CREATE TABLE usuarios (
    id int AUTO_INCREMENT PRIMARY KEY,
    nome varchar(255),
    senha varchar(255),
    email varchar(255)
);

CREATE TABLE maxusers (
    id int AUTO_INCREMENT PRIMARY KEY,
    value int
);

INSERT INTO maxusers VALUES (1,1); /* MAXIMO USUARIOS */

CREATE TABLE auth (
    code varchar(255) not null unique,
    dataInicio date
);

CREATE TABLE poupanca (
    id int AUTO_INCREMENT PRIMARY KEY,
    valor decimal(15,2) NOT NULL,
    deposito bit NOT NULL,
    dt datetime NOT NULL,
);

CREATE TABLE metas (
    id int AUTO_INCREMENT PRIMARY KEY,
    titulo varchar(255) NOT NULL,
    dsc varchar(255),
    dtLim datetime NOT NULL,
    valor decimal(15,2)
);

CREATE TABLE repeticao (
    id int AUTO_INCREMENT PRIMARY KEY,
    nome varchar(255) NOT NULL
);

INSERT INTO repeticao (nome) VALUES
    ('Não repete'),
    ('Diario'),
    ('Semanal'),
    ('Mensal'),
    ('Anual');


CREATE TABLE avisogasto (
    id int AUTO_INCREMENT PRIMARY KEY,
    titulo varchar(255) NOT NULL,
    dsc varchar(255),
    repeticao int REFERENCES repeticao(id),
    emailManha bit NOT NULL,
    porcentagemAviso decimal(15,2) NOT NULL
);

CREATE TABLE bandeiraEnergia (
    id int AUTO_INCREMENT PRIMARY KEY,
    nome varchar(255) NOT NULL
);

INSERT INTO bandeiraEnergia (nome) VALUES
    ('Verde'),
    ('Amarela'),
    ('Vermelha Patamar 1'),
    ('Vermelha Patamar 2');

CREATE TABLE eletricidade (
    id int AUTO_INCREMENT PRIMARY KEY,
    preco decimal(15,2) NOT NULL,
    ilumpublica decimal(15,2) NOT NULL,
    medicao decimal(15,2) NOT NULL,
    precokwh decimal(15,2) NOT NULL,
    dias int NOT NULL,
    mes date NOT NULL,
    bandeira int REFERENCES bandeiraEnergia(id),
    leitura int NOT NULL
);

CREATE TABLE lembreteCompra (
    id int AUTO_INCREMENT PRIMARY KEY,
    titulo varchar(255) NOT NULL,
    dsc varchar(255),
    horario time NOT NULL,
    email varchar(255) NOT NULL
);

CREATE TABLE categoriaGanhos (
    id int PRIMARY KEY AUTO_INCREMENT,
    nome varchar(255) NOT NULL
);

INSERT INTO categoriaGanhos (nome) VALUES
    ('Pix'),
    ('Salario'),
    ('Pensao'),
    ('Transferencia'),
    ('Estorno');

CREATE TABLE ganhos (
    id int AUTO_INCREMENT PRIMARY KEY,
    titulo varchar(255) NOT NULL,
    categoria int REFERENCES categoriaGanhos(id),
    dsc varchar(255),
    horario time NOT NULL,
    email varchar(255) NOT NULL
);

