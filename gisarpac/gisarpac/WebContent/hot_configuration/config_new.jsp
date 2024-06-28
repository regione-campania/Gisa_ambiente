<jsp:useBean id="jsonProperties" class="org.json.JSONArray" scope="request"/>
<%@page import="org.json.*"%>

<style>
.noUpper{
text-transform: none !important;
}

</style>
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="MyCFS.do?command=Home"><dhv:label name="My Home Page" mainMenuItem="true">La Mia Home Page</dhv:label></a> >
Configurazione a caldo
</td>
</tr>
</table>

<form name="configForm" action="HotConfiguration.do?command=Config" method="post">

<center>
<h2>Configurazione a caldo 2.0</h2>
<i><font color="red">Attenzione: tutte le modifiche effettuate in questa pagina verranno perse al prossimo riavvio</font></i><br/>
caricato: <b><label class="noUpper"><%=org.aspcfs.modules.util.imports.ApplicationProperties.getFileProperties() %></label></b><br/>
Se la riga nel properties inizia con ##, viene configurata come CAPITOLO. Se inizia con #, viene ignorata. I parametri del properties vanno elencati in ordine.
</center>

<table cellpadding="2" cellspacing="2" border="0" width="100%" id="tableProperties">
	<tr>
	    <td width="50%" valign="top">
	    	<table cellpadding="4" cellspacing="0" border="0" width="50%" class="details">
	        	
		        <% 
				for (int i = 0; i<jsonProperties.length(); i++) {
						
					JSONObject json = (JSONObject) jsonProperties.get(i);
					String tipo = (String) json.get("tipo");
					String chiave = (String) json.get("chiave");
					String valore =  (String) json.get("valore");
				
				%>
				
				<% if (tipo.equalsIgnoreCase("capitolo")) {%>
				 <tr><th nowrap colspan="2"><label class="noUpper"><%= chiave %></label></th></tr>
				<% } else { %>
		        <tr>
	          		<td nowrap class="formLabel"><label class="noUpper"><%= chiave %></label></td>
	          		<td><input type="text" size="98%" class="noUpper" name="<%= chiave %>" value="<%=valore %>"/></td>
	        	</tr>
	        	
	        	<%} %>
	        	
		        <%
					
				}
				%>
		        
			</table>
			<input type="submit" value="Salva"></input><br/>
			<p style="color: red;"><%= request.getAttribute("configMessage") != null ? request.getAttribute("configMessage") : ""%></p>
		</td>
	</tr>
</table>

</form>
