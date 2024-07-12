-- Operazioni della classe Squadra

create or replace function numOperatori(codice CodSquadra, d timestamp) returns integer as $$
    begin
        if exists (
            select *
            from squadra sq
            where sq.codice = codice and (d <= sq.inizio or (coalesce(sq.fine,'infinity'::timestamp) <= d))
        ) then raise exception 'Error O_001 - Data inserita non valida'; end if;
    
    return (
        select count(p.id)
        from partecipa p
        where p.squadra = codice and p.inizio <= d and (d <= coalesce(p.fine,'infinity'::timestamp))
    );
    end;
$$ language plpgsql;

    TODO
    attrezzaturaUsabile(d DataOra): Attrezzatura [0..*]
        precondizioni:
            (ALL i inizio(this,i) -> i <= d) and (ALL f fine(this,f) -> d <= f)
        postcondizioni:
            Sia A = {a | EXISTS o, p, pu par_sq(p,this) and op_par(o,p) and op_pu(o,pu) and attr_pu(a,pu) and (ALL i inizio(p,i) -> i <= d) and (ALL f fine(p,f) -> d <= f) and (ALL i inizio(pu,i) -> i <= d) and (ALL f fine(pu,f) -> d <= f)}
            result = A

-- Operazioni della classe Intervento

    TODO
    attrezzaturaRichiesta(): Attrezzatura [0..*]
        precondizioni:
            nessuna
        postcondizioni:
            Sia A = {a | EXISTS ta int_ta(this,ta) and attr_ta(a,ta)}
            result = A