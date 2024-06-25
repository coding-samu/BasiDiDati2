-- Operazioni classe FondoGestito
create or replace function percentualeAzionari(this integer)
returns Perc as $$
begin
    return (
        select fg.titoliAzionari::real / (fg.titoliAzionari::real + fg.titoliObbligazionari::real + fg.titoliDiStato::real)
        from FondoGestito fg
        where fg.id = this
    );
end;
$$ language plpgsql;
-- Le operazioni percentualeObbligazionari e percentualeDiStato sono simili

-- Operazioni classe StrumentoFinanziario
create or replace function valoreSF(this integer, t timestamp)
returns Denaro as $$
begin
    if not exists (
        select *
        from rilevazione r
        where r.sf = this and r.istante <= t
    ) then raise exception 'Error 001 - non esiste rilevazione'; end if;

    return (
        with ril as (
            select r.istante, r.valore
            from Rilevazione r
            where r.sf = this
        ),
        massimo as (
            select max(r.istante)
            from ril r
        )
        select r.valore
        from ril r
        where r.istante = massimo.max
    );
end;
$$ language plpgsql;

-- Operazioni classe Investimento

create or replace function importoInvestimento(this integer)
returns Denaro as $$
begin
    return (
        SELECT i.quantita * valoreSF(i.sf,i.istante)
        FROM investimento i
        WHERE i.id = this
    );
end;
$$ language plpgsql;

create or replace function valoreInvestimento(this integer, t timestamp)
returns Denaro as $$
begin
    if exists (
        SELECT *
        FROM investimento i
        WHERE i.id = this and i.istante > t
    ) then raise exception 'Error 002 - la data è precedente rispetto la data di inizio di investimento'; end if;
    return (
        with dis as (
            SELECT sum(d.quantita)
            FROM disinvestimento d
            WHERE d.investimento = this
        )
        SELECT (i.quantita - dis) * valoreSF(i.sf,t)
        FROM investimento i
        WHERE i.id = this
    );
end;
$$ language plpgsql;

