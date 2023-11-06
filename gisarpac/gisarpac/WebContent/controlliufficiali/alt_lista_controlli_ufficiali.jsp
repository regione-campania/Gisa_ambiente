


<%@page import="java.util.Iterator"%>


<%@page import="org.aspcfs.modules.vigilanza.base.Ticket"%>


<table cellpadding="4" cellspacing="0" border="0" width="100%" class="pagedList">
    
        <tr>
	 
	   <th><strong><dhv:label name="">Identificativo</dhv:label></strong></th>
      <th ><strong><dhv:label name="">Controllo del</dhv:label></strong></th>
      <th><b><dhv:label name="sanzionia.data_richiesta">Data Fine Controllo</dhv:label></b></th>
      <th><b><dhv:label name="sanzionia.richiedente">Tipo di controllo</dhv:label></b></th>
       <th><b><dhv:label name="sanzionia.richiedente">Linee Sottoposte A controllo</dhv:label></b></th>
    
      <th><b><dhv:label name="sanzionia.richiedente">Punteggio</dhv:label></b></th>
      <th><b><dhv:label name="sanzionia.richiedente">Inserito da</dhv:label></b></th>

  </tr>
  <%
    Iterator j = TicList.iterator();
    if ( j.hasNext() ) {
      int rowid = 0;
      int i =0;
      while (j.hasNext()) {
        i++;
        rowid = (rowid != 1?1:2);
        Ticket thisTic = (Ticket)j.next();
  %>
    <tr class="row<%= rowid %>">
    
     
   <td width="10%" valign="top" nowrap>
		<%=thisTic.getPaddedId() %>
		</td>
		<td width="10%" valign="top" nowrap>
			<a href="<%=OrgDetails.getAction() %>Vigilanza.do?command=TicketDetails&id=<%= thisTic.getId() %>&altId=<%= thisTic.getAltId()%><%= addLinkParams(request, "popup|popupType|actionId") %>"><zeroio:tz timestamp="<%= thisTic.getAssignedDate() %>" dateOnly="true" timeZone="<%= thisTic.getAssignedDateTimeZone() %>" showTimeZone="false" default="&nbsp;"/>
	
	   </a>
		</td>
    	<td width="15%" valign="top" class="row<%= rowid %>">
      <zeroio:tz timestamp="<%= thisTic.getDataFineControllo() %>" timeZone="<%= User.getTimeZone() %>" dateOnly="true" showTimeZone="false" default="&nbsp;"/>
    	
		<%if(thisTic.getTipoCampione() > -1) {%>
		<td valign="top"><%= TipoCampione.getSelectedValue(thisTic.getTipoCampione()) %>
		
		</td>
		<%}else{%>
		<td>-
		</td>
		<%} %>
		
		<td valign="top">
    	<%
    	if(thisTic.getTipoCampione()!=5 && thisTic.getListaLineeProduttive().size()>0)
    		{
    		for(String linea : thisTic.getListaLineeProduttive() )
    			out.print(linea+"<br>");
    		}
    		
    		%>
		
		</td>
		
		<%if(thisTic.getPunteggio() >= 3) {%>
		<td valign="top"><%= thisTic.getPunteggio() %></td>	
		<%}else{%>
		<td><%=thisTic.getPunteggio()%> 
		</td>
		<%} %>

		<td nowrap>
		<%
		if (thisTic.getEnteredBy() == -3)
		{
			out.print("Utente Black Berry");
		}
		else
		{
		%>
      <dhv:username id="<%= thisTic.getEnteredBy() %>" />
      <%} %>
	</td>
	</tr>
      
<tr class="row<%= rowid %>">
      <td colspan="7" valign="top">
        <%
          if (1==1) {
            Iterator files = thisTic.getFiles().iterator();
        
          }
        %>
        <%= toHtml(thisTic.getProblemHeader()) %>&nbsp;
      
         
<%String stato ="";
if (thisTic.getStatusId()==thisTic.STATO_APERTO && thisTic.isChiusura_attesa_esito() == true) 
  	stato = "<font color=\"red\">CONTROLLO CHIUSO IN ATTESA DI ESITO</font>";
else if (thisTic.getStatusId()==thisTic.STATO_CHIUSO)
	stato="<font color=\"red\">Chiuso</font>";
else if (thisTic.getStatusId()==thisTic.STATO_RIAPERTO)
	stato="<font color=\"orange\">Riaperto</font>";
else if (thisTic.getStatusId()==thisTic.STATO_ANNULLATO)
	stato="<font color=\"red\"><strike>Disattivato</strike></font>";
else if (thisTic.getStatusId()==thisTic.STATO_APERTO)
	stato="<font color=\"green\">Aperto</font>";
%>
        
      [<%=stato %>]  
        
      
      
      </td>
    </tr>
  <%}%>
  <%} else {%>
  
    <tr class="containerBody">
      <td colspan="7">
        <dhv:label name="accounts.richieste.search.notFound">Nessun Controllo Ufficiale Trovato.</dhv:label>
      </td>
    </tr>
  <%}%>
  </table>