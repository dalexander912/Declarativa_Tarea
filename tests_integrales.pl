:- begin_tests(integrales).
:- consult(base).

comprobar(F,A,B,Esperado) :- term_variables(F,Variables), (Variables = [X] -> true ; Variables = []), area(X,F,A,B,R), assertion(abs(R-Esperado)<1.0e-9),
    s(X,F,P), T is (A+B)/2, H is 1.0e-5,
    T1 is T+H, T0 is T-H, evalS(X,P,T1,P1), evalS(X,P,T0,P0),
    evalS(X,F,T,Valor), Derivada is (P1-P0)/(2*H),
    assertion(abs(Derivada-Valor)<1.0e-6).

test(a_constante) :- comprobar(5,0,2,10).
test(b_variable) :- comprobar(X,0,2,2), var(X).
test(c_multiplo) :- comprobar(3*_X,0,2,6).
test(d_potencia) :- comprobar(_X^2,0,3,9).
test(d_menos_uno) :- E is log(2), comprobar(_X^(-1),1,2,E).
test(d_negativa) :- comprobar(_X^(-2),1,2,0.5).
test(f_multiplo_funcion) :- comprobar(2*sin(_X),0,pi,4).
test(g_suma) :- E is 14/3, comprobar(X^2+X,0,2,E).
test(h_resta) :- E is 2/3, comprobar(X^2-X,0,2,E).
test(i_exponencial) :- E is 1/log(2), comprobar(2^_X,0,1,E).
test(j_exponencial_afin) :- E is 3/log(2), comprobar(2^(2*_X+1),0,1,E).
test(j_pendiente_negativa) :- E is 3/(8*log(2)), comprobar(2^(-2*_X),0,1,E).
test(base_uno) :- comprobar(1^(2*_X+1),0,2,2).
test(exponente_constante) :- comprobar(2^(0*_X+3),0,2,16).
test(k_seno) :- comprobar(sin(_X),0,pi,2).
test(l_coseno) :- comprobar(cos(_X),0,pi/2,1).
test(m_tangente) :- E is log(2)/2, comprobar(tan(_X),0,pi/4,E).
test(q_seno_hiperbolico) :- E is cosh(1)-1, comprobar(sinh(_X),0,1,E).
test(r_coseno_hiperbolico) :- E is sinh(1), comprobar(cosh(_X),0,1,E).
test(negacion) :- comprobar(-_X,0,2,-2).
test(cero) :- comprobar(0,0,2,0).
test(limites_iguales) :- area(X,X^2,1,1,R), assertion(R=:=0).
test(limites_invertidos) :- area(X,X,2,0,R), assertion(R=:= -2).
test(singularidad, [throws(entrada(_))]) :- area(X,X^(-1),-1,1,_).
test(polo_tangente, [throws(entrada(_))]) :- area(X,tan(X),0,pi,_).
test(exponencial_no_lineal, [fail]) :- s(X,2^(X^2),_).
test(base_invalida, [fail]) :- s(X,(-2)^X,_).
:- end_tests(integrales).
