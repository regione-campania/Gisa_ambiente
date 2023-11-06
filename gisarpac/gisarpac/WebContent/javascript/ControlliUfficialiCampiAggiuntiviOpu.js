function recuperaLineaSottoposta(idTicket){
	PopolaCombo.recuperaLineaSottopostaCu(idTicket,{callback:recuperaLineaSottopostaCallBack,async:false});
}

function recuperaLineaSottopostaCallBack(val){
	controllaCampiAggiuntiviLinea(val);
}

function controllaCampiAggiuntiviLinea(idLinea) {
	PopolaCombo.recuperaCodiceIdentificativoCu(idLinea,{callback:controllaCampiAggiuntiviLineaCallBack,async:false});
}

function controllaCampiAggiuntiviLineaCallBack(val){
	showHide(val);
}

function showHide(id){
	var list = document.getElementsByClassName("campiAggiuntiviLinea");
	for (var i=0; i<list.length; i++){
		if (list[i].id == id)
			list[i].style.display="";
		else
			list[i].style.display="none";
	}
	
}