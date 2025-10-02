DROP DATABASE IF EXISTS HealthGuard;

CREATE DATABASE IF NOT EXISTS HealthGuard;

USE HealthGuard;

-- Label Empresa
CREATE TABLE UnidadeDeAtendimento (

idUnidadeDeAtendimento INT PRIMARY KEY AUTO_INCREMENT,

razaoSocial VARCHAR(100) 			NOT NULL,

nomeFantasia VARCHAR(100) 			DEFAULT NULL,

cnpj CHAR(14) 						NOT NULL,

unidadeGestora VARCHAR(100) 		NOT NULL
);

CREATE TABLE Endereco (

idEndereco 					INT AUTO_INCREMENT,

fkUnidadeDeAtendimento 		INT,
CONSTRAINT pkCompostaEndereco PRIMARY KEY (idEndereco, fkUnidadeDeAtendimento),

cep CHAR(8) 				NOT NULL,

uf CHAR(2) 					NOT NULL,

cidade VARCHAR(100) 		NOT NULL,

bairro VARCHAR(100) 		NOT NULL,

logradouro VARCHAR(100) 	NOT NULL,

numero VARCHAR(45) 			NOT NULL,

complemento VARCHAR(45) 	DEFAULT NULL,

CONSTRAINT fkEnderecoUnidadeDeAtendimento FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES UnidadeDeAtendimento(idUnidadeDeAtendimento)
);

CREATE TABLE ContatoParaAlertas (
idContatoParaAlertas 		INT AUTO_INCREMENT,

fkUnidadeDeAtendimento 		INT,
CONSTRAINT pkCompostaContatoParaAlertas PRIMARY KEY (idContatoParaAlertas,fkUnidadeDeAtendimento),

nome VARCHAR(100) 			NOT NULL,

cargo VARCHAR(45) 			NOT NULL,

email VARCHAR(100) 			DEFAULT NULL,

telefone CHAR(11) 			DEFAULT NULL,

disponibilidadeDeHorario 	VARCHAR(45) NOT NULL,

nivelEscalonamento 			VARCHAR(45) NOT NULL,

CONSTRAINT fkContatoParaAlertasUnidadeDeAtendimento FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES UnidadeDeAtendimento(idUnidadeDeAtendimento)
);

CREATE TABLE CodigoValidacao (
idCodigoValidacao 			INT AUTO_INCREMENT,

fkUnidadeDeAtendimento 		INT,
CONSTRAINT pkCompostaCodigoValidacao PRIMARY KEY (idCodigoValidacao,fkUnidadeDeAtendimento),

codigo 						CHAR(15),

dataCriacao 				DATETIME DEFAULT CURRENT_TIMESTAMP,

dataExpiracao 				DATETIME DEFAULT CURRENT_TIMESTAMP,

statusCodigo 				VARCHAR(45) DEFAULT 'Pedente',
CONSTRAINT chkStatusCodigoValidacao CHECK (statusCodigo in('Pedente','Aceito','Expirado')),

CONSTRAINT fkCodigoValidacaoUnidadeDeAtendimento FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES UnidadeDeAtendimento(idUnidadeDeAtendimento)
);

CREATE TABLE CodigoConfiguracao (
idCodigoConfiguracao 		INT AUTO_INCREMENT,

fkUnidadeDeAtendimento 		INT,
CONSTRAINT pkCompostaCodigoValidacao PRIMARY KEY (idCodigoConfiguracao,fkUnidadeDeAtendimento),

codigo 						CHAR(20),

dataCriacao 				DATETIME DEFAULT CURRENT_TIMESTAMP,

dataExpiracao 				DATETIME DEFAULT CURRENT_TIMESTAMP,

statusCodigo 				VARCHAR(45) DEFAULT 'Pedente',
CONSTRAINT chkStatusCodigoConfiguracao CHECK (statusCodigo in('Pedente','Aceito','Expirado')),

CONSTRAINT fkCodigoConfiguracaoUnidadeDeAtendimento FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES UnidadeDeAtendimento(idUnidadeDeAtendimento)
);

-- Label Usuário 

CREATE TABLE Usuario (
idUsuario 			INT PRIMARY KEY AUTO_INCREMENT,

nome VARCHAR(100) 	NOT NULL,

email VARCHAR(100) 	NOT NULL,

senha VARCHAR(256) 	NOT NULL,

cpf 				CHAR(11)
);

CREATE TABLE LogAcesso (
idLogAcesso 				INT AUTO_INCREMENT,

fkUnidadeDeAtendimento 		INT,

fkUsuario 					INT,
CONSTRAINT pkCompostaLogAcesso PRIMARY KEY (idLogAcesso,fkUnidadeDeAtendimento,fkUsuario),

dataAcesso 					DATETIME DEFAULT CURRENT_TIMESTAMP,

CONSTRAINT fkLogAcessoUnidadeDeAtendimento FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES UnidadeDeAtendimento(idUnidadeDeAtendimento),
CONSTRAINT fkLogAcessoUsuario FOREIGN KEY (fkUsuario) REFERENCES Usuario(idUsuario)
);

CREATE TABLE LogAcoes (
idLogAcoes 				INT AUTO_INCREMENT,

fkUnidadeDeAtendimento 	INT,

fkUsuario 				INT,

fkLogAcesso 			INT,
CONSTRAINT pkCompostaLogAcoes PRIMARY KEY(idLogAcoes,fkUnidadeDeAtendimento,fkUsuario,fkLogAcesso),

acao VARCHAR(100) 		NOT NULL,

horarioDaAcao 			DATETIME DEFAULT CURRENT_TIMESTAMP,

CONSTRAINT fkLogAcoesUnidadeDeAtendimento FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES LogAcesso(fkUnidadeDeAtendimento),
CONSTRAINT fkLogAcoesUsuario FOREIGN KEY (fkUsuario) REFERENCES LogAcesso(fkUsuario),
CONSTRAINT fkLogAcoesLogAcesso FOREIGN KEY (fkLogAcesso) REFERENCES LogAcesso(idLogAcesso)
);

-- Label Captura

CREATE TABLE Dac (
idDac 						INT AUTO_INCREMENT,

fkUnidadeDeAtendimento 		INT,
CONSTRAINT pkCompostaDac PRIMARY KEY (idDac,fkUnidadeDeAtendimento),

nomeDeIdentificacao 		VARCHAR(100) NOT NULL,

statusDac VARCHAR(45) 		DEFAULT 'Inativo',
CONSTRAINT chkStatusDac CHECK (statusDac in('Ativo','Inativo','Excluido')),

codigoValidacao VARCHAR(256) 	NOT NULL,

CONSTRAINT fkDacUnidadeDeAtendimento FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES UnidadeDeAtendimento(idUnidadeDeAtendimento)
);

CREATE TABLE MedicoesDisponiveis (
idMedicoesDisponiveis 	INT PRIMARY KEY AUTO_INCREMENT,

nomeDaMedicao 			VARCHAR(100) NOT NULL,

unidadeDeMedida 	VARCHAR(45) NOT NULL
);

CREATE TABLE MedicoesSelecionadas (
idMedicoesSelecionadas 	INT AUTO_INCREMENT,

fkUnidadeDeAtendimento 	INT,

fkDac 					INT,

fkMedicoesDisponiveis 	INT,
CONSTRAINT pkCompostaMedicoesSelecionadas PRIMARY KEY (idMedicoesSelecionadas,fkUnidadeDeAtendimento,fkDac,fkMedicoesDisponiveis),

dataConfiguracao 		DATETIME DEFAULT CURRENT_TIMESTAMP,

CONSTRAINT fkMedicoesSelecionadasUnidadeDeAtendimento FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES Dac(fkUnidadeDeAtendimento),
CONSTRAINT fkMedicoesSelecionadasDac FOREIGN KEY (fkDac) REFERENCES Dac(idDac),
CONSTRAINT fkMedicoesSelecionadasMedicoesDisponiveis FOREIGN KEY (fkMedicoesDisponiveis) REFERENCES MedicoesDisponiveis(idMedicoesDisponiveis)
);

CREATE TABLE MetricaAlerta (
idMetricaAlerta 			INT AUTO_INCREMENT,

fkUnidadeDeAtendimento 		INT,

fkDac 						INT,

fkMedicoesDisponiveis 		INT,

fkMedicoesSelecionadas 		INT,
CONSTRAINT pkCompostaMetricaAlerta PRIMARY KEY(idMetricaAlerta,fkUnidadeDeAtendimento,fkDac,fkMedicoesDisponiveis,fkMedicoesSelecionadas),

nomeNivel VARCHAR(45) 		NOT NULL,

valorMinimo	 				FLOAT,

valorMaximo 				FLOAT,

dataCriacao 				DATETIME DEFAULT CURRENT_TIMESTAMP,

CONSTRAINT fkMetricaAlertaUnidadeDeAtendimento FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES MedicoesSelecionadas(fkUnidadeDeAtendimento),
CONSTRAINT fkMetricaAlertaDac FOREIGN KEY (fkDac) REFERENCES MedicoesSelecionadas(fkDac),
CONSTRAINT fkMetricaAlertaMedicoesDisponiveis  FOREIGN KEY (fkMedicoesDisponiveis) REFERENCES MedicoesSelecionadas(fkMedicoesDisponiveis),
CONSTRAINT fkMetricaAlertaMedicoesSelecionadas FOREIGN KEY (fkMedicoesSelecionadas) REFERENCES MedicoesSelecionadas(idMedicoesSelecionadas)
);

CREATE TABLE Alerta (
idAlerta INT AUTO_INCREMENT,

fkUnidadeDeAtendimento 		INT,

fkDac 						INT,

fkMedicoesDisponiveis 		INT,

fkMedicoesSelecionadas 		INT,

fkMetricaAlerta 			INT,
CONSTRAINT pkCompostaAlerta PRIMARY KEY (idAlerta,fkUnidadeDeAtendimento,fkDac,fkMedicoesDisponiveis,fkMedicoesSelecionadas,fkMetricaAlerta),

dataInicio 					DATETIME DEFAULT CURRENT_TIMESTAMP,

dataTermino 				DATETIME DEFAULT NULL,

CONSTRAINT fkAlertaUnidadeDeAtendimento FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES MetricaAlerta(fkUnidadeDeAtendimento),
CONSTRAINT fkAlertaDac FOREIGN KEY (fkDac) REFERENCES MetricaAlerta(fkDac),
CONSTRAINT fkMedicoesDisponiveis FOREIGN KEY (fkMedicoesDisponiveis) REFERENCES MetricaAlerta(fkMedicoesDisponiveis),
CONSTRAINT fkAlertaMedicoesSelecionadas FOREIGN KEY (fkMedicoesSelecionadas) REFERENCES MetricaAlerta(fkMedicoesSelecionadas),
CONSTRAINT fkAlertaMetricaAlerta FOREIGN KEY (fkMetricaAlerta) REFERENCES MetricaAlerta(idMetricaAlerta)
);

CREATE TABLE Leitura (
idLeitura INT AUTO_INCREMENT,
fkMedicoesDisponiveis INT,
fkMedicoesSelecionadas INT,
fkDac INT,
fkUnidadeDeAtendimento INT,
CONSTRAINT pkCompostaLeitura PRIMARY KEY (idLeitura,fkMedicoesDisponiveis,fkMedicoesSelecionadas,fkDac,fkUnidadeDeAtendimento),
medidaCapturada VARCHAR(45) NOT NULL,
dataCaptura DATETIME DEFAULT CURRENT_TIMESTAMP,
fkAlerta INT DEFAULT NULL,
fkMetricaAlerta INT DEFAULT NULL,
fkMedicoesDisponiveisAlerta INT DEFAULT NULL,
fkMedicoesSelecionadasAlerta INT DEFAULT NULL,
fkDacAlerta INT DEFAULT NULL,
fkUnidadeDeAtendimentoAlerta INT DEFAULT NULL,

-- FOREIGN KEYS das PKS
CONSTRAINT fkLeituraMedicoesDisponiveis FOREIGN KEY (fkMedicoesDisponiveis) REFERENCES MedicoesSelecionadas(fkMedicoesDisponiveis),
CONSTRAINT fkLeituraMedicoesSelecionadas FOREIGN KEY (fkMedicoesSelecionadas) REFERENCES MedicoesSelecionadas(idMedicoesSelecionadas),
CONSTRAINT fkLeituraDac FOREIGN KEY (fkDac) REFERENCES MedicoesSelecionadas(fkDac),
CONSTRAINT fkLeituraUnidadeDeAtendimento FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES MedicoesSelecionadas(fkUnidadeDeAtendimento),
-- FOREIGN KEYS da tabela alerta
CONSTRAINT fkLeituraAlerta FOREIGN KEY (fkAlerta) REFERENCES Alerta(idAlerta),
CONSTRAINT fkLeituraMetricaAlerta FOREIGN KEY (fkMetricaAlerta) REFERENCES Alerta(fkMetricaAlerta),
CONSTRAINT fkLeituraMedicoesDisponiveisAlerta FOREIGN KEY (fkMedicoesDisponiveisAlerta) REFERENCES Alerta(fkMedicoesDisponiveis),
CONSTRAINT fkLeituraMedicoesSelecionadasAlerta FOREIGN KEY (fkMedicoesSelecionadasAlerta) REFERENCES Alerta(fkMedicoesSelecionadas),
CONSTRAINT fkLeituraDacAlerta FOREIGN KEY (fkDacAlerta) REFERENCES Alerta(fkDac),
CONSTRAINT fkLeituraUnidadeDeAtendimentoAlerta FOREIGN KEY (fkUnidadeDeAtendimentoAlerta) REFERENCES Alerta(fkUnidadeDeAtendimento)
);

DROP USER IF EXISTS logan;
CREATE USER 'logan'@'%' IDENTIFIED BY 'senha-segura123';
GRANT INSERT,SELECT,UPDATE,DELETE ON HealthGuard.* TO 'logan'@'%';
FLUSH PRIVILEGES;


