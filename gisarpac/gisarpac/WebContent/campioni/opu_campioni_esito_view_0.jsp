 
 <%@page import="org.aspcfs.modules.campioni.base.Analita"%>
 <table cellpadding="4" cellspacing="0" width="100%" class="details">
	<tr>
    <th colspan="10">
      <strong><dhv:label name="">Esito Campione</dhv:label></strong>
    </th>
	</tr>
	<tr>
	 <th>Analita</th>
	 <th>Data</th>
	 <th>Esito</th>
	 <th>Motivo Respingimento</th>
	 <th>Punteggio</th>
	 <th>Responsabilita</th>
	 <th>Segnalazione Allarme Rapido</th>
	 <th>Segnalazione Informazioni</th>
	 <th>Note</th>
	 <th>&nbsp;</th>
	 </tr>
 <%
 for(Analita analita : TicketDetails.getTipiCampioni())
 {
	
		
		
	 
	 %>
	 <tr>
	 <td><%=analita.getDescrizione() %></td>
	 <td><%=toDateString(analita.getEsito_data()) %></td>
	 <td><%= toStringSpace(EsitoCampione.getSelectedValue(analita.getEsito_id()))%></td>
	 <td><%=toStringSpace(analita.getEsito_motivazione_respingimento()) %></td>
	 <td><%= analita.getEsito_punteggio() %></td>
	 <td> <%=toStringSpace(ResponsabilitaPositivita.getSelectedValue(analita.getEsito_responsabilita_positivita()))%> </td>
	 <td><%if(analita.isEsito_allarme_rapido()){%><input type="checkbox" checked disabled><%}else{%><input type="checkbox" disabled><%}%></td>
	 <td><%if(analita.isEsito_segnalazione_informazioni()){%><input type="checkbox" checked disabled><%}else{%><input type="checkbox" disabled><%}%></td>
	 <td> <%= toStringSpace(analita.getEsito_note_esame()) %></td>
	
	 <%
	 if (analita.getEsito_data()==null || analita.getEsito_id()<=0)
		{
			out.print("<td><a href=\"#\" onclick=\"openPopUp('Campioni.do?command=ModifyTicketEsito&idControlloUfficiale="+TicketDetails.getIdControlloUfficiale()+"&id="+TicketDetails.getId()+"&id_analita="+analita.getIdAnalita()+"')\">Inserisci Esito</a></td></tr>");
		}
		else
		{
			out.print("<td><font color='green'>Esito Inserito</font></td></tr>");
		}
	 %>
	
	 
	 </tr>
	 <%
 }
 %>

 
