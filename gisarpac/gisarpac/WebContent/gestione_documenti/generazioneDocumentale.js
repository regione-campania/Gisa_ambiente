
function openRichiestaPDF(id, address1, address2, address3, file, tipo){
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDF&id='+id+'&address1='+address1+'&address2='+address2+'&address3='+address3+'&file='+file+'&tipo='+tipo,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento entro qualche secondo...');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
		
	}
	
function openRichiestaPDF2(id, address1, address2, address3, tipo){
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDFCentralizzato&orgId='+id+'&address1='+address1+'&address2='+address2+'&address3='+address3+'&tipoOperatore='+tipo,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento entro qualche secondo...');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
		
	}

function openRichiestaPDF_ConExtra(id, extra, tipo){
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDFCentralizzato&orgId='+id+'&extra='+extra+'&tipoOperatore='+tipo,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento entro qualche secondo...');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
		
	}

function openRichiestaPDFControlli(id){
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDFCUCentralizzato&idCU='+id,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento entro qualche secondo...');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
		
	}

function openRichiestaPDFOpu(id, address1, address2, address3, tipo){
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDFCentralizzato&stabId='+id+'&tipoOperatore='+tipo,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento entro qualche secondo...');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
		
	}

function openRichiestaPDFOpuRegistrazione(id, address1, address2, address3, tipo){
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDFCentralizzato&tipoCertificato=AttestatoRegistrazione&stabId='+id+'&tipoOperatore='+tipo,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento entro qualche secondo...');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
		
	}

function openRichiestaPDFOpu2(id, address1, address2, address3, file, tipo){
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDF&stabId='+id+'&address1='+address1+'&address2='+address2+'&address3='+address3+'&file='+file+'&tipo='+tipo,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento entro qualche secondo...');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
		
	}
	

function openRichiestaPDF_DPAT(idAsl, anno, tipo,idArea){
	var res;
	var result=
		window.open('GestioneDocumentiDPAT.do?command=GeneraPDF&combo_area='+idArea+'&idAsl='+idAsl+'&anno='+anno+'&tipo='+tipo,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento... (potrebbe richiedere diversi minuti. Si prega di non eseguire altre operazioni nell attesa.)');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
	}

function openRichiestaPDF_Trasgressori(anno, tipo){
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDF&anno='+anno+'&tipo='+tipo,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento... (potrebbe richiedere qualche minuto)');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
	}

function openRichiestaPDF_ModuliCampione(idCampione, orgId, idCU, url,  tipo){
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDFModuliCampione&ticketId='+idCampione+'&orgId='+orgId+'&idCU='+idCU+'&url='+url+'&tipo='+tipo,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento... (potrebbe richiedere qualche secondo)');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
	}

function openRichiestaPDF_Modello5(idCU, orgId, stabId, altId, tipo, tipoMod){
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDFModello5&idCU='+idCU+'&orgId='+orgId+'&stabId='+stabId+'&altId='+altId+'&tipo='+tipo+'&extra='+tipoMod,'popupSelectDoc',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento... (potrebbe richiedere qualche secondo)');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
	}


		function openRichiestaPDF_LogIBR(idInvio){
			var res;
			var result=
				window.open('GestioneDocumenti.do?command=GeneraPDFLogInvii&idInvio='+idInvio,
				'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
				var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
				span = document.createElement('span');
				span.style.fontSize = "30px";
				span.style.fontWeight = "bold";
				span.style.color ="#ff0000";
				span.appendChild(text);
				var br = document.createElement("br");
				var text2 = document.createTextNode('Attendere la generazione del documento... (potrebbe richiedere qualche secondo)');
				span2 = document.createElement('span');
				span2.style.fontSize = "20px";
				span2.style.fontStyle = "italic";
				span2.style.color ="#000000";
				span2.appendChild(text2);
				result.document.body.appendChild(span);
				result.document.body.appendChild(br);
				result.document.body.appendChild(span2);
				result.focus();
			}
		
		
		function openRichiestaPDF_LogMolluschi(idInvio){
			var res;
			var result=
				window.open('GestioneDocumenti.do?command=GeneraPDFLogInvii&idInvioMolluschi='+idInvio,
				'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
				var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
				span = document.createElement('span');
				span.style.fontSize = "30px";
				span.style.fontWeight = "bold";
				span.style.color ="#ff0000";
				span.appendChild(text);
				var br = document.createElement("br");
				var text2 = document.createTextNode('Attendere la generazione del documento... (potrebbe richiedere qualche secondo)');
				span2 = document.createElement('span');
				span2.style.fontSize = "20px";
				span2.style.fontStyle = "italic";
				span2.style.color ="#000000";
				span2.appendChild(text2);
				result.document.body.appendChild(span);
				result.document.body.appendChild(br);
				result.document.body.appendChild(span2);
				result.focus();
			}
		
function openRichiestaPDF_LogBA(dataEstrazione, dataInizio, dataFine, tipo){
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDFLogBA&tipo='+tipo+'&dataEstrazione='+dataEstrazione+'&dataInizio='+dataInizio+'&dataFine='+dataFine,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento... (potrebbe richiedere qualche secondo)');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
	}



function openRichiestaPDF_LogB11(dataEstrazione, dataInizio, dataFine, tipo){
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDFLogB11&tipo='+tipo+'&dataEstrazione='+dataEstrazione+'&dataInizio='+dataInizio+'&dataFine='+dataFine,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento... (potrebbe richiedere qualche secondo)');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
	}

function openRichiestaPDF_Echinococco(idMacello, idPartita, organo, tipo){
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDFMacelli&tipo='+tipo+'&orgId='+idMacello+'&idPartita='+idPartita+'&organo='+organo,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento... (potrebbe richiedere qualche secondo)');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
	}

function openRichiestaPDFDettaglioCentralizzato(id,tipo){
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDFDettaglioCentralizzato&objectId='+id+'&tipoDettaglio='+tipo,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento entro qualche secondo...');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
		
	}


function openRichiestaPDFOpuAnagrafica(id, tipoOperatore, tipoCertificato){
	
	if (tipoCertificato==null || tipoCertificato=='')
		tipoCertificato = "SchedaOperatore";
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDFCentralizzato&tipoCertificato='+tipoCertificato+'&stabId='+id+'&tipoOperatore='+tipoOperatore,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento entro qualche secondo...');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
		
	}

function openRichiestaPDFAiaAnagrafica(id, tipoOperatore, tipoCertificato){
	
	if (tipoCertificato==null || tipoCertificato=='')
		tipoCertificato = "SchedaOperatore";
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDFCentralizzato&tipoCertificato='+tipoCertificato+'&jsonEntita={"idStabilimentoAIA" : '+id+'}'+'&tipoOperatore='+tipoOperatore,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento entro qualche secondo...');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
		
	}
function openRichiestaPDFOpuRichiestaAnagrafica(id, tipoOperatore, tipoCertificato){
	
	if (tipoCertificato==null || tipoCertificato=='')
		tipoCertificato = "SchedaOperatore";
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDFCentralizzato&tipoCertificato='+tipoCertificato+'&altId='+id+'&tipoOperatore='+tipoOperatore,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento entro qualche secondo...');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
		
	}

function openRichiestaPDFAllegatoF(idAllerta, idAsl, tipoAllegato){
	var res;
	if (idAsl==null || idAsl=='')
		idAsl = '-1';
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDFAllerte&tipo=AllegatoF&idAllerta='+idAllerta+'&idAsl='+idAsl+'&tipoAllegato='+tipoAllegato,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento entro qualche secondo...');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
		
	}


function openRichiestaPDFCensimento(id, tipo){
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDF&id='+id+'&tipo='+tipo+'&file='+tipo,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento entro qualche secondo...');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
		
	}


function openRichiestaPDFMovimentazione(id, tipo){
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDF&id='+id+'&tipo='+tipo+'&file='+tipo,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento entro qualche secondo...');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
		
	}



function openRichiestaPDFSintesisAnagrafica(id, tipoOperatore, tipoCertificato){
	
	if (tipoCertificato==null || tipoCertificato=='')
		tipoCertificato = "SchedaOperatore";
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDFCentralizzato&tipoCertificato='+tipoCertificato+'&altId='+id+'&tipoOperatore='+tipoOperatore,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento entro qualche secondo...');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
		
	}


function openRichiestaPDFGestioneAnagrafica(id, tipoOperatore, tipoCertificato){
	
	if (tipoCertificato==null || tipoCertificato=='')
		tipoCertificato = "SchedaOperatore";
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDFCentralizzato&tipoCertificato='+tipoCertificato+'&altId='+id+'&tipoOperatore='+tipoOperatore,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento entro qualche secondo...');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
		
	}

function openRichiestaPDFRichiestaErrataCorrige(id, riferimentoId, riferimentoIdNomeTab){
	
	
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDFRichiestaErrataCorrige&id='+id+'&riferimentoId='+riferimentoId+'&riferimentoIdNomeTab='+riferimentoIdNomeTab,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento ed invio mail entro qualche secondo...');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
		
	}

function openRichiestaPDFOpuAnagraficaCampoEsteso(id, idCampoEsteso, tipoOperatore){
	
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDFCentralizzato&stabId='+id+'&idCampoEsteso='+idCampoEsteso+'&tipoOperatore='+tipoOperatore,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento entro qualche secondo...');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
		
	}

function openRichiestaPDFAMR(id){
	
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDFAMR&idControllo='+id,'popupSelect2',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento entro qualche secondo...');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
		
	}

function openRichiestaPDFScarrabile(id, altId){
	
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDFScarrabile&id='+id+'&altId='+altId,'popupSelect2',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento entro qualche secondo...');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
	}




