

<%@page import="org.json.JSONObject"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Enumeration"%>
<%
HashMap map= new HashMap();
map.put("EsitoInserimentoSoggettoFisico", request.getAttribute("EsitoInserimentoSoggettoFisico"));
map.put("ErroreInserimento", request.getAttribute("ErroreInserimento"));

map.put("nominativoSoggettoFisico", request.getAttribute("nominativoSoggettoFisico"));
map.put("idSoggettoFisico", request.getAttribute("idSoggettoFisico"));
map.put("cfSoggettoFisico", request.getAttribute("cfSoggettoFisico"));



 Enumeration<String> e =  request.getAttributeNames();
while (e.hasMoreElements())
{
	String kiave = e.nextElement();
	if (kiave.contains("Error"))
	{
		String valore = (String) request.getAttribute(kiave);
		map.put(kiave, valore);
	}
	
}

JSONObject json = new JSONObject(map);

%>

<%=json%>