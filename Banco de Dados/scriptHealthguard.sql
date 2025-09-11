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

CREATE TABLE OrgaoPublico (
	idOrgao INT PRIMARY KEY AUTO_INCREMENT,
    razaoSocial VARCHAR(45),
    telefone CHAR(11),
    email VARCHAR(45),
    cnpj CHAR(14)
);

INSERT INTO OrgaoPublico (razaoSocial, telefone, email, cnpj) VALUES
("Prefeitura de São Paulo", 11941924548, "saopaulo@org.com.br", 12345678912345);

CREATE TABLE CentralAtendimento (
	idCentral INT AUTO_INCREMENT,
    fkOrgao INT,
    fkEndereco INT,
    nome VARCHAR(45),
    email VARCHAR(45),
	telefone CHAR(11),
    PRIMARY KEY (idCentral, fkOrgao),
    FOREIGN KEY (fkOrgao)
    REFERENCES OrgaoPublico(idOrgao),
    FOREIGN KEY (fkEndereco)
    REFERENCES Endereco(idEndereco)
);

INSERT INTO CentralAtendimento (fkOrgao, fkEndereco, nome, email, telefone) VALUES
(1, 1, "SAMU Esperança", "samuesperanca@gmail.com", 934891828);

CREATE TABLE CodigoAtivacao (
	idCodigo INT PRIMARY KEY AUTO_INCREMENT,
    fkCentral INT,
    codigo VARCHAR(45),
    validade DATE,
    qtdUsos INT,
    FOREIGN KEY (fkCentral)
    REFERENCES CentralAtendimento(idCentral)
);

INSERT INTO CodigoAtivacao (fkCentral, codigo, validade, qtdUsos) VALUES 
(1, "00j12", "2025-09-11", 10);

CREATE TABLE TipoUsuario (
	idTipo INT PRIMARY KEY AUTO_INCREMENT, 
    tipo VARCHAR(45),
    permissao VARCHAR(100)
);

INSERT INTO TipoUsuario (tipo, permissao) VALUES
("Administrador", "Ler, escrever, executar e gerenciar usuários e permissões");

CREATE TABLE Usuario (
	idUsuario INT AUTO_INCREMENT,
    fkTipo INT,
    fkCentral INT,
    nome VARCHAR(45),
    email VARCHAR(45),
    senha VARCHAR(45),
    cpf CHAR(11),
    PRIMARY KEY (idUsuario, fkTipo),
    FOREIGN KEY (fkTipo)
    REFERENCES TipoUsuario(idTipo),
    FOREIGN KEY (fkCentral)
    REFERENCES CentralAtendimento(idCentral)
);

INSERT INTO Usuario (fkTipo, fkCentral, nome, email, senha, cpf) VALUES 
(1, 1, "Ryan Patric", "ryanpina@gmail.com", "urubu100", 55754898548);

CREATE TABLE Maquina (
	idMaquina INT PRIMARY KEY AUTO_INCREMENT,
    fkCentral INT,
    sistemaOperacional VARCHAR(45),
    marca VARCHAR(45),
    modelo VARCHAR(45),
    FOREIGN KEY (fkCentral)
    REFERENCES CentralAtendimento(idCentral)
);

Insert into Maquina (fkCentral,sistemaOperacional, marca, modelo) values
(1, "Linux", "Dell", "Inspiron 15");

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
	idAlerta INT PRIMARY KEY AUTO_INCREMENT,
    fkCaptura INT,
    nivel VARCHAR(45),
    mensagem VARCHAR(80),
    status VARCHAR(45),
    dtEmissao TIMESTAMP,
    FOREIGN KEY (fkCaptura)
    REFERENCES Captura(idCaptura)
);

CREATE TABLE Parametro (
	idParametro INT AUTO_INCREMENT,
    fkComponente INT, 
    nivel VARCHAR(45),
    minimo VARCHAR(45),
    maximo VARCHAR(45),
    PRIMARY KEY (idParametro, fkComponente),
    FOREIGN KEY (fkComponente)
    REFERENCES Componente(idComponente)
);



SELECT 
                    u.nome AS Usuario,
                    c.nome AS Central,
                    m.marca AS Maquina,
                    m.sistemaOperacional AS SistemaOperacional,
                    co.nome AS Componente,
                    CONCAT(cap.porcentagemDeUso, "%") AS Percentual,
                    cap.dtCaptura AS DataCaptura
                FROM Usuario u
                JOIN CentralAtendimento c ON u.fkCentral = c.idCentral
                JOIN Maquina m ON m.fkCentral = c.idCentral
                JOIN Componente co ON m.idMaquina = co.fkMaquina
                LEFT JOIN Captura cap ON co.idComponente = cap.fkComponente
                WHERE co.nome = "Processador"
                ORDER BY cap.dtCaptura DESC;

					SELECT 
                    u.nome AS Usuario,
                    c.nome AS Central,
                    m.marca AS Maquina,
                    m.sistemaOperacional AS SistemaOperacional,
                    co.nome AS Componente,
                    CONCAT(cap.gbLivre, " GB") AS MemoriaLivre,
                    CONCAT(cap.gbEmUso, " GB") AS MemoriaEmUso,
                    cap.dtCaptura AS DataCaptura
                FROM Usuario u
                JOIN CentralAtendimento c ON u.fkCentral = c.idCentral
                JOIN Maquina m ON m.fkCentral = c.idCentral
                JOIN Componente co ON m.idMaquina = co.fkMaquina
                LEFT JOIN Captura cap ON co.idComponente = cap.fkComponente
                WHERE co.nome = "Memória RAM"
                ORDER BY cap.dtCaptura DESC;


SELECT 
                    u.nome AS Usuario,
                    c.nome AS Central,
                    m.marca AS Maquina,
                    m.sistemaOperacional AS SistemaOperacional,
                    c.nome AS Componente,
                    CONCAT(ROUND(cap.gbLivre,2), " GB") AS GBLivre,
                    CONCAT(ROUND(cap.gbEmUso,2), " GB") AS GBEmUso,
                    CONCAT(cap.porcentagemDeUso, "%") AS Percentual,
                    cap.dtCaptura AS DataCaptura
                FROM Usuario u
                JOIN CentralAtendimento c ON u.fkCentral = c.idCentral
                JOIN Maquina m ON m.fkCentral = c.idCentral
                JOIN Componente co ON m.idMaquina = co.fkMaquina
                LEFT JOIN Captura cap ON co.idComponente = cap.fkComponente
                WHERE co.nome = "Disco Rígido"
                ORDER BY cap.dtCaptura DESC;
                