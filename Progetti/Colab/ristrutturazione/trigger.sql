-- 1. Non è possibile modificare gli id artificiali

-- 2.1 Trigger V.Cliente.disjoint.Azienda
    quando deve essere effettuato: dopo insert(new) o update(new) in Azienda
    controllo da effettuare:
        isError := not exists(
            select *
            from PersonaFisica pf
            where pf.cliente = new.cliente
        )

-- 2.2 Trigger V.Cliente.disjoint.PersonaFisica
    quando deve essere effettuato: dopo insert(new) o update(new) in PersonaFisica
    controllo da effettuare:
        isError := not exists(
            select *
            from Azienda az
            where new.cliente = az.cliente
        )

-- 3.1 Trigger V.Cliente.complete.Insert
    quando deve essere effettuato: dopo insert(new) o update(new) in Cliente
    controllo da effettuare:
        isError := not (exists (
            select *
            from Azienda az
            where new.id = azienda.cliente
        )
        or exists (
            select *
            from PersonaFisica pf, Cliente c
            where new.id = pf.cliente
        ))

-- 3.2 Trigger V.Cliente.complete.Drop
    quando deve essere effettuato: dopo drop(old) in Azienda o PersonaFisica
    controllo da effettuare:
        isError := not exists (
            select *
            from Cliente c
            where old.cliente = c.id
        )

-- 4. Trigger V.Abbonamento_in_intervallo_date
    quando deve essere effettuato: dopo insert(new) o update(new) in Abbonamento
    controllo da effettuare:
        isError := not exists (
            select *
            from IntervalloDate ind
            where ind.tab = new.tab and ind.inizio <= new.inizio and ind.fine >= new.inizio
        )

TODO [V.Abbonamento_non_superati_max_abbonati]
ALL ta, m, d TipologiaAbbonamento(ta) and maxAbbonati(ta,m) and Data(d) -> (
     U = {u | EXISTS a ab_ut(a,u) and ab_ta(a,ta) and (ALL i inizio(a,i) -> i <= d) and (ALL f fine_{Abbonamento}(a,f) -> d <= f)} 
        -> |U| <= m)
-- 5. Trigger V.Abbonamento_non_superati_max_abbonati
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError :=

-- 6. Trigger V.Accesso_se_abbonato
    quando deve essere effettuato: dopo insert(new) o update(new) in Accesso
    controllo da effettuare:
        isError := not exists (
            select *
            from Abbonamento ab, ab_ut au
            where au.utente = new.utente and ab.inizio <= new.entrata and new.uscita <= fineAbbonamento(ab.id)
        )

TODO [V.Accesso.Overlapping_accessi]
ALL u,a1,a2 ac_ut(a1,u) and ac_ut(a2,u) and a1 != a2
    -> NOT EXISTS t DataOra(t) and (ALL e entrata(a1,e) -> e <= t) and (ALL e entrata(a2,e) -> e <= t)
        and (ALL u Uscita(a1) and Uscita(a1,u) -> t <= u) and (ALL u Uscita(a2) and Uscita(a2,u) -> t <= u)
-- 7. Trigger V.Accesso.Overlapping_accessi (trigger equivalenti: V.IntervalloDate.Overlapping, V.PostazioneLavoro.no_overlapping, V.Utilizzo.Overlapping, V.Abbonamento.No_overlapping_utenti)
    quando deve essere effettuato: dopo
    controllo da effettuare:
        isError :=

-- 8. Trigger V.Utilizzo.dentro_accesso_utente
    quando deve essere effettuato: dopo insert(new) o update(new) in Utilizzo
    controllo da effettuare:
        isError := not exists (
            select *
            from Accesso ac
            where ac.utente = new.utente and ac.entrata <= new.inizio and (ac.uscita is null or new.fine <= ac.uscita)
        )