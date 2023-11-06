<%@page import="java.util.Map.Entry"%>
<%@ include file="../../../initPage.jsp" %>

<jsp:useBean id="campiHash" class="java.util.LinkedHashMap" scope="request"/>

<% if (campiHash.size()>0) {%>
<table width="100%">
<col widh="10%">
<col widh="90%">
<th align="center" colspan="2" bgcolor="#5CB8E6">Dati estesi</th>

<%
Set<Entry> entries = campiHash.entrySet();
for (Entry elemento : entries) 
{
%>
<tr><td width="15%" class="formLabel"> 
<%=elemento.getKey() %>
</td>

<td>
<%=elemento.getValue() %>
</td></tr>

<% } %>

</table>
<% } %>


