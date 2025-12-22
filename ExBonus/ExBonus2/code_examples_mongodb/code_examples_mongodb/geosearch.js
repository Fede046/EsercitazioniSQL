
//Esempio di utilizzo dell'operatore NEAR per operazioni di ricerca su documenti GEO-JSON 
connection=new Mongo()
db=connection.getDB("datiBO");
db.createCollection("pizzerie");

//Elimina eventuali documenti già presenti 
db.pizzerie.remove({});

//Inserisce un documento
db.pizzerie.insert( { 
      nome: "Il Sellaio",
      indirizzo: "Via S. Donato 31",
      posizione : { type: "Point", coordinates: [44.499896, 11.359857]}
});

//Inserisce un documento
db.pizzerie.insert( { 
      nome: "La brace",
      indirizzo: "Via S. Vitale 14",
      posizione : { type: "Point", coordinates: [44.494633, 11.349320]}
});

//Crea un indice
db.pizzerie.ensureIndex( { posizione: "2dsphere" } );

//Cerca le pizzerie nel raggio di 500 metri da una posizione fissata (dipartimento)
cursor=db.pizzerie.find( { posizione :  { $near :
                          		 { $geometry :
                              		 	{ type : "Point" , coordinates : [44.497095, 11.356001] } ,
                              		    	  $maxDistance : 2000 
					 } 
				  } 
		   } );

print("Elenco pizzerie nel raggio di 2Km dal dipartimento:"); 
//Stampa le pizzerie
while(cursor.hasNext()) {
	printjson(cursor.next());
}
