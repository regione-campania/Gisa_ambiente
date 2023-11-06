<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>

<%@page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page import="org.json.*"%>



 
<%
    
    JSONObject resp = new JSONObject();  
    resp.put("status",request.getAttribute("risultato") != null ? request.getAttribute("risultato") : "ko");
	  
	
	response.setContentType("application/json");
	out.write(resp.toString());
%>


