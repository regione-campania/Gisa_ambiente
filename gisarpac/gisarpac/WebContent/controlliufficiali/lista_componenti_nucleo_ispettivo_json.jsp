<%@page import="java.lang.reflect.Type"%>
<%@page import="com.google.gson.JsonSerializationContext"%>
<%@page import="com.google.gson.JsonPrimitive"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="com.google.gson.JsonElement"%>
<%@page import="com.google.gson.JsonSerializer"%>
<%@page import="com.google.gson.ExclusionStrategy"%>
<%@page import="com.google.gson.FieldAttributes"%>
<%@page import="com.google.gson.GsonBuilder"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="org.aspcfs.modules.dpat.base.DpatStrumentoCalcoloNominativi"%>
<%@page import="java.util.ArrayList"%>

<jsp:useBean id="ListaToReturn" class="java.util.ArrayList" scope="request" />

<%@ include file="../initPage.jsp" %>

<%
Gson gson = new GsonBuilder().serializeNulls().create();


%>
<%=gson.toJson(ListaToReturn) %>


