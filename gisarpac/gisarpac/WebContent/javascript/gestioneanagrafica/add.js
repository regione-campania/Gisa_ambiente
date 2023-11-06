function mostraNascondiNumeroPratica(val){
	
	if (val=='manuale'){
		document.getElementById("numeroPratica").required = "required";
		document.getElementById("numeroPratica").style.visibility = "visible";
	}
	else if (val =='automatico'){
		document.getElementById("numeroPratica").required = "";
		document.getElementById("numeroPratica").style.visibility = "hidden";
		document.getElementById("numeroPratica").value = "";
	}
}

function openUploadAllegatoGins(idAggiuntaPratica, codiceAllegato, tipoUpload){
	var res;
	var result;
	
	if (document.all || 1==1) {
		window.open('GestioneAllegatiGins.do?command=PrepareUploadAllegato&tipo='+tipoUpload+'&tipoAllegato='+tipoUpload+'&idAggiuntaPratica='+idAggiuntaPratica+'&codiceAllegato='+codiceAllegato,null,
		'height=450px,width=480px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=no,resizable=no ,modal=yes');
		
		
		} else {
		
			res = window.showModalDialog('GestioneAllegatiGins.do?command=PrepareUploadAllegato&tipo='+tipoUpload+'&tipoAllegato='+tipoUpload+'&idAggiuntaPratica='+idAggiuntaPratica+'&codiceAllegato='+codiceAllegato,null,
			'dialogWidth:480px;dialogHeight:450px;center: 1; scroll: 0; help: 1; status: 0');
		
		}
		} 