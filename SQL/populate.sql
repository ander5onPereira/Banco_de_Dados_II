-- %%%%%%%%%%%%%%%%%%%%%%%%% FUNCOES UTEIS %%%%%%%%%%%%%%%%%%%%%%%%%

--Numero aleatorio (Quantidade max de digitos por parametro)
create or replace function numero_big(digitos integer) returns BIGINT as
$$
declare
	num BIGINT;
   begin
   		num := trunc(random()*power(10,digitos));
      	return num;
   end;
$$language plpgsql;
--select numero(3);

--Numero aleatorio (Quantidade max de digitos por parametro)
create or replace function numero(digitos integer) returns integer as
$$
declare
	num integer;
   begin
   		num := trunc(random()*power(10,digitos));
      	return num;
   end;
$$language plpgsql;
--select numero(3);

--Data aleatoria (indicar periodo na funcao se quiser alterar)
create or replace function data() returns timestamp as
$$
   begin
   return timestamp '2020-01-10 20:00:00' +
       random() * (timestamp '2014-01-20 20:00:00' -
                   timestamp '2014-01-10 10:00:00');
   end;
$$language plpgsql;
--select data
-- para mudar a forma de representacao da data DayMesYear - DMY
-- SET datestyle TO SQL, DMY;

--Texto aleatorio 
Create or replace function texto(tamanho integer) returns text as
$$
declare
  chars text[] := '{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z}';
  result text := '';
  i integer := 0;
begin
  if tamanho < 0 then
    raise exception 'Tamanho dado nao pode ser menor que zero';
  end if;
  for i in 1..tamanho loop
    result := result || chars[1+random()*(array_length(chars, 1)-1)];
  end loop;
  return result;
end;
$$ language plpgsql;
--select texto(5)

--Nome aleatorio 
Create or replace function random_nome(tamanho decimal) returns text as
$$
declare
  chars text[] := '{A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z}';
  result text := '';
  i integer := 0;
begin
  if tamanho < 0 then
    raise exception 'Tamanho dado nao pode ser menor que zero';
  end if;
  for i in 1..tamanho loop
    result := result || chars[1+random()*(array_length(chars, 1)-1)];
  end loop;
  return result;
end;
$$ language plpgsql;
--select random_nome(5)

--Email aleatorio 
Create or replace function email_random() returns text as
$$
declare
  chars text[] := '{@gmail.com, @hotmail.com, @outlook.com}';
begin
  return chars[trunc(random() * 3 + 1)];
end;
$$ language plpgsql;
-- select curso_random();

--Pais aleatorio 
Create or replace function pais_random() returns text as
$$
declare
  chars text[] := '{Brasil, Uruguai, Argentina, EUA}';
begin
  return chars[trunc(random() * 4 + 1)];
end;
$$ language plpgsql;
-- select pais_random();

--Servicos aleatorio 
Create or replace function servico_random() returns text as
$$
declare
  chars text[] := '{Dentista, Pintura, Diarista, 
  					Músico, TI, Desenvolvedor, Pedreiro, Coach, Psicólogo, Medico, Segurança, 
  					Jogador, Fisiotepeuta, Programar, DBA, Engenheiro}';
begin
  return chars[trunc(random() * 16 + 1)];
end;
$$ language plpgsql;
-- select servico_random();

-- %%%%%%%%%%%%%%%%%%%%%%%%% POPULAR AS TABELAS %%%%%%%%%%%%%%%%%%%%%%%%%
-- Inserir Endereco
do $$
declare
aux_numero INTEGER;
begin
for i in 1..2000 loop
	aux_numero := trunc(random() * 14 + 1);
	INSERT INTO endereco (cep, pais, estado, cidade, bairro, rua, complemento, numero)
	VALUES ( numero(8), pais_random(), random_nome(2), random_nome(aux_numero), 
						random_nome(aux_numero), 
						random_nome(aux_numero), '' , numero(2));
end loop;
end $$ 
language plpgsql;

-- Inserir Login e Cliente
do $$
declare
	aux_nome VARCHAR(20);
	aux_numero INTEGER;
	aux_email VARCHAR(50);
	aux_count INTEGER;
	aux_endereco BIGINT;
	
	begin
		for i in 1..2000 loop
			aux_nome := random_nome(numero(1) + 2);
			aux_email := aux_nome||email_random();
			aux_count := COUNT(*) FROM endereco;
			aux_endereco := id_endereco FROM endereco OFFSET floor(random()*aux_count) LIMIT 1;
			
			INSERT INTO Login (email, senha, permissao)
			VALUES ( aux_email, texto(numero(1) + 4), numero(1))
			ON CONFLICT (email) DO NOTHING;
			
			
			
			INSERT INTO cliente (cpf, nome, sobrenome, telefone, fk_login, fk_endereco)
			VALUES (numero_big(11), aux_nome, random_nome(numero(1)), ARRAY[numero(9)], aux_email, aux_endereco)
			ON CONFLICT (cpf) DO NOTHING;
		end loop;
end $$ 
language plpgsql;

-- Inserir Empresa
do $$
declare
	aux_nome VARCHAR(20);
	aux_razao VARCHAR(50);
	aux_numero INTEGER;
	aux_email VARCHAR(50);
	aux_count INTEGER;
	aux_endereco BIGINT;
	
	begin
		for i in 1..200 loop
			aux_nome := random_nome(numero(1) + 8);
			aux_razao := random_nome(numero(1) + 10);
			aux_email := aux_nome||email_random();
			aux_count := COUNT(*) FROM endereco;
			aux_endereco := id_endereco FROM endereco OFFSET floor(random()*aux_count) LIMIT 1;
			
			INSERT INTO Login (email, senha, permissao)
			VALUES ( aux_email, texto(numero(1)), numero(2))
			ON CONFLICT (email) DO NOTHING;
			
			INSERT INTO Empresa (cnpj, email, nome, razao_social, telefone, fk_login, fk_endereco)
			VALUES ( numero_big(14), aux_email, aux_nome, aux_razao, ARRAY[numero(9), numero(9)], aux_email, aux_endereco)
			ON CONFLICT (cnpj) DO NOTHING;
		end loop;
end $$ 
language plpgsql;

-- Inserir Servico
do $$
declare
	aux_nome VARCHAR(20);
	aux_desc VARCHAR(50);
	aux_count INTEGER;
	aux_cnpj BIGINT;
	
	begin
		for i in 1..400 loop
			aux_nome := servico_random();
			aux_desc := random_nome(numero(1) + 40);
			aux_count := COUNT(*) FROM empresa;
			aux_cnpj := cnpj FROM empresa OFFSET floor(random()*aux_count) LIMIT 1;
			
			INSERT INTO Servico (nome, tipo, descricao, fk_empresa)
			VALUES (aux_nome, aux_nome, aux_desc, aux_cnpj)
			ON CONFLICT (id_servico) DO NOTHING;
		end loop;
end $$ 
language plpgsql;

-- Inserir Agenda
do $$
declare
	aux_nome VARCHAR(20);
	aux_desc VARCHAR(50);
	aux_count INTEGER;
	aux_cpf BIGINT;
	aux_cnpj BIGINT;
	aux_servico BIGINT;
	
	begin
		for i in 1..5000 loop
			aux_nome := servico_random();
			aux_desc := random_nome(numero(1) + 40);
			
			aux_count := COUNT(*) FROM cliente;
			aux_cpf := cpf FROM cliente OFFSET floor(random()*aux_count) LIMIT 1;
			
			aux_count := COUNT(*) FROM empresa;
			aux_cnpj := cnpj FROM empresa OFFSET floor(random()*aux_count) LIMIT 1;
			
			aux_count := COUNT(*) FROM servico;
			aux_servico := id_servico FROM servico OFFSET floor(random()*aux_count) LIMIT 1;
			
			INSERT INTO Agenda (data, fk_cliente, fk_empresa, fk_servico)
			VALUES (data(), aux_cpf, aux_cnpj, aux_servico);
		end loop;
end $$ 
language plpgsql;


-- Visualizar tabelas
TABLE login;
TABLE cliente;
TABLE servico;
TABLE empresa;
TABLE endereco;
TABLE Agenda;
