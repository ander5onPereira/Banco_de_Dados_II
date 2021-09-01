-- VIEW SIMPLES
-- CREATE VIEW nome_view AS SELECT parameters, parameters FROM table


-- VIEW ROBUSTA
-- CREATE MATERIALIZED VIEW AS SELECT parameters, parameters FROM table

-- REFRESH MATERIALIZED VIEW [CONCURRENTLY] nomeview

-- 1° VIEW SIMPLES
-- RETORNA A QUANTIDADE DE EMPRESAS QUE OFERECE O SERVICO
CREATE VIEW qtdempresaservico AS
SELECT 	nome,
       	Count(fk_empresa) AS "Quantidade de empresas"
FROM 	servico
GROUP  BY nome; 


-- 2° VIEW SIMPLES
-- RETORNA AS CARACTERISTICAS DO CLIENTE COM ENDERECO
CREATE VIEW InfoCliente AS
SELECT 	Concat(nome, ' ', sobrenome),
       	telefone,
       	endereco.rua,
      	endereco.numero,
       	endereco.bairro,
       	endereco.cidade,
       	endereco.estado
FROM   	cliente
       	inner join endereco
               	ON cliente.fk_endereco = endereco.id_endereco; 