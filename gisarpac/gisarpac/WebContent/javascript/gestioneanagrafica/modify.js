
function setValore(key, value){
	var campoOld = $('#'+key);
	
	if (campoOld==null)
		return false;
	
	campoOld.replaceWith(value);
}

function VisualizzaValoriModifica(arrAnagrafica){
	loadModalWindow();
	var value;
	for (var key in arrAnagrafica) {
		{      
			var elemento = arrAnagrafica[key];
			var keyfield =  document.getElementById(key);
			if (typeof(keyfield) != 'undefined' && keyfield != null)
			{			
				keyfield.value = elemento;
				if (keyfield.id == 'numero_registrazione_stabilimento' || keyfield.id == 'asl_stabilimento'){
					value = arrAnagrafica[key];
					   setValore(key, value);
				}
				if (keyfield.id == 'partita_iva_impresa'){
					keyfield.readOnly = true;
				}
			}
		}
	}
	
	if(typeof(document.getElementById('nazione_nascita_rapp_legale')) != 'undefined' && document.getElementById('nazione_nascita_rapp_legale') != null){
		if(document.getElementById('nazione_nascita_rapp_legale').value != 106)
		{
			document.getElementById('tr_comune_nascita_rapp_legale').style='display: none';
			document.getElementById('tr_comune_nascita_estero_rapp_legale').style='display: block inline-block';
			document.getElementById('comune_nascita_estero_rapp_legale').style='display: block inline-block';
	        document.getElementById('comune_nascita_estero_rapp_legale').disabled = false;
	        document.getElementById('comune_nascita_rapp_legale').disabled = true;
			document.getElementById('calcola_cf_rapp_legale').style='display: none';
		}
	}
	
	
	if(typeof(document.getElementById('nazione_residenza_rapp_legale')) != 'undefined' && document.getElementById('nazione_sede_legale') != null){
		if(document.getElementById('nazione_residenza_rapp_legale').value != '106'){
			document.getElementById('indirizzo_residenza_rapp_legale').style='display: none';
			document.getElementById('tr_comune_residenza_estero_rapp_legale').style='display: block inline-block';
			document.getElementById('comune_residenza_estero_rapp_legale').style='display: block inline-block';
	        document.getElementById('comune_residenza_estero_rapp_legale').value = document.getElementById('comune_residenza_rapp_legale').value;
	        document.getElementById('comune_residenza_rapp_legale').value = "";
		}
	}
	
	if(typeof(document.getElementById('nazione_sede_legale')) != 'undefined' && document.getElementById('nazione_sede_legale') != null){
		if(document.getElementById('nazione_sede_legale').value != '106'){
			document.getElementById('indirizzo_sede_legale').style='display: none';
			document.getElementById('tr_comune_estero_sede_legale').style='display: block inline-block';
			document.getElementById('comune_estero_sede_legale').style='display: block inline-block';
	        document.getElementById('cap_sede_legale').removeAttribute('required');
	        document.getElementById('comune_estero_sede_legale').value = document.getElementById('comune_sede_legale').value;
	        document.getElementById('comune_sede_legale').value = "";
		}
	}
	
	$("#ins_numero_registrazione").hide();
	$("#stabilimento_id_sezione").hide();
	$("#dati_impresa_id").hide();
	loadModalWindowUnlock();
}