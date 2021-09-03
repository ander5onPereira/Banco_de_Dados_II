-- 1° TRIGGER
-- Tabela de auditoria da agenda
CREATE TABLE audit_agenda(
	operacao CHAR,
	data timestamp with time zone,
	usuario varchar,
	id_agenda BIGSERIAL,
	data_antiga timestamp with time zone,
	fk_cliente VARCHAR,
	fk_empresa VARCHAR,
	fk_servico BIGINT references servico(id_servico),
);

-- DROP TABLE audit_agenda;

CREATE OR REPLACE FUNCTION process_agenda_audit()
	RETURNS TRIGGER AS $agenda_audit$
	BEGIN
		IF (TG_OP = 'DELETE') THEN
			INSERT INTO audit_agenda SELECT 'D', now(), user, OLD.*;
			RETURN OLD;
		ELSIF (TG_OP = 'UPDATE') THEN
			INSERT INTO audit_agenda SELECT 'U', now(), user, NEW.*;
			RETURN NEW;
		ELSIF (TG_OP = 'INSERT') THEN
			INSERT INTO audit_agenda SELECT 'I', now(), user, NEW.*;
			RETURN NEW;
		END IF;
		RETURN NULL;
	END;
$agenda_audit$ LANGUAGE plpgsql;


CREATE TRIGGER agenda_audit
AFTER INSERT OR UPDATE OR DELETE ON Agenda
FOR EACH ROW EXECUTE PROCEDURE process_agenda_audit();


-- DROP TRIGGER agenda_audit ON Agenda

TABLE agenda;
TABLE audit_agenda;

DELETE FROM Agenda
WHERE id_agenda = 4;


UPDATE Agenda
SET fk_cliente = 83684665942
WHERE id_agenda = 2;


INSERT INTO Agenda (data, fk_cliente, fk_empresa)
VALUES (data(), 70519551169, 15011691814288);


-- 2° TRIGGER

CREATE TABLE audit_login (
	operacao CHAR,
	data timestamp with time zone,
	usuario varchar,
	email VARCHAR(50) NOT NULL,
	senha VARCHAR(15) NOT NULL,
	permissao CHAR(2) NOT NULL
);

-- BACKUP DA ALTERAÇÃO DE SENHA
CREATE OR REPLACE FUNCTION process_audit_login()
RETURNS trigger AS $login_audit$
	BEGIN
		IF (TG_OP = 'UPDATE') THEN
			INSERT INTO audit_login SELECT 'U', now(), user, NEW.*;
			RETURN NEW;
		END IF;
		RETURN NULL;
	END;
$login_audit$ language plpgsql;


CREATE TRIGGER login_audit
AFTER UPDATE ON login
FOR EACH ROW EXECUTE PROCEDURE process_audit_login();

DROP TRIGGER login_audit ON login

SELECT * FROM  login
WHERE email = 'ijWqhydtDP@gmail.com';
TABLE audit_login;

UPDATE Login
SET senha = 'abacate'
WHERE email = 'ijWqhydtDP@gmail.com';



-- 3° TRIGGER
CREATE TABLE audit_cliente (
	operacao CHAR,
	data timestamp with time zone,
	usuario varchar,
	cpf VARCHAR(11) NOT NULL,
	nome VARCHAR(20) NOT NULL,
	sobrenome VARCHAR(100),
	telefone text[],
	fk_login VARCHAR,
	fk_endereco BIGINT 
);

-- BACKUP DOS DADOS CADASTRAIS DO CLIENTE
CREATE OR REPLACE FUNCTION process_audit_cliente()
RETURNS trigger AS $cliente_audit$
	BEGIN
		IF (TG_OP = 'DELETE') THEN
			INSERT INTO audit_cliente SELECT 'D', now(), user, OLD.*;
			RETURN OLD;
		ELSIF (TG_OP = 'UPDATE') THEN
			INSERT INTO audit_cliente SELECT 'U', now(), user, NEW.*;
			RETURN NEW;
		ELSIF (TG_OP = 'INSERT') THEN
			INSERT INTO audit_cliente SELECT 'I', now(), user, NEW.*;
			RETURN NEW;
		END IF;
		RETURN NULL;
	END;
$cliente_audit$ language plpgsql;


CREATE TRIGGER cliente_audit
AFTER INSERT OR UPDATE OR DELETE ON cliente
FOR EACH ROW EXECUTE PROCEDURE process_audit_cliente();

DROP TRIGGER cliente_audit ON cliente

SELECT * FROM  cliente
WHERE fk_login = 'ijWqhydtDP@gmail.com';
TABLE audit_cliente;

UPDATE cliente
SET telefone[1] = 123456789
WHERE fk_login = 'ijWqhydtDP@gmail.com';

INSERT INTO Cliente values (12345678911, 'abacate 2', 'abacaxi', ARRAY['123456789'], 'lyfHQn@gmail.com', 1688)


DELETE FROM cliente
WHERE fk_login = 'ijWqhydtDP@gmail.com'

select * from agenda
where fk_cliente = '45294321794'


table * from audit
ALTER TABLE agenda
MODIFY CONSTRAINTS ADD DELETE CASCADE and UPDATE CASCADE

ALTER TABLE agenda
ADD DELETE CASCADE

TABLE audit_agenda

ALTER TABLE agenda 
  DROP CONSTRAINT agenda_fk_cliente_fkey;
  
ALTER TABLE agenda 
  ADD CONSTRAINT agenda_fk_cliente_fkey
  FOREIGN KEY (fk_cliente)
  REFERENCES cliente(cpf)
  ON DELETE CASCADE;
  
  
 ALTER TABLE agenda 
  DROP CONSTRAINT  agenda_fk_empresa_fkey;

 ALTER TABLE agenda 
  ADD CONSTRAINT agenda_fk_empresa_fkey
  FOREIGN KEY (fk_empresa)
  REFERENCES empresa(cnpj)
  ON DELETE CASCADE;