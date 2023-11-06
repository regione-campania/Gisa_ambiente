function selectDestinazioneFromLinkTextarea( index )
{
	try {
		document.getElementById( 'destinatario_label_' + index ).innerHTML	= "-- Seleziona Esercente --";
		if(document.getElementById( 'destinatario_' + index + "_id" ).value != "-999"){
			document.getElementById( 'destinatario_' + index + "_id" ).value	= "-1";
			document.getElementById( 'destinatario_' + index + "_nome" ).value	= "";
			document.getElementById('esercenteNoGisa' + index).value = '';
			document.getElementById('esercenteFuoriRegione' + index).value = '';
		}
		
		
		
		
		inReg = document.getElementById( "inRegione_" + index );
		fuoriReg = document.getElementById( "outRegione_" + index );
	
		if( inReg.checked )
		{
			document.getElementById( 'imprese_' + index ).style.display		= "block";
			document.getElementById( 'esercenti_' + index ).style.display	= "none";
			document.getElementById('esercenteFuoriRegione' + index).style.display = 'none';
			document.getElementById('esercenteFuoriRegione' + index).value = '';
		}
		else if( fuoriReg.checked )
		{
			document.getElementById( 'imprese_' + index ).style.display		= "none";
			document.getElementById( 'esercenti_' + index ).style.display	= "block";
			document.getElementById('esercenteNoGisa' + index).style.display = 'none';
			document.getElementById('esercenteNoGisa' + index).value = '';
		}
	}
	catch(err)
	{
		alert(err.description);
	}
}


function selectDestinazione( index )
{//alert(index);
	try {
		
		//alert(index);
		document.getElementById( 'destinatario_label_' + index ).innerHTML	= "-- Seleziona Esercente --";
		
		document.getElementById( 'destinatario_' + index + "_id" ).value	= "-1";
		document.getElementById( 'destinatario_' + index + "_nome" ).value	= "";
		document.getElementById('esercenteFuoriRegione' + index).style.display = 'none';
		document.getElementById('esercenteFuoriRegione' + index).value = '';
		document.getElementById('esercenteNoGisa' + index).style.display = 'none';
		document.getElementById('esercenteNoGisa' + index).value = '';
		
		
		
		inReg = document.getElementById( "inRegione_" + index );
		fuoriReg = document.getElementById( "outRegione_" + index );
	
		if( inReg.checked )
		{
			document.getElementById( 'imprese_' + index ).style.display		= "block";
			document.getElementById( 'esercenti_' + index ).style.display	= "none";
			
		}
		else if( fuoriReg.checked )
		{
			document.getElementById( 'imprese_' + index ).style.display		= "none";
			document.getElementById( 'esercenti_' + index ).style.display	= "block";
			
		}
	}
	catch(err)
	{
		alert('aaaa' +err.description);
	}
}

function mostraDestinazione()
{
	try {
		
		inReg1 = document.getElementById( "inRegione_1");
		fuoriReg1 = document.getElementById( "outRegione_1");
//		inReg2 = document.getElementById( "inRegione_2");
//		fuoriReg2 = document.getElementById( "outRegione_2");
	
		if( inReg1.checked )
		{
			document.getElementById( 'imprese_1').style.display		= "block";
			document.getElementById( 'esercenti_1').style.display	= "none";
			
		}
		else if( fuoriReg1.checked )
		{
			document.getElementById( 'imprese_1').style.display		= "none";
			document.getElementById( 'esercenti_1').style.display	= "block";
			
		}

//		if( inReg2.checked )
//		{
//			document.getElementById( 'imprese_2').style.display		= "block";
//			document.getElementById( 'esercenti_2').style.display	= "none";
//			
//		}
//		else if( fuoriReg2.checked )
//		{
//			document.getElementById( 'imprese_2').style.display		= "none";
//			document.getElementById( 'esercenti_2').style.display	= "block";
//			
//		}
//		
	}
	catch(err)
	{
		alert(err.description);
	}
	
}
	
	
	function mostraTextareaEsercente(idTextarea){
		alert(idTextarea);
		document.getElementById(idTextarea).style.display = '';
	}

	function nascondiTextareaEsercente(idTextarea){
		document.getElementById(idTextarea).value = '';
		document.getElementById(idTextarea).style.display = 'none';
	}

	function valorizzaDestinatario(campoTextarea,idDestinatario){
		document.getElementById(idDestinatario + '_nome').value = campoTextarea.value;
		document.getElementById(idDestinatario + '_id').value = -999;
	//	gestisciObbligatorietaVisitaPostMortem();
	}
	

