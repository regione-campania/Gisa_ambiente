
<%@page import="org.aspcfs.modules.macellazioninew.utils.ConfigTipo"%>
<%
ConfigTipo configTipo = (ConfigTipo) request.getSession().getAttribute("configTipo");
String fileToInclude = "richiesta_istopatologico" + configTipo.getIdTipo() + ".jsp";
%>


<jsp:include page="<%=fileToInclude%>"/>


