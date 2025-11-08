//Esempio di utilizzo delle operazioni CRUD (Create, Read, Update, Delete)
connection=new Mongo()
db=connection.getDB("tennis");
db.createCollection("circoli");

//Rimuove dalla collezione tutti i circoli presenti
db.circoli.remove({});

//Inserisce un nuovo documento con due campi
print("[DEBUG] Inserimento di un documento 1/2");
db.circoli.insert({nome:"Nettuno", indirizzo: "Via Massarenti", telefono:"051223355"});

//Inserisce un nuovo documento con tre campi
print("[DEBUG] Inserimento di un documento 2/2");
db.circoli.insert({nome:"TennisBO", numeroIscritti: 15, proprietario:{nome:"Mario", cognome: "Rossi"}});

//Aggiorna un documento inserendo una nuova coppia chiave/valore
db.circoli.update({nome:"Nettuno"},{$set:{cap:"40126"}});

//Visualizza tutti i documenti presenti nel DB
print("[DEBUG] Stampa tutti i documenti presenti:");
cursore=db.circoli.find({});
while (cursore.hasNext()) 
	printjson(cursore.next());

//Cerca solo i circoli con più di 10 iscritti; di essi, stampa solo il nome
cursore=db.circoli.find({numeroIscritti:{$gt:10}});
while (cursore.hasNext()) {
	nome=cursore.next()["nome"];
	print("[DEBUG] Nome circolo con più di 10 iscritti: "+nome);
} 
