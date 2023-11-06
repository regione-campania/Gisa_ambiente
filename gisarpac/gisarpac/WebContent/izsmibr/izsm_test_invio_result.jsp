<%@page import="com.itextpdf.text.log.SysoLogger"%>
<%@page import="com.google.gson.GsonBuilder"%>
<%@page import="com.google.gson.Gson"%>
<jsp:useBean id="Esito" class="org.aspcfs.modules.izsmibr.actions.EsitoInvioMoll" scope="request"/>
<%
Gson gson = new GsonBuilder().create();
out.print(gson.toJson(Esito));
out.flush();
%>