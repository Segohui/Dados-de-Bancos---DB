CREATE TABLE estado_assento (
    nome VARCHAR(32) NOT NULL,
    PRIMARY KEY (nome)
);

CREATE TABLE localizacao (
    nome VARCHAR(20) NOT NULL,
    coordenadas VARCHAR(50),
    PRIMARY KEY (nome)
);

CREATE TABLE assento (
    id INT NOT NULL,
    data_publicacao DATE NOT NULL,
    nome_estado_assento VARCHAR(32) NOT NULL,
    nome_localizacao VARCHAR(32) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (nome_estado_assento) REFERENCES estado_assento(nome),
    FOREIGN KEY (nome_localizacao) REFERENCES localizacao(nome)
);

CREATE TABLE valida (
    id_assento INT NOT NULL,
    nome_estado_assento VARCHAR(32) NOT NULL,
    FOREIGN KEY (id_assento) REFERENCES assento(id),
    FOREIGN KEY (nome_estado_assento) REFERENCES estado_assento(nome)
);

CREATE TABLE abriga (
    id_assento INT NOT NULL,
    nome_localizacao VARCHAR(32) NOT NULL,
    FOREIGN KEY (id_assento) REFERENCES assento(id),
    FOREIGN KEY (nome_localizacao) REFERENCES localizacao(nome)
);

CREATE TABLE avalia (
    user_tag VARCHAR(32) NOT NULL,
    id_assento INT NOT NULL,
    nota INT NOT NULL,
    data_avaliacao DATE NOT NULL,
    comentario VARCHAR(150),
    PRIMARY KEY (user_tag,id_assento),
    FOREIGN KEY (user_tag) REFERENCES usuario(user_tag),
    FOREIGN KEY (id_assento) REFERENCES assento(id),
    CHECK (nota BETWEEN 0 and 5)
);

CREATE TABLE sugestao (
    id_sugestao INT NOT NULL,
    estado VARCHAR(16) NOT NULL DEFAULT 'pendente',
    data_de_envio DATE NOT NULL,
    user_tag VARCHAR(32) NOT NULL,
    nome_local VARCHAR(32) NOT NULL,
    nome_estado_assento VARCHAR(32) NOT NULL,
    coordenadas VARCHAR(50),
    PRIMARY KEY (id_sugestao),
    FOREIGN KEY (user_tag) REFERENCES usuario(user_tag),
    FOREIGN KEY (nome_local) REFERENCES localizacao(nome),
    FOREIGN KEY (nome_estado_assento) REFERENCES estado_assento(nome),
    CHECK (estado IN ('pendente','aprovada','rejeitada'))
);

INSERT INTO assento (id, data_publicacao, nome_estado_assento, nome_localizacao) VALUES
(1, '01/10/2026', 'vivo', 'IC'),
(2, '01/9/2026', 'vivo', 'CB'),
(3, '01/8/2026', 'vivo', 'IC'),
(4, '01/7/2026', 'vivo', 'CB'),
(5, '01/6/2026', 'vivo', 'CB'),
(6, '01/5/2026', 'vivo', 'IC'),
(7, '01/4/2026', 'vivo', 'CB'),
(8, '01/3/2026', 'vivo', 'IC'),
(9, '01/2/2026', 'vivo', 'IC'),
(10, '01/1/2026', 'vivo', 'CB'),
(11, '01/1/2026', 'vivo', 'IC'),
(12, '01/1/2026', 'morto', 'CB');

INSERT INTO estado_assento (nome) VALUES
('vivo'),
('morto');

INSERT INTO localizacao (nome, coordenadas) VALUES
('IC', 'sla'),
('CB', 'sla');

INSERT INTO avalia (user_tag, id_assento, nota, data_avaliacao, comentario) VALUES
('@ana',   1,  5, '2026-10-02', 'Sombra o dia todo, ótimo para ler'),
('@ana',   2,  3, '2026-09-10', 'Ok, mas fica perto do barulho'),
('@ana',   7,  4, '2026-04-12', NULL),
('@bruno', 1,  4, '2026-10-05', 'Bom, só falta uma tomada'),
('@bruno', 3,  2, '2026-08-15', 'Madeira solta'),
('@bruno', 12, 0, '2026-01-20', 'Quebrado, não dá para sentar'),
('@carla', 1,  5, '2026-10-10', NULL),
('@carla', 6,  4, '2026-05-18', 'Tranquilo à tarde'),
('@carla', 9,  3, '2026-02-25', NULL),
('@diego', 4,  5, '2026-07-21', 'Melhor do CB'),
('@diego', 5,  2, '2026-06-30', 'Bate sol forte'),
('@diego', 11, 4, '2026-01-14', NULL);

INSERT INTO sugestao (id_sugestao, estado, data_de_envio, user_tag, nome_local, nome_estado_assento, coordenadas) VALUES
(1, 'aprovada',  '2025-12-20', '@ana',   'IC', 'vivo', '-22.8147,-47.0647'),
(2, 'rejeitada', '2026-03-02', '@bruno', 'CB', 'vivo', NULL),
(3, 'pendente',  '2026-10-20', '@carla', 'IC', 'vivo', '-22.8150,-47.0650'),
(4, 'pendente',  '2026-10-25', '@diego', 'CB', 'vivo', NULL),
(5, 'aprovada',  '2026-09-28', '@ana',   'IC', 'vivo', NULL);