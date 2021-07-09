/* Banco_Dados_II_Logico: */

CREATE TABLE Agendamento (
    hora DATE,
    data DATE,
    id INTEGER PRIMARY KEY
);

CREATE TABLE Servico (
    tipo VARCHAR,
    descricao VARCHAR,
    nome VARCHAR,
    id INTEGER PRIMARY KEY
);

CREATE TABLE Empresa (
    cnpj VARCHAR PRIMARY KEY,
    nome VARCHAR,
    razao_social VARCHAR,
    emaill VARCHAR,
    id_endereco INTEGER
);

CREATE TABLE Endereco (
    id INTEGER PRIMARY KEY,
    cep VARCHAR,
    rua VARCHAR,
    bairro VARCHAR,
    cidade VARCHAR,
    pais VARCHAR,
    numero NUMERIC,
    complemento VARCHAR
);

CREATE TABLE Cliente_Login (
    cpf VARCHAR,
    nome VARCHAR,
    id_login NUMERIC,
    sobrenome VARCHAR,
    token VARCHAR,
    permissao DECIMAL,
    email VARCHAR,
    senha VARCHAR,
    fk_Endereco_id INTEGER,
    PRIMARY KEY (id_login, email)
);

CREATE TABLE telefones (
    id_empresa NUMERIC,
    contato VARCHAR,
    id INTEGER PRIMARY KEY
);

CREATE TABLE servico_prestado (
    fk_Servico_id INTEGER,
    fk_Empresa_cnpj VARCHAR
);

CREATE TABLE fornece (
    fk_Empresa_cnpj VARCHAR,
    fk_Agendamento_id INTEGER
);

CREATE TABLE agendar (
    fk_Cliente_Login_id_login NUMERIC,
    fk_Agendamento_id INTEGER
);

CREATE TABLE login_empresa (
    fk_Empresa_cnpj VARCHAR,
    fk_Cliente_Login_id_login NUMERIC,
    fk_Cliente_Login_email VARCHAR
);

CREATE TABLE endereco_empresa (
    fk_Endereco_id INTEGER,
    fk_Empresa_cnpj VARCHAR
);

CREATE TABLE telefone_empresa (
    fk_Empresa_cnpj VARCHAR,
    fk_telefones_id INTEGER
);

CREATE TABLE telefone_cliente (
    fk_Cliente_Login_id_login NUMERIC,
    fk_Cliente_Login_email VARCHAR,
    fk_telefones_id INTEGER
);
 
ALTER TABLE Cliente_Login ADD CONSTRAINT FK_Cliente_Login_2
    FOREIGN KEY (fk_Endereco_id)
    REFERENCES Endereco (id)
    ON DELETE RESTRICT;
 
ALTER TABLE servico_prestado ADD CONSTRAINT FK_servico_prestado_1
    FOREIGN KEY (fk_Servico_id)
    REFERENCES Servico (id)
    ON DELETE RESTRICT;
 
ALTER TABLE servico_prestado ADD CONSTRAINT FK_servico_prestado_2
    FOREIGN KEY (fk_Empresa_cnpj)
    REFERENCES Empresa (cnpj)
    ON DELETE RESTRICT;
 
ALTER TABLE fornece ADD CONSTRAINT FK_fornece_1
    FOREIGN KEY (fk_Empresa_cnpj)
    REFERENCES Empresa (cnpj)
    ON DELETE RESTRICT;
 
ALTER TABLE fornece ADD CONSTRAINT FK_fornece_2
    FOREIGN KEY (fk_Agendamento_id)
    REFERENCES Agendamento (id)
    ON DELETE SET NULL;
 
ALTER TABLE agendar ADD CONSTRAINT FK_agendar_1
    FOREIGN KEY (fk_Cliente_Login_id_login, ???)
    REFERENCES Cliente_Login (id_login, ???)
    ON DELETE SET NULL;
 
ALTER TABLE agendar ADD CONSTRAINT FK_agendar_2
    FOREIGN KEY (fk_Agendamento_id)
    REFERENCES Agendamento (id)
    ON DELETE SET NULL;
 
ALTER TABLE login_empresa ADD CONSTRAINT FK_login_empresa_1
    FOREIGN KEY (fk_Empresa_cnpj)
    REFERENCES Empresa (cnpj)
    ON DELETE RESTRICT;
 
ALTER TABLE login_empresa ADD CONSTRAINT FK_login_empresa_2
    FOREIGN KEY (fk_Cliente_Login_id_login, fk_Cliente_Login_email)
    REFERENCES Cliente_Login (id_login, email)
    ON DELETE RESTRICT;
 
ALTER TABLE endereco_empresa ADD CONSTRAINT FK_endereco_empresa_1
    FOREIGN KEY (fk_Endereco_id)
    REFERENCES Endereco (id)
    ON DELETE RESTRICT;
 
ALTER TABLE endereco_empresa ADD CONSTRAINT FK_endereco_empresa_2
    FOREIGN KEY (fk_Empresa_cnpj)
    REFERENCES Empresa (cnpj)
    ON DELETE SET NULL;
 
ALTER TABLE telefone_empresa ADD CONSTRAINT FK_telefone_empresa_1
    FOREIGN KEY (fk_Empresa_cnpj)
    REFERENCES Empresa (cnpj)
    ON DELETE RESTRICT;
 
ALTER TABLE telefone_empresa ADD CONSTRAINT FK_telefone_empresa_2
    FOREIGN KEY (fk_telefones_id)
    REFERENCES telefones (id)
    ON DELETE SET NULL;
 
ALTER TABLE telefone_cliente ADD CONSTRAINT FK_telefone_cliente_1
    FOREIGN KEY (fk_Cliente_Login_id_login, fk_Cliente_Login_email)
    REFERENCES Cliente_Login (id_login, email)
    ON DELETE RESTRICT;
 
ALTER TABLE telefone_cliente ADD CONSTRAINT FK_telefone_cliente_2
    FOREIGN KEY (fk_telefones_id)
    REFERENCES telefones (id)
    ON DELETE SET NULL;