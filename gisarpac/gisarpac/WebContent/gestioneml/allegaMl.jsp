 <jsp:useBean id="msg" class="java.lang.String" scope="request"/>
 <jsp:useBean id="FlussoList" class="org.aspcfs.utils.web.LookupList" scope="request" />
	
 <% if (msg!=null && !msg.equals("")) {%>
 
 <script>
 alert('<%=msg%>');
 </script>
 
 <%} %>
 
 
 
 <script>       
       function checkFormFile(form){
		var importOk = true;
		var errorString = '';
		
		var fileCaricato = form.file1;

		if (fileCaricato.value=='' || (!fileCaricato.value.toLowerCase().endsWith(".xlsx"))){
		errorString+='Errore! Selezionare un file in formato XSLX! \n';
		form.file1.value='';
		importOk = false;
	}
		
// 		var idFlussoOriginale = form.idFlussoOriginale;
// 		var idFlussoOriginaleTesto = idFlussoOriginale.options[idFlussoOriginale.selectedIndex].text
// 		if (idFlussoOriginale.value=='-1' || idFlussoOriginale.value== ''){
// 			errorString+='Errore! Selezionare un flusso! \n';
// 			importOk = false;
// 		}
		
		if (importOk==false){
			alert(errorString);
			return false;
		}
	
	
	if (!importOk)
		alert(errorString);
	else
	{
		
		if (!confirm("ATTENZIONE! Cliccando OK i record presenti nel file saranno importati secondo il flusso di appartenenza. Proseguire?")){
			return false;
		}
		
	alert("L'import impiegher� diversi minuti.");	
	//form.filename.value = fileCaricato.value;	
	form.uploadButton.hidden="hidden";
	form.file1.hidden="hidden";
	document.getElementById("image_loading").hidden="";
	document.getElementById("text_loading").hidden="";
	loadModalWindow();
	form.submit();
	}
}</script>
 
  
 
 
 <form method="POST" action="GestioneMasterList.do?command=AllegaFile" enctype="multipart/form-data" >
          
          
<table>
<!-- <tr> -->
<!-- <td>Flusso d'origine:</td> -->
<%-- <td><%=FlussoList.getHtmlSelect("idFlussoOriginale", -1)%></td> --%>
<!-- </tr> -->

<tr>
<td>File:</td>
<td><input type="file" name="file1" id="file1"  /> </td>
</tr>

<tr><td colspan="2">
<img id="image_loading" hidden="hidden" src="gestione_documenti/images/loading.gif" height="15"/>
<input type="text" disabled id="text_loading" name="text_loading" hidden="hidden" value="Caricamento in corso..."  style="border: none"/>
<input type="hidden" value="/tmp" name="destination"/>
<input type="button" class="green" value="CONFERMA E INVIA FILE"  id="uploadButton" name="uploadButton"  onClick="checkFormFile(this.form)" />
</td>
</form>