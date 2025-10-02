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

select * from MedicoesSelecionadas;
SELECT idDac,fkUnidadeDeAtendimento FROM HealthGuard.Dac WHERE statusDac != 'Excluido' AND codigoValidacao = 'ABC123DEF456GHI78901';



