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
    seguindo            INT             NOT NULL    DEFAULT 0,
    seguidores          INT             NOT NULL    DEFAULT 0,
    n_bancos_avaliados  INT             NOT NULL    DEFAULT 0,
    media_rate          INT             NOT NULL    DEFAULT 0,
    rate_5              INT             NOT NULL    DEFAULT 0,
    rate_4              INT             NOT NULL    DEFAULT 0,
    rate_3              INT             NOT NULL    DEFAULT 0,
    rate_2              INT             NOT NULL    DEFAULT 0,
    rate_1              INT             NOT NULL    DEFAULT 0,
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
    id INTEGER PRIMARY KEY,
    nome VARCHAR(32) NOT NULL UNIQUE
);

CREATE TABLE assento (
    id_assento          INT         NOT NULL,
    data_publicacao     DATE        NOT NULL,
    estado VARCHAR(32) NOT NULL,
    nome_localizacao    VARCHAR(32) NOT NULL,
    FOREIGN KEY (nome_localizacao)      REFERENCES localizacao(nome),
    PRIMARY KEY (id_assento),
    CHECK (estado IN ('existe', 'nao existe', 'quebrado'))
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

CREATE TABLE moderador (
    mod_tag     VARCHAR(16) NOT NULL CHECK(length(mod_tag)>=3),
    username    VARCHAR(16) NOT NULL CHECK(length(username)>=3),
    role        VARCHAR(16) NOT NULL DEFAULT 'moderador',
    PRIMARY KEY (mod_tag)
);

CREATE TABLE sugestao (
    id_sugestao INT NOT NULL,
    estado VARCHAR(16) NOT NULL DEFAULT 'pendente',
    data_de_envio DATE NOT NULL,
    user_tag VARCHAR(16) NOT NULL,
    nome_local VARCHAR(32) NOT NULL,
    estado_assento VARCHAR(32) NOT NULL,
    coordenadas VARCHAR(50),
    mod_tag VARCHAR(16),
    data_analise DATE,
    justificativa VARCHAR(150),
    PRIMARY KEY (id_sugestao),
    FOREIGN KEY (user_tag) REFERENCES usuario(user_tag),
    FOREIGN KEY (nome_local) REFERENCES localizacao(nome),
    FOREIGN KEY (mod_tag) REFERENCES moderador(mod_tag),
    CHECK (estado IN ('pendente','aprovada','rejeitada')),
    CHECK (estado_assento IN ('existe', 'nao existe', 'quebrado'))
);

CREATE TABLE manutencao (
    id_manutencao       INT         NOT NULL,
    data_de_envio       DATE        NOT NULL,
    tipo_manutencao     VARCHAR(16) NOT NULL,
    estado              VARCHAR(16) NOT NULL DEFAULT 'pendente',
    id_assento          INT         NOT NULL,
    user_tag VARCHAR(16) NOT NULL,
    mod_tag varchar(16),
    data_analise DATE,
    justificativa VARCHAR(150),
    PRIMARY KEY (id_manutencao),
    FOREIGN KEY (id_assento) REFERENCES assento(id_assento),
    FOREIGN KEY (user_tag) REFERENCES usuario(user_tag),
    FOREIGN KEY (mod_tag) REFERENCES moderador(mod_tag),
    CHECK (estado IN ('pendente', 'aprovada', 'rejeitada'))
);

INSERT INTO usuario 
    (user_tag           , username      ,data_nascimento ,data_criacao   ,foto_perfil_url           ,biografia)     VALUES
    ('ana'              ,'AnaAvalia'    ,'2005-02-12'    ,'2025-06-06'   ,'foto_perfil_Blank.png'   ,NULL   ),
    ('bruno'            ,'Bru'          ,'1999-12-12'    ,'2025-06-07'   ,'foto_customTeste.png'    ,NULL   ),
    ('carla'            ,'carla'        ,'2013-03-23'    ,'2025-05-08'   ,'foto_claraTReste.png'    ,'bio'  ),
    ('diego'            ,'NaoEoDiego'   ,'2000-09-11'    ,'2025-05-05'   ,'foto_perfil_Blank.png'   ,'gloria aos bancos'),
    ('abobora'          ,'Aboboras'     ,'2003-01-03'    ,'2025-05-05'   ,'foto_abobora.png'        ,'abobora'),
    ('sixbancoseven'    ,'SIXS7VEN'     ,'2008-06-07'    ,'2025-04-05'   ,'foto_sixseven.png'       ,'SIX SEVEN!!!!!!'),
    ('conta'            ,'Aurelio'      ,'2001-25-12'    ,'2025-05-13'   ,'foto_conta.png'          ,NULL),
    ('bomDIA'           ,'DIAbom'       ,'2000-09-10'    ,'2025-03-14'   ,'foto_diaSOL.png'         ,'se você esta vendo isso, bom dia'),
    ('yay'              ,'yay :D'       ,'1999-12-31'    ,'2025-12-05'   ,'foto_yay.png'            ,'yay')
;

INSERT INTO segue
    (user_tag1  , user_tag2)    VALUES
    ('ana', 'carla'),
    ('yay', 'bruno'),
    ('sixbancoseven', 'conta'),
    ('sixbancoseven', 'bomDIA'),
    ('yay', 'sixbancoseven'),
    ('yay', 'abobora'),
    ('sixbancoseven', 'yay'),
    ('carla', 'diego'),
    ('yay', 'ana'),
    ('yay', 'conta'),
    ('yay', 'bomDIA'),
    ('ana'      , 'diego'),
    ('bruno', 'ana'),
    ('ana'      , 'bruno'),
    ('sixbancoseven', 'abobora'),
    ('bruno','sixbancoseven'),
    ('sixbancoseven', 'bruno'),
    ('ana','sixbancoseven'),
    ('carla','sixbancoseven'),
    ('conta','sixbancoseven'),
    ('sixbancoseven', 'carla'),
    ('yay', 'carla'),
    ('yay', 'diego'),
    ('diego','sixbancoseven'),
    ('bomDIA','sixbancoseven')
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
('material: plástico'),
('dá para deitar'),
('acompanha uma mesa'),
('carteira'),
('em interior'),
('ar livre'),
('air fryer acoplada');

INSERT INTO localizacao (nome, coordenadas) VALUES
('IC', 'sla'),
('CB', 'sla'),
('IFGW', 'sla');

INSERT INTO assento 
(id_assento , data_publicacao   , estado      , nome_localizacao) VALUES
(1          , '2026-10-01'      , 'existe'    , 'IC'),
(2          , '2026-09-01'      , 'existe'    , 'IC'),
(3          , '2026-08-01'      , 'existe'    , 'IC'),
(4          , '2026-07-01'      , 'existe'    , 'IC'),
(5          , '2026-06-01'      , 'existe'    , 'IC'),
(6          , '2026-05-01'      , 'quebrado'  , 'IC'),
(7          , '2026-04-01'      , 'existe'    , 'IFGW'),
(8          , '2026-03-01'      , 'existe'    , 'IFGW'),
(9          , '2026-02-01'      , 'existe'    , 'CB'),
(10         , '2026-01-02'      , 'existe'    , 'CB'),
(11         , '2026-01-01'      , 'existe'    , 'CB'),
(12         , '2026-01-01'      , 'nao existe', 'CB');

INSERT INTO foto (file_path, id_assento) VALUES
('000000001.jpg', 1),
('000000002.jpg', 2),
('000000003.jpg', 3),
('000000004.jpg', 3),
('000000005.jpg', 4),
('000000006.jpg', 4),
('000000007.jpg', 5),
('000000008.jpg', 6),
('000000009.jpg', 7),
('000000010.jpg', 8),
('000000011.jpg', 8),
('000000012.jpg', 8),
('000000013.jpg', 9),
('000000014.jpg', 9),
('000000015.jpg', 9),
('000000016.jpg', 10),
('000000017.jpg', 10),
('000000018.jpg', 11),
('000000019.jpg', 12),
('000000020.jpg', 12),
('000000021.jpg', 12);

-- tags que descrevem o assento de id 1, e assim para os outros assentos
INSERT INTO descreve (id_tag, id_assento)
SELECT id, 1
FROM tag
WHERE nome IN (
    'social',
    'material: pedra',
    'dá para deitar',
    'acompanha uma mesa',
    'ar livre'
);

INSERT INTO descreve (id_tag, id_assento)
SELECT id, 2
FROM tag
WHERE nome IN (
    'possui encosto',
    'acolchoado',
    'social',
    'dá para deitar',
    'em interior'
);

INSERT INTO descreve (id_tag, id_assento)
SELECT id, 3
FROM tag
WHERE nome IN (
    'possui encosto',
    'individual',
    'material: plástico',
    'acompanha uma mesa',
    'carteira',
    'em interior'
);

INSERT INTO descreve (id_tag, id_assento)
SELECT id, 4
FROM tag
WHERE nome IN (
    'individual',
    'em interior'
);

INSERT INTO descreve (id_tag, id_assento)
SELECT id, 5
FROM tag
WHERE nome IN (
    'possui encosto',
    'possui braço',
    'acolchoado',
    'individual',
    'em interior'
);

INSERT INTO descreve (id_tag, id_assento)
SELECT id, 6
FROM tag
WHERE nome IN (
    'social',
    'material: pedra',
    'dá para deitar',
    'ar livre'
);

INSERT INTO descreve (id_tag, id_assento)
SELECT id, 7
FROM tag
WHERE nome IN (
    'social',
    'acompanha uma mesa',
    'ar livre'
);

INSERT INTO descreve (id_tag, id_assento)
SELECT id, 8
FROM tag
WHERE nome IN (
    'social',
    'material: pedra',
    'dá para deitar',
    'ar livre'
);

INSERT INTO descreve (id_tag, id_assento)
SELECT id, 9
FROM tag
WHERE nome IN (
    'social',
    'material: pedra',
    'acompanha uma mesa',
    'ar livre'
);

INSERT INTO descreve (id_tag, id_assento)
SELECT id, 10
FROM tag
WHERE nome IN (
    'social',
    'material: pedra',
    'dá para deitar',
    'acompanha uma mesa',
    'ar livre'
);

INSERT INTO descreve (id_tag, id_assento)
SELECT id, 11
FROM tag
WHERE nome IN (
    'social',
    'material: pedra',
    'dá para deitar',
    'ar livre'
);

INSERT INTO descreve (id_tag, id_assento)
SELECT id, 12
FROM tag
WHERE nome IN (
    'social',
    'material: pedra',
    'dá para deitar',
    'ar livre'
);

INSERT INTO avalia 
    (user_tag, id_assento, nota, data_avaliacao, comentario) VALUES
    ('ana',   1,  5, '2026-10-02', 'Sombra o dia todo, ótimo para ler'),
    ('ana',   2,  3, '2026-09-10', 'Ok, mas fica perto do barulho'),
    ('ana',   7,  4, '2026-04-12', NULL),
    ('bruno', 1,  4, '2026-10-05', 'Bom, só falta uma tomada'),
    ('bruno', 3,  2, '2026-08-15', 'Madeira solta'),
    ('bruno', 12, 0, '2026-01-20', 'Quebrado, não dá para sentar'),
    ('carla', 1,  5, '2026-10-10', NULL),
    ('carla', 6,  4, '2026-05-18', 'Tranquilo à tarde'),
    ('carla', 9,  3, '2026-02-25', NULL),
    ('sixbancoseven', 4,  5, '2026-07-21', 'Melhor do CB'),
    ('sixbancoseven', 5,  2, '2026-06-30', 'Bate sol forte'),
    ('sixbancoseven', 11, 4, '2026-01-14', NULL)
;

UPDATE usuario SET n_bancos_avaliados = (
    SELECT COUNT(avalia.user_tag) 
    FROM avalia
    WHERE (usuario.user_tag = avalia.user_tag)
);

UPDATE usuario SET media_rate = ROUND(COALESCE((
    SELECT AVG(avalia.nota) 
    FROM avalia
    WHERE (usuario.user_tag = avalia.user_tag)
),0),2)
;

UPDATE usuario SET rate_5 = COALESCE((
    SELECT COUNT(avalia.user_tag) 
    FROM avalia
    WHERE (usuario.user_tag = avalia.user_tag AND avalia.nota = 5)
),0)
;

UPDATE usuario SET rate_4 = COALESCE((
    SELECT COUNT(avalia.user_tag) 
    FROM avalia
    WHERE (usuario.user_tag = avalia.user_tag AND avalia.nota = 4)
),0)
;

UPDATE usuario SET rate_3 = COALESCE((
    SELECT COUNT(avalia.user_tag) 
    FROM avalia
    WHERE (usuario.user_tag = avalia.user_tag AND avalia.nota = 3)
),0)
;

UPDATE usuario SET rate_2 = COALESCE((
    SELECT COUNT(avalia.user_tag) 
    FROM avalia
    WHERE (usuario.user_tag = avalia.user_tag AND avalia.nota = 2)
),0)
;

UPDATE usuario SET rate_1 = COALESCE((
    SELECT COUNT(avalia.user_tag) 
    FROM avalia
    WHERE (usuario.user_tag = avalia.user_tag AND avalia.nota = 1)
),0)
;

INSERT INTO moderador (mod_tag, username, role) VALUES
('Avaliadora',  'AnaAvalia', 'VIP'),
('Gynn', 'Bgoy', 'moderador');

INSERT INTO sugestao (id_sugestao, estado, data_de_envio, user_tag, nome_local, estado_assento, coordenadas, mod_tag, data_analise, justificativa) VALUES
(1,  'aprovada',  '2025-12-20', 'ana',           'IC',   'existe',     '-22.8147,-47.0647', 'Avaliadora', '2025-12-22', NULL),
(2,  'rejeitada', '2026-03-02', 'bruno',         'CB',   'existe',     NULL,                'Gynn',       '2026-03-04', 'Local sem assento visível na foto'),
(3,  'pendente',  '2026-10-20', 'carla',         'IC',   'existe',     '-22.8150,-47.0650', NULL,         NULL,         NULL),
(4,  'pendente',  '2026-10-25', 'diego',         'CB',   'existe',     NULL,                NULL,         NULL,         NULL),
(5,  'aprovada',  '2026-09-28', 'ana',           'IC',   'existe',     NULL,                'Gynn',       '2026-09-30', NULL),
(6,  'pendente',  '2026-11-01', 'abobora',       'IFGW', 'nao existe', '-22.8160,-47.0660', NULL,         NULL,         NULL),
(7,  'aprovada',  '2026-01-15', 'sixbancoseven', 'CB',   'quebrado',   NULL,                'Avaliadora', '2026-01-16', NULL),
(8,  'rejeitada', '2026-04-10', 'conta',         'IC',   'existe',     NULL,                'Gynn',       '2026-04-12', 'Já existe um banco cadastrado nessa exata coordenada'),
(9,  'pendente',  '2026-11-02', 'bomDIA',        'IFGW', 'existe',     '-22.8162,-47.0665', NULL,         NULL,         NULL),
(10, 'pendente',  '2026-11-02', 'yay',           'CB',   'nao existe', NULL,                NULL,         NULL,         NULL);

INSERT INTO manutencao (id_manutencao, data_de_envio, tipo_manutencao, estado, id_assento, user_tag, mod_tag, data_analise, justificativa) VALUES
(1,  '2026-09-12', 'quebrado',    'aprovada',  6,  'ana',           'Avaliadora', '2026-09-14', 'Assento quebrado confirmado pela foto'),
(2,  '2026-10-28', 'nao existe',  'rejeitada', 3,  'bruno',         'Gynn',       '2026-10-29', 'Banco existe'),
(3,  '2026-05-20', 'inacessivel', 'pendente',  8,  'carla',         NULL,         NULL,         NULL),
(4,  '2026-03-05', 'inacessivel', 'pendente',  4,  'diego',         NULL,         NULL,         NULL),
(5,  '2026-04-02', 'nao existe',  'pendente',  7,  'yay',           NULL,         NULL,         NULL),
(6,  '2026-08-10', 'nao existe',  'pendente',  5,  'abobora',       NULL,         NULL,         NULL),
(7,  '2026-09-01', 'inacessivel', 'aprovada',  1,  'sixbancoseven', 'Gynn',       '2026-09-05', 'Assento inacessivel confimado'),
(8,  '2026-01-11', 'quebrado',    'pendente',  2,  'conta',         NULL,         NULL,         NULL),
(9,  '2026-02-08', 'inacessivel', 'pendente',  11, 'bomDIA',        NULL,         NULL,         NULL),
(10, '2026-01-01', 'nao existe',  'rejeitada', 12, 'conta',         'Avaliadora', '2026-01-03', 'Falso relato'),
(11, '2026-02-23', 'nao existe',  'pendente',  10, 'yay',           NULL,         NULL,         NULL);
