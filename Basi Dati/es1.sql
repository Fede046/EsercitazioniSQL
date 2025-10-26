--0  Utilizzando  il  software  MySQL,  costruire  il  database  PIANI_STUDIO.  Il  database  tiene 
--traccia  di  studenti  iscritti  a  corsi  di  laurea  di  UNIBO.  Nello  specifico,  il  database  supporta 
--un’applicazione che gestisce la compilazione dei piani di studio e la verbalizzazione dei voti 
--degli insegnamenti svolti. 

DROP DATABASE IF EXISTS PIANI_STUDIO;
CREATE DATABASE PIANI_STUDIO;

USE PIANI_STUDIO;

CREATE TABLE STUDENTI (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    NOME VARCHAR(100) NOT NULL,
    COGNOME VARCHAR(100) NOT NULL,
    EMAIL VARCHAR(255)
);

SELECT * FROM STUDENTI;