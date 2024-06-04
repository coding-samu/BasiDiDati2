-- operazioni classe PostoLetto

create or replace function occupato(this PostoLetto,inizio date, fine date)
returns boolean as 
$$
declare
    prenotazioni InteroGEZ = 0;
begin
    -- pre-condizione
    if inizio > fine then raise exception 'Error 001 - la data di inizio è maggiore di quella di fine'; end if;

    -- post-condizione

    select count(*)
    into prenotazioni
    from Prenotazione p,PrenotazioneAccettata pa,pren_pl pp
    where p.id = pa.Prenotazione and pp.Prenotazione = p.id and pp.PostoLetto = this.id and ( (inizio,fine) overlaps (p.dataInizio,p.dataInizio+p.durataGiorni));

    return prenotazioni != 0;
end;
$$ language plpgsql;

create or replace function indisponibilePostoLetto(this PostoLetto, inizio date, fine date)
returns boolean as $$
declare
    indisponibilita InteroGEZ = 0;
    begin
        if inizio > fine then raise exception 'Error 001 - la data di inizio è maggiore di quella di fine'; end if;

        select count(*)
        into indisponibilita
        from IndisponibilitaPostoLetto as ipl
        where ipl.postoletto = this.id and ((inizio,fine) overlaps (ipl.dataInizio,ipl.dataInizio + ipl.durataGiorni));

        return indisponibilita != 0;
    end;
$$ language plpgsql;

create or replace function postiPostoLetto(this PostoLetto)
returns InteroGZ as $$
begin

return (
    select t.numPosti
    from TipoPostoLetto t
    where this.tipo = t.nome
);

end;
$$
language plpgsql;

-- operazioni classe abitazione

create or replace function numPersoneOspitabili(this Abitazione,inizio date,fine date)
returns InteroGEZ as
$$
begin
    if inizio > fine then raise exception 'Error 001 - la data di inizio è maggiore di quella di fine'; end if;

    return (
        select sum(postiPostoLetto(pl))
        from stanza s,postoLetto pl
        where s.abitazione = this.utente and pl.stanza = s.id and not occupato(pl,inizio,fine)
    ); 

end;
$$
language plpgsql;

create or replace function indisponibileAbitazione(this Abitazione, inizio date, fine date)
returns boolean as $$
declare
    indisponibilita InteroGEZ = 0;
    begin
        if inizio > fine then raise exception 'Error 001 - la data di inizio è maggiore di quella di fine'; end if;

        select count(*)
        into indisponibilita
        from indisponibileAbitazione as ia
        where ia.abitazione = this.utente and ((inizio,fine) overlaps (ia.dataInizio,ia.dataInizio+ia.durataGiorni));

        return indisponibilita != 0;
    end;
$$ language plpgsql;

-- operazioni classe PrenotazioneAccettata

create or replace function terminata(this PrenotazioneAccettata)
returns boolean as $$
declare
    fine date = null;
begin
    select p.dataInizio + p.durataGiorni
    into fine
    from Prenotazione p
    where this.Prenotazione = p.id;

    return fine <= current_date;
end;
$$
language plpgsql;

-- operazioni classe Utente

create or replace function puoPrenotare(this Utente)
returns boolean as $$
    declare
        senzaFeedback InteroGEZ = 0;
    begin
        select count(*)
        into senzaFeedback
        from prenotazione as p, PrenotazioneAccettata as pa, prenotati as pr
        where pa.prenotazione = p.id and pr.prenotazione = p.id and pr.utente = this.id and terminata(pa) and pr.VotoVersoOspitante is null;

        return senzaFeedback = 0;
    end;
$$ language plpgsql;