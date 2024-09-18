-- Criação da tabela de usuários / 01/09/2024
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    telefone VARCHAR(20) DEFAULT NULL,
    endereco TEXT DEFAULT NULL,
    data_cadastro DATE,
    data_modificou DATE,
    ultimo_login DATE,
    foto_perfil VARCHAR(255) DEFAULT NULL,
    status ENUM('ativo', 'inativo', 'banido') DEFAULT 'ativo',
    role ENUM('admin', 'usuario', 'moderador') DEFAULT 'usuario',
    token_recuperacao VARCHAR(255) DEFAULT NULL,
    data_expiracao_token DATE DEFAULT NULL,
    criado_por INT DEFAULT NULL,
    modificado_por INT DEFAULT NULL
);


-- Criação da tabela de vagas / 01/09/2024
CREATE TABLE vagas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    data_cadastro DATE,
    descricao VARCHAR(255) NOT NULL, -- (nome da vaga)
    obteve_resposta TINYINT(1) DEFAULT 0,     
    localizacao VARCHAR(255) DEFAULT NULL, 
    status_vaga VARCHAR(100) DEFAULT NULL, -- (candidatado, em processo, aprovado e rejeitado)
    modelo_vaga VARCHAR(100) DEFAULT NULL, -- (home, hibrido ou presencial)
    nome_empresa VARCHAR(100) DEFAULT NULL, 
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id) ON DELETE CASCADE
);
