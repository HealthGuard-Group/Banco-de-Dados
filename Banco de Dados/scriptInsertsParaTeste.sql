use HealthGuard;

INSERT INTO MedicoesDisponiveis (nomeDaMedicao,unidadeDeMedida) VALUES
('Porcentagem de uso da CPU','%'),
('Frequência de uso da CPU','GHz'),
('Uso da Memória RAM','%'),
('Memória RAM Total','GB'),
('Uso do disco','GB'),
('Espaço restante do disco','GB'),
('Espaço do Disco','GB');

-- Inserções na tabela UnidadeDeAtendimento
INSERT INTO UnidadeDeAtendimento (razaoSocial, nomeFantasia, cnpj, unidadeGestora)
VALUES ('Hospital Vida Ltda', 'Hospital Vida', '12345678000195', 'Secretaria da Saúde');

INSERT INTO UnidadeDeAtendimento (razaoSocial, nomeFantasia, cnpj, unidadeGestora)
VALUES ('Clínica Bem Estar SA', 'Clínica Bem Estar', '98765432000177', 'Secretaria da Saúde');

-- Inserções na tabela CodigoConfiguracao
INSERT INTO CodigoConfiguracao (fkUnidadeDeAtendimento, codigo, dataExpiracao, statusCodigo)
VALUES (1, 'ABC123DEF456GHI78901', '2025-12-31 23:59:59', 'Pedente');

INSERT INTO CodigoConfiguracao (fkUnidadeDeAtendimento, codigo, dataExpiracao, statusCodigo)
VALUES (2, 'XYZ987LMN654OPQ32102', '2025-10-31 23:59:59', 'Aceito');

INSERT INTO Dac (fkUnidadeDeAtendimento,codigoValidacao,nomeDeIdentificacao) VALUES
(1,"ABC123DEF456GHI78901","Arthur Machine");
UPDATE HealthGuard.CodigoConfiguracao SET statusCodigo = 'Pedente' WHERE idCodigoConfiguracao = 1;
select * from CodigoConfiguracao;
select * from Dac;
INSERT INTO MedicoesSelecionadas (fkUnidadeDeAtendimento,fkDac,fkMedicoesDisponiveis) VALUES
(1,1,1),
(1,1,2),
(1,1,3),
(1,1,4),
(1,1,5),
(1,1,6),
(1,1,7);

-- 1. Porcentagem de uso da CPU (%)
INSERT INTO MetricaAlerta (fkUnidadeDeAtendimento,fkDac,fkMedicoesDisponiveis,fkMedicoesSelecionadas,nomeNivel,valorMinimo,valorMaximo)
VALUES
(1,1,1,1,'Atenção',70,85),
(1,1,1,1,'Crítico',85,100);

-- 2. Frequência de uso da CPU (GHz)
INSERT INTO MetricaAlerta (fkUnidadeDeAtendimento,fkDac,fkMedicoesDisponiveis,fkMedicoesSelecionadas,nomeNivel,valorMinimo,valorMaximo)
VALUES
(1,1,2,2,'Atenção',2.5,3.2),
(1,1,2,2,'Crítico',3.2,5.0);

-- 3. Uso da Memória RAM (%)
INSERT INTO MetricaAlerta (fkUnidadeDeAtendimento,fkDac,fkMedicoesDisponiveis,fkMedicoesSelecionadas,nomeNivel,valorMinimo,valorMaximo)
VALUES
(1,1,3,3,'Atenção',70,85),
(1,1,3,3,'Crítico',85,100);

-- 4. Memória RAM Total (GB) -> geralmente não varia, mas alertas podem ser sobre capacidade
/*INSERT INTO MetricaAlerta (fkUnidadeDeAtendimento,fkDac,fkMedicoesDisponiveis,fkMedicoesSelecionadas,nomeNivel,valorMinimo,valorMaximo)
VALUES
(1,1,4,4,'Baixa Capacidade',0,4),
(1,1,4,4,'Média Capacidade',4,16),
(1,1,4,4,'Alta Capacidade',16,128);
*/
-- 5. Uso do Disco (GB)
INSERT INTO MetricaAlerta (fkUnidadeDeAtendimento,fkDac,fkMedicoesDisponiveis,fkMedicoesSelecionadas,nomeNivel,valorMinimo,valorMaximo)
VALUES

(1,1,5,5,'Atenção',500,800),
(1,1,5,5,'Crítico',800,1000);

-- 6. Espaço restante do disco (GB)
INSERT INTO MetricaAlerta (fkUnidadeDeAtendimento,fkDac,fkMedicoesDisponiveis,fkMedicoesSelecionadas,nomeNivel,valorMinimo,valorMaximo)
VALUES
(1,1,6,6,'Atenção',50,200),
(1,1,6,6,'Crítico',0,50);

/*
-- 7. Espaço do Disco (GB) -> valor fixo de capacidade, mas podemos classificar
INSERT INTO MetricaAlerta (fkUnidadeDeAtendimento,fkDac,fkMedicoesDisponiveis,fkMedicoesSelecionadas,nomeNivel,valorMinimo,valorMaximo)
VALUES
(1,1,7,7,'Pequeno',0,256),
(1,1,7,7,'Médio',256,512),
(1,1,7,7,'Grande',512,2000);
*/
select * from MedicoesSelecionadas;
select * from MetricaAlerta;
SELECT max(valorMinimo) FROM MetricaAlerta WHERE fkDac = 1 AND fkMedicoesDisponiveis = 1;
SELECT min(valorMaximo) FROM MetricaAlerta WHERE fkDac = 1 AND fkMedicoesDisponiveis = 1;
SELECT idDac,fkUnidadeDeAtendimento FROM HealthGuard.Dac WHERE statusDac != 'Excluido' AND codigoValidacao = 'ABC123DEF456GHI78901';



