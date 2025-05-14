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

SELECT MAX(preco) FROM Produtos;

-- Subqueries
SELECT nome, preco FROM Produtos
WHERE preco = (SELECT MAX(preco) FROM Produtos);

SELECT AVG(preco) as 'Média de preço dos produtos' FROM Produtos;
