-- usecase Calcolo delle statistiche



create or replace function calcoloStatisticheEsotiche(inizio date, fine date)
returns real
as $$
begin
    with etaClienti as (
        select extract(years,age(u.dataN)) as eta
        from utente as u, prenotazione as p, crociera as c, itinerario as i, 
        where date(p.istante_prenotazione) >= inizio and date(p.istante_prenotazione) <= fine and
        p.utente = u.id and p.crociera = c.codice and c.itinerario = i.nome and esisteEsotica(i)
    )
    return select avg(etaClienti.eta) from etaClienti
end;
$$
language plpgsql;

create or replace function gettonata(this Destinazione,inizio date, fine date)
returns boolean
as $$
declare
    lunamiele InteroGEZ = 0;
    famiglie InteroGEZ = 0;
begin
    select distinct count(ldm.crociera)
    into lunamiele
    from itinerario as i,tappa as t,crociera as c,CrocLunaDiMiele as ldm
    where (i.arrivo = this.id or i.partenza = this.id or (t.destinazione = this.id and t.itinerario = i.nome))
        and c.itinerario = i.nome
        and ldm.crociera = c.codice;

    select distinct count(cpf.crociera)
    into famiglie
    from itinerario as i,tappa as t,crociera as c,CrocPerFamiglia as cpf
    where (i.arrivo = this.id or i.partenza = this.id or (t.destinazione = this.id and t.itinerario = i.nome))
        and c.itinerario = i.nome
        and cpf.crociera = c.codice;
    return lunamiele >= 10 or famiglie >= 15;
end;
$$ language plpgsql;

create or replace function percentualeGettonate(inizio date, fine date)
return real
as $$
declare 
    tot InteroGEZ = 0;
    gettonate InteroGEZ = 0;
begin
    select count(*)
    into tot
    from destinazione;

    select distinct count(d.id)
    from destinazione as d
    where gettonata(d,inizio,fine);

    return gettonate/tot;
end;
$$
language plpgsql;