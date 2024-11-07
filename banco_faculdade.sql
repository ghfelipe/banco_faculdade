CREATE DATABASE faculdade;
use faculdade;

-- tabela cidade
DROP TABLE cidade;

CREATE TABLE cidade
(
	ID_cidade INT PRIMARY KEY AUTO_INCREMENT,
    tx_nome VARCHAR(100) NOT NULL,
    tx_uf CHAR(2)
);

INSERT INTO cidade (tx_nome, tx_uf)
VALUES ('maringa', 'PR');

INSERT INTO cidade (tx_nome, tx_uf)
VALUES ('brasilia', 'DF');

INSERT INTO cidade (tx_nome, tx_uf)
VALUES ('campinas', 'SP');

INSERT INTO cidade (tx_nome, tx_uf)
VALUES ('rio branco', 'AC');

SELECT * FROM cidade;

-- tabela endereco
DROP TABLE endereco;

CREATE TABLE endereco
(
	ID_endereco INT PRIMARY KEY AUTO_INCREMENT,
    tx_cep CHAR(8) UNIQUE KEY,
    id_cidade INT, -- FK
	FOREIGN KEY (ID_cidade) REFERENCES cidade(ID_cidade) -- FK
);

INSERT INTO endereco(tx_cep, id_cidade)
VALUES ('12345678',
    (select id_cidade from cidade where tx_nome = 'maringa')
);

INSERT INTO endereco(tx_cep, id_cidade)
VALUES ('87654321',
    (select id_cidade from cidade where tx_nome = 'brasilia')
);

INSERT INTO endereco(tx_cep, id_cidade)
VALUES ('12345789',
    (select id_cidade from cidade where tx_nome = 'campinas')
);

INSERT INTO endereco(tx_cep, id_cidade)
VALUES ('12345788',
    (select id_cidade from cidade where tx_nome = 'campinas')
); -- cardinalidade

INSERT INTO endereco(tx_cep, id_cidade)
VALUES ('12345787',
    (select id_cidade from cidade where tx_nome = 'rio branco')
);

SELECT * FROM endereco;

-- Tabela de alunos
DROP TABLE aluno;

CREATE TABLE aluno 
( 
    ID_aluno INT PRIMARY KEY AUTO_INCREMENT,  
    tx_cpf CHAR(11) UNIQUE NOT NULL,  
    tx_nome VARCHAR(100) NOT NULL,  
    dt_datanascimento DATE,
    tx_email VARCHAR(100) NOT NULL,
    id_endereco INT, -- FK
    FOREIGN KEY (ID_endereco) REFERENCES endereco(ID_endereco) -- FK

--    co_cidade VARCHAR(100) -- FK
);

INSERT INTO aluno (tx_cpf, tx_nome, dt_datanascimento, tx_email, id_endereco)
VALUES ('12345678912','gustavo','2004-09-03','exemplo@gmail.com',1);

INSERT INTO aluno (tx_cpf, tx_nome, dt_datanascimento, tx_email, id_endereco)
VALUES ('12345678911','julia','2004-09-03','exemplos@gmail.com',1);

INSERT INTO aluno (tx_cpf, tx_nome, dt_datanascimento, tx_email, id_endereco)
VALUES ('12345678999','ayrton','1960-03-21','email@exemplo.com',3);

INSERT INTO aluno (tx_cpf, tx_nome, dt_datanascimento, tx_email, id_endereco)
VALUES ('12345678998','larissa','2004-07-10','gamil@exemplo.com',5);

SELECT * FROM aluno;

-- Tabela de professores
DROP TABLE professor;

CREATE TABLE professor 
( 
    id_professor INT PRIMARY KEY AUTO_INCREMENT,  
    tx_email VARCHAR(100) NOT NULL,  
    tx_nome VARCHAR(100) NOT NULL,  
    tx_cpf CHAR(11) UNIQUE NOT NULL 
);

INSERT INTO professor (tx_email, tx_nome, tx_cpf)
VALUES ('professor@gmail.com','marcelo','98765432198');

INSERT INTO professor (tx_email, tx_nome, tx_cpf)
VALUES ('professorex@gmail.com','allan','98765432197');

INSERT INTO professor (tx_email, tx_nome, tx_cpf)
VALUES ('professor@exemple.com','andre','98765432196');

SELECT * FROM professor;

-- Tabela de cursos
DROP TABLE curso;

CREATE TABLE curso 
( 
    id_curso INT PRIMARY KEY AUTO_INCREMENT,  
    tx_materia VARCHAR(100) NOT NULL 
);

INSERT INTO curso (tx_materia)
VALUE ('ads');

INSERT INTO curso (tx_materia)
VALUE ('medicina');

SELECT * FROM curso;

-- Tabela de turmas
DROP TABLE turma;

CREATE TABLE turma 
( 
    ID_turma INT PRIMARY KEY AUTO_INCREMENT,  
    id_curso INT,  -- FK
    id_professor INT,  -- FK
    FOREIGN KEY (id_curso) REFERENCES curso(id_curso),
    FOREIGN KEY (id_professor) REFERENCES professor(id_professor)
);

INSERT INTO turma (id_curso, id_professor)
VALUES (
  (select id_curso from curso where tx_materia = 'ads'),
  (select id_professor from professor where tx_cpf = '98765432197')
);

INSERT INTO turma (id_curso, id_professor)
VALUES (
  (select id_curso from curso where tx_materia = 'medicina'),
  (select id_professor from professor where tx_cpf = '98765432198')
);

SELECT * FROM turma;

-- Tabela de relacionamento entre turmas e alunos
DROP TABLE matriculado;

CREATE TABLE matriculado
( 
    id_turma INT,  
    id_aluno INT,  
    PRIMARY KEY (id_turma, id_aluno),
    FOREIGN KEY (id_turma) REFERENCES turma(id_turma),
    FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno)
);

INSERT INTO matriculado (id_turma, id_aluno)
VALUES (1, 1);

INSERT INTO matriculado (id_turma, id_aluno)
VALUES (1, 2);

INSERT INTO matriculado (id_turma, id_aluno)
VALUES (2, 3);

INSERT INTO matriculado (id_turma, id_aluno)
VALUES (1, 4);

SELECT * FROM matriculado

COMMIT;

-- lista
SELECT c.tx_uf AS uf
     , c.tx_nome AS cidade
     , cur.tx_materia AS curso     
     , p.tx_nome AS professor
--   , e.tx_cep AS CEP
     , a.tx_nome AS aluno
  FROM cidade c
	   INNER JOIN endereco e ON e.id_cidade = c.id_cidade
       INNER JOIN aluno a ON a.id_endereco = e.id_endereco
       INNER JOIN matriculado m ON m.id_aluno = a.id_aluno
       INNER JOIN turma t ON t.id_turma = m.id_turma
       INNER JOIN curso cur ON cur.id_curso = t.id_curso
       INNER JOIN professor p ON p.id_professor = t.id_professor
ORDER BY c.tx_uf
	   , c.tx_nome
       , cur.tx_materia
       , p.tx_nome
       , a.tx_nome
       , e.tx_cep
