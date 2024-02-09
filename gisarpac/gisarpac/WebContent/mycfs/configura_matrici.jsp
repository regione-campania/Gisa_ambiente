
<%@page import="java.util.Iterator"%>
<link rel="stylesheet" type="text/css" href="javascript/jquerypluginTableSorter/css/theme.css"></link>
<script type="text/javascript" src="javascript/jquerypluginTableSorter/jquery.tablesorter.js"></script>
<script type="text/javascript" src="javascript/jquerypluginTableSorter/jquery.tablesorter.widgets.js"></script>
<script type="text/javascript" src="javascript/jquerypluginTableSorter/jquery.tablesorter.pager.js"></script>

<script type="text/javascript" src="javascript/jquerypluginTableSorter/tableJqueryFilterDialogCu.js"></script>

<%@page import="org.aspcfs.modules.dpat.base.PianoMonitoraggio"%><jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="ListaPiani" class="org.aspcfs.modules.programmazzionecu.base.PianoMonitoraggioList" scope="request"/>

<script>

function openPopUp(url)
{

	var res;
	var result;


		window.open(url,null,
		'height=900px,width=900px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=no ,modal=yes');
		
		
		
}
</script>


<table class="trails" cellspacing="0">
<tr>
<td>
Configurazione Matrici - Piani
</td>
</tr>
</table>




<table  class="tablesorter" id="tableConfiguraPiani">
<thead>

<tr class="tablesorter-headerRow" role="row">
		<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRO PER ALIAS" class="filter-match tablesorter-header tablesorter-headerUnSorted"><div class="tablesorter-header-inner">ALIAS</div></th>
		<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRO CODICE" class="filter-match tablesorter-header tablesorter-headerUnSorted"><div class="tablesorter-header-inner">CODICE</div></th>
	<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRO PER PIANO" class="filter-match tablesorter-header tablesorter-headerUnSorted"><div class="tablesorter-header-inner">PIANO DI MON.</div></th>
<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="" class="filter-match tablesorter-header tablesorter-headerUnSorted"><div class="tablesorter-header-inner">CONFIGURAZIONI</div></th>
  
</tr>
</thead>

<tbody aria-relevant="all" aria-live="polite">
<%
	Iterator itPiani =  ListaPiani.iterator();

while (itPiani.hasNext())
{
	PianoMonitoraggio piano = (PianoMonitoraggio) itPiani.next();
	if (piano.getLista_sottopiani().size()>0)
	{
		%>
		<tr>
		<td colspan="1"><%=piano.getDescrizione() %></td>
		
		
	
	</tr>
		
		<%
		
	for (PianoMonitoraggio pfiglio : piano.getLista_sottopiani())
	{
%>
	<tr >
		<td style="margin-left: 20px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=pfiglio.getAlias() %></td>
		<td style="margin-left: 20px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=pfiglio.getCodice()%></td>
		<td style="margin-left: 20px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=pfiglio.getDescrizione() %></td>
		
		<td width="100px"> 
				
				<a href = "#" onclick="javascript:openPopUp('Tree.do?command=ConfigPianiTree&idPiano=<%=pfiglio.getCode() %>&nomeTabella=analiti')">Analiti</a>&nbsp;  
				<a href = "#" onclick="javascript:openPopUp('Tree.do?command=ConfigPianiTree&idPiano=<%=pfiglio.getCode() %>&nomeTabella=matrici')">Matrici </a> 
		
		</td>
	
	</tr>
	
	<%
			}
	}
	else
	{%>
		<tr>
		<td><%=piano.getAlias() %></td>
		<td><%=piano.getCodice() %></td>
		<td><%=piano.getDescrizione() %></td>
			
		<td width="100px"> <a href = "#" onclick="javascript:openPopUp('Tree.do?command=ConfigPianiTree&idPiano=<%=piano.getCode() %>&nomeTabella=analiti')"> Analiti </a>  &nbsp;
			 <a href = "#" onclick="javascript:openPopUp('Tree.do?command=ConfigPianiTree&idPiano=<%=piano.getCode() %>&nomeTabella=matrici')"> Matrici </a> 
			 
		</td>
	
	</tr>
	<%	
	}
	}
	%>
	</tbody>
	
	</table>