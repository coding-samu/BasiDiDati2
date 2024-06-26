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

            U = {(u,n) | EXISTS m1,m2,a1,a2,i,ut so_uti(s,u) and inizio(u,i) and mese(i,m1) anno(i,a1) and mese(t,m2) and anno(t,a2) and a1 = a2 and m1 = m2 and i <= t and quantitaUtilizzata(u,n) and ab_ut(this,ut) and ut_uti(ut,u)}

create or replace function utilizziRimasti(this integer, s integer, t timestamp)
returns InteroGEZ as $$
declare
    tot InteroGEZ = null;
    ug InteroGEZ = null;
begin
    select count(uti.id)
    into tot
    from Utilizzo uti, Utente ut, ab_ut au
    where au.utente = ut.email and au.abbonamento = this and uti.utente = ut.email and extract(month from uti.inizio) = extract(month from t) and extract(year from uti.inizio) = extract(year from t);

    select ts.utilizzoGratis
    into ug
    from Abbonamento ab, ta_so ts
    where ab.id = this and ts.servizio = s and ts.tab = ab.tab;
    if ug is null then return 0; end if;
    if ug-tot >= 0 then return (ug-tot); end if;
    return 0;
end;
$$ language plpgsql;

-- Operazioni della classe Azienda
create or replace function utentiGestiti(this integer, i date, f date)
returns setof IndEmail as $$
begin
    return query (
        select distinct u.email
        from Utente u, Abbonamento ab, ab_ut au
        where ab.acquirente = this and au.abbonamento = ab.id and au.utente = u.email and ab.inizio >= i and ab.inizio <= f
    );
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
                        -> ALL sco,ur sconto(ta,so,sco) and UtilizziRimasti(a,adesso,ur)
                           and (ur = 0 -> result = p*q - p*q*sco
                                and
                                ur > 0 -> (
                                    q-ur <= 0 -> result = 0
                                    and
                                    q-ur > 0 -> result = p*(q-ur) - p*(q-ur)*sco
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
