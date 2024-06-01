-- implementazione operazioni Crociera

create or replace function data_fine_crociera(this Crociera)
returns TIMESTAMP
as $$
declare
    istante_arrivo DeltaOra = null;
    ora_partenza time = null;
    data_inizio date = this.data_inizio;
    giorni integer = null;
    ora_arrivo time = null;
begin
    -- Ottenere istante_arrivo e ora_partenza dall'itinerario
    select (i.istante_arrivo).giorno,(i.istante_arrivo).ora
    into giorni,ora_arrivo
    from itinerario as i
    where this.itinerario = i.nome;

    -- Restituire la data e l'ora di fine crociera
    return (this.data_inizio + giorni) + ora_arrivo;
end;
$$
language plpgsql;

select c.codice,c.data_inizio,i.istante_arrivo,data_fine_crociera(c)
from crociera c, itinerario i
where c.itinerario = i.nome;

create or replace function prenotati_crociera(this Crociera)
returns InteroGEZ
as $$
begin 

	return (
    select sum(p.num_posti_prenotati)
    from Prenotazione as p
    where p.crociera = this.codice and p.tipo = 'Accettata'
	);
end;
$$ language plpgsql;

select p.num_posti_prenotati,p.crociera,p.tipo,prenotati_crociera(c)
from prenotazione as p,crociera c
where p.crociera = c.codice;

-- implementazione operazioni classe tappa

create or replace function ordine(this Tappa)
returns InteroGZ
as $$
begin
    return (
        select count(*)
        from Tappa as t
        where t.itinerario = this.itinerario and minoreDeltaOra(t.arrivo,this.arrivo)
    ) + 1;
end;
$$ language plpgsql;

-- implementazione operazioni Croc_Luna_Di_Miele

create or replace function tipoCrocLdM(this CrocLunaDiMiele)
returns TipoCrocieraLunaDiMiele
as $$
declare
romantiche InteroGEZ = 0;
divertenti InteroGEZ = 0;
begin
    select distinct count(d.id)
    into romantiche
    from crociera as c, itinerario as i, destinazione as d, tappa as t
    where this.crociera = c.codice and c.itinerario = i.nome and 
    ((t.itinerario = i.nome and t.destinazione = d.id) or (i.arrivo = d.id) or (i.partenza = d.id))
    and ((d.tipo = 'Romantica') or d.tipo = 'RomanticaDivertente');

    select distinct count(d.id)
    into divertenti
    from crociera as c, itinerario as i, destinazione as d, tappa as t
    where this.crociera = c.codice and c.itinerario = i.nome and 
    ((t.itinerario = i.nome and t.destinazione = d.id) or (i.arrivo = d.id) or (i.partenza = d.id))
    and ((d.tipo = 'Divertente') or d.tipo = 'RomanticaDivertente');

    if (romantiche >= divertenti)
    then return 'Tradizionale';
    else return 'Alternativa';
    end if;
end;
$$
language plpgsql;

-- Operazioni della classe Itinerario

create or replace function esisteEsotica(this Itinerario)
returns boolean
as $$
    declare
    numEsotiche InteroGEZ = 0;
    select count(d.id)
    into numEsotiche
    from crociera as c, itinerario as i, destinazione as d, tappa as t, porto as p, citta as cit, nazione as n
    where this.crociera = c.codice and c.itinerario = i.nome and 
    ((t.itinerario = i.nome and t.destinazione = d.id) or (i.arrivo = d.id) or (i.partenza = d.id))
    and d.porto = p.id and p.citta = cit.id and cit.nazione = n.nome and n.continente != 'Europa';
    return numEsotiche != 0;
$$
language plpgsql