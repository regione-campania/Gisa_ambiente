<%@ page import="java.util.*,org.aspcfs.utils.*"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio"%>
<%@ include file="../initPage.jsp"%>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean"
	scope="session" />

<%-- Trails --%>
<table class="trails" cellspacing="0">
	<tr>
		<td width="100%"><a href="Stabilimenti.do"><dhv:label
			name="">Sin</dhv:label></a> > <dhv:label
			name="">Import Effettuati</dhv:label>
		</td>
	</tr>
</table>
<%-- End Trails --%>

<br>

<table cellpadding="4" cellspacing="0" border="0" width="50%"
	class="details">
	<tr>
		<th nowrap class="formLabel"><strong>DATA</strong></th>

		<th nowrap class="formLabel"><strong>ERRORI</strong></th>
		<th nowrap class="formLabel"><strong>OK</strong></th>
		<th nowrap class="formLabel"><strong>KO</strong></th>

	</tr>
	
	<% 
		ArrayList<RiepilogoImport> rImport = ( ArrayList<RiepilogoImport> ) request.getAttribute("allRecords");
		if ( rImport.size() > 0 ) { 
			for ( int i=0; i< rImport.size(); i++ ) {
	%>
			<tr>
				<td align="right"><zeroio:tz timestamp="<%= rImport.get(i).getDataOp() %>" dateOnly="true" showTimeZone="false" default="&nbsp;" /></td>
				<td align="right"><a href="<%= "logSin/"+rImport.get(i).getErrori() %>">Download</a></td>
				<td align="right"><a href="<%= "logSin/"+rImport.get(i).getOkLog() %>">Download</a></td>
				<td align="right"><a href="<%= "logSin/"+rImport.get(i).getKoLog() %>">Download</a></td>
				
			</tr>
			<% } %>
		<% } else { %>
		  <tr class="containerBody">
      			<td colspan="4">
        			<dhv:label name="">Nessun import eseguito.</dhv:label>
      			</td>
    	  </tr>
		<% } %> 
	
</table>




	