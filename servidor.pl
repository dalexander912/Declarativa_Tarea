:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_files)).

:- multifile user:file_search_path/2.

user:file_search_path(frontend, './frontend').

:- http_handler(root(.),
    http_reply_from_files(frontend, [indexes(['index.html'])]),
    [prefix]).

:- consult('base.pl').

:- http_handler(root(consulta), consulta, []).

servidor :-
    http_server(http_dispatch, [port(8080)]).

consulta(Request):-

    http_parameters(Request,
        [
            funcion(FuncionAtom, []),
            a(A, [number]),
            b(B, [number])
        ]),

    atom_to_term(FuncionAtom, F, _),
    
    ( s(X, F, Primitiva), mostrar_primitiva(Primitiva, PrimitivaStr), area(X, F, A, B, Area) ->
    
        reply_json_dict(_{
            primitiva: PrimitivaStr,
            area: Area
        })
    ;
        reply_json_dict(_{
            primitiva: "No se pudo realizar el calculo.",
            area: ""
        })
    ).