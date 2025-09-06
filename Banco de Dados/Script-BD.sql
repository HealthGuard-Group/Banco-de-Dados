CREATE DATABASE healthguard;
USE healthguard;

CREATE TABLE Endereco (
	idEndereco INT PRIMARY KEY AUTO_INCREMENT,
    logradouro VARCHAR(45),
    numero VARCHAR(45),
    cidade VARCHAR(45),
    bairro VARCHAR(45),
    uf CHAR(2)
);

Insert into Endereco (logradouro, numero, cidade, bairro, uf) values
("Avenida Paulista", 290, "São Paulo", "Bela vista", "SP");


CREATE TABLE Empresa (
	idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    razaoSocial VARCHAR(45),
    email VARCHAR(45),
    senha VARCHAR(45),
    telefone CHAR(11),
    cnpj CHAR(14),
    codigoEmpresa CHAR(8),
    fkEndereco INT,
    FOREIGN KEY (fkEndereco)
    REFERENCES Endereco(idEndereco)
);

Insert into Empresa (razaoSocial, email, senha, telefone, cnpj, codigoEmpresa, fkEndereco) values
("Serviços Integrados de Urgência e Emergência", "Samu192@segurança.com", "SAMU192", 11937131341, 51407659000106, 5555-9999, 1);

CREATE TABLE Usuario (
	idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    email VARCHAR(45),
    senha VARCHAR(45),
    fkEmpresa INT,
    FOREIGN KEY (fkEmpresa)
    REFERENCES Empresa(idEmpresa)
);

INSERT INTO Usuario (nome, email, senha, fkEmpresa)
VALUES ("Felipe", "Felipe.ferraz@sptech.school", "SPTech2024", 1);

CREATE TABLE Lote (
	idLote INT PRIMARY KEY AUTO_INCREMENT,
    dtRegistro DATETIME,
	preco DECIMAL(5,2),
    fkEmpresa INT,
    FOREIGN KEY (fkEmpresa)
    REFERENCES Empresa(idEmpresa)
);

Insert into Lote (dtRegistro, preco, fkEmpresa) Values
("2025-08-28 14:15:07", 140.000, 1);

CREATE TABLE Maquina (
	idMaquina INT PRIMARY KEY AUTO_INCREMENT,
    sistemaOperacional VARCHAR(45),
    marca VARCHAR(45),
    fkLote INT,
    FOREIGN KEY (fkLote)
    REFERENCES Lote(idLote)
);

Insert into Maquina (sistemaOperacional, marca, fkLote) values
("Linux", "Dell", 1);

CREATE TABLE Componente (
	idComponente INT auto_increment,
    fkMaquina INT,
    nome VARCHAR(45),
    tipo VARCHAR(45),
    capacidade VARCHAR(45),
    fabricante VARCHAR(45),
    preco DECIMAL(4,2),
    PRIMARY KEY (idComponente, fkMaquina),
    FOREIGN KEY (fkMaquina)
    REFERENCES Maquina(idMaquina)
);

INSERT INTO Componente (idComponente, fkMaquina, nome, tipo, capacidade, fabricante, preco) VALUES 
(default, 1, 'Memória RAM', 'Hardware', '16GB DDR4', 'Kingston', 29.99), 
(default, 1, 'Disco Rígido', 'Hardware', '1TB', 'Seagate', 99.00),
(default, 1, 'Processador', 'Hardware', 'Intel i7', 'Intel', 10.00);

CREATE TABLE Nucleo (
	idNucleo INT,
    fkComponente INT, 
    numeroNucleo INT,
    PRIMARY KEY (idNucleo, fkComponente),
    FOREIGN KEY (fkComponente)
    REFERENCES Componente(idComponente)
);

INSERT INTO Nucleo (idNucleo, fkComponente, numeroNucleo) VALUES
(1, 3, 1),
(2, 3, 2),
(3, 3, 3),
(4, 3, 4),
(5, 3, 5),
(6, 3, 6),
(7, 3, 7),
(8, 3, 8),
(9, 3, 9),
(10, 3, 10),
(11, 3, 11),
(12, 3, 12);

CREATE TABLE Captura (
    idCaptura INT AUTO_INCREMENT,
	fkComponente INT,
    fkNucleo INT,
    gbLivre FLOAT,
    gbEmUso FLOAT,
    porcentagemDeUso FLOAT,
    hostname VARCHAR(45),
    dtCaptura TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (idCaptura, fkComponente),
    FOREIGN KEY (fkComponente)
    REFERENCES Componente(idComponente),
    FOREIGN KEY (fkNucleo)
    REFERENCES Nucleo(idNucleo)
);


-- Select dos dados importantes para vizualização da Inserção no Banco de Dados
SELECT 
u.nome              AS Usuario,
e.razaoSocial       AS Empresa,
m.marca             AS Maquina,
m.sistemaOperacional AS SistemaOperacional,
c.nome              AS Componente,
CONCAT(ROUND(cap.gbEmUso, 1), " GB")          AS "GigaBytes EM USO",
CONCAT(ROUND(gbLivre, 2), " GB" )       AS "GigaBytes Livre",
CONCAT(cap.porcentagemDeUso, "%")          AS "Porcentagem EM USO",
cap.dtCaptura       AS DataCaptura
FROM Usuario u
JOIN Empresa e     ON u.fkEmpresa = e.idEmpresa
JOIN Lote l        ON e.idEmpresa = l.fkEmpresa
JOIN Maquina m     ON l.idLote = m.fkLote
JOIN Componente c  ON m.idMaquina = c.fkMaquina
LEFT JOIN Captura cap   ON c.idComponente = cap.fkComponente;



-- Select para ver porcentagem Da memoria
SELECT 
u.nome              AS Usuario,
e.razaoSocial       AS Empresa,
m.marca             AS Maquina,
m.sistemaOperacional AS SistemaOperacional,
c.nome   AS Componente,
CONCAT(ROUND(cap.gbEmUso, 1), " GB")          AS "GigaBytes EM USO",
CONCAT(ROUND(gbLivre, 2), " GB" )       AS "GigaBytes Livre",
cap.dtCaptura       AS DataCaptura
FROM Usuario u
JOIN Empresa e     ON u.fkEmpresa = e.idEmpresa
JOIN Lote l        ON e.idEmpresa = l.fkEmpresa
JOIN Maquina m     ON l.idLote = m.fkLote
JOIN Componente c  ON m.idMaquina = c.fkMaquina
LEFT JOIN Captura cap   ON c.idComponente = cap.fkComponente
where c.nome = "Memoria RAM";

-- Select para ver dados da cpu

SELECT 
u.nome              AS Usuario,
e.razaoSocial       AS Empresa,
m.marca             AS Maquina,
m.sistemaOperacional AS SistemaOperacional,
c.nome   AS Componente,
CONCAT(cap.porcentagemDeUso, "%")          AS "Porcentagem EM USO",
cap.dtCaptura       AS DataCaptura
FROM Usuario u
JOIN Empresa e     ON u.fkEmpresa = e.idEmpresa
JOIN Lote l        ON e.idEmpresa = l.fkEmpresa
JOIN Maquina m     ON l.idLote = m.fkLote
JOIN Componente c  ON m.idMaquina = c.fkMaquina
LEFT JOIN Captura cap   ON c.idComponente = cap.fkComponente
where c.nome = "Processador";

