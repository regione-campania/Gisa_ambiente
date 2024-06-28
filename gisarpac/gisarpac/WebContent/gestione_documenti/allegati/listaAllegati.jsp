<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
    <%@ include file="../../initPage.jsp"%>
<jsp:useBean id="listaAllegati" class="org.aspcfs.modules.gestioneDocumenti.base.DocumentaleAllegatoList" scope="request"/>
<%@page import="org.aspcfs.modules.gestioneDocumenti.base.DocumentaleAllegato"%>
<%@page import="org.json.JSONObject"%>

<jsp:useBean id="downloadURL" class="java.lang.String" scope="request"/>
<jsp:useBean id="folderId" class="java.lang.String" scope="request"/>
<jsp:useBean id="parentId" class="java.lang.String" scope="request"/>
<jsp:useBean id="grandparentId" class="java.lang.String" scope="request"/>
<jsp:useBean id="jsonEntita" class="java.lang.String" scope="request"/>
<jsp:useBean id="op" class="java.lang.String" scope="request"/>
<jsp:useBean id="nomeCartella" class="java.lang.String" scope="request"/>
<jsp:useBean id="messaggioPost" class="java.lang.String" scope="request"/>
<jsp:useBean id="pag" class="java.lang.String" scope="request"/>
<jsp:useBean id="pagTot" class="java.lang.String" scope="request"/>
<jsp:useBean id="pagine" class="java.lang.String" scope="request"/>

<jsp:useBean id="ImpresaAIADettaglio" class="org.aspcfs.modules.aia.base.ImpresaAIA" scope="request"/>
<jsp:useBean id="StabilimentoAIADettaglio" class="org.aspcfs.modules.aia.base.StabilimentoAIA" scope="request"/>
<jsp:useBean id="ImpresaAUADettaglio" class="org.aspcfs.modules.aua.base.ImpresaAUA" scope="request"/>
<jsp:useBean id="StabilimentoAUADettaglio" class="org.aspcfs.modules.aua.base.StabilimentoAUA" scope="request"/>
<jsp:useBean id="SubparticellaDettaglio" class="org.aspcfs.modules.terreni.base.Subparticella" scope="request"/>


<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*, org.aspcfs.modules.base.*" %>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>

<script type="text/javascript">
function openNewCartella(jsonEntita, folderId, parentId){
	var res;
	var result;
	
		window.open('GestioneAllegatiUpload.do?command=CreaNuovaCartella&folderId='+folderId+'&parentId='+parentId+'&jsonEntita='+jsonEntita+'&new=new','popupSelect',
		'height=410px,width=410px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
	}
</script>

<script type="text/javascript">
function gestioneBoxCaricaFile(){
	var box = document.getElementById('boxCaricaFile');
	if (box.style.display=='none')
		box.style.display='block';
	else
		box.style.display='none';
	}
</script> 
 
<script type="text/javascript">
function gestioneBoxCreaCartella(){
	var box = document.getElementById('boxCreaCartella');
	if (box.style.display=='none')
		box.style.display='block';
	else
		box.style.display='none';
	}
</script> 

<script type="text/javascript">
function deleteCartella(jsonEntita, folderId, parentId, idCartella){
	var res;
	var result;
	
		window.open('GestioneAllegatiUpload.do?command=CreaNuovaCartella&folderId='+folderId+'&parentId='+parentId+'&jsonEntita='+jsonEntita+'&new=new','popupSelect',
		'height=410px,width=410px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
	}
</script> 


  <%! public static String fixData(String timestring)
  {
	  String toRet = "";
	  if (timestring == null || timestring.equals("null"))
		  return toRet;
	  String anno = timestring.substring(0,4);
	  String mese = timestring.substring(5,7);
	  String giorno = timestring.substring(8,10);
	  String ora = timestring.substring(11,13);
	  String minuto = timestring.substring(14,16);
	  String secondi = timestring.substring(17,19);
	  toRet =giorno+"/"+mese+"/"+anno+" "+ora+":"+minuto;
	  return toRet;
	  
  }%>
  <%! public static String fixStringa(String nome)
  {
	  String toRet = nome;
	  if (nome == null || nome.equals("null"))
		  return toRet;
	  toRet = nome.replaceAll("'", "");
	  toRet = toRet.replaceAll(" ", "_");
	  toRet = toRet.replaceAll("\\?","");
	
	  return toRet;
	  
  }%>
  
  	<%-- a href="#" onclick="openNewCartella('<%=orgId%>','<%=folderId%>','<%=parentId%>');"
				id="" target="_self">Crea nuova cartella</a--%>

<%
String obj = ""; 
 String param ="";

if (StabilimentoAIADettaglio!=null && StabilimentoAIADettaglio.getIdStabilimento()>0){
	param = "stabId="+StabilimentoAIADettaglio.getIdStabilimento();
	obj = "StabilimentoAIADettaglio";
}

else if (SubparticellaDettaglio!=null && SubparticellaDettaglio.getId()>0){
	param = "id="+SubparticellaDettaglio.getId();
	obj = "SubparticellaDettaglio";
} else if (StabilimentoAUADettaglio!=null && StabilimentoAUADettaglio.getIdStabilimento()>0){
	param = "stabId="+StabilimentoAUADettaglio.getIdStabilimento();
	obj = "StabilimentoAUADettaglio";
}
%>	

<dhv:container name="<%=op %>" selected="Allegati" object="<%=obj %>" param="<%= param %>">

<%if (!folderId.equals("-1")) {%>
	<form action="GestioneAllegatiUpload.do?command=ListaAllegati" id="formListaCartellaSuperiore" method="post">
	<textarea readonly style="display:none" name="jsonEntita" id ="jsonEntita"><%= jsonEntita%></textarea>
    <input type="hidden" name="folderId" id="folderId" value="<%= parentId %>" />
	<input type="hidden" name="parentId" id="parentId" value="<%= grandparentId %>" /> 
	<input type="hidden" name="op" id="op" value="<%= op %>" /> 
	<a href="#" onClick="document.getElementById('formListaCartellaSuperiore').submit();"> <img src="gestione_documenti/images/parent_folder_icon.png" width="30"/> Cartella superiore</a> </a>
	</form>	
<% } %>  

 <dhv:permission name="documentale_documents-add">
<a href="javascript:gestioneBoxCreaCartella()">
<img src="gestione_documenti/images/new_folder_icon.png" width="30"/>
Crea nuova cartella</a> &nbsp;&nbsp;&nbsp;&nbsp;  

<a href="javascript:gestioneBoxCaricaFile()">
<img src="gestione_documenti/images/new_file_icon.png" width="30"/>  
Carica file</a>
</dhv:permission>

<br/><br/>
 
 <% if (nomeCartella!=null && !nomeCartella.equals("")) {%>
 <table border="1">
 <tr><td><%=nomeCartella.toUpperCase() %></td></tr>
 </table>
<br/>
<%} %>

<div id="boxCreaCartella" style="display:none">
<%@ include file="/gestione_documenti/allegati/newCartella.jsp" %> <br/><br/>
</div>



<div id="boxCaricaFile" style="display:none">
<%@ include file="/gestione_documenti/allegati/uploadFile.jsp" %> <br/><br/>
</div>


<!-- BOX MESSAGGIO -->
<%if (messaggioPost!=null && !messaggioPost.equals("null")) {
	String color="green";
	if (messaggioPost.startsWith("Errore"))
		color="red";
%>

<p style="text-align: center;"><span style="font-size: large; font-family: trebuchet ms,geneva; font-weight: bold; color: <%=color %>; background-color:#ff8">
<%=messaggioPost %>
</span></p>
<%} %>

  <table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <col width="10%">
  <col width="30%">
  <col width="5%">
  <col width="10%">
  <col width="15%">
  

		<tr>
			<th><strong>Codice/ID</strong></th>
			<th><strong>Oggetto</strong></th>
			<th><strong>Tipo</strong></th>
			<th><strong>Data caricamento</strong></th>
			<th><strong>Caricato/creato da</strong></th>
			<th><strong>Gestione</strong></th>
		</tr>
	
			
			<%
	
	if (listaAllegati.size()>0)
		for (int i=0;i<listaAllegati.size(); i++){
			DocumentaleAllegato doc = (DocumentaleAllegato) listaAllegati.get(i);
				
			%>
			
			<%if (doc.isFolder()) {  //SE E UNA CARTELLA%> 
					<tr class="row<%=i%2%>">
			<td>&nbsp;</td> 
			
			<td>
			<img src="gestione_documenti/images/folder_icon.png" width="20"/> 
			<form action="GestioneAllegatiUpload.do?command=ListaAllegati" id="formListaCartella" method="post">
			<textarea readonly style="display:none" name="jsonEntita" id ="jsonEntita"><%= jsonEntita%></textarea>
		    <input type="hidden" name="folderId" id="folderId" value="<%= doc.getIdCartella() %>" />
			<input type="hidden" name="parentId" id="parentId" value="<%= folderId %>" /> 
			<input type="hidden" name="op" id="op" value="<%= op %>" /> 
			<a href="#" onClick="document.getElementById('formListaCartella').submit();"> <%= doc.getNomeDocumento() %> </a> <b>(<%=doc.getContaFile() %>)</b>
			</form>	
			</td>
			 
			<td>CARTELLA</td>
			<td><%= fixData(doc.getDataCreazione()) %></td> 
			<td> </td> 
			
			<td>
			<dhv:permission name="documentale_documents-edit">
			<form action="GestioneAllegatiUpload.do?command=GestisciCartella" id="formRinominaCartella" method="post">
			<textarea readonly style="display:none" name="jsonEntita" id ="jsonEntita"><%= jsonEntita%></textarea>
      		<input type="hidden" name="folderId" id="folderId" value="<%= folderId %>" />
			<input type="hidden" name="parentId" id="parentId" value="<%= parentId %>" /> 
			<input type="hidden" name="op" id="op" value="<%= op %>" /> 
			<input type="hidden" name="operazione" id="operazione" value="rinomina" /> 
			<input type="hidden" name="idCartella" id="idCartella" value="<%= doc.getIdCartella() %>" /> 
			<a href="#" onClick="document.getElementById('formRinominaCartella').submit()"><img src="gestione_documenti/images/rename_folder_icon.png" width="20"/> Rinomina</a>
			</form>
			</dhv:permission> &nbsp;
			<dhv:permission name="documentale_documents-delete">
			<form action="GestioneAllegatiUpload.do?command=GestisciCartella" id="formEliminaCartella" method="post">
			<textarea readonly style="display:none" name="jsonEntita" id ="jsonEntita"><%= jsonEntita%></textarea>
      		<input type="hidden" name="folderId" id="folderId" value="<%= folderId %>" />
			<input type="hidden" name="parentId" id="parentId" value="<%= parentId %>" /> 
			<input type="hidden" name="op" id="op" value="<%= op %>" /> 
			<input type="hidden" name="operazione" id="operazione" value="cancella" /> 
			<input type="hidden" name="idCartella" id="idCartella" value="<%= doc.getIdCartella() %>" /> 
			<a href="#" onClick="if (confirm('ATTENZIONE! Stai per cancellare la cartella e tutto il suo contenuto. Sei sicuro di continuare?')){loadModalWindow(); document.getElementById('formEliminaCartella').submit();} else { return false; }"><img src="gestione_documenti/images/delete_folder_icon.png" width="20"/> Cancella</a>
			</form>
			</dhv:permission>
			</td> 
		
			</tr>
			
			<%} else {%>
			<tr class="row<%=i%2%>">
			<td><%=doc.getIdHeader() %> </td> 
			<td>
			<a href="GestioneAllegatiUpload.do?command=DownloadPDF&codDocumento=<%=doc.getIdHeader()%>&idDocumento=<%=doc.getIdDocumento() %>&tipoDocumento=<%=doc.getTipoAllegato()%>&nomeDocumento=<%=fixStringa(doc.getNomeClient())%>">
			<% if (doc.getEstensione().equalsIgnoreCase("pdf")) {%>
			<img src="gestione_documenti/images/pdf_icon.png" width="20"/>
			<%} else if (doc.getEstensione().equalsIgnoreCase("csv")) { %>
			<img src="gestione_documenti/images/csv_icon.png" width="20"/>
			<%} else if (doc.getEstensione().equalsIgnoreCase("png") || doc.getEstensione().equals("gif") || doc.getEstensione().equals("jpg") || doc.getEstensione().equals("ico")) { %>
			<img src="gestione_documenti/images/img_icon.png" width="20"/>
			<%} else if (doc.getEstensione().equalsIgnoreCase("rar") || doc.getEstensione().equals("zip")) { %>
			<img src="gestione_documenti/images/rar_icon.png" width="20"/>
			<%} else if (doc.getEstensione().contains("xls")) { %>
			<img src="gestione_documenti/images/xls_icon.png" width="20"/>
			<%} else if (doc.getEstensione().contains("doc")) { %>
			<img src="gestione_documenti/images/doc_icon.png" width="20"/>
			<%} else if (doc.getEstensione().contains("p7m")) { %>
			<img src="gestione_documenti/images/p7m_icon.png" width="20"/>
			<%} else { %>
			<img src="gestione_documenti/images/file_icon.png" width="20"/>
			<%} %> 
			<%= doc.getOggetto() %> 
			</a>
			</td> 
			<td><%=(doc.getEstensione()!=null && !doc.getEstensione().equals("null")) ? doc.getEstensione() : "&nbsp;"%></td>
			<td><%= fixData(doc.getDataCreazione()) %></td> 
			<td></td> 
			<td>
			<dhv:permission name="documentale_documents-delete">
			<form action="GestioneAllegatiUpload.do?command=GestisciFile" id="formEliminaFile" method="post">
			<textarea readonly style="display:none" name="jsonEntita" id ="jsonEntita"><%= jsonEntita%></textarea>
      		<input type="hidden" name="folderId" id="folderId" value="<%= folderId %>" />
			<input type="hidden" name="parentId" id="parentId" value="<%= parentId %>" /> 
			<input type="hidden" name="op" id="op" value="<%= op %>" /> 
			<input type="hidden" name="operazione" id="operazione" value="cancella" /> 
			<input type="hidden" name="idFile" id="idFile" value="<%= doc.getIdDocumento() %>" /> 
			<a href="#" onClick="if (confirm('ATTENZIONE! Stai per cancellare definitivamente questo file. Sei sicuro di continuare?')){loadModalWindow(); document.getElementById('formEliminaFile').submit();} else { return false; }"><img src="gestione_documenti/images/delete_file_icon.png" width="20"/> Cancella</a>
			</form>
			</dhv:permission>
			</td>
			</tr>
		<%} %>
			
		<%}  else {%>
					<tr>
			<td colspan="8">Non sono presenti file in questa cartella.</td> 
		</tr>
		<%}%>
		
		</table>
	
</dhv:container>




	<table name="pagine" align="right">	
	<% int pagSel = 1;
		int pagTotali = 1;
	if (pag!=null && !pag.equals("null") && !pag.equals(""))
		pagSel = Integer.parseInt(pag);
	if (pagTot!=null && !pagTot.equals("null") && !pagTot.equals(""))
		pagTotali = Integer.parseInt(pagTot);
		%>
	<tr>
<td>Pagine </td>
	<td>
	
	<%if (pagSel>1){ %>
	<form action="GestioneAllegatiUpload.do?command=ListaAllegati" id="formListaIndietro" method="post">
	<textarea readonly style="display:none" name="jsonEntita" id ="jsonEntita"><%= jsonEntita%></textarea>
    <input type="hidden" name="folderId" id="folderId" value="<%= folderId %>" />
	<input type="hidden" name="parentId" id="parentId" value="<%= parentId %>" /> 
	<input type="hidden" name="op" id="op" value="<%= op %>" /> 
	<input type="hidden" name="pag" id="pag" value="<%=pagSel-1%>" /> 
	<a href="#" onClick="document.getElementById('formListIndietro').submit();"> >> </a>
	</form>	
	<%} %>
	</td>
	
	<td><%=pagSel %></td>
	
	<td>
	<%if (pagSel<pagTotali){ %>
	<form action="GestioneAllegatiUpload.do?command=ListaAllegati" id="formListaAvanti" method="post">
	<textarea readonly style="display:none" name="jsonEntita" id ="jsonEntita"><%= jsonEntita%></textarea>
    <input type="hidden" name="folderId" id="folderId" value="<%= folderId %>" />
	<input type="hidden" name="parentId" id="parentId" value="<%= parentId %>" /> 
	<input type="hidden" name="op" id="op" value="<%= op %>" /> 
	<input type="hidden" name="pag" id="pag" value="<%=pagSel+1%>" /> 
	<a href="#" onClick="document.getElementById('formListaAvanti').submit();"> >> </a>
	</form>	
	<%} %>
	</td>
	
	<td>
	<form action="GestioneAllegatiUpload.do?command=ListaAllegati" id="formListaTutto" method="post">
	<textarea readonly style="display:none" name="jsonEntita" id ="jsonEntita"><%= jsonEntita%></textarea>
    <input type="hidden" name="folderId" id="folderId" value="<%= folderId %>" />
	<input type="hidden" name="parentId" id="parentId" value="<%= parentId %>" /> 
	<input type="hidden" name="op" id="op" value="<%= op %>" /> 
	<input type="hidden" name="pagine" id="pagine" value="no" /> 
	<a href="#" onClick="document.getElementById('formListaTutto').submit();"> (<%=pagTotali%> Tutto</a>)
	</form>
	</td>
	</tr>
	</table>
	
	

<script type="text/javascript">
<!-- aggiornamento pagina per modifica indirizzo in request --> 
   if(window.location.href.substr(-9) !== "&def=true") {
	  loadModalWindow();
	  window.location.href = 'GestioneAllegatiUpload.do?command=ListaAllegati&jsonEntita=<%=jsonEntita%>&folderId=<%=folderId%>&parentId=<%=parentId%>&op=<%=op%>&messaggioPost=<%=messaggioPost%>&pag=<%=pag%>&pagTot=<%=pagTot%>&pagine=<%=pagine%>&def=true';
	  }
</script>


