-- operazioni classe Video

create or replace function numeroVisualizzazioni(this Video)
returns InteroGEZ as
$$
begin
return (
    select count(*)
    from Cronologia c
    where c.video = this.id
);
end;
$$
language plpgsql;

create or replace function numeroValutazioni(this Video)
returns InteroGEZ as
$$
begin
return (
    select count(*)
    from Valutazione v
    where v.video = this.id
);
end;
$$
language plpgsql;

create or replace function mediaValutazioni(this Video)
returns RealeGEZ as
$$
declare
    numVal InteroGEZ = numeroValutazioni(this);
    sumVal InteroGEZ = 0;
begin

    if numVal = 0 then raise exception 'Error 001 - il video non ha valutazioni'; end if;

    select sum(v.voto)
    into sumVal
    from Valutazione v
    where v.video = this.id;

    return sumVal/numVal;
end;
$$
language plpgsql;