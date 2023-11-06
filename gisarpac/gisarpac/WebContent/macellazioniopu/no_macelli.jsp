<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio"%>

<%@page import="org.aspcfs.modules.macellazioniopu.utils.MacelliUtil"%>

<%@page import="org.aspcfs.modules.util.imports.ApplicationProperties"%>
<jsp:useBean id="OrgDetails" class="org.aspcfs.modules.opu.base.Stabilimento" scope="request" />
<jsp:useBean id="error" class="java.lang.String" scope="request" />


<script>
alert('<%=error%>');
window.location.href="OpuStab.do?command=Details&stabId=<%=OrgDetails.getIdStabilimento()%>";
</script>