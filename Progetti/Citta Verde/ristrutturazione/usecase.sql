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

TODO
areeSensibiliSenzaInterventi(i DataOra, f DataOra): AreaVerde
    precondizioni:
        i <= f
    postcondizioni:
        AS = {a | Sensibile(a)}

        AI = {a | exists int Sensibile(a) and av_int(a,int) and ((ALL in inizio(int,in) -> i <= in <= f) or (ALL ic istanteCompl(int,ic) -> i <= ic <= f))}

        result = AS - AI
-- Usecase areeSensibiliSenzaInterventi
create or replace function areeSensibiliSenzaInterventi(i timestamp, f timestamp)

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