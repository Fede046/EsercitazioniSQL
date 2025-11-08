//L'esercizio è stato svolto:
//Inserendo	tutto	il	codice	nel	file	consegna2.js e	caricando	il	file	attraverso	
//l’interfaccia	del	tool	Studio	3T	(File -> Open -> Run)	

conn = new Mongo();
db = conn.getDB("unibo");
db.dropDatabase();

/*----------------------------------------*/

// Creazione collezioni
db.createCollection("Studenti");
db.createCollection("CorsiDiLaurea");
db.createCollection("Insegnamenti");

/*----------------------------------------*/

// Inserimento STUDENTI (Tabella 1)
db.Studenti.insert({matricola: "S0001", nome: "Mario", cognome: "Rossi", anno: 2023});
db.Studenti.insert({matricola: "S0002", nome: "Monica", cognome: "Verdi", anno: 2022});
db.Studenti.insert({matricola: "S0003", nome: "Sara", cognome: "Bianchi", anno: 2024, email:"sara.bianchi@studio.unibo.it" , telefono: "0513424"});
db.Studenti.insert({matricola: "S0004", nome: "Luca", cognome: "Neri", anno: 2021, email: ["luca.neri@yahoo.it", "lucan@gmail.com"],telefono:"0513321"});
db.Studenti.insert({matricola: "S0005", nome: "Giulia", cognome: "De Santis", anno: 2024, email: "giulia.ds@gmail.com"});
db.Studenti.insert({matricola: "S0006", nome: "Marco", cognome: "Conti", anno: 2023, telefono: "051212", email: "marco.conti@studio.unibo.it"});
db.Studenti.insert({matricola: "S0007", nome: "Chiara", cognome: "Viola"});
db.Studenti.insert({matricola: "S0008", nome: "Paolo", cognome: "Rinaldi", anno: 2023, telefono: "0513134"});

// Inserimento CORSI DI LAUREA (Tabella 2)
db.CorsiDiLaurea.insert({codice: "INF-L", nome: "Informatica", tipo: "Triennale", sede: "Bologna", numeroCurricula: 1});
db.CorsiDiLaurea.insert({codice: "ING-M", nome: "Ingegneria Informatica", tipo: "Magistrale", sede: "Bologna", numeroCurricula: 1});
db.CorsiDiLaurea.insert({codice: "ECO-L", nome: "Economia e Commercio", sede: "Forlì"});
db.CorsiDiLaurea.insert({codice: "MAT-L", nome: "Matematica", tipo: "Triennale", sede: "Cesena"});
db.CorsiDiLaurea.insert({codice: "LING-L", nome: "Lingue e Letterature Straniere", tipo: "Triennale", numeroCurricula: 3});
db.CorsiDiLaurea.insert({codice: "PSY-M", nome: "Psicologia Cognitiva Applicata", tipo: "Magistrale", sede: "Cesena"});
db.CorsiDiLaurea.insert({codice: "BIO-L", nome: "Scienze Biologiche", tipo: "Triennale", sede: "Bologna", numeroCurricula: 5});

// Inserimento INSEGNAMENTI (Tabella 3)
db.Insegnamenti.insert({codiceInsegnamento: "C1", titolo: "Programmazione", cfu: 12, ssd: "INF/01", corsoDiLaurea: "INF-L", categoria: "Obbligatorio"});
db.Insegnamenti.insert({codiceInsegnamento: "C2", titolo: "Basi di Dati", cfu: 9, ssd: "INF/01", corsoDiLaurea: "INF-L"});
db.Insegnamenti.insert({codiceInsegnamento: "C3", titolo: "Sistemi Embedded", cfu: 6, corsoDiLaurea: "ING-M", categoria: "Obbligatorio"});
db.Insegnamenti.insert({codiceInsegnamento: "C4", titolo: "Economia Politica", cfu: 9, ssd: "SECS-P/01", corsoDiLaurea: "ECO-L"});
db.Insegnamenti.insert({codiceInsegnamento: "C5", titolo: "Analisi Matematica", cfu: 9, ssd: "MAT/01", corsoDiLaurea: "MAT-L", categoria: "Obbligatorio"});
db.Insegnamenti.insert({codiceInsegnamento: "C6", titolo: "Letteratura Inglese", cfu: 6, corsoDiLaurea: "LING-L", categoria: "Opzionale"});
db.Insegnamenti.insert({codiceInsegnamento: "C7", titolo: "Psicologia", cfu: 6, corsoDiLaurea: "PSY-M", categoria: "Obbligatorio"});
db.Insegnamenti.insert({codiceInsegnamento: "C8", titolo: "C1 Spagnolo", corsoDiLaurea: "LING-L", categoria: "Idoneità"});
db.Insegnamenti.insert({codiceInsegnamento: "C9", titolo: "Chimica dei Polimeri", ssd: "CHIM/05", corsoDiLaurea: "CHI-M"});
db.Insegnamenti.insert({codiceInsegnamento: "C10", titolo: "B2 Inglese", corsoDiLaurea: "INF-L", categoria: "Idoneità"});
db.Insegnamenti.insert({codiceInsegnamento: "C11", titolo: "Algebra", ssd: "MAT/01", corsoDiLaurea: "INF-L", categoria: "Obbligatorio"});

/*----------------------------------------*/

//PUNTO 1 
cont1 = db.CorsiDiLaurea.count();
print("[PUNTO 1] Numero di corsi di laurea presenti: " + cont1);

/*----------------------------------------*/

//PUNTO 2 
cont2 = db.CorsiDiLaurea.count({tipo: "Magistrale", sede: "Bologna"});
print("[PUNTO 2] Numero corsi di laurea di tipo Magistrale a Bologna: " + cont2);

/*----------------------------------------*/


//PUNTO 3
cont3 = db.CorsiDiLaurea.count({numeroCurricula: {$gte: 3}});
print("[PUNTO 3] Numero di corsi di laurea con almeno 3 curricula: " + cont3);

/*----------------------------------------*/

//PUNTO 4
cont4 = db.Insegnamenti.count({$or: [{ssd: "INF/01"}, {corsoDiLaurea: "INF-L"}]});
print("[PUNTO 4] Numero di insegnamenti settore INF/01 oppure del CdL Informatica: " + cont4);

/*----------------------------------------*/

//PUNTO 5
db.Insegnamenti.remove({categoria: "Idoneità"});
cont5 = db.Insegnamenti.count();
print("[PUNTO 5] Numero di insegnamenti presenti dopo filtraggio: " + cont5);

/*----------------------------------------*/

//PUNTO 6
db.Studenti.update({matricola: "S0001"}, {$set: {email: "mario.rossi@gmail.com", telefono: "3451211221"}});
cursore6 = db.Studenti.find({matricola: "S0001"});
while (cursore6.hasNext()) {
    printjson(cursore6.next());
}
/*----------------------------------------*/

//PUNTO 7
db.createCollection("PianiStudio");
db.PianiStudio.insert({matricola: "S0001", cdl: "INF-L", insegnamenti: [{codice: "C1", voto: 28}, {codice: "C5", voto: 30}, {codice: "C2", voto: 26}, {codice: "C11", voto: 29}]});
db.PianiStudio.insert({matricola: "S0002", cdl: "ING-M", insegnamenti: [{codice: "C3", voto: 27}]});
db.PianiStudio.insert({matricola: "S0003", cdl: "INF-L", insegnamenti: [{codice: "C6", voto: 24}, {codice: "C7", voto: "30L"}]});
db.PianiStudio.insert({matricola: "S0004", cdl: "MAT-L", insegnamenti: [{codice: "C1", voto: 26}, {codice: "C3", voto: 18}]});
db.PianiStudio.insert({matricola: "S0005", cdl: "CHI-M", insegnamenti: [{codice: "C4", voto: 20}, {codice: "C6", voto: 25}]});
db.PianiStudio.insert({matricola: "S0006", cdl: "INF-L", insegnamenti: [{codice: "C4", voto: 18}]});
db.PianiStudio.insert({matricola: "S0007", cdl: "LING-L", insegnamenti: [{codice: "C2", voto: 21}, {codice: "C6", voto: 22}]});
db.PianiStudio.insert({matricola: "S0008", cdl: "INF-L", insegnamenti: [{codice: "C3", voto: 30}, {codice: "C9", voto: 23}]});

/*----------------------------------------*/

//PUNTO 8
cont8 = 0;
piano = db.PianiStudio.findOne({matricola: "S0001"});
if (piano) {
    listaInsegnamenti = piano.insegnamenti;
    for (i = 0; i < listaInsegnamenti.length; i++) {
        codiceIns = listaInsegnamenti[i].codice;
        ins = db.Insegnamenti.findOne({codiceInsegnamento: codiceIns});
        if (ins && ins.ssd === "MAT/01") {
            cont8++;
        }
    }
}
print("[PUNTO 9] Numero di insegnamenti con SSD MAT/01 nel piano di S0001: " + cont8);

/*----------------------------------------*/

//PUNTO 10

//faccio rifermeinto soltanto alla tabella piano di studi 
//in particolare riferimento al campo cdl

var statisticheCdL = {};

var cursore = db.PianiStudio.find({});
while (cursore.hasNext()) {
    piano = cursore.next();
    codiceCdL = piano.cdl;
    

    if (!statisticheCdL[codiceCdL]) {
        statisticheCdL[codiceCdL] = {
            sommaVoti: 0,
            conteggioVoti: 0
        };
    }
    
    listaIns = piano.insegnamenti;
    for (j = 0; j < listaIns.length; j++) {
        voto = listaIns[j].voto;
        if (typeof voto === "number") {
            statisticheCdL[codiceCdL].sommaVoti += voto;
            statisticheCdL[codiceCdL].conteggioVoti++;
        } else if (voto === "30L") {
            statisticheCdL[codiceCdL].sommaVoti += 30;
            statisticheCdL[codiceCdL].conteggioVoti++;
        }
    }
}


for (var cdl in statisticheCdL) {
    if (statisticheCdL[cdl].conteggioVoti > 0) {
        media = statisticheCdL[cdl].sommaVoti / statisticheCdL[cdl].conteggioVoti;
        print("[PUNTO 10] CdL: " + cdl + ", Media voto esami: " + media.toFixed(2));
    }
}