<!--  CAMPIONI_ESITO_VIEW_3 : SOLO LETTURA -->
 
 
 
  
 <%@page import="org.aspcfs.modules.campioni.base.Analita"%>
 
 <!-- RELATIVO AL NUOVO CALENDARIO CON MESE E ANNO FACILMENTE MODIFICABILI -->
<SCRIPT LANGUAGE="JavaScript" SRC="javascript/CalendarPopup.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="javascript/common.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">document.write(getCalendarStyles());</SCRIPT>
<SCRIPT LANGUAGE="JavaScript" ID="js19">
	var cal19 = new CalendarPopup();
	cal19.showYearNavigation();
	cal19.showYearNavigationInput();
	cal19.showNavigationDropdowns();
</SCRIPT>


  <% int colspan = 10 ;
	 if (TicketDetails.getPdp()!=null && TicketDetails.getPdp().getId()>0)
	 {
		colspan = 11 ;
	 }
	 %>
	 
	  <table cellpadding="4" cellspacing="0" width="100%" class="details">
  	<tr>
    <th colspan="2">
      <strong><dhv:label name="">Informazioni campione da laboratorio</dhv:label></strong>
    </th>
	</tr>
	 <tr class="containerBody">
    <td valign="top" class="formLabel">
      <dhv:label name="sanzionia.importo">Codice Accettazione</dhv:label>
    </td>
    <%--<td><%= toHtmlValue(TicketDetails.getCause()) %></td>--%>
    <td>
     <%= toHtmlValue(TicketDetails.getCause()) %>
    </td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="">Data Accettazione</dhv:label>
    </td>
    <td>   
    <%= (TicketDetails.getDataAccettazione()==null)?(""):(getLongDate(TicketDetails.getDataAccettazione()))%>
	</td>
  </tr>
  
 
  <tr class="containerBody">
    <td valign="top" class="formLabel">
      <dhv:label name="sanzionia.azioni">Descrizione Risultato Esame</dhv:label>
    </td>
    <td>
      <table border="0" cellspacing="0" cellpadding="0" class="empty">
        <tr>
          <td>
            <%=TicketDetails.getEsitoNoteEsame() %>
          </td>
          <td valign="top">
            <%= showAttribute(request, "problemError") %>
          </td>
        </tr>
        </table>
        </td>
        </tr>
  <!-- NUOVO CAMPO DATA -->
   <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="">Data Risultato</dhv:label>
    </td>
    <td>   
    <%= (TicketDetails.getDataRisultato()==null)?(""):(getLongDate(TicketDetails.getDataRisultato()))%>
    </td>
  
  </tr>
  
  </table>
  <br>
  <br>
	 
	 
 <table cellpadding="4" cellspacing="0" width="100%" class="details">
	<tr>
    <th colspan="<%=colspan%>">
      <strong><dhv:label name="">Esito Campione</dhv:label></strong>
    </th>
	</tr>
	<tr>
	 <th>Analita</th>
	 <th>Data esito</th>
	 <th>Esito</th>
	 <th>Motivo Respingimento</th>
	 <% if (!TicketDetails.getURlDettaglio().contains("AcqueRete")) {%>
	 <th>Punteggio</th>
	 <th>Responsabilita</th>
	 <th>Allarme Rapido</th>
	 <th>Segnal. Info</th>
	 <%} %>
	  <% if (TicketDetails.getPdp()!=null && TicketDetails.getPdp().getId()>0)
	 {
		 %>
		 <th>
		 Punto di Prelievo</th>
		 <%
	 }
	 %>
	
	 </tr>
	 
	 <!--  COMMENTARE PER NON FAR SCHIATTARE (NON AGGIORNA GLI ANALITI) -->
<%-- 	  <input type="hidden" id="numAnaliti" name="numAnaliti" value="<%=TicketDetails.getTipiCampioni().size()%>"/> --%>
	  
 <% int k = 0;
 for(Analita analita : TicketDetails.getTipiCampioni())
 { k++;
	 %>
	 <input type="hidden" id="idAnalita_<%=k %>" name="idAnalita_<%=k %>" value="<%=analita.getIdAnalita()%>"/>
	 <tr>
	 <td><%=analita.getDescrizione() %> &nbsp;</td>
	  <td><%=toDateasString(analita.getEsito_data()) %> &nbsp;</td>
	  <td><%= toStringSpace(EsitoCampione.getSelectedValue(analita.getEsito_id()))%> &nbsp;</td>
	 <td><%=toStringSpace(analita.getEsito_motivazione_respingimento()) %> &nbsp;</td>
	<% if (!TicketDetails.getURlDettaglio().contains("AcqueRete")) {%>
	 <td><%= analita.getEsito_punteggio() %> &nbsp;</td>
	 <td> <%=toStringSpace(ResponsabilitaPositivita.getSelectedValue(analita.getEsito_responsabilita_positivita()))%> &nbsp; </td>
	 <td><%if(analita.isEsito_allarme_rapido()){%><input type="checkbox" checked disabled><%}else{%><input type="checkbox" disabled> &nbsp;<%}%></td>
	 <td><%if(analita.isEsito_segnalazione_informazioni()){%><input type="checkbox" checked disabled><%}else{%><input type="checkbox" disabled> &nbsp;<%}%></td>
	 <% } %>
	  <%
	 if (TicketDetails.getPdp()!=null && TicketDetails.getPdp().getId()>0)
	 {
		 %>
		 <td>
		 <%=(TicketDetails.getPdp().getOrgdDetails() != null) ? TicketDetails.getPdp().getOrgdDetails().getName()+"<br> loc. "+TicketDetails.getPdp().getOrgdDetails().getAddressList().getAddress(5).toString() : ""%>
		
		 </td>
		 <%
	 }
	 %>
	 	 </tr>
	 <%
 }
 %>

 
