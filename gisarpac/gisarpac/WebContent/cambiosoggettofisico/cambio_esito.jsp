
<jsp:useBean id="messaggioUscita" class="java.lang.String" scope="request" />
<jsp:useBean id="idStabilimento" class="java.lang.String" scope="request" />
<jsp:useBean id="altIdStabilimento" class="java.lang.String" scope="request" />

<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>


<script>
function vaiARichiesta(){
	loadModalWindow();
	window.location.href="GisaSuapStab.do?command=Details&altId=<%=altIdStabilimento%>";
}
function vaiAStabilimento(){
	loadModalWindow();
	window.location.href="OpuStab.do?command=Details&stabId=<%=idStabilimento%>";
}
</script>

<% if (altIdStabilimento==null || Integer.parseInt(altIdStabilimento)<=0){ %>
<script>
alert('<%=messaggioUscita%>');
vaiAStabilimento();
</script>
<%} %>


<script>

if (confirm("<%=messaggioUscita%>")){
	vaiARichiesta();
}
else {
	vaiAStabilimento();
}
</script>