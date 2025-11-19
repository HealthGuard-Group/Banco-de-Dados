DROP DATABASE IF EXISTS HealthGuard;

CREATE DATABASE IF NOT EXISTS HealthGuard;

USE HealthGuard;

-- Label entidades relacionadas a Central
CREATE TABLE UnidadeDeAtendimento (

idUnidadeDeAtendimento INT PRIMARY KEY AUTO_INCREMENT,

razaoSocial VARCHAR(100) NOT NULL,

nomeFantasia VARCHAR(100) NOT NULL,

cnpj CHAR(14) NOT NULL,

unidadeGestora VARCHAR(100) NOT NULL
);

CREATE TABLE TipoDeContato (

idTipoDeContato INT PRIMARY KEY AUTO_INCREMENT,

formaDeContato VARCHAR(100)
);

CREATE TABLE TipoDia (

idTipoDia INT PRIMARY KEY AUTO_INCREMENT,

nome VARCHAR(100)
);

CREATE TABLE Endereco (

idEndereco INT AUTO_INCREMENT,

fkUnidadeAtendimento INT,

CONSTRAINT pkCompostaEndereco PRIMARY KEY (idEndereco,fkUnidadeAtendimento),

cep CHAR(8) NOT NULL,

uf CHAR(2) NOT NULL,

cidade VARCHAR(100) NOT NULL,

bairro VARCHAR(100) NOT NULL,

logradouro VARCHAR(100) NOT NULL,

numero VARCHAR(100) NOT NULL,

complemento VARCHAR(100) DEFAULT NULL,

CONSTRAINT fkEnderecoUnidadeDeAtendimento FOREIGN KEY (fkUnidadeAtendimento) REFERENCES UnidadeDeAtendimento(idUnidadeDeAtendimento)
);

CREATE TABLE ContatosParaAlerta (
idContatosParaAlerta INT AUTO_INCREMENT,

fkUnidadeDeAtendimento INT,

CONSTRAINT pkCompostaContatosParaAlerta PRIMARY KEY (idContatosParaAlerta,fkUnidadeDeAtendimento),

nome VARCHAR(100) NOT NULL,

cargo VARCHAR(100) NOT NULL,

email VARCHAR(100),

nivelEscalonamento VARCHAR(100) NOT NULL,

CONSTRAINT fkContatosParaAlertaUnidadeDeAtendimento FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES UnidadeDeAtendimento(idUnidadeDeAtendimento)
);

CREATE TABLE MeioDeContato (

idMeioDeContato INT AUTO_INCREMENT,

fkContatoParaAlertas INT,

fkUnidadeDeAtendimento INT,

fkTipodeContato INT,

CONSTRAINT pkCompostaMeioDeContato PRIMARY KEY (idMeioDeContato,fkContatoParaAlertas,fkUnidadeDeAtendimento,fkTipodeContato),

contato VARCHAR(100),


CONSTRAINT fkMeioDeContato_ContatosParaAlerta FOREIGN KEY (fkContatoParaAlertas, fkUnidadeDeAtendimento) 
    REFERENCES ContatosParaAlerta(idContatosParaAlerta, fkUnidadeDeAtendimento),


CONSTRAINT fkMeioDeContatoTipodeContato FOREIGN KEY (fkTipodeContato) REFERENCES TipoDeContato(idTipoDeContato)
);

CREATE TABLE HorarioDisponibilidade (

idHorarioDisponibilidade INT AUTO_INCREMENT,

fkContatoParaAlertas INT,

fkUnidadeDeAtendimento INT,

fkTipoDia INT,

CONSTRAINT pkCompostaDiasDisponiveis PRIMARY KEY (idHorarioDisponibilidade,fkContatoParaAlertas,fkUnidadeDeAtendimento,fkTipoDia),

horarioEntrada TIME,

horarioSaida TIME,

CONSTRAINT fkHorarioDisponibilidade_ContatosParaAlerta FOREIGN KEY (fkContatoParaAlertas, fkUnidadeDeAtendimento) 
    REFERENCES ContatosParaAlerta(idContatosParaAlerta, fkUnidadeDeAtendimento),


CONSTRAINT fkHorarioDisponibilidadeTipoDia FOREIGN KEY (fkTipoDia) REFERENCES TipoDia(idTipoDia)
);

-- Label entidades relacionadas ao usuário

CREATE TABLE Permissoes (

idPermissoes INT PRIMARY KEY AUTO_INCREMENT,

nome VARCHAR(100) NOT NULL,

descricao VARCHAR(500)
);

CREATE TABLE CodigoValidacaoUsuario (

idCodigoValidacao INT AUTO_INCREMENT,

fkUnidadeDeAtendimento INT,

fkPermissoes INT,

CONSTRAINT pkCompostaCodigoValidacaoUsuario PRIMARY KEY (idCodigoValidacao,fkUnidadeDeAtendimento,fkPermissoes),

codigo VARCHAR(100) NOT NULL,

dataCriacao DATETIME DEFAULT CURRENT_TIMESTAMP,

dataExpiracao DATETIME NOT NULL,

emailSugerido VARCHAR(100) NOT NULL,

nomeSugerido VARCHAR(100) NOT NULL,

statusCodigoValidacaoUsuario VARCHAR(100) DEFAULT "Pendente",

CONSTRAINT chkStatusCodigoValidacaoUsuario CHECK (statusCodigoValidacaoUsuario in("Pendente","Aceito","Expirado","Revogado")),

CONSTRAINT fkCodigoValidacaoUsuarioUnidadeDeAtendimento FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES UnidadeDeAtendimento(idUnidadeDeAtendimento),
CONSTRAINT fkCodigoValidacaoUsuarioPermissoes FOREIGN KEY (fkPermissoes) REFERENCES Permissoes(idPermissoes)
);

CREATE TABLE Usuario (

idUsuario INT AUTO_INCREMENT PRIMARY KEY, 
fkPermissoes INT,

nome VARCHAR(100) NOT NULL,

email VARCHAR(100) NOT NULL UNIQUE,

senha VARCHAR(256) NOT NULL,

cpf CHAR(11) NOT NULL,

CONSTRAINT fkUsuarioPermissoes FOREIGN KEY (fkPermissoes) REFERENCES Permissoes(idPermissoes)
);


CREATE TABLE LogAcesso(

idLogAcesso INT AUTO_INCREMENT,

fkUnidadeDeAtendimento INT,

fkUsuario INT,

CONSTRAINT pkCompostaLogAcesso PRIMARY KEY (idLogAcesso,fkUnidadeDeAtendimento,fkUsuario),

dataAcesso DATETIME DEFAULT CURRENT_TIMESTAMP,

CONSTRAINT fkLogAcessoUnidadeDeAtendimento FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES UnidadeDeAtendimento(idUnidadeDeAtendimento),
CONSTRAINT fkLogAcessoUsuario FOREIGN KEY (fkUsuario) REFERENCES Usuario(idUsuario)
);

CREATE TABLE LogAcoes (

idLogAcoes INT AUTO_INCREMENT,

fkUnidadeAtendimento INT,

fkLogAceso INT,

fkUsuario INT,

CONSTRAINT pkCompostaLogAcoes PRIMARY KEY (idLogAcoes,fkUnidadeAtendimento,fkLogAceso,fkUsuario),

acao VARCHAR(1000) NOT NULL,

horarioDaAcao DATETIME DEFAULT CURRENT_TIMESTAMP,

statusAcao VARCHAR(100),

CONSTRAINT fkLogAcoes_LogAcesso FOREIGN KEY (fkLogAceso, fkUnidadeAtendimento, fkUsuario)
    REFERENCES LogAcesso(idLogAcesso, fkUnidadeDeAtendimento, fkUsuario)

);

CREATE TABLE CodigoRecuperacaoSenha (

idCodigoRecuperacaoSenha INT AUTO_INCREMENT,

fkPermissoes INT,

fkUsuario INT UNIQUE,

CONSTRAINT pkCompostaCodigoRecuperacaoSenha PRIMARY KEY (idCodigoRecuperacaoSenha,fkPermissoes,fkUsuario),

codigo CHAR(6) NOT NULL,

dataCriacao DATETIME DEFAULT CURRENT_TIMESTAMP,

CONSTRAINT fkCodigoRecuperacaoSenhaUsuario FOREIGN KEY (fkUsuario) REFERENCES Usuario(idUsuario),
CONSTRAINT fkCodigoRecuperacaoSenhaPermissoes FOREIGN KEY (fkPermissoes) REFERENCES Usuario(fkPermissoes)
);

CREATE TABLE CodigoConfiguracaoMaquina(

idCodigoConfiguracao INT AUTO_INCREMENT,

fkUnidadeDeAtendimento INT,

CONSTRAINT pkCompostaCodigoConfiguracaoMaquina PRIMARY KEY (idCodigoConfiguracao,fkUnidadeDeAtendimento),

codigo VARCHAR(100) NOT NULL,

dataCriacao DATETIME DEFAULT CURRENT_TIMESTAMP,

dataExpiracao DATETIME NOT NULL,

statusCodigoConfiguracaoMaquina VARCHAR(45) DEFAULT "Pendente",
CONSTRAINT chkstatusCodigoConfiguracaoMaquina CHECK (statusCodigoConfiguracaoMaquina in("Pendente","Aceito","Expirado")),

CONSTRAINT fkCodigoConfiguracaoMaquinaUnidadeDeAtendimento FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES UnidadeDeAtendimento(idUnidadeDeAtendimento)
);

CREATE TABLE Dac (

idDac INT AUTO_INCREMENT,

fkUnidadeDeAtendimento INT,

CONSTRAINT pkCompostaDac PRIMARY KEY (idDac,fkUnidadeDeAtendimento),

nomeIdentificacao VARCHAR(100) NOT NULL,

statusDac VARCHAR(100) DEFAULT "Em configuração",
CONSTRAINT chkStatusDac CHECK (statusDac in("Ativo","Inativo","Excluido","Alerta","Em configuração")),

codigoValidacao VARCHAR(256) NOT NULL,

descricao VARCHAR(500) DEFAULT "",

CONSTRAINT fkDacUnidadeDeAtendimento FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES UnidadeDeAtendimento(idUnidadeDeAtendimento)
);

CREATE TABLE MedicoesDisponiveis (

idMedicoesDisponiveis INT PRIMARY KEY AUTO_INCREMENT,

nomeDaMedicao VARCHAR(100),

unidadeDeMedida VARCHAR(100)
);

CREATE TABLE MedicoesSelecionadas (

idMedicoesSelecionadas INT AUTO_INCREMENT,

fkMedicoesDisponiveis INT,

fkDac INT,

fkUnidadeDeAtendimento INT,

CONSTRAINT pkCompostaMedicoesSelecionadas PRIMARY KEY(idMedicoesSelecionadas,fkMedicoesDisponiveis,fkDac,fkUnidadeDeAtendimento),

dataConfiguracao DATETIME DEFAULT CURRENT_TIMESTAMP,

CONSTRAINT fkMedicoesSelecionadas_Dac FOREIGN KEY (fkDac, fkUnidadeDeAtendimento) 
    REFERENCES Dac(idDac, fkUnidadeDeAtendimento),

CONSTRAINT fkMedicoesSelecionadasMedicoesDisponiveis FOREIGN KEY (fkMedicoesDisponiveis) REFERENCES MedicoesDisponiveis(idMedicoesDisponiveis)
);

CREATE TABLE Leitura (

idLeitura INT AUTO_INCREMENT,

fkUnidadeDeAtendimento INT,

fkMedicoesDisponiveis INT,

fkDac INT,

fkMedicoesSelecionadas INT,

CONSTRAINT pkCompostaLeitura PRIMARY KEY (idLeitura,fkUnidadeDeAtendimento,fkMedicoesDisponiveis,fkDac,fkMedicoesSelecionadas),

medidaCapturada VARCHAR(100),

dataCaptura DATETIME DEFAULT CURRENT_TIMESTAMP,

CONSTRAINT fkLeitura_MedicoesSelecionadas FOREIGN KEY (fkMedicoesSelecionadas, fkMedicoesDisponiveis, fkDac, fkUnidadeDeAtendimento)
    REFERENCES MedicoesSelecionadas(idMedicoesSelecionadas, fkMedicoesDisponiveis, fkDac, fkUnidadeDeAtendimento)

);

CREATE TABLE Alerta (

idAlerta INT AUTO_INCREMENT,

fkLeitura INT,

fkDac INT,

fkMedicoesSelecionadas INT,

fkUnidadeDeAtendimento INT,

fkMedicoesDisponiveis INT,

CONSTRAINT pkCompostaAlerta PRIMARY KEY (idAlerta,fkLeitura,fkDac,fkMedicoesSelecionadas,fkUnidadeDeAtendimento,fkMedicoesDisponiveis),

dataDoAlerta DATETIME DEFAULT CURRENT_TIMESTAMP,

CONSTRAINT fkAlerta_Leitura FOREIGN KEY (fkLeitura, fkUnidadeDeAtendimento, fkMedicoesDisponiveis, fkDac, fkMedicoesSelecionadas)
    REFERENCES Leitura(idLeitura, fkUnidadeDeAtendimento, fkMedicoesDisponiveis, fkDac, fkMedicoesSelecionadas)

);

CREATE TABLE MetricaAlerta (

idMetricaAlerta INT AUTO_INCREMENT,

fkMedicoesDisponiveis INT,

fkUnidadeDeAtendimento INT,

CONSTRAINT pkCompostaMetricaAlerta PRIMARY KEY (idMetricaAlerta,fkMedicoesDisponiveis,fkUnidadeDeAtendimento),

fkDac INT,

fkUnidadeDeAtendimentoDac INT,

nomeNivel VARCHAR(100) NOT NULL,

valorMinimo FLOAT,

valorMaximo FLOAT,

dataCriacao DATETIME DEFAULT CURRENT_TIMESTAMP,


CONSTRAINT fkMetricaAlertaMedicoesDisponiveis FOREIGN KEY (fkMedicoesDisponiveis) REFERENCES MedicoesDisponiveis(idMedicoesDisponiveis),
CONSTRAINT fkMetricaAlertaUnidadeDeAtendimento FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES UnidadeDeAtendimento(idUnidadeDeAtendimento),

CONSTRAINT fkMetricaAlerta_Dac FOREIGN KEY (fkDac, fkUnidadeDeAtendimentoDac) 
    REFERENCES Dac(idDac, fkUnidadeDeAtendimento)

);


DROP USER IF EXISTS logan;

CREATE USER 'logan'@'%' IDENTIFIED BY 'senha-segura123';
GRANT INSERT,SELECT,UPDATE,DELETE ON HealthGuard.* TO 'logan'@'%';
FLUSH PRIVILEGES;
