
-- Adicionando as permissões
INSERT INTO HealthGuard.Permissoes(nome,descricao) VALUES
('Gestor TI',"Todas as funções do Analista TI e incluso visualizar logs de ações e adicionar funcionários"),
('Analista TI','Pode visualizar a dashboard e adicionar uma nova máquina');

-- Adicionando os monitoramentos
INSERT INTO HealthGuard.MedicoesDisponiveis (nomeDaMedicao,unidadeDeMedida) VALUES
('Porcentagem de uso da CPU','%'),
('Uso da Memória RAM','%'),
('Uso de disco','%'),
('Conexão com a rede','I/O');

-- Inserções na tabela UnidadeDeAtendimento
INSERT INTO HealthGuard.UnidadeDeAtendimento (razaoSocial, nomeFantasia, cnpj, unidadeGestora) VALUES 
('HealthGuard LTDA', 'HealthGuard', '12345678000195', 'Secretaria da Saúde');

-- Inserções na tabela CodigoConfiguracao
INSERT INTO HealthGuard.CodigoConfiguracaoMaquina (fkUnidadeDeAtendimento, codigo, dataExpiracao,statusCodigoConfiguracaoMaquina) VALUES
-- Códigos para ativação 
(1, 'ABC123DEF456GHI78901', '2026-01-01 23:59:59','Pendente'),
(1, 'AYGDSIASKDPNKODASJ28', '2026-01-01 23:59:59','Pendente'),
-- Códigos de erro para teste
(1, 'ifiosijoASDUasjd1828', '2024-01-01 23:59:59','Pendente'),
(1, 'idasisgias9238919287', '2024-01-01 23:59:59','Expirado'),
(1, 'hsjboaisofiiasoidasi', '2026-01-01 23:59:59','Aceito');

-- Inserido uma máquina
INSERT INTO HealthGuard.Dac (fkUnidadeDeAtendimento,codigoValidacao,nomeIdentificacao) VALUES
(1,"ABC123DEF456GHI78901","Máquina A-01");

-- Inserção para a configuração de todos os monitoramentos
INSERT INTO HealthGuard.MedicoesSelecionadas (fkUnidadeDeAtendimento,fkDac,fkMedicoesDisponiveis) VALUES
(1,1,1),
(1,1,2),
(1,1,3),
(1,1,4);

INSERT INTO HealthGuard.CodigoValidacaoUsuario(fkUnidadeDeAtendimento, fkPermissoes, codigo, dataExpiracao, statusCodigoValidacaoUsuario,emailSugerido,nomeSugerido) VALUES
-- Convites para utilização
(1, 1, 'A1B2C3D4E5F6G7H','2026-01-01 23:59:00', 'Pendente',"arthur.amahals1000@gmail.com","Arthur Felipe Amaral da Silva"),
(1, 2, 'UAISODSAIDSAJJ7','2026-01-01 23:59:00', 'Pendente',"yuri.boechat@sptech.school","Yuri boechat da Silva");

-- Inserção de máquinas DAC
INSERT INTO HealthGuard.Dac (fkUnidadeDeAtendimento, nomeIdentificacao, statusDac, codigoValidacao) VALUES
(1, 'Maquina A-02', 'Ativo', 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6'),
(1, 'Maquina A-03', 'Ativo', 'q9r8s7t6u5v4w3x2y1z0a1b2c3d4e5f6'),
(1, 'Maquina A-04', 'Ativo', 'g7h8i9j0k1l2m3n4o5p6q9r8s7t6u5v4'),
(1, 'Maquina A-05', 'Inativo', 'w3x2y1z0a1b2c3d4e5f6g7h8i9j0k1l2'),
(1, 'Maquina A-06', 'Ativo', 'm3n4o5p6q9r8s7t6u5v4w3x2y1z0a1b2'),
(1, 'Maquina A-07', 'Ativo', 'c3d4e5f6g7h8i9j0k1l2m3n4o5p6q9r8'),
(1, 'Maquina A-08', 'Alerta', 's7t6u5v4w3x2y1z0a1b2c3d4e5f6g7h8'),
(1, 'Maquina A-09', 'Ativo', 'i9j0k1l2m3n4o5p6q9r8s7t6u5v4w3x2'),
(1, 'Maquina A-10', 'Ativo', 'y1z0a1b2c3d4e5f6g7h8i9j0k1l2m3n4'),
(1, 'Maquina B-01', 'Ativo', 'o5p6q9r8s7t6u5v4w3x2y1z0a1b2c3d4'),
(1, 'Maquina B-02', 'Ativo', 'e5f6g7h8i9j0k1l2m3n4o5p6q9r8s7t6'),
(1, 'Maquina B-03', 'Excluido', 'u5v4w3x2y1z0a1b2c3d4e5f6g7h8i9j0'),
(1, 'Maquina B-04', 'Ativo', 'k1l2m3n4o5p6q9r8s7t6u5v4w3x2y1z0'),
(1, 'Maquina B-05', 'Ativo', 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6'),
(1, 'Maquina B-06', 'Ativo', 'q9r8s7t6u5v4w3x2y1z0a1b2c3d4e5f6'),
(1, 'Maquina B-07', 'Em configuração', 'g7h8i9j0k1l2m3n4o5p6q9r8s7t6u5v4'),
(1, 'Maquina B-08', 'Ativo', 'w3x2y1z0a1b2c3d4e5f6g7h8i9j0k1l2'),
(1, 'Maquina B-09', 'Ativo', 'm3n4o5p6q9r8s7t6u5v4w3x2y1z0a1b2'),
(1, 'Maquina C-01', 'Ativo', 'c3d4e5f6g7h8i9j0k1l2m3n4o5p6q9r8'),
(1, 'Maquina C-02', 'Ativo', 's7t6u5v4w3x2y1z0a1b2c3d4e5f6g7h8'),
(1, 'Maquina C-03', 'Ativo', 'i9j0k1l2m3n4o5p6q9r8s7t6u5v4w3x2'),
(1, 'Maquina C-04', 'Ativo', 'y1z0a1b2c3d4e5f6g7h8i9j0k1l2m3n4'),
(1, 'Maquina C-05', 'Inativo', 'o5p6q9r8s7t6u5v4w3x2y1z0a1b2c3d4'),
(1, 'Maquina C-06', 'Ativo', 'e5f6g7h8i9j0k1l2m3n4o5p6q9r8s7t6'),
(1, 'Maquina C-07', 'Ativo', 'u5v4w3x2y1z0a1b2c3d4e5f6g7h8i9j0'),
(1, 'Maquina C-08', 'Ativo', 'k1l2m3n4o5p6q9r8s7t6u5v4w3x2y1z0'),
(1, 'Maquina C-09', 'Alerta', 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6'),
(1, 'Maquina D-01', 'Ativo', 'q9r8s7t6u5v4w3x2y1z0a1b2c3d4e5f6'),
(1, 'Maquina D-02', 'Ativo', 'g7h8i9j0k1l2m3n4o5p6q9r8s7t6u5v4'),
(1, 'Maquina D-03', 'Ativo', 'w3x2y1z0a1b2c3d4e5f6g7h8i9j0k1l2'),
(1, 'Maquina D-04', 'Ativo', 'm3n4o5p6q9r8s7t6u5v4w3x2y1z0a1b2'),
(1, 'Maquina D-05', 'Ativo', 'c3d4e5f6g7h8i9j0k1l2m3n4o5p6q9r8'),
(1, 'Maquina D-06', 'Excluido', 's7t6u5v4w3x2y1z0a1b2c3d4e5f6g7h8'),
(1, 'Maquina D-07', 'Ativo', 'i9j0k1l2m3n4o5p6q9r8s7t6u5v4w3x2'),
(1, 'Maquina D-08', 'Ativo', 'y1z0a1b2c3d4e5f6g7h8i9j0k1l2m3n4'),
(1, 'Maquina D-09', 'Ativo', 'o5p6q9r8s7t6u5v4w3x2y1z0a1b2c3d4'),
(1, 'Maquina E-01', 'Ativo', 'e5f6g7h8i9j0k1l2m3n4o5p6q9r8s7t6'),
(1, 'Maquina E-02', 'Em configuração', 'u5v4w3x2y1z0a1b2c3d4e5f6g7h8i9j0'),
(1, 'Maquina E-03', 'Ativo', 'k1l2m3n4o5p6q9r8s7t6u5v4w3x2y1z0'),
(1, 'Maquina E-04', 'Ativo', 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6'),
(1, 'Maquina E-05', 'Ativo', 'q9r8s7t6u5v4w3x2y1z0a1b2c3d4e5f6'),
(1, 'Maquina E-06', 'Ativo', 'g7h8i9j0k1l2m3n4o5p6q9r8s7t6u5v4'),
(1, 'Maquina E-07', 'Ativo', 'w3x2y1z0a1b2c3d4e5f6g7h8i9j0k1l2'),
(1, 'Maquina E-08', 'Ativo', 'm3n4o5p6q9r8s7t6u5v4w3x2y1z0a1b2'),
(1, 'Maquina E-09', 'Ativo', 'c3d4e5f6g7h8i9j0k1l2m3n4o5p6q9r8'),
(1, 'Maquina F-01', 'Ativo', 's7t6u5v4w3x2y1z0a1b2c3d4e5f6g7h8'),
(1, 'Maquina F-02', 'Inativo', 'i9j0k1l2m3n4o5p6q9r8s7t6u5v4w3x2'),
(1, 'Maquina F-03', 'Ativo', 'y1z0a1b2c3d4e5f6g7h8i9j0k1l2m3n4'),
(1, 'Maquina F-04', 'Alerta', 'o5p6q9r8s7t6u5v4w3x2y1z0a1b2c3d4'),
(1, 'Maquina F-05', 'Ativo', 'e5f6g7h8i9j0k1l2m3n4o5p6q9r8s7t6');





