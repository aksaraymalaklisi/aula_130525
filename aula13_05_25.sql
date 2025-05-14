CREATE DATABASE loja_db;

DROP DATABASE loja_db; -- Detonar a database caso eu esqueça de algo.

USE loja_db;

SELECT * FROM Clientes;
SELECT * FROM Produtos;
SELECT * FROM Pedidos;
SELECT * FROM ItensPedido;

CREATE TABLE Clientes(
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(100) NOT NULL, 
	email VARCHAR(100) NOT NULL, 
	telefone VARCHAR(11) NOT NULL
);

CREATE TABLE Produtos(
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nome VARCHAR(100) NOT NULL, 
    preco DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL
);

CREATE TABLE Pedidos(
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    id_cliente INT NOT NULL,
    data_pedido DATE NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id)
);

CREATE TABLE ItensPedido(
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2),
    
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id),
	FOREIGN KEY (id_produto) REFERENCES Produtos(id)
);

INSERT INTO Clientes (nome, email, telefone) VALUES
('Carlos Roberto', 'carlosroberto@gmail.com', '21987654321'),
('Roberto Carlos', 'robertocarlos@email.com', '21912345678'),
('Henrique Roberto', 'hroberto@outlook.com', '21976543210'),
('Roberto Miranda', 'rmiranda@hotmail.com', '21965432109');

INSERT INTO Produtos(nome, preco, estoque) VALUES
('Notebook', 3200.00, 10),
('Mouse', 50.00, 26),
('Teclado', 120.00, 8);

INSERT INTO Pedidos(id_cliente, data_pedido, valor_total) VALUES
(1, '2025-05-12', 3350.00),
(2, '2025-04-02', 170.00);

INSERT INTO ItensPedido(id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1,1,1,3200.00),
(1,2,3,50.00),
(2,3,1,120.00),
(2,2,1,50.00);

/* Selecionem dados completos dos pedidos */
/* INNER JOIN de todos os dados do pedidos. */
SELECT 
	Pedidos.id, 
	Clientes.nome as 'Cliente', 
	Produtos.nome as 'Produto', 
	ItensPedido.quantidade as 'Quantidade', 
	ItensPedido.preco_unitario as 'Preço Unitário', 
    (ItensPedido.quantidade*ItensPedido.preco_unitario) as 'Subtotal'
FROM Pedidos
INNER JOIN Clientes ON Pedidos.id_cliente = Clientes.id
INNER JOIN ItensPedido ON Pedidos.id = ItensPedido.id_pedido
INNER JOIN Produtos ON ItensPedido.id_produto = Produtos.id;

SELECT AVG(preco) FROM Produtos;

-- Subqueries

-- Exemplo 1
-- Média de preço dos produtos
SELECT AVG(preco) as 'Média de preço dos produtos' FROM Produtos;

-- Selecionar produtos com preço acima da média (note o '>')
SELECT nome, preco FROM Produtos
WHERE preco > (SELECT AVG(preco) FROM Produtos);

-- Selecionar produtos com preço abaixo da média (note o '<')
SELECT nome, preco FROM Produtos
WHERE preco < (SELECT AVG(preco) FROM Produtos);

/* Nota do Professor: "A subquery é executada primeiro. 
O resultado da subquery é armazenado, realizado um "storage momentâneo" do valor que será utilizado."*/

-- Exemplo 2
-- Mostrar os clientes na tabela:
SELECT * FROM Clientes;

-- Mesma coisa, mas apenas nome e e-mail (?):
SELECT nome, email FROM Clientes;

-- Note que há IDs de clientes em pedidos.
SELECT id_cliente FROM pedidos; -- O resultado, nesse caso, é (1,2), de certa forma.

-- Daí, é possível selecionar clientes que realizaram um pedido, usando uma subquery (subconsulta) como condição
-- É parecido com o JOIN, mas essa query não está, de fato, mesclando as tabelas.
SELECT nome, email FROM Clientes
WHERE id IN (SELECT id_cliente FROM pedidos); 
-- IN = EM; 
-- WHERE = ONDE; 
-- Ou seja: ONDE (O) id (ESTEJA) EM (1,2). Essa é a condição do WHERE.
-- Essa explicação é muito esculachada, portanto, recomendo que fale com o professor caso esteja com dúvida.

-- Exemplo 3: Selecionar clientes que possuem pelo menos um pedido registrado
SELECT nome, email
FROM Clientes c -- O 'c' simplesmente é um alias (literalmente apelido) de Clientes
WHERE EXISTS (SELECT 1 FROM Pedidos p WHERE p.id_cliente = c.id); -- Sinceramente, eu não entendi o número.

-- Exemplo 4: Subquery na cláusula FROM
-- Selecionar a média de quantidade vendida por produto e usar o resultado
-- em uma consulta principal:

SELECT AVG(quantidade_media) as 'Média geral'
FROM (
	SELECT id_produto, AVG(quantidade) as quantidade_media 
	FROM ItensPedido
	GROUP BY id_produto
) AS subconsulta;

-- "Cria uma tabela temporária chamada subconsulta"

-- Exemplo 5 - Subquery com HAVING
/* Selecionar os produtos que já venderam mais que a média geral das quantidades
   vendidas por período */

-- Checando as entradas em ItensPedido
SELECT * FROM ItensPedido;

-- Consultado a quantidade de produto que contém uma soma de quantidade maior que a média do total de pedidos, 
-- que é obtida ao realizar a média da subconsulta que possui a soma da quantidade de produtos de cada produto.
-- Ou, na explicação do professor: " Selecionar os produtos que já venderam mais que a média geral das quantidades vendidas por periodo" (período?)
SELECT id_produto, SUM(quantidade) as total_vendido FROM ItensPedido
GROUP BY id_produto
HAVING SUM(quantidade) > (
	SELECT AVG(total_pedido) -- Consulta a tabela virtual 
    FROM (
		SELECT id_pedido, SUM(quantidade) as total_pedido
		FROM ItensPedido
		GROUP BY id_pedido) -- Calcula o total de pedidos por período 
as subtotal_pedido);
