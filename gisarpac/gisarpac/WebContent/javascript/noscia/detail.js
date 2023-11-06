function setValore(key, value){
	var campoOld = $('#'+key);
	
	if (campoOld==null)
		return false;
	
	campoOld.replaceWith(value);
}

function setLinea(key, value){
	
	var newRow = $("<tr>");
    var cols = "";
    cols += '<td class="formLabel">LINEA</td>';
    cols += '<td>'+value+'</td>';
    newRow.append(cols);
    newRow.insertAfter($('#trLinee'));
}

function VisualizzaDettaglio(arrAnagrafica, arrLinee){

	$("div#dettaglio :input").each(function(){
		 var input = $(this); // This is the jquery object of the input, do what you will
		 if (input.attr('type') == 'button'){
			 input.hide();
		 }
		 if (input.attr('type') == 'text'){
			 input.hide();
		 }
		});
	$("#dati_impresa_id").hide();
	
	var value;
	for (var key in arrAnagrafica) {
	    value = arrAnagrafica[key];
	   setValore(key, value);
	}
	
	for (var key in arrLinee) {
	    value = arrLinee[key];
    	setLinea(key, value);
	}
	
}