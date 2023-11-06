var idTab;
var livelloIn;
var tipoRegistrazione ;
var numeroLinee = 0 ;
function mostraMasterList(tipologiaDaVisualizzare , idRiferimento, nomeIdRiferimento , idFlussoOriginale)
  {
	
	var dataInput ="tipologia="+tipologiaDaVisualizzare+"&"+nomeIdRiferimento+"="+idRiferimento+"&flussoOrig="+idFlussoOriginale ;
	
	$.ajax({
		  // definisco il tipo della chiamata
		  type: "POST",
		  // specifico la URL della risorsa da contattare
		  url: "GestioneMasterList.do?command=CostruisciMasterList",
		  // passo dei dati alla risorsa remota
		  data: data,
		  // definisco il formato della risposta
		  dataType: "json",
		  // imposto un'azione per il caso di successo
		  success: function(risposta){
			  mostraMasterListCallback(risposta)
		  },
		  // ed una per il caso di fallimento
		  error: function(){
		    alert("Chiamata fallita!!!");
		  }
		});
	
  }
  

  function mostraMasterListCallback(lista)
  {
	 
	 
  	alert(lista[i].aggregazione);
  
  }
  
  