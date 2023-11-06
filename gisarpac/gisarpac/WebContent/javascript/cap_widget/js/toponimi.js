var selezioneToponimo = false;
var toponimoSelezionato = '';
var optionsToponimo = {
	url: "resources/toponimi.json",

	getValue: "name",
  list: {
  onSelectItemEvent: function() {
      var value =  $("#top").getSelectedItemData().value;
      var name = $("#top").getSelectedItemData().name;
      $("#topId").val(value).trigger("change");
      $("#top").val(name).trigger("change");
      toponimoSelezionato = name;
      selezioneToponimo = true;
		},
		match: {
			enabled: true
		}
	}
};

$("#top").easyAutocomplete(optionsToponimo);
$("#top").on('focus', function() {
	  selezioneToponimo = false;
      $(this).val('');
      $("#topId").val(null);
      $("#via").val(null);
      $("#civ").val(null);
      if($("#comuneId").val() == 5279){
    	  $("#cap").val(null);
      }      
  }).on('blur', function() {
    if (!selezioneToponimo || ($("#top").val() != toponimoSelezionato)) {
      $(this).val(null);
      toponimoSelezionato = '';
    }
  });