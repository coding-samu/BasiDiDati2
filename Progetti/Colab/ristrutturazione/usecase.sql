TODO
media_giornaliera(I: Intervallo [0..*]): (Intervallo, RealeGEZ) [0..*]
    precondizioni:
        -- classico overlapping per verificare che gli intervalli siano tutti disgiunti tra loro

    postcondizioni:
        non modifica lo spazio estensionale
        A = {(a,i) | exists u,in,fi,ia,a,m,an,em,ean i in I and inizio(i,in) and fine(i,fi) and ac_ut(a,u) and ora(ia,oia) and entrata(a,ia) and in <= oia <= fi and mese(adesso,m) and anno(adesso,an) and mese(ia,em) and anno(ia,ean) and em = m and ean = an}
        result = {(i,r) | r = |AM|/gm and i in I and AM = {(a1,i1) | (a1,i1) in A and i1 = i} and giorno(adesso,gm)}

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
        definizione operazione <= per le tuple (s,n):
            (s,n) <= (s1,n1) <=> n >= n1

        Sia S = {(tot,so) | tot = |U| and U = {u | EXISTS iu so_uti(so,u) and inizio(u,iu) and i <= iu <= f} }
        result = {s | exists (s1,n,i) in sorted(S) and s = s1 and i <= k}

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
        U = {u | exists ab ab_ut(a,u) and exists t inCorso_{Abbonamento, Data}(ab,t)}
        A = {u | exists a,t ac_ut(a,u) and entrata(a,t) and i <= t <= f}

        result = U \ A

create or replace function clientiInutili(i date, f date)
returns setof IndEmail as $$
begin

end;
$$ language plpgsql;

