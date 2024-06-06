create domain InteroGZ as integer
    check(value > 0);

create domain InteroGEZ as integer
    check(value >= 0);

create domain StringaS as varchar(100);

create domain CF as varchar(16);
    --check(isCF(value));

create domain Sconto as real
    check(value > 0 and value <= 1);

create domain Civico_not_null as StringaS
    check(value is not null /*and isCivico(value)*/);

create domain StringaS_not_null as StringaS
    check(value is not null);

create type Ind as (
    via StringaS_not_null,
    civico Civico_not_null
);

create domain PartitaIva as StringaS;
    -- check(isPartitaIva(value));

create Email as StringaS;
    -- check(isEmail(value));

create type StatoPrenotazione as enum('Pending','Accettata','Rifiutata');

create type StatoAccettazione as enum('Completata','NonUtilizzata');

create domain RealeGEZ as real
	check(value >= 0);

