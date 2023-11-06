<%@ include file="header.jsp" %>

<jsp:useBean id="output" class="java.lang.String" scope="request"/>
<jsp:useBean id="username" class="java.lang.String" scope="request"/>
<%@ page import="org.aspcfs.modules.util.base.*" %>

<center>
Risultato: <%= output %> <br/><br/>

<input type="button" class="buttonguru" value="RELOAD UTENTI" onClick="window.open('<%=request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath()%>/ReloadUtenti');window.location.href='Utility.do?command=GURUList'"/>
</center>