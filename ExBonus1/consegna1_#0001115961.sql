-- CREAZIONE DEL DB
DROP DATABASE IF EXISTS PIANI_STUDIO;

CREATE DATABASE PIANI_STUDIO;

USE PIANI_STUDIO;

--CREAZIONE DELLE TABLE

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

--Trigger:

-- IncrementaPartecipanti	

DELIMITER |

CREATE TRIGGER IncrementaPartecipanti
AFTER INSERT ON PIANOSTUDI
FOR EACH ROW
BEGIN
    UPDATE INSEGNAMENTO SET NumIscritti = NumIscritti + 1 WHERE Id = NEW.IdInsegnamento;
END |

DELIMITER;

-- DecrementaPartecipanti	
DELIMITER |

CREATE TRIGGER DecrementaPartecipanti
AFTER DELETE ON PIANOSTUDI
FOR EACH ROW
BEGIN
    UPDATE INSEGNAMENTO
    SET NumIscritti = NumIscritti - 1
    WHERE Id = OLD.IdInsegnamento
      AND NumIscritti > 0;
END |

DELIMITER;

--IncrementoCFU

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



--Implementare	le	seguenti	Stored	Procedure:

-- a) InserisciPartecipazione(IN Mat VARCHAR(30), IN IdIns VARCHAR(30)) 

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

-- b) InserisciVerbalizzazione(IN Mat VARCHAR(30), IN Ins VARCHAR(30), Vt:INT) 

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

-- c) CancellaStorico() 

DELIMITER $

CREATE PROCEDURE CancellaStorico() 
BEGIN
    DELETE FROM RICHIESTE_RIFIUTATE;
END$

DELIMITER;

-- d) RimuoviStudente(IN Mat VARCHAR(30))

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

-- LISTA_DIP_CON_INFORMATICA(Nome,	Sede)	
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

-- LISTA_STUDENTI_INATTIVI	(Mat,	CodiceCL)	
CREATE VIEW LISTA_STUDENTI_INATTIVI (Mat, CodiceCL) AS
SELECT S.Matricola AS Mat, S.CodiceCL
FROM STUDENTE S
WHERE
    S.Matricola NOT IN(
        SELECT P.Matricola
        FROM PIANOSTUDI P
    );

-- LISTA_INSEGNAMENTI_TOP (Id,	Nome,	CodiceCL)
CREATE VIEW LISTA_INSEGNAMENTI_TOP (Id, Nome, CodiceCL) AS
SELECT I.Id, I.Nome, I.CodiceCL
FROM INSEGNAMENTO I
LEFT JOIN PIANOSTUDI P ON P.IdInsegnamento = I.Id
LEFT JOIN RICHIESTE_RIFIUTATE R ON R.IdInsegnamento = I.Id
GROUP BY I.Id, I.Nome, I.CodiceCL
HAVING COUNT(P.IdInsegnamento) + COUNT(R.IdInsegnamento) = (
    SELECT MAX(total_richieste)
    FROM (
        SELECT COUNT(P2.IdInsegnamento) + COUNT(R2.IdInsegnamento) as total_richieste
        FROM INSEGNAMENTO I2
        LEFT JOIN PIANOSTUDI P2 ON P2.IdInsegnamento = I2.Id
        LEFT JOIN RICHIESTE_RIFIUTATE R2 ON R2.IdInsegnamento = I2.Id
        GROUP BY I2.Id
    ) as richieste_per_insegnamento
);


-- LISTA_AREE_TOP (ssd)	

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