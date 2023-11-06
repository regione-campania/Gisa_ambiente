
<jsp:useBean id="jsonVerbale" class="org.json.JSONObject" scope="request"/>
<jsp:useBean id="tipoVerbale" class="java.lang.String" scope="request"/>
<jsp:useBean id="hasProtocollo" class="java.lang.String" scope="request"/>
<jsp:useBean id="idGiornataIspettiva" class="java.lang.String" scope="request"/>

<%
String url = "";

if (hasProtocollo!=null && "true".equals(hasProtocollo)){%> 
	<script>
	alert('Attenzione. Per questo verbale risulta un documento protocollato. Impossibile compilare.');
	window.opener.location.href="GestioneGiornateIspettive.do?command=View&idGiornataIspettiva=<%=idGiornataIspettiva %>";
	window.close();
	</script>
<%} 

if (tipoVerbale.equals("A6")) 
	url = "moduli/ispettiva.jsp";

%>

<div style="display:none">
<form id="formVerbale" name="formVerbale" action="<%=url %>" method="post">
<textarea id="json" name="json" rows="20" cols="50"><%=jsonVerbale.toString()%></textarea>
</form>
</div>

<script> 
document.getElementById("formVerbale").submit();
</script>
