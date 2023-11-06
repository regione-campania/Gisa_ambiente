<%
String esito = (String)request.getParameter("esito");
String msg = (String)request.getParameter("msg");
%>

<script>

location.href="http://www.gisacampania.it/i2-resp_acque.php?esito=<%=esito%>&msg=<%=msg%>";
</script>