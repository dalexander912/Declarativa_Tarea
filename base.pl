% Base de conocimiento: integracion simbolica en una variable.

s(X, F, _) :- var(F), F \== X, !, fail.
s(X, K, K*X) :- var(X), number(K), !.
s(X, F, X^2/2) :- var(X), F == X, !.
s(X, X^N, log(abs(X))) :- var(X), number(N), N =:= -1, !.
s(X, X^N, X^M/M) :- var(X), number(N), M is N+1, !.
s(X, -U, -P) :- var(X), s(X, U, P), !.
s(X, K*U, K*P) :- var(X), number(K), s(X, U, P), !.
s(X, U*K, K*P) :- var(X), number(K), s(X, U, P), !.
s(X, U+V, P+Q) :- var(X), s(X, U, P), s(X, V, Q), !.
s(X, U-V, P-Q) :- var(X), s(X, U, P), s(X, V, Q), !.
% a^u: se admite u=m*x+c. No hay una regla elemental general para todo u.
s(X, A^U, P) :-
    var(X), number(A), A > 0, afin(X, U, M, C),
    ( A =:= 1 -> P = X
    ; M =:= 0 -> K is A^C, P = K*X
    ; P = A^U/(M*log(A)) ), !.
s(X, sin(X), -cos(X)) :- var(X), !.
s(X, cos(X), sin(X)) :- var(X), !.
s(X, tan(X), -log(abs(cos(X)))) :- var(X), !.
% Dos tipos adicionales de la lista para superar el minimo de doce.
s(X, sinh(X), cosh(X)) :- var(X), !.
s(X, cosh(X), sinh(X)) :- var(X), !.

afin(X, U, 1, 0) :- U == X, !.
afin(_, U, 0, U) :- number(U), !.
afin(X, -U, M, C) :- afin(X, U, A, B), M is -A, C is -B.
afin(X, K*U, M, C) :- number(K), afin(X, U, A, B), M is K*A, C is K*B.
afin(X, U*K, M, C) :- number(K), afin(X, U, A, B), M is K*A, C is K*B.
afin(X, U+V, M, C) :- afin(X,U,A,B), afin(X,V,D,E), M is A+D, C is B+E.
afin(X, U-V, M, C) :- afin(X,U,A,B), afin(X,V,D,E), M is A-D, C is B-E.

% Comprobar todo el intervalo, no solamente sus extremos.
dominio(X, F, _, _) :- F == X, !.
dominio(_, F, _, _) :- number(F), !.
dominio(X, F, A, B) :- nonvar(F), F = Base^N, Base == X, number(N), !,
    L is min(A,B), H is max(A,B),
    ( N < 0, L =< 0, H >= 0 -> throw(entrada('El intervalo cruza una singularidad en x=0.')) ; true ),
    ( N =\= round(N), L < 0 -> throw(entrada('La potencia no es real en todo el intervalo.')) ; true ).
dominio(X, tan(X), A, B) :- !,
    L is min(A,B), H is max(A,B),
    K is ceiling((L-pi/2)/pi-1.0e-12), Polo is pi/2+K*pi,
    ( Polo =< H+1.0e-12 -> throw(entrada('La tangente tiene una singularidad en el intervalo.')) ; true ).
dominio(_, F, _, _) :- nonvar(F), F = _^_, !.
dominio(X, F, A, B) :- compound(F), F =.. [_|Args],
    maplist(dominio_argumento(X,A,B), Args).
dominio_argumento(X,A,B,F) :- dominio(X,F,A,B).

evalS(X, F, Valor, Resultado) :-
    copy_term(X-F, Y-G), Y = Valor, Resultado is G.

area(X, F, A, B, Area) :-
    s(X, F, P), dominio(X,F,A,B),
    evalS(X,P,B,FB), evalS(X,P,A,FA), Area is FB-FA,
    ( float(Area) -> float_class(Area, Clase), memberchk(Clase,[normal,subnormal,zero]) ; true ).

mostrar_primitiva(P, Texto) :-
    copy_term(P, Copia), term_variables(Copia, Variables),
    maplist(=(x), Variables), term_string(Copia, Expresion),
    string_concat(Expresion, ' + C', Texto).
