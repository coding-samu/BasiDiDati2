-- implementazione operazioni Crociera

create or replace function data_fine_crociera(this Crociera)
returns TIMESTAMP
as $$
begin
    istante := (
        select i.istante_arrivo
        from itinerario as i
        where this.itinerario = i.nome
    )
    return (make_interval(days => istante.giorno) + istante.ora) + this.data_
end;
$$
language plpgsql;