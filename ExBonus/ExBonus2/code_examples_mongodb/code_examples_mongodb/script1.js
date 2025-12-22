// Connect to DB
conn = new Mongo();
db = conn.getDB("Calcio");
db.dropDatabase();
// Create collection
db.createCollection("Squadre");
// Insert into collection
db.Squadre.insert({"nome":"Juventus", "annoFondazione":1896});
db.Squadre.insert({"nome":"Milan", "annoFondazione":1899});
db.Squadre.insert({"nome":"Inter", "sede":"Milano"});
