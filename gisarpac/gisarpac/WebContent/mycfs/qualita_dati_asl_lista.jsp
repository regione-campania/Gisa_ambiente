<jsp:useBean id="tipo" class="java.lang.String" scope="request"/>
<jsp:useBean id="listaElementi" class="java.util.ArrayList" scope="request"/>

 <%@ include file="../initPage.jsp" %>
 
<% if (tipo.equals("1")) { %>
<table class="details" width="100%">

<tr><th colspan="4"> CONTROLLI UFFICIALI APERTI </th></tr>

<tr>
<th> ID CONTROLLO</th>
<th> RAGIONE SOCIALE</th>
<th> Tecnica del controllo ufficiale</th>
<th> DATA CONTROLLO</th>

</tr>

<% for (int i = 0; i<listaElementi.size(); i++){ 
String elemento = (String) listaElementi.get(i);
String elem[] = elemento.split(";;");
%>
<tr>
<%-- <td> <a href="#" onClick="window.open('GlobalSearch.do?command=Search&searchcodeTipologiaAttivita=3&tipoRicerca=cu&searchOpCancellati=no_trashed&searchAttCancellati=no_trashed&searchEsito=non_esito&searchAccountIdentificativo=<%=elem[0]%>').focus()"><%=elem[0]%></a></td> --%>
<td> <%=elem[0] %></td>
<td> <%=elem[1] %></td>
<td> <%=elem[2] %></td>
<td> <%=toDateasStringfromString(elem[3]) %></td>
</tr>

<% } %>
</table>
<% } else if (tipo.equals("2")) { %>
<table class="details" width="100%">

<tr><th colspan="4"> CONTROLLI UFFICIALI IN SORVEGLIANZA SENZA CHECKLIST </th></tr>

<tr>
<th> ID CONTROLLO</th>
<th> RAGIONE SOCIALE</th>
<th> Tecnica del controllo ufficiale</th>
<th> DATA CONTROLLO</th>
</tr>

<% for (int i = 0; i<listaElementi.size(); i++){ 
String elemento = (String) listaElementi.get(i);
String elem[] = elemento.split(";;");
%> 
<tr>
<%-- <td> <a href="#" onClick="window.open('GlobalSearch.do?command=Search&searchcodeTipologiaAttivita=3&tipoRicerca=cu&searchOpCancellati=no_trashed&searchAttCancellati=no_trashed&searchEsito=non_esito&searchAccountIdentificativo=<%=elem[0]%>').focus()"><%=elem[0]%></a></td> --%>
<td> <%=elem[0] %></td>
<td> <%=elem[1] %></td>
<td> <%=elem[2] %></td>
<td> <%=toDateasStringfromString(elem[3]) %></td> 
</tr>
<% } %>
</table>
<% } else if (tipo.equals("3")) { %>
<table class="details" width="100%" >

<tr><th colspan="3"> ERRATA CORRIGE INVIATE NEL MESE PRECEDENTE</th></tr>

<tr>
<th> DATA</th>
<th> RAGIONE SOCIALE</th>
<th> NUMERO REGISTRAZIONE</th>
</tr>

<% for (int i = 0; i<listaElementi.size(); i++){ 
String elemento = (String) listaElementi.get(i);
String elem[] = elemento.split(";;");
%>
<tr>
<td> <%=toDateasStringfromString(elem[0]) %></td> 
<td> <%=elem[1] %></td>
<td> <%=elem[2] %></td></tr>
<% } %>
</table>
<% } else if (tipo.equals("4")) { %>
<table class="details" width="100%" >

<tr><th colspan="5"> ERRATA CORRIGE ARTICOLO 17 INVIATE NEL MESE PRECEDENTE</th></tr>

<tr>
<th> DATA</th>
<th> RAGIONE SOCIALE</th>
<th> APPROVAL NUMBER</th>
<th> IDENTIFICATIVO</th>
<th> TIPO</th>

</tr>

<% for (int i = 0; i<listaElementi.size(); i++){ 
String elemento = (String) listaElementi.get(i);
String elem[] = elemento.split(";;");
%>
<tr>
<td> <%=toDateasStringfromString(elem[0]) %></td> 
<td> <%=elem[1] %></td>
<td> <%=elem[2] %></td>
<td> <%=elem[3] %></td>
<td> <%=elem[4] %></td></tr>
<% } %>
</table>

<% } %>
