-- Listar a agenda de clientes agendados na empresa com contatos e dados do serviço --
CREATE OR REPLACE FUNCTION AgendaCliente(cnpj_search VARCHAR)
RETURNS TABLE (nome_cliente VARCHAR, cpf VARCHAR, telefone TEXT[], email VARCHAR, data timestamp with time zone, nome_servico VARCHAR, tipo VARCHAR, descricao TEXT) as $$
BEGIN
	RETURN QUERY SELECT cliente.nome as nome_cliente, cliente.cpf,cliente.telefone,login.email, 
	agenda.data, servico.nome as nome_servico, servico.tipo, servico.descricao
	FROM agenda 
	INNER JOIN servico ON agenda.fk_servico=servico.id_servico 
	INNER JOIN empresa on agenda.fk_empresa=empresa.cnpj
	INNER JOIN cliente on agenda.fk_cliente=cliente.cpf
	INNER JOIN login on cliente.fk_login=login.email
	WHERE empresa.cnpj = cnpj_search;
END
$$ LANGUAGE plpgsql;
DROP FUNCTION AgendaCliente
-- SELECT * FROM AgendaCliente(cnpj);


-- Buscar os clientes com agenda entre as datas --
CREATE OR REPLACE FUNCTION AgendaData(dia VARCHAR, mes VARCHAR, ano VARCHAR, cnpj_search VARCHAR)
RETURNS TABLE (nome_cliente VARCHAR, sobrenome VARCHAR, telefone TEXT[], email VARCHAR, cpf VARCHAR, data timestamp with time zone) as $$
DECLARE 
	mensagem VARCHAR;
BEGIN
	mensagem := CONCAT(ano,' year ', mes, ' month ', dia, ' day');
	RETURN QUERY SELECT cliente.nome as "nome_cliente",
			cliente.sobrenome,
			cliente.telefone,
			cliente.fk_login as "email",
			cliente.cpf,
			agenda.data
		from cliente 
	INNER JOIN agenda on agenda.fk_cliente=cliente.cpf
	INNER JOIN empresa on agenda.fk_empresa=empresa.cnpj
	where agenda.data BETWEEN (NOW() - mensagem::interval) AND NOW() AND empresa.cnpj = cnpj_search;
END
$$ LANGUAGE plpgsql;
-- SELECT * FROM AgendaData(dia, mes, ano, cnpj)


-- Buscar quantidade de clientes atendidos em um intervalo de data --
CREATE OR REPLACE FUNCTION QuantidadeCliente(dia VARCHAR, mes VARCHAR, ano VARCHAR)
RETURNS TABLE (cnpj VARCHAR, quantidade_cliente BIGINT) as $$
DECLARE 
	mensagem VARCHAR;
BEGIN
	mensagem := CONCAT(ano,' year ', mes, ' month ', dia, ' day');
	RETURN QUERY SELECT fk_empresa as "cnpj",
						COUNT(1) as "quantidade_cliente"
				FROM agenda
				WHERE agenda.data BETWEEN (NOW() - mensagem::interval) and NOW()
			GROUP BY fk_empresa;
END
$$ LANGUAGE plpgsql;
DROP FUNCTION QuantidadeCliente;
-- SELECT * FROM QuantidadeCliente(dia, mes, ano)