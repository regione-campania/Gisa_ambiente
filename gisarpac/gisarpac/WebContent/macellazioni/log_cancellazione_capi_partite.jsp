<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>

<%@page import="org.aspcfs.modules.macellazioni.base.LogCancellazioneCapiPartite"%>

<%@ include file="../initPage.jsp"%>


<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/spanDisplay.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/confirmDelete.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popURL.js"></SCRIPT>

  
 
  <% ArrayList<LogCancellazioneCapiPartite> lista = (ArrayList<LogCancellazioneCapiPartite>) request.getAttribute("listaCapiPartiteCancellati"); %>
  
  
  <h4>Log cancellazione capi e partite</h4>
  <br/><br/>
  
  <table class="details" width="100%" cellpadding="4">
  
  <tr>
  <th> Tipo </th>
  <th> Matricola/Numero</th>
  <th> Operazione </th>
  <th> Data </th>
  <th> Note </th>
  <th> Utente </th>
  </tr>
  
  
  <% for (int i = 0; i<lista.size(); i++) { 
	  LogCancellazioneCapiPartite log = (LogCancellazioneCapiPartite) lista.get(i);
  %>
  <tr class="row<%=i%2%>">
  <td><%=(log.getIdCapo()>0) ? "Capo" : "Partita" %></td>
  <td><%=(log.getIdCapo()>0) ? log.getMatricola() : log.getNumero() %></td> 
  <td><%=log.getTipoOperazione()%></td>
  <td><%=toDateasStringWitTime(log.getDataOperazione())%></td>
  <td><%=(log.getNote()!=null) ? log.getNote() : "" %></td>
  <td> <dhv:username id="<%= log.getIdUtente() %>"></dhv:username></td>
  </tr>
   <%} %>
  
  
  
  
  
  </table>
  
  
  

</body>
</html>