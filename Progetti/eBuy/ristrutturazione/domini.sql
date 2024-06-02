create domain StringaM as varchar(100);

create domain StringaS as varchar(50);

create domain  InteroGEZ as integer
    check(value >= 0);

create domain InteroGZ as integer
    check (value > 0);

create type tipoPagamento as enum('ContoCorrente','Bonifico','Altro');

create domain Valutazione as InteroGEZ
    check(value <= 5);

create domain denaro as real
    check(value > 0);

create domain ValAffidabilita as real
    check(value >= 0 and value <= 1);

create domain MesiGaranziaNuovo as integer
    check(value >= 24);

create domain MesiGaranzia as InteroGEZ;

create type condizioniUsato as enum('Ottimo','Buono','Discreto','DaSistemare');

create type ValVendProf as enum('Bassa','Media','Alta');

create domain MediaValutazione as real
    check(value >= 0 and value <= 5);

create domain PercentualeFeedbackNegativi as real 
    check(value >= 0 and value <= 1);

create domain Valuta as varchar(3);
    -- check(isValuta(value));
