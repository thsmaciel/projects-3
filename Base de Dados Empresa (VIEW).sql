create table marcas (
	marca_id				int primary key,
	marca_nome				varchar(50)		NOT NULL,
	marca_nacionalidade		varchar(50)

);

create table produtos (
	prod_id					int primary key,
	prod_nome				varchar(50)		NOT NULL,
	prod_quant_estoque		int				NOT NULL			default 0,		
	prod_estoque_min		int				NOT NULL			default 0,
	prod_data_fabr			timestamp							default CURRENT_TIMESTAMP,
	prod_perecivel			boolean,
	prod_valor				DECIMAL (10,2),

	prod_marca_id			int,
	constraint fk_marcas	foreign key(prod_marca_id) references marcas(marca_id)
);


create table fornecedores (
	forn_id					int primary key,
	forn_nome				varchar(50)		NOT NULL,
	forn_email				varchar(50)
);


create table produto_fornecedor (
	pf_prod_id					int				references produtos		(prod_id),
	pf_forn_id					int				references forncedores	(forn_id),

	primary key (pf_prod_id, pf_forn_id)
);

-- inserção em marcas
INSERT INTO marcas (marca_id, marca_nome, marca_nacionalidade) VALUES
(1, 'AA', 'Brasil '),
(2, 'BB', 'Alemanha'),
(3, 'CC', 'Holanda'),
(4, 'DD', 'Costa Rica'),
(5, 'EE', 'Estados Unidos');

-- inserção em produtos
INSERT INTO produtos (prod_id, prod_nome, prod_quant_estoque, prod_estoque_min, prod_perecivel, prod_valor, prod_marca_id) VALUES
(1, 'produto A', 100, 20, true, 10.50, 1),
(2, 'produto B', 5, 10, false, 5.75, 2),
(3, 'produto C', 200, 50, true, 7.99, 1),
(4, 'produto D', 20, 30, false, 3.25, 3),
(5, 'produto E', 150, 40, true, 12.00, 4);

-- inserção em fornecedores

INSERT INTO fornecedores (forn_id, forn_nome, forn_email) VALUES
(1, 'fornecedor A', 'A@gmail.com'),
(2, 'fornecedor B', 'B@gmail.com'),
(3, 'fornecedor C', 'C@gmail.com'), 
(4, 'fornecedor D', 'D@gmail.com'),
(5, 'fornecedor E', 'E@gmail.com');

-- inserção em produtos_fornecedor

INSERT INTO produto_fornecedor (pf_prod_id, pf_forn_id) VALUES
(1, 1), 
(2, 2), 
(3, 3), 
(4, 4), 
(5, 5);

-- Crie uma view que mostra todos os produtos e suas respectivas marcas

CREATE VIEW produtos_com_marcas AS
SELECT 
    p.prod_id,
    p.prod_nome AS nome_produto,
    p.prod_quant_estoque,
    p.prod_estoque_min,
    p.prod_data_fabr,
    p.prod_perecivel,
    p.prod_valor,
    m.marca_id,
    m.marca_nome AS nome_marca,
    m.marca_nacionalidade
FROM 
    produtos p
JOIN 
    marcas m ON p.prod_marca_id = m.marca_id;
    
 SELECT * FROM produtos_com_marcas;
 
 -- Crie uma view que mostra todos os produtos e seus respectivos fornecedores
 
 CREATE VIEW produtos_com_fornecedores AS
SELECT 
    p.prod_id,
    p.prod_nome AS nome_produto,
    p.prod_quant_estoque,
    p.prod_estoque_min,
    p.prod_data_fabr,
    p.prod_perecivel,
    p.prod_valor,
    f.forn_id,
    f.forn_nome AS nome_fornecedor,
    f.forn_email
FROM 
    produtos p
JOIN 
    produto_fornecedor pf ON p.prod_id = pf.pf_prod_id
JOIN 
    fornecedores f ON pf.pf_forn_id = f.forn_id;
    
SELECT * FROM produtos_com_fornecedores;
    
-- Crie uma view que mostra todos os produtos e seus respectivos fornecedores e marcas

CREATE VIEW produtos_com_fornecedores_e_marcas AS
SELECT 
    p.prod_id,
    p.prod_nome AS nome_produto,
    p.prod_quant_estoque,
    p.prod_estoque_min,
    p.prod_data_fabr,
    p.prod_perecivel,
    p.prod_valor,
    f.forn_id AS fornecedor_id,
    f.forn_nome AS nome_fornecedor,
    f.forn_email,
    m.marca_id AS marca_id,
    m.marca_nome AS nome_marca,
    m.marca_nacionalidade
FROM 
    produtos p
JOIN 
    produto_fornecedor pf ON p.prod_id = pf.pf_prod_id
JOIN 
    fornecedores f ON pf.pf_forn_id = f.forn_id
JOIN 
    marcas m ON p.prod_marca_id = m.marca_id;
    
 SELECT * FROM produtos_com_fornecedores_e_marcas;
 
 --Crie uma view que mostra todos os produtos com estoque abaixo do mínimo
 
 CREATE VIEW produtos_com_estoque_abaixo_do_minimo AS
SELECT 
    prod_id,
    prod_nome AS nome_produto,
    prod_quant_estoque,
    prod_estoque_min,
    prod_data_fabr,
    prod_perecivel,
    prod_valor,
    prod_marca_id
FROM 
    produtos
WHERE 
    prod_quant_estoque < prod_estoque_min;
    
SELECT * FROM produtos_com_estoque_abaixo_do_minimo;

-- Crie uma view que mostra todos os produtos e suas respectivas marcas com validade vencida
-- ???
--Selecionar os produtos com preço acima da média

SELECT 
    prod_id,
    prod_nome AS nome_produto,
    prod_valor,
    prod_marca_id
FROM 
    produtos
WHERE 
    prod_valor > (SELECT AVG(prod_valor) FROM produtos);