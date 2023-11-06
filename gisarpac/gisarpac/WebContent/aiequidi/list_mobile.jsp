 		
 	
<%@page import="java.util.ArrayList"%>
<%@page import="org.aspcfs.modules.aiequidi.base.Aiequidi"%><br><br>
 		
 		<form name="aiequidiForm" action="AIEquidi.do?command=ListMobile" method="post">
 		<fieldset>
 		<legend>Ricerca per id Capo</legend>
	     <table align="left">
	     <tr>
	            <td align="right">
                   ID CAPO
                </td>
                <td>
                  <input type="text"   name="idCapo">
                </td>
         </tr>
          <tr>
          <td colspan="2">
         &nbsp;
	     </td>
	     </tr>
          <tr>
          <td colspan="2">
         <input type = "submit" value = "Ricerca"/>
	     </td>
	     </tr>
	     </table>
	     
	     </fieldset>
	    </form>
	    <br>
	    <br>
	    
	    <%
	    if (request.getAttribute("ListaEquidi")!=null)
	    {
	    	%>
	    	<form>
	    	<fieldset>
	    	<legend>Risultati Ricerca</legend>
	    	<table border="1">
	    	<tr>
	    	<th>Anno</th>
	    	<th>idCapo</th>
	    	<th>Prelievo</th>
	    	<th>Esito</th>
	    	<th>N. rapporto</th>
	    	</tr>
	    	<%
	    	ArrayList<Aiequidi> lista = (ArrayList<Aiequidi>)request.getAttribute("ListaEquidi");
	    	for(Aiequidi equido : lista)
	    	{
	    		%>
	    		<tr>
	    		<td><%=equido.getAnno() %></td>
	    		<td><%=equido.getId_capo() %></td>
	    		<td><%=equido.getData_prelievo() %></td>
	    		<td><%=equido.getEsito()%></td>
	    		<td><%=equido.getNum_rapporto() %></td>
	    		</tr>
	    		<%
	    	}
	    	%>
	    	</table>
	    	</fieldset>
	    	</form>
	    	<%
	    }
	    %>


	
