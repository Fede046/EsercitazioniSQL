conn = new Mongo();
db = conn.getDB("Calcio");

cont=0;
while (cont < 100) {
	if (cont % 2 == 0) {
		print(cont+" è pari");
	} else {
	 	print(cont+" è dispari"); 
	}
	cont++;
}

