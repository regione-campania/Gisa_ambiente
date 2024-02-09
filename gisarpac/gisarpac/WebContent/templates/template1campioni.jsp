
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page import=" org.aspcfs.modules.util.imports.ApplicationProperties"%>
 

<%@page import="java.net.InetAddress"%><html>
<head>

<link rel="stylesheet" type="text/css" media="screen" documentale_url="" href="css/moduli_screen.css" />

<% String tipo = request.getParameter("tipo");
String print = "moduli_print.css";
if (tipo!=null){
if (tipo.equals("1") || tipo.equals("2") || tipo.equals("3"))
	print = "moduli_print_grande.css";
if (tipo.equals("19")|| tipo.equals("9"))
	print = "moduli_print_medio.css";
}
%>
<link rel="stylesheet" type="text/css" media="print" documentale_url="" href="css/<%=print %>" />
 <link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>
  
 <script src='javascript/modalWindow.js'></script>
  <script src='javascript/jquerymini.js'></script>	
  
<!-- <link rel="stylesheet" type="text/css" href="css/capitalize.css"></link> -->		

<title></title>
</head>
<body leftmargin="0" rightmargin="0" margin="0" marginwidth="0" topmargin="0" marginheight="0"  onblur="if(window.opener!=null ){window.opener.loadModalWindowUnlock(); }">
<!-- <DIV ID='modalWindow' CLASS='unlocked'> -->
<!-- <P CLASS='wait'>Attendere il completamento dell'operazione...</P></DIV> -->

<table border="0" width="100%">
  <tr>
    <td valign="top">
		<jsp:include page='<%= (String) request.getAttribute("IncludeModule") %>' flush="true"/>
    </td>
  </tr>

</table>
</body>
</html>

