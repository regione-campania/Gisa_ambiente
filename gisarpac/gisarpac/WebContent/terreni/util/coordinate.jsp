<script>
var MIN_COORD_X = 434854.654;
var MAX_COORD_X = 437761.808; 
var MIN_COORD_Y = 4502019.235;
var MAX_COORD_Y = 4504797.827;

function validaCoordinate(s) {
    var rgx = /^[0-9]*\.?[0-9]*$/;
    if (s.value.match(rgx) == null){
    	alert("Valore non consentito! (Consentito solo il formato coordinate es. 437761.808)");
    	s.value = "";
    }
}

</script>