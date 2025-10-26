--0  Utilizzando  il  software  MySQL,  costruire  il  database  PIANI_STUDIO.  Il  database  tiene 
--traccia  di  studenti  iscritti  a  corsi  di  laurea  di  UNIBO.  Nello  specifico,  il  database  supporta 
--un’applicazione che gestisce la compilazione dei piani di studio e la verbalizzazione dei voti 
--degli insegnamenti svolti. 

DROP DATABASE IF EXISTS PIANI_STUDIO;
CREATE DATABASE PIANI_STUDIO;

USE PIANI_STUDIO;

--Stuenti
CREATE TABLE STUDENTE (
    Matricola INT PRIMARY KEY,
    CodiceCL INT NOT NULL,
    Nome VARCHAR(100) NOT NULL,
    Cognome VARCHAR(100) NOT NULL,
    CFUConseguiti INT NOT NULL
);

INSERT INTO STUDENTE (Matricola, CodiceCL, Nome, Cognome, CFUConseguiti) VALUES
(1,8014,'Luca','Bianchi', 12),
(2,8014,'Maria','Rossi', 18),
(3,8014,'Giulia','Neri', 0),
(4,8014,'Paolo','Verdi', 24),
(5,8014,'Chiara','Marrone', 6);


SELECT * FROM STUDENTE;

--CORSOLAUREA

CREATE TABLE CORSOLAUREA(
    Codice INT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    NomeDip VARCHAR(100) NOT NULL,
    NumeroProgrammato VARCHAR(100) NOT NULL
);

INSERT INTO CORSOLAUREA(Codice, Nome, NomeDip, NumeroProgrammato) VALUES
(8019,'Informatica','DISI','Nonattivo'),
(8014,'InfoMan','DISI','Nonattivo'),
(6061, 'Matematica','MAT','Attivo'),
(6610,'Economia Aziendale','DISA','Attivo');

SELECT * FROM corsolaurea;

--DIPARTIMENTO
CREATE Table DIPARTIMENTOO(

);