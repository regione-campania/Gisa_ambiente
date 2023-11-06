<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<h2>stato operazione</h2>
<tr>
	<td>  
		<label id="inserimento_linea">operazione in corso</label>    
		<input type="hidden" id="stabId" value="${stabId}"> 
		<input type="hidden" id="altId" value="${altId}"> 
		<input type="hidden" id="numeroPratica" value="${numeroPratica}"> 
		<input type="hidden" id="tipoPratica" value="${tipoPratica}"> 
		<input type="hidden" id="dataPratica" value="${dataPratica}">
		<input type="hidden" id="tipo_output" value="${tipo_output}">
		<input type="hidden" id="comunePratica" value="${comunePratica}">
	</td>
</tr>


<script>

  var stabId = document.getElementById("stabId").value; 
  var altId = document.getElementById("altId").value; 
  var numeroPratica = document.getElementById("numeroPratica").value; 
  var tipoPratica = document.getElementById("tipoPratica").value; 
  var dataPratica = document.getElementById("dataPratica").value;
  var tipo_output = document.getElementById("tipo_output").value;
  var comunePratica = document.getElementById("comunePratica").value;
  
  if(tipo_output == '2'){
	  loadModalWindow();
	  window.location.href='GestioneAnagraficaAction.do?command=CreaPratica';
  } else if (tipo_output == '3'){
	  loadModalWindow();
	  window.location.href='GestioneAnagraficaAction.do?command=ListaPraticheStabilimenti';
  } else {
	  if(tipoPratica != '1' && altId == '-1'){
		  var messaggio_stab_mancante = "Attenzione: si sta tentando di applicare una modifica ad uno stabilimento non presente in gisa.\n";
		  messaggio_stab_mancante += "Cliccare ok per inserire lo stabilimento in gisa oppure cliccare annulla per tornare alla lista delle pratiche."
		  if(confirm(messaggio_stab_mancante)){
			  window.location.href='GestioneAnagraficaAction.do?command=Choose';
		  }else{
			  window.location.href='GestioneAnagraficaAction.do?command=ListaPraticheStabilimenti';
		  }
	  } else {
			  switch(tipoPratica){
				//inserimento stabilimento
			  case "1":
				  loadModalWindow();
				  var link = 'GestioneAnagraficaAction.do?command=Choose&numeroPratica='+numeroPratica+'&tipoPratica='+tipoPratica+'&dataPratica='+dataPratica+'&comunePratica='+comunePratica;
				  window.location.href=link;
				  break;
			  
				  //ampliamento
			  case "2":
				  loadModalWindow();
				  var link = 'GestioneAnagraficaAction.do?command=ModifyGeneric&altId='+altId
						  		+'&operazione=ampliamento&numeroPratica='+numeroPratica+'&tipoPratica='+tipoPratica+'&dataPratica='+dataPratica+'&comunePratica='+comunePratica;
				  window.location.href=link;
				  break;
				  
				  //cessazione
			  case "3":
				  loadModalWindow();
				  var link = 'GestioneAnagraficaAction.do?command=ModifyGeneric&altId='+altId
			  		+'&operazione=cessazione&numeroPratica='+numeroPratica+'&tipoPratica='+tipoPratica+'&dataPratica='+dataPratica+'&comunePratica='+comunePratica;
				  window.location.href=link;
				  break;
				  
				  //variazione titolarita
			  case "4":
				  loadModalWindow();
				  var link = 'GestioneAnagraficaAction.do?command=TemplateVariazione&altId='+altId
						  + '&numeroPratica='+numeroPratica+'&tipoPratica='+tipoPratica+'&dataPratica='+dataPratica+'&comunePratica='+comunePratica;;
				  window.location.href=link;
				  break;
				  
				  //modifica stato luoghi
			  case "6":
				  loadModalWindow();
				  var link = 'GestioneAnagraficaAction.do?command=ModifyGeneric&altId='+altId
			  		+'&operazione=modificaStatoDeiLuoghi&numeroPratica='+numeroPratica+'&tipoPratica='+tipoPratica+'&dataPratica='+dataPratica+'&comunePratica='+comunePratica;
				  window.location.href=link;
				  break;
				 
				  //trasferimento sede
			  case "7":
				  loadModalWindow();
				  var link = 'GestioneAnagraficaAction.do?command=ModifyGeneric&altId='+altId
			  		+'&operazione=trasferimentoSede&numeroPratica='+numeroPratica+'&tipoPratica='+tipoPratica+'&dataPratica='+dataPratica+'&comunePratica='+comunePratica;
				  window.location.href=link;
				  break;
		}
	  }
  }
  
  
  
  
  
  
  

</script>