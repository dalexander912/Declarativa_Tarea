% --------------
% - INTEGRALES -
% --------------

% a) Integral de k
s(Var, K, K*Var):-
    var(Var), number(K), !.

% b) Integral de x
s(Var, Var, (Var^2)/2):-
    var(Var), !.

% c) Integral de kx
s(Var, K*Var, C*Var^2):-
    var(Var), number(K),
    C is K/2, !.

% d) Integral de x^n
s(Var, Var^N, (Var^C)/C):-
    var(Var), number(N),
    C is N+1, !.

% Integral de kx^n
s(Var, K*Var^N, C2*Var^C):-
    var(Var), number(K), number(N),
    C is N+1, C2 is K/C, !.

% f) Integral de ku
s(Var, K*U, K*IU):-
    var(Var), number(K), s(Var, U, IU), !.

% g) Integral de u + v
s(Var, U + V, IU + IV):-
    var(Var), s(Var, U, IU), s(Var, V, IV), !.

% h) Integral de u - v
s(Var, U - V, IU - IV):-
    var(Var), s(Var, U, IU), s(Var, V, IV), !.

% i) Integral de a^x
s(Var, A^Var, log(A)*(A^Var)):-
    var(Var), number(A), !.

% j) Integral de a^u
s(Var, A^U, log(A)*(A^Var)*IU):-
    var(Var), number(A), s(Var, U, IU), !.

% k) Integral de sen(x)
s(Var, sin(Var), -cos(Var)):-
    var(Var), !.

% l) Integral de cos(x)
s(Var, cos(Var), sin(Var)):-
    var(Var), !.

% m) Integral de tan(x)
s(Var, tan(Var), -log(abs(cos(Var)))):-
    var(Var), !.

% --------------
% - EVALUACION -
% --------------

% Se crean copias de las variables para evitar que se modifiquen los valores originales durante la evaluación.
evalS(Var, F, Valor, Resultado) :-
    copy_term(Var-F, Var2-F2),
    Var2 = Valor,
    Resultado is F2.

area(Var, F, A, B, Area) :-
    s(Var, F, Primitiva),
    evalS(Var, Primitiva, B, FB),
    evalS(Var, Primitiva, A, FA),
    Area is FB - FA.

% Función auxiliar para mostrar la primitiva en formato de texto adecuadamente.
mostrar_primitiva(Primitiva, Texto) :-
    copy_term(Primitiva, Copia),
    term_variables(Copia, [Var]),
    Var = x,
    term_string(Copia, Texto).