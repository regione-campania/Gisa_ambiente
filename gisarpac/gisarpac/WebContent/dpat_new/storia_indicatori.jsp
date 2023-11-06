


<%@page import="org.aspcfs.modules.dpatnew.base.DpatIndicatoreNewBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.aspcfs.modules.dpat.base.DpatIndicatore"%>
<%@page import="org.aspcfs.modules.dpatnew_interfaces.*" %>



<script type="text/javascript" src="javascript/jquery.miny_1.7.2.js"></script>
<script   src="javascript/jquery-ui.js"></script>

<%@include file="../initPage.jsp" %>


<link rel="stylesheet" type="text/css" href="css/jquery-ui-1.9.2.custom.css" />
 
<link rel="stylesheet" type="text/css" href="javascript/jquerypluginTableSorter/css/theme.css"></link>
<link rel="stylesheet" type="text/css" href="javascript/jquerypluginTableSorter/css/jquery.tablesorter.pages.css"></link>

<script type="text/javascript" src="javascript/jquerypluginTableSorter/jquery.tablesorter.js"></script>
<script type="text/javascript" src="javascript/jquerypluginTableSorter/jquery.tablesorter.pager.js"></script>

<script type="text/javascript" src="javascript/jquerypluginTableSorter/jquery.tablesorter.widgets.js"></script>
<script type="text/javascript" src="javascript/jquerypluginTableSorter/tableJqueryFilterDialogRichiesteDaValidare.js"></script>

<%@page import="java.util.ArrayList,org.servlet.*" %>
<jsp:useBean id="alIndicatori" class="java.util.ArrayList" scope="request" />
<jsp:useBean id="piano" class="org.aspcfs.modules.dpatnew.base.DpatPianoAttivitaNewBean" scope="request" />
<jsp:useBean id="sezione" class="org.aspcfs.modules.dpatnew.base.DpatSezioneNewBean" scope="request" />

<%--
<%

DpatIndicatore ind = (DpatIndicatore)request.getAttribute("DettaglioIndicatore");

ArrayList<DpatIndicatore> storia = ind.getStoriaIndicatore();
--%>

 
	<center>
	<font size="2px" style="color: red; font-weight: bold;" >
		versioni per INDICATORE codice univoco <u><%=((DpatIndicatoreNewBeanAbstract)alIndicatori.get(0)).getCodiceAliasIndicatore() %></u>
	</font>
	</center>

  	<table id ="tableRichiesteDaValidare" class="tableSorter">
  		<thead>
  			
  			
  			<tr class="tablesorter-headerRow" role="row">
  			<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRA PER ID RICHIESTA" class="filter-match tablesorter-header tablesorter-headerUnSorted"><div class="tablesorter-header-inner">ANNO</div></th>
  			<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRA PER ID RICHIESTA" class="filter-match tablesorter-header tablesorter-headerUnSorted"><div class="tablesorter-header-inner">DESCRIZIONE</div></th>
  			<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRA PER ID RICHIESTA" class="filter-match tablesorter-header tablesorter-headerUnSorted"><div class="tablesorter-header-inner">CODICE UNIVOCO PIANO/ATTIVITA PADRE</div></th>
  			<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRA PER ID RICHIESTA" class="filter-match tablesorter-header tablesorter-headerUnSorted"><div class="tablesorter-header-inner">ATTIVO AL</div></th>

	</tr>
	</thead>
	
		<tbody aria-relevant="all" aria-live="polite">
		
		<%-- <%
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
		%> --%>
		
		<%
		for (Object bean : alIndicatori)
		{
			DpatIndicatoreNewBeanAbstract beanInd = (DpatIndicatoreNewBeanAbstract)bean;
			String descrSezMadre = beanInd.getDescrSezMadre();
			String descrPianoAttivitaPadre = beanInd.getDescrPianoAttivitaPadre();
			 
			
			%>
				 
			<tr>
			<td><%=beanInd.getAnno() %></td>
			<td><font color="orange"><%=descrSezMadre %></font><br>
				<font color="green"><%=descrPianoAttivitaPadre %></font><br>
				<font color="blue"><b>> </b><%=beanInd.getDescrizione() %></font><br>
			</td>
			<td><%= piano.getCodiceAliasAttivita()%></td>
			<td><%=(beanInd.getScadenza()!= null) ? toDateasString(beanInd.getScadenza()) : beanInd.getAnno()+"" %></td>
			
			</tr>
			<%
		}
		%>
		</tbody>


</table>
	
	