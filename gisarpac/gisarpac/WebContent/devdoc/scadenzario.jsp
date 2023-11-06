<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
 
<jsp:useBean id="listaFlussiAperti" class="java.util.ArrayList" scope="request"/>

    <%@ include file="../../initPage.jsp"%>

  <%! public static String zeroPad(String id)
  {
	  String toRet = id;
	  while (toRet.length()<3)
	  	toRet = "0"+toRet;
	  return toRet;
  
  }

%>
	<font color="red">Richieste in attesa di risposta da piu' di due settimane.</font> <br/><br/>
	
<table width="100%" cellpadding="2" cellspacing="2"  border="1" class="details">
		<tr>
		<th><strong>ID RICHIESTA</strong></th>
		<th><strong>DATA</strong></th>
		<th><strong>DESCRIZIONE</strong></th>
		<th><strong>DATA ULTIMA MODIFICA</strong></th>
		<th><strong>SITUAZIONE</strong></th>
		</tr>

		<%if (listaFlussiAperti!=null && listaFlussiAperti.size()>0){ %>		
			<%
		for (int i=0;i<listaFlussiAperti.size(); i++){
			String riga = (String) listaFlussiAperti.get(i);
			String elem[] = riga.split(";;");
			%>
			
			<tr>
			<td> <%=zeroPad(elem[1]) %></td>  
			<td> <%=toDateasStringFromString(elem[2]) %></td>
			<td> <%=elem[4] %></td>
			<td> <%=toDateasStringFromString(elem[3]) %></td>
			<td> <%=elem[5] %></td>
		
<%}} %>

</table>
  
