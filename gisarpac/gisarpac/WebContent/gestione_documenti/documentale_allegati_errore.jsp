<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
        
    <%@ include file="../../initPage.jsp"%>
    <jsp:useBean id="error" class="java.lang.String" scope="request"/>
    <jsp:useBean id="orgId" class="java.lang.String" scope="request"/>
      <jsp:useBean id="label" class="java.lang.String" scope="request"/>
      
<jsp:useBean id="op" class="java.lang.String" scope="request"/>

<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*, org.aspcfs.modules.base.*" %>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>

<body>

		
	
<% String param ="";
 
%>	

<dhv:container name="<%=op %>" selected="documents" object="OrgDetails" param="<%= param %>">

<center><b><p><span style="color: #ff0000;">ERRORE</span> </p></b>
<dhv:evaluate if="<%=(error!=null) %>"> 
<label><font size="20"><%=error %></font></label>
</dhv:evaluate>
<br/>
<img style="text-decoration: none;" width="150" src="gestione_documenti/schede/images/sd_error.png" />
</center>
</dhv:container>