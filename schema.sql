CREATE TABLE estado_assento (
    nome VARCHAR(32) NOT NULL,
    PRIMARY KEY (nome)
);

CREATE TABLE localizacao (
    nome VARCHAR(20) NOT NULL,
    coordenadas VARCHAR(50),
    PRIMARY KEY (nome)
);

CREATE TABLE tag (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome VARCHAR(32) NOT NULL UNIQUE
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

CREATE TABLE foto (
    file_path VARCHAR(128) NOT NULL,
    id_assento INT NOT NULL,
    PRIMARY KEY (file_path),
    FOREIGN KEY (id_assento) REFERENCES assento(id)
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

CREATE TABLE descreve (
    id_tag INT NOT NULL,
    id_assento INT NOT NULL,
    FOREIGN KEY (id_tag) REFERENCES tag(id),
    FOREIGN KEY (id_assento) REFERENCES assento(id)
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