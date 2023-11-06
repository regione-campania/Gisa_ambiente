<%@page import="org.aspcfs.modules.gestioneanagraficaremota.base.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>


<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>

<jsp:useBean id="idStabilimento" class="java.lang.String" scope="request"/>

<%@ include file="../initPage.jsp" %>


<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/spanDisplay.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/confirmDelete.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popURL.js"></SCRIPT>


<% 
int idStabilimentoInt = -1;
try {idStabilimentoInt = Integer.parseInt(idStabilimento);}
catch (Exception e) {}

if (idStabilimentoInt>0) {%>
<script>
alert('Anagrafica importata correttamente');
window.location.href="OpuStab.do?command=Details&stabId=<%=idStabilimentoInt%>";
</script>
<% } else { %>
<script>
alert('Errore nella procedura di import.');
window.location.href="GestioneAnagraficaRemotaAction.do?command=PrepareSearchAnagraficaRemota";
</script>
<% } %>