Uso:
--

1. Consultar servidor
```prolog
    ?- consult(['{ Dirección del proyecto }/servidor.pl']).
    true.
```

2. Levantar servidor
```prolog
    ?- servidor.
    % Started server at http://localhost:8080/
    true.
```

3. Establecer dirección de trabajo  
```prolog
    ?- working_directory(_, '{ Dirección del proyecto }').
    true.
```

4. Acceder a la interfaz

En un navegador acceder a http://localhost:8080
