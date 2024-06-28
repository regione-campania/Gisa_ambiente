<script>

let VERTICE_NORDOVEST_X = 392648;
let VERTICE_NORDOVEST_Y = 4600260;

let VERTICE_NORDEST_X = 572449;
let VERTICE_NORDEST_Y = 4598906;

let VERTICE_SUDEST_X = 571130;
let VERTICE_SUDEST_Y = 4423843;

let VERTICE_SUDOVEST_X = 391330;
let VERTICE_SUDOVEST_Y = 4425197;

function validaCoordinate(s) {
    var rgx = /^[0-9]*\.?[0-9]*$/;
    if (s.value.match(rgx) == null){
    	alert("Valore non consentito! (Consentito solo il formato coordinate es. 437761.808)");
    	s.value = "";
    }
}

function validaCoordinateFormato(s) {
    var rgx = /^[0-9]*\.?[0-9]*$/;
    if (s.value.match(rgx) == null){
    	alert("Valore non consentito! (Consentito solo il formato coordinate es. 437761.808)");
    	s.value = "";
    }
}

function maxCoordinate(c1, c2){
	if (c1 > c2)
		return c1;
	else
		return c2;
}
function minCoordinate(c1, c2){
	if (c1 < c2)
		return c1;
	else
		return c2;
}

function isPointOnLine(x, y, x1, y1, x2, y2) {
    // Calcola la distanza tra il punto (x, y) e la linea definita dai punti (x1, y1) e (x2, y2)
    let dist = Math.abs((y2 - y1) * x - (x2 - x1) * y + x2 * y1 - y2 * x1) / Math.sqrt(Math.pow(y2 - y1, 2) + Math.pow(x2 - x1, 2));
    // Se la distanza è molto piccola, consideriamo che il punto sia sulla linea
    return dist < 0.00001;
}

function validaCoordinateCampania(coord_x, coord_y) {
   
   let x = parseFloat(coord_x);
   let y = parseFloat(coord_y);
   

// Creazione del poligono
	    let polygon = [
	        [VERTICE_NORDOVEST_X, VERTICE_NORDOVEST_Y],
	        [VERTICE_NORDEST_X, VERTICE_NORDEST_Y],
	        [VERTICE_SUDEST_X, VERTICE_SUDEST_Y],
	        [VERTICE_SUDOVEST_X, VERTICE_SUDOVEST_Y]
	    ];

	    // Verifica se il punto è all'interno del poligono
	    let inside = false;
	    for (let i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
	        let xi = polygon[i][0], yi = polygon[i][1];
	        let xj = polygon[j][0], yj = polygon[j][1];

	        let intersect = ((yi > y) !== (yj > y)) && (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
	        if (intersect) inside = !inside;

	        // Verifica se il punto è su un bordo del poligono
	        if (isPointOnLine(x, y, xi, yi, xj, yj)) return true;
	    }

	    return inside;
	}

</script>