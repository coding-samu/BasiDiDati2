-- Usecase 1. squadrePerIntervento
create or replace function squadrePerIntervento(i integer)
returns table (codice CodSquadra) as $$
    begin
        if exists (
            select *
            from Assegnato a
            where a.intervento = i
        ) then raise exception 'Usecase 1. | Error 001 - Intervento già assegnato';
        end if;
        if not exists (
            select *
            from Intervento inte
            where inte.id = i
        ) then raise exception 'Usecase 1. | Error 002 - Intervento inesistente';
        end if;
        if (
            select (inte.inizio < current_timestamp) 
            from intervento inte 
            where inte.id = i
        ) then raise exception 'Usecase 1. | Error 003 - Intervento già iniziato';
        end if;
        return query (
            select s.codice
            from Squadra s, Intervento inte
            where inte.minimoOperatori <= numOperatori(s.codice,current_timestamp) and not exists (
                select *
                from attrezzaturaRichiesta(i) as t2
                where not exists (
                    select *
                    from attrezzaturaUsabile(s.codice,current_timestamp) as t1
                    where t1.nome = t2.nome
                )
            )
        );
    end;
$$ language plpgsql;

-- Usecase 2. areeSensibiliSenzaInterventi
create or replace function areeSensibiliSenzaInterventi(i timestamp, f timestamp)
returns table (denominazione StringaS) as $$
    begin
        if i > f then raise exception 'Usecase 2. | Error 003 - inizio > fine';
        end if;

        return query (
            select a.denominazione
            from AreaVerde a
            where a.isSensibile and not exists (
                select *
                from Intervento inte
                where inte.areaVerde = a.denominazione and (
                    (select (inte.inizio >= i and inte.inizio <= f) from Intervento inte where inte.areaVerde = a.denominazione) or
                    (select (coalesce(comp.istanteCompl,'infinity'::timestamp) >= i and coalesce(comp.istanteCompl,'infinity'::timestamp) <= f) from Completato comp, Intervento inte where comp.intervento = inte.id and inte.areaVerde = a.denominazione)
                )
            )
        );
    end;
$$ language plpgsql;

-- Usecase 3. resocontoTassoMalattia
create or replace function resocontoTassoMalattia(i timestamp, f timestamp, MAL StringaS[])
returns table (m StringaS, t RealeGEZ) as $$
    declare
        totale integer := 0;
    begin
        if i > f then raise exception 'Usecase 3. | Error 003 - inizio > fine';
        end if;

        select count(sv.id)
        into totale
        from SoggettoVerde sv, StoricoMalattia sm
        where sm.soggettoVerde = sv.id and i <= sm.scoperta and sm.scoperta <= f;

        return query (
            select m, count(sm.id)::real/totale
            from StoricoMalattia sm
            where i <= sm.scoperta and sm.scoperta <= f and sm.malattia = m and m = any(MAL)
            group by m
        );
    end;
$$ language plpgsql;