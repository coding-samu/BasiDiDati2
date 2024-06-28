-- Trigger V.Offerta.No_overlapping_offerte_stesso_articolo_per_stessa_azienda
    quando deve essere effettuato: dopo insert(new) o update(new) in Offerta
    controllo da effettuare:
        isError := exists (
            select *
            from Offerta o
            where o.id != new.id and o.articolo = new.articolo and o.negozio = new.negozio and ((o.inizio,coalesce(o.fine,'infinity'::timestamp)) overlaps (new.inizio,coalesce(new.fine,'infinity'::timestamp)))
        );

-- Trigger V.Riduzione.Riduzioni_consistenti
    quando deve essere effettuato: dopo insert(new) o update(new) o remove(new)
    controllo da effettuare:
        isError := exists ( -- i1 < i
            select *
            from Riduzione r
            where r.spedizione = new.spedizione and r.id <> new.id and r.inizio < new.inizio
        ) and not exists ( -- f1 = i-1
            select *
            from Riduzione r
            where r.spedizione = new.spedizione and r.id <> new.id and r.fine = new.inizio-1
        )

-- Trigger V.Riduzione.No_overlapping_stessa_spedizione
    quando deve essere effettuato: dopo insert(new) o update(new) in Riduzione
    controllo da effettuare:
        isError := exists (
            select *
            from Riduzione r
            where r.spedizione = new.spedizione and ((new.inizio,coalesce(new.fine,'infinity'::integer)) overlaps (r.inizio,coalesce(r.fine,'infinity'::integer)))
        );

-- Trigger V.Riduzione.piu_grande_senza_fine
    quando deve essere effettuato: dopo insert(new), update(new) o delete(new) in Riduzione
    controllo da effettuare:
        isError := not exists (
            with massimo as (
                select max(r.inizio) as ma
                from Riduzione r
                where r.spedizione = new.spedizione
            )
            select *
            from Riduzione r, massimo mas
            where r.inizio = mas.ma and r.fine is null and r.spedizione = new.spedizione
        );

-- Trigger V.Acquisto.buoni_regalo_posseduti_da_utente
    quando deve essere effettuato: dopo insert(new) o update(new) in Acquisto
    controllo da effettuare:
        isError := exists (
            select *
            from BuonoRegalo br
            where br.acquisto = new.id and br.possiede <> new.utente
        );

-- Trigger V.Acquisto.totale_buoni_non_supera_prezzo
    quando deve essere effettuato: dopo insert(new) o update(new) in Acquisto
    controllo da effettuare:
        isError := valoreBuoni(new.id) < prezzoSenzaBuoni(new.id)

-- Trigger V.Acquisto.indirizzo_nazione_tale_che_esiste_spedizione_nazione
    quando deve essere effettuato: dopo insert(new) o update(new) in acq_of
    controllo da effettuare:
        isError := not exists (
            select *
            from Citta c, Acquisto acq, spedizione s
            where acq.citta = c.id and new.acquisto = acq.id and new.offerta = s.offerta and s.nazione = c.nazione
        );

-- Trigger V.Acquisto.acquisto_in_periodo_offerta
    quando deve essere effettuato: dopo insert(new) o update(new) in Acquisto
    controllo da effettuare:
        isError := exists (
            select *
            from Offerta o
            where new.offerta = o.id and not ((new.istante,new.istante) overlaps (o.inizio,coalesce(o.fine,'infinity'::timestamp)))
        );

-- Trigger V.Acquisto.buono_utilizzato_in_periodo_validità
    quando deve essere effettuato: dopo insert(new) o update(new) in Acquisto
    controllo da effettuare:
        isError := exists (
            select *
            from BuonoRegalo br
            where br.acquisto = new.id and (new.istante < br.inizio or new.istante > fine(br.id))
        );

-- Trigger V.Acquisto.istante_acquisto_maggiore_registrazione_utente
    quando deve essere effettuato: dopo insert(new) o update(new) in Acquisto
    controllo da effettuare:
        isError := exists (
            select *
            from Utente u
            where new.utente = u.nickname and u.reg > new.istante
        );

-- Trigger V.BuonoRegalo.istante_inizio_maggiore_registrazione_utente_che_possiede
    quando deve essere effettuato: dopo insert(new) o update(new) in BuonoRegalo
    controllo da effettuare:
        isError := exists (
            select *
            from Utente u
            where new.possiede = u.nickname and u.reg > new.inizio
        );

-- Trigger V.BuonoRegalo.istante_inizio_maggiore_registrazione_utente_che_acquista
    quando deve essere effettuato: dopo insert(new) o update(new) in BuonoRegalo
    controllo da effettuare:
        isError := exists (
            select *
            from Utente u
            where new.acquista = u.nickname and u.reg > new.inizio
        );

-- Trigger V.Acquisto.cc_di_utente
    quando deve essere effettuato: dopo insert(new) o update(new) in Acquisto
    controllo da effettuare:
        isError := exists (
            select *
            from CartaDiCredito c
            where new.carta = c.numero and c.utente <> new.utente
        );

-- Trigger V.Acquisto.cc_solo_se_prezzo_GZ
    quando deve essere effettuato: dopo insert(new) o update(new) in Acquisto
    controllo da effettuare:
        isError := (prezzo(new.id) > 0 and new.carta is null) or (prezzo(new.id) = 0 and new.carta is not null);

-- Trigger V.Acquisto.cc_non_scaduta
    quando deve essere effettuato: dopo insert(new) o update(new) in Acquisto
    controllo da effettuare:
        isError := exists (
            select *
            from CartaDiCredito c
            where c.numero = new.carta and c.scadenza < new.istante
        );

-- Trigger V.Amicizia.no_due_relazioni
    quando deve essere effettuato: dopo insert(new) o update(new) in amiciziaPending
    controllo da effettuare:
        isError := exists (
            select *
            from amiciziaPending ap
            where ap.riceve = new.invia and ap.invia = new.riceve
        );