create domain InteroGEZ as integer 
    check(value >= 0);

create domain InteroGZ as integer
    check(value > 0);

create domain Valutazione as integer
    check (value >= 0 and value <= 5);

create type Genere as enum('Maschio','Femmina','Altro');

create domain StringaS as varchar(100);

