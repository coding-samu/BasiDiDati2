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

[V.Emittente_Stato_se_e_solo_se_titolo_di_stato]
ALL sf,e,te,tt,t em_sf(e,sf) and t_isa_sf(t,sf) and tipoEmittente(e,te) and te = 'Stato' <-> Titolo(t) and tipoTitolo(t,tt) and tt = 'DiStato'

4. Trigger V.Emittente_Stato_se_e_solo_se_titolo_di_stato
    quando deve essere effettuato: dopo insert(new) o update(new) in StrumentoFinanziario
    controllo da effettuare:
        isError := exists (
            SELECT *
            FROM titolo t, emittente e
            WHERE t.sf = new.id and e.nome = new.emittente and ((e.tipo = 'Stato' and t.tipo <> 'DiStato') or (e.tipo <> 'Stato' and t.tipo = 'Stato'))
        )

[V.Istante_investimento_in_periodo_gestione]
ALL inv,ges,i,is inv_ges(inv,ges) and inizio(ges,i) and istante(inv,is) -> 
    (isTerminata(g,True) and fine(ges,f) and i <= is and is <= f)
    or
    (isTerminata(g,False) and i <= is)

[V.Gestione.Overlapping]
ALL c,g',g'',i',i'' cli_ges(c,g') and cli_ges(c,g'') and inizio(g',i') and inizio(g'',i'')
    -> NOT EXISTS t DataOra(t) and (i' <= t and i'' <= t) and (ALL f fine(g',f) -> t <= f) and (ALL f fine(g'',f) -> t <= f)

[V.Istante_investimento_maggiore_di_rilevazione]
ALL inv,sf,i inv_sf(inv,sf) and istante(inv,i) -> EXISTS r,ri ril_sf(r,sf) and istante(r,ri) and ri <= i

[V.Istante_disinvestimento_maggiore_di_istante_investimento]
ALL dis,inv,i,id dis_inv(dis,inv) and istante(inv,i) and istante(dis,id) -> id >= i

[V.Somma_quantita_disinvestimento_LEQ_quantita_investimento]
ALL inv,qi Investimento(inv) and quantita(inv,qi) and Q = {(q,d) | dis_inv(d,i) and quantita(d,q)} and tot = (sum_(q,d) in Q q) -> tot <= qi
