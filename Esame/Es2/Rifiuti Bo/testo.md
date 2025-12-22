ESERCIZIO	2	(12	punti)	
Si	vuole	progettare	una	base	di	dati	a	supporto	di	un	sistema	intelligente	di	raccolta	e	
gestione	dei	rifiuti	urbani	della	città	di	Bologna.	La	città	è	suddivisa	in	quartieri,	
ognuno	con	un	nome	(“Navile”),	un’estensione	ed	un	campo	#numcontenitori	
(ridondanza	concettuale,	vedi	sotto).		Il	sistema	di	raccolta	dei	rifiuti	è	formato	da	un	
insieme	di	contenitori	(“cassonetti”):	ogni	contenitore	dispone	di	un	codice	univoco,	
una	latitudine,	una	longitudine,	una	capacità	massima,	ed	è	dislocato	in	un	solo	
quartiere.	Si	considerano	due	sotto-tipologie	di	contenitori:	contenitori	per	
l’indifferenziato	e	contenitori	per	l’umido.	I	primi	dispongono	dei	seguenti	campi:	
larghezza,	lunghezza	ed	altezza.	I	secondi	hanno	una	data	e	nome	del	modello.	
Esistono	contenitori	che	non	ricadono	in	alcuna	delle	tipologie	sovra-elencate.	
Inoltre,	alcuni	contenitori	dispongono	di	un	sensore	che	misura	la	temperatura	
esterna	ed	il	livello	di	riempimento	del	contenitore	stesso:	ogni	sensore	ha	un	id	
univoco	ed	una	descrizione.	Si	vuole	tenere	traccia	dei	dati	(temperatura	ed	
%riempimento)	prodotti	dal	sensore	nel	tempo.	Inoltre,	si	vogliono	gestire	i	dati	degli	
utenti	residenti.	Ogni	utente	dispone	di	codice	fiscale,	nome,	cognome,	anno	di	
nascita,	e	risiede	in	uno	specifico	quartiere	di	Bologna.	Alcuni	utenti	(ma	non	tutti,	in	
quanto	si	assume	che	il	servizio	sia	ancora	in	fase	di	sperimentazione),	dispongono	di	
una	tessera,	con	id	e	data	di	rilascio,	per	la	raccolta	dell’indifferenziato.	I	contenitori	
dell’indifferenziato	sono	utilizzabili	solo	mediante	la	tessera:	si	vuole	tenere	traccia	
degli	eventi	di	apertura	del	contenitore	da	parte	di	un	utente.		Infine,	il	sistema	è	
composto	da	una	flotta	di	veicoli	che	si	occupano	della	raccolta	dei	rifiuti.	Ogni	veicolo	
dispone	di	una	targa,	un	nome	del	modello,	una	o	più	foto,	uno	stato	(fermo/in	
servizio).	Si	vuole	tenere	traccia	del	tragitto	operato	da	ogni	veicolo:	un	tragitto	ha	un	
orario	di	inizio,	un	orario	di	fine,	e	consiste	in	un	elenco	di	contenitori	da	visitare,	in	
uno	specifico	ordine.	In	caso	di	riempimento	oltre	una	certa	soglia,	il	sensore	di	un	
contenitore	invierà	una	notifica	di	allarme.	Una	notifica	dispone	di	una	data,	un	testo,	
ed	è	raccolta	-al	massimo-	da	un	solo	veicolo.	E’	possibile	che	la	notifica	non	sia	
raccolta/gestita	da	alcun	veicolo.	

a)	(6pt)	Costruire	il	modello	Entità-Relazione	(E-R)	della	base	di	dati.	

b)	(4pt)	Tradurre	il	modello	E-R	nel	modello	logico	relazionale,	preferendo	(NELLA	
TRADUZIONE	DI	EVENTUALI	GENERALIZZAZIONI,	E	SOLO	IN	QUESTE)	la	soluzione	
che	minimizzi	il	numero	di	valori	NULL.	Indicare	i	vincoli	di	integrità	
referenziale	tra	gli	attributi	dello	schema.	

c)	(2pt)	Indicare	se	la	ridondanza	concettuale	#numcontenitori	debba	essere	
mantenuta	o	eliminata,	sulla	base	delle	seguenti	operazioni	sui	dati:	
Ø Contare	il	numero	di	contenitori	presenti	in	uno	specifico	quartiere	(Batch,	1	
volta/mese).	
Ø Aggiungere	un	contenitore	ad	un	quartiere	(Batch,	1	volta/mese).	
Ø Dato	uno	specifico	veicolo,	contare	il	numero	di	contenitori	visitati	durante	un	
tragitto	(Interattiva,	10	volte/mese).	
Tabella	dei	volumi.	6	contenitori	per	quartiere,	10	contenitori	per	tragitto,	wI	(peso	
operazioni	interattive)=1,	wB	(peso	operazioni	batch)=0.5,	alpha	=	2.	