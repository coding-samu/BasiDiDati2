-- usecase ricerca

create or replace function ricerca(c integer,n InteroGEZ, inizio date, fine date)
returns setof Abitazione
as $$
begin
return query
    select a.*
    from Abitazione a
    where a.citta = c and numPersoneOspitabili(a,inizio,fine) >= n;
end;
$$ language plpgsql;