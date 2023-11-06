<%@page import="org.aspcfs.modules.macellazioninewopu.utils.ConfigTipo"%>
<%
ConfigTipo configTipo = (ConfigTipo) request.getSession().getAttribute("configTipo");
String fileToInclude = "modifica_capo" + configTipo.getIdTipo() + ".jsp";
%>


<jsp:include page="<%=fileToInclude%>"/>