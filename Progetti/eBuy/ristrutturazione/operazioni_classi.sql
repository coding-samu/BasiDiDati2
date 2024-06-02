-- operazioni classe prezzoOfferto

create or replace function prezzoOfferto(this Bid)
returns Denaro as
declare
    n_bid_precedenti InteroGEZ = 0;
$$
begin

n_bid_precedenti := (
    select count(*)
    from bid as b
    where this.
)

end;
$$
language plpgsql;

-- operazioni classe post

create or replace function prezzoVenditaAsta(this PostAsta)
returns Denaro

create or replace function prezzoVendita(this Post)
returns Denaro as
declare
    comprasubito PostCS = null;
    asta PostAsta = null
$$
begin

    select *
    into comprasubito
    from PostCS as cs
    where cs.post = this.id

    if comprasubito <> null then return this.prezzo_iniziale;
    end if;

    select *
    into asta
    from PostAsta as a
    where a.post = this.id;

    return prezzoVenditaAsta(a);
end;
$$
language plpgsql;