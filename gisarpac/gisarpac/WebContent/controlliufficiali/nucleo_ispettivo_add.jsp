
<%@page import="org.aspcfs.modules.vigilanza.base.Ticket,java.util.*"%>
<input type ="hidden" name = "elementi" id = "elementi" value = "1">
<input type ="hidden" name = "elemento" id = "elemento" value = "1">
<input type ="hidden" name = "size" id = "size" value = "1">

<tr class="containerBody" >

	<td valign="top" class="formLabel"><label id = "nucleo" >Nucleo Ispettivo </label></td>
	<td>
	<table class="empty">
		<tr id = "nucleo_ispettivo">
			<td>
			
				<%TitoloNucleo.setJsEvent("onChange=prova(1)"); %>
				<%= TitoloNucleo.getHtmlSelect("nucleo_ispettivo_1",TicketDetails.getNucleoIspettivo()) %>
			</td>
			<td>
			
				<%
   					HashMap<String,ArrayList<String>> listaSian=(HashMap<String,ArrayList<String>>)request.getAttribute("listaUtentiSian");
        			HashMap<String,ArrayList<String>> lista=(HashMap<String,ArrayList<String>>)request.getAttribute("listaUtenti");        
        			HashMap<String,ArrayList<String>> listaTpal=(HashMap<String,ArrayList<String>>)request.getAttribute("listaUtentiTpal");
        			HashMap<String,ArrayList<String>> listaRefe=(HashMap<String,ArrayList<String>>)request.getAttribute("listaUtentiReferenteAllerte");
        			HashMap<String,ArrayList<String>> listaAmm=(HashMap<String,ArrayList<String>>)request.getAttribute("listaUtentiAmministrativi");
            	%>
             	<select name="Veterinari_1" id="Veterinari_1" style="display: none" onchange="clona()">
					<option value="-1">Seleziona</option>
					<%
						Iterator<String> itVeterinari = lista.keySet().iterator();
					while (itVeterinari.hasNext())
					{
						String label = itVeterinari.next();
						%>
						<optgroup label="<%=label %>"></optgroup>
						<%
						ArrayList<String> listaUtenti = lista.get(label);
						for (String utente : listaUtenti)
						{
							%>
							<option value = "<%=utente %>"><%=utente %></option>
							<%
						}
					}
					%>
				</select>
				<select name="Medici_1" id="Medici_1" style="display: none" onchange="clona()">
					<option value="-1">Seleziona</option>
					<%
						Iterator<String> idMedici = listaSian.keySet().iterator();
					while (idMedici.hasNext())
					{
						String label = idMedici.next();
						%>
						<optgroup label="<%=label %>"></optgroup>
						<%
						ArrayList<String> listaUtenti = listaSian.get(label);
						for (String utente : listaUtenti)
						{
							%>
							<option value = "<%=utente %>"><%=utente %></option>
							<%
						}
					}
					%>
				</select>
				<select name="Tpal_1" id="Tpal_1" style="display: none" onchange="clona()">
				
					<option value="-1">Seleziona</option>
					<%
						Iterator<String> itTpal = listaTpal.keySet().iterator();
					while (itTpal.hasNext())
					{
						String label = itTpal.next();
						%>
						<optgroup label="<%=label %>"></optgroup>
						<%
						ArrayList<String> listaUtenti = listaTpal.get(label);
						for (String utente : listaUtenti)
						{
							%>
							<option value = "<%=utente %>"><%=utente %></option>
							<%
						}
					}
					%>
				</select>
				
				<select name="Ref_1" id="Ref_1" style="display: none" onchange="clona()">
				
					<option value="-1">Seleziona</option>
					<%
						Iterator<String> itRef = listaRefe.keySet().iterator();
					while (itRef.hasNext())
					{
						String label = itRef.next();
						%>
						<optgroup label="<%=label %>"></optgroup>
						<%
						ArrayList<String> listaUtenti = listaRefe.get(label);
						for (String utente : listaUtenti)
						{
							%>
							<option value = "<%=utente %>"><%=utente %></option>
							<%
						}
					}
					%>
				</select>
				
				<select name="Amm_1" id="Amm_1" style="display: none" onchange="clona()">
				
					<option value="-1">Seleziona</option>
					<%
						Iterator<String> itAmm = listaAmm.keySet().iterator();
					while (itVeterinari.hasNext())
					{
						String label = itAmm.next();
						%>
						<optgroup label="<%=label %>"></optgroup>
						<%
						ArrayList<String> listaUtenti = listaAmm.get(label);
						for (String utente : listaUtenti)
						{
							%>
							<option value = "<%=utente %>"><%=utente %></option>
							<%
						}
					}
					%>
				</select>
				
				<input type="text" name="Utente_1" id="Utente_1" size="20" maxlength="256"  style="display: none" onchange="clona()" />
				<font color = "red"> * </font>
			</td>
		</tr>
	</table>
	</td>
</tr>
