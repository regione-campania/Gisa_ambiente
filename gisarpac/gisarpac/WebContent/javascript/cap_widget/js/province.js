let inputParams = new URLSearchParams(window.location.search);
var flag_regione = inputParams.get('flag_regione');
var flag_id_asl = inputParams.get('flag_id_asl');

var selezioneProvincia = false;
var provinciaSelezionata = '';
var fileResourceProvince;

if(flag_regione == 'campania'){

	if(flag_id_asl == '-1'){
		fileResourceProvince = "resources/provincecampania.json";
	}else {
		fileResourceProvince = "GetProvinceByAsl.do?command=Search&idAsl=" + flag_id_asl;
	}
	
} else {
	fileResourceProvince = "resources/province.json";
}
var optionsProvincie = {
			url : function() {
						return fileResourceProvince;
						},

			getValue: "label",
			
			list: {
				onChooseEvent: function() {    
				      var value =  $("#provincia").getSelectedItemData().value;
				      var name = $("#provincia").getSelectedItemData().label;
				      $("#provinciaId").val(value).trigger("change");
				      $("#provincia").val(name).trigger("change");
				      provinciaSelezionata = name;
				      selezioneProvincia = true;
					},
				/*
			  	onSelectItemEvent: function() {    
			      var value =  $("#provincia").getSelectedItemData().value;
			      var name = $("#provincia").getSelectedItemData().label;
			      $("#provinciaId").val(value).trigger("change");
			      $("#provincia").val(name).trigger("change");
			      provinciaSelezionata = name;
			      selezioneProvincia = true;
				}*/
				
				match: {
					enabled: true
				}
			}
};
$("#provincia").easyAutocomplete(optionsProvincie);

$('#provincia').on('focus', function() {
      selezioneProvincia = false;
	  $(this).val('');
      $("#provinciaId").val(null);
      $("#comuni").val(null);
      $("#comuneId").val(null);
      $("#top").val(null);
      $("#topId").val(null);
      $("#via").val(null);
      $("#civ").val(null);
      $("#cap").val(null);
      $("#napoli").css({"visibility":"hidden"});
  }).on('blur', function() {
    if (!selezioneProvincia || ($("#provincia").val() != provinciaSelezionata)) {
      $(this).val(null);
      provinciaSelezionata = '';
    }
  });
  
