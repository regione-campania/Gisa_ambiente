<%@page import="org.aspcfs.modules.macellazioninew.utils.ConfigTipo"%>
<%
ConfigTipo configTipo2 = (ConfigTipo) request.getSession().getAttribute("configTipo");
String fileToInclude2 = "include_campioni_add" + configTipo2.getIdTipo() + ".jsp";
%>


<jsp:include page="<%=fileToInclude2%>"/>
