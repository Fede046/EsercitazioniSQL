//Esempio di modellazione: gestione delle info dei circoli tennis (elenco circoli + elenco soci)
//Soluzione 2: Utilizzo una sola collezione (vedere model2.js per una soluzione alternativa) 

connection=new Mongo()
db=connection.getDB("tennis");
db.createCollection("circoli");


//Rimuove dalla collezione tutti i circoli presenti
db.circoli.remove({});


//Inserimento di due circoli (si sfrutta il fatto che i documenti MongoDB non devono rispettare la Prima Forma Normale)
db.circoli.insert({nome:"Nettuno", indirizzo: "Via Massarenti", telefono:"051223355",
		  listaSoci: [{nome:"Michele", cognome:"Bianchi", anni:25}, 
			      {nome:"Sara", cognome:"Verdi", professione:"studente"}]});
db.circoli.insert({nome:"TennisBO", numeroIscritti: 15, proprietario:{nome:"Mario", cognome: "Rossi"}});


//Query: Per ogni socio, mostro Nome, Cognome, ed Indirizzo del Circolo Tennis cui sono iscritti
//Seleziono tutti i circoli per i quali esista il campo "listaSoci"
cursore=db.circoli.find({ listaSoci: { $exists: true}});
while (cursore.hasNext()) {
	circoloAttuale=cursore.next();
	indirizzo=circoloAttuale["indirizzo"];
	listaSoci=circoloAttuale["listaSoci"];
	for (i=0; i<listaSoci.length; i++) 
		print("Nome socio: "+listaSoci[i]["nome"]+" | Cognome socio: "+listaSoci[i]["cognome"]+" | Indirizzo circolo: "+indirizzo);
		
}
