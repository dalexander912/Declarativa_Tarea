# Calculadora de integrales en SWI-Prolog

Requiere SWI-Prolog. Desde la carpeta del proyecto:

```sh
swipl -q -s servidor.pl -g servidor -t "thread_get_message(stop)"
```

Abrir http://localhost:8080. Para detener el servidor de consola, usar Ctrl+C.

La interfaz usa JavaScript y consulta la base de conocimiento en Prolog.

## Expresiones admitidas

Se acepta una sola variable, X o x. Usar multiplicación explícita: `3*X`.

| Tipo del enunciado | Ejemplo |
|---|---|
| a: constante | `5` |
| b: variable | `X` |
| c: constante por variable | `3*X` |
| d: potencia | `X^2`, `X^(-1)` |
| f: constante por función | `2*sin(X)` |
| g: suma | `X^2+X` |
| h: resta | `X^2-X` |
| i: exponencial | `2^X` |
| j: exponencial con exponente lineal | `2^(2*X+1)` |
| k: seno | `sin(X)` |
| l: coseno | `cos(X)` |
| m: tangente | `tan(X)` |
| q: seno hiperbólico | `sinh(X)` o `sh(X)` |
| r: coseno hiperbólico | `cosh(X)` |

Se implementan ejemplos de 14 categorías; no es un integrador universal.
Para `a^u`, se requiere base numérica positiva y `u=m*x+c` con coeficientes numéricos. Exponentes no lineales se rechazan: no existe una fórmula elemental general para todos ellos.
La potencia `X^(-1)` produce `log(abs(X)) + C`.

El valor mostrado es la integral definida con signo F(b)-F(a); puede ser negativo. No representa automáticamente el área geométrica de una curva que cambia de signo. Se rechazan intervalos con singularidades de potencias o tangente, y cálculos fuera del dominio real.

## Pruebas

```sh
swipl -q -s tests_integrales.pl -g run_tests -t halt
```

Las pruebas comparan integrales definidas con valores conocidos y verifican numéricamente la derivada de las primitivas, además de casos inválidos y singularidades.
Los registros del servidor y los archivos locales de auditoría se excluyen con `.gitignore`.

La interfaz es adaptable a móviles, incluye ejemplos con un clic, cálculo con Enter, estados de carga y mensajes de validación. No requiere servicios externos ni dependencias de frontend.

## Entrega y ejecución desde ZIP

1. Instalar SWI-Prolog con sus bibliotecas estándar HTTP y disponer de un navegador actualizado.
2. Extraer el ZIP completo. Mantener `base.pl`, `servidor.pl` y la carpeta `frontend` con sus tres archivos juntos.
3. Abrir una terminal en la carpeta extraída y ejecutar el comando de inicio indicado arriba. Si `swipl` no se reconoce, usar la ruta del ejecutable o la consola de SWI-Prolog.
4. En la consola de SWI-Prolog también se puede cargar `servidor.pl` con File > Consult y ejecutar `servidor.`.
5. Abrir http://localhost:8080 en el navegador. El puerto 8080 debe estar libre.

No requiere Python, Node.js, Java, C++, paquetes de frontend ni conexión a Internet para ejecutar la calculadora. Python solo se usó en comprobaciones locales que no forman parte de la entrega. No abrir `index.html` directamente: la interfaz debe accederse a través del servidor Prolog.
