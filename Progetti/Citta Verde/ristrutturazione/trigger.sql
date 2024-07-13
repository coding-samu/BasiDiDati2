-- 1. Trigger [V.Partecipa.no_overlapping_capo_stessa_squadra]
quando deve essere effettuato: dopo insert(new) or update(new) in Partecipa
controllo da effettuare:
    isError := exists (
        select *
        from Partecipa p
        where p.squadra = new.squadra and p.id != new.id and p.capo = True and new.capo = True and ((p.inizio,coalesce(p.fine,'infinity'::timestamp)) overlaps (new.inizio,coalesce(new.fine,'infinity'::timestamp)))
    );

-- 2. Trigger [V.Assegnato.Squadra_puo_usare_attrezzatura_istante_assegnamento]
quando deve essere effettuato: dopo insert(new) or update(new) in Assegnato
controllo da effettuare:
    isError := exists (
        select *
        from attrezzaturaRichiesta(new.intervento) as t2
        where not exists (
            select *
            from attrezzaturaUsabile(new.squadra,new.istanteAss) as t1
            where t1.nome = t2.nome
        )
    );

-- 3. Trigger [V.Completato.Squadra_puo_usare_attrezzatura]
quando deve essere effettuato: dopo insert(new) or update(new) in Completato
controllo da effettuare:
    isError := exists (
        select *
        from attrezzaturaRichiesta(new.intervento) as t2
        where not exists (
            select *
            from Assegnato a, attrezzaturaUsabile(a.squadra,new.istanteCompl) as t1
            where t1.nome = t2.nome and a.intervento = new.intervento
        )
    );

-- 4. Trigger [V.Risolta.data_consistente]
quando deve essere effettuato: dopo insert(new) o update(new) in StoricoMalattia
controllo da effettuare:
    isError := exists (
        select *
        from Assegnato a
        where new.isRisolta and a.intervento = new.intervento and a.istanteAss < new.scoperta
    );

-- 5. Trigger [V.Assegnato.istante_minore_di_inizio_intervento]
quando deve essere effettuato: dopo insert(new) or update(new) in Assegnato
controllo da effettuare:
    isError := exists (
        select *
        from Intervento i
        where new.intervento = i.id and new.istanteAss >= i.inizio
    );

-- 6. Trigger [V.Completato.istante_maggiore_di_inizio_intervento]
quando deve essere effettuato: dopo insert(new) or update(new) in Completato
controllo da effettuare:
    isError := exists (
        select *
        from Intervento i
        where i.id = new.intervento and new.istanteCompl <= i.inizio
    );

-- 7. Trigger [V.SoggettoVerde.date_intervento_consistenti]
quando deve essere effettuato: dopo insert(new) or update(new) in int_sv
controllo da effettuare:
    isError := exists (
        select *
        from Intervento i, Completato c, SoggettoVerde sv
        where i.id = c.intervento and i.id = new.intervento and sv.id = new.soggettoVerde and (i.inizio < sv.dataPiantumazione or coalesce(c.istanteCompl,'infinity'::timestamp) > coalesce(sv.rimozione,'infinity'::timestamp))
    );

-- 8. Trigger [V.Intervento.inizio_e_completamento_coerenti_con_inizio_e_fine_squadra]
quando deve essere effettuato: dopo insert(_) o update(_) in Assegnato o Completato
controllo da effettuare:
    isError := exists (
        select *
        from Squadra sq, Assegnato a, Completato c, Intervento i
        where sq.codice = a.squadra and a.intervento = i.id and i.id = c.intervento and ((sq.inizio > i.inizio) or (coalesce(c.istanteCompl,'infinity'::timestamp) > coalesce(sq.fine,'infinity'::timestamp)))
    );

-- 9. Trigger [V.Intervento_su_malattia_allora_intervento_su_soggetto_verde_oppure_su_area_verde_senza_soggetti_verdi]
quando deve essere effettuato: dopo insert(new) or update(new) in StoricoMalattia
controllo da effettuare:
    isError := exists (
        select *
        from Intervento i, SoggettoVerde sv
        where new.soggettoVerde = sv.id and new.intervento is not null and new.intervento = i.id 
            and (i.areaVerde <> sv.areaVerde or (
                not exists (
                    select *
                    from int_sv ins
                    where ins.intervento = i.id and ins.soggettoVerde = sv.id
                ) and exists (
                    select *
                    from int_sv ins
                    where ins.intervento = i.id and ins.soggettoVerde <> sv.id
                )
            ))
    );

-- 10. Trigger [V.Squadra.no_overlapping_stesso_operatore]
quando deve essere effettuato: insert(new) or update(new) in partecipa
controllo da effettuare:
    isError := exists (
        select *
        from partecipa p
        where p.operatore = new.operatore and p.squadra = new.squadra and p.id <> new.id and ((p.inizio,coalesce(p.fine,'infinity'::timestamp)) overlaps (new.inizio,coalesce(new.fine,'infinity'::timestamp)))
    );

-- 11. Trigger [V.partecipa.no_overlapping_operatore]
quando deve essere effettuato: dopo insert(new) or update(new) in partecipa
controllo da effettuare:
    isError := exists (
        select *
        from partecipa p
        where p.operatore = new.operatore and p.id <> new.id and ((p.inizio,coalesce(p.fine,'infinity'::timestamp)) overlaps (new.inizio,coalesce(new.fine,'infinity'::timestamp)))
    );

-- 12. Trigger [V.Operatore.no_overlapping_per_stessa_persona]
quando deve essere effettuato: dopo insert(new) or update(new) in Operatore
controllo da effettuare:
    isError := exists (
        select *
        from Operatore o
        where o.persona = new.persona and o.id <> new.id and ((o.inizio,coalesce(o.fine,'infinity'::timestamp)) overlaps (new.inizio,coalesce(new.fine,'infinity'::timestamp)))
    );

-- 13. Trigger [V.PuoUtilizzare.no_overlapping_operatore_stesso_attrezzo]
quando deve essere effettuato: dopo insert(new) or update(new) in PuoUtilizzare
controllo da effettuare:
    isError := exists (
        select *
        from PuoUtilizzare pu
        where pu.operatore = new.operatore and pu.attrezzatura = new.attrezzatura and pu.id <> new.id and ((pu.inizio,coalesce(pu.fine,'infinity'::timestamp)) overlaps (new.inizio,coalesce(new.fine,'infinity'::timestamp)))
    );

-- 14. Trigger [V.Partecipa.date_consistenti_con_date_operatore]
quando deve essere effettuato: dopo insert(new) or update(new) in partecipa
controllo da effettuare:
    isError := exists (
        select *
        from operatore o
        where o.id = new.operatore and (new.inizio < o.inizio or coalesce(new.fine,'infinity'::timestamp) > coalesce(o.fine,'infinity'::timestamp))
    );

-- 15. Trigger [V.PuoUtilizzare.date_consistenti_con_date_operatore]
quando deve essere effettuato: dopo insert(new) or update(new) in PuoUtilizzare
controllo da effettuare:
    isError := exists (
        select *
        from Operatore o
        where o.id = new.operatore and (new.inizio < o.inizio or coalesce(new.fine,'infinity'::timestamp) > coalesce(o.fine,'infinity'::timestamp))
    );

-- 16. Trigger [V.Assegnato.Squadra_cardinalita_almeno_minimo_operatori_richiesti]
quando deve essere effettuato: dopo insert(new) or update(new) in Assegnato
controllo da effettuare:
    isError := exists (
        select *
        from Intervento i
        where new.intervento = i.id and i.minimoOperatori > numOperatori(new.squadra,new.istanteAss)
    );

-- 17. Trigger [V.SoggettoVerde.date_malattia.consistenti]
quando deve essere effettuato: dopo insert(new) or update(new) in StoricoMalattia
controllo da effettuare:
    isError := exists (
        select *
        from SoggettoVerde sv
        where new.soggettoVerde = sv.id and (new.scoperta < sv.dataPiantumazione or new.scoperta > coalesce(sv.rimozione,'infinity'::timestamp))
    );

-- 18. Trigger [V.Intervento.SoggettoVerde_in_area_verde]
quando deve essere effettuato: dopo insert(new) or update(new) in int_sv
controllo da effettuare:
    isError := exists (
        select *
        from Intervento i, SoggettoVerde sv
        where i.id = new.intervento and sv.id = new.soggettoVerde and i.areaVerde <> sv.areaVerde
    );