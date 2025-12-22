conn = new Mongo();
db = conn.getDB("Calcio2");

//Create collection
db.createCollection("Squadre");

db.Squadre.insert({"nome":"Milan", "sede":"Milano","giocatori":[{"nome":"Zlatan", "cognome":"Ibrahimovic"}]});
db.Squadre.insert({"nome":"Juventus", "anno":1896,"giocatori":[{"nome":"Cristiano", "cognome":"Ronaldo"},{"nome":"Paolo","cognome":"Dybala"}]});


cursore=db.Squadre.find({});
while (cursore.hasNext()) {
	printjson(cursore.next());
}
