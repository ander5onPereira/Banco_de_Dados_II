-- RETORNA A QUANTIDADE DE EMPRESAS QUE OFERECE O SERVICO
CREATE VIEW qtdempresaservico AS
SELECT 	nome,
       	Count(fk_empresa) AS "Quantidade de empresas"
FROM 	servico
GROUP  BY nome; 


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


-- RETORNA AS EMPRESAS QUE POSSUEM FILIAIS
CREATE VIEW EmpFilias AS
SELECT 	empresa.cnpj, 
		COUNT(endereco.id_endereco) AS "qtd" 
FROM 	empresa
	INNER JOIN endereco ON empresa.fk_endereco = endereco.id_endereco
	GROUP BY empresa.cnpj
	HAVING COUNT(endereco.id_endereco) > 1;