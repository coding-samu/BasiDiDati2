create or replace function mediaAffluenzaPerPromozione(r PartitaIva,utente Email,i timestamptz, f timestamptz)
returns table(promozione integer,media RealeGEZ)
as $$
begin
    if i > f then raise exception 'Error 002 - inizio maggiore di fine'; end if;
    if not exists(
        select *
        from Ristorante ris
        where ris.ristoratore = utente
    ) then raise exception 'Error 003 - utente non corrisponde al ristorante'; end if;

    return query
        select p.id,avg(copertiOccupati(g.id,f))::RealeGEZ
        from Promozione p,promPerDate(p.id,i,f) g
        where p.ristorante = r and g.promozione = p.id
        group by p.id;
end;
$$
language plpgsql;

create or replace function ricerca(x integer, C StringaS[], s Sconto, d date)
returns setof Ristorante as $$
begin
    return query
        select r.*
        from ristorante r,cuc_rist cr,promozione p, GiornoPromozione gp
        where r.citta = x and cr.ristorante = r.piva and exists (
            select *
            from unnest(C) k
            where k.k = cr.tipoCucina 
        ) and p.ristorante = r.piva and gp.promozione = p.id and p.percentuale >= s and gp.giorno = d;
end;
$$ language plpgsql;