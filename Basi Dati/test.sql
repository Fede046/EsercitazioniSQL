USE PIANI_STUDIO;

# Rimuove eventuali procedure/tabelle di test preesistenti
SET SQL_SAFE_UPDATES=0;
DROP PROCEDURE IF EXISTS TEST_UNO;
DROP PROCEDURE IF EXISTS TEST_DUE;
DROP PROCEDURE IF EXISTS TEST_TRE;
DROP PROCEDURE IF EXISTS TEST_QUATTRO;
DROP PROCEDURE IF EXISTS TEST_CINQUE;
DROP PROCEDURE IF EXISTS TEST_SEI;
DROP PROCEDURE IF EXISTS TEST_SETTE;
DROP PROCEDURE IF EXISTS TEST_OTTO;
DROP PROCEDURE IF EXISTS TEST_NOVE;
DROP PROCEDURE IF EXISTS TEST_DIECI;
DROP PROCEDURE IF EXISTS TEST_UNDICI;
DROP PROCEDURE IF EXISTS TEST_DODICI;
DROP PROCEDURE IF EXISTS TEST_TREDICI;
DROP PROCEDURE IF EXISTS TEST_QUATTORDICI;
DROP PROCEDURE IF EXISTS TEST_QUINDICI;
DROP PROCEDURE IF EXISTS AGGIUNGI_LOG;
DROP PROCEDURE IF EXISTS STAMPA_LOG;
DROP PROCEDURE IF EXISTS RIEPILOGO_TEST;
DROP PROCEDURE IF EXISTS RIPRISTINA_DB;
DROP TABLE IF EXISTS LOG;

# -----------------------------------------------------
# Variabili di controllo e numeriche attese (NON MODIFICARE)
SET @NUM_DIPARTIMENTI = 3;
SET @NUM_CORSI        = 4;
SET @NUM_STUDENTI     = 5;
SET @NUM_INSEGNAMENTI = 5;

SET @TEST_ERROR_CONDITION   = FALSE;
SET @GLOBAL_ERROR_CONDITION = FALSE;
# -----------------------------------------------------


# -----------------------------------------------------
# Funzioni di logging  (NON MODIFICARE)
CREATE TABLE LOG(
  Id INT AUTO_INCREMENT PRIMARY KEY,
  NumeroTest INT,
  Messaggio VARCHAR(200),
  Esito BOOLEAN
);

DELIMITER $
CREATE PROCEDURE AGGIUNGI_LOG(IN TestNo INT, IN Testo VARCHAR(200), IN Ok BOOLEAN)
BEGIN
  INSERT INTO LOG(NumeroTest, Messaggio, Esito) VALUES (TestNo, Testo, Ok);
END $
DELIMITER ;

DELIMITER $
CREATE PROCEDURE RIEPILOGO_TEST(IN NumTest INT)
BEGIN
  DECLARE Messaggio VARCHAR(30);
  IF (@TEST_ERROR_CONDITION = TRUE) THEN
    SET Messaggio = CONCAT(' TEST ', NumTest, ' FALLITO');
    CALL AGGIUNGI_LOG(NumTest, Messaggio, FALSE);
  ELSE
    SET Messaggio = CONCAT(' TEST ', NumTest, ' OK');
    CALL AGGIUNGI_LOG(NumTest, Messaggio, TRUE);
  END IF;
  SET @GLOBAL_ERROR_CONDITION = @GLOBAL_ERROR_CONDITION OR @TEST_ERROR_CONDITION;
  SET @TEST_ERROR_CONDITION = FALSE;
END $
DELIMITER ;

DELIMITER $
CREATE PROCEDURE STAMPA_LOG()
BEGIN
  IF @GLOBAL_ERROR_CONDITION = TRUE THEN
    CALL AGGIUNGI_LOG(0, 'TEST NON SUPERATO! (debug necessario)', FALSE);
  ELSE
    CALL AGGIUNGI_LOG(0, 'TEST INTERAMENTE SUPERATO! (puoi sottomettere)', TRUE);
  END IF;
  SELECT NumeroTest, Messaggio, Esito FROM LOG;
END $
DELIMITER ;
# -----------------------------------------------------


# -----------------------------------------------------
# Funzione di ripristino DB a valle di modifiche operate dal test
# (ripulisce le tabelle dinamiche e ripristina i valori iniziali)
DELIMITER $
CREATE PROCEDURE RIPRISTINA_DB()
BEGIN
  # Svuota tabelle di stato
  DELETE FROM VERBALIZZAZIONE;
  DELETE FROM RICHIESTE_RIFIUTATE;
  DELETE FROM PIANOSTUDI;

  # Ripristina contatori iscritti degli insegnamenti
  UPDATE INSEGNAMENTO
  SET NumIscritti = 0;

  # Ripristina CFU degli studenti ai valori di popolamento iniziale
  # (coerenti con le INSERT del file di partenza)
  UPDATE STUDENTE SET CFUConseguiti = 12 WHERE Matricola = 1;
  UPDATE STUDENTE SET CFUConseguiti = 18 WHERE Matricola = 2;
  UPDATE STUDENTE SET CFUConseguiti = 0  WHERE Matricola = 3;
  UPDATE STUDENTE SET CFUConseguiti = 24 WHERE Matricola = 4;
  UPDATE STUDENTE SET CFUConseguiti = 6  WHERE Matricola = 5;
END $
DELIMITER ;
# -----------------------------------------------------

# Test UNO: Verifica il corretto popolamento delle tabelle DIPARTIMENTO, CORSOLAUREA, STUDENTE, INSEGNAMENTO
DELIMITER $
CREATE PROCEDURE TEST_UNO()
BEGIN
    DECLARE NumDip INT DEFAULT 0;
    DECLARE NumCL INT DEFAULT 0;
    DECLARE NumStud INT DEFAULT 0;
    DECLARE NumIns INT DEFAULT 0;

    # Conta i record nelle tabelle
    SET NumDip  = (SELECT COUNT(*) FROM DIPARTIMENTO);
    SET NumCL   = (SELECT COUNT(*) FROM CORSOLAUREA);
    SET NumStud = (SELECT COUNT(*) FROM STUDENTE);
    SET NumIns  = (SELECT COUNT(*) FROM INSEGNAMENTO);

    # Verifica se DIPARTIMENTO è popolata correttamente
    IF (NumDip != @NUM_DIPARTIMENTI) THEN
        CALL AGGIUNGI_LOG(1, 'Popolamento tabella DIPARTIMENTO NON corretto', FALSE);
        SET @TEST_ERROR_CONDITION = TRUE;
    ELSE
        CALL AGGIUNGI_LOG(1, 'Popolamento tabella DIPARTIMENTO CORRETTO', TRUE);
    END IF;

    # Verifica se CORSOLAUREA è popolata correttamente
    IF (NumCL != @NUM_CORSI) THEN
        CALL AGGIUNGI_LOG(1, 'Popolamento tabella CORSOLAUREA NON corretto', FALSE);
        SET @TEST_ERROR_CONDITION = TRUE;
    ELSE
        CALL AGGIUNGI_LOG(1, 'Popolamento tabella CORSOLAUREA CORRETTO', TRUE);
    END IF;

    # Verifica STUDENTE è popolata correttamente
    IF (NumStud != @NUM_STUDENTI) THEN
        CALL AGGIUNGI_LOG(1, 'Popolamento tabella STUDENTE NON corretto', FALSE);
        SET @TEST_ERROR_CONDITION = TRUE;
    ELSE
        CALL AGGIUNGI_LOG(1, 'Popolamento tabella STUDENTE CORRETTO', TRUE);
    END IF;

    # Verifica INSEGNAMENTO è popolata correttamente
    IF (NumIns != @NUM_INSEGNAMENTI) THEN
        CALL AGGIUNGI_LOG(1, 'Popolamento tabella INSEGNAMENTO NON corretto', FALSE);
        SET @TEST_ERROR_CONDITION = TRUE;
    ELSE
        CALL AGGIUNGI_LOG(1, 'Popolamento tabella INSEGNAMENTO CORRETTO', TRUE);
    END IF;

    CALL RIEPILOGO_TEST(1);
END $
DELIMITER ;

# Test DUE: InserisciPartecipazione NON deve inserire nulla per matricola inesistente
DELIMITER $
CREATE PROCEDURE TEST_DUE()
BEGIN
    DECLARE N INT;
	
    # Inserimento Matricola inesistente: non deve funzionare
    CALL InserisciPartecipazione(999, 1);  
    SET N = (SELECT COUNT(*) FROM PIANOSTUDI);

    IF (N > 0) THEN
        CALL AGGIUNGI_LOG(2, 'InserisciPartecipazione: accetta matricola inesistente (ERRORE)', FALSE);
        SET @TEST_ERROR_CONDITION = TRUE;
    ELSE
        CALL AGGIUNGI_LOG(2, 'InserisciPartecipazione: rifiuta matricola inesistente (OK)', TRUE);
    END IF;

    CALL RIPRISTINA_DB();
    CALL RIEPILOGO_TEST(2);
END $
DELIMITER ;


# Test TRE: InserisciPartecipazione NON deve inserire nulla per insegnamento inesistente
DELIMITER $
CREATE PROCEDURE TEST_TRE()
BEGIN
    DECLARE N INT;

    # Tentativo di inserimento con IdInsegnamento inesistente
    CALL InserisciPartecipazione(1, 999);  # 999 = IdInsegnamento inesistente

    # Nessuna riga deve essere stata inserita in PIANOSTUDI o RICHIESTE_RIFIUTATE
    SET N = (SELECT COUNT(*) FROM PIANOSTUDI) + (SELECT COUNT(*) FROM RICHIESTE_RIFIUTATE);

    IF (N > 0) THEN
        CALL AGGIUNGI_LOG(3, 'InserisciPartecipazione: accetta IdInsegnamento inesistente (ERRORE)', FALSE);
        SET @TEST_ERROR_CONDITION = TRUE;
    ELSE
        CALL AGGIUNGI_LOG(3, 'InserisciPartecipazione: rifiuta IdInsegnamento inesistente (OK)', TRUE);
    END IF;

    CALL RIPRISTINA_DB();
    CALL RIEPILOGO_TEST(3);
END $
DELIMITER ;

# Test QUATTRO: InserisciPartecipazione gestisce correttamente corsi attivi/non attivi
DELIMITER $
CREATE PROCEDURE TEST_QUATTRO()
BEGIN
    DECLARE CountAccettate INT;
    DECLARE CountRifiutate INT;

    # Caso 1: Corso NON ATTIVO: la richiesta deve essere accettata
    CALL InserisciPartecipazione(1, 1);   # Insegnamento 1 appartiene a corso NONATTIVO
    SET CountAccettate = (SELECT COUNT(*) FROM PIANOSTUDI);

    # Caso 2: Corso ATTIVO ma pieno, quindi deve andare in richieste rifiutate
    UPDATE INSEGNAMENTO SET NumIscritti = MaxIscritti WHERE Id = 3; # Riempie l'insegnamento 3
    CALL InserisciPartecipazione(1, 3);
    SET CountRifiutate = (SELECT COUNT(*) FROM RICHIESTE_RIFIUTATE);

    IF (CountAccettate = 1 AND CountRifiutate = 1) THEN
        CALL AGGIUNGI_LOG(4, 'InserisciPartecipazione gestisce correttamente corsi attivi/nonattivi (OK)', TRUE);
    ELSE
        CALL AGGIUNGI_LOG(4, 'InserisciPartecipazione NON gestisce correttamente corsi attivi/nonattivi (ERRORE)', FALSE);
        SET @TEST_ERROR_CONDITION = TRUE;
    END IF;

    CALL RIPRISTINA_DB();
    CALL RIEPILOGO_TEST(4);
END $
DELIMITER ;

# Test CINQUE: InserisciVerbalizzazione deve verificare studente e insegnamento esistenti
# NON deve inserire verbalizzazione se lo studente non ha l’insegnamento nel piano di studi
DELIMITER $
CREATE PROCEDURE TEST_CINQUE()
BEGIN
    DECLARE NumVerbal INT DEFAULT 0;
    DECLARE ExistStud INT DEFAULT 0;
    DECLARE ExistIns INT DEFAULT 0;

    # Controlliamo che lo studente e l'insegnamento ESISTANO davvero
    SET ExistStud = (SELECT COUNT(*) FROM STUDENTE WHERE Matricola = 1);
    SET ExistIns = (SELECT COUNT(*) FROM INSEGNAMENTO WHERE Id = 1);

    IF (ExistStud = 0 OR ExistIns = 0) THEN
        CALL AGGIUNGI_LOG(5, 'ERRORE TEST: studente o insegnamento di test non esistenti', FALSE);
        SET @TEST_ERROR_CONDITION = TRUE;
    ELSE
        # Provo a verbalizzare SENZA che lo studente abbia l'insegnamento nel piano
        CALL InserisciVerbalizzazione(1, 1, 30); # l'operazione deve fallire

        # Controllo che NON sia stata fatta la verbalizzazione 
        SET NumVerbal = (SELECT COUNT(*) FROM VERBALIZZAZIONE);

        IF (NumVerbal > 0) THEN
            CALL AGGIUNGI_LOG(5, 'InserisciVerbalizzazione accetta verbalizzazione ILLEGALE (ERRORE)', FALSE);
            SET @TEST_ERROR_CONDITION = TRUE;
        ELSE
            CALL AGGIUNGI_LOG(5, 'InserisciVerbalizzazione rifiuta verbalizzazione ILLEGALE (OK)', TRUE);
        END IF;
    END IF;

    CALL RIPRISTINA_DB();
    CALL RIEPILOGO_TEST(5);
END $
DELIMITER ;


# Test SEI: InserisciVerbalizzazione deve inserire correttamente una verbalizzazione valida
DELIMITER $
CREATE PROCEDURE TEST_SEI()
BEGIN
    DECLARE ExistStud INT DEFAULT 0;
    DECLARE ExistIns INT DEFAULT 0;
    DECLARE NumVerbal INT DEFAULT 0;

    # Verifica che lo studente e l'insegnamento del test ESISTANO
    SET ExistStud = (SELECT COUNT(*) FROM STUDENTE WHERE Matricola = 1);
    SET ExistIns = (SELECT COUNT(*) FROM INSEGNAMENTO WHERE Id = 1);

    IF (ExistStud = 0 OR ExistIns = 0) THEN
        CALL AGGIUNGI_LOG(6, 'ERRORE TEST: studente o insegnamento inesistenti', FALSE);
        SET @TEST_ERROR_CONDITION = TRUE;
    ELSE
        # Si inserisce una riga prima nel piano di studi (condizione necessaria)
        CALL InserisciPartecipazione(1, 1);

        # Adesso verbalizzazione valida
        CALL InserisciVerbalizzazione(1, 1, 28);

        # Controllo se è stata inserita
        SET NumVerbal = (SELECT COUNT(*) FROM VERBALIZZAZIONE WHERE Matricola = 1 AND IdInsegnamento = 1);

        IF (NumVerbal = 1) THEN
            CALL AGGIUNGI_LOG(6, 'InserisciVerbalizzazione accetta verbalizzazione valida (OK)', TRUE);
        ELSE
            CALL AGGIUNGI_LOG(6, 'InserisciVerbalizzazione NON inserisce verbalizzazione valida (ERRORE)', FALSE);
            SET @TEST_ERROR_CONDITION = TRUE;
        END IF;
    END IF;

    CALL RIPRISTINA_DB();
    CALL RIEPILOGO_TEST(6);
END $
DELIMITER ;


# Test SETTE: CancellaStorico deve svuotare la tabella RICHIESTE_RIFIUTATE
DELIMITER $
CREATE PROCEDURE TEST_SETTE()
BEGIN
    DECLARE NumRif INT DEFAULT 0;

    # Crea righe di test in richieste_rifiutate
    UPDATE INSEGNAMENTO SET NumIscritti = MaxIscritti WHERE Id = 3;
    CALL InserisciPartecipazione(1, 3); # va in RICHIESTE_RIFIUTATE
    CALL InserisciPartecipazione(2, 3); # va in RICHIESTE_RIFIUTATE

    # Verifica che ci siano almeno 2 righe prima della cancellazione
    SET NumRif = (SELECT COUNT(*) FROM RICHIESTE_RIFIUTATE);
    IF (NumRif = 0) THEN
        CALL AGGIUNGI_LOG(7, 'ERRORE TEST: impossibile preparare dati in RICHIESTE_RIFIUTATE', FALSE);
        SET @TEST_ERROR_CONDITION = TRUE;
    END IF;

    # Applica la procedura e verifica svuotamento
    CALL CancellaStorico();
    SET NumRif = (SELECT COUNT(*) FROM RICHIESTE_RIFIUTATE);

    IF (NumRif = 0) THEN
        CALL AGGIUNGI_LOG(7, 'CancellaStorico svuota correttamente RICHIESTE_RIFIUTATE (OK)', TRUE);
    ELSE
        CALL AGGIUNGI_LOG(7, 'CancellaStorico NON funziona correttamente (ERRORE)', FALSE);
        SET @TEST_ERROR_CONDITION = TRUE;
    END IF;

    CALL RIPRISTINA_DB();
    CALL RIEPILOGO_TEST(7);
END $
DELIMITER ;


# Test OTTO: verifica procedura RimuoviStudente e ON DELETE CASCADE
DELIMITER $
CREATE PROCEDURE TEST_OTTO()
BEGIN
    DECLARE BeforeDel INT DEFAULT 0;
    DECLARE AfterDel INT DEFAULT 0;

    # Preparazione: inseriamo una partecipazione e una verbalizzazione per lo studente 1
    CALL InserisciPartecipazione(1, 1);
    CALL InserisciVerbalizzazione(1, 1, 28);

    # Verifica che esistano righe associate allo studente
    SET BeforeDel = 
        (SELECT COUNT(*) FROM PIANOSTUDI WHERE Matricola = 1) +
        (SELECT COUNT(*) FROM VERBALIZZAZIONE WHERE Matricola = 1);

    # Elimina studente
    CALL RimuoviStudente(1);

    # Verifica che tutte le righe collegate siano eliminate
    SET AfterDel =
        (SELECT COUNT(*) FROM STUDENTE WHERE Matricola = 1) +
        (SELECT COUNT(*) FROM PIANOSTUDI WHERE Matricola = 1) +
        (SELECT COUNT(*) FROM VERBALIZZAZIONE WHERE Matricola = 1);

    IF (BeforeDel > 0 AND AfterDel = 0) THEN
        CALL AGGIUNGI_LOG(8, 'RimuoviStudente rimuove correttamente studente e dati collegati (OK)', TRUE);
    ELSE
        CALL AGGIUNGI_LOG(8, 'RimuoviStudente NON funziona correttamente (ERRORE)', FALSE);
        SET @TEST_ERROR_CONDITION = TRUE;
    END IF;
	
    #Inserisce nuovamente lo studente
    INSERT INTO STUDENTE (Matricola, CodiceCL, Nome, Cognome, CFUConseguiti) VALUES (1, 8014, 'Luca', 'Bianchi', 12);
    
    CALL RIPRISTINA_DB();
    CALL RIEPILOGO_TEST(8);
END $
DELIMITER ;


# Test NOVE: Trigger IncrementaPartecipanti aumenta NumIscritti
DELIMITER $
CREATE PROCEDURE TEST_NOVE()
BEGIN
    DECLARE NumPrima INT DEFAULT 0;
    DECLARE NumDopo INT DEFAULT 0;
	
    SELECT NumIscritti FROM INSEGNAMENTO;
    SELECT * FROM PIANOSTUDI;
    # Numero iscritti prima
    SET NumPrima = (SELECT NumIscritti FROM INSEGNAMENTO WHERE Id = 1);

    # Inserimento in piano studi
    CALL InserisciPartecipazione(1, 1);
	SELECT NumIscritti FROM INSEGNAMENTO;
	SELECT * FROM PIANOSTUDI;
    # Numero iscritti dopo
    SET NumDopo = (SELECT NumIscritti FROM INSEGNAMENTO WHERE Id = 1);

    IF (NumDopo = NumPrima + 1) THEN
        CALL AGGIUNGI_LOG(9, 'Trigger IncrementaPartecipanti funziona correttamente (OK)', TRUE);
    ELSE
        CALL AGGIUNGI_LOG(9, 'Trigger IncrementaPartecipanti NON funziona (ERRORE)', FALSE);
        SET @TEST_ERROR_CONDITION = TRUE;
    END IF;

    CALL RIPRISTINA_DB();
    CALL RIEPILOGO_TEST(9);
END $
DELIMITER ;


# Test DIECI: Trigger DecrementaPartecipanti decrementa NumIscritti
DELIMITER $
CREATE PROCEDURE TEST_DIECI()
BEGIN
    DECLARE NumPrima INT DEFAULT 0;
    DECLARE NumDopo INT DEFAULT 0;

    # Preparazione: aggiungo prima una partecipazione
    CALL InserisciPartecipazione(1, 1);

    # Valore prima della cancellazione
    SET NumPrima = (SELECT NumIscritti FROM INSEGNAMENTO WHERE Id = 1);

    # Rimuovo la riga dalla tabella PIANOSTUDI
    DELETE FROM PIANOSTUDI WHERE Matricola = 1 AND IdInsegnamento = 1;

    # Valore dopo → trigger deve decrementare automaticamente
    SET NumDopo = (SELECT NumIscritti FROM INSEGNAMENTO WHERE Id = 1);

    IF (NumDopo = NumPrima - 1) THEN
        CALL AGGIUNGI_LOG(10, 'Trigger DecrementaPartecipanti funziona correttamente (OK)', TRUE);
    ELSE
        CALL AGGIUNGI_LOG(10, 'Trigger DecrementaPartecipanti NON funziona (ERRORE)', FALSE);
        SET @TEST_ERROR_CONDITION = TRUE;
    END IF;

    CALL RIPRISTINA_DB();
    CALL RIEPILOGO_TEST(10);
END $
DELIMITER ;


# Test UNDICI: Trigger IncrementoCFU aggiorna CFU dello studente correttamente
DELIMITER $
CREATE PROCEDURE TEST_UNDICI()
BEGIN
    DECLARE CFUPrima INT DEFAULT 0;
    DECLARE CFUDopo INT DEFAULT 0;
    DECLARE CFUCorso INT DEFAULT 0;

    # Preparazione: lo studente deve avere l'insegnamento nel piano
    CALL InserisciPartecipazione(1, 1);

    # Leggo i CFU prima della verbalizzazione
    SET CFUPrima = (SELECT CFUConseguiti FROM STUDENTE WHERE Matricola = 1);
    SET CFUCorso = (SELECT CFU FROM INSEGNAMENTO WHERE Id = 1);

    # Effettuo una verbalizzazione
    CALL InserisciVerbalizzazione(1, 1, 28);

    # CFU devono aumentare del CFU dell’insegnamento
    SET CFUDopo = (SELECT CFUConseguiti FROM STUDENTE WHERE Matricola = 1);

    IF (CFUDopo = CFUPrima + CFUCorso) THEN
        CALL AGGIUNGI_LOG(11, 'Trigger IncrementoCFU funziona correttamente (OK)', TRUE);
    ELSE
        CALL AGGIUNGI_LOG(11, 'Trigger IncrementoCFU NON funziona correttamente (ERRORE)', FALSE);
        SET @TEST_ERROR_CONDITION = TRUE;
    END IF;

    CALL RIPRISTINA_DB();
    CALL RIEPILOGO_TEST(11);
END $
DELIMITER ;


# Test DODICI: Vista LISTA_STUDENTI_INATTIVI deve elencare solo gli studenti senza piano di studi
DELIMITER $
CREATE PROCEDURE TEST_DODICI()
BEGIN
    DECLARE N INT DEFAULT 0;

    # Inseriamo tre studenti nel piano di studi
    CALL InserisciPartecipazione(1, 1);
    CALL InserisciPartecipazione(2, 1);
    CALL InserisciPartecipazione(3, 1);

    # Ora solo gli studenti 4 e 5 devono essere inattivi → totale 2
    SET N = (SELECT COUNT(*) FROM LISTA_STUDENTI_INATTIVI);

    IF (N = 2) THEN
        CALL AGGIUNGI_LOG(12, 'Vista LISTA_STUDENTI_INATTIVI corretta (OK)', TRUE);
    ELSE
        CALL AGGIUNGI_LOG(12, 'Vista LISTA_STUDENTI_INATTIVI ERRATA', FALSE);
        SET @TEST_ERROR_CONDITION = TRUE;
    END IF;

    CALL RIPRISTINA_DB();
    CALL RIEPILOGO_TEST(12);
END $
DELIMITER ;


# Test TREDICI: Vista LISTA_INSEGNAMENTI_TOP deve restituire l'insegnamento più richiesto
DELIMITER $
CREATE PROCEDURE TEST_TREDICI()
BEGIN
    DECLARE TopID INT DEFAULT 0;
    DECLARE TopNome VARCHAR(30);
	DECLARE curTop CURSOR FOR SELECT Id, Nome FROM LISTA_INSEGNAMENTI_TOP;
	
	-- 3 studenti iscritti all'insegnamento 1
	CALL InserisciPartecipazione(1, 1);
    CALL InserisciPartecipazione(2, 1);
    CALL InserisciPartecipazione(3, 1);

    -- 2 studenti iscritti all'insegnamento 2
    CALL InserisciPartecipazione(4, 2);
    CALL InserisciPartecipazione(5, 2);
    # Lettura dalla vista tramite cursore
    OPEN curTop;
        FETCH curTop INTO TopID, TopNome;
    CLOSE curTop;

    IF (TopID = 1) THEN
        CALL AGGIUNGI_LOG(13, 'Vista LISTA_INSEGNAMENTI_TOP corretta (OK)', TRUE);
    ELSE
        CALL AGGIUNGI_LOG(13, CONCAT('Vista LISTA_INSEGNAMENTI_TOP ERRATA, atteso Id=1 ma trovato Id=', TopID), FALSE);
        SET @TEST_ERROR_CONDITION = TRUE;
    END IF;

    CALL RIPRISTINA_DB();
    CALL RIEPILOGO_TEST(13);
END $
DELIMITER ;

# Test QUATTORDICI: Verifica il corretto funzionamento della vista LISTA_DIP_CON_INFORMATICA
DELIMITER $
CREATE PROCEDURE TEST_QUATTORDICI()
BEGIN
    DECLARE NomeDip VARCHAR(30);
    DECLARE SedeDip VARCHAR(30);

    # Cursor per leggere la vista
    DECLARE myCursor CURSOR FOR (SELECT Nome, Sede FROM LISTA_DIP_CON_INFORMATICA);

    # Nella vista ci deve essere il dipartimento DISI (unico con insegnamenti SSD INF)
    OPEN myCursor;
        FETCH myCursor INTO NomeDip, SedeDip;
    CLOSE myCursor;

    IF (NomeDip = 'DISI') THEN
        CALL AGGIUNGI_LOG(14, 'Vista 4.A, LISTA_DIP_CON_INFORMATICA corretta (OK)', TRUE);
    ELSE
        CALL AGGIUNGI_LOG(14, 'Vista 4.A, LISTA_DIP_CON_INFORMATICA NON corretta (ERRORE)', FALSE);
        SET @TEST_ERROR_CONDITION = TRUE;
    END IF;

    CALL RIEPILOGO_TEST(14);
END $
DELIMITER ;



# Test QUINDICI: Verifica il corretto funzionamento della vista LISTA_AREE_TOP
DELIMITER $
CREATE PROCEDURE TEST_QUINDICI()
BEGIN
    DECLARE SSDTop VARCHAR(30);
	DECLARE myCursor CURSOR FOR (SELECT SSD FROM LISTA_AREE_TOP);

    # Preparazione:
    # Inserisco 3 volte SSD = 'MAT' (insegnamento Id = 3, Ottimizzazione)
    CALL InserisciPartecipazione(1, 3);
    CALL InserisciPartecipazione(2, 3);
    CALL InserisciPartecipazione(3, 3);

    # Inserisco 2 volte SSD = 'INF' (insegnamento Id = 1, Apprendimento automatico)
    CALL InserisciPartecipazione(4, 1);
    CALL InserisciPartecipazione(5, 1);

	# Il risultato deve essere solo 'MAT'
    OPEN myCursor;
        FETCH myCursor INTO SSDTop;
    CLOSE myCursor;

    IF (SSDTop = 'MAT') THEN
        CALL AGGIUNGI_LOG(15, 'Vista 4.B, LISTA_AREE_TOP corretta (OK)', TRUE);
    ELSE
        CALL AGGIUNGI_LOG(15, 'Vista 4.B, LISTA_AREE_TOP NON corretta (ERRORE)', FALSE);
        SET @TEST_ERROR_CONDITION = TRUE;
    END IF;

    CALL RIPRISTINA_DB();
    CALL RIEPILOGO_TEST(15);
END $
DELIMITER ;

# --------------------------------------------------------------------
# Esecuzione sequenziale dei test
TRUNCATE LOG;
CALL RIPRISTINA_DB();

# TEST PROCEDURE E TRIGGER E VISTE
CALL TEST_UNO();          -- Popolamento tabelle
CALL TEST_DUE();          -- InserisciPartecipazione: matricola inesistente
CALL TEST_TRE();          -- InserisciPartecipazione: insegnamento inesistente
CALL TEST_QUATTRO();      -- InserisciPartecipazione: corso ATTIVO/NONATTIVO
CALL TEST_CINQUE();       -- InserisciVerbalizzazione: caso non valido
CALL TEST_SEI();          -- InserisciVerbalizzazione: caso valido
CALL TEST_SETTE();        -- CancellaStorico
CALL TEST_OTTO();         -- RimuoviStudente (cascade)
CALL TEST_NOVE();         -- Trigger IncrementaPartecipanti
CALL TEST_DIECI();        -- Trigger DecrementaPartecipanti
CALL TEST_UNDICI();       -- Trigger IncrementoCFU
CALL TEST_DODICI();       -- Vista LISTA_STUDENTI_INATTIVI
CALL TEST_TREDICI();      -- Vista LISTA_INSEGNAMENTI_TOP
CALL TEST_QUATTORDICI();  -- Vista LISTA_DIP_CON_INFORMATICA
CALL TEST_QUINDICI();     -- Vista LISTA_AREE_TOP


# Stampa il risultato finale del test
CALL STAMPA_LOG();

# Ripristina DB allo stato iniziale
CALL RIPRISTINA_DB();

# --------------------------------------------------------------------
# RIMUOVE LE PROCEDURE DI TEST E LA TABELLA LOG
DROP TABLE LOG;
DROP PROCEDURE IF EXISTS TEST_UNO;
DROP PROCEDURE IF EXISTS TEST_DUE;
DROP PROCEDURE IF EXISTS TEST_TRE;
DROP PROCEDURE IF EXISTS TEST_QUATTRO;
DROP PROCEDURE IF EXISTS TEST_CINQUE;
DROP PROCEDURE IF EXISTS TEST_SEI;
DROP PROCEDURE IF EXISTS TEST_SETTE;
DROP PROCEDURE IF EXISTS TEST_OTTO;
DROP PROCEDURE IF EXISTS TEST_NOVE;
DROP PROCEDURE IF EXISTS TEST_DIECI;
DROP PROCEDURE IF EXISTS TEST_UNDICI;
DROP PROCEDURE IF EXISTS TEST_DODICI;
DROP PROCEDURE IF EXISTS TEST_TREDICI;
DROP PROCEDURE IF EXISTS TEST_QUATTORDICI;
DROP PROCEDURE IF EXISTS TEST_QUINDICI;
DROP PROCEDURE IF EXISTS AGGIUNGI_LOG;
DROP PROCEDURE IF EXISTS STAMPA_LOG;
DROP PROCEDURE IF EXISTS RIEPILOGO_TEST;
DROP PROCEDURE IF EXISTS RIPRISTINA_DB;


