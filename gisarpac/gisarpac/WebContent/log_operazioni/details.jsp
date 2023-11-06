<%@page import="java.util.* ,org.aspcfs.modules.admin.base.UserOperation"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>
<jsp:useBean id="UODetails" class="org.aspcfs.modules.admin.base.UserOperation" scope="request"/>
<jsp:useBean id="searchUsername" class="java.lang.String" scope="request"/>
<jsp:useBean id="searchtimestampDateStart" class="java.lang.String" scope="request"/>
<jsp:useBean id="searchtimestampDateEnd" class="java.lang.String" scope="request"/>

<table class="trails" cellspacing="0">
	<tr>
		<td width="100%">
		<a href="LogOperazioni.do?command=Home">
			<dhv:label name="">Log Operazioni</dhv:label></a> > 
		<a href="LogOperazioni.do?command=Search&searchUsername=<%=searchUsername%>&searchtimestampDateStart=<%=searchtimestampDateStart%>&searchtimestampDateEnd=<%=searchtimestampDateEnd%>">
			<dhv:label name="">Lista Operazioni</dhv:label></a> > <dhv:label name="">Dettaglio Operazione</dhv:label>
		</td>
	</tr>
</table>

<table class="details" cellpadding="4" cellspacing="0" border="0" width="100%">
	<tr class="row1"><td>ID</td><td><%=UODetails.getId()%></td></tr>
	<tr class="row2"><td>USERID</td><td><%=UODetails.getUser_id()%></td></tr>
	<tr class="row1"><td>USERNAME</td><td><%=UODetails.getUsername()%></td></tr>
	<tr class="row2"><td>IP</td><td><%=UODetails.getIp()%></td></tr>
	<tr class="row1"><td>DATA</td><td><%=UODetails.getData()%></td></tr>
	<tr class="row2"><td>BROWSER</td><td><%=UODetails.getUserBrowser()%></td></tr>
	<tr class="row1"><td>URL</td><td><%=UODetails.getUrl()%></td></tr>
	<tr class="row2"><td>PARAMETRI</td><td><%=UODetails.getParameter()%></td></tr>
	<tr class="row1"><td>ARCHIVIAZIONE<br>AUTOMATICA</td><td><%=UODetails.getAutomatico()%></td></tr>
</table>

