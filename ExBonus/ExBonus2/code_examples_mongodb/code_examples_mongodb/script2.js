conn = new Mongo();
db = conn.getDB("Calcio");

cont=db.Squadre.count();
print("Numero Squadre "+cont);

// Print the collection data
cursore=db.Squadre.find({});
while (cursore.hasNext()) {
        printjson (cursore.next());
}
