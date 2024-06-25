TODO
media_giornaliera(I: Intervallo [0..*]): RealeGEZ
    precondizioni:
        -- classico overlapping per verificare che gli intervalli siano tutti disgiunti tra loro

    postcondizioni:
        non modifica lo spazio estensionale

create or replace function mediaGiornaliera(setof Intervallo)
returns RealeGEZ as $$
begin

end;
$$ language plpgsql;


TODO
fattura(a: Azienda, i: Data, f: Data): Denaro
    precondizioni:
        nessuna
    
    postcondizioni:
        non modifica lo spazio estensionale
        P = {(ut,p) | EXISTS u,iu utentiGestiti(a,i,f,ut) and ut_uti(u,ut) and prezzo(ut,p) and inizio(u,iu) and i <= iu <= f}
        and
        result = sum_{(ut,p) in P} p

create or replace function fattura(az integer, i date, f date)
returns Denaro as $$
begin

end;
$$ language plpgsql;


TODO
serviziModa(i: Data, f: Data, k: InteroGZ): ServizioOfferto [0..k]
    precondizioni:
        nessuna
    postcondizioni:
        non modifica lo spazio estensionale
        Sia S = {(tot,so) | tot = |U| and U = {u | EXISTS iu so_uti(so,u) and inizio(u,iu) and i <= iu <= f} }
        T = sorted(S,desc)
        Sia R l'insieme formato dai primi k so tali che (tot,so) in T
        result = R

create or replace function serviziModa(i date, f date, k interoGZ)
returns setof integer as $$
begin

end;
$$ languageplpgsql;


TODO
clientiInutili(i: Data, f: Data): Utente [0..*]
    precondizioni:
        nessuna
    postcondizioni:
        non modifica lo spazio estensionale
        U = {u | not exists a,e,t DataOra(t) ac_ut(a,u) and entrata(a,e) and (i <= t and e <= t) and (t <= f) and (ALL u uscita(a,u) -> t <= u)}
        result = U

create or replace function clientiInutili(i date, f date)
returns setof IndEmail as $$
begin

end;
$$ language plpgsql;

