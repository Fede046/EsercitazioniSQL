-- Utilizzando il software MySQL, costruire il database PIANI_STUDIO. Il database tiene
-- traccia di studenti iscritti a corsi di laurea di UNIBO. Nello specifico, il database supporta
-- un'applicazione che gestisce la compilazione dei piani di studio e la verbalizzazione dei voti
-- degli insegnamenti svolti.

-- Il	database	PIANI_STUDIO	è	composto	dalle	seguenti	tabelle	(usare	il	table	engine:	INNODB):
-- STUDENTE(Matricola,	CodiceCL,	Nome,	Cognome,	CFUConseguiti)
-- CORSOLAUREA(Codice,	Nome,	NomeDip,	NumeroProgrammato)
-- DIPARTIMENTO(Nome,	Sede,	NumeroDocenti)
-- INSEGNAMENTO(Id,	Nome,	CodiceCL,	CFU,	SSD,	NumIscritti,	MaxIscritti)
-- PIANOSTUDI(Matricola,	IdInsegnamento,	Data)
-- RICHIESTE_RIFIUTATE(Matricola,	IdInsegnamento,	Data)
-- VERBALIZZAZIONE(Matricola,	IdInsegnamento,	Data,	Voto)
-- Vincoli	sui	dati:
-- Ø Vincolo	di	integrità	referenziale	tra	STUDENTE.CodiceCL	e	CORSOLAUREA.Codice
-- Ø Vincolo	di	integrità	referenziale	tra	INSEGNAMENTO.CodiceCL	e	CORSOLAUREA.Codice
-- Ø Vincolo	di	integrità	referenziale	tra	CORSOLAUREA.NomeDip	e	DIPARTIMENTO.Nome
-- Ø Vincolo	di	integrità	referenziale	tra	PIANOSTUDI.Matricola	e	STUDENTE.Matricola
-- Ø Vincolo	di	integrità	referenziale	tra	PIANOSTUDI.IdInsegnamento	e	INSEGNAMENTO.Id
-- Ø Vincolo	di	integrità	referenziale	tra	RICHIESTE_RIFIUTATE.Matricola	e	STUDENTE.Matricola
-- Ø Vincolo	di	integrità	referenziale	tra	RICHIESTE_RIFIUTATE.IdInsegnamento	e
-- INSEGNAMENTO.Id
-- Ø Vincolo	di	integrità	referenziale	tra	VERBALIZZAZIONE.Matricola	e	STUDENTE.Matricola
-- Ø Vincolo	di	integrità	referenziale	tra	VERBALIZZAZIONE.IdInsegnamento	e	INSEGNAMENTO.Id
-- Ø CORSOLAUREA.Nome	non	ammette	duplicati	e	non	può	essere	NULL
-- Ø CORSOLAUREA.NomeDip	non	può	essere	NULL
-- Ø Tutti	i	campi	di	tipo	stringa	devono	essere	VARCHAR	con	lunghezza	massima	30	caratteri.
-- Ø STUDENTE.CFUConseguiti	è	un	intero,	con	valore	di	default	pari	a	0.
-- Ø CORSOLAUREA.NumeroProgrammato	(type	ENUM)	può	assumere	solo	due	valori:	“Attivo”,
-- “Nonattivo”.
-- Ø INSEGNAMENTO.SSD	(type	ENUM)	può	assumere	solo	cinque	valori:	“INF”,	“ING-INF”,	“SECS”,
-- “IUS”,	“MAT”.
-- Ø I	campi	che	si	chiamano	Data	(presenti	in	tre	tabelle)	sono	di	tipo	Date.
-- Ø VERBALIZZAZIONE.Voto	NON	può	essere	NULL.
-- Ø Se	rimuovo	uno	STUDENTE,	cancello	anche	tutte	le	righe	nella	tabella	PIANOSTUDI,
-- RICHIESTE_RIFIUTATE	e	VERBALIZZAZIONE	che	fanno	riferimento	a	quello	studente.
-- Ø Se	rimuovo	un	INSEGNAMENTO,	cancello	anche	tutte	le	righe	nella	tabella	PIANOSTUDI,
-- RICHIESTE_RIFIUTATE	e	VERBALIZZAZIONE	che	fanno	riferimento	a	quell’insegnamento.

DROP DATABASE IF EXISTS PIANI_STUDIO;

CREATE DATABASE PIANI_STUDIO;

USE PIANI_STUDIO;

-- DIPARTIMENTO
CREATE TABLE DIPARTIMENTO (
    Nome VARCHAR(30) PRIMARY KEY,
    Sede VARCHAR(30),
    NumeroDocenti INT
);

-- CORSOLAUREA
CREATE TABLE CORSOLAUREA (
    Codice INT PRIMARY KEY,
    Nome VARCHAR(30) NOT NULL UNIQUE,
    NomeDip VARCHAR(30) NOT NULL,
    NumeroProgrammato ENUM('Attivo', 'Nonattivo'),
    Foreign Key (NomeDip) REFERENCES DIPARTIMENTO (Nome)
);

-- Studenti
CREATE TABLE STUDENTE (
    Matricola VARCHAR(30) PRIMARY KEY,
    CodiceCL INT,
    Nome VARCHAR(30),
    Cognome VARCHAR(30),
    CFUConseguiti INT DEFAULT(0),
    Foreign Key (CodiceCL) REFERENCES CORSOLAUREA (Codice)
);

-- INSEGNAMENTO
CREATE TABLE INSEGNAMENTO (
    Id VARCHAR(30) PRIMARY KEY,
    Nome VARCHAR(30),
    CodiceCL INT,
    CFU INT,
    SSD ENUM(
        'INF',
        'ING-INF',
        'SECS',
        'IUS',
        'MAT'
    ),
    NumIscritti INT,
    MaxIscritti INT,
    Foreign Key (CodiceCL) REFERENCES CORSOLAUREA (Codice)
);

--PIANOSTUDI
CREATE Table PIANOSTUDI (
    Matricola VARCHAR(30),
    IdInsegnamento VARCHAR(30),
    Data DATE,
    PRIMARY KEY (Matricola, IdInsegnamento),
    FOREIGN KEY (Matricola) REFERENCES STUDENTE (Matricola) ON DELETE CASCADE,
    FOREIGN KEY (IdInsegnamento) REFERENCES INSEGNAMENTO (Id) ON DELETE CASCADE
);

--RICHIESTE_RIFIUTATE
CREATE Table RICHIESTE_RIFIUTATE (
    Matricola VARCHAR(30),
    IdInsegnamento VARCHAR(30),
    Data DATE,
    PRIMARY KEY (Matricola, IdInsegnamento),
    FOREIGN KEY (Matricola) REFERENCES STUDENTE (Matricola) ON DELETE CASCADE,
    FOREIGN KEY (IdInsegnamento) REFERENCES INSEGNAMENTO (Id) ON DELETE CASCADE
);

--VERBALIZZAZIONE
CREATE Table VERBALIZZAZIONE (
    Matricola VARCHAR(30),
    IdInsegnamento VARCHAR(30),
    Data DATE,
    Voto INT NOT NULL,
    PRIMARY KEY (Matricola, IdInsegnamento),
    FOREIGN KEY (Matricola) REFERENCES STUDENTE (Matricola) ON DELETE CASCADE,
    FOREIGN KEY (IdInsegnamento) REFERENCES INSEGNAMENTO (Id) ON DELETE CASCADE
);

--Implementare	i	seguenti	trigger:

-- IncrementaPartecipanti	à	Dopo	ogni	inserimento	nella	tabella	PIANOSTUDI
-- relativo	ad	un	certo	insegnamento	con	id	pari	a	IdInsegnamento,	modifica
-- automaticamente	il	campo	NumIscritti	associato	a	quell’id	nella	tabella
-- INSEGNAMENTO,	incrementandolo	di	1	unità.

DELIMITER |

CREATE TRIGGER IncrementaPartecipanti
AFTER INSERT ON PIANOSTUDI
FOR EACH ROW
BEGIN
    UPDATE INSEGNAMENTO SET NumIscritti = NumIscritti + 1 WHERE Id = NEW.IdInsegnamento;
END |

DELIMITER;

-- DecrementaPartecipanti	à	Dopo	ogni	rimozione	nella	tabella	PIANOSTUDI
-- relativo	ad	un	certo	insegnamento	con	id	pari	a	IdInsegnamento,	modifica
-- automaticamente	il	campo	NumIscritti	associato	a	quell’id	nella	tabella
-- INSEGNAMENTO,	decrementandolo	di	1	unità.

DELIMITER |

CREATE TRIGGER DecrementaPartecipanti
AFTER DELETE ON PIANOSTUDI
FOR EACH ROW
BEGIN
    UPDATE INSEGNAMENTO
    SET NumIscritti = NumIscritti - 1
-- controllare se va bene old non c'è nelle slide del PROF ma risolve il problema
-- nel caso valutare soluzioni alternative
    WHERE Id = OLD.IdInsegnamento
      AND NumIscritti > 0;
END |

DELIMITER;

-- Dopo	ogni	inserimento	nella	tabella	VERBALIZZAZIONE	relativo
-- ad	un	certo	riga	con	id	dell’insegnamento	pari	a	IdInsegnamento	e	matricola	pari	a	Mat,
-- incrementa	automaticamente	il	campo	CFUConseguiti	nella	tabella	STUDENTE	nella	riga
-- relativa	alla	matricola	uguale	a	Mat.	L’incremento	è	pari	al	numero	di	CFU
-- dell’insegnamento	con	id	pari	a	IdInsegnamento,	presente	nella	tabella
-- INSEGNAMENTO.

DELIMITER |

CREATE TRIGGER IncrementoCFU
AFTER INSERT ON VERBALIZZAZIONE
FOR EACH ROW
BEGIN
    UPDATE Studente
    SET CFUConseguiti = CFUConseguiti + (
        SELECT Cfu
        FROM Insegnamento
        WHERE Insegnamento.Id = NEW.IdInsegnamento
    )
    WHERE Matricola = NEW.Matricola;
END |

DELIMITER;

----INSERT
-- Popolare	il	contenuto	delle	tabelle	STUDENTE,	CORSOLAUREA,	INSEGNAMENTO,
-- DIPARTIMENTO	caricando	i	dati	dai	file	studenti.txt, cdl.txt, insegnamenti.txt,
-- dipartimenti.txt. I	file	sono	disponibili	sulla	piattaforma	Virtuale.	Il	caricamento	dei	dati
-- di	una	tabella	DEVE	avvenire	attraverso	istruzioni	di	INSERT ripetute.

-- INSERT ripetuti per DIPARTIMENTO
INSERT INTO
    DIPARTIMENTO (Nome, Sede, NumeroDocenti)
VALUES ('DISI', 'Bologna', 30);

INSERT INTO
    DIPARTIMENTO (Nome, Sede, NumeroDocenti)
VALUES ('DISA', 'Bologna', 85);

INSERT INTO
    DIPARTIMENTO (Nome, Sede, NumeroDocenti)
VALUES ('MAT', 'Bologna', 110);

SELECT * FROM DIPARTIMENTO;

-- INSERT ripetuti per CORSOLAUREA
INSERT INTO
    CORSOLAUREA (
        Codice,
        Nome,
        NomeDip,
        NumeroProgrammato
    )
VALUES (
        8019,
        'Informatica',
        'DISI',
        'Nonattivo'
    );

INSERT INTO
    CORSOLAUREA (
        Codice,
        Nome,
        NomeDip,
        NumeroProgrammato
    )
VALUES (
        8014,
        'InfoMan',
        'DISI',
        'Nonattivo'
    );

INSERT INTO
    CORSOLAUREA (
        Codice,
        Nome,
        NomeDip,
        NumeroProgrammato
    )
VALUES (
        6061,
        'Matematica',
        'MAT',
        'Attivo'
    );

INSERT INTO
    CORSOLAUREA (
        Codice,
        Nome,
        NomeDip,
        NumeroProgrammato
    )
VALUES (
        6610,
        'Economia Aziendale',
        'DISA',
        'Attivo'
    );

SELECT * FROM corsolaurea;

-- INSERT ripetuti per STUDENTE
INSERT INTO
    STUDENTE (
        Matricola,
        CodiceCL,
        Nome,
        Cognome,
        CFUConseguiti
    )
VALUES (
        '1',
        8014,
        'Luca',
        'Bianchi',
        12
    );

INSERT INTO
    STUDENTE (
        Matricola,
        CodiceCL,
        Nome,
        Cognome,
        CFUConseguiti
    )
VALUES (
        '2',
        8014,
        'Maria',
        'Rossi',
        18
    );

INSERT INTO
    STUDENTE (
        Matricola,
        CodiceCL,
        Nome,
        Cognome,
        CFUConseguiti
    )
VALUES (
        '3',
        8014,
        'Giulia',
        'Neri',
        0
    );

INSERT INTO
    STUDENTE (
        Matricola,
        CodiceCL,
        Nome,
        Cognome,
        CFUConseguiti
    )
VALUES (
        '4',
        8014,
        'Paolo',
        'Verdi',
        24
    );

INSERT INTO
    STUDENTE (
        Matricola,
        CodiceCL,
        Nome,
        Cognome,
        CFUConseguiti
    )
VALUES (
        '5',
        8014,
        'Chiara',
        'Marrone',
        6
    );

SELECT * FROM STUDENTE;

-- INSERT ripetuti per INSEGNAMENTO
INSERT INTO
    INSEGNAMENTO (
        Id,
        Nome,
        CodiceCL,
        CFU,
        SSD,
        NumIscritti,
        MaxIscritti
    )
VALUES (
        1,
        'Apprendimento automatico',
        8019,
        6,
        'INF',
        0,
        0
    );

INSERT INTO
    INSEGNAMENTO (
        Id,
        Nome,
        CodiceCL,
        CFU,
        SSD,
        NumIscritti,
        MaxIscritti
    )
VALUES (
        2,
        'Lab Making',
        8019,
        6,
        'INF',
        0,
        0
    );

INSERT INTO
    INSEGNAMENTO (
        Id,
        Nome,
        CodiceCL,
        CFU,
        SSD,
        NumIscritti,
        MaxIscritti
    )
VALUES (
        3,
        'Ottimizzazione',
        6061,
        6,
        'MAT',
        0,
        5
    );

INSERT INTO
    INSEGNAMENTO (
        Id,
        Nome,
        CodiceCL,
        CFU,
        SSD,
        NumIscritti,
        MaxIscritti
    )
VALUES (
        4,
        'Diritto Privato',
        6610,
        6,
        'IUS',
        0,
        3
    );

INSERT INTO
    INSEGNAMENTO (
        Id,
        Nome,
        CodiceCL,
        CFU,
        SSD,
        NumIscritti,
        MaxIscritti
    )
VALUES (
        5,
        'Economia Aziendale',
        6610,
        6,
        'SECS',
        0,
        250
    );

SELECT * FROM INSEGNAMENTO;

--Implementare	le	seguenti	Stored	Procedure:

-- a) InserisciPartecipazione(IN Mat VARCHAR(30), IN IdIns VARCHAR(30)) à
-- à	Verifica	se	Mat	fa	riferimento	ad	una	matricola	esistente	nella	tabella	STUDENTE,	ed
-- InIns	ad	un	insegnamento	valido	nella	tabella	INSEGNAMENTO.	Se	tali	condizioni	sono
-- soddisfatte:
-- Se	IdIns	si	riferisce	ad	un	insegnamento	di	un	Corso	di	Laurea	con	numero	programmato
-- pari	ad	“Nonattivo”,	inserisce	una	riga	dentro	la	tabella	PIANOSTUDI,	con	Matricola	pari
-- a	Mat,	e	IdInsegnamento	pari	a	IdIns.	Viceversa,	Se	IdIns	si	riferisce	ad	un	insegnamento
-- di	un	Corso	di	Laurea	con	numero	programmato	pari	ad	“Attivo”:	verifica	se,	per
-- l’insegnamento	con	Id	pari	a	IdIns,		il	campo	NumIscritti	è	inferiore	a	MaxIscritti.	In	tal
-- caso,	inserisce	una	riga	dentro	la	tabella	PIANOSTUDI,	con	Matricola	pari	a	Mat,	e
-- IdInsegnamento	pari	a	IdIns.	Il	campo	Data	va	settato	alla	data	attuale.	Vice	versa,	se,
-- per	l’insegnamento	con	Id	pari	a	IdIns,		il	campo	NumIscritti	è	uguale	o	superiore	a
-- MaxIscritti,	inserire	una	riga	dentro	la	tabella	RICHIESTE_RIFIUTATE,	con	Matricola
-- pari	a	Mat,	e	IdInsegnamento	pari	a	IdIns.	Il	campo	Data	va	settato	alla	data	attuale

DELIMITER $

CREATE PROCEDURE InserisciPartecipazione(IN Mat VARCHAR(30), IN IdIns VARCHAR(30))
BEGIN
        DECLARE condM INT;
        DECLARE condI INT;
        DECLARE presente INT;
        DECLARE tp enum('Attivo', 'Nonattivo');
        DECLARE posti int;


        set condM = (
            SELECT count(*) from studente where Matricola=Mat
        ); 
        
        set condI = (
            SELECT count(*) from INSEGNAMENTO where Id=IdIns
        );
        -- Questo serve per la gestione di casi in cui è già stato inserito
        -- all'interno per evitare messaggi di errore, funziona anche senza.
        set presente = (
            SELECT count(*) FROM PIANOSTUDI WHERE Matricola=Mat AND IdInsegnamento=IdIns
        );

        if condM>0 and condI>0 and presente<=0 THEN
            
            set tp = (
                SELECT NumeroProgrammato from INSEGNAMENTO 
                join CORSOLAUREA ON (INSEGNAMENTO.CodiceCL = CORSOLAUREA.Codice) 
                where INSEGNAMENTO.Id=IdIns 
            );

            if tp='Nonattivo' THEN

                    INSERT INTO PIANOSTUDI(Matricola,IdInsegnamento,Data) VALUES (Mat,IdIns,CURRENT_DATE);
            END IF;
            
            if tp='Attivo' THEN

                set posti = (
                    SELECT (MaxIscritti-NumIscritti) from INSEGNAMENTO 
                    where Id=IdIns
                );

                if posti>0 THEN
                    INSERT INTO PIANOSTUDI(Matricola,IdInsegnamento,Data) VALUES (Mat,IdIns,CURRENT_DATE);
                ELSE
                    INSERT INTO RICHIESTE_RIFIUTATE(Matricola,IdInsegnamento,Data) VALUES (Mat,IdIns,CURRENT_DATE);
                end if;

            end if;
        end if;
END $

DELIMITER;

-- b) InserisciVerbalizzazione(IN Mat VARCHAR(30), IN Ins VARCHAR(30), Vt:
-- INT) à Verifica	se	Mat	ed	Ins	fanno	riferimento	ad	una	riga	presente	nella	tabella
-- PIANOSTUDI.	In	tal	caso,	aggiunge	una	riga	nella	tabella	VERBALIZZAZIONE,	con	voto
-- pari	a	Vt.	Il	campo	Data	va	settato	alla	data	attuale.

DELIMITER $

CREATE Procedure InserisciVerbalizzazione(IN Mat VARCHAR(30), IN Ins VARCHAR(30), IN Vt INT)
BEGIN
        DECLARE contatore INT;
        set contatore = (
            select count(*) from PIANOSTUDI 
            WHERE Matricola = Mat and IdInsegnamento=Ins
        );
        if contatore>0 THEN
            INSERT INTO VERBALIZZAZIONE(Matricola,IdInsegnamento,Data,voto) VALUES (Mat,Ins,CURRENT_DATE,Vt);
        end if;
END$

DELIMITER;

-- c) CancellaStorico() à Rimuove	tutte	le	righe	presenti	nella	tabella
-- RICHIESTE_RIFIUTATE.
DELIMITER $

CREATE PROCEDURE CancellaStorico() 
BEGIN
    DELETE FROM RICHIESTE_RIFIUTATE;
END$

DELIMITER;

-- d) RimuoviStudente(IN Mat VARCHAR(30)) à Rimuove	dalla	tabella	STUDENTE	la
-- riga	relativa	allo	studente	con	matricola	pari	a	Mat.

DELIMITER $

CREATE Procedure RimuoviStudente(IN Mat VARCHAR(30))
begin
    DECLARE contatore INT;

    SET contatore = (
        SELECT COUNT(*) FROM studente where (Matricola=Mat)
    );
    if (contatore>0) THEN
        DELETE from studente WHERE Matricola=Mat;
    end if;
END$

DELIMITER;

-- Viste
-- LISTA_DIP_CON_INFORMATICA(Nome,	Sede)	à	restituisce	nome	e	sede	dei
-- dipartimenti	che	hanno	corsi	di	laurea	che	a	loro	volta	contengono	insegnamenti	con
-- SSD	pari	a	INF.
CREATE VIEW LISTA_DIP_CON_INFORMATICA (Nome, Sede) AS
SELECT DISTINCT
    D.Nome,
    D.Sede
FROM
    DIPARTIMENTO D
    JOIN CORSOLAUREA C ON C.NomeDip = D.Nome
    JOIN INSEGNAMENTO I ON I.CodiceCL = C.Codice
WHERE
    I.SSD = 'INF';

-- LISTA_STUDENTI_INATTIVI	(Mat,	CodiceCL)	à	restituisce	la	lista	degli	studenti	che
-- NON	hanno	alcun	insegnamento	nel	loro	piano	di	studi.
CREATE VIEW LISTA_STUDENTI_INATTIVI (Mat, CodiceCL) AS
SELECT S.Matricola AS Mat, S.CodiceCL
FROM STUDENTE S
WHERE
    S.Matricola NOT IN(
        SELECT P.Matricola
        FROM PIANOSTUDI P
    );

-- LISTA_INSEGNAMENTI_TOP (Id,	Nome,	CodiceCL)	à	restituisce	l’insegnamento/
-- insegnamenti	che	ha	/	hanno	ricevuto	più	richieste	da	parte	degli	studenti.	Le	richieste
-- si	ottengono	sommando,	per	ciascun	insegnamento,	il	numero	di	volte	in	cui	tale
-- insegnamento	appare	in	un	piano	di	studi	(richieste	accettate),	al	numero	di	volte	in	cui
-- appare	nelle	richieste	rifiutate.

-- LISTA_AREE_TOP (ssd)	à	restituisce	la	lista	degli	SSD	che	compaiono	in	almeno	3
-- insegnamenti	presentinei	piani	di	studio	degli	studenti	con	CodiceCL	=	8014.

CREATE VIEW LISTA_AREE_TOP (SSD) AS
SELECT I.SSD
FROM
    PIANOSTUDI P
    JOIN STUDENTE S ON P.Matricola = S.Matricola
    JOIN INSEGNAMENTO I ON P.IdInsegnamento = I.Id
WHERE
    S.CodiceCL = 8014
GROUP BY
    I.SSD
HAVING
    COUNT(*) >= 3;