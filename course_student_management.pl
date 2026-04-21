% Define quais cursos existem 
% Estrutura: curso(codigo_curso, nome_curso)
curso(1,informatica).
curso(2,eletro_eletronica).

% Define quais matérias existem 
% Estrutura: materia(codigo_materia, nome_materia, aulas_por_semana)
materia(1,tecnicas_de_programacao,8).
materia(2,programacao_orientada_a_objetos,5).
materia(3,estruturas_de_dados,4).
materia(4,topicos_em_metodologias_de_programacao,3).
materia(5,circuitos_eletricos,4).
materia(6,eletronica_digital,5).
materia(7,arquitetura_computadores,6).
materia(8,microcontroladores,4).

% Curriculo de cada curso 
% Estrutura: curriculo(codigo_curso, lista_de_materias)
curriculo(1,[1,2,3,4]). % O curso de código 1 tem as matérias 1,2,3,4
curriculo(2,[5,6,7,8]).

% Define os alunos
% Estrutura: aluno(ra, nome)
aluno(12808,jose).
aluno(12080,marcos).
aluno(12909,joao).
aluno(12090,ana).

% Define o que o aluno cursa 
% Estrutura: cursa(ra, codigo_curso)
cursa(12909,1).
cursa(12080,2).
cursa(12090,2).

% Histórico escolar de cada aluno 
% Estrutura: item(cod_materia, semestre, ano, nota, frequencia)
historico(12808,
[
item(1,1,2012,3.0,0.77),
item(1,2,2013,6.5,0.90),
item(5,1,2014,8.0,0.80)
]).

historico(12909,
[
item(1,1,2012,7.0,0.80),
item(2,2,2013,8.5,0.80),
item(3,1,2014,5.0,0.75)
]).

historico(12080,
[
item(5,1,2012,6.0,0.70),
item(5,2,2013,7.5,0.90),
item(6,1,2014,5.0,0.90)
]).

historico(12090,
[
item(7,1,2012,6.0,0.75),
item(8,2,2014,8.0,0.89)
]).

% Criando a regra aprovado que verifica se o aluno foi aprovado na materia 
% Aprovado se: nota >= 6 e frequencia >= 0.75
aprovado(RA,CodigoMateria) :-
	
    % Busca o histórico do aluno 
    historico(RA,ListaHistorico),
	
    % Verifica se algo está dentro de uma lista (member) 
    member(
        item(CodigoMateria,_,_,Nota,Frequencia),
        ListaHistorico
    ),
	
    Nota >= 6, % Verifica se a nota do aluno é maior ou igual a 6 
    Frequencia >= 0.75. % Verifica se a frequência é pelo menos 75%

% Cria a regra concluiu que verifica se o aluno concluiu o curso 
% Ele precisa estar aprovado em TODAS as materias do curriculo
concluiu(RA,CodigoCurso) :-
	
    % Pega as matérias obrigatórias do curso 
    curriculo(CodigoCurso,ListaMaterias),

    forall(
        member(CodigoMateria,ListaMaterias),
        aprovado(RA,CodigoMateria)
    ).

% Cria a regra falta que lista quais materias ainda faltam para concluir o curso 
falta(RA,CodigoCurso,ListaMateriasFaltantes) :-
	
    % Pega as matérias obrigatórias do curso 
    curriculo(CodigoCurso,ListaMaterias),

    findall(
        NomeMateria,
        
        (
            member(CodigoMateria,ListaMaterias),
            \+ aprovado(RA,CodigoMateria),
            materia(CodigoMateria,NomeMateria,_)
        ),
        
        ListaMateriasFaltantes
    ).

% Cria a regra extra que mostra quais materias o aluno fez, mas que não pertencem ao curso dele 
extra(RA,CodigoCurso,ListaMateriasExtras) :-
	
    % Pega o histórico escolar do aluno 
    historico(RA,ListaHistorico),
	
    % Pega as matérias obrigatorias do curso 
    curriculo(CodigoCurso,ListaMateriasCurso),

    findall(
        NomeMateria,
        (

            member(
                item(CodigoMateria,_,_,_,_),
                ListaHistorico
            ),
            
            \+ member(CodigoMateria,ListaMateriasCurso),
            materia(CodigoMateria,NomeMateria,_)
        ),
        
        ListaMateriasExtras
    ).

% Cria a regra jafoi que mostra qual porcentual do curso o aluno já concluiu
jafoi(RA,CodigoCurso,PercentualConcluido) :-
	
    % Pega as matérias obrigatorias do curso 
    curriculo(CodigoCurso,ListaMateriasCurso),
	
    % Conta quantas materias obrigatorias o curso tem, ou seja, quantos elementos tem dentro da lista 
    length(ListaMateriasCurso,TotalMaterias),

    findall(
        CodigoMateria,
        (
            member(CodigoMateria,ListaMateriasCurso),
            aprovado(RA,CodigoMateria)
        ),

        ListaMateriasFeitas
    ),
	
    % Conta quantas materias o aluno ja concluiu 
    length(ListaMateriasFeitas,QuantidadeFeitas),
	
    % Calcula a pocentagem do curso do aluno
    PercentualConcluido is
        (QuantidadeFeitas / TotalMaterias) * 100.
