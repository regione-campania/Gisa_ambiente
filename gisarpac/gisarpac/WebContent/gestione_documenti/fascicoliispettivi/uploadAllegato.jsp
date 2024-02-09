  <%
       int maxFileSize=-1;
	   int mb1size = 1048576;
	    maxFileSize=Integer.parseInt(org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("MAX_SIZE_ALLEGATI"));
	   	String maxSizeString = String.format("%.2f", (double) maxFileSize/ (double) mb1size);
       %>
       
       <script>function checkFormFile(form){
	var fileCaricato = form.file1;
	var oggetto = form.subject.value;
	var errorString = '';
	if (fileCaricato.value=='' || !fileCaricato.value.endsWith(".pdf")){  // && !fileCaricato.value.endsWith(".csv"))){
		errorString+='Errore! Selezionare un file in formato PDF!';
		form.file1.value='';
	}
	if (oggetto==''){
		errorString+='\nErrore! L\'oggetto è obbligatorio.';
		}
	if (!GetFileSize(form.file1))
		errorString+='\nErrore! Selezionare un file con dimensione inferiore a <%=maxSizeString%> MB';
	if (errorString!= '')
		alert(errorString)
	else
	{
	//form.filename.value = fileCaricato.value;	
	form.uploadButton.hidden="hidden";
	form.file1.hidden="hidden";
	document.getElementById("image_loading").hidden="";
	document.getElementById("text_loading").hidden="";
	//loadModalWindow();
	form.submit();
	}
}</script>

<script>function GetFileSize(fileid) {
	var input = document.getElementById('file1');
        file = input.files[0];
        if (file.size> <%=Integer.parseInt(org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("MAX_SIZE_ALLEGATI"))%>)
      	 	return false;
        return true;
		}
</script>

<%@ include file="../../initPage.jsp" %>
  
 <script src='javascript/modalWindow.js'></script>
 
 <%if ((String) request.getAttribute("messaggioPost")!=null ) {%>
 <font color="red"><%=(String) request.getAttribute("messaggioPost") %></font>
 <%} %>

<form id="form2" action="GestioneAllegatiFascicoliIspettivi.do?command=AllegaFile" method="post" name="form2" enctype="multipart/form-data">
 <table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
    <tr>
      <th colspan="2">
        <img border="0" src="images/file.gif" align="absmiddle"><b>Allega un nuovo file</b>
      </th>
    </tr>
    <tr class="containerBody">
      <td class="formLabel">
        Oggetto
      </td>
      <td>
        <input type="text" readonly name="subject" size="59" maxlength="255" value="RAPPORTO CONCLUSIVO FASCICOLO ISPETTIVO"><font color="red">*</font>
        <%= showAttribute(request, "subjectError") %>
      </td>
    </tr>
      <tr class="containerBody">
      <td class="formLabel">
        <dhv:label name="contacts.companydirectory_confirm_importupload.File">File</dhv:label>
       
       
       (Max. <%=maxSizeString %> MB)
       
      </td>
      <td>
        <input type="file" id="file1" name="file1" size="45">  <input type="button" id="uploadButton" name="uploadButton" value="UPLOAD" onclick="checkFormFile(this.form)" />
      
          <img id="image_loading" hidden="hidden" src="gestione_documenti/images/loading.gif" height="15"/>
          <input type="text" disabled id="text_loading" name="text_loading" hidden="hidden" value="Caricamento in corso..."  style="border: none"/>
      </td>
    </tr>
     <textarea readonly style="display:none" name="jsonEntita" id ="jsonEntita"><%= (String)request.getAttribute("jsonEntita")%></textarea>
      <% String tipo = request.getParameter("tipo");
     if (tipo==null)
     tipo = (String) request.getAttribute("tipo");%>
       <input type="hidden" name="tipoAllegato" id ="tipoAllegato" value="<%=tipo%>" />
      </table>
   </form>
   <p align="center">
    * File di grandi dimensioni possono richiedere tempo per essere caricati.<br/>
    Aspetta il messaggio di avvenuto caricamento quando l'operazione è completata.
  </p>
 