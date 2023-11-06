
/*var optionsVia = {
		url: function() {
			return "GetIndirizzoByComune.do?command=Search&idComune=" +$("#comuneId").val()+"&idToponimo="+$("#topId").val()+"&via="+$("#via").val();
		},
		getValue: "via",
	    list: {		              
	    	   match: {
	               enabled: true
	           }
	          }
    };

$("#via").easyAutocomplete(optionsVia);*/
$("#via").on('focus', function() {
	if($("#comuneId").val() != 5279){
		 $(this).val('');    
		 $("#civ").val(null);
	}
});