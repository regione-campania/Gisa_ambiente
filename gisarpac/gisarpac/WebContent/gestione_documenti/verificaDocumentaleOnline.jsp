<%@page import="org.json.JSONObject"%>
<%@page import="java.util.HashMap"%>

<% HashMap map= new HashMap();

map.put("Esito", request.getAttribute("verificaDocumentaleOnline"));

JSONObject json = new JSONObject(map); %>
<%=json%>