<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<jsp:useBean id="listaDocumenti" class="org.aspcfs.modules.gestioneDocumenti.base.DocumentaleDocumentoList" scope="request"/>
<jsp:useBean id="downloadURL" class="java.lang.String" scope="request"/>

<jsp:useBean id="StabilimentoAIADettaglio" class="org.aspcfs.modules.aia.base.StabilimentoAIA" scope="request"/>
<jsp:useBean id="ImpresaAIADettaglio" class="org.aspcfs.modules.aia.base.ImpresaAIA" scope="request"/>

<jsp:useBean id="op" class="java.lang.String" scope="request"/>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<jsp:useBean id="AslList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<%@page import="org.aspcfs.modules.gestioneDocumenti.base.DocumentaleDocumento"%>


<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/spanDisplay.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/confirmDelete.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popURL.js"></SCRIPT>

<link rel="stylesheet" type="text/css" href="javascript/jquerypluginTableSorter/css/theme.css"></link>
<link rel="stylesheet" type="text/css" href="javascript/jquerypluginTableSorter/css/jquery.tablesorter.pages.css"></link>

<script type="text/javascript" src="javascript/jquerypluginTableSorter/jquery.tablesorter.js"></script>
<script type="text/javascript" src="javascript/jquerypluginTableSorter/jquery.tablesorter.pager.js"></script>

<script type="text/javascript" src="javascript/jquerypluginTableSorter/jquery.tablesorter.widgets.js"></script>
<script type="text/javascript" src="javascript/jquerypluginTableSorter/tableJqueryFilterDialogDocumenti.js"></script>


 <%! public static String fixData(String timestring)
  {
	  String toRet = "";
	  if (timestring == null)
		  return toRet;
	  String anno = timestring.substring(0,4);
	  String mese = timestring.substring(5,7);
	  String giorno = timestring.substring(8,10);
	  String ora = timestring.substring(11,13);
	  String minuto = timestring.substring(14,16);
	  String secondi = timestring.substring(17,19);
	  toRet =giorno+"/"+mese+"/"+anno+" "+ora+":"+minuto+":"+secondi;
	  return toRet;
	  
  }%>

    <br>
<% 
String obj = "";
String param ="";
if (op.equals("aia")){
	param = "stabId="+StabilimentoAIADettaglio.getIdStabilimento();
	obj = "StabilimentoAIADettaglio";
}

%>	
  <dhv:container name="<%=op %>" selected="Documenti PDF" object="<%=obj %>"  param="<%= param %>">
  
  			
<div class="pager">
	Page: <select class="gotoPage"></select>		
	<img src="javascript/img/first.png" class="first" alt="First" title="First page" />
	<img src="javascript/img/prev.png" class="prev" alt="Prev" title="Previous page" />
	<img src="javascript/img//next.png" class="next" alt="Next" title="Next page" />
	<img src="javascript/img/last.png" class="last" alt="Last" title= "Last page" />
	<select class="pagesize">
		<option value="10">10</option>
		<option value="20">20</option>
		<option value="30">30</option>
		<option value="40">40</option>
		<option value="<%=listaDocumenti.size()%>">Tutti</option>
		</select> / <%=listaDocumenti.size()%>
</div>
<table  class="tablesorter" id = "tablelistadocumenti">
  
<thead>
		<tr class="tablesorter-headerRow" role="row">
		
		
		<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRA PER CODICE" class="filter-match tablesorter-header tablesorter-headerUnSorted"><div class="tablesorter-header-inner">Codice Doc.</div></th>
			<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRA PER TIPO" class="first-name filter-select"><div class="tablesorter-header-inner">Tipo</div></th>
			<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRA PER INFO" class="sorter-shortDate dateFormat-ddmmyyyy"><div class="tablesorter-header-inner">Info</div></th>
			<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRA PER DATA" class="sorter-shortDate dateFormat-ddmmyyyy"><div class="tablesorter-header-inner">Data creazione</div></th>
			<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRA PER UTENTE" class="filter-match tablesorter-header tablesorter-headerUnSorted"><div class="tablesorter-header-inner">Generato da</div></th>
			<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRO" class="filter-false tablesorter-header tablesorter-headerUnSorted"><div class="tablesorter-header-inner">Recupera</div></th>
		</tr>
	</thead>
	<tbody aria-relevant="all" aria-live="polite">
			
			<%

	if (listaDocumenti.size()>0) {
		for (int i=0;i<listaDocumenti.size(); i++){
			DocumentaleDocumento doc = (DocumentaleDocumento) listaDocumenti.get(i);
			
			%>
			
			<tr>
			<td><%= (doc.getIdHeader()!=null && !doc.getIdHeader().equals("null")) ? doc.getIdHeader() : doc.getIdDocumento() %></td> 
			<td><%= doc.getTipo() %></td> 
			<td><%= (doc.getExtra()!=null && !doc.getExtra().equals("null")) ? doc.getExtra() : "&nbsp;" %></td> 
			<td><%= fixData(doc.getDataCreazione()) %></td> 
			<td> <dhv:username id="<%= doc.getUserId() %>"></dhv:username>
			
			</td> 
			<td>
			
			<a href="GestioneDocumenti.do?command=DownloadPDF&codDocumento=<%=doc.getIdHeader()%>&idDocumento=<%=doc.getIdDocumento() %>"><input type="button" value="DOWNLOAD"></input></a>
			
			</td> 
		</tr>
		<%} } else {%>
		<tr><td colspan="5"> Non sono stati generati documenti.</td></tr>
		
		<% } %>
			</tbody>
	
	</table>
	
	<div class="pager">
	Page: <select class="gotoPage"></select>		
	<img src="javascript/img/first.png" class="first" alt="First" title="First page" />
	<img src="javascript/img/prev.png" class="prev" alt="Prev" title="Previous page" />
	<img src="javascript/img//next.png" class="next" alt="Next" title="Next page" />
	<img src="javascript/img/last.png" class="last" alt="Last" title= "Last page" />
	<select class="pagesize">
		<option value="10">10</option>
		<option value="20">20</option>
		<option value="30">30</option>
		<option value="40">40</option>
		<option value="<%=listaDocumenti.size()%>">Tutti</option>
	</select> / <%=listaDocumenti.size()%>
</div>


		</dhv:container>

</body>
</html>