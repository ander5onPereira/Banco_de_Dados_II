-- Listar a agenda de clientes agendados na empresa com contatos e dados do serviço --
SELECT cliente.nome as nome_cliente, cliente.cpf,cliente.telefone,login.email, 
agenda.data, servico.nome as nome_servico, servico.tipo, servico.descricao
FROM agenda 
INNER JOIN servico ON agenda.fk_servico=servico.id_servico 
inner join empresa on agenda.fk_empresa=empresa.cnpj
inner join cliente on agenda.fk_cliente=cliente.cpf
inner join login on cliente.fk_login=login.email
WHERE empresa.cnpj='52157974615693';

-- buscar empresas e serviços em que o cliente realizou agendamento --
SELECT	Em.nome,Em.razao_social,Em.telefone,Em.email, Ag.data,
Se.nome,Se.tipo
FROM cliente as Cl
INNER JOIN agenda as Ag on Ag.fk_cliente=Cl.cpf 
INNER JOIN empresa as Em on Ag.fk_empresa=Em.cnpj
INNER JOIN servico as Se on Ag.fk_servico=Se.id_servico
WHERE Cl.cpf='83684665942';

-- buscar empresa com tipo especifico no estado determinado -- 
SELECT * FROM endereco as EN
INNER JOIN empresa as EM on EM.fk_endereco=EN.id_endereco
INNER JOIN servico as SE on SE.fk_empresa=EM.cnpj
WHERE EN.estado='jY' AND SE.tipo='Dentista';


select fk_empresa from servico where nome='Desenvolvimento'; 

select * from cliente where nome='vaer';