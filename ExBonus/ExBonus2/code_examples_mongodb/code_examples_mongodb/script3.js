conn = new Mongo();
db = conn.getDB("Calcio");

//Create collection
db.createCollection("Calciatori");
db.Calciatori.insert({"nome":"Cristiano", "cognome":"Ronaldo", "squadra":"Juventus"});
db.Calciatori.insert({"nome":"Paolo", "cognome":"Dybala", "squadra":"Juventus"});
db.Calciatori.insert({"nome":"Zlatan", "cognome":"Ibrahimovic", "squadra":"Milan", "eta":39});


cursore=db.Calciatori.find({"cognome": "Ronaldo"});
nomeSquadra=cursore.next()["squadra"];

cursore2=db.Squadre.find({"nome": nomeSquadra});
while (cursore2.hasNext()) {
	printjson(cursore2.next());
}
