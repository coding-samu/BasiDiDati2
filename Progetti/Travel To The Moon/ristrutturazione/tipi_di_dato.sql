create type StatoPrenotazione as enum('Pending','Accettata','Rifiutata');

create type TipoDestinazione as enum('Romantica','Divertente','RomanticaDivertente');

create domain InteroGEZ as integer
    check (value >= 0);

create domain StringaS as varchar(100);

create domain ValutazioneNave as integer
    check (value >= 3 and value <= 5);

create domain InteroGZ as integer
    check (value > 0);

create domain StringaM as varchar(500);

create domain InteroGZ_not_null as InteroGZ
    check (value is not null);

create domain time_not_null as time
    check (value is not null);

create type DeltaOra as (
    giorno InteroGZ_not_null,
    ora time_not_null
);

create or replace function minoreDeltaOra(a DeltaOra,b DeltaOra) -- a < b
returns boolean as
$$
begin
    if a.giorno < b.giorno then return true;
    elsif a.giorno = b.giorno then return a.ora < b.ora;
    else
        return false;
    end if;
end;
$$
language plpgsql;

create domain StringaS_not_null as StringaS
    check(value is not null);

create domain Civico_not_null as StringaS
    check(value is not null /*and isCivico(value)*/);

create type Indirizzo as (
    via StringaS_not_null,
    civico Civico_not_null
);

create type Giorno as enum('Lunedi','Martedi','Mercoledi','Giovedi','Venerdi','Sabato','Domenica');

create type TipoCrocieraLunaDiMiele as enum('Tradizionale','Alternativa');