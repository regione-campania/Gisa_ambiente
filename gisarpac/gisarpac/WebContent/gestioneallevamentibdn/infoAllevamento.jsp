<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="jsonAllevamento" class="org.json.JSONObject" scope="request"/>
<jsp:useBean id="jsonAzienda" class="org.json.JSONObject" scope="request"/>
<jsp:useBean id="jsonProprietario" class="org.json.JSONObject" scope="request"/>
<jsp:useBean id="jsonDetentore" class="org.json.JSONObject" scope="request"/>

<jsp:useBean id="orgId" class="java.lang.String" scope="request"/>
<jsp:useBean id="messaggio" class="java.lang.String" scope="request"/>

<%@ page import="org.json.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="http://code.jquery.com/jquery-1.8.2.js"></script>
<script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<script>
alert("<%=messaggio%>");
</script>

<% if (orgId != null && !orgId.equals("") && !orgId.equals("-1")){ %>
<script>
window.location.href="Allevamenti.do?command=Details&orgId=<%=orgId %>";
</script>
<% } else { %>
<script>
window.location.href="Allevamenti.do?command=Add";
</script>
<% } %>


<!--JSON-->
<br/><br/><br/><br/>
<textarea rows="10" cols="200" readonly id="jsonAllevamento" name="jsonAllevamento" style="display:none"><%=jsonAllevamento%></textarea>
<textarea rows="10" cols="200" readonly id="jsonAzienda" name="jsonAzienda" style="display:none"><%=jsonAzienda%></textarea>
<textarea rows="10" cols="200" readonly id="jsonProprietario" name="jsonProprietario" style="display:none"><%=jsonProprietario%></textarea>
<textarea rows="10" cols="200" readonly id="jsonDetentore" name="jsonDetentore" style="display:none"><%=jsonDetentore%></textarea>
<!--JSON-->


