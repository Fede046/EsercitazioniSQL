//Esempio di modellazione: gestione delle info dei circoli tennis (elenco circoli + elenco soci)
//Soluzione 1: Utilizzo di due collezioni (vedere model2.js per una soluzione alternativa) 

connection=new Mongo()
db=connection.getDB("tennis");
db.createCollection("circoli");
db.createCollection("soci");


//Rimuove dalla collezione tutti i circoli presenti
db.circoli.remove({});

//Rimuove dalla collezione tutti i soci presenti
db.soci.remove({});

//Inserimento di due circoli
db.circoli.insert({nome:"Nettuno", indirizzo: "Via Massarenti", telefono:"051223355"});
db.circoli.insert({nome:"TennisBO", numeroIscritti: 15, indirizzo: "Via Zanardi", proprietario:{nome:"Mario", cognome: "Rossi"}});

//Inserimento di due soci
db.soci.insert({nome:"Michele", cognome:"Bianchi", anni:25, nomeCircolo:"Nettuno"});
db.soci.insert({nome:"Sara", cognome:"Verdi", professione:"studente", nomeCircolo:"Nettuno"});

//Query: Per ogni socio, mostro Nome, Cognome, ed Indirizzo del Circolo Tennis cui sono iscritti
//Join manuale: scorro tutti i soci presenti
cursor=db.soci.find({});
while (cursor.hasNext()) {
	socioAttuale=cursor.next()
	//Scorro tutti i circoli presenti
	cursor2=db.circoli.find({});
	while (cursor2.hasNext()) {
		circoloAttuale=cursor2.next()
		//Controllo della condizione di JOIN
		if (circoloAttuale["nome"]==socioAttuale["nomeCircolo"]) {
			print("Nome socio: "+socioAttuale["nome"]+" | Cognome socio: "+socioAttuale["cognome"]+" | Indirizzo circolo: "+circoloAttuale["indirizzo"]);
		}
	}
}
