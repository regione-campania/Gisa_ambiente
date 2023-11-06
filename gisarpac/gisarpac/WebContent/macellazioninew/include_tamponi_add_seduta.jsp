<%@page import="org.aspcfs.modules.macellazioninew.utils.ConfigTipo"%>
<%
ConfigTipo configTipo3 = (ConfigTipo) request.getSession().getAttribute("configTipo");
String fileToInclude3 = "include_tamponi_add_seduta" + configTipo3.getIdTipo() + ".jsp";
%>


<jsp:include page="<%=fileToInclude3%>"/>
