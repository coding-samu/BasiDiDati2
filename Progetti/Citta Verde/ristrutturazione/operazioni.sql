-- Operazioni della classe Squadra

create or replace function numOperatori(cs CodSquadra, d timestamp) returns integer as $$
    begin
        if exists (
            select *
            from squadra sq
            where sq.codice = cs and (d <= sq.inizio or (coalesce(sq.fine,'infinity'::timestamp) <= d))
        ) then raise exception 'Error O_001 - Data inserita non valida'; end if;
    
    return (
        select count(p.id)
        from partecipa p
        where p.squadra = cs and p.inizio <= d and (d <= coalesce(p.fine,'infinity'::timestamp))
    );
    end;
$$ language plpgsql;

create or replace function attrezzaturaUsabile(cs CodSquadra, d timestamp) 
returns table (nome StringaS)
as $$
    begin
        if exists (
            select *
            from squadra sq
            where sq.codice = cs and (d <= sq.inizio or (coalesce(sq.fine,'infinity'::timestamp) <= d))
        ) then raise exception 'Error O_001 - Data inserita non valida'; end if;

        return query(
            select distinct pu.attrezzatura
            from PuoUtilizzare pu, partecipa p
            where p.squadra = cs and p.operatore = pu.operatore and pu.inizio <= d and (d <= coalesce(pu.fine,'infinity'::timestamp)) and p.inizio <= d and (d <= coalesce(p.fine,'infinity'::timestamp))
        );
    end;
$$ language plpgsql;

-- Operazioni della classe Intervento

create or replace function attrezzaturaRichiesta(this integer)
returns table (nome StringaS)
as $$
    begin
        return query(
            select distinct atta.attrezzatura
            from attr_ta atta, int_ta ia
            where atta.tipologiaAttivita = ia.tipologiaAttivita and ia.intervento = this
        );
    end;
$$ language plpgsql;