-- Operazioni della classe Abbonamento
create or replace function fineAbbonamento(this integer)
returns date as $$
begin
    return (
        SELECT ab.inizio + ta.durataGiorni
        FROM Abbonamento ab, TipologiaAbbonamento ta
        WHERE ab.id = this and ta.id = ab.tab
    );
end;
$$ language plpgsql;

create or replace function inCorsoAbbonamento(this integer, t date)
returns boolean as $$
begin
    return (
        select (ab.inizio <= t and t <= fineAbbonamento(this))
        from Abbonamento ab
        where ab.id = this
    );
end;
$$ language plpgsql;

create or replace function utilizziRimasti(this integer, s integer, t timestamp)
returns InteroGEZ as $$
declare
    tot InteroGEZ = null;
    ug InteroGEZ = null;
begin
    select sum(uti.quantitaUtilizzata)
    into tot
    from Utilizzo uti, ab_ut au
    where au.abbonamento = this and uti.utente = au.utente and uti.servizio = s and uti.inizio < t
        and extract(month from uti.inizio) = extract(month from t) and extract(year from uti.inizio) = extract(year from t);

    select ts.utilizzoGratis
    into ug
    from Abbonamento ab, ta_so ts
    where ab.id = this and ts.servizio = s and ts.tab = ab.tab;
    if ug is null then return 0; end if;
    if tot is null then return ug; end if;
    if ug-tot >= 0 then return (ug-tot); end if;
    return 0;
end;
$$ language plpgsql;

-- Operazioni della classe Azienda
create or replace function utentiGestiti(this integer, i date, f date)
returns table(utente IndEmail) as $$
begin
    return query (
        select distinct u.email
        from Utente u, Abbonamento ab, ab_ut au
        where ab.acquirente = this and au.abbonamento = ab.id and au.utente = u.email and ab.inizio >= i and ab.inizio <= f
    );
end;
$$ language plpgsql;


-- Operazioni della classe Utilizzo
create or replace function prezzoUtilizzo(this integer)
returns Denaro as $$
declare
    sco Perc = 0;
    ur InteroGEZ = 0;
    q InteroGEZ = 0;
    p Denaro = 0;
begin
    select uti.quantitaUtilizzata,ts.sconto,utilizziRimasti(ab.id,ts.servizio,uti.inizio),s.prezzo
    into q,sco,ur,p
    from utilizzo uti join ab_ut au
        on (uti.utente = au.utente) join Abbonamento ab
        on (au.abbonamento = ab.id) join servizioOfferto s
        on (s.id = uti.servizio) left outer join ta_so ts
        on (ts.servizio = s.id and ts.tab = ab.tab)
    where uti.id = this;
    if sco is null then return p*q; end if;
    if q-ur >= 0 then return p*(q-ur) - p*(q-ur)*sco; end if;
    return 0;

end;
$$ language plpgsql;
