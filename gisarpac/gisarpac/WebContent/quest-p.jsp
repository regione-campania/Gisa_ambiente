<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>

<sql:setDataSource var="dm" driver="org.postgresql.Driver" url="jdbc:postgresql://192.168.2.195/gisa" user="postgres"  password=""/>

<sql:query var="rm" dataSource="${dm}">
select * from(
select  distinct on (descrizione_problema) to_char(data_operazione,'YYYY-MM-DD  HH24:MI:SS') d, username u, descrizione_problema p, asl, time_esecuzione_secondi::int t from customer_satisfaction_view where  soddisfatto ='N' 
)as s  order by d desc limit 300;
</sql:query>

<html>
<script type="text/javascript" src="http://code.jquery.com/jquery-2.1.1.min.js"></script>
<script type="text/javascript" src="scroll.js"></script>

<script>
function scroll() {
	$('#myTable').tScroll({
			h_box: '500px'
	});

}
</script>

<style type="text/css">
table{
	table-layout:fixed;
}
.menu_table td {
	border: 1px solid #98bf21; 
	vertical-align: middle;
	background-color:#EFEFEF;
}
.css_tab{
    font-family: verdana;
    font-size: 12px;
    background-color: blue;
    color:white;
    border-left:1px solid #CCCCCC;
    border-top:1px solid #CCCCCC; 
}
.css_tab th{
    padding:2px; 
    border-bottom:1px solid #CCCCCC;
    border-right: 1px solid #CCCCCC;
}
.css_tab td{
    text-align: right;
    background-color: aqua;
    color:black;
    padding:4px; 
    border-bottom:1px solid #CCCCCC;
    border-right: 1px solid #CCCCCC;
}
</style>

<body onload='scroll()'>
<table class="menu_table"><tr>
<td><a href=quest.jsp>Ultimi 300</a> </td>
<td style="background-color:yellow">Ultimi (max) 300 problemi segnalati in C.S. BDU </td>
<td><a href=questlong.jsp>lenti</a></td>
<td><a href=questall.jsp>tutti</a></td>
<td><a href="javascript:window.close()"> Chiudi</a> </td>
</tr></table>


<table border="0" cellpadding="0" cellspacing="0" id='myTable' class="css_tab">
	<thead> <th>data</th><th>user</th><th>problema</th><th>asl</th> <th>durata in sec</th> </thead>
	
	<c:forEach var="row" items="${rm.rows}"> 
	<tr> 
	   <td>${row.d}</td><td>${row.u}</td><td>${row.p} &nbsp;</td><td>${row.asl}</td><td>${row.t}</td>
	</tr> 
	</c:forEach>
</table>
</body></html>

