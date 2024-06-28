<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="ListaDipartimenti" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="DettaglioAreaSemplice" class="org.aspcfs.modules.gestionedpat.base.AreaSemplice" scope="request"/>

<%@ page import="org.aspcfs.modules.gestionedpat.base.*" %>


<script>

function chiudi(){
	window.opener.location.href="GestioneDPAT.do?command=DettaglioAreaComplessa&idAreaComplessa=<%=DettaglioAreaSemplice.getIdAreaComplessa()%>";
	window.close();
}

</script>


<%=DettaglioAreaSemplice.getNome() %><br/><br/>

<script>
chiudi();
</script>
