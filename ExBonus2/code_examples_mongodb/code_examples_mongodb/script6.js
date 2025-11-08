// Connect to DB
conn = new Mongo();
db = conn.getDB("Calcio");

cursore=db.Squadre.aggregate([
 	{$match:{"nome":"Juventus"}},
	{$project:{"_id":1}} 
	 ])

while (cursore.hasNext()) {
        printjson (cursore.next());
}
