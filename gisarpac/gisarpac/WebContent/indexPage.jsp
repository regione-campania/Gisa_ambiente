<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%
request.setAttribute("coordinate", request.getAttribute("coordinate")); 
%>
<jsp:include page='<%= (String) request.getAttribute("LAYOUT.JSP") %>' flush="true" />