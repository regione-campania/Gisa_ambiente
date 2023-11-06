<%@page import="java.util.Enumeration"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<h1>RICHIEST INSERITA PERFETTAMENTE. DI SEGUITO I DATI INSERITI</h1>

<table>
<tr>
<th>Descrizione Campo</th>
<th>Valore</th>
<tr>
<%
Enumeration<String> enumParameter = request.getParameterNames();
while (enumParameter.hasMoreElements())
{
	String elemento = enumParameter.nextElement();
	String[] value = request.getParameterValues(elemento);
	for(int k=0;k<value.length;k++)
		out.print("<tr><td>"+elemento + (k+1)+"</td><td>"+value[k]+"</td></tr>");
	
}

%>
</table>
</body>
</html>