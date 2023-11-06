
<%@page import="ext.aspcfs.modules.apiari.base.Stabilimento"%>
<%@page import="ext.aspcfs.modules.apiari.base.StabilimentoList"%>
<jsp:useBean id="ApicolturaSottospecie" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ApicolturaModalita" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ApicolturaClassificazione" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoAttivitaApi" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ApiarioOrigine" class="ext.aspcfs.modules.apiari.base.Stabilimento" scope="request"/>




<jsp:useBean id="NazioniList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Operatore" class="ext.aspcfs.modules.apiari.base.Operatore" scope="request" />





<link rel="stylesheet" href="css/jquery-ui.css" />
<link rel="stylesheet" href="css/opu.css" />

<script language="JavaScript" TYPE="text/javascript" SRC="javascript/gestoreCodiceFiscale.js"></script>
<SCRIPT src="javascript/apiari.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="javascript/CalendarPopup.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" ID="js19">
	var cal19 = new CalendarPopup();
	cal19.showYearNavigation();
	cal19.showYearNavigationInput();
	cal19.showNavigationDropdowns();
</SCRIPT>
<%@ include file="../initPage.jsp"%>





<link rel="stylesheet" type="text/css" href="javascript/jquerypluginTableSorter/css/theme.css"></link>
<link rel="stylesheet" type="text/css" href="javascript/jquerypluginTableSorter/css/jquery.tablesorter.pages.css"></link>

<script type="text/javascript" src="javascript/jquerypluginTableSorter/jquery.tablesorter.js"></script>
<script type="text/javascript" src="javascript/jquerypluginTableSorter/jquery.tablesorter.pager.js"></script>

<script type="text/javascript" src="javascript/jquerypluginTableSorter/jquery.tablesorter.widgets.js"></script>
<script type="text/javascript" src="javascript/jquerypluginTableSorter/tableJqueryFilterApi.js"></script>


<script src="javascript/jquery.searchable-1.0.0.min.js"></script>
<!--   <link rel="stylesheet" type="text/css" media="screen" href="http://combogrid.justmybit.com/resources/css/smoothness/jquery-ui-1.10.1.custom.css"/> -->

  <link rel="stylesheet" type="text/css" media="screen" href="css/jquery.ui.combogrid.css"/>
  <script type="text/javascript" src="javascript/jquery.ui.combogrid.js"></script>
  <script>
  
  
  function checkForm()
  {
	  
	  formTest = true;
	    message = "";
	    alertMessage = "";
	   
	    form = document.formcessazione ;
	
	    if (document.addmovimentazione.dataInizioAttivita!=null && document.addmovimentazione.dataInizioAttivita.value=='' )
		  {
		  message += "- Data Inizio Attivita richiesto\r\n";
	        formTest = false;
		  }
	    
	    
	    if (document.addmovimentazione.provinciaUbicazioneIn!=null && document.addmovimentazione.provinciaUbicazioneIn.value=='' )
		  {
		  message += "- Selezionare l'apiario di destinazione\r\n";
	        formTest = false;
		  }
	    
	    
	    if (document.addmovimentazione.data_modello.value != '' && document.addmovimentazione.dataMovimentazione.value != '' ){
    		var dataUsc = document.addmovimentazione.dataMovimentazione.value ;
    		annoU = parseInt(dataUsc.substr(6),10);
    		meseU = parseInt(dataUsc.substr(3, 2),10);
    		giornoU = parseInt(dataUsc.substr(0, 2),10);
    		
    		var dataMod = document.addmovimentazione.data_modello.value ;
    		annoM = parseInt(dataMod.substr(6),10);
    		meseM = parseInt(dataMod.substr(3, 2),10);
    		giornoM = parseInt(dataMod.substr(0, 2),10);
    		
    		var _dataUscita = new Date(annoU, meseU-1, giornoU);
    		var _dataModello = new Date(annoM, meseM-1, giornoM);
    	
    		if(_dataUscita < _dataModello){
		  		message += "- La data uscita deve essere maggiore della data modello\r\n";
	        	formTest = false;
    		}
		  }
	    
	    
	    if (formTest == false) {
	        alert(label("check.form", "Form could not be saved, please check the following:\r\n\r\n") + message);
	        return false;
	      } else {
	      
	        loadModalWindow();
	        return true;
	      }
	 
  }
  
  
  $( document ).ready(function() {
	  
	  
	  
	    $( "#codiceApiarioDestinazione" ).combogrid({
		  debug:true,
		  colModel: [  {'columnName':'comune','width':'20','label':'Comune'},{'columnName':'indirizzo','width':'20','label':'Indirizzo'},{'columnName':'detentore','width':'45','label':'Detentore'}],
		  url: "ApicolturaApiari.do?command=SearchApiari&codiceAzienda=<%=Operatore.getCodiceAzienda() %>&idApiarioScelto=<%=ApiarioOrigine.getIdBda() %>&output=json",
		  select: function( event, ui ) {
			  if(ui.item.id>0)
				  {
					  if('<%=ApiarioOrigine.getSedeOperativa().getSiglaProvincia().toUpperCase()%>'==ui.item.provincia.toUpperCase())
				  	  {
				  		  alert("Attenzione!!! Non e' possibile selezionare un apiario appartenente alla stessa provincia dell'apiario di origine");
				  		  $( "#codiceApiarioDestinazione" ).val("");	
				  	  }
					  else
					  {
				  
			  			selectApiarioDestinazione(ui.item.progressivo,ui.item.id,ui.item.comune,ui.item.provincia,ui.item.indirizzo,ui.item.detentore,ui.item.cfDetentore,ui.item.numAlveari,ui.item.latitudine,ui.item.longitudine);
					  }
					  }
			  else
				  {
				  alert("Non Esistono Altri Apiari");
				  $( "#codiceApiarioDestinazione" ).val("");
				  }
			 
			  return false;
		  }
	  });
	    
	  
 
  
  });




  function selectApiarioDestinazione(progressivo,idApiario,comuneUbicazione,provinciaUbicazione,indirizzoApiario,detentore,cfDetentore,numAlveari,latitudine,longitudine)
  {
  	document.getElementById("idApiarioIn").value=idApiario;
  	document.getElementById("indirizzoUbicazioneIn").value=indirizzoApiario;
  	document.getElementById("provinciaUbicazioneIn").value=provinciaUbicazione;
  	document.getElementById("detentoreIn").value=detentore;
  	document.getElementById("cfDetentoreIn").value=cfDetentore;
  	document.getElementById("codiceApiarioDestinazione").value=comuneUbicazione;
  	document.getElementById("progressivoIn").value=progressivo;
  	document.getElementById("numAlveariIn").value=numAlveari;
  	
  	document.getElementById("latitudine_dest").value=latitudine;
  	document.getElementById("longitudine_dest").value=longitudine;
  	
  	$(".table-wrapper").hide();
  	
  }
  

function selectApiarioOrigine(progressivo,idApiario,comuneUbicazione,provinciaUbicazione,indirizzoApiario,detentore,cfDetentore,numAlveari)
{
	document.getElementById("idApiario").value=idApiario;
	document.getElementById("indirizzoUbicazione").value=indirizzoApiario;
	document.getElementById("provinciaUbicazione").value=provinciaUbicazione;
	document.getElementById("detentore").value=detentore;
	document.getElementById("cfDetentore").value=cfDetentore;
	document.getElementById("apiario").value=comuneUbicazione;
	document.getElementById("progressivo").value=progressivo;
	document.getElementById("numAlveari").value=numAlveari;

	
	$(".table-wrapper").hide();
	
}
</script>

<style>
input[readonly="readonly"]
{
    border:0;
}


</style>




<table class="trails" cellspacing="0">
<tr>
<td>
<a href="ApicolturaAttivita.do?command=Home">ANAGRAFICA ATTIVITA</a> > 
<a href="ApicolturaMovimentazioni.do?command=List">MOVIMENTAZIONI </a> >
<a href="ApicolturaMovimentazioni.do?command=ToAddRichiesta">NUOVA MOVIMENTAZIONE</a> >
NOMADISMO
</td>
</tr>
</table>
<br>

<%
if (request.getAttribute("Error")!=null && ((String)request.getAttribute("Error")).indexOf("duplicati_movimentazioni")>0)
{
	%>
	<font color="red">Errore: la movimentazione che si vuole inserire esiste gi�</font>
	<%
}
else if (request.getAttribute("Error")!=null)
{
	%>
	<font color="red"><%=(String)request.getAttribute("Error")%></font>
	<%
}

%>

<form  name="addmovimentazione" action="ApicolturaMovimentazioni.do?command=Insert&auto-populate=true" method="POST" onsubmit="return checkForm()">

<input type="hidden" name="idOperatore" id="idOperatore" value="<%=Operatore.getIdOperatore()%>">
	
	<fieldset>
		<legend><b>NUOVA MOVIMENTAZIONE</b></legend>
		<table cellpadding="4" cellspacing="0" border="0" width="100%"
		class="details">
		 <tr>
    <th colspan="2">
      <strong>AZIENDA</strong>
    </th>
  </tr>

		
		<tr>
			<td nowrap class="formLabel">Tipo di Movimentazione</td>
			<td>

			NOMADISMO <input type="hidden" required="required"  name="idTipoMovimentazione" id = "tipoMovimentazion3" value="2" onclick="showDatiTipoMovimentazione(this.value)">
			
			
			
			
			</td>
		</tr>
		
		
		
			<tr>
			<td nowrap class="formLabel">Data Uscita</td>
			<td>
			<input type= "text" name = "dataMovimentazione" required/>
			<a href="#" onClick="cal19.select(document.forms['addmovimentazione'].dataMovimentazione,'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19"><img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
							<%=showError(request, "dataMovimentazioneError") %>
			
			</td>
		</tr>
		
		<tr>
			<td nowrap class="formLabel">Data Modello</td>
			<td>
			<input type= "text" name = "data_modello" required/>
			<a href="#" onClick="cal19.select(document.forms['addmovimentazione'].data_modello,'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19"><img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
							<%=showError(request, "dataMovimentazioneError") %>
			
			</td>
		</tr>
		<tr>
			<td nowrap class="formLabel">Richiesta validazione ASL</td>
			<td>
				<input type="checkbox" name="richiestaValidazione" id="richiestaValidazione"><i>Per le destinazioni in regione la validazione non sar� in nessun caso necessaria</i>
			</td>
		</tr>
	
		
		
			
			
	</table>
	
	<BR>
	<table cellpadding="4" cellspacing="0" border="0" width="100%"
		class="details" id = "dati_apiario">
		 <tr>
   
  
   <tr><th colspan="2"><strong>APIARIO DA MOVIMENTARE</strong></th></tr>
				
				
				
	<tr><td nowrap class="formLabel">CODICE AZIENDA</td><td><input type="text" value="<%=Operatore.getCodiceAzienda() %>"  size="50" min="5"  readonly="readonly"  name="codiceAziendaOrigine" required id="codiceAziendaOrigine" ></td></tr>
				<tr>
			<td nowrap class="formLabel">Denominazione</td>
			<td>
			<input type="hidden" name = "idAzienda" value="<%=Operatore.getIdOperatore() %>">
			<%=Operatore.getRagioneSociale() %>
			
			</td>
		</tr>
		
		
			<tr>
				<td class="formLabel" nowrap>Codice Fiscale Proprietario</td>
				<td>
				<%=Operatore.getRappLegale().getCodFiscale() %>
					
				</td>
			</tr>
			
			<tr>
				<td nowrap class="formLabel">Proprietario (cognome e nome) </td>
				<td>
				<%=Operatore.getRappLegale().getCognome() +" "+ Operatore.getRappLegale().getNome() %>
				</td>

			</tr>
				 <tr><td nowrap class="formLabel">Comune</td><td>
				 
				
				 <input type="text"   size="50" name="codiceApiario" readonly="readonly" required id="apiario" value="<%=ApiarioOrigine.getSedeOperativa().getDescrizioneComune() %>" placeholder="DIGITARE IL COMUNE PER CERCARE">
				 
				 
				 </td></tr>

				 <tr><td nowrap class="formLabel">Provincia</td><td>
				 <input type="hidden" id="idApiario" value="<%=ApiarioOrigine.getIdBda() %>" name="idBdaApiarioOrigine" required >
				 <input type="text" value="<%=ApiarioOrigine.getSedeOperativa().getSiglaProvincia() %>" size="50"  readonly="readonly" name="provinciaUbicazione" id="provinciaUbicazione"></td></tr>
				 <tr><td nowrap class="formLabel">Indirizzo</td><td><input type="text"  size="50"  value="<%=ApiarioOrigine.getSedeOperativa().getVia() %>" readonly="readonly" name="indirizzoUbicazione" required id="indirizzoUbicazione"></td></tr>	
				 <tr><td nowrap class="formLabel">Detentore</td><td><input type="text"  size="50"  value="<%=ApiarioOrigine.getDetentore().getNome() + " "+ApiarioOrigine.getDetentore().getCognome() %>" readonly="readonly" name="detentore" required id="detentore"></td></tr>	
				 <tr><td nowrap class="formLabel">Codice Fiscale Detentore</td><td><input type="text"  size="50"  value="<%=ApiarioOrigine.getDetentore().getCodFiscale() %>" readonly="readonly" name="cfDetentore" id="cfDetentore"></td></tr>	
				 <tr><td nowrap class="formLabel">PROGRESSIVO</td><td><input type="text"  size="50"  value="<%=ApiarioOrigine.getProgressivoBDA() %>" readonly="readonly" name="progressivoApiarioOrigine" required id="progressivo"></td></tr>	
    <tr><td nowrap class="formLabel">Numero Alverari Presenti</td><td><input type="text"  size="50"  value="<%=ApiarioOrigine.getNumAlveari() %>" readonly="readonly" name="numApiariOrigine" required id="numAlveari"></td></tr>
  <tr id="tr_num_alveari"><td nowrap class="formLabel">Numero Alverari Da Spostare</td><td><input type="text"  size="50"  value=""  name="numAlveariDaSpostare" required id="numAlveariDaSpostare"></td></tr>
  
  </table>
  
  <br>
  
  
   <table cellpadding="4" cellspacing="0" border="0" width="100%"
		class="details" >
		 <tr>
   
   <tr><th colspan="2"><strong>APIARIO DI DESTINAZIONE</strong></th></tr>

  <tr><td nowrap class="formLabel">CODICE AZIENDA</td><td><input type="text" value="<%=Operatore.getCodiceAzienda() %>"  size="50" min="5"  name="codiceAziendaDestinazione" required id="codiceAziendaDestinazione" readonly="readonly"></td></tr>

  				 <tr><td nowrap class="formLabel">Comune</td><td><input type="text" value=""   size="50" name="codiceApiarioDestinazione" required id="codiceApiarioDestinazione" placeholder="DIGITARE IL COMUNE PER CERCARE"></td></tr>
				 <tr><td nowrap class="formLabel">Provincia</td><td><input type="hidden" id="idApiarioIn" name="idBdaApiarioDestinazione" required="required" value=""><input type="text" value=""  size="50"  readonly="readonly" name="provinciaUbicazioneIn" id="provinciaUbicazioneIn"></td></tr>
				 <tr><td nowrap class="formLabel">Indirizzo</td><td><input type="text"  size="50"  value="" readonly="readonly" name="indirizzoUbicazioneIn" required="required" id="indirizzoUbicazioneIn"></td></tr>	
				
				<tr><td nowrap class="formLabel">Latitudine</td><td><input type="text"  size="50"  value="" readonly="readonly" name="latitudine_dest" required id="latitudine_dest"></td></tr>
				 <tr><td nowrap class="formLabel">Longitudine</td><td><input type="text"  size="50"  value="" readonly="readonly" name="longitudine_dest" required id="longitudine_dest"></td></tr>
				
				 <tr><td nowrap class="formLabel">Detentore</td><td><input type="text"  size="50"  value="" readonly="readonly" name="detentoreIn" required id="detentoreIn"></td></tr>	
				 <tr><td nowrap class="formLabel">Codice Fiscale Detentore</td><td><input type="text"  size="50"  value="" readonly="readonly" name="cfDetentoreIn" id="cfDetentoreIn"></td></tr>	
				 <tr><td nowrap class="formLabel">PROGRESSIVO</td><td><input type="text"  size="50"  value="" readonly="readonly" name="progressivoApiarioDestinazione" required id="progressivoIn"></td></tr>	
      <tr><td nowrap class="formLabel">Numero Alverari Presenti</td><td><input type="text"  size="50"  value="" readonly="readonly" name="numApiariDestinazione" required id="numAlveariIn"></td></tr>
    
  </table>
  
  <br>
  
  
 
	</fieldset>
	
	
	
		<input type ="submit" value="SALVA" >
</form>


