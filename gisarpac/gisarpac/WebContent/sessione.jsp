<%@page import="org.apache.commons.io.IOUtils"%>
<%@page import="java.io.InputStream"%>
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

<% 
Enumeration<String> enume = application.getAttributeNames();

int i = 1 ;
long sizeTot = 0 ;
while (enume.hasMoreElements())
{
	String next = enume.nextElement();
			
			
	out.println(i+")"+ next+"<br>");
	out.println(i+")"+ ((Object)application.getAttribute(next)).toString()+"<br>");
	out.println(i+")"+ ((Object)application.getAttribute(next)).toString()+"<br>");

	Class c = ((Object)application.getAttribute(next)).getClass();
	String className = c.getName();
	String classAsPath = className.replace('.', '/') + ".class";
	System.out.println(classAsPath);
	
	/*InputStream stream = c.getClassLoader().getResourceAsStream(classAsPath);
	byte[] arr = IOUtils.toByteArray(stream);
	out.println(i+")"+ arr.length+"<br>");
	sizeTot += arr.length ;*/
	i++;
}
out.println("--------------------SIZE TOT----------------------"+sizeTot);
%>

</body>
</html>