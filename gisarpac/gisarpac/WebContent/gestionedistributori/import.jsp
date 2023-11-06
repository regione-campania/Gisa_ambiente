<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery-1.8.2.js"></script>
<script src="javascript/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>
<link rel="stylesheet" href="gestionedistributori/css/screen.css" type="text/css" media="screen" />

<DIV ID='modalWindow' CLASS='unlocked'><P CLASS='wait'>Attendere il completamento dell'operazione...</P></DIV>

<jsp:useBean id="riferimentoId" class="java.lang.String" scope="request"/>
<jsp:useBean id="riferimentoIdNomeTab" class="java.lang.String" scope="request"/>

<!-- RELATIVO AL NUOVO CALENDARIO CON MESE E ANNO FACILMENTE MODIFICABILI -->
  <script>
       
       function checkFormFile(form){
    	   
		var importOk = true;
		var errorString = '';
		
		var fileCaricato = form.file;

		if (fileCaricato.value=='' || (!fileCaricato.value.toLowerCase().endsWith(".xls") && !fileCaricato.value.toLowerCase().endsWith(".xlsx"))){
		errorString+='Errore! Selezionare un file in formato XLS o XLSX!';
		form.file.value='';
		importOk = false;
	}
		
		if (importOk==false){
			alert(errorString);
			return false;
		}
	
	if (!importOk)
		alert(errorString);
	else
	{
		
		if (!confirm("ATTENZIONE! Proseguire?")){
			return false;
		}
		
	form.uploadButton.hidden="hidden";
	form.file.hidden="hidden";
	document.getElementById("image_loading").hidden="";
	document.getElementById("text_loading").hidden="";
	loadModalWindow();
	form.submit();
	}
}</script>


<jsp:useBean id="msg" class="java.lang.String" scope="request" />


<%if (msg!=null && !msg.equals("") && !msg.equals("null")) {%>
<script>
alert("<%=msg%>");
</script>
<%} %>

<b>Caricamento massivo distributori</b> 

<form method="POST" action="GestioneDistributori.do?command=Import" enctype="multipart/form-data" >

<table class="details">


 <tr>
 <td class="formLabel">File</td>
 
 <td>
 
 <input type="file" name="file" id="file"  /> 
 <img id="image_loading" hidden="hidden" src="gestione_documenti/images/loading.gif" height="15"/>
 <input type="text" disabled id="text_loading" name="text_loading" hidden="hidden" value="Caricamento in corso..."  style="border: none"/>
 <input type="hidden" value="/tmp" name="destination"/>
  <input type="hidden" name="riferimentoId" id="riferimentoId" value="<%=riferimentoId %>"  /> 
  <input type="hidden" name="riferimentoIdNomeTab" id="riferimentoIdNomeTab" value="<%=riferimentoIdNomeTab %>" /> 
 
 </td>
 </tr>
 
 <tr>
 <td colspan="2" class="formLabel">
 
 <input type="button" value="CONFERMA E INVIA FILE"  id="uploadButton" name="uploadButton"  onClick="checkFormFile(this.form)" />
 
 </td>
 </tr>
 </table>
 
</form>

<b>Attenzione.</b><br/>
Le matricole non presenti nel sistema verranno inserite con i dati riportati nel relativo record del file.<br/>
Le matricole presenti nel sistema, ma gia' associate ad altre anagrafiche, non verranno inserite.<br/>
Le matricole presenti nel sistema, se associate a questa anagrafica, verranno aggiornate con i dati riportati nel relativo record del file.<br/><br/><br/>


<a href="#" onClick="window.open('gestionedistributori/allegati/file_di_esempio_distributori.xlsx')">Scarica file di esempio</a> 

<center>
<input type="button" class="blueBigButton" value="ANNULLA" onClick="window.location.href='GestioneDistributori.do?command=View&riferimentoId=<%=riferimentoId %>&riferimentoIdNomeTab=<%=riferimentoIdNomeTab %>'"></center>

