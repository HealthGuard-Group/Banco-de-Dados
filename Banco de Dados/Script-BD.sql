CREATE DATABASE healthguard;
USE healthguard;


CREATE TABLE Empresa (
	idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    razaoSocial VARCHAR(45),
    telefone CHAR(11),
    cnpj CHAR(14),
    email VARCHAR(45)
);

Insert into Empresa (razaoSocial, telefone, cnpj, email) values
("Serviços Integrados de Urgência e Emergência", 11937131341, 51407659000106, "healthguard@gmail.com");

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


CREATE TABLE CentralAtendimento (
	idCentral INT AUTO_INCREMENT,
    fkEmpresa INT,
    fkEndereco INT,
    nome VARCHAR(45),
    codigoCentral INT, 
    email VARCHAR(45),
    telefone CHAR(11),
    PRIMARY KEY (idCentral, fkEmpresa),
    FOREIGN KEY (fkEmpresa)
    REFERENCES Empresa (idEmpresa)
);

INSERT INTO CentralAtendimento (fkEmpresa, fkEndereco, nome, codigoCentral, email, telefone) VALUES
(1, 1, "Salvando Vidas", 1212, "salvando@gmail.com", 11910887786);

CREATE TABLE Usuario (
	idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    email VARCHAR(45),
    senha VARCHAR(45),
    telefone CHAR(11),
    fkCentral INT,
    FOREIGN KEY (fkCentral)
    REFERENCES CentralAtendimento(idCentral)
);

INSERT INTO Usuario (nome, email, senha, telefone, fkCentral) VALUES 
("Felipe", "Felipe.ferraz@sptech.school", "SPTech2024", "11931548458", 1);

CREATE TABLE Permissao (
	idPermissao INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(45),
    descricao VARCHAR(100)
);

INSERT INTO Permissao (tipo, descricao) VALUES
("ROOT", "Excluir usuários");

CREATE TABLE UsuarioPermissao (
	fkUsuario INT,
    fkPermissao INT,
    PRIMARY KEY (fkUsuario, fkPermissao),
    FOREIGN KEY (fkUsuario)
    REFERENCES Usuario(idUsuario),
    FOREIGN KEY (fkPermissao)
    REFERENCES Permissao(idPermissao)
);

INSERT INTO UsuarioPermissao (fkUsuario, fkPermissao) VALUES
(1,1);

CREATE TABLE CompraMaquina (
	idCompra INT PRIMARY KEY AUTO_INCREMENT, 
    fkCentral INT,
    dtRegistro DATETIME,
    preco DECIMAL(6,2),
    quantidade INT,
    notaFiscal VARCHAR(50),
    FOREIGN KEY (fkCentral)
    REFERENCES CentralAtendimento (idCentral)
);

INSERT INTO CompraMaquina (fkCentral, dtRegistro, preco, quantidade, notaFiscal) VALUES
(1, "2025-09-08 20:00:00", 1000.0, 50, "0000011910887786");

CREATE TABLE Maquina (
	idMaquina INT PRIMARY KEY AUTO_INCREMENT,
    sistemaOperacional VARCHAR(45),
    marca VARCHAR(45),
    modelo VARCHAR(45),
    fkCompra INT,
    FOREIGN KEY (fkCompra)
    REFERENCES CompraMaquina(idCompra)
);

Insert into Maquina (sistemaOperacional, marca, modelo ,fkCompra) values
("Linux", "Dell", "Inspiron 15", 1);

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

CREATE TABLE Captura (
    idCaptura INT AUTO_INCREMENT,
	fkComponente INT,
    gbLivre FLOAT,
    gbEmUso FLOAT,
    porcentagemDeUso FLOAT,
    hostname VARCHAR(45),
    dtCaptura TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (idCaptura, fkComponente),
    FOREIGN KEY (fkComponente)
    REFERENCES Componente(idComponente)
);


CREATE TABLE Alerta (
	idAlerta INT,
    fkCaptura INT,
    tipo VARCHAR(45), 
    nivel VARCHAR(25),
    mensagem VARCHAR(80),
    status VARCHAR(45),
    dtEmissao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (idAlerta, fkCaptura),
    FOREIGN KEY (fkCaptura)
    REFERENCES Captura(idCaptura)
);


-- AJUSTAR SELECTS!!!!!!!!!!!


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

-- disco select

SELECT 
u.nome              AS Usuario,
e.razaoSocial       AS Empresa,
m.marca             AS Maquina,
m.sistemaOperacional AS SistemaOperacional,
c.nome   AS Componente,
CONCAT(cap.porcentagemDeUso, "%")          AS "Porcentagem EM USO",
CONCAT(ROUND(cap.gbEmUso, 1), " GB")          AS "GigaBytes EM USO",
CONCAT(ROUND(gbLivre, 2), " GB" )       AS "GigaBytes Livre",
cap.dtCaptura       AS DataCaptura
FROM Usuario u
JOIN Empresa e     ON u.fkEmpresa = e.idEmpresa
JOIN Lote l        ON e.idEmpresa = l.fkEmpresa
JOIN Maquina m     ON l.idLote = m.fkLote
JOIN Componente c  ON m.idMaquina = c.fkMaquina
LEFT JOIN Captura cap   ON c.idComponente = cap.fkComponente
where c.nome = "Disco Rígido";

select * from captura;
