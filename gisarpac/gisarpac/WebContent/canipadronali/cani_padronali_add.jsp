
<%@page import="org.aspcfs.modules.util.imports.ApplicationProperties"%>
<%@page import="org.aspcfs.utils.UrlUtil"%><body>

<%
String url2 = ApplicationProperties.getProperty("InfoCaneLoginAction");
String result2 = UrlUtil.getUrlResponse( url2 );

%>
<%=result2 %>


</body>