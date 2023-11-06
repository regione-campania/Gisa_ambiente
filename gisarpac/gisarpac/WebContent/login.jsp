
<%@page import="java.util.ArrayList"%>
<link rel="shortcut icon" href="images/gisa_favicon.ico" /> 


<frameset cols="100%,*" onunload="">
<%
ArrayList<String> coordinate = (ArrayList<String>) request.getAttribute("coordinate");
//String url = "ex_login.jsp";
String url = "ldap_login.jsp";
url = ((coordinate!=null && coordinate.size()>2) ? url +"?latitudine="+coordinate.get(0)+"&longitudine="+coordinate.get(1) : url+"" );
request.setAttribute("coordinate", request.getAttribute("coordinate"));%> 
<frame src="<%=url %>" name="gisa" id = "gisa" >



<!-- <frame id = "container_applet_hidden" src="container_applet.jsp" name="container_applet_hidden"> -->


</frameset>


