<%@ include file="initPage.jsp" %>
<html>
<head>
  <title>Centric CRM</title>
  <%if( request.getAttribute( "to_url" ) != null ){ %>
  <meta http-equiv="refresh" content="0;URL=<%= ((String)request.getAttribute("to_url")) %>">
  <%}else{
	  if( request.getAttribute( "to_url_suap" ) != null ){
		  
		  %>
		      <meta http-equiv="refresh" content="0;URL=<%=request.getAttribute( "to_url_suap" )%>">
		  
		  <%
	  }
	  else
	  {
	  %>
    <meta http-equiv="refresh" content="1;URL=<%= request.getScheme() %>://<%= getServerUrl(request) + "/" + request.getParameter("redirectTo") %>">
  
  <%} }%>
</head>
</html>