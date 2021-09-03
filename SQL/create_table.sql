
-- CRIANDO TABLE LOGIN --
CREATE TABLE login (
	email VARCHAR(50) NOT NULL,
	senha VARCHAR(15) NOT NULL,
	permissao CHAR(2) NOT NULL,
	constraint pk_login primary key (email),
);
-- CRIANDO TABLE ENDEREÇO
CREATE TABLE endereco (
	id_endereco BIGSERIAL NOT NULL,
	cep VARCHAR(8),
	pais VARCHAR(50),
	estado VARCHAR(50),
	cidade VARCHAR(80),
	bairro VARCHAR(100),
	rua VARCHAR(255),
	complemento VARCHAR(255),
	numero DECIMAL(8),
	constraint pk_endereco primary key(id_endereco),
);
-- CRIANDO TABLE CLIENTE --
CREATE TABLE cliente (
	cpf VARCHAR(11) NOT NULL,
	nome VARCHAR(20) NOT NULL,
	sobrenome VARCHAR(100),
	telefone text[],
	fk_login VARCHAR references login(email) ON DELETE CASCADE ON UPDATE CASCADE,
	fk_endereco BIGINT references endereco(id_endereco) ON DELETE CASCADE ON UPDATE CASCADE,
	constraint pk_cpf primary key(cpf),
);

-- CRIANDO TABLE EMPRESA --
CREATE TABLE empresa (
	cnpj VARCHAR(14) NOT NULL,
	email VARCHAR(50) NOT NULL,
	nome VARCHAR(50) NOT NULL,
	razao_social VARCHAR(50) NOT NULL,
	telefone text[],
	fk_login VARCHAR references login(email) ON DELETE CASCADE ON UPDATE CASCADE,
	fk_endereco BIGINT references endereco(id_endereco) ON DELETE CASCADE ON UPDATE CASCADE,
	constraint pk_cnpj primary key(cnpj),
);

-- CRIANDO TABLE SERVICO --
CREATE TABLE servico (
	id_servico BIGSERIAL NOT NULL,
	nome VARCHAR(255) NOT NULL,
	tipo VARCHAR(150) NOT NULL,
	descricao TEXT,
	fk_empresa VARCHAR references empresa(cnpj) ON DELETE CASCADE ON UPDATE CASCADE,
	constraint pk_servico primary key(id_servico),
);

-- CRIANDO TABLE AGENDA --
CREATE TABLE agenda (
	id_agenda BIGSERIAL NOT NULL,
	data timestamp with time zone NOT NULL,
	fk_cliente VARCHAR references cliente(cpf) ON DELETE CASCADE ON UPDATE CASCADE,
	fk_empresa VARCHAR references empresa(cnpj) ON DELETE CASCADE ON UPDATE CASCADE,
	fk_servico BIGINT references servico(id_servico) ON DELETE CASCADE ON UPDATE CASCADE,
	constraint pk_agenda primary key(id_agenda, data),
);