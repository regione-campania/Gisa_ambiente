<%--Pagina JSP creata da Francesco --%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="java.util.*,org.aspcfs.modules.base.*,org.aspcfs.utils.web.*" %>
<%@ page import="org.aspcfs.utils.*" %>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></script>

<%@ include file="initPage.jsp" %>



<%

boolean trovato = (Boolean)request.getAttribute("DiaEsistente");

if(trovato == true)
{

%>
<body >

<script>
popLookupSelectorCheckImpreseRed();
</script>

<table>

<tr><td colspan="2">
<b>La Dia Con Partita Iva :  <%=request.getAttribute("PartitaIva") %> è stata già inserita precedentemente . Continuare con l'inserimenti degli altri Dati ?</b></td></tr>
<tr><td>
<input type = "button" value = "si" onclick="popLookupSelectorCheckImpreseOk();">

</td><td>

<input type = "button" value = "no" onclick="popLookupSelectorCheckImpreseNo();">

</td></tr>

</table>
</body>

<%}else
{
	%>


<body onload="closeCheckDia();">
</body>

<%}%>

