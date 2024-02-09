
<jsp:useBean id="jsonVerbale" class="org.json.JSONObject" scope="request"/>
<jsp:useBean id="tipoVerbale" class="java.lang.String" scope="request"/>
<jsp:useBean id="hasProtocollo" class="java.lang.String" scope="request"/>
<jsp:useBean id="idCampione" class="java.lang.String" scope="request"/>

<%
String url = "";

if (hasProtocollo!=null && "true".equals(hasProtocollo)){%> 
	<script>
	alert('Attenzione. Per questo verbale risulta un documento protocollato. Impossibile compilare.');
	window.opener.location.href="GestioneCampioni.do?command=View&idCampione=<%=idCampione %>";
	window.close();
	</script>
<%} 

if (tipoVerbale.equals("C4")) 
	url = "moduli/campionamento.jsp"; 
else if (tipoVerbale.equals("AcqueSott"))
	url = "moduli/acquesotterranee.jsp";
else if (tipoVerbale.equals("CampionamentoSuolo"))
	url = "moduli/campionamentosuolo.jsp";
else if (tipoVerbale.equals("MancatoCampionamentoSuolo"))
	url = "moduli/mancatocampionamentosuolo.jsp";
%>

<%=url %>
<div style="display:none">
<form id="formVerbale" name="formVerbale" action="<%=url %>" method="post">
<textarea id="json" name="json" rows="20" cols="50"><%=jsonVerbale.toString()%></textarea>
</form>
</div>

<script> 
document.getElementById("formVerbale").submit();
</script>
