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

/*
select * from MedicoesSelecionadas;
select * from MetricaAlerta;
SELECT max(valorMinimo) FROM MetricaAlerta WHERE fkDac = 1 AND fkMedicoesDisponiveis = 1;
SELECT min(valorMaximo) FROM MetricaAlerta WHERE fkDac = 1 AND fkMedicoesDisponiveis = 1;
SELECT idDac,fkUnidadeDeAtendimento FROM HealthGuard.Dac WHERE statusDac != 'Excluido' AND codigoValidacao = 'ABC123DEF456GHI78901';
*/
-- Inserts Para o cadastro e Login
INSERT INTO healthguard.permissoes(nome,descricao) VALUES
('Gestor TI',"Todas as funções do Analista TI e incluso visualizar logs de ações e adicionar funcionários"),
('Analista TI','Pode visualizar a dashboard e adicionar uma nova máquina');

INSERT INTO healthguard.CodigoValidacao 
(fkUnidadeDeAtendimento, fkPermissoes, codigo, dataCriacao, dataExpiracao, statusCodigo)
VALUES
-- 1 - Expirado
(1, 1, 'A1B2C3D4E5F6G7H', '2025-05-10 14:20:00', '2025-06-10 14:20:00', 'Expirado'),

-- 2 - Expirado
(1, 2, 'K9L8M7N6O5P4Q3R', '2025-04-01 09:00:00', '2025-05-01 09:00:00', 'Expirado'),

-- 3 - Aceito
(1, 1, 'Z1Y2X3W4V5U6T7S', '2025-07-12 11:35:00', '2025-08-12 11:35:00', 'Aceito'),

-- 4 - Aceito
(1, 2, 'P0O9I8U7Y6T5R4E', '2025-07-25 08:00:00', '2025-08-25 08:00:00', 'Aceito'),

-- 5 - Pedente (data expirada → útil pra testar erro de lógica)
(1, 1, 'M1N2B3V4C5X6Z7A', '2025-06-15 15:10:00', '2025-07-15 15:10:00', 'Pedente'),

-- 6 - Pedente
(1, 2, 'L0K9J8H7G6F5D4S', '2025-09-01 10:45:00', '2025-09-30 10:45:00', 'Pedente'),

-- 7 - Expirado
(1, 1, 'R3T4Y5U6I7O8P9Q', '2025-02-10 13:22:00', '2025-03-10 13:22:00', 'Expirado'),

-- 8 - Aceito
(1, 2, 'E1D2C3B4A5S6D7F', '2025-03-01 18:00:00', '2025-04-01 18:00:00', 'Aceito'),

-- 9 - Pedente
(1, 1, 'H1G2F3E4D5C6B7A', '2025-08-05 07:15:00', '2025-09-05 07:15:00', 'Pedente'),

-- 10 - Expirado
(1, 2, 'W9Q8E7R6T5Y4U3I', '2025-01-10 16:30:00', '2025-02-10 16:30:00', 'Expirado');


