create domain interogz as integer (check value > 0);
create domain interogez as integer (check value >= 0);
create domain realegz as real (check value > 0);
create domain stringas as varchar(75);
create domain codice as text; --(check value isCodCliente());
create type tipocontratto as enum('Indeterminato','Determinato');