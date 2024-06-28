-- Usecase paeseConPiuAcquisti
create or replace function paeseConPiuAcquisti(i date, f date)
returns table(nazione StringaS) as $$
begin
    if f < i then raise exception 'Error 001 - fine minore di inizio'; end if;
	return query (with ins as(
	    select n.nome as n,sum(ao.quantita) as t
	    from Nazione n, acq_of ao, citta c, Acquisto acq
	    where n.nome = c.nazione and c.id = acq.citta and i <= acq.istante and acq.istante <= f and acq.id = ao.acquisto
		group by n.nome
	), massimo as(
	    select max(INS.t) as mas
	    from INS)
    select INS.n
    from INS,massimo
	where INS.t = massimo.mas
    );
end;
$$ language plpgsql;

-- Usecase ricerca
create or replace function ricerca(c StringaS, T StringaS[], n StringaS)
returns table(articolo Identificativo, prezzo Denaro) as $$
begin
    return query (
        with TAB as (
            select offe.articolo as a, offe.id as o,prezzoOfferta(offe.id, n, 1) as p
            from Offerta offe, Articolo art
            where exists (
                        select *
                        from Spedizione s
                        where s.offerta = offe.id and s.nazione = n
                    ) and art.codId = offe.articolo and art.categoria = c and exists (
                        select *
                        from art_tag ata
                        where ata.articolo = art.codId and ata.tag = any(T)
                    )
        )
        select TAB.a,TAB.p
        from TAB
        where not exists (
            select *
            from TAB as tab2
            where TAB.a = tab2.a and tab.o <> tab2.o and tab2.p < tab.p
        )
    );
end;
$$ language plpgsql;

-- Usecase articoliModa
create or replace function articoliModa()
returns table(articolo Identificativo) as $$
begin
    return query (
        select a.codId
        from Articolo a
        where mediaGiornaliera(a.codid,current_date-90,current_date-31) < mediaGiornaliera(a.codid,current_date-30,current_date)
    );
end;
$$ language plpgsql;