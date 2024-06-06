create or replace function copertiOccupati(this integer, i timestamptz)
returns InteroGEZ as
$$
declare risultato InteroGEZ = null;
begin
    
    select sum(p.coperti)
    into risultato
    from GiornoPromozione g,Prenotazione p
    where g.id = this and p.giornoProm = this and p.statoPren = 'Accettata' and (not p.annullata) and p.data <= i;
    if risultato is null then return 0; end if;
    return risultato;

end;
$$
language plpgsql;


create or replace function promPerDate(this integer, i timestamptz, f timestamptz)
returns setof GiornoPromozione as $$
    begin
        if i > f then raise exception 'Error 001 - data di inzio maggiore di quella di fine'; end if;
        return query (
            select gp.*
            from GiornoPromozione gp
            where gp.promozione = this and i <= gp.giorno + gp.inizio and gp.giorno + gp.fine <= f
        );
    end;
$$ language plpgsql;