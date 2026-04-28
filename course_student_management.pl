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

% CONCLUIU - aluno concluiu o curso? 
% Verifica se um elemento está contido em uma lista
pertence(X, [X|_]). % X (primeiro elemento) pertence à lista se ele for o primeiro elemento
pertence(X, [_|R]) :- pertence(X, R). % Se não for o primeiro, procura no resto (R) da lista

% Verifica se o aluno (RA) foi aprovado na matéria (CodMateria) 
aprovado(RA, CodMateria) :-
    historico(RA, ListaHistorico), % Pega o histórico do aluno 
    
    % Procura dentro da ListaHistorico um registro dessa matéria e pega a nota e a frequência
    pertence(item(CodMateria, _, _, Nota, Frequencia), ListaHistorico), 
    Nota >= 5.0,
    Frequencia >= 0.75. 

% Verifica se o aluno concluiu o curso (aprovado em todas as matérias) 
todas_aprovadas(_, []). % Não tem mais matérias na lista, então o aluno já passou em todas

% O aluno (RA) passou em todas as matérias se: 
todas_aprovadas(RA, [M|R]) :-
    aprovado(RA, M), % Passou na primeira matéria (M)
    todas_aprovadas(RA, R). % E passou em todas as outras (R = resto) 

% O aluno (RA) concluiu o curso se: 
concluiu(RA, CodigoCurso) :-
    cursa(RA, CodigoCurso), % Ele está matriculado no curso
    curriculo(CodigoCurso, Materias), % Verifica quais matérias esse curso tem 
    todas_aprovadas(RA, Materias). % Passou em todas essas matérias

% FALTAS - quais matérias falta para o aluno terminar o curso 
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
    curriculo(CC, ListaMaterias), % Quais matérias esse curso tem?
    pega_faltas(RA, ListaMaterias, OQUE). % Dessas matérias, quais o aluno não passou?

% EXTRA - quais matérias o aluno fez que não pertencem ao curso
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

% CONTAGEM - conta quantas matérias o aluno passou e quantas matérias existem no curso
% Conta quantas matérias o aluno já passou
conta_aprovadas(_, [], 0). % Se não tem mais matérias, o total é 0

% Se passou na matéria, soma + 1
conta_aprovadas(RA, [H|T], N) :-
    aprovado(RA, H),
    conta_aprovadas(RA, T, N1),
    N is N1 + 1.

% Se não passou, não soma nada
conta_aprovadas(RA, [H|T], N) :-
    \+ aprovado(RA, H),
    conta_aprovadas(RA, T, N). % Continua contando o resto (sem somar)

% Conta quantas matérias existem no curso
conta_elementos([], 0). % Se a lista está vazia, não tem nenhum elemento

% Se a lista tem pelo menos 1 elemento...
conta_elementos([_|T], N) :-
    conta_elementos(T, N1), % Conta quantos elementos tem no resto da lista (T)
    N is N1 + 1 .% Soma +1 (por causa do elemento que foi ignorado no começo)

% PERCENTUAL - quantos % do curso o aluno já completou?
jafoi(RA, CC, QUANTO) :-
    curriculo(CC, ListaMaterias), % Pega as matérias do curso
    conta_aprovadas(RA, ListaMaterias, Feitas), % Conta quantas matérias o aluno já passou
    conta_elementos(ListaMaterias, Total), % Conta quantas matérias existem no curso
    QUANTO is (Feitas / Total) * 100.
