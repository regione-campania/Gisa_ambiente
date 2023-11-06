<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>

<script type="text/javascript">
function checkFormCartella(formCartella) {
	if (formCartella.nomeCartella.value!=""){
		loadModalWindow();
		formCartella.submit();
		return true;}
	alert("Nome cartella obbligatorio.");
	return false;
	}

</script>
	
	
	<form name="newCartella" action="GestioneAllegatiUpload.do?command=CreaNuovaCartella" method="post">
	
	 <table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
	  <tr>
      <th colspan="2">
        <img border="0" src="images/folder.gif" align="absmiddle"><b> Crea nuova cartella</b>
      </th>
    </tr>
			<tr id="eventoId">
			<td class="formLabel" nowrap>
			<img src="gestione_documenti/images/new_folder_icon.png" width="30"/>  Nome cartella
			</td>
			<td><input type="text" id="nomeCartella" name="nomeCartella" size="50" value=""/> 
			<input type="button" onClick="checkFormCartella(this.form)" value="Crea cartella">
		</td>
		</tr>
			
		</table>
	<input type="hidden" id="orgId" name="orgId" value="<%=orgId%>"/>
	<input type="hidden" id="stabId" name="stabId" value="<%=stabId%>"/>
	<input type="hidden" id="altId" name="altId" value="<%=altId%>"/>
	<input type="hidden" id="ticketId" name="ticketId" value="<%=ticketId%>"/>
	<input type="hidden" id="folderId" name="folderId" value="<%=folderId%>"/>
	<input type="hidden" id="parentId" name="parentId" value="<%=parentId%>"/>
	<input type="hidden" name="op" id="op" value="<%= (String)request.getAttribute("op") %>" />
	
	<%--input type="button"
		value="Annulla"
		onClick="window.location.href='GestioneAllegatiUpload.do?command=ListaAllegati&orgId=<%=request.getParameter("orgId")%>&folderId=<%=request.getParameter("folderId")%>&parentId=<%=request.getParameter("parentId")%>&grandparentId=<%=request.getParameter("grandparentId")%>';this.form.dosubmit.value='false';" /--%>
	
	
	</form>
	
	
	