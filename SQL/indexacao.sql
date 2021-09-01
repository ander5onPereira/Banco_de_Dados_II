create index idxEstado on endereco(estado);

create index idxEmpresa on agenda(fk_empresa);

create index idxServico on agenda(fk_servico);

create index idxNomeCliente on cliente(nome);

create index idxNomeServico on servico(fk_empresa) where nome='Programador';