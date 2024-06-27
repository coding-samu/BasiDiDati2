/*
[V.Offerta.No_overlapping_offerte_stesso_articolo_per_stessa_azienda]
ALL n,a,o1,o2,i1,i2 neg_of(n,o1) and neg_of(n,o2) and art_of(a,o1) and art_of(a,o2) and inizio(o1,i1) and inizio(o2,i2)
    -> not exists t DataOra(t) and (i1 <= t and i2 <= t) and ALL (f1 fine(o1,f1) -> t <= f1) and (ALL f2 fine(o2,f2) -> t <= f2)
*/
TODO
-- Trigger
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError := 

/*
[V.Riduzione.Riduzioni_consistenti]
ALL r,n,o,i spedizione(n,o) and rid_spe(r,n,o) and inizio(r,i) and i != 2 -> EXISTS r1,f r1 != r and rid_spe(r1,n,o) and f = i-1
*/
TODO
-- Trigger
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError := 

/*
[V.Riduzione.No_overlapping_stessa_spedizione]
ALL r1,r2,i1,i2,n,o spedizione(n,o) and rid_spe(r1,n,o) and rid_spe(r2,n,o) and inizio(r1,i1) and inizio(r2,i2)
    -> not exists t DataOra(t) and (i1 <= t and i2 <= t) and (ALL f1 fine(r1,f1) -> t <= f1) and (ALL f2 fine(r2,f2) -> t <= f2)
*/
TODO
-- Trigger
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError := 

/*
[V.Riduzione.inizio_fine_coerenti]
ALL r,i Riduzione(r) and inizio(r,i) and (ALL f fine(r,f)) -> i <= f
*/
TODO
-- Trigger
    DA IMPLEMENTARE COME VINCOLO DI ENNUPLA

/*
[V.Riduzione.piu_grande_senza_fine]
ALL r,n,o rid_spe(r,n,o) -> EXISTS r1 rid_spe(r1,n,o) and NOT EXISTS f fine(r1,f)
*/
TODO
-- Trigger
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError := 

/*
[V.Acquisto.buoni_regalo_posseduti_da_utente]
ALL a,b,u acq_ut(a,u) and acq_br(a,b) -> possiede(u,b)
*/
TODO
-- Trigger
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError := 

/*
[V.Acquisto.totale_buoni_non_supera_prezzo]
ALL a,psb,tb prezzoSenzaBuoni_{Acquisto}(a,psb) and valoreBuoni{Acquisto}(a,tb) -> psb-tb >= 0
*/
TODO
-- Trigger
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError := 

/*
[V.Acquisto.indirizzo_nazione_tale_che_esiste_spedizione_nazione]
ALL a,ca,na acq_cit(a,ca) and cit_naz(ca,na) -> EXISTS o acq_of(a,o) and spedizione(na,o)
*/
TODO
-- Trigger
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError := 

/*
[V.Acquisto.acquisto_in_periodo_offerta]
ALL a,o,is,i acq_of(a,o) and istante(a,is) and inizio(a,i) -> (ALL f fine(o,f) -> is <= f) and i <= is
*/
TODO
-- Trigger
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError := 

/*
[V.Offerta.inizio_leq_fine]
ALL o,i,f Offerta(o) and inizio(o,i) and fine(o,f) -> i <= f
*/
TODO
-- Trigger
    DA IMPLEMENTARE COME VINCOLO DI ENNUPLA

/*
[V.Acquisto.buono_utilizzato_in_periodo_validità]
ALL a,b,is,i,f acq_br(a,b) and inizio(b,i) and fine_{BuonoRegalo}(b,f) -> i <= is <= f
*/
TODO
-- Trigger
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError := 

/*
[V.amiciziaPending.non_a_se_stesso]
ALL u1,u2 amiciziaPending(u1,u2) -> u1 != u2
*/
TODO
-- Trigger
    DA IMPLEMENTARE COME VINCOLO DI ENNUPLA

/*
[V.Acquisto.istante_acquisto_maggiore_registrazione_utente]
ALL a,u,ia,ir acq_ut(a,u) and reg(u,ir) and istante(a,ia) -> ia > ir
*/
TODO
-- Trigger
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError := 

/*
[V.BuonoRegalo.istante_inizio_maggiore_registrazione_utente_che_possiede]
ALL u,b,ir,i possiede(u,b) and reg(u,ir) and inizio(b,i) -> ir <= i
*/
TODO
-- Trigger
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError := 

/*
[V.BuonoRegalo.istante_inizio_maggiore_registrazione_utente_che_acquista]
ALL u,b,ir,i acquista(u,b) and reg(u,ir) and inizio(b,i) -> ir <= i
*/
TODO
-- Trigger
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError := 

/*
[V.Acquisto.cc_di_utente]
ALL a,cc,u acq_cc(a,cc) and acq_ut(a,u) -> cc_ut(cc,u)
*/
TODO
-- Trigger
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError := 

/*
[V.Acquisto.cc_solo_se_prezzo_GZ]
ALL a,p prezzo_{Acquisto}(a,p) (EXISTS cc acq_cc(a,cc) <-> p > 0)
*/
TODO
-- Trigger
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError := 

/*
[V.Acquisto.cc_non_scaduta]
ALL a, cc, ia, is acq_cc(a,cc) and istante(a,ia) and scadenza(cc,is) -> ia <= is
*/
TODO
-- Trigger
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError := 

/*
[V.amicizia_isa_amiciziapending]
ALL u1,u2 amicizia(u1,u2) -> amiciziaPending(u1,u2)
*/
TODO
-- Trigger
    DA IMPLEMENTARE COME VINCOLO DI INCLUSIONE

/*
[V.Amicizia.no_due_relazioni]
ALL u1,u2 amiciziaPending(u1,u2) -> not amiciziaPending(u2,u1)
*/
TODO
-- Trigger
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError :=