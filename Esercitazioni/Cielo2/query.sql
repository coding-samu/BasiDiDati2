-- Esercizio 1
select ae.codice, ae.nome, count(distinct co.nome) as num_compagnie
from aeroporto as ae, compagnia as co, arrpart as ap
where (ae.codice = ap.partenza or ae.codice = ap.arrivo) and ap.comp = co.nome
group by ae.codice;

-- Esercizio 2
select count((v.codice, v.comp)) as num_voli
from volo as v, arrpart as ap
where v.codice = ap.codice and v.comp = ap.comp and ap.partenza = 'HTR' and durataMinuti >= 100;

-- Esercizio 3
select la.nazione, count(distinct ae.codice) as num_aerop
from luogoaeroporto as la, compagnia as co, aeroporto as ae, arrpart as ap
where co.nome = 'Apitalia' 
	and la.aeroporto = ae.codice 
	and ap.comp = co.nome 
	and (ap.arrivo = ae.codice or ap.partenza = ae.codice)
group by la.nazione;

-- Esercizio 4
select avg(v.durataMinuti) as media, min(v.durataMinuti) as minimo, max(v.durataMinuti) as massimo
from compagnia as co, volo as v
where co.nome = 'MagicFly' and v.comp = co.nome;

-- Esercizio 5
select ae.codice, ae.nome, min(co.annoFondaz) as anno
from aeroporto as ae, compagnia as co, arrpart as ap
where (ae.codice = ap.partenza or ae.codice = ap.arrivo) and ap.comp = co.nome
group by ae.codice;

-- Esercizio 6
select la2.nazione as naz, count(distinct(la.nazione)) as raggiungibili
from luogoaeroporto as la, volo as v, arrpart as ap, luogoaeroporto as la2
where v.codice = ap.codice
	and v.comp = ap.comp
	and la.aeroporto = ap.arrivo
	and la2.aeroporto = ap.partenza
	and la.nazione != la2.nazione
group by la2.nazione;

-- Esercizio 7
select ae.codice, ae.nome, avg(v.durataMinuti) as media_durata
from aeroporto as ae, arrpart as ap, volo as v
where ae.codice = ap.partenza
	and v.codice = ap.codice and v.comp = ap.comp
group by ae.codice;

-- Esercizio 8
select v.comp as nome, sum(v.durataMinuti) as durata_tot
from volo as v, compagnia as co
where v.comp = co.nome and co.annoFondaz >= 1950
group by v.comp;

-- Esercizio 9
select  codice, nome 
	from (select ae.codice, ae.nome, count(distinct co.nome) as num_compagnie
			from aeroporto as ae, compagnia as co, arrpart as ap
			where (ae.codice = ap.partenza or ae.codice = ap.arrivo) and ap.comp = co.nome
			group by ae.codice) as ta 
	where num_compagnie = 2;

-- Esercizio 10
select citta from (select la.citta, count(distinct la.aeroporto) as conteggio from luogoaeroporto as la group by la.citta) as ta where conteggio >= 2; 

-- Esercizio 11
select compagnia from (select ap.comp as compagnia, avg(v.durataMinuti) as media_durata
from arrpart as ap, volo as v
where v.codice = ap.codice and v.comp = ap.comp
group by ap.comp) as ta where media_durata > 360;

-- Esercizio 12
select ta1.compagnia
	from
		(select v.comp as compagnia, count(v) as conteggio 
		from volo as v
		where v.durataMinuti > 100
		group by v.comp) as ta1,
		(select v.comp as compagnia, count(v) as conteggio 
		from volo as v
		group by v.comp) as ta2
	where ta1.conteggio = ta2.conteggio;
