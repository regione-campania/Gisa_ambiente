<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.math.*,java.net.*, java.io.*, java.util.*, java.servlet.*, java.servlet.http.*, java.security.cert.*, java.security.cert.X509Certificate.*, org.bouncycastle.asn1.x509.X509Name.*, org.bouncycastle.jce.PrincipalUtil.*, org.bouncycastle.jce.X509Principal.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Welcome</title>
</head>
<body>
<center> <font color="red"> Welcome</font> </center>
<%
Object o = request.getAttribute("javax.servlet.request.X509Certificate");
if (o != null) {
X509Certificate certs[] = (X509Certificate[]) o;
 X509Certificate cert = certs[0];

    System.out.println("ver: " + cert.getVersion());
    System.out.println("\nSerial: " + cert.getSerialNumber().toString(16));
    System.out.println("\n Subj: " + cert.getSubjectDN());
    System.out.println("\n issuer: " + cert.getIssuerDN());
    System.out.println("\n ini: " + cert.getNotBefore());
    System.out.println("\n end: " + cert.getNotAfter());
    System.out.println("\n Sig: " + cert.getSigAlgName());
   
%>
<h3> subject: </h3>
 <%=cert.getSubjectDN() %> 

<%
} else {
%>
You are not Authorized!
Your certificate cannot be found!
<%
}
%>
<br><br>
<form method = "get" action = "SecurityAttribs">
<input type = submit value = "click me">
</form>
</body>
</html>