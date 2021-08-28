CREATE TABLE Funcionario(
	id SERIAL PRIMARY KEY,
	cpf VARCHAR(11),
	nome VARCHAR(25) NOT NULL,
	data_reg DATE NOT NULL,
	id_dep INTEGER NOT NULL
);


CREATE TABLE Departamento(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(25) NOT NULL,
	numero_func INTEGER,
	max_mesas INTEGER,
	lotacao INTEGER
);

ALTER TABLE funcionario
	ADD CONSTRAINT fk_IdDep
	FOREIGN KEY (id_dep)
	REFERENCES Departamento(id);
	
ANALYZE Funcionario, Departamento;

-- Incrementar o numero de funcionario automaticamente (numero_func)
CREATE OR REPLACE FUNCTION update_numero_func()
RETURNS trigger AS $$
	BEGIN
		UPDATE Departamento SET numero_func = numero_func+1 WHERE id = new.id;
		RETURN NEW;
	end;
$$ language plpgsql;

CREATE TRIGGER update_numero_func 
AFTER INSERT ON funcionario
FOR EACH ROW EXECUTE PROCEDURE update_numero_func();


INSERT INTO Departamento (nome, numero_func, max_mesas, lotacao)
		VALUES ('cpd', 0, 4, 4);

INSERT INTO Departamento (nome, numero_func, max_mesas, lotacao)
		VALUES ('pagode', 0, 10, 40);

TABLE Departamento;

-- DELETE FROM Departamento;

UPDATE Departamento
SET numero_func = 0
WHERE id = 1;

INSERT INTO Funcionario (cpf, nome, data_reg, id_dep)
		VALUES ('00000000000', 'abacate', now(), 4);
		
INSERT INTO Funcionario (cpf, nome, data_reg, id_dep)
		VALUES ('00000000000', 'abacaxi', now(), 5);

TABLE Funcionario;

DELETE FROM Funcionario
where id = 18;

UPDATE Funcionario
SET id_dep = 5
WHERE id = 23;

CREATE OR REPLACE FUNCTION process_numero_func()
RETURNS trigger AS $numero_func$
BEGIN
	IF (TG_OP = 'DELETE') THEN
		UPDATE Departamento SET numero_func = numero_func-1 WHERE id = old.id_dep;
		RETURN OLD;
		
	ELSIF (TG_OP = 'UPDATE') THEN
		UPDATE Departamento SET numero_func = numero_func-1 WHERE id = old.id_dep;
		UPDATE Departamento SET numero_func = numero_func+1 WHERE id = new.id_dep;
		RETURN NEW;
		
	ELSIF (TG_OP = 'INSERT') THEN
		UPDATE Departamento SET numero_func = numero_func+1 WHERE id = new.id_dep;
		RETURN NEW;
	END IF;
	
	RETURN NULL;
END
$numero_func$ LANGUAGE plpgsql;


CREATE TRIGGER numero_func 
AFTER INSERT OR DELETE OR UPDATE ON funcionario
FOR EACH ROW EXECUTE PROCEDURE process_numero_func();

-- DELETA TRIGGER
DROP TRIGGER numero_func ON funcionario;

-- VERIFICA TRIGGERS
select event_object_schema as table_schema,
       event_object_table as table_name,
       trigger_schema,
       trigger_name,
       string_agg(event_manipulation, ',') as event,
       action_timing as activation,
       action_condition as condition,
       action_statement as definition
from information_schema.triggers
group by 1,2,3,4,6,7,8
order by table_schema,
         table_name;



