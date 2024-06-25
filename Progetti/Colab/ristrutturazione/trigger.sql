-- 1. Non è possibile modificare gli id artificiali

TODO [V.Cliente.disjoint]
    ALL c,x,y pf_isa_cli(x,c) -> not az_isa_cli(y,c)
-- 2. Trigger V.Cliente.disjoint
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError :=

TODO [V.Cliente.complete]
    ALL c Cliente(c) -> EXISTS x pf_isa_cli(x,c) or az_isa_cli(x,c)
-- 3. Trigger V.Cliente.complete
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError :=

TODO [V.Abbonamento_in_intervallo_date]
ALL a,ta,ia ab_ta(a,ta) and inizio(a,ia) -> EXISTS id,i,f id_ta(id,ta) and inizio(id,i) and fine(id,f) and i <= ia <= f
-- 4. Trigger V.Abbonamento_in_intervallo_date
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError :=

TODO [V.Abbonamento_non_superati_max_abbonati]
ALL ta, m, d TipologiaAbbonamento(ta) and maxAbbonati(ta,m) and Data(d) -> (
     U = {u | EXISTS a ab_ut(a,u) and ab_ta(a,ta) and (ALL i inizio(a,i) -> i <= d) and (ALL f fine_{Abbonamento}(a,f) -> d <= f)} 
        -> |U| <= m)
-- 5. Trigger V.Abbonamento_non_superati_max_abbonati
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError :=

TODO [V.Accesso_se_abbonato]
ALL u,a,ie ac_ut(a,u) and entrata(a,ie) -> EXISTS ab,i,f ab_ut(ab,u) and inizio(ab,i) and fine_{Abbonamento}(ab,f) and i <= ie <= f
-- 6. Trigger V.Accesso_se_abbonato
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError :=

TODO [V.Accesso.Overlapping_accessi]
ALL u,a1,a2 ac_ut(a1,u) and ac_ut(a2,u) and a1 != a2
    -> NOT EXISTS t DataOra(t) and (ALL e entrata(a1,e) -> e <= t) and (ALL e entrata(a2,e) -> e <= t)
        and (ALL u Uscita(a1) and Uscita(a1,u) -> t <= u) and (ALL u Uscita(a2) and Uscita(a2,u) -> t <= u)
-- 7. Trigger V.Accesso.Overlapping_accessi (trigger equivalenti: V.IntervalloDate.Overlapping, V.PostazioneLavoro.no_overlapping, V.Utilizzo.Overlapping, V.Abbonamento.No_overlapping_utenti)
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError :=

TODO [V.Utilizzo.dentro_accesso_utente]
ALL uti,u,i,f ut_uti(u,uti) and inizio(uti,i) and fine(uti,f)
    -> (EXISTS a,ie ac_ut(a,u) and entrata(a,ie) and ie <= i and (ALL iu uscita(a,iu) -> f <= iu))
-- 8. Trigger V.Utilizzo.dentro_accesso_utente
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError :=