<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>


<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>

<jsp:useBean id="listaAnagrafiche" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="limit" class="java.lang.String" scope="request"/>

<%@page import="org.aspcfs.modules.gestionexml.base.*"%>

<%@ include file="../initPage.jsp" %>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/spanDisplay.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/confirmDelete.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popURL.js"></SCRIPT>

<script>function refreshLista(form){
	loadModalWindow();
	form.submit();
}</script>

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
   
     <center><b>Lista anagrafiche XML</b></center>
     
     <form id="sel" name="sel" action="GestioneXML.do?command=List&auto-populate=true" method="post">
<div align="right">
<select id="limit" name="limit" onChange="refreshLista(this.form)")>
<option value="10" <%=limit.equals("10") ? "selected" : "" %>>10</option>
<option value="50" <%=limit.equals("50") ? "selected" : "" %>>50</option>
<option value="100" <%=limit.equals("100") ? "selected" : "" %>>100</option>
<option value="-1" <%=limit.equals("-1") ? "selected" : "" %>>Tutte</option>
</select>  
</div>
</form>
<br/>
  		
<table  class="details" width="100%">

		<tr>
			<th>Ragione sociale</th>
			<th>Partita IVA</th>
			<th>Indirizzo sede operativa</th>
			<th>Attivita'</th>
			<th>Operazione</th>
			<th>Inserita da</th>
			<th>Caricamento in anagrafica</th>
			
			
		</tr>
			<%
			
			for (int i=0;i<listaAnagrafiche.size(); i++){
					AnagraficaXML anagrafica = (AnagraficaXML) listaAnagrafiche.get(i);
					
			  %>
			  	<tr class="row<%=i%2%>">
			  	
			  
			<td><%= anagrafica.getImpresaRagioneSociale()%></td> 
			<td><%= anagrafica.getImpresaPartitaIva()%></td> 
			<td><%= anagrafica.getOperativaIndirizzo()%> <%= anagrafica.getOperativaCivico()%> <%= anagrafica.getOperativaDescrizioneComune() %></td> 
			<td>
			<%if (anagrafica.getLineaDescrizione1() != null) { %>
				<li><%= toHtml(anagrafica.getLineaDescrizione1())%> </li><br/>
			<% } %>
			<%if (anagrafica.getLineaDescrizione2() != null) { %>
				<li><%= toHtml(anagrafica.getLineaDescrizione2())%> </li><br/>
			<% } %>
			<%if (anagrafica.getLineaDescrizione3() != null) { %>
				<li><%= toHtml(anagrafica.getLineaDescrizione3())%> </li><br/>
			<% } %>
			<%if (anagrafica.getLineaDescrizione4() != null) { %>
				<li><%= toHtml(anagrafica.getLineaDescrizione4())%> </li><br/>
			<% } %>
			<%if (anagrafica.getLineaDescrizione5() != null) { %>
				<li><%= toHtml(anagrafica.getLineaDescrizione5())%> </li><br/>
			<% } %>
			<%if (anagrafica.getLineaDescrizione6() != null) { %>
				<li><%= toHtml(anagrafica.getLineaDescrizione6())%> </li><br/>
			<% } %>
			<%if (anagrafica.getLineaDescrizione7() != null) { %>
				<li><%= toHtml(anagrafica.getLineaDescrizione7())%> </li><br/>
			<% } %>
			<%if (anagrafica.getLineaDescrizione8() != null) { %>
				<li><%= toHtml(anagrafica.getLineaDescrizione8())%> </li><br/>
			<% } %>
			<%if (anagrafica.getLineaDescrizione9() != null) { %>
				<li><%= toHtml(anagrafica.getLineaDescrizione9())%> </li><br/>
			<% } %>
			<%if (anagrafica.getLineaDescrizione10() != null) { %>
				<li><%= toHtml(anagrafica.getLineaDescrizione10())%> </li><br/>
			<% } %>

			
			</td> 
			<td><%= toHtml(anagrafica.getOperazione()) %></td>
			<td><dhv:username id="<%= anagrafica.getEnteredBy() %>" />  <%=toDateasString(anagrafica.getEntered()) %></td>
			<td> 
			<a href="GestioneXML.do?command=Dettaglio&idAnagraficaXML=<%=anagrafica.getId()%>" title="Elaborazione e completamento del dato per caricamento in anagrafica GISA" style="text-decoration:none"><font size ="3px">[» »]</font></a>
			</td>
			
			</tr> 
			  
			  <%
			}	
	
			%>
					
			
		
	
	</table>
	
	

	
	