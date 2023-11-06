 
<jsp:useBean id="oggettoRisposta" class="org.json.JSONObject" scope="request" />
 <%
 System.out.println(oggettoRisposta!= null ? oggettoRisposta.toString() : "{}");
out.println(oggettoRisposta!= null ? oggettoRisposta.toString() : "{}");
 out.flush();
%>