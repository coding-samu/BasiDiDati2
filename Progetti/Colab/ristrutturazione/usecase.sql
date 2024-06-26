-- Usecase mediaGiornaliera
create or replace function mediaGiornaliera(I Intervallo[])
returns table(il Intervallo,m RealeGEZ) as $$
begin
    if exists (
        select
        from unnest(I) as x(ini,f), unnest(I) as y(ini,f)
        where x <> y and ((x.ini,x.f) overlaps (y.ini,y.f))
    ) then raise exception 'Error 001 - ci sono intervalli sovrapposti'; end if;

    return query (
        with acc as (
            select a.id, x
            from unnest(I) as x(ini,f), Accesso a
            where a.entrata::time >= x.ini and a.entrata::time <= x.f
            and date_part('month',now()::timestamp) = date_part('month',a.entrata)
            and date_part('year',now()::timestamp) = date_part('year',a.entrata)
        )
        select acc.x as il, (count(acc.id)/date_part('day',now()::timestamp))::RealeGEZ as m
        from acc
        group by acc.x
    );
end;
$$ language plpgsql;

-- Usecase fattura
create or replace function fattura(az integer, i date, f date)
returns Denaro as $$
begin
    return (
        select sum(prezzoUtilizzo(uti.id))
        from utentiGestiti(az,i,f) as ug, Utilizzo uti
        where uti.utente = ug.utente
    );
end;
$$ language plpgsql;

-- Usecase serviziModa
create or replace function serviziModa(i date, f date, k interoGZ)
returns setof integer as $$
begin
    return query (
        select so.id
        from Utilizzo uti, ServizioOfferto so
        where uti.servizio = so.id and i <= uti.inizio and uti.inizio <= f
		group by so.id
        order by sum(uti.quantitaUtilizzata) desc
        limit k
    );
end;
$$ language plpgsql;

-- Usecase clientiInutili
create or replace function clientiInutili(i date, f date)
returns setof IndEmail as $$
begin
    return query(
        select u.email
        from Utente u, Abbonamento ab, ab_ut au
        where u.email = au.utente and au.abbonamento = ab.id and ((i,f) overlaps (ab.inizio,fineAbbonamento(ab.id)))

        except

        select u.email
        from Utente u, Accesso ac
        where ac.utente = u.email and date(ac.entrata) >= i and date(ac.uscita) <= f
    );
end;
$$ language plpgsql;

