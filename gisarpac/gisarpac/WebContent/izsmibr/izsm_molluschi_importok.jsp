<%@page import="com.google.gson.GsonBuilder"%>
<%@page import="com.google.gson.Gson"%>

<%
String ImportKoError = (String)request.getAttribute("ImportKoError");
Integer numeroRiga = (Integer)request.getAttribute("numeroRiga");

Gson gson = new GsonBuilder().create();
out.print(gson.toJson("___Errore_Tracciato_Record___Attenzione! Si e' verificato il seguente errore" + ((numeroRiga!=null)?(" alla riga numero " + numeroRiga):("")) +  ": " + ImportKoError ));
out.flush();
%>