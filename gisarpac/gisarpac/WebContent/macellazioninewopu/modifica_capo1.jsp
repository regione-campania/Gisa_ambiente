<%@page import="org.aspcfs.modules.macellazioninewopu.utils.ConfigTipo"%>
<jsp:useBean id="Capo"				class="org.aspcfs.modules.macellazioninewopu.base.Capo"			scope="request" />

<%if (Capo.getStato_macellazione().equals("Incompleto: Presenti campioni senza esito.") && (Capo.isArticolo17() || Capo.isModello10())) {%>
<jsp:include page="include_capo_add_modify_esito.jsp" /><%}
else
{
%>
<%
ConfigTipo configTipo = (ConfigTipo)request.getSession().getAttribute("configTipo");
String fileToInclude = "include_capo_add_modify" + configTipo.getIdTipo() + ".jsp";
%>


<jsp:include page="<%=fileToInclude%>"/>

<%	
}
%>
