-- Usecase squadrePerIntervento
create or replace function squadrePerIntervento(i integer)
returns table (codice CodSquadra) as $$
    begin
        if exists (
            select *
            from Assegnato a
            where a.intervento = i
        ) then raise exception 'Usecase Error 001 - Intervento già assegnato';
        end if;
        if not exists (
            select *
            from Intervento inte
            where inte.id = i
        ) then raise exception 'Usecase Error 002 - Intervento inesistente';
        end if;
        if (
            select (inte.inizio < current_timestamp) 
            from intervento inte 
            where inte.id = i
        ) then raise exception 'Usecase Error 003 - Intervento già iniziato';
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

-- Usecase areeSensibiliSenzaInterventi
create or replace function areeSensibiliSenzaInterventi(i timestamp, f timestamp)
returns table (denominazione StringaS) as $$
    begin
        if i > f then raise exception 'Usecase Error 003 - inizio > fine';
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

TODO
resocontoTassoMalattia(i DataOra, f DataOra, M Malattia [0..*]): (m Malattia, t RealeGEZ)
    precondizioni:
        i <= f

    postcondizioni:
        ALL T, TpM
            T = {sv | exists sm, dsm sm_sv(sm,sv) and scoperta(sm,dsm) and i <= dsm and dsm <= f}
            and
            TpM = {(m,n) | m in M and n = |{sv | exists sm, dsm sm_sv(sm,sv) and scoperta(sm,dsm) and i <= dsm and dsm <= f and mal_sm(m,sm)}|/|T|}
                -> result = TpM