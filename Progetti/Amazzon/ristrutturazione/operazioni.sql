-- Operazioni classe Acquisto

create or replace function valoreBuoni(this integer)
returns Denaro as $$
begin
    return (SELECT sum(tbr.saldo)
    FROM Acquisto ac, BuonoRegalo br, TipologiaBuonoRegalo tbr
    WHERE ac.id = this and ac.id = br.acquisto and br.tipo = tbr.nome);
end;
$$ language plpgsql;

create or replace function prezzoSenzaBuoni(this integer)
returns Denaro as $$
begin
    return (
        select sum(prezzoOfferta(ao.offerta, c.nazione, ao.quantita))
        from acq_of ao, Acquisto acq, Citta c, Nazione n
        where ao.acquisto = this and acq.id = this and acq.citta = c.id
    );
end;
$$ language plpgsql;

create or replace function prezzo(this integer)
returns Denaro as $$
begin
    return prezzosenzaBuoni(this) - valoreBuoni(this);
end;
$$ language plpgsql;


-- Operazioni della classe BuonoRegalo

create or replace function fine(this integer)
returns timestamp as $$
declare
    inizio timestamp = null;
    durata InteroGZ = null;
begin
    select br.inizio, tbr.durataGiorni
    into inizio, durata
    from BuonoRegalo br, TipologiaBuonoRegalo tbr
    where br.id = this and br.tipo = tbr.nome;

    return inizio + make_interval(days => durata);
end;
$$ language plpgsql;


-- Operazioni della classe Articolo

create or replace function mediaGiornaliera(this Identificativo, i Date, f Date)
returns RealeGEZ as $$
DECLARE
tot RealeGez = null;
begin
    if f < i then raise exception 'Error 001 - Inizio maggiore di fine'; end if;
    select sum(ao.quantita)
    into tot
    from Acquisto acq, Offerta o, acq_of ao
    where o.articolo = this and ao.offerta = o.id and ao.acquisto = acq.id and i <= acq.istante and acq.istante <= f;
    return tot/(f-i+1);
end;
$$ language plpgsql;


-- Operazioni della classe Offerta

create or replace function prezzoOfferta(this integer, n StringaS, q InteroGZ)
returns Denaro as $$
declare
    rid integer = null;
begin
    if not exists (
        select *
        from Spedizione s
        where s.offerta = this and s.nazione = n
    ) then raise exception 'Error 002 - Non sono presenti tariffe di spedizione nella nazione specificata'; end if;

    select r.id
    into rid
    from Riduzione r, Spedizione s
    where s.nazione = n and s.offerta = this and r.spedizione = s.id and ((q,q) overlaps (r.inizio,coalesce(r.fine,'infinity'::integer)));
    -- se esiste Riduzione, allora ritorna q*prezzoRidotto + q*prezzoArticolo
    if rid is not null then return (
        select (r.prezzo + o.prezzo)*q
        from Riduzione r, Offerta o
        where o.id = this and r.id = rid
    ); end if;
    -- se non esiste Riduzione, allora ritorna q*prezzoBase + q*prezzoArticolo
    return (
        select (s.prezzo + o.prezzo)*q
        from Spedizione s, Offerta o
        where s.nazione = n and s.offerta = this and o.id = this
    );
end;
$$ language plpgsql;