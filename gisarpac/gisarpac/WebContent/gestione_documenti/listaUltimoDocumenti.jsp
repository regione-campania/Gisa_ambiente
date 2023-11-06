<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <jsp:useBean id="idDocumento" class="java.lang.String" scope="request"/>
    <jsp:useBean id="idDocumentoSin" class="java.lang.String" scope="request"/>
    
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Recupera ultimo pdf</title>
</head>
<body>
<% if (!idDocumento.equals("-1")){ %>
<a href="GestioneDocumenti.do?command=Download&idDocumento=<%=idDocumento%>"><input type="button" value="Recupera ultimo PDF generato (Modello)"></input></a>

<%} if (!idDocumentoSin.equals("-1")){ %>
<a href="GestioneDocumenti.do?command=Download&idDocumento=<%=idDocumentoSin%>"><input type="button" value="Recupera ultimo PDF generato (Schede SIN)"></input></a>
<%} if (idDocumento.equals("-1") && idDocumentoSin.equals("-1")){ %>
Non sono presenti documenti generati.
<%} %>
</body>
</html>