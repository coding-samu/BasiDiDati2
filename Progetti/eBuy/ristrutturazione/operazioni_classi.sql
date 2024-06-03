-- operazioni classe prezzoOfferto

create or replace function prezzoOfferto(this Bid)
returns Denaro as
$$
declare
    n_bid_precedenti InteroGEZ = 0;
    prezzo_iniziale Denaro = null;
    rialzo Denaro = null;
begin

n_bid_precedenti := (
    select count(*)
    from bid as b
    where this.post = b.post and this.istante > b.istante
);

select p.prezzo_iniziale,pa.rialzo
into prezzo_iniziale,rialzo
from postAsta as pa,post as p
where pa.post = p.id and this.post = pa.post;


return (n_bid_precedenti + 1) * rialzo + prezzo_iniziale;

end;
$$
language plpgsql;

-- operazioni classe post

create or replace function prezzoVenditaAsta(this PostAsta)
returns Denaro as
$$
declare
    max_offerto Denaro = null;

begin
    select max(prezzoOfferto(b))
    into max_offerto
    from bid b
    where b.post = this.post;

    if max_offerto = null then return (
        select p.prezzo_iniziale
        from Post p
        where p.id = this.post
    );
    end if;
    return max_offerto;
end;
$$
language plpgsql;

create or replace function prezzoVendita(this Post)
returns Denaro as
$$
declare
    comprasubito PostCS = null;
    asta PostAsta = null;
begin

    select cs.*
    into comprasubito
    from PostCS as cs
    where cs.post = this.id;

    if comprasubito is not null then return this.prezzo_iniziale;
    end if;

    select *
    into asta
    from PostAsta as a
    where a.post = this.id;

    return prezzoVenditaAsta(asta);
end;
$$
language plpgsql;


-- Operazioni classe PostAsta

create or replace function aggiudicanteAsta(this PostAsta)
returns UtentePrivato
as $$
declare
    prezzo Denaro = prezzoVenditaAsta(this);
    utente UtentePrivato = null;
begin
    if current_timestamp < this.istante_scad then raise exception 'Error 001 - Asta non terminata'; end if;
    
    select u.*
    into utente
    from Bid as b, UtentePrivato as u
    where b.post = this.post and prezzoOfferto(b) = prezzo and b.bidder = u.utente
    limit 1;

    return utente;
end;
$$
language plpgsql;


-- Operazioni della classe PostCS

create or replace function aggiudicanteCS(this PostCS)
returns UtentePrivato
as $$
    declare
    utente UtentePrivato = null;
    begin
        if this.acquirente is null then raise exception 'Error 002 - Compro subito non comprato'; end if;

        select u.*
        into utente
        from UtentePrivato as u
        where u.utente = this.acquirente;

        return utente;

    end;
$$
language plpgsql;


-- Operazioni della classe Post

create or replace function aggiudicante(this Post)
returns UtentePrivato
as $$
    declare 
        postcos PostCS = null;
        postast PostAsta = null;
    begin
        select p.*
        into postcos
        from PostCS as p
        where p.post = this.id;

        if postcos is not null then return aggiudicanteCS(postcos); end if;

        select p.*
        into postast
        from PostAsta as p
        where p.post = this.id;

        -- aggiunto per colpa di chatgpt

        if postast is null then return null; end if;

        return aggiudicanteAsta(postast);
    end;
$$
language plpgsql;