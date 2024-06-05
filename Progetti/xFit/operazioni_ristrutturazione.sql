-- Operazione classe Contratto

create or replace function contrattoAttivo(this Contratto)
returns boolean as $$
    begin
        if this.fine is null then return true; end if;
        return this.fine < current_date;
    end;
$$ language plpgsql;

-- Operazione classe Lezione

create or replace function lezioneInCorso(this Lezione, istante timestamptz)
returns boolean as $$
    begin
        return this.inizio <= istante and istante <= this.fine;
    end;
$$ language plpgsql;


-- Operazione classe Abbonamento

create or replace function fineAbbonamento(this Abbonamento)
returns date as $$
    declare
        mesi InteroGEZ = 0;
    begin
        SELECT ta.durataMesi
        INTO mesi
        FROM TipologiaAbbonamento as ta
        WHERE ta.id = this.tipologia;

        return mesi*30 + this.inizio;
    end;
$$ language plpgsql;

create or replace function abbonamentoScaduto(this Abbonamento, istante date)
returns boolean as $$
    declare
        fine date = fineAbbonamento(this);
    begin
        if istante < this.inizio then raise exception 'Error 001 - Istante non valido'; end if;
        return fine < istante;
    end;
$$ language plpgsql;

create or replace function attivitaConcesse(this Abbonamento, istante timestamptz)
returns setof AttivitaSportiva as $$
    begin
        return query (
            select distinct a.*
            from AttivitaSportiva as a, Accede as acc, Lezione as l, TipologiaAbbonamento as t
            where this.tipologia = t.id and acc.tipologia = t.id and acc.attivita = a.nome and l.attivita = a.nome and lezioneInCorso(l,istante)
        );
    end;
$$ language plpgsql;

-- Operazioni della classe AreaAttivita

create or replace function numClientiDentro(this AreaAttivita, quando timestamptz)
returns InteroGEZ as $$
    declare
        risultato InteroGEZ = 0;
    begin
        select distinct count(c.codice)
        into risultato
        from Cliente c, Varco v, StoricoIngressi s
        where v.entraIn = this.area and s.varco = v.id and s.cliente = c.codice and s.entrata >= quando and ((s.uscita is null) or (s.uscita > quando));
        return risultato;
    end;
$$ language plpgsql;

-- Operazioni della classe Varco

create or replace function varchiRaggiungibili(this Varco)
returns setof Varco as $$
    begin
        return query (
            with immragg as (
                select v.*
                from Varco v, Area a
                where (this.entraIn = a.id and v.entraDa = a.id and v.id != this.id)
            )
            SELECT v1.*
            FROM immragg as ir, Varco v1
            where v1.id = ir.id
            union
            select v.*
            from Varco v, immragg ir
            where v.id != ir.id and v =any varchiRaggiungibili(ir)
        );
    end;
$$ language plpgsql;

create or replace function puoEntrare(this Varco, c Cliente)
returns boolean as $$
    begin
        if not exists(
            select *
            from Abbonamento a
            where c.codice = a.cliente and not abbonamentoScaduto(a,current_date)
        )
        then return false;
        end if;

        if exists (
            select *
            from Area a, AreaComune ac
            where this.entraIn = a.id and a.id = ac.area
        ) then return true; end if;

        if exists(select *
        from Abbonamento a, Area ar, AreaAttivita arat
        where c.codice = a.cliente and not abbonamentoScaduto(a,current_date) 
            and this.entraIn = ar.id and arat.area = ar.id and (numClientiDentro(arat,current_timestamp) + 1 <= arat.capienza)
            and exists (
                select *
                from attivitaConcesse(a,current_timestamp) ac, AttivitaSportiva ats
                where ac.nome = ats.nome
            )
        ) then return true; end if;

        if exists(
            select *
            from varchiRaggiungibili(this) as vr
            where puoEntrare(vr,c)
        ) then return true; end if;

        return false;
    end;
$$ language plpgsql;

-- Operazioni della classe Cliente

create or replace function volteInAreaUltimoMese(this Cliente, a AreaAttivita)
returns InteroGEZ as $$
    declare
        volte InteroGEZ = 0;
        inizio timestamp = current_date - 30 + current_time;
    begin
        select count(*)
        into volte
        from StoricoIngressi s, Varco v
        where v.entraIn = a.area and s.entrata >= inizio and s.varco = v.id;

        return volte;
    end;
$$ language plpgsql;