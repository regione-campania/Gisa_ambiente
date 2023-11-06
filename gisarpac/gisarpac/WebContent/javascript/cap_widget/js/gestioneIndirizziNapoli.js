var selezioneIndirizzoNapoli = false;
var indirizzoNapoliSelezionato = '';
var optionsNapoli = {
		
		url: "resources/napoli.js",
		
		list: {	
			maxNumberOfElements: 15,
			onSelectItemEvent: function() {    
			      var viaNapoli =  $("#napoli").getSelectedItemData();
			      indirizzoNapoliSelezionato = viaNapoli;
			      $("#napoli").val(viaNapoli).trigger("change");			      
			      selezioneIndirizzoNapoli = true;
			  },
              
		      match: {
		    	  enabled: true
		      }
	      }
    };

$("#napoli").easyAutocomplete(optionsNapoli);

$("#napoli").on('focus', function() {
	selezioneIndirizzoNapoli = false;
    $(this).val('');    
    $("#top").val(null);
    $("#topId").val(null);
    $("#via").val(null);
    $("#civ").val(null);
    $("#cap").val(null);
}).on('blur', function() {
    if (!selezioneIndirizzoNapoli || ($("#napoli").val() != indirizzoNapoliSelezionato)) {
    	$(this).val(null);
        indirizzoNapoliSelezionato = '';
      } else {
    	$(this).val(indirizzoNapoliSelezionato);
        var arrayIndirizzo = indirizzoNapoliSelezionato.split("|");
  	    $("#top").val(arrayIndirizzo[1]).trigger("change");
  	    $("#topId").val(toponimi[arrayIndirizzo[1]]).trigger("change");
  	    $("#via").val(arrayIndirizzo[0]).trigger("change");
  	    $("#cap").val(arrayIndirizzo[2]).trigger("change");
      }
    });;