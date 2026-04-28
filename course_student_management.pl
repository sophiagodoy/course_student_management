% Banco de conhecimentos
% Cursos - curso(id_curso, nome_do_curso)
curso(1, informatica).
curso(2, eletro_eletronica).

% Materias - materia(id_materia, nome_da_materia, aulas_por_semana)
materia(1, tecnicas_de_programacao, 8).
materia(2, programacao_orientada_a_objetos, 5).
materia(3, estruturas_de_dados, 4).
materia(4, topicos_em_metodologias_de_programacao, 3).
materia(5, circuitos_eletricos, 4).
materia(6, eletronica_digital, 5).
materia(7, arquitetura_computadores, 6).
materia(8, microcontroladores, 4).

% Curriculo - curriculo(id_curso, lista_de_ids_das_materias)
curriculo(1, [1,2,3,4]). % O curso 1 tem as matérias 1,2,3,4
curriculo(2, [5,6,7,8]).

% Alunos - aluno(ra_do_aluno, nome_do_aluno)
aluno(12808, jose).
aluno(12080, marcos).
aluno(12909, joao).
aluno(12090, ana).

% Quem cursa o que - cursa(ra_do_aluno, id_curso)
cursa(12909, 1).
cursa(12080, 2).
cursa(12090, 2).

% Historico - historico(ra_do_aluno, lista_de_itens)
historico(12808, [
    % Item - representa uma disciplina que o aluno cursou
    % item(id_materia, semestre, ano, nota, frequencia)
    item(1,1,2012,3.0,0.77),
    item(1,2,2013,6.5,0.90),
    item(5,1,2014,8.0,0.80)
]).

historico(12909, [
    item(1,1,2012,7.0,0.80),
    item(2,2,2013,8.5,0.80),
    item(3,1,2014,5.0,0.75)
]).

historico(12080, [
    item(5,1,2012,6.0,0.70),
    item(5,2,2013,7.5,0.90),
    item(6,1,2014,5.0,0.90)
]).

historico(12090, [
    item(7,1,2012,6.0,0.75),
    item(8,2,2014,8.0,0.89)
]).

% CONCLUIU 
% Verifica se um elemento está contido em uma lista
pertence(X, [X|_]). % Se o primeiro da lista for igual ao X 
pertence(X, [_|R]) :- pertence(X, R). % Se não for o primeiro, ignora ele e procura no resto

% Verifica se o aluno foi aprovado na matéria 
aprovado(RA, CodMateria) :-
    historico(RA, ListaHistorico), 
    
    % Procura no histórico um item dessa matéria
    pertence(item(CodMateria, _, _, Nota, Frequencia), ListaHistorico), 
    Nota >= 5.0,
    Frequencia >= 0.75. 

% Verifica se o aluno concluiu o curso 
todas_aprovadas(_, []). % Se o aluno não tem amis matérias ele já passou em todas

% O aluno passou na primeira matéria e também passou em todas as outras
todas_aprovadas(RA, [M|R]) :-
    aprovado(RA, M),
    todas_aprovadas(RA, R).

concluiu(RA, CodigoCurso) :-
    cursa(RA, CodigoCurso), % O aluno faz esse curso?
    curriculo(CodigoCurso, Materias), % Quais matérias esse curso tem?
    todas_aprovadas(RA, Materias). % O aluno passou em todas essas matérias?

% FALTAS 
% Verifica quais matérias falta para o aluno terminar o curso 
pega_faltas(_, [], []). % Se não tem mais matérias, não falta nada

% Se o aluno NÃO passou na matéria, coloca ela na lista de faltas
pega_faltas(RA, [H|T], [Nome|Resto]) :-
    \+ aprovado(RA, H), % O aluno não passou nessa materia 
    materia(H, Nome, _), % Pega o nome da materia 
    pega_faltas(RA, T, Resto). % Adiciona o nome na lista 

% Se o aluno JÁ passou nessa matéria, ignora ela
pega_faltas(RA, [H|T], Resto) :-
    aprovado(RA, H), % O aluno passou nessa matéria?
    pega_faltas(RA, T, Resto). % Verifica se ele passou no resto da lista 

falta(RA, CC, OQUE) :-
    cursa(RA, CC), % O aluno faz esse curso?
    curriculo(CC, ListaMaterias), % Quais matérias esse curso tem?”
    pega_faltas(RA, ListaMaterias, OQUE). % Dessas matérias, quais o aluno não passou?

% EXTRA
% Quais matérias o aluno fez que NÃO pertencem ao curso?
pega_extra(_, _, [], []). % Se não tem mais histórico, acabou 

% Quando a matéria é extra...
pega_extra(RA, Curriculo, [item(CM,_,_,_,_)|T], [Nome|Resto]) :-
    aprovado(RA, CM), % Aluno passou 
    \+ pertence(CM, Curriculo), % Não está no curso do aluno 
    materia(CM, Nome, _),
    pega_extra(RA, Curriculo, T, Resto).

% Quando a matéria não é extra...
pega_extra(RA, Curriculo, [_|T], Resto) :-
    pega_extra(RA, Curriculo, T, Resto).

extra(RA, CC, QUAIS) :-
    cursa(RA, CC),
    curriculo(CC, ListaMaterias),
    historico(RA, Historico),
    pega_extra(RA, ListaMaterias, Historico, QUAIS).

% CONTAGEM
% Conta quantas matérias o aluno passou e quantas matérias existem no curso

% Se não tem mais matérias, o total é 0
conta_aprovadas(_, [], 0).

% Se passou na matéria, soma + 1
conta_aprovadas(RA, [H|T], N) :-
    aprovado(RA, H),
    conta_aprovadas(RA, T, N1),
    N is N1 + 1.

% Se não passou, não soma nada
conta_aprovadas(RA, [H|T], N) :-
    \+ aprovado(RA, H),
    conta_aprovadas(RA, T, N).

conta_elementos([], 0).

conta_elementos([_|T], N) :-
    conta_elementos(T, N1),
    N is N1 + 1.

% PERCENTUAL
% Quantos % do curso o aluno já completou?
jafoi(RA, CC, QUANTO) :-
    curriculo(CC, ListaMaterias),
    conta_aprovadas(RA, ListaMaterias, Feitas),
    conta_elementos(ListaMaterias, Total),
    QUANTO is (Feitas / Total) * 100.
