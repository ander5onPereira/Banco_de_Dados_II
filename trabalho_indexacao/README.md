<div align="center">

### Banco de Dados II
# Avaliação 1: Indexação

</div>

<div style="margin-top:15px;text-align: justify;border-bottom:1px;
  border-bottom-style: solid;
  border-bottom-color: darkgrey;">
<p>
Atividade realizada como parte da avaliação da disciplina de Banco de Dados II, com objetivo de aplicar o conhecimento demonstrado durante as aulas.
Os exercicios propostos estão apresentados no arquivo <a href='https://github.com/ander5onPereira/Banco_de_Dados_II/blob/93d38b47f35d4ae91f836e70c493574ed562a01a/trabalho_indexacao/Atividade_Indexes.pdf'>Atividade_Indexes</a>.
</p>

### Arquivos costantes nesse atividade

- <a href='https://github.com/ander5onPereira/Banco_de_Dados_II/blob/93d38b47f35d4ae91f836e70c493574ed562a01a/trabalho_indexacao/tb_aluno.sql'>tb_aluno</a> : sql para povoar tabela aluno
- <a href='https://github.com/ander5onPereira/Banco_de_Dados_II/blob/93d38b47f35d4ae91f836e70c493574ed562a01a/trabalho_indexacao/tb_discip.sql'>tb_discip</a> : sql para povoar tabela discip
- <a href='https://github.com/ander5onPereira/Banco_de_Dados_II/blob/93d38b47f35d4ae91f836e70c493574ed562a01a/trabalho_indexacao/tb_discip_update.sql'>tb_discip_update</a> : sql para atualizar campos de 'siglaprereq' 
- <a href='https://github.com/ander5onPereira/Banco_de_Dados_II/blob/93d38b47f35d4ae91f836e70c493574ed562a01a/trabalho_indexacao/tb_matricula.sql'>tb_matricula</a> : sql para povoar tabela matricula

</div>

<div >

## Criando tabalas

> Tabela aluno
```
CREATE TABLE aluno( nome VARCHAR(50) NOT NULL, ra DECIMAL(8) NOT NULL, dataNasc DATE NOT NULL, idade DECIMAL(3), nomemae VARCHAR(50) NOT NULL,cidade VARCHAR(30), estado CHAR(2), curso VARCHAR(50), periodo integer );
```
> Tabela discip
```
CREATE TABLE discip( sigla CHAR(7) NOT NULL, nome VARCHAR(25) NOT NULL, siglaprereq CHAR(7), nncred DECIMAL(2) NOT NULL, monitor DECIMAL(8), depto CHAR(8));
```
> Tabela matricula
```
CREATE TABLE matricula( ra DECIMAL(8) NOT NULL, sigla CHAR(7) NOT NULL, ano CHAR(4) NOT NULL, semestre CHAR(1) NOT NULL, codturma DECIMAL(4) NOT NULL, notap1 NUMERIC(3,1), notap2 NUMERIC(3,1), notatrab NUMERIC(3,1), notafim NUMERIC(3,1), frequencia DECIMAL(3));
```
## Alterações tabelas
```
ALTER TABLE aluno ADD CONSTRAINT pkAluno PRIMARY KEY (ra);

ALTER TABLE discip ADD CONSTRAINT fk_monitor FOREIGN KEY (monitor) REFERENCES aluno(RA) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE discip ADD CONSTRAINT pkSigla PRIMARY KEY (sigla);

ALTER TABLE discip ADD CONSTRAINT fk_sigla FOREIGN KEY (siglaprereq) REFERENCES discip(sigla) ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE matricula ADD CONSTRAINT fk_ra FOREIGN KEY (ra) REFERENCES aluno(ra) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE matricula ADD CONSTRAINT pk_ra_sigla_ano_semestre PRIMARY KEY (ra, sigla,ano, semestre);

ALTER TABLE matricula ADD CONSTRAINT fk_sigla FOREIGN KEY (sigla) REFERENCES discip(sigla) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE matricula ADD CONSTRAINT check_semestre CHECK (semestre = '1' or semestre = '2');

ALTER TABLE aluno ADD CONSTRAINT check_periodo CHECK (periodo <= 10 AND periodo >= 1);
```
> Atualização
```
analyze aluno;
analyze discip;
analyze matricula;
```

## Operações realizada na base sem índices
> Busca pelo nome img01
```
explain analyze SELECT * FROM Aluno where nome ='Antonella';
```
> Busca todas as tuplas em que o nome não sejá null img02
```
explain analyze select * from aluno	where nome IS NOT NULL;
```
> Busca de alunos no 10 periodo sem indexação img03
```
explain analyze select * from aluno where periodo=10;
```
> Busca nome do aluno com ra=36305122 img04
```
explain analyze select nome from aluno where ra = 36305122;
```
> Busca ra e idade do aluno com ra=36305122 img05
```
explain analyze select ra, idade from aluno	where ra = 36305122;
```
> Busca as disciplinas em que o aluno é monitos concatenando os dados do aluno com a disciplina img06 
```
explain analyze select * from aluno, discip where discip.monitor = aluno.ra and aluno.nome = 'Antonella';
```
> Lista todos dados do aluno junto com as materias que está matriculado img07
```
explain analyze select * from aluno A join matricula B on A.ra = B.ra;
```
> Busca por alunos que estão no 10 periodo img08
```
explain analyze select * from aluno where periodo=10;
```

## Criando índices para as operações

```
CREATE UNIQUE INDEX IdxAlunoNNI ON Aluno (Nome, NomeMae, Idade);

create extension btree_gin;
create index idxPeriodoBitmap on aluno using gin (periodo);

create index idxRaAluno on aluno (ra);

create index idxOnlyScanAgrVai on aluno(ra, idade);

create index idxRaEstrangeiro on aluno(ra);

create index idxIdade on aluno(idade);

alter table aluno cluster on idxidade;
analyze aluno;
cluster aluno;
```
>índice do json
```
create index idxTelefone on aluno using BTREE ((informacoesExtras->>'telefone'));
```

> Atualização
```
analyze aluno;
analyze discip;
analyze matricula;
```

## Operações realizada na base sem índices
>img09
```
explain analyze select * from Aluno	where nome ='Antonella';
```
>img10
```
explain analyze select * from aluno	where nome IS NOT NULL;
```
>img11
```
explain analyze select * from aluno	where periodo=10;
```
>img12
```
explain analyze select nome from aluno where ra=36305122;
```
>img13
```
explain analyze select ra, idade from aluno where ra=36305122;
```
>img14
```
explain analyze select * from aluno A join matricula B on A.ra = B.ra;
```
>img15
```
explain analyze select * from aluno	where periodo=10;
```
>img16
```
explain analyze select * from aluno	where idade=30;
```
>img17
```
explain analyze select * from aluno, discip where discip.monitor = aluno.ra and aluno.nome = 'Antonella';
```
>img18 - apos clusterizar
```
explain analyze select * from aluno	where idade=30;
```

>img19 - buscadndo telefone
```
explain analyze select * from aluno where informacoesExtras ->>'telefone' = '467777-7777';

```

>Add Json
```
alter table aluno add informacoesExtras jsonb;
```

> Populando json
```
update aluno set informacoesExtras=(('{"telefone":  "458998-8998 ","time":"Internacional "}')) where ra between 0 and 250000;

update aluno set informacoesExtras=(('{"telefone":  "461841-1651 ","time":"Fortaleza"}')) where ra between 250001 and 500000;

update aluno set informacoesExtras=(('{"telefone":  "467330-7557 ","time":" Flamengo"}')) where ra between 500001 and 800000;

update aluno set informacoesExtras=(('{"telefone":  "675566-6996 ","time":"Santos "}')) where ra > 800001;
``` 

</div>

