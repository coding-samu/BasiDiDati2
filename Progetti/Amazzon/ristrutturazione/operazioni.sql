-- Operazioni classe Acquisto

create or replace function valoreBuoni(this integer)
returns Denaro as $$
begin
    return (SELECT sum(tbr.saldo)
    FROM Acquisto ac, BuonoRegalo br, TipologiaBuonoRegalo tbr
    WHERE ac.id = this and ac.id = br.acquisto and br.tipo = tbr.nome);
end;
$$ language plpgsql;

/*
prezzoSenzaBuoni(): Denaro

    precondizioni: nessuna

    postcondizioni:

        O = {(o,q,po,ps) | exists c,n acq_of(this,o) and quantita(this,o,q) and prezzo(o,po) and acq_cit(this,c) and cit_naz(c,n) and (
            q = 1 -> (
                prezzo(n,o,ps)
            )
            and
            q != 1 -> (
                not exists r,i rid_spe(r,n,o) and inizio(r,i) and i <= q -> (
                    prezzo(n,o,ps)
                )
                and
                exists r,i rid_spe(r,n,o) and inizio(r,i) and i <= q -> (
                    ALL r1,i1 rid_spe(r1,o,n) and (ALL f1 fine(r1,f1) -> q <= f1) and i1 <= q -> prezzo(r1,ps)
                )
            )
        )}

        result = sum_{(o,q,po,ps) in O} q*po + q*ps
*/

create or replace function prezzoSenzaBuoni(this integer)
returns Denaro as $$
begin
    TODO
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