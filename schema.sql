CREATE TABLE assento (
    id INT NOT NULL,
    data_publicacao DATE NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE estado_assento (
    nome VARCHAR(32) NOT NULL,
    PRIMARY KEY (nome)
);

CREATE TABLE localizacao (
    nome VARCHAR(20) NOT NULL,
    coordenadas VARCHAR(50),
    PRIMARY KEY (nome)
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
    FOREIGN KEY (nome_local) REFERENCES localizacao(nome)
)