CREATE DATABASE grupo9;

USE grupo9;

CREATE TABLE Usuario (
	idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45),
    email VARCHAR(45),
    senha VARCHAR(45),
    fkEmpresa INT,
    FOREIGN KEY (fkEmpresa)
    REFERENCES Empresa(idEmpresa)
);

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

CREATE TABLE Endereco (
	idEndereco INT PRIMARY KEY AUTO_INCREMENT,
    logradouro VARCHAR(45),
    numero VARCHAR(45),
    cidade VARCHAR(45),
    bairro VARCHAR(45),
    uf CHAR(2)
);

CREATE TABLE Lote (
	idLote INT PRIMARY KEY AUTO_INCREMENT,
    dtRegistro DATETIME,
	preco DECIMAL(5,2),
    fkEmpresa INT,
    FOREIGN KEY (fkEmpresa)
    REFERENCES Empresa(idEmpresa)
);

CREATE TABLE ComputadorDeDespacho (
	idComputador INT PRIMARY KEY AUTO_INCREMENT,
    sistemaOperacional VARCHAR(45),
    marca VARCHAR(45),
    fkLote INT,
    FOREIGN KEY (fkLote)
    REFERENCES Lote(idLote)
);

CREATE TABLE Captura (
	idCaptura INT PRIMARY KEY AUTO_INCREMENT,
    valor FLOAT,
    dtCaptura TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fkComputador INT,
    FOREIGN KEY (fkComputador)
    REFERENCES ComputadorDeDespacho(idComputador)
);

CREATE TABLE Componente (
	idComponente INT,
    fkComputador INT,
    nome VARCHAR(45),
    tipo VARCHAR(45),
    capacidade VARCHAR(45),
    fabricante VARCHAR(45),
    preco DECIMAL(4,2),
    PRIMARY KEY (idComponente, fkComputador),
    FOREIGN KEY (fkComputador)
    REFERENCES ComputadorDeDespacho(idComputador)
);



