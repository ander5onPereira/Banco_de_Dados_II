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