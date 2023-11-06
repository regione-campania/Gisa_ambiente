<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
    <%@ include file="../../initPage.jsp"%>
<jsp:useBean id="listaAllegati" class="org.aspcfs.modules.gestioneDocumenti.base.DocumentaleBachecaList" scope="request"/>
<%@page import="org.aspcfs.modules.gestioneDocumenti.base.DocumentaleBacheca"%>
<jsp:useBean id="downloadURL" class="java.lang.String" scope="request"/>
<jsp:useBean id="folderId" class="java.lang.String" scope="request"/>
<jsp:useBean id="parentId" class="java.lang.String" scope="request"/>
<jsp:useBean id="grandparentId" class="java.lang.String" scope="request"/>
<jsp:useBean id="storeId" class="java.lang.String" scope="request"/>
<jsp:useBean id="nomeCartella" class="java.lang.String" scope="request"/>
<jsp:useBean id="nomeArchivio" class="java.lang.String" scope="request"/>
<jsp:useBean id="messaggioPost" class="java.lang.String" scope="request"/>
<jsp:useBean id="pag" class="java.lang.String" scope="request"/>
<jsp:useBean id="pagTot" class="java.lang.String" scope="request"/>
<jsp:useBean id="pagine" class="java.lang.String" scope="request"/>
<jsp:useBean id="OrgDetails" class="org.aspcf.modules.controlliufficiali.base.Organization" scope="request"/>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,org.aspcfs.modules.opu.base.*, org.aspcfs.modules.base.*, org.aspcfs.modules.registrazioniAnimali.base.*" %>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>

<script type="text/javascript">
function openNewCartella(storeId, folderId, parentId){
	var res;
	var result;
	
		window.open('GestioneBacheca.do?command=CreaNuovaCartella&folderId='+folderId+'&parentId='+parentId+'&storeId='+storeId+'&new=new','popupSelect',
		'height=410px,width=410px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
	}
	
	
function sortTable(tname, ncol) 
{
   var table, rows, switching, i, x, y, shouldSwitch;
   table = document.getElementById(tname);
   switching = true;

   while (switching) 
   {
     switching = false;
     rows = table.rows;

     for (i = 1; i < (rows.length - 1); i++) 
     {
       shouldSwitch = false;
       x = rows[i].getElementsByTagName("TD")[ncol-1];
       y = rows[i + 1].getElementsByTagName("TD")[ncol-1];
       if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) 
       {
         shouldSwitch = true;
         break;
       }
     }
     if (shouldSwitch) {
       rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
       switching = true;
     }
   }
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
function deleteCartella(storeId, folderId, parentId, idCartella){
	var res;
	var result;
	
		window.open('GestioneBacheca.do?command=CreaNuovaCartella&folderId='+folderId+'&parentId='+parentId+'&storeId='+storeId+'&new=new','popupSelect',
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
  
  
  	<%-- a href="#" onclick="openNewCartella('<%=storeId%>','<%=folderId%>','<%=parentId%>');"
				id="" target="_self">Crea nuova cartella</a--%>
	<% String param1 = "storeId=" + storeId;   
%>

		<table class="trails" cellspacing="0">
<tbody><tr>
<td>
<a href="GestioneBacheca.do">Bacheca</a> &gt;
Contenuto archivio
</td>
</tr>
</tbody></table>

<%if (!folderId.equals("-1")){ %>
<a href="GestioneBacheca.do?command=ListaAllegati&storeId=<%=storeId%>&folderId=<%=parentId%>&parentId=<%=grandparentId %>">
<img src="gestione_documenti/images/parent_folder_icon.png" width="30"/>
Cartella superiore</a> &nbsp;&nbsp;&nbsp;&nbsp;  
<%} %>

 <dhv:permission name="documentale_bacheca_cartelle-add">
<a href="javascript:gestioneBoxCreaCartella()">
<img src="gestione_documenti/images/new_folder_icon.png" width="30"/>
Crea nuova cartella</a> &nbsp;&nbsp;&nbsp;&nbsp;  
</dhv:permission>

 <dhv:permission name="documentale_bacheca_files-add">
<a href="javascript:gestioneBoxCaricaFile()">
<img src="gestione_documenti/images/new_file_icon.png" width="30"/>  
Carica file</a>
</dhv:permission>


<br/><br/>
 
 <table border="1" cellspacing="0" align="center">
 <tr><td>
 <img src="gestione_documenti/images/archivio_icon.png" width="20"/>  
  <b><%=nomeArchivio.toUpperCase()%></b> (<a href="GestioneBacheca.do?command=GestisciArchivio&operazione=dettaglioArchivio&storeId=<%=storeId%>">Scheda archivio</a>)<br/>
   <%=nomeCartella.toUpperCase() %></td></tr>
 </table>
<br/>

<div id="boxCreaCartella" style="display:none">
<%@ include file="/gestione_documenti/bacheca/newCartella.jsp" %> <br/><br/>
</div>



<div id="boxCaricaFile" style="display:none">
<%@ include file="/gestione_documenti/bacheca/uploadFile.jsp" %> <br/><br/>
</div>


<div id="boxCreaArchivio" style="display:none">
<%@ include file="/gestione_documenti/bacheca/creaArchivio.jsp" %> <br/><br/>
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


  <table cellpadding="4" cellspacing="0" border="0" width="100%" class="details" id="tabella_allegati">
  <col width="10%">
  <col width="30%">
  <col width="5%">
  <col width="10%">
  <col width="15%">
  

		<tr>
			<th><strong>Codice/ID</strong></th>
			<th><strong>Oggetto</strong></th>
			<th style="display:none;"></th>
			<th><strong>Tipo</strong></th>
			<th><strong>Data caricamento</strong></th>
			<th><strong>Caricato/creato da</strong></th>
			<th><strong>Gestione</strong></th>
		</tr>
	
			
			<%

	if (listaAllegati.size()>0)
		for (int i=0;i<listaAllegati.size(); i++){
			DocumentaleBacheca doc = (DocumentaleBacheca) listaAllegati.get(i);
				
			%>
			
			<%if (doc.isFolder()) {  //SE E UNA CARTELLA%> 
				<tr class="row<%=i%2%>">
			<td>&nbsp;</td> 
			<td>
			<img src="gestione_documenti/images/folder_icon.png" width="20"/> 
			<a href="GestioneBacheca.do?command=ListaAllegati&storeId=<%=storeId%>&folderId=<%=doc.getIdCartella()%>&parentId=<%=folderId%>&pagine=no"><%= doc.getNomeDocumento() %></a> <b>(<%=doc.getContaFile() %>)</b>  </td> 
			<td style="display:none;"><%=" " + doc.getNomeDocumento()%></td> 
			<td>CARTELLA</td>
			<td><%= fixData(doc.getDataCreazione()) %></td> 
			<td> <dhv:username id="<%= doc.getUtenteInserimento() %>" /></td> 
			<td>
			<dhv:permission name="documentale_bacheca_cartelle-edit">
			<a href="GestioneBacheca.do?command=GestisciCartella&storeId=<%=storeId%>&folderId=<%=folderId%>&parentId=<%=parentId%>&operazione=rinomina&idCartella=<%=doc.getIdCartella() %>&nomeCartella=<%=doc.getNomeDocumento()%>">
<img src="gestione_documenti/images/rename_folder_icon.png" width="20"/> Rinomina</a>
</dhv:permission> &nbsp;
<dhv:permission name="documentale_bacheca_cartelle-delete">
	<a href="GestioneBacheca.do?command=GestisciCartella&storeId=<%=storeId%>&folderId=<%=folderId%>&parentId=<%=parentId%>&idCartella=<%=doc.getIdCartella()%>&operazione=cancella" onCLick="if(confirm('ATTENZIONE! Stai per cancellare definitivamente la cartella e il suo contenuto. Sei sicuro di continuare?')) { loadModalWindow(); return true;}">
<img src="gestione_documenti/images/delete_folder_icon.png" width="20"/> Cancella</a>
</dhv:permission>
</td> 
		
		</tr>
			
			<%} else {%>
			<tr class="row<%=i%2%>">
			<td><%= doc.getIdHeader() %> </td> 
			<td>
			<a href="GestioneBacheca.do?command=DownloadPDF&codDocumento=<%=doc.getIdHeader()%>&idDocumento=<%=doc.getIdDocumento() %>&tipoDocumento=<%=doc.getEstensione()%>&nomeDocumento=<%=fixStringa(doc.getNomeClient()) %>">
			<% if (doc.getEstensione().equalsIgnoreCase("pdf")) {%>
			<img src="gestione_documenti/images/pdf_icon.png" width="20"/>
			<%} else if (doc.getEstensione().equalsIgnoreCase("csv")) { %>
			<img src="gestione_documenti/images/csv_icon.png" width="20"/>
			<%} else if (doc.getEstensione().equalsIgnoreCase("png") || doc.getEstensione().equals("gif") || doc.getEstensione().equals("jpg") || doc.getEstensione().equals("ico")) { %>
			<img src="gestione_documenti/images/img_icon.png" width="20"/>
			<%} else if (doc.getEstensione().equalsIgnoreCase("rar") || doc.getEstensione().equals("zip")) { %>
			<img src="gestione_documenti/images/rar_icon.png" width="20"/>
			<%} else if (doc.getEstensione().equals("xls")) { %>
			<img src="gestione_documenti/images/xls_icon.png" width="20"/>
			<%} else if (doc.getEstensione().equals("doc")) { %>
			<img src="gestione_documenti/images/doc_icon.png" width="20"/>
			<%} else if (doc.getEstensione().contains("p7m")) { %>
			<img src="gestione_documenti/images/p7m_icon.png" width="20"/>
			<%} else { %>
			<img src="gestione_documenti/images/file_icon.png" width="20"/>
			<%} %> 
			<%= doc.getOggetto() %> 
			</a>
			</td> 
			<td style="display:none;"><%=((doc.getOggetto().toLowerCase().contains("procedure documentate sintetiche 2019_tabelle"))?("  " + doc.getOggetto()):(doc.getOggetto()))%></td> 
			<td><%=(doc.getEstensione()!=null && !doc.getEstensione().equals("null")) ? doc.getEstensione() : "&nbsp;"%></td>
			<td><%= fixData(doc.getDataCreazione()) %></td> 
			<td> <dhv:username id="<%= doc.getUtenteInserimento() %>" /></td> 
			<td>
			<dhv:permission name="documentale_bacheca_files-delete">
			<a href="GestioneBacheca.do?command=GestisciFile&storeId=<%=storeId%>&folderId=<%=folderId%>&parentId=<%=parentId%>&idFile=<%=doc.getIdDocumento()%>&operazione=cancella" onCLick="if(confirm('ATTENZIONE! Stai per cancellare definitivamente questo file. Sei sicuro di continuare?')) { loadModalWindow(); return true;}">
<img src="gestione_documenti/images/delete_file_icon.png" width="20"/> Cancella</a>
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
	<a href="GestioneBacheca.do?command=ListaAllegati&storeId=<%=storeId%>&folderId=<%=folderId%>&parentId=<%=parentId%>&pag=<%=pagSel-1%>"><%= "<<" %></a>
	<%} %>
	</td>
	
	<td><%=pagSel %></td>
	
	<td>
	<%if (pagSel<pagTotali){ %>
	<a href="GestioneBacheca.do?command=ListaAllegati&storeId=<%=storeId%>&folderId=<%=folderId%>&parentId=<%=parentId%>&pag=<%=pagSel+1%>"><%= ">>" %></a>
	<%} %>
	</td>
	
	<td>(<%=pagTotali%> <a href="GestioneBacheca.do?command=ListaAllegati&storeId=<%=storeId%>&folderId=<%=folderId%>&parentId=<%=parentId%>&pagine=no"><%= "Tutto" %></a>)</td></tr></table>

<script type="text/javascript">
<!-- aggiornamento pagina per modifica indirizzo in request --> 
   if(window.location.href.substr(-9) !== "&def=true") {
	  loadModalWindow();
	  window.location.href = 'GestioneBacheca.do?command=ListaAllegati&storeId=<%=storeId%>&folderId=<%=folderId%>&parentId=<%=parentId%>&pag=<%=pag%>&pagTot=<%=pagTot%>&pagine=<%=pagine%>&messaggioPost=<%=messaggioPost%>&def=true';
	  
    }
   sortTable('tabella_allegati', 3);
</script>
