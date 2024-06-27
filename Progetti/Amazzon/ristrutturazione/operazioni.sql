-- Operazioni classe Acquisto

/*
valoreBuoni(): Denaro

    precondizioni: nessuna

    postcondizioni:

        B = {(b,s) | exists tbr acq_br(this,b) and br_tbr(b,tbr) and saldo(tbr,s)}

        result = sum_{(b,s) in B} s
*/

create or replace function valoreBuoni(this integer)
returns Denaro as $$
begin
    TODO
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

/*
prezzo(): Denaro

    precondizioni: nessuna

    postcondizioni:

        ALL psb,vb pressoSenzaBuoni_{Acquisto}(this,psb) and valoreBuoni_{Acquisto}(this,vb) -> result = psb-vb
*/

create or replace function prezzo(this integer)
returns Denaro as $$
begin
    TODO
end;
$$ language plpgsql;


-- Operazioni della classe BuonoRegalo

/*
fine(): DataOra

    precondizioni: nessuna

    postcondizioni:

        ALL i,tbr,d br_tbr(this,tbr) and inizio(this,i) and durataGiorni(tbr,d) -> result = i+d
*/

create or replace function fine(this integer)
returns timestamp as $$
begin
    TODO
end;
$$ language plpgsql;


-- Operazioni della classe Articolo

/*
mediaGiornaliera(i: Data, f: Data): RealeGEZ

    precondizioni:
        i <= f

    postcondizioni:
        A = {(a,o,q) | exists is art_of(this,o) and acq_of(a,o) and quantita(a,o,q) and istante(a,is) and i <= is <= f}

        result = (sum_{(a,o,q) in A} q)/(f-i+1)
*/

create or replace function mediaGiornaliera(this Identificativo)
returns RealeGEZ as $$
    TODO
$$ language plpgsql;