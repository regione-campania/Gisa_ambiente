<%@page import="java.util.HashMap"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
JSONArray array = new JSONArray(); 
HashMap map = new HashMap();
map.put("nome", "camillo");
map.put("cognome", "benson");
HashMap map2 = new HashMap();
map2.put("comune", "torre annunziata");
map2.put("indirizzo", "via marconi");
JSONObject indirizzo = new JSONObject(map2);



map.put("indirizzo", indirizzo);
JSONObject o = new JSONObject(map);

%>
<%=o.toString().replace(",}", "}") %>

