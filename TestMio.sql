-- Test InserisciPartecipazione con corso non programmato
CALL InserisciPartecipazione('1', '1');
SELECT * FROM PIANOSTUDI WHERE Matricola='1';

-- Test con corso programmato e posti disponibili
CALL InserisciPartecipazione('2', '3');
SELECT * FROM PIANOSTUDI WHERE Matricola='2';

-- Test con corso programmato senza posti (deve andare in RICHIESTE_RIFIUTATE)
CALL InserisciPartecipazione('1', '4');
CALL InserisciPartecipazione('2', '4');
CALL InserisciPartecipazione('3', '4');
CALL InserisciPartecipazione('4', '4'); -- Questa dovrebbe essere rifiutata
SELECT * FROM RICHIESTE_RIFIUTATE;

-- Test InserisciVerbalizzazione
CALL InserisciVerbalizzazione('1', '1', 28);
SELECT * FROM VERBALIZZAZIONE WHERE Matricola='1';

-- Verifica incremento CFU dopo verbalizzazione
SELECT Matricola, CFUConseguiti FROM STUDENTE WHERE Matricola='1';

-- Test CancellaStorico
CALL CancellaStorico();
SELECT COUNT(*) FROM RICHIESTE_RIFIUTATE; -- Dovrebbe essere 0

-- Test RimuoviStudente
CALL RimuoviStudente('5');
SELECT * FROM STUDENTE WHERE Matricola='5'; -- Non dovrebbe esistere

--
SELECT * FROM PIANOSTUDI;
--
SELECT * from dipartimento;

SELECT * FROM INSEGNAMENTO;

SELECT * FROM studente;

select * from RICHIESTE_RIFIUTATE;
--
INSERT into DIPARTIMENTO(Nome,	Sede,	NumeroDocenti)	VALUES ('Sapienza Dams','Roma','1000');

insert into CORSOLAUREA(Codice,	Nome,	NomeDip,	NumeroProgrammato)	VALUES ('90','Dams','Sapienza Dams','Attivo');
INSERT  INTO STUDENTE(Matricola,CodiceCL,Nome,Cognome,CFUConseguiti) VALUES ('99','90','Marco','Bossi','0');

INSERT into INSEGNAMENTO(Id,	Nome,	CodiceCL,	CFU,	SSD,	NumIscritti,	MaxIscritti) VALUES ('100','Acrobazia','90','12','MAT',0,2);	

call InserisciPartecipazione('99','100');

call CancellaStorico();
CALL RimuoviStudente('99');

call InserisciVerbalizzazione('99','100',20);



SELECT * FROM LISTA_DIP_CON_INFORMATICA;

SELECT * from LISTA_STUDENTI_INATTIVI;