


<%@page import="java.util.ArrayList"%>
<%@page import="org.aspcfs.modules.dpat.base.DpatIndicatore"%>



<script type="text/javascript" src="javascript/jquery.miny_1.7.2.js"></script>
<script   src="javascript/jquery-ui.js"></script>

<%@ include file="../initPage.jsp"%>


<link rel="stylesheet" type="text/css" href="css/jquery-ui-1.9.2.custom.css" />
 
<link rel="stylesheet" type="text/css" href="javascript/jquerypluginTableSorter/css/theme.css"></link>
<link rel="stylesheet" type="text/css" href="javascript/jquerypluginTableSorter/css/jquery.tablesorter.pages.css"></link>

<script type="text/javascript" src="javascript/jquerypluginTableSorter/jquery.tablesorter.js"></script>
<script type="text/javascript" src="javascript/jquerypluginTableSorter/jquery.tablesorter.pager.js"></script>

<script type="text/javascript" src="javascript/jquerypluginTableSorter/jquery.tablesorter.widgets.js"></script>
<script type="text/javascript" src="javascript/jquerypluginTableSorter/tableJqueryFilterDialogRichiesteDaValidare.js"></script>

<%

DpatIndicatore ind = (DpatIndicatore)request.getAttribute("DettaglioIndicatore");

ArrayList<DpatIndicatore> storia = ind.getStoriaIndicatore();
%>



<%=storia.size() %>




  	<table id ="tableRichiesteDaValidare" class="tableSorter">
  		<thead>
  			
  			
  			<tr class="tablesorter-headerRow" role="row">
  			<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRA PER ID RICHIESTA" class="filter-match tablesorter-header tablesorter-headerUnSorted"><div class="tablesorter-header-inner">ANNO</div></th>
  			<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRA PER ID RICHIESTA" class="filter-match tablesorter-header tablesorter-headerUnSorted"><div class="tablesorter-header-inner">SEZIONE</div></th>
  			<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRA PER ID RICHIESTA" class="filter-match tablesorter-header tablesorter-headerUnSorted"><div class="tablesorter-header-inner">PIANO</div></th>
  			<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRA PER ID RICHIESTA" class="filter-match tablesorter-header tablesorter-headerUnSorted"><div class="tablesorter-header-inner">ATTIVITA</div></th>
  			<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRA PER ID RICHIESTA" class="filter-match tablesorter-header tablesorter-headerUnSorted"><div class="tablesorter-header-inner">INDICATORE</div></th>
  			<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRA PER ID RICHIESTA" class="filter-match tablesorter-header tablesorter-headerUnSorted"><div class="tablesorter-header-inner">ALIAS</div></th>
  			<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRA PER ID RICHIESTA" class="filter-match tablesorter-header tablesorter-headerUnSorted"><div class="tablesorter-header-inner">CODICE</div></th>

  			<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRA PER ID RICHIESTA" class="filter-match tablesorter-header tablesorter-headerUnSorted"><div class="tablesorter-header-inner">ATTIVO AL</div></th>

	</tr>
	</thead>
	
		<tbody aria-relevant="all" aria-live="polite">
		
		<%
		for (DpatIndicatore indicatore : storia)
		{
			%>
			<tr>
			<td><%=indicatore.getAnnoRiferimento() %></td>
			<td><%=indicatore.getDescrizioneSezione() %></td>
			<td><%= toHtml(indicatore.getAliasPiano()) %></td>
			<td><%=indicatore.getDescrizioneAttivita() %></td>
			<td><%=indicatore.getDescription() %></td>
			<td><%=indicatore.getAlias() %></td>
<td><%=indicatore.getCodiceAlias() %></td>
			
			<td><%=(indicatore.getDataScadenza()!= null) ?indicatore.getDataScadenza()+"" : indicatore.getAnnoRiferimento()+"" %></td>
			
			</tr>
			
			<%
		}
		%>
		</tbody>


</table>
	
	