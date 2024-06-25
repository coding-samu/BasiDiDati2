create or replace function valorePortafoglio(p MatProm, c codFisc)
returns Denaro as $$
begin
    if not exists (
        SELECT *
        FROM Gestione g
        WHERE g.cliente = c and g.promotore = p and not g.isTerminata and g.inizio <= now()::timestamp
    ) then raise exception 'Error 003 - cliente non è gestito dal promotore'; end if;

    return (
        SELECT sum(valoreInvestimento(i.id, now()::timestamp))
        FROM investimento i, gestione g
        WHERE g.cliente = c and i.gestione = g.id
        GROUP BY i.id
    );
end;
$$ language plpgsql;

create or replace function rischioCliente(p MatProm, c codFisc)
returns Rischio as $$
declare
    totF Denaro = null;
    totA Denaro = null;
    totT Denaro = valorePortafoglio(p,c);
begin
    if not exists (
        SELECT *
        FROM Gestione g
        WHERE g.cliente = c and g.promotore = p and not g.isTerminata and g.inizio <= now()::timestamp
    ) then raise exception 'Error 003 - cliente non è gestito dal promotore'; end if;
    if totT == 0 then return 'Basso'; end if;

    select sum(valoreSF(i.sf,now()::timestamp) * percentualeAzionari(i.sf))
    into totF
    from Gestione g, Investimento i, StrumentoFinanziario sf, FondoGestito fg
    where g.cliente = c and i.gestione = g.id and sf.id = i.sf and fg.sf = sf.id;

    select sum(valoreSF(i.sf,now()::timestamp))
    into totA
    from Gestione g, Investimento i, StrumentoFinanziario sf, Titolo t
    where g.cliente = c and i.gestione = g.id and sf.id = i.sf and t.sf = sf.id;

    if (totF + totA)/totT <= 0.1 then return 'Basso'; end if;
    if 0.1 < (totF + totA)/totT and (totF + totA)/totT <= 0.4 then return 'Medio'; end if;
    if 0.4 < (totF + totA)/totT and (totF + totA)/totT <= 0.6 then return 'Alto'; end if;
    return 'Aggressivo';

end;
$$ language plpgsql;