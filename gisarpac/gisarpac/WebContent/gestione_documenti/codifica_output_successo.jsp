<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
        
    <%@ include file="../../initPage.jsp"%>
    <jsp:useBean id="messaggioPost" class="java.lang.String" scope="request"/>
    <jsp:useBean id="orgId" class="java.lang.String" scope="request"/>
      <jsp:useBean id="label" class="java.lang.String" scope="request"/>
       <jsp:useBean id="codDocumento" class="java.lang.String" scope="request"/>
        <jsp:useBean id="titolo" class="java.lang.String" scope="request"/>

<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,org.aspcfs.modules.opu.base.*, org.aspcfs.modules.base.*" %>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>

	<% String param1 = "orgId=" + orgId;   
%>

<center><b><p><span style="color:green"><%=codDocumento %> - <%=titolo %></span> </p></b>
<dhv:evaluate if="<%=(messaggioPost!=null) %>"> 
<label><font size="20"><%=messaggioPost %></font></label>
</dhv:evaluate>
<br/>
<img style="text-decoration: none;" width="100" src="gestione_documenti/schede/images/sdlogo.png" />
</center>

