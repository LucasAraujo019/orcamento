-- Tabela usuarios (Usuários)
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    empresa_id INT, -- Relacionamento com a tabela de empresas
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    perfil ENUM('admin', 'gerente', 'funcionario') DEFAULT 'funcionario', -- Níveis de permissão
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela empresas (Empresas)
CREATE TABLE empresas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    logotipo VARCHAR(255), -- Caminho para o logotipo da empresa
    endereco TEXT,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela assinaturas (Assinaturas)
CREATE TABLE assinaturas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    empresa_id INT,
    stripe_assinatura_id VARCHAR(255), -- ID do Stripe para o gerenciamento de cobranças
    plano ENUM('basico', 'pro', 'enterprise') NOT NULL,
    status ENUM('ativo', 'em_atraso', 'cancelado', 'teste') DEFAULT 'teste',
    data_inicio DATE,
    data_fim DATE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id)
);

-- Tabela modelos (Templates de Orçamentos)
CREATE TABLE modelos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    empresa_id INT,
    nome VARCHAR(255) NOT NULL,
    dados_modelo TEXT NOT NULL, -- Dados de configuração (JSON, por exemplo)
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id)
);

-- Tabela orcamentos (Orçamentos)
CREATE TABLE orcamentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    empresa_id INT,
    modelo_id INT,
    cliente_nome VARCHAR(255), -- Nome do cliente que receberá o orçamento
    cliente_email VARCHAR(255),
    valor_total DECIMAL(10, 2) NOT NULL,
    status ENUM('rascunho', 'enviado', 'aprovado', 'rejeitado') DEFAULT 'rascunho',
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (empresa_id) REFERENCES empresas(id),
    FOREIGN KEY (modelo_id) REFERENCES modelos(id)
);

-- Tabela itens_orcamento (Itens do Orçamento)
CREATE TABLE itens_orcamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    orcamento_id INT,
    descricao TEXT NOT NULL, -- Descrição do produto/serviço
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    total DECIMAL(10, 2) AS (quantidade * preco_unitario), -- Total do item
    FOREIGN KEY (orcamento_id) REFERENCES orcamentos(id)
);

-- Tabela logs_email (Logs de E-mails Enviados)
CREATE TABLE logs_email (
    id INT AUTO_INCREMENT PRIMARY KEY,
    orcamento_id INT,
    destinatario_email VARCHAR(255),
    assunto VARCHAR(255),
    corpo TEXT,
    enviado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (orcamento_id) REFERENCES orcamentos(id)
);

-- Tabela pagamentos (Pagamentos)
CREATE TABLE pagamentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    empresa_id INT,
    stripe_pagamento_id VARCHAR(255),
    valor DECIMAL(10, 2),
    status ENUM('pendente', 'completo', 'falhou') DEFAULT 'pendente',
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES empresas(id)
);
