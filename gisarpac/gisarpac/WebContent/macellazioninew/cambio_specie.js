
function lanciaModifiche(){
	var specie1 = document.getElementById("Specie1");
	var specie2 = document.getElementById("Specie2");
	var elementi1 = document.getElementsByClassName("specie1");
	var elementi2 = document.getElementsByClassName("specie2");
	
	for (var i=0; i<elementi1.length;i++)
		elementi1[i].innerHTML = specie1.value;
	for (var j=0; j<elementi2.length;j++)
		elementi2[j].innerHTML = specie2.value;
	
	var selectSpecie = document.getElementById("cd_specie");
	if (selectSpecie!=null){
		selectSpecie.options[1].innerHTML = specie1.value;
		selectSpecie.options[2].innerHTML = specie2.value;
	}
}

function gestisciLabelPartite(valore){
	var specie1 = document.getElementById("Specie1");
	var specie2 = document.getElementById("Specie2"); 
	var specie_suina = document.getElementById("specie_suina");
	if (valore=='1'){
		specie1.value="Ovini";
		specie2.value="Caprini";
		specie_suina.value = 'false';
	}
	else if (valore=='2'){
		specie1.value="Cinghiali";
		specie2.value="Suini";
		specie_suina.value = 'true';
	}
	lanciaModifiche();
}

