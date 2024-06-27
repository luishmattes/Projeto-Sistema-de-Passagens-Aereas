-- MYSQL

-- Criação do schema
CREATE DATABASE sistema_voo;
USE sistema_voo;

-- Criação das tabelas

CREATE TABLE Passageiro 
( 
    Cpf VARCHAR(11) PRIMARY KEY NOT NULL,  
    rg VARCHAR(8) NOT NULL,  
    nome VARCHAR(100) NOT NULL,  
    data_nascimento DATE NOT NULL,  
    email VARCHAR(100) NOT NULL,  
    cidade_residencia VARCHAR(100) NOT NULL,  
    unidade_federativa VARCHAR(2) NOT NULL,  
    UNIQUE (rg, email)
); 

CREATE TABLE Voo 
( 
    codigo_voo INT PRIMARY KEY,  
    origem VARCHAR(30) NOT NULL,  
    destino VARCHAR(30) NOT NULL
); 

CREATE TABLE Aeronave 
( 
    codigo_aeronave INT PRIMARY KEY,  
    tipo_aeronave VARCHAR(100) NOT NULL,  
    codigo_voo INT NOT NULL,
    FOREIGN KEY (codigo_voo) REFERENCES Voo (codigo_voo)
); 

CREATE TABLE Reserva 
( 
    codigo_reserva INT PRIMARY KEY,  
    cpf VARCHAR(11),  
    data_reserva DATE NOT NULL,  
    status_reserva VARCHAR(100) NOT NULL,  
    data_expiracao DATE NOT NULL,
    FOREIGN KEY (cpf) REFERENCES Passageiro (Cpf)
); 

CREATE TABLE ReservaNaoConcluida
(
    codigo_reserva INT PRIMARY KEY,
    cpf VARCHAR(11),
    data_reserva DATE NOT NULL,
    status_reserva VARCHAR(100) NOT NULL,
    data_expiracao DATE NOT NULL,
    FOREIGN KEY (cpf) REFERENCES Passageiro (Cpf)
);

CREATE TABLE Trecho 
( 
    codigo_trecho INT PRIMARY KEY,  
    codigo_reserva INT,  
    origem VARCHAR(30) NOT NULL,  
    destino VARCHAR(30) NOT NULL,  
    FOREIGN KEY (codigo_reserva) REFERENCES Reserva (codigo_reserva)
);

CREATE TABLE Trecho_Voo 
( 
    codigo_trecho INT,  
    codigo_voo INT,  
    data_hora_partida DATETIME NOT NULL,  
    classe VARCHAR(100) NOT NULL,  
    PRIMARY KEY (codigo_trecho, codigo_voo),
    FOREIGN KEY (codigo_trecho) REFERENCES Trecho (codigo_trecho),
    FOREIGN KEY (codigo_voo) REFERENCES Voo (codigo_voo)
);

CREATE TABLE Operadora_Cartao (
    CodigoOperadoraCartao VARCHAR(10) PRIMARY KEY,
    NomeOperadora VARCHAR(100)
);

CREATE TABLE Venda 
( 
    codigo_venda INT PRIMARY KEY,  
    codigo_reserva INT,  
    metodo_pagamento VARCHAR(100) NOT NULL,  
    codigo_operadora_cartao VARCHAR(10) NOT NULL, 
    numero_parcelas INT NOT NULL CHECK (numero_parcelas <= 6),
    data_venda DATE NOT NULL,
    valor_venda DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (codigo_reserva) REFERENCES Reserva (codigo_reserva),
    FOREIGN KEY (codigo_operadora_cartao) REFERENCES Operadora_Cartao (CodigoOperadoraCartao)
);


-- Inserções na tabela Passageiro
INSERT INTO Passageiro (Cpf, rg, nome, data_nascimento, email, cidade_residencia, unidade_federativa)
VALUES 
('12345678901', '12345678', 'Maria Silva', '1985-05-15', 'mariasilva@gmail.com', 'São Paulo', 'SP'),
('23456789012', '23456789', 'João Vitor', '1992-08-25', 'joaovitor@outlook.com', 'Rio de Janeiro', 'RJ'),
('34567890123', '34567890', 'Luis', '1978-03-30', 'luis@gmail.com', 'Belo Horizonte', 'MG'),
('45678901234', '45678901', 'Carlos', '1982-08-25', 'carlos@gmail.com', 'Curitiba', 'PR'),
('56789012345', '56789012', 'Ana Clara', '1995-07-10', 'anaclara@gmail.com', 'Brasília', 'DF'),
('67890123456', '67890123', 'Marcos Paulo', '1988-12-05', 'marcosp@gmail.com', 'Porto Alegre', 'RS'),
('78901234567', '78901234', 'Fernanda Costa', '1991-04-18', 'fernandacosta@hotmail.com', 'Florianópolis', 'SC'),
('89012345678', '89012345', 'Ricardo Almeida', '1979-09-23', 'ricardoalmeida@yahoo.com', 'Manaus', 'AM');

-- Inserções na tabela Voo
INSERT INTO Voo (codigo_voo, origem, destino)
VALUES 
(101, 'São Paulo', 'Rio de Janeiro'),
(102, 'Rio de Janeiro', 'Salvador'),
(103, 'Salvador', 'Recife'),
(104, 'Recife', 'Fortaleza'),
(105, 'Fortaleza', 'Natal'),
(106, 'Natal', 'Recife'),
(107, 'Recife', 'Rio de Janeiro'),
(108, 'Rio de Janeiro', 'São Paulo');

-- Inserções na tabela Aeronave
INSERT INTO Aeronave (codigo_aeronave, tipo_aeronave, codigo_voo)
VALUES 
(1, 'Boeing 737', 101),
(2, 'Airbus A320', 102),
(3, 'Embraer E195', 103),
(4, 'Boeing 787', 104),
(5, 'Boeing 737', 105),
(6, 'Airbus A320', 106),
(7, 'Embraer E195', 107),
(8, 'Boeing 787', 108);

-- Inserções na tabela Reserva
INSERT INTO Reserva (codigo_reserva, cpf, data_reserva, status_reserva, data_expiracao)
VALUES 
(1, '12345678901', '2024-01-15', 'Confirmada', '2024-02-14'),
(2, '23456789012', '2024-02-20', 'Pendente', '2024-03-21'),
(3, '34567890123', '2024-03-25', 'Cancelada', '2024-04-24'),
(4, '45678901234', '2024-04-30', 'Confirmada', '2024-05-30'),
(5, '56789012345', '2024-05-05', 'Pendente', '2024-06-04'),
(6, '67890123456', '2024-06-10', 'Confirmada', '2024-07-10'),
(7, '78901234567', '2024-07-15', 'Pendente', '2024-08-14'),
(8, '89012345678', '2024-08-20', 'Cancelada', '2024-09-19'),
(9, '34567890123', '2024-09-20', 'Confirmada', '2024-10-19'),
(10, '34567890123', '2024-01-15', 'Confirmada', '2024-02-14');

-- Inserções na tabela Trecho
INSERT INTO Trecho (codigo_trecho, codigo_reserva, origem, destino)
VALUES 
(10, 1, 'São Paulo', 'Rio de Janeiro'),
(20, 2, 'Rio de Janeiro', 'Salvador'),
(30, 3, 'Salvador', 'Recife'),
(40, 4, 'Recife', 'Fortaleza'),
(50, 5, 'Fortaleza', 'Natal'),
(60, 6, 'Natal', 'Recife'),
(70, 7, 'Recife', 'Rio de Janeiro'),
(80, 8, 'Rio de Janeiro', 'São Paulo'),
(90, 9, 'São Paulo', 'Rio de Janeiro'),
(100, 10, 'São Paulo', 'Rio de Janeiro');

-- Inserções na tabela Trecho_Voo
INSERT INTO Trecho_Voo (codigo_trecho, codigo_voo, data_hora_partida, classe)
VALUES 
(10, 101, '2024-01-01 08:00:00', 'Econômica'),
(20, 102, '2024-02-02 10:00:00', 'Executiva'),
(30, 103, '2024-03-03 12:00:00', 'Econômica'),
(40, 104, '2024-04-04 14:00:00', 'Primeira'),
(50, 105, '2024-05-15 09:00:00', 'Econômica'),
(60, 106, '2024-06-20 11:00:00', 'Executiva'),
(70, 107, '2024-07-25 13:00:00', 'Primeira'),
(80, 108, '2024-08-30 15:00:00', 'Econômica'),
(100, 108, '2024-09-30 15:00:00', 'Econômica'),
(100, 101, '2024-01-01 08:00:00', 'Econômica');

-- Inserções na tabela Operadora_Cartao
INSERT INTO Operadora_Cartao (CodigoOperadoraCartao, NomeOperadora)
VALUES 
('01', 'Visa'),
('02', 'Mastercard'),
('03', 'Elo');

-- Inserções na tabela Venda
INSERT INTO Venda (codigo_venda, codigo_reserva, metodo_pagamento, codigo_operadora_cartao, numero_parcelas, data_venda, valor_venda)
VALUES 
(9, 1, 'Cartão de Crédito', '01', 3, '2024-06-21', 1000.00),
(10, 2, 'Cartão de Crédito', '02', 1, '2024-06-21', 1500.00),
(11, 3, 'Cartão de Crédito', '03', 2, '2024-06-21', 750.00),
(12, 4, 'Cartão de Crédito', '01', 4, '2024-06-21', 2000.00),
(13, 5, 'Cartão de Crédito', '02', 5, '2024-06-21', 3000.00),
(14, 6, 'Cartão de Crédito', '03', 6, '2024-06-21', 1200.00),
(15, 7, 'Cartão de Crédito', '01', 2, '2024-06-21', 1800.00),
(16, 8, 'Cartão de Crédito', '02', 3, '2024-06-21', 2200.00);


-- sql
-- 1) Implemente uma consulta que mostre para o usuário quais são os trechos que compõem um voo, entre duas datas, retornando datas, horários, cidades de origem e destino.

SELECT 
    tv.data_hora_partida AS Data_Hora_Partida,
    v.origem AS Origem,
    v.destino AS Destino
FROM 
    Trecho_Voo tv
    JOIN Voo v ON tv.codigo_voo = v.codigo_voo
WHERE 
    tv.codigo_voo = 102   -- Código do voo desejado
    AND tv.data_hora_partida BETWEEN '2024-01-01' AND '2024-12-14'  -- Intervalo de datas desejado
ORDER BY 
    tv.data_hora_partida;

-- 2 Faça uma consulta que retorne todos os dados dos voos de um determinado cliente, realizados em um período específico. 

SELECT 
    p.nome AS Nome_Passageiro,
    v.codigo_voo AS Codigo_Voo,
    v.origem AS Origem,
    v.destino AS Destino,
    tv.data_hora_partida AS Data_Hora_Partida,
    tv.classe AS Classe,
    r.status_reserva AS Status_Reserva
FROM 
    Passageiro p
    JOIN Reserva r ON p.Cpf = r.cpf
    JOIN Trecho t ON r.codigo_reserva = t.codigo_reserva
    JOIN Trecho_Voo tv ON t.codigo_trecho = tv.codigo_trecho
    JOIN Voo v ON tv.codigo_voo = v.codigo_voo
WHERE 
    p.cpf = '34567890123'  -- CPF do cliente desejado
    AND tv.data_hora_partida BETWEEN '2024-01-01' AND '2024-12-31'  -- Período desejado
ORDER BY 
    tv.data_hora_partida;


-- 3  Implemente uma consulta que mostre todas as reservas diárias, retornando os nomes, e-mails e cidades de origem e destino dos clientes, em determinado voo. 

SELECT 
    p.nome AS Nome_Passageiro,
    p.email AS Email,
    p.cidade_residencia AS Cidade_Origem,
    v.origem AS Origem_Voo,
    v.destino AS Destino_Voo
FROM 
    Passageiro p
    JOIN Reserva r ON p.Cpf = r.cpf
    JOIN Trecho t ON r.codigo_reserva = t.codigo_reserva
    JOIN Trecho_Voo tv ON t.codigo_trecho = tv.codigo_trecho
    JOIN Voo v ON tv.codigo_voo = v.codigo_voo
WHERE 
    v.codigo_voo = 101  -- Código do voo desejado
    AND DATE(tv.data_hora_partida) = '2024-01-01'  -- Data desejada
ORDER BY 
    p.nome;


-- 4) Faça uma consulta que retorne o total dos pagamentos realizados por uma operadora de cartões de crédito, no período de um mês.
SELECT 
    oc.NomeOperadora AS Operadora_Cartao,
    SUM(v.numero_parcelas) AS Total_Parcelas,
    COUNT(*) AS Total_Vendas,
    SUM(v.valor_venda) AS Total_Valor_Venda
FROM 
    Venda v
    JOIN Operadora_Cartao oc ON v.codigo_operadora_cartao = oc.CodigoOperadoraCartao
WHERE 
    oc.NomeOperadora = 'Visa' -- parametro cartão desejado
    AND MONTH(v.data_venda) = 6   -- parametro mes
    AND YEAR(v.data_venda) = 2024 -- parametro ano
GROUP BY 
    oc.NomeOperadora;


-- 5 Implemente um procedimento na base de dados que copie para uma tabela auxiliar todas as reservas que não foram efetivadas, isto é, com venda não concluída. O procedimento deve também eliminar estas reservas não concluídas da tabela original.

DELIMITER //

CREATE PROCEDURE InserirReservaNaoConcluida() -- criando o procedimento
BEGIN
    INSERT INTO ReservaNaoConcluida (codigo_reserva, cpf, data_reserva, status_reserva, data_expiracao)
    SELECT codigo_reserva, cpf, data_reserva, status_reserva, data_expiracao 
    FROM Reserva 
    WHERE status_reserva = 'Cancelada'; 
END //

DELIMITER ;

CALL InserirReservaNaoConcluida();  -- Inserindo os dados na tabela ReservaNaoConcluida

select * from ReservaNaoConcluida; -- mostrando os dados atualizados na tavela ReservaNaoConcluida


 -- 6  Implemente uma função que mostre a idade de um cliente qualquer. 
 
DELIMITER //

CREATE FUNCTION CalcularIdade (cpf_cliente VARCHAR(11)) 
RETURNS INT 
DETERMINISTIC 
BEGIN
    DECLARE idade INT;

    SELECT FLOOR(DATEDIFF(CURDATE(), data_nascimento) / 365.25) INTO idade
    FROM Passageiro
    WHERE Cpf = cpf_cliente;

    RETURN idade;
END //

DELIMITER ;

SELECT CalcularIdade('78901234567'); -- chamado da funcao para calcular idade (Parametro CPF)

-- 7 Implemente uma consulta que retorne todos os clientes aniversariantes de uma data específica. 

SELECT 
    nome, 
    email, 
    data_nascimento 
FROM 
    Passageiro 
WHERE 
    MONTH(data_nascimento) = MONTH('1992-08-25') 
    AND DAY(data_nascimento) = DAY('1992-08-25');



-- 8 Escreva uma consulta para mostrar quais os trechos são comuns a dois voos específicos.

SELECT t.codigo_trecho, t.origem, t.destino
FROM Trecho t
JOIN Trecho_Voo tv1 ON t.codigo_trecho = tv1.codigo_trecho
JOIN Trecho_Voo tv2 ON t.codigo_trecho = tv2.codigo_trecho
WHERE tv1.codigo_voo = 101 AND tv2.codigo_voo = 108; -- codigos dos voos específicos.



-- 9 Escreva uma consulta para obter os nomes e e-mails dos clientes que não fizeram nenhum voo no ano anterior.

SELECT nome, email
FROM Passageiro
WHERE Cpf NOT IN (
    SELECT DISTINCT p.Cpf
    FROM Passageiro p
    JOIN Reserva r ON p.Cpf = r.cpf
    JOIN Trecho t ON r.codigo_reserva = t.codigo_reserva
    JOIN Trecho_Voo tv ON t.codigo_trecho = tv.codigo_trecho
    WHERE YEAR(tv.data_hora_partida) = YEAR(CURDATE()) - 1
);


-- 10) Faça uma função que conte o número de reservas realizadas por um determinado cliente em um período específico. 

DELIMITER //

CREATE FUNCTION ContarReservas(cpf_cliente BIGINT, data_inicio DATE, data_fim DATE) 
RETURNS INT 
DETERMINISTIC
BEGIN
    DECLARE num_reservas INT;

    -- Conta o número de reservas realizadas pelo cliente no período específico
    SELECT COUNT(*) INTO num_reservas
    FROM Reserva
    WHERE cpf = cpf_cliente
    AND data_reserva BETWEEN data_inicio AND data_fim;

    RETURN num_reservas;
END //

DELIMITER ;
-- Chamar a função
SELECT ContarReservas(34567890123, '2024-01-01', '2024-12-31') AS num_reservas_cliente;



select * from aeronave;
select * from operadora_cartao;
select * from passageiro;
select * from reserva;
select * from reservanaoconcluida;
select * from trecho;
select * from trecho_voo;
select * from venda;
select * from voo;