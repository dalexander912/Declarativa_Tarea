:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_files)).
:- consult('base.pl').

:- multifile user:file_search_path/2.
:- prolog_load_context(directory, Dir),
   directory_file_path(Dir, frontend, Frontend),
   asserta(user:file_search_path(frontend, Frontend)).

:- http_handler(root(.), http_reply_from_files(frontend, [indexes(['index.html'])]), [prefix]).
:- http_handler(root(consulta), consulta, []).

servidor :- http_server(http_dispatch, [port(8080)]).

consulta(Request) :- catch(resolver(Request), Error, responder_error(Error)).

resolver(Request) :-
    http_parameters(Request, [funcion(Texto, [atom]), a(A,[number]), b(B,[number])]),
    ( atom_length(Texto, Longitud), Longitud =< 1000 -> true
    ; throw(entrada('La expresion es demasiado larga.')) ),
    read_term_from_atom(Texto, Original, [variable_names(Nombres), syntax_errors(error)]),
    ( Nombres = [] -> true
    ; Nombres = [Nombre=X], memberchk(Nombre, ['X',x]) -> true
    ; throw(entrada('Utiliza una sola variable: X o x.')) ),
    normalizar(Original, X, F),
    ( s(X,F,P), area(X,F,A,B,Area) ->
        mostrar_primitiva(P, Primitiva), reply_json_dict(_{primitiva:Primitiva,area:Area})
    ; throw(entrada('Integral no soportada. En a^u utiliza u=m*x+c y a>0.')) ).

normalizar(T, X, X) :- var(T), !, T = X.
normalizar(x, X, X) :- !.
normalizar(T, _, T) :- number(T), !.
normalizar(T, X, F) :-
    compound(T), T =.. [Nombre|Args], length(Args,N),
    memberchk(Nombre/N, [(+)/2,(-)/2,(*)/2,(^)/2,(-)/1,sin/1,cos/1,tan/1,sinh/1,cosh/1,sh/1]), !,
    maplist(normalizar_argumento(X), Args, Nuevos),
    ( Nombre == sh -> Funcion = sinh ; Funcion = Nombre ),
    F =.. [Funcion|Nuevos].
normalizar(_, _, _) :- throw(entrada('Expresion no valida. Usa X o x y las operaciones soportadas.')).
normalizar_argumento(X,T,F) :- normalizar(T,X,F).

responder_error(entrada(Mensaje)) :- !,
    reply_json_dict(_{error:Mensaje}, [status(400)]).
responder_error(error(syntax_error(_),_)) :- !,
    reply_json_dict(_{error:'Revisa la sintaxis y los parentesis de la funcion.'}, [status(400)]).
responder_error(_) :-
    reply_json_dict(_{error:'No se pudo calcular. Revisa los datos y el dominio de la funcion.'}, [status(400)]).
