<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="com.darkhorseventures.database.ConnectionPool"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%

response.setIntHeader("Refresh", 5);
ConnectionPool sqlDriver = (ConnectionPool) application.getAttribute("ConnectionPool");

 
int ava = sqlDriver.AVAILABLE_CONNECTION ;
int max = sqlDriver.getMaxConnections();
int busy = sqlDriver.BUSY_CONNECTION;

%>

<table>

<tr>
<th>Connection Pool Monitoring [GISA]</th><th>MaxDeadTime</th><th>MaxIdleTime</th><th>Busy Conn</th><th>Avail Conn</th><th>Max Conn</th>
</tr>
<tr>
<td><%=""%></td>
<td><%=sqlDriver.getMaxDeadTime() %></td>
<td><%=sqlDriver.getMaxIdleTime() %></td>
<td><%=busy %></td>
<td><%=sqlDriver.AVAILABLE_CONNECTION %></td>

<td><%=max %></td>



</tr>
</table>


</body>
</html>