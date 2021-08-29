analyze agenda;
analyze cliente;
analyze empresa;
analyze endereco;
analyze login;
analyze servico;

explain
SELECT cliente.nome as nome_cliente,cliente.cpf,agenda.id_agenda, agenda.data, 
servico.nome, servico.tipo, servico.descricao,  empresa.cnpj, empresa.email, 
empresa.nome, empresa.razao_social, empresa.telefone
FROM agenda INNER JOIN servico ON agenda.fk_servico=servico.id_servico 
inner join empresa on agenda.fk_empresa=empresa.cnpj
inner join cliente on agenda.fk_cliente=cliente.cpf
WHERE servico.nome='Dentista';

table login
table cliente
table agenda
SELECT * FROM login WHERE permissao = '0';

UPDATE login SET permissao=10 WHERE permissao >= '90';

UPDATE login SET permissao= 5 WHERE permissao >= '40' and permissao < '50';

SELECT * FROM login WHERE permissao >= '80' and permissao < '90';



