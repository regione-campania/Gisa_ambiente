<%@page import="org.aspcfs.modules.iter.base.Cartografia"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>

<jsp:useBean id="listaCartografie" class="java.util.ArrayList" scope="request"/>

<%@ include file="../initPage.jsp" %>


<style>

.iterTable th,td{
 font-size:20px;
}

.iterTable ul li{
 font-size:20px;
}
</style>


   <center>
   
    <div style="background: #0d47a1; color: white"><font size="30px">Cartografie iTer</font></div>
  
<%--   <% for (int i = 0; i<listaCartografie.size(); i++) { --%>
<%--   	Cartografia c = (Cartografia) listaCartografie.get(i); %> --%>
<!--   	<table cellpadding="20" cellspacing="20" width="40%" class="iterTable"> -->
<%--   	<tr><th><%=c.getNome() %> <a href="<%=c.getUrl() %>" target="_blank">Consulta mappa</a></th></tr> --%>
<%--   	<tr><td><%=c.getDescrizione() %></td></tr> --%>
<!--   	</table> -->
  	
<!--   	<br/><br/> -->
  	
<%--   	<% } %> --%>

<br/>

<a href= "#" onClick="window.open('https://sit2.regione.campania.it/content/servizi-wms')" style="text-decoration:none; font-size:30px">Accedi a Servizi WMS</a>

</center>
  	
<!-- <a href= "https://sit2.regione.campania.it/STWebGisApp/Map?id-map=mappa_wms_base" rel = "https://sit2.regione.campania.it/content/servizi-wms">LINK</a> -->
  	
  	
  	
  	
  	