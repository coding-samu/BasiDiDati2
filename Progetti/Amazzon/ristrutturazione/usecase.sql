/*
paeseConPiuAcquisti(i: Data, f: Data): Nazione [0..*]

    precondizioni: i <= f

    postcondizioni:

        N = {(n,a,q) | exists c,is acq_cit(a,c) and cit_naz(c,n) and istante(a,is) and i <= is <= f}

        T = {(t,n) | Nazione(n) and (t = sum_{(n1,a,q) in N} and n1 = n)}

        result = arg_max_{(t,n) in T}(t)
*/
-- Usecase paeseConPiuAcquisti
create or replace function paeseConPiuAcquisti(i date, f date)
returns table(nazione StringS) as $$
begin
    TODO
end;
$$ language plpgsql;

/*
ricerca(c: Categoria, T: tag [0..*],n:Nazione): (a: Articolo, p:Denaro) [0..*]

    precondizioni:
        nessuna

    postcondizioni:
        A = {(a,o,p) | art_cat(a,c) and exists t1 in T art_tag(a,t1) and art_of(a,o) and spedizione(n,o) and exists p1,p2 prezzo(o,p1) and prezzo(n,o,p2) and p = p1+p2}

        result = {(a,p) | EXISTS (a1,o1,p1) in A and NOT EXISTS (a2,o2,p2) in A and a1 = a2 = a and p2 < p1 and p = p1}
*/
-- Usecase ricerca
create or replace function ricerca(c StringaS, T StringaS[], n StringaS)
returns table(articolo Identificativo, prezzo Denaro) as $$
begin
    TODO
end;
$$ language plpgsql;

/*
articoliModa(): Articolo [0..*]

    precondizioni: nessuna

    postcondizioni:
        result = {a | exists r1,r2 mediaGiornaliera{Articolo,Data,Data}(a,dataOggi-30,dataOggi,r2) and
                    mediaGiornaliera{Articolo,Data,Data}(a,dataOggi-90,dataOggi-31,r1) and r1 < r2}
*/
-- Usecase articoliModa
create or replace function articoliModa()
returns table(articolo Identificativo) as $$
    TODO
$$ language plpgsql;