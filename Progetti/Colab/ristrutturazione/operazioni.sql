-- Operazioni della classe Abbonamento
create or replace function fineAbbonamento(this integer)
returns date as $$
begin
    return (
        SELECT ab.inizio + ta.durataGiorni
        FROM Abbonamento ab, TipologiaAbbonamento ta
        WHERE ab.id = this and ta.id = ab.ta
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

-- Operazioni della classe Azienda
create or replace function utentiGestiti(this integer, i date, f date)
returns setof IndEmail as $$
begin
    returns query (
        select distinct u.email
        from Utente u, Abbonamento ab, ab_ut au
        where ab.acquirente = this and au.abbonamento = ab.id and au.utente = u.email and ab.inizio >= i and ab.inizio <= f
    )
end;
$$ language plpgsql;


-- Operazioni della classe Utilizzo
    TODO
    prezzo(): Denaro
        precondizioni:
            nessuna

        postcondizioni:
            non modifica lo spazio estensionale
            ALL i,f,q,a,u,so,p inizio(this,i) and fine(this,f) and quantitaUtilizzata(this,q) and inCorso(a,i,True) and ut_uti(this,u) and ab_ut(a,u) and so_uti(so,this) and prezzo(so,p)
                -> EXISTS ta ta_so(ta,so) and ab_ta(ta,a)
                        -> ALL sco,ur sconto(ta,so,sco) and UtilizziRimasti(ta,so,adesso,ur)
                           and (ur = 0 -> result = p*q*sco
                                and
                                ur > 0 -> (
                                    q-ur <= 0 -> result = 0
                                    and
                                    q-ur > 0 -> result = p*(q-ur)
                                )
                           )
                    and 
                NOT EXISTS ta ta_so(ta,so) and ab_ta(ta,a)
                        -> result = p*q

create or replace function prezzoUtilizzo(this integer)
returns Denaro as $$
begin

end;
$$ language plpgsql;


--Operazioni della classe ta_so
create or replace function utilizziRimasti(tab integer, ser integer, t timestamp)
returns InteroGEZ as $$
declare
tot integer = null;
ug InteroGEZ = 0;
begin
    SELECT sum(u.quantitaUtilizzata)
    INTO tot
    FROM ta_so ts, utilizzo u
    WHERE ts.servizio = ser and ts.tab = tab and u.servizio = ts.servizio and (extract(month from t) = extract(month from u.inizio)) and (extract(year from t) = extract(year from u.inizio))

    SELECT ts.utilizzoGratis
    INTO ug
    FROM ta_so ts
    WHERE ts.servizio = ser and ts.tab = tab

    tot = tot-ug
    if tot >= 0 then return tot; end if;
    return 0;
end;
$$ language plpgsql;