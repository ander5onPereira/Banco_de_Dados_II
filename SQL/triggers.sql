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

