# 🎓 Sistema Acadêmico em Prolog

<p align="center">
  <img src="https://img.shields.io/badge/Prolog-SWI--Prolog-blue?style=for-the-badge&logo=prolog">
  <img src="https://img.shields.io/badge/Status-Concluído-success?style=for-the-badge">
  <img src="https://img.shields.io/badge/Projeto-Acadêmico-orange?style=for-the-badge">
</p>

## 📌 Sobre o Projeto
Este sistema utiliza o paradigma de Programação Lógica para modelar o fluxo acadêmico de uma instituição de ensino. Através de uma base de conhecimento composta por fatos e regras, o motor de inferência do Prolog é capaz de validar históricos escolares, calcular progressões e verificar requisitos de graduação de forma dinâmica.

## 🚀 Funcionalidades
- Verificação de Aprovação: Validação automática de notas e frequência.
- Análise Curricular: Identificação de conclusão de curso e matérias pendentes.
- Auditoria de Histórico: Detecção de disciplinas cursadas fora da grade (extras).
- Métricas de Desempenho: Cálculo em tempo real do percentual de conclusão.

## 🧠 Arquitetura do Sistema
```text
Aluno → Curso → Currículo → Matérias
          ↓
       Histórico → Regras → Consultas
```

## 🧩 Modelagem (Predicados)

| Predicado     | Descrição                     |
|--------------|------------------------------|
| `curso/2`     | Define cursos                |
| `materia/3`   | Define disciplinas           |
| `curriculo/2` | Relaciona curso e matérias   |
| `aluno/2`     | Cadastro de alunos           |
| `cursa/2`     | Matrícula do aluno           |
| `historico/2` | Notas e frequência           |

## 💻 Exemplos de Uso
No terminal do SWI-Prolog, você pode interagir com o sistema:
- Verificar conclusão de curso → concluiu(12909, 1).
- Disciplinas pendentes → falta(12090, 2, X).
- Percentual concluído → jafoi(12909, 1, P).
- Disciplinas extras → extra(12808, 1, X).

## ⚙️ Como Executar
1) Abra o SWI-Prolog
2) Carregue o arquivo
3) Execute as consultas desejadas

### 🛠️ Tecnologias e Conceitos
- Linguagem: Prolog (SWI-Prolog)
- Paradigma: Lógico (Declarativo)
- Técnicas: Recursão, Unificação, Manipulação de Listas e Backtracking.

## 👨‍💻 Autor
- Desenvolvido para fins acadêmicos na disciplina de Paradigmas de Programação
