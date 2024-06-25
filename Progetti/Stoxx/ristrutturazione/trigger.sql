1. Non è possibile modificare gli id artificiali

2.1 Trigger V.StrumentoFinanziario.disjoint.titolo
    quando deve essere effettuato: dopo insert(new) o update(new) in titolo
    controllo da effettuare:
        isError := exists (
            SELECT *
            FROM FondoGestito fg
            WHERE fg.sf = new.sf
        )

2.2 Trigger V.StrumentoFinanziario.disjoint.FondoGestito
    Uguale a 2.1

3. Trigger V.StrumentoFinanziario.complete
    quando deve essere effettuato: dopo insert(new) o update(new) in StrumentoFinanziario
    controllo da effettuare:
        isError := not exists (
            SELECT *
            FROM FondoGestito fg
            WHERE fg.sf = new.id
        ) and not exists (
            SELECT *
            FROM Titolo t
            WHERE t.sf = new.id
        )

4. Trigger V.Emittente_Stato_se_e_solo_se_titolo_di_stato
    quando deve essere effettuato: dopo insert(new) o update(new) in StrumentoFinanziario
    controllo da effettuare:
        isError := exists (
            SELECT *
            FROM titolo t, emittente e
            WHERE t.sf = new.id and e.nome = new.emittente and ((e.tipo = 'Stato' and t.tipo <> 'DiStato') or (e.tipo <> 'Stato' and t.tipo = 'Stato'))
        )

5. Trigger V.Istante_investimento_in_periodo_gestione
    quando deve essere effettuato: dopo insert(new) o update(new) in Investimento
    controllo da effettuare:
        isError := not exists(
            select *
            from Gestione g
            where new.gestione = g.id and new.istante >= g.inizio and (g.fine is null or g.fine >= new.istante)
        )

6. Trigger V.Gestione.Overlapping
    quando deve essere effettuato: dopo insert(new) o update(new) in Gestione
    controllo da effettuare:
        isError := exists (
            select *
            from Gestione g
            where g.id != new.id and new.cliente = g.cliente and
                    ((g.fine is not null and new.fine is not null and (g.inizio,g.fine) overlaps (new.inizio,new.fine))
                    or (g.fine is not null and new.fine is null and (g.inizio,g.fine) overlaps (new.inizio,now()::timestamp))
                    or (g.fine is null and new.fine is not null and (g.inizio,now()::timestamp) overlaps(new.inizio,new,fine))
                    or (g.fine is null and new.fine is null)
                    )
        )

7. Trigger V.Istante_investimento_maggiore_di_rilevazione
    quando deve essere effettuato: dopo insert(new) o update(new) in Investimento
    controllo da effettuare:
        isError := not EXISTS (
            select *
            from Rilevazione r
            where r.istante <= new.istante and r.sf = new.sf
        )

8. Trigger V.Istante_disinvestimento_maggiore_di_istante_investimento
    quando deve essere effettuato: dopo insert(new) o update(new) in Disinvestimento
    controllo da effettuare:
        isError := EXISTS (
            select *
            from Investimento i
            where i.istante > new.istante and new.investimento = i.id
        )

9. Trigger V.Somma_quantita_disinvestimento_LEQ_quantita_investimento
    quando deve essere effettuato: dopo insert(new) o update(new) in Disinvestimento
    controllo da effettuare:
        isError := EXISTS (
            select *
            from tot as (
                select sum(d.quantita)
                from Disinvestimento d
                where d.investimento = new.investimento
            ), Investimento i
            where new.investimento = i.id and tot > i.quantita
        )