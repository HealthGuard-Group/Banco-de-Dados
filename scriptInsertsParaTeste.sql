
-- Adicionando as permissões
INSERT INTO HealthGuard.Permissoes(nome,descricao) VALUES
('Gestor de TI',"Todas as funções do Analista TI e incluso visualizar logs de ações e adicionar funcionários"),
('Técnico de TI','Pode visualizar a dashboard e adicionar uma nova máquina');

-- Adicionando os monitoramentos
INSERT INTO HealthGuard.MedicoesDisponiveis (nomeDaMedicao,unidadeDeMedida) VALUES
('Porcentagem de uso da CPU','%'),
('Processos ativos','Qtd'),
('Quantidade núcleos','Qtd'),
('Threads','Qtd'),
('Frequência Atual','Mhz'),
('Uso da Memória RAM','%'),
('Memória RAM Total','GB'),
('Uso Memória SWAP','%'),
('Memória SWAP Total','GB'),
('Uso de disco','%'),
('Conexão com a rede','I/O'),
('Frequência Máxima de CPU','Mhz'),
('Tempo de atividade','Tempo'),
('Espaço livre do disco','GB'),
('IOPS','operaçãoes/s'),
('Partição de Disco','JSON'),
('Ranking processos','JSON'),
('Porcentagem CPU - nucleo', 'JSON');

-- Inserções na tabela UnidadeDeAtendimento
INSERT INTO HealthGuard.UnidadeDeAtendimento (razaoSocial, nomeFantasia, cnpj, unidadeGestora) VALUES 
('Saúde Integral Diagnósticos Ltda', 'Centro de Diagnóstico Integral', '12345678000195', 'Secretaria da Saúde'),
('Bem Estar Hospitalar S.A', 'Hospital Bem Estar', '98765432000177', 'Secretaria da Saúde'),
('Nova Esperança Terapias e Reabilitação Ltda.', 'Reabilitar Nova Esperança', '45678912000103', 'Instituição privada'),
('Vida Plena Serviços Médicos Ltda', 'Clínica Vida Plena', '85296374000166', 'Secretaria da Saúde');

-- Inserções na tabela CodigoConfiguracao
INSERT INTO HealthGuard.CodigoConfiguracaoMaquina (fkUnidadeDeAtendimento, codigo, dataExpiracao,statusCodigoConfiguracaoMaquina) VALUES
-- Códigos para ativação 
(1, 'ABC123DEF456GHI78901', '2026-01-01 23:59:59','Pendente');

-- Inserido uma máquina
INSERT INTO HealthGuard.Dac (fkUnidadeDeAtendimento,codigoValidacao,nomeIdentificacao) VALUES
(1,"ABC123DEF456GHI78901","Máquina A-01");

-- Inserção para a configuração de todos os monitoramentos
INSERT INTO HealthGuard.MedicoesSelecionadas (fkUnidadeDeAtendimento,fkDac,fkMedicoesDisponiveis) VALUES
(1,1,1),
(1,1,2),
(1,1,3),
(1,1,4),
(1,1,5),
(1,1,6),
(1,1,7),
(1,1,8),
(1,1,9),
(1,1,10),
(1,1,11),
(1,1,12),
(1,1,13),
(1,1,14),
(1,1,15),
(1,1,16),
(1,1,17);

INSERT INTO MetricaAlerta(fkMedicoesDisponiveis,fkUnidadeDeAtendimento,nomeNivel,valorMinimo,valorMaximo) VALUES
(1,1,"Atenção",58.00,78.49),
(1,1,"Alerta",78.50,100.00),
(6,1,"Atenção",91.9,99.00),
(6,1,"Alerta",99.01,100.00),
(10,1,"Atenção",70.00,80.00),
(10,1,"Alerta",80.01,100.00);

INSERT INTO HealthGuard.CodigoValidacaoUsuario(fkUnidadeDeAtendimento, fkPermissoes, codigo, dataExpiracao, statusCodigoValidacaoUsuario,emailSugerido,nomeSugerido) VALUES
-- Convites para utilização
(1, 1, '1111111111','2026-01-01 23:59:00', 'Pendente',"andre.leao@sptech.school","André Augusto Corado Leão"),
(1, 1, '2222222222','2026-01-01 23:59:00', 'Pendente',"arthur.asilva@sptech.school","Arthur Felipe Amaral da Silva"),
(1, 1, '3333333333','2026-01-01 23:59:00', 'Pendente',"davi.caproni@sptech.school","Davi Escudero Caproni"),
(1, 1, '4444444444','2026-01-01 23:59:00', 'Pendente',"giovanna.andrade@sptech.school","Giovanna Prado Andrade"),
(1, 1, '5555555555','2026-01-01 23:59:00', 'Pendente',"marcela.vicente@sptech.school","Marcela Bastos Vicente"),
(1, 1, '6666666666','2026-01-01 23:59:00', 'Pendente',"rafael.corso@sptech.school","Rafael Fratini Dal Corso"),
(1, 1, '7777777777','2026-01-01 23:59:00', 'Pendente',"rodrigo.trindade@healthguard.com","Rodrigo Trindade da Cunha"),
(1, 2, '8888888888','2026-01-01 23:59:00', 'Pendente',"angela.martins@healthguard.com","Ângela Martins Reis");