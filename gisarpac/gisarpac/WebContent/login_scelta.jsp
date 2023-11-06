<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="org.aspcfs.modules.admin.base.User" %>
<jsp:useBean id="listaUtenti" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="cfSpid" class="java.lang.String" scope="request"/>

<script language="JavaScript" TYPE="text/javascript" SRC="dwr/interface/PopolaCombo.js"> </script>
<script language="JavaScript" TYPE="text/javascript" SRC="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>
<script type="text/javascript" src="javascript/jquery-1.6.1.js"></script>

<%@ include file="initPage.jsp" %>

<html>
<head>
<title><dhv:label name="templates.CentricCRM">G.I.S.A</dhv:label></title>
</head>
<link rel="stylesheet" href="css/template-login.css" type="text/css">
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript"
	SRC="javascript/geolocation.js"></script>
	

<script>
function settaUserId(userId){
	document.getElementById("userIdScelta").value = userId;
	document.getElementById("login").submit();
}

</script>	
	
	
          <form name="login" id="login" method="POST" action="Login.do?command=LoginSpid&auto-populate=true">
    
                <br/><br/>
    
             <center>
             <img src="images/concourseSuiteCommunitySplashOLD.png" width="300" height="200" alt="" border="0" /><br/><br/>
             </center>
        
           <div class="fieldsContainer" style="text-align: center">
                 
    
             
             Profili disponibili per il Codice Fiscale: <b><%=cfSpid %></b><br/><br/>
             
            <% for (int i = 0; i<listaUtenti.size(); i++) {
             	User utente = (User) listaUtenti.get(i);%>
             	
             	<div style="border: 1px solid black; padding: 10px; background-color: <%=i%2==0 ? "white" : "lightgrey" %>">
             	<a href="#" onClick="settaUserId('<%=utente.getId()%>')">
             	<img src="images/user.png" width="50" height="50" alt="" border="1px solid black" style="filter: saturate(<%=listaUtenti.size()-i%>);"/><br/>
             	<b><%=utente.getRole() %></b><br/>
             	(<%=utente.getSiteIdName() %>)
             	</a>
             	</div>
             	
             	<% } %>
             
       <input type="hidden" id="userIdScelta" name="userIdScelta" value=""/>
       <input type="hidden" id="cfSpid" name="cfSpid" value="<%=cfSpid%>"/>
       
          </form>
          
          <br/>
         <script src="https://gel.gisacampania.it/js/GisaSpid.js"></script>
		<center>
		<a href="#" onclick="GisaSpid.logoutSpid('/gisarpac');"><b>LOGOUT DA SPID/CIE</b></a>
		</center>
		
	

</body>
</html>
