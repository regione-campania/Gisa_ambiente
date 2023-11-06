<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,java.text.DateFormat,org.aspcfs.modules.campioni.base.*,com.zeroio.iteam.base.*, org.aspcfs.modules.quotes.base.*,org.aspcfs.modules.base.EmailAddress" %><html>
<jsp:useBean id="input" class="java.lang.String" scope="request"/>
<jsp:useBean id="id" class="java.lang.String" scope="request"/>
<jsp:useBean id="orgId" class="java.lang.String" scope="request"/>

<script type="text/javascript">
function ViewDetails(){
	document.campioni_dettaglio.action='<%=request.getParameter("input")%>?command=TicketDetails&id=<%=request.getParameter("id")%>&orgId=<%=request.getParameter("orgId")%>';
	document.campioni_dettaglio.submit();
}
</script>

<form name="campioni_dettaglio" action="" method="post">
</form>

<script type="text/javascript">
	ViewDetails();
</script>