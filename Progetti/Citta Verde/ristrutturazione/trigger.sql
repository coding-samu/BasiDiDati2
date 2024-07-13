-- Trigger [V.Partecipa.no_overlapping_capo_stessa_squadra]
quando deve essere effettuato: dopo insert(new) or update(new) in Partecipa
controllo da effettuare:
    isError := exists (
        select *
        from Partecipa p
        where p.squadra = new.squadra and p.id != new.id and p.capo = True and new.capo = True and ((p.inizio,coalesce(p.fine,'infinity'::timestamp)) overlaps (new.inizio,coalesce(new.fine,'infinity'::timestamp)))
    );

-- Trigger [V.Assegnato.Squadra_puo_usare_attrezzatura_istante_assegnamento]
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

-- Trigger [V.Completato.Squadra_puo_usare_attrezzatura]
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

TODO
[V.Risolta.data_consistente]
ALL sm,compl,ass,int,ii,is compl_sm(compl,sm) and compl_isa_ass(compl,ass) and ass_isa_int(ass,int) and inizio(int,ii) and scoperta(sm,is)
    -> is <= ii
-- Trigger [V.Risolta.data_consistente]
quando deve essere effettuato:
controllo da effettuare:
    isError := exists (
        select *
        from
        where
    )

TODO
[V.Assegnato.istante_minore_di_inizio_intervento]
ALL ass,ia,ii,int ass_isa_int(ass,int) and istanteAss(ass,ia) and inizio(int,ii) -> ia < ii
-- Trigger [V.Assegnato.istante_minore_di_inizio_intervento]
quando deve essere effettuato:
controllo da effettuare:
    isError := exists (
        select *
        from
        where
    )

TODO
[V.Completato.istante_maggiore_di_inizio_intervento]
ALL compl,ic,ii,ass,int compl_isa_ass(compl,ass) and ass_isa_int(ass,int) and istanteCompl(compl,ic) and inizio(int,ii) -> ic > ii
-- Trigger [V.Completato.istante_maggiore_di_inizio_intervento]
quando deve essere effettuato:
controllo da effettuare:
    isError := exists (
        select *
        from
        where
    )

TODO
[V.SoggettoVerde.date_intervento_consistenti]
ALL sv, int, ass, compl, ii, dp int_sv(int,sv) and ass_isa_int(ass,int) and compl_isa_ass(compl,ass) and dataPiantumazione(sv,dp) and inizio(int,ii)
    -> dp <= ii and (ALL ic, ir istanteCompl(compl,ic) and rimozione(sv,ir) -> ic <= ir)
-- Trigger [V.SoggettoVerde.date_intervento_consistenti]
quando deve essere effettuato:
controllo da effettuare:
    isError := exists (
        select *
        from
        where
    )

TODO
[V.Intervento.inizio_e_completamento_coerenti_con_inizio_e_fine_squadra]
ALL s,compl,is,ic,ii,int,ass ass_sq(ass,s) and ass_isa_int(ass,int) and compl_isa_ass(compl,ass) and istanteCompl(compl,ic) and inizio(int,ii) and inizio(s,is)
    -> is <= ii and (ALL f fine(s,f) -> ic <= f)
-- Trigger [V.Intervento.inizio_e_completamento_coerenti_con_inizio_e_fine_squadra]
quando deve essere effettuato:
controllo da effettuare:
    isError := exists (
        select *
        from
        where
    )

TODO
[V.Intervento_su_malattia_allora_intervento_su_soggetto_verde_oppure_su_area_verde_senza_soggetti_verdi]
ALL compl,sm,sv,int,ass ass_isa_int(ass,int) and compl_isa_ass(compl,ass) and compl_sm(compl,sm) and sm_sv(sm,sv) -> int_sv(int,sv) OR ((exists av av_sv(av,sv) and av_int(av,int)) and (not exists sv1 int_sv(int,sv1)))
-- Trigger [V.Intervento_su_malattia_allora_intervento_su_soggetto_verde_oppure_su_area_verde_senza_soggetti_verdi]
quando deve essere effettuato:
controllo da effettuare:
    isError := exists (
        select *
        from
        where
    )

TODO
[V.Squadra.no_overlapping_stesso_operatore]
    ALL o,s1,s2 partecipa(o,s1) and partecipa(o,s2) and s1 != s2 
        -> not exists t DataOra(t) and (ALL i inizio(s1,i) -> i <= t) and (ALL i inizio(s2,i) -> i <= t)
           and (ALL f fine(s1,f) -> t <= f) and (ALL f fine(s2,f) -> t <= f)
-- Trigger [V.Squadra.no_overlapping_stesso_operatore]
quando deve essere effettuato:
controllo da effettuare:
    isError := exists (
        select *
        from
        where
    )

TODO
[V.partecipa.no_overlapping_operatore]
ALL p1, p2, op, i1, i2 op_par(op,p1) and op_par(op,p2) and inizio(p1,i1) and inizio(p2,i2) and p1 != p2
    -> not exists t DataOra(t) and (i1 <= t and i2 <= t) and (ALL f1 fine(p1,f1) -> t <= f1) and (ALL f2 fine(t2,f2) -> t <= f2)
-- Trigger [V.partecipa.no_overlapping_operatore]
quando deve essere effettuato:
controllo da effettuare:
    isError := exists (
        select *
        from
        where
    )

TODO
[V.Operatore.no_overlapping_per_stessa_persona]
ALL op1, op2, per, i1, i2 op_per(op1,per) and op_per(op2,per) and inizio(op1,i1) and inizio(op2,i2) and op1 != op2
    -> not exists t DataOra(t) and (i1 <= t and i2 <= t) and (ALL f1 fine(op1,f1) -> t <= f1) and (ALL f2 fine(op2,f2) -> t <= f2)
-- Trigger [V.Operatore.no_overlapping_per_stessa_persona]
quando deve essere effettuato:
controllo da effettuare:
    isError := exists (
        select *
        from
        where
    )

TODO
[V.PuoUtilizzare.no_overlapping_operatore_stesso_attrezzo]
ALL pu1, pu2, o, a, i1, i2 op_pu(o,pu1) and op_pu(o,pu2) and attr_pu(a,pu1) and attr_pu(a,pu2) and pu1 != pu2 and inizio(pu1,i1) and inizio(pu2,i2)
    -> not exists t DataOra(t) and (i1 <= t and i2 <= t) and (ALL f1 fine(pu1,f1) -> t <= f1) and (ALL f2 fine(pu2,f2) -> t <= f2)
-- Trigger [V.PuoUtilizzare.no_overlapping_operatore_stesso_attrezzo]
quando deve essere effettuato:
controllo da effettuare:
    isError := exists (
        select *
        from
        where
    )

TODO
[V.Partecipa.date_consistenti_con_date_operatore]
ALL p, o, ip, io op_par(o,p) and inizio(o,io) and inizio(p,ip)
    -> io <= ip and ((not exists fo fine(o,fo)) or (exists fo,fp fine(o,fo) and fine(p,fp) and fp <= fo)) 
-- Trigger [V.Partecipa.date_consistenti_con_date_operatore]
quando deve essere effettuato:
controllo da effettuare:
    isError := exists (
        select *
        from
        where
    )

TODO
[V.PuoUtilizzare.date_consistenti_con_date_operatore]
ALL p, o, ip, io op_pu(o,p) and inizio(o,io) and inizio(p,ip)
    -> io <= ip and ((not exists fo fine(o,fo)) or (exists fo,fp fine(o,fo) and fine(p,fp) and fp <= fo)) 
-- Trigger [V.PuoUtilizzare.date_consistenti_con_date_operatore]
quando deve essere effettuato:
controllo da effettuare:
    isError := exists (
        select *
        from
        where
    )

TODO
[V.Assegnato.Squadra_cardinalita_almeno_minimo_operatori_richiesti]
ALL a,s,m,ia,no ass_sq(a,s) and istanteAss(a,ia) and numOperatori_{Squadra,DataOra}(s,ia,no) and minimoOperatori(a,m) -> no >= m
-- Trigger [V.Assegnato.Squadra_cardinalita_almeno_minimo_operatori_richiesti]
quando deve essere effettuato:
controllo da effettuare:
    isError := exists (
        select *
        from
        where
    )

TODO
[V.SoggettoVerde.date_malattia.consistenti]
ALL sm, sv, dsm sm_sv(sm,sv) and scoperta(sm,dsm) -> (ALL dp dataPiantumazione(sv,dp) -> dp <= dsm) and (ALL r rimozione(sv,r) -> dsm <= r)
-- Trigger [V.SoggettoVerde.date_malattia.consistenti]
quando deve essere effettuato:
controllo da effettuare:
    isError := exists (
        select *
        from
        where
    )

TODO
[V.Intervento.SoggettoVerde_in_area_verde]
ALL i,av,sv int_sv(i,sv) and av_sv(av,sv) -> av_int(av,i)
-- Trigger [V.Intervento.SoggettoVerde_in_area_verde]
quando deve essere effettuato:
controllo da effettuare:
    isError := exists (
        select *
        from
        where
    )