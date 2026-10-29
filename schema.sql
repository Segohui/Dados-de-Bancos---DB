

CREATE TABLE estado_assento (
    nome VARCHAR(32) NOT NULL,
    PRIMARY KEY (nome)
);

CREATE TABLE localizacao (
    nome VARCHAR(20) NOT NULL,
    coordenadas VARCHAR(50),
    PRIMARY KEY (nome)
);

CREATE TABLE usuario (
    user_tag            VARCHAR(16)     NOT NULL    CHECK(length(user_tag)>=3),
    username            VARCHAR(16)     NOT NULL    CHECK(length(username)>=3),
    data_nascimento     DATE            NOT NULL,
    data_criacao        DATE            NOT NULL    DEFAULT current_date,
    foto_perfil_url     VARCHAR(32)     NOT NULL    DEFAULT 'foto_perfil_Blank.png',
    -- armazenado como char, salvando o link da imagem salva no sistema
    biografia           VARCHAR(64),
    n_bancos_avaliados  INT             NOT NULL    DEFAULT 0,
    media_rate          INT             NOT NULL    DEFAULT 0,
    seguindo            INT             NOT NULL    DEFAULT 0,
    seguidores          INT             NOT NULL    DEFAULT 0,
    PRIMARY KEY(user_tag)
);

CREATE TABLE segue (
    user_tag1       VARCHAR(16)     NOT NULL,
    user_tag2       VARCHAR(16)     NOT NULL CHECK(user_tag2 != user_tag1),
    FOREIGN KEY (user_tag1) REFERENCES usuario(user_tag),
    FOREIGN KEY (user_tag2) REFERENCES usuario(user_tag),
    PRIMARY KEY (user_tag1, user_tag2)
);

CREATE TABLE tag (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(32) NOT NULL UNIQUE
);

CREATE TABLE assento (
    id_assento          INT         NOT NULL,
    data_publicacao     DATE        NOT NULL,
    nome_estado_assento VARCHAR(32) NOT NULL,
    nome_localizacao    VARCHAR(32) NOT NULL,
    FOREIGN KEY (nome_estado_assento)   REFERENCES estado_assento(nome),
    FOREIGN KEY (nome_localizacao)      REFERENCES localizacao(nome),
    PRIMARY KEY (id_assento)
);

CREATE TABLE foto (
    file_path VARCHAR(128) NOT NULL,
    id_assento INT NOT NULL,
    PRIMARY KEY (file_path),
    FOREIGN KEY (id_assento) REFERENCES assento(id_assento)
);

CREATE TABLE descreve (
    id_tag INT NOT NULL,
    id_assento INT NOT NULL,
    FOREIGN KEY (id_tag) REFERENCES tag(id),
    FOREIGN KEY (id_assento) REFERENCES assento(id_assento)
);

CREATE TABLE valida (
    id_assento INT NOT NULL,
    nome_estado_assento VARCHAR(32) NOT NULL,
    FOREIGN KEY (id_assento) REFERENCES assento(id_assento),
    FOREIGN KEY (nome_estado_assento) REFERENCES estado_assento(nome)
);

CREATE TABLE abriga (
    id_assento INT NOT NULL,
    nome_localizacao VARCHAR(32) NOT NULL,
    FOREIGN KEY (id_assento) REFERENCES assento(id_assento),
    FOREIGN KEY (nome_localizacao) REFERENCES localizacao(nome)
);

CREATE TABLE avalia (
    user_tag VARCHAR(16) NOT NULL,
    id_assento INT NOT NULL,
    nota INT NOT NULL,
    data_avaliacao DATE NOT NULL,
    comentario VARCHAR(150),
    PRIMARY KEY (user_tag,id_assento),
    FOREIGN KEY (user_tag) REFERENCES usuario(user_tag),
    FOREIGN KEY (id_assento) REFERENCES assento(id_assento),
    CHECK (nota BETWEEN 0 and 5)
);

CREATE TABLE sugestao (
    id_sugestao INT NOT NULL,
    estado VARCHAR(16) NOT NULL DEFAULT 'pendente',
    data_de_envio DATE NOT NULL,
    user_tag VARCHAR(16) NOT NULL,
    nome_local VARCHAR(32) NOT NULL,
    nome_estado_assento VARCHAR(32) NOT NULL,
    coordenadas VARCHAR(50),
    PRIMARY KEY (id_sugestao),
    FOREIGN KEY (user_tag) REFERENCES usuario(user_tag),
    FOREIGN KEY (nome_local) REFERENCES localizacao(nome),
    FOREIGN KEY (nome_estado_assento) REFERENCES estado_assento(nome),
    CHECK (estado IN ('pendente','aprovada','rejeitada'))
);


INSERT INTO usuario 
    (user_tag   , username     ,data_nascimento ,data_criacao   ,foto_perfil_url            ,biografia)     VALUES
    ('ana'     ,'AnaAvalia'   ,'2005-02-12'    ,'2025-06-06'   ,'foto_perfil_Blank.png'    ,NULL   ),
    ('bruno'   ,'Bru'         ,'1999-12-12'    ,'2025-06-07'   ,'foto_customTeste.png'     ,NULL   ),
    ('carla'   ,'carla'       ,'2013-03-23'    ,'2025-05-08'   ,'foto_claraTReste.png'     ,'bio'  ),
    ('diego'   ,'NaoEoDiego'  ,'2000-09-11'    ,'2025-05-05'   ,'foto_perfil_Blank.png'    ,'gloria aos bancos')
;

INSERT INTO segue
    (user_tag1  , user_tag2)    VALUES
    ('ana'      , 'bruno'),
    ('ana'      , 'diego'),
    ('ana', 'carla'),
    ('bruno', 'ana'),
    ('carla', 'diego')
;

UPDATE usuario SET seguidores = (
    SELECT COUNT(user_tag2) 
    FROM segue
    WHERE (user_tag2 = user_tag)
);

UPDATE usuario SET seguindo = (
    SELECT COUNT(user_tag1) 
    FROM segue
    WHERE (user_tag1 = user_tag)
);

INSERT INTO tag (nome) VALUES
('possui encosto'),
('possui braço'),
('acolchoado'),
('individual'),
('social'),
('poltrona'),
('material: madeira'),
('material: metal'),
('material: pedra'),
('dá para deitar'),
('acompanha uma mesa'),
('carteira'),
('em interior'),
('ar livre'),
('air fryer acoplada');

INSERT INTO estado_assento (nome) VALUES
('vivo' ),
('morto');

INSERT INTO localizacao (nome, coordenadas) VALUES
('IC', 'sla'),
('CB', 'sla');

INSERT INTO assento 
(id_assento , data_publicacao   , nome_estado_assento   , nome_localizacao) VALUES
(1  , '2026-10-01'      , 'vivo'                , 'IC'),
(2  , '2026-09-01'      , 'vivo'                , 'CB'),
(3  , '2026-08-01'      , 'vivo'                , 'IC'),
(4  , '2026-07-01'      , 'vivo'                , 'CB'),
(5  , '2026-06-01'      , 'vivo'                , 'CB'),
(6  , '2026-05-01'      , 'vivo'                , 'IC'),
(7  , '2026-04-01'      , 'vivo'                , 'CB'),
(8  , '2026-03-01'      , 'vivo'                , 'IC'),
(9  , '2026-02-01'      , 'vivo'                , 'IC'),
(10 , '2026-01-02'      , 'vivo'                , 'CB'),
(11 , '2026-01-01'      , 'vivo'                , 'IC'),
(12 , '2026-01-01'      , 'morto'               , 'CB');

INSERT INTO avalia (user_tag, id_assento, nota, data_avaliacao, comentario) VALUES
('ana',   1,  5, '2026-10-02', 'Sombra o dia todo, ótimo para ler'),
('ana',   2,  3, '2026-09-10', 'Ok, mas fica perto do barulho'),
('ana',   7,  4, '2026-04-12', NULL),
('bruno', 1,  4, '2026-10-05', 'Bom, só falta uma tomada'),
('bruno', 3,  2, '2026-08-15', 'Madeira solta'),
('bruno', 12, 0, '2026-01-20', 'Quebrado, não dá para sentar'),
('carla', 1,  5, '2026-10-10', NULL),
('carla', 6,  4, '2026-05-18', 'Tranquilo à tarde'),
('carla', 9,  3, '2026-02-25', NULL),
('diego', 4,  5, '2026-07-21', 'Melhor do CB'),
('diego', 5,  2, '2026-06-30', 'Bate sol forte'),
('diego', 11, 4, '2026-01-14', NULL);

UPDATE usuario SET n_bancos_avaliados = (
    SELECT COUNT(avalia.user_tag) 
    FROM avalia
    WHERE (usuario.user_tag = avalia.user_tag)
);

UPDATE usuario SET n_bancos_avaliados = ROUND((
    SELECT AVG(nota) 
    FROM avalia
    WHERE (usuario.user_tag = avalia.user_tag)
),2);

INSERT INTO sugestao (id_sugestao, estado, data_de_envio, user_tag, nome_local, nome_estado_assento, coordenadas) VALUES
(1, 'aprovada',  '2025-12-20', 'ana',   'IC', 'vivo', '-22.8147,-47.0647'),
(2, 'rejeitada', '2026-03-02', 'bruno', 'CB', 'vivo', NULL),
(3, 'pendente',  '2026-10-20', 'carla', 'IC', 'vivo', '-22.8150,-47.0650'),
(4, 'pendente',  '2026-10-25', 'diego', 'CB', 'vivo', NULL),
(5, 'aprovada',  '2026-09-28', 'ana',   'IC', 'vivo', NULL);
