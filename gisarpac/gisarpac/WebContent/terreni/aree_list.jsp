<%@ page import="java.util.ArrayList" %>
<%@ page import="org.aspcfs.modules.terreni.base.*" %>
<%
	ArrayList<Area> listaAree =  (ArrayList<Area>)request.getAttribute("listaAree");
%>

<link rel="stylesheet" type="text/css"
	href="javascript/jquerypluginTableSorter/css/theme.css"></link>
<link rel="stylesheet" type="text/css"
	href="javascript/jquerypluginTableSorter/css/jquery.tablesorter.pages.css"></link>
<script type="text/javascript"
	src="javascript/jquerypluginTableSorter/jquery.tablesorter.js"></script>
<script type="text/javascript"
	src="javascript/jquerypluginTableSorter/jquery.tablesorter.pager.js"></script>
<script type="text/javascript"
	src="javascript/jquerypluginTableSorter/jquery.tablesorter.widgets.js"></script>
<script type="text/javascript"
	src="javascript/jquerypluginTableSorter/tableJqueryFilterOpu.js"></script>
<script src="javascript/jquery.searchable-1.0.0.min.js"></script>


<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Terreni.do?command=toSearchArea">Terra dei fuochi</a> > 
Ricerca Area
</td>
</tr>
</table>
<br/>

<div class="pager">
	Page: <select class="gotoPage"></select>		
	<img src="javascript/img/first.png" class="first" alt="First" title="First page" />
	<img src="javascript/img/prev.png" class="prev" alt="Prev" title="Previous page" />
	<img src="javascript/img//next.png" class="next" alt="Next" title="Next page" />
	<img src="javascript/img/last.png" class="last" alt="Last" title= "Last page" />
	<select class="pagesize">
		<option value="10">10</option>
		<option value="25">25</option>
		<option value="50">50</option>
	</select>
</div>

<table class="tablesorter">
<thead>
<tr class="tablesorter-headerRow" role="row">
	<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" class="filter-false tablesorter-header tablesorter-headerUnSorted">
		<div class="tablesorter-header-inner">Codice Sito</div></th>
	<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" class="filter-false tablesorter-header tablesorter-headerUnSorted">
		<div class="tablesorter-header-inner">Provincia</div></th>
	<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" class="filter-match tablesorter-header tablesorter-headerUnSorted">
		<div class="tablesorter-header-inner">Comune</div></th>
	<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" class="filter-match tablesorter-header tablesorter-headerUnSorted">
		<div class="tablesorter-header-inner">Foglio</div></th>
	<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" class="filter-match tablesorter-header tablesorter-headerUnSorted">
		<div class="tablesorter-header-inner">Particella</div></th>
	<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" class="filter-false tablesorter-header tablesorter-headerUnSorted">
		<div class="tablesorter-header-inner">Area (mq)</div></th>
</tr>
</thead>
<tbody aria-relevant="all" aria-live="polite">
<%
	if(listaAree.size() > 0){
		for(Area area : listaAree){
%>
					<tr>
						<td><a href="Terreni.do?command=DetailsArea&id=<%= area.getId() %>" ><%= area.getCodiceSito() %></a></td>
						<td><%= area.getDescrizioneProvincia() %></td>					
						<td><%= area.getDescrizioneComune() %></td>					
						<td><%= area.getFoglioCatastale()%></td>					
						<td><%= area.getParticellaCatastale() %></td>						
						<td><%= area.getArea() %></td>
					</tr>
		<% 			}
				}else{
		%>
				<tr><td colspan="6">NESSUNA AREA TROVATA</td></tr>
		<%
				}
%>
</tbody>
</table>