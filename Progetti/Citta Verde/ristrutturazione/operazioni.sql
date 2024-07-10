-- Operazioni della classe Squadra

    TODO
    numOperatori(d DataOra): InteroGEZ
        precondizioni:
            (ALL i inizio(this,i) -> i <= d) and (ALL f fine(this,f) -> d <= f)
        postcondizioni:
            Sia O = {o | exists p op_par(o,p) and par_sq(p,this) and (ALL i inizio(p,i) -> i <= d) and (ALL f fine(p,f) -> d <= f)}
            result = |O|

    TODO
    attrezzaturaUsabile(d DataOra): Attrezzatura [0..*]
        precondizioni:
            (ALL i inizio(this,i) -> i <= d) and (ALL f fine(this,f) -> d <= f)
        postcondizioni:
            Sia A = {a | EXISTS o, p, pu par_sq(p,this) and op_par(o,p) and op_pu(o,pu) and attr_pu(a,pu) and (ALL i inizio(p,i) -> i <= d) and (ALL f fine(p,f) -> d <= f) and (ALL i inizio(pu,i) -> i <= d) and (ALL f fine(pu,f) -> d <= f)}
            result = A

-- Operazioni della classe Intervento

    TODO
    attrezzaturaRichiesta(): Attrezzatura [0..*]
        precondizioni:
            nessuna
        postcondizioni:
            Sia A = {a | EXISTS ta int_ta(this,ta) and attr_ta(a,ta)}
            result = A