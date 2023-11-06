<%@page import="java.util.TreeSet"%>
<%@page import="org.aspcfs.modules.util.imports.ApplicationProperties"%>

<table class="trails" cellspacing="0">
<tr>
<td>
<a href="MyCFS.do?command=Home"><dhv:label name="My Home Page" mainMenuItem="true">La Mia Home Page</dhv:label></a> >
Configurazione a caldo
</td>
</tr>
</table>

<form name="configForm" action="HotConfiguration.do?command=Config" method="post">

<% TreeSet<Object> chiavi = new TreeSet<Object>( ApplicationProperties.getApplicationProperties().keySet() ); %>
<table cellpadding="2" cellspacing="2" border="0" width="100%">
	<tr>
	    <td width="50%" valign="top">
	    	<table cellpadding="4" cellspacing="0" border="0" width="50%" class="details">
	        	<tr>
	          		<th colspan="2"><strong>Configurazione a caldo</dhv:label></strong></th>
	        	</tr>
		        <% 
				for(Object chiave : chiavi){
					if(!chiave.equals("livelloLOG")){
				%>
		        <tr>
	          		<td nowrap class="formLabel"><%= chiave %></td>
	          		<td><input type="text" size="98%" name="<%= chiave %>" value="<%= ApplicationProperties.getProperty(chiave.toString()) %>" /></td>
	        	</tr>
		        <%
					}
				}
				%>
				
				<tr>
	          		<th colspan="2"><strong>Configurazione a caldo - LOG</dhv:label></strong></th>
	        	</tr>
		        
		        <tr>
	          		<td nowrap class="formLabel">livelloLOG</td>
	          		<td>
	          			Livello attuale: <%= ApplicationProperties.getProperty("livelloLOG") %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	          			Modifica livello:  
	          			<select name="livelloLOG" >
	          				<option value="SEVERE" <% if( ApplicationProperties.getProperty("livelloLOG").equalsIgnoreCase("SEVERE") ){ %>selected="selected"<% } %> >SEVERE</option>
	          				<option value="WARNING" <% if( ApplicationProperties.getProperty("livelloLOG").equalsIgnoreCase("WARNING") ){ %>selected="selected"<% } %> >WARNING</option>
	          				<option value="INFO" <% if( ApplicationProperties.getProperty("livelloLOG").equalsIgnoreCase("INFO") ){ %>selected="selected"<% } %> >INFO</option>
	          				<option value="CONFIG" <% if( ApplicationProperties.getProperty("livelloLOG").equalsIgnoreCase("CONFIG") ){ %>selected="selected"<% } %> >CONFIG</option>
	          			</select>
	          		</td>
	        	</tr>
		        
			</table>
			<input type="submit" value="Salva"></input><br/>
			<p style="color: red;"><%= request.getAttribute("configMessage") != null ? request.getAttribute("configMessage") : ""%></p>
		</td>
	</tr>
</table>

</form>