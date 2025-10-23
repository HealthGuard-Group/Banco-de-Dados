DROP DATABASE IF EXISTS HealthGuard;

CREATE DATABASE IF NOT EXISTS HealthGuard;

USE HealthGuard;

-- Label entidades relacionadas a Central
CREATE TABLE UnidadeDeAtendimento (

idUnidadeDeAtendimento INT PRIMARY KEY AUTO_INCREMENT,

razaoSocial VARCHAR(100) NOT NULL,

nomeFantasia VARCHAR(100) NOT NULL,

cnpj CHAR(14) NOT NULL,

unidadeGestora VARCHAR(100) NOT NULL,
CONSTRAINT chkUnidadeGestora CHECK (unidadeGestora in("Federal","Estadual","Municipal"))
);

CREATE TABLE TipoDeContato (

idTipoDeContato INT PRIMARY KEY AUTO_INCREMENT,

formaDeContato VARCHAR(100)
);

CREATE TABLE DiasDisponibilidade (

idDiasDisponibibilidade INT PRIMARY KEY AUTO_INCREMENT,

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

CONSTRAINT fkMeioDeContatoUnidadeDeAtendimento FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES ContatosParaAlerta(fkUnidadeDeAtendimento),
CONSTRAINT fkMeioDeContatoContatoParaAlertas FOREIGN KEY (fkContatoParaAlertas) REFERENCES ContatosParaAlerta(idContatosParaAlerta),
CONSTRAINT fkMeioDeContatoTipodeContato FOREIGN KEY (fkTipodeContato) REFERENCES TipoDeContato(idTipoDeContato)
);

CREATE TABLE DiasDisponiveis (

idDiasDisponiveis INT AUTO_INCREMENT,

fkContatoParaAlertas INT,

fkUnidadeDeAtendimento INT,

fkDiasDisponibibilidade INT,

CONSTRAINT pkCompostaDiasDisponiveis PRIMARY KEY (idDiasDisponiveis,fkContatoParaAlertas,fkUnidadeDeAtendimento,fkDiasDisponibibilidade),

horarioEntrada TIME,

horarioSaida TIME,

CONSTRAINT fkDiasDisponiveisUnidadeDeAtendimento FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES ContatosParaAlerta(fkUnidadeDeAtendimento),
CONSTRAINT fkDiasDisponiveisContatoParaAlertas FOREIGN KEY (fkContatoParaAlertas) REFERENCES ContatosParaAlerta(idContatosParaAlerta),
CONSTRAINT fkDiasDisponiveisDiasDisponibibilidade FOREIGN KEY (fkDiasDisponibibilidade) REFERENCES DiasDisponibilidade(idDiasDisponibibilidade)
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

statusCodigoValidacaoUsuario VARCHAR(100) DEFAULT "Pendente"
CONSTRAINT chkStatusCodigoValidacaoUsuario CHECK (statusCodigoValidacaoUsuario in("Pendente","Aceito","Expirado")),

CONSTRAINT fkCodigoValidacaoUsuarioUnidadeDeAtendimento FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES UnidadeDeAtendimento(idUnidadeDeAtendimento),
CONSTRAINT fkCodigoValidacaoUsuarioPermissoes FOREIGN KEY (fkPermissoes) REFERENCES Permissoes(idPermissoes)
);

CREATE TABLE Usuario (

idUsuario INT AUTO_INCREMENT,

fkPermissoes INT,

CONSTRAINT pkCompostaUsuario PRIMARY KEY(idUsuario,fkPermissoes),

nome VARCHAR(100) NOT NULL,

email VARCHAR(100) NOT NULL,

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

acao VARCHAR(100) NOT NULL,

horarioDaAcao DATETIME DEFAULT CURRENT_TIMESTAMP,

CONSTRAINT fkLogAcoesUnidadeAtendimento FOREIGN KEY (fkUnidadeAtendimento) REFERENCES LogAcesso(fkUnidadeDeAtendimento),
CONSTRAINT fkLogAcoesUsuario FOREIGN KEY (fkUsuario) REFERENCES LogAcesso(fkUsuario),
CONSTRAINT fkLogAcoesLogAceso FOREIGN KEY (fkLogAceso) REFERENCES LogAcesso(idLogAcesso)
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

CONSTRAINT fkMedicoesSelecionadasUnidadeDeAtendimento FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES Dac(fkUnidadeDeAtendimento),
CONSTRAINT fkMedicoesSelecionadasDac FOREIGN KEY (fkDac) REFERENCES Dac(idDac),
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

CONSTRAINT fkLeituraUnidadeDeAtendimento FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES MedicoesSelecionadas(fkUnidadeDeAtendimento),
CONSTRAINT fkLeituraDac FOREIGN KEY (fkDac) REFERENCES MedicoesSelecionadas(fkDac),
CONSTRAINT fkLeituraMedicoesDisponiveis FOREIGN KEY (fkMedicoesDisponiveis) REFERENCES MedicoesSelecionadas(fkMedicoesDisponiveis),
CONSTRAINT fkLeituraMedicoesSelecionadas FOREIGN KEY (fkMedicoesSelecionadas) REFERENCES MedicoesSelecionadas(idMedicoesSelecionadas)

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

CONSTRAINT fkAlertaUnidadeDeAtendimento FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES Leitura(fkUnidadeDeAtendimento),
CONSTRAINT fkAlertaDac FOREIGN KEY (fkDac) REFERENCES Leitura(fkDac),
CONSTRAINT fkAlertaMedicoesDisponiveis FOREIGN KEY (fkMedicoesDisponiveis) REFERENCES Leitura(fkMedicoesDisponiveis),
CONSTRAINT fkAlertaMedicoesSelecionadas FOREIGN KEY (fkMedicoesSelecionadas) REFERENCES Leitura(fkMedicoesSelecionadas),
CONSTRAINT fkAlertaLeitura FOREIGN KEY (fkLeitura) REFERENCES Leitura(idLeitura)
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

-- Fks Fracas
CONSTRAINT fkMetricaAlertaMedicoesDisponiveis FOREIGN KEY (fkMedicoesDisponiveis) REFERENCES MedicoesDisponiveis(idMedicoesDisponiveis),
CONSTRAINT fkMetricaAlertaUnidadeDeAtendimento FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES UnidadeDeAtendimento(idUnidadeDeAtendimento),
-- Fks Fortes
CONSTRAINT fkMetricaAlertaDac FOREIGN KEY (fkDac) REFERENCES Dac(idDac),
CONSTRAINT fkMetricaAlertaUnidadeDeAtendimentoDac FOREIGN KEY (fkUnidadeDeAtendimento) REFERENCES Dac(fkUnidadeDeAtendimento)
);



DROP USER IF EXISTS logan;
CREATE USER 'logan'@'%' IDENTIFIED BY 'senha-segura123';
GRANT INSERT,SELECT,UPDATE,DELETE ON HealthGuard.* TO 'logan'@'%';
FLUSH PRIVILEGES;


