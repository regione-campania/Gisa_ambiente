<jsp:useBean id="tipo" class="java.lang.String" scope="request"/>
<jsp:useBean id="listaControlli" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="SiteList" class="org.aspcfs.utils.web.LookupList" scope="request"/>

 <%@ include file="../initPage.jsp" %>
 
 <%
 	if(listaControlli.isEmpty())
 	{
 %>
 		Nessun controllo trovato
 <% 	
 	}
 	else
 	{	
 %>
<table class="details" width="100%">

<tr><th colspan="5"> CONTROLLI UFFICIALI PER ACQUACOLTURA </th></tr>

<tr>
<th> ID CONTROLLO</th>
<th> ASL</th>
<th> PIANO DI MONITORAGGIO</th>
<th> DATA CONTROLLO</th>

</tr>

<% for (int i = 0; i<listaControlli.size(); i++){  
String elemento = (String) listaControlli.get(i);
String elem[] = elemento.split(";;");
%>
<tr>
<td> <a href="GlobalSearch.do?command=Search&searchcodeTipologiaAttivita=3&tipoRicerca=cu&searchOpCancellati=no_trashed&searchAttCancellati=no_trashed&searchEsito=non_esito&searchAccountIdentificativo=<%=elem[0]%>&redirectAcquacoltura=true"><%=elem[0]%></a></td> 
<%-- <td> <%=elem[0] %></td> --%>
<td> <%=SiteList.getSelectedValue(elem[1]) %></td> 
<td> <%=toHtml(elem[2]) %></td>
<td> <%=toDateasStringFromString(elem[3]) %></td>
</tr>

<% 
	}
	}
%>
</table>