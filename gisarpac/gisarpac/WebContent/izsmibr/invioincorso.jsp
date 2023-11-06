<%@page import="com.google.gson.GsonBuilder"%>
<%@page import="com.google.gson.Gson"%>
<%
Gson gson = new GsonBuilder().create();
out.print(gson.toJson("Esecuzione"));
out.flush();
%>