//Esempio di utilizzo dell'operatore AGGREGATE per operazioni di ricerca sui dati 
connection=new Mongo()
db=connection.getDB("olimpiadi");
db.createCollection("atleti");

db.atleti.remove({});

db.atleti.insert({nome:"Mario", cognome:"Bianchi", specialita:"Maratona", anni: 30});
db.atleti.insert({nome:"Maria", cognome:"Verdi", specialita:"Maratona", anni: 23, provenienza:"Roma"});
db.atleti.insert({nome:"Antonio", cognome:"Neri", specialita:"Salto in lungo", anni: 22, provenienza:"Bologna"});
db.atleti.insert({nome:"Sara", cognome:"Rossi", specialita:"Salto in alto", anni: 26, provenienza:"Milano"});
db.atleti.insert({nome:"Claudio", cognome:"Rosa", specialita:"Maratona", anni: 28, provenienza:"Roma"});
db.atleti.insert({nome:"Giovanna", cognome:"Arancio", anni: 22, provenienza:"Napoli"});


//Esempio 1: Seleziono solo gli atleti che provengono da Roma 
cursor=db.atleti.aggregate([{$match:{provenienza:"Roma"}}]);
while (cursor.hasNext())
	printjson(cursor.next());
print("-------------------");


//Esempio 2: Seleziono solo gli atleti che provengono da Roma, e di essi prelevo solo nome e cognome 
cursor=db.atleti.aggregate([{$match:{provenienza:"Roma"}},{$project:{nome:1,cognome:1}}]);
while (cursor.hasNext())
	printjson(cursor.next());
print("-------------------");



//Esempio 3: Raggruppo gli atleti in base alla specialita
cursor=db.atleti.aggregate([{$group:{_id:"$specialita"}}]);
while (cursor.hasNext())
	printjson(cursor.next());
print("-------------------");



//Esempio 3: Raggruppo gli atleti in base alla specialita, e li conto
cursor=db.atleti.aggregate([{$group:{_id:"$specialita",totale:{$sum:1}}}]);
while (cursor.hasNext())
	printjson(cursor.next());
print("-------------------");



//Esempio 4: Raggruppo gli atleti in base alla specialita, li conto, e filtro solo la specialita con almeno 2 praticanti
cursor=db.atleti.aggregate([{$group:{_id:"$specialita",totale:{$sum:1}}},{$match:{totale:{$gte:2}}}]);
while (cursor.hasNext())
	printjson(cursor.next());
print("-------------------");




