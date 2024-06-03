-- usecase ottieniPlaylist

create or replace function ottieniPlaylist(this Utente)
returns setof Playlist as
$$
begin

return query
select p.*
from Playlist as p
where p.utente = this.nome and p.stato = 'Pubblica';

end;
$$
language plpgsql;

-- usecase ricercaVideoTag

create or replace function ricercaVideoTag(c Categoria, t Tag[], val Voto)
returns setof Video
as $$
    begin
        return query (
            select v.*
            from Video v
            where v.categoria = c.nome and exists (
                select *
                from tagVid as tv, unnest(t) as ut
                where tv.video = v.id and tv.tag = ut.nome
            ) and (
                numeroValutazioni(v) = 0 or mediaValutazioni(v) >= val
            )
        );
    end;
$$ language plpgsql;


-- usecase Video con tante risposte

create or replace function ricercaVideoMaggiorRisposta(c Categoria)
returns setof Video
as $$
begin
    return query
    with video_risposta as (
        select v2.id as video,count(v1.id) as occorrenze
        from Video v1,Video v2
        where v1.super_vid = v2.id and v1.categoria = c.nome and not exists(
            select *
            from VideoCensurato as vc
            where v2.id = vc.video
        )
        group by v2.id
    )
    select v.*
    from video_risposta as vr, Video v
    where vr.video = v.id
    order by vr.occorrenze desc;
end;
$$ language plpgsql;
