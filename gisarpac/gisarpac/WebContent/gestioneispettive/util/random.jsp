<script>

function rispondiCaso() {

	var nomi = ["RITA", "PAOLO", "STEFANO", "ALESSANDRO", "UOLTER", "ANTONIO", "CARMELA", "VIVIANA", "VALENTINO", "GIUSEPPE", "SIMONE", "MIRKO"];
	 var cognomi = ["VERDI", "GIALLI", "ARANCIONI", "AZZURRI", "LOVER", "RUSSO", "ROSSI", "BIANCHI", "NERI", "BORDEAUX", "ESPOSITO", "DALLE MARCHE", "BARILE"];
	var qualita = ["RESPONSABILE", "OSSERVATORE", "INCARICATO", "DIRIGENTE", "TECNICO", "AMMINISTRATORE"];
	var termini = ["ABC", "DEF", "GHI", "TEST", "PROVA", "XYZ", "LOREM", "IPSUM", "QUANTUM", "CHECK", "EXT", "ESEMPIO", "BNS", "CHECKLIST", "SPECIE", "QWERTY", "DOLOR", "SIT", "AMET", "CONSECTETUR", "ELIT", "DIAM", "QUIS", "TAVOLO", "SEDIA", "BOTTIGLIA", "SPINA", "QUADERNO", "LIBRO", "TAPPO", "MOBILE", "SCHERMO", "PORTA", "FINESTRA", "PAVIMENTO", "MATTONELLA", "LAVAGNA"];
	var tipo = ["PRATICO", "UNICO", "RIPETUTO"];

	
    var coordinateX = ["6.9", "7.0", "7.1", "7.2", "7.3", "7.4", "7.5", "7.6", "7.7", "7.8"];
    var coordinateY = ["45.5", "45.6", "45.7", "45.8"];
    
    var inputs = document.getElementsByTagName('input');
    var inputNamePrecedente = "";

    for (i = 0; i < inputs.length; i++) {
        if (!inputs[i].readOnly) {
        	if (inputs[i].type == 'radio' || inputs[i].type == 'checkbox') {
                var random = Math.floor(Math.random() * 11);
                if (random > 5 || inputNamePrecedente != inputs[i].name)
                    inputs[i].click();
            } else if (inputs[i].type == 'text') {
                if ($(inputs[i]).attr("onkeyup") == 'filtraInteri(this)') {
                    inputs[i].value = Math.floor((Math.random() * termini.length - 1) + 1) + '' + Math.floor((Math.random() * termini.length - 1) + 1) + '' + Math.floor((Math.random() * termini.length - 1) + 1);
                }
                else if ($(inputs[i]).attr("onkeyup") == 'validaCoordinateFormato(this)') {
                    
                	if (inputs[i].name.includes("X"))
                		inputs[i].value = VERTICE_NORDOVEST_X;//+ Math.floor(Math.random() * 100001);
                	else if (inputs[i].name.includes("Y"))
            			inputs[i].value = VERTICE_NORDOVEST_Y;// + Math.floor(Math.random() * 100001);
                }
                else {
                	if (inputs[i].placeholder.toUpperCase().includes("NOMINATIV"))
                		inputs[i].value = nomi[Math.floor((Math.random() * nomi.length - 1) + 1)] + " " + cognomi[Math.floor((Math.random() * cognomi.length - 1) + 1)];
                	else if (inputs[i].placeholder.toUpperCase()=="NOME"){
            			inputs[i].innerHTML = nomi[Math.floor((Math.random() * nomi.length - 1) + 1)];
            			inputs[i].value = nomi[Math.floor((Math.random() * nomi.length - 1) + 1)];
            		}
            	    else if (inputs[i].placeholder.toUpperCase()=="COGNOME"){
            			inputs[i].innerHTML = cognomi[Math.floor((Math.random() * cognomi.length - 1) + 1)];
            			inputs[i].value = cognomi[Math.floor((Math.random() * cognomi.length - 1) + 1)];
            		} 
            	    else if (inputs[i].placeholder.toUpperCase().includes("QUALIT"))
                		inputs[i].value = qualita[Math.floor((Math.random() * qualita.length - 1) + 1)];
                	else if (inputs[i].placeholder.toUpperCase().includes("TIPO"))
                		inputs[i].value = tipo[Math.floor((Math.random() * tipo.length - 1) + 1)];
                	else if (inputs[i].placeholder.toUpperCase().includes("NOTE"))
                    	inputs[i].value = termini[Math.floor((Math.random() * termini.length - 1) + 1)] + " " + termini[Math.floor((Math.random() * termini.length - 1) + 1)] + " " + termini[Math.floor((Math.random() * termini.length - 1) + 1)] + " " + termini[Math.floor((Math.random() * termini.length - 1) + 1)] + " " + termini[Math.floor((Math.random() * termini.length - 1) + 1)] + " " + termini[Math.floor((Math.random() * termini.length - 1) + 1)] + " " + termini[Math.floor((Math.random() * termini.length - 1) + 1)] + " " + termini[Math.floor((Math.random() * termini.length - 1) + 1)] + " " + termini[Math.floor((Math.random() * termini.length - 1) + 1)] + " " + termini[Math.floor((Math.random() * termini.length - 1) + 1)];
                	else
                    	inputs[i].value = termini[Math.floor((Math.random() * termini.length - 1) + 1)] + " " + termini[Math.floor((Math.random() * termini.length - 1) + 1)];
                }
            } else if (inputs[i].type == 'number') {
                var random1 = Math.floor(Math.random() * 11);
                var random2 = Math.floor(Math.random() * 11);

                if ($(inputs[i]).attr("step") == '.01')
                    inputs[i].value = random1 + '.' + random2;
                else
                    inputs[i].value = random1;
            } else if (inputs[i].type == 'date') {

                var date = new Date();
                var currentDate = date.toISOString().slice(0, 10);
                inputs[i].value = currentDate;
            } else if (inputs[i].type == 'time') {

                var date = new Date();
                var currentTime = date.toISOString().slice(11, 16);
                inputs[i].value = currentTime;
            }

            inputNamePrecedente = inputs[i].name;
        }
    }
    
    inputs = document.getElementsByTagName("textarea");
    for(var i = 0; i < inputs.length; i++){
    	if (inputs[i].id.includes("json")){
    		
    	} else if (inputs[i].placeholder.toUpperCase().includes("NOMINATIV")){
    		inputs[i].innerHTML = nomi[Math.floor((Math.random() * nomi.length - 1) + 1)] + " " + cognomi[Math.floor((Math.random() * cognomi.length - 1) + 1)];
    		inputs[i].value = nomi[Math.floor((Math.random() * nomi.length - 1) + 1)] + " " + cognomi[Math.floor((Math.random() * cognomi.length - 1) + 1)];
    	}
	    else if (inputs[i].placeholder.toUpperCase()=="NOME"){
			inputs[i].innerHTML = nomi[Math.floor((Math.random() * nomi.length - 1) + 1)];
			inputs[i].value = nomi[Math.floor((Math.random() * nomi.length - 1) + 1)];
		}
	    else if (inputs[i].placeholder.toUpperCase()=="COGNOME"){
			inputs[i].innerHTML = cognomi[Math.floor((Math.random() * cognomi.length - 1) + 1)];
			inputs[i].value = cognomi[Math.floor((Math.random() * cognomi.length - 1) + 1)];
		}
    	else if (inputs[i].placeholder.toUpperCase().includes("QUALIT")){
    		inputs[i].innerHTML = qualita[Math.floor((Math.random() * qualita.length - 1) + 1)];
    		inputs[i].value = qualita[Math.floor((Math.random() * qualita.length - 1) + 1)];
    	}
    	else if (inputs[i].placeholder.toUpperCase().includes("TIPO")){
    		inputs[i].innerHTML = tipo[Math.floor((Math.random() * tipo.length - 1) + 1)];
    		inputs[i].value = tipo[Math.floor((Math.random() * tipo.length - 1) + 1)];
    	}
    	else if (inputs[i].placeholder.toUpperCase().includes("NOTE")){
    		inputs[i].innerHTML = termini[Math.floor((Math.random() * termini.length - 1) + 1)] + " " + termini[Math.floor((Math.random() * termini.length - 1) + 1)] + termini[Math.floor((Math.random() * termini.length - 1) + 1)] + " " + termini[Math.floor((Math.random() * termini.length - 1) + 1)] + termini[Math.floor((Math.random() * termini.length - 1) + 1)] + " " + termini[Math.floor((Math.random() * termini.length - 1) + 1)] + termini[Math.floor((Math.random() * termini.length - 1) + 1)] + " " + termini[Math.floor((Math.random() * termini.length - 1) + 1)] + termini[Math.floor((Math.random() * termini.length - 1) + 1)] + " " + termini[Math.floor((Math.random() * termini.length - 1) + 1)];
        	inputs[i].value = termini[Math.floor((Math.random() * termini.length - 1) + 1)] + " " + termini[Math.floor((Math.random() * termini.length - 1) + 1)] + termini[Math.floor((Math.random() * termini.length - 1) + 1)] + " " + termini[Math.floor((Math.random() * termini.length - 1) + 1)] + termini[Math.floor((Math.random() * termini.length - 1) + 1)] + " " + termini[Math.floor((Math.random() * termini.length - 1) + 1)] + termini[Math.floor((Math.random() * termini.length - 1) + 1)] + " " + termini[Math.floor((Math.random() * termini.length - 1) + 1)] + termini[Math.floor((Math.random() * termini.length - 1) + 1)] + " " + termini[Math.floor((Math.random() * termini.length - 1) + 1)];
    	}
    	else{
        	inputs[i].innerHTML = termini[Math.floor((Math.random() * termini.length - 1) + 1)] + " " + termini[Math.floor((Math.random() * termini.length - 1) + 1)];
        	inputs[i].value = termini[Math.floor((Math.random() * termini.length - 1) + 1)] + " " + termini[Math.floor((Math.random() * termini.length - 1) + 1)];
    	}
    }
}



</script>


<br/>	
<center>
<input type="button" id="caso" name="caso" style="background-color:yellow; color: black; font-size:30px; padding: 10px" value="rispondi a caso (TEST)" onClick="rispondiCaso()"/>
</center>
<br>