<table cellpadding="4" cellspacing="0" width="100%" class="details">
		<tr>
			<th colspan="2"><strong><dhv:label
				name="followup.information">Scheda Follow Up</dhv:label></strong></th>
		</tr>
		<%--<tr class="containerBody">
    <td class="formLabel">
      <dhv:label name="followup.tipo_richiesta">Ticket State</dhv:label>
    </td>
    <td>
      <dhv:label name="<%="richieste." + TicketDetails.getTipo_richiesta() %>"><%=TicketDetails.getTipo_richiesta()%></dhv:label>
    </td>
  </tr>--%>
		<dhv:include name="" none="true">
			<dhv:evaluate if="<%= SiteIdList.size() > 1 %>">
				<tr class="containerBody">
					<td nowrap class="formLabel"><dhv:label
						name="stabilimenti.site">Site</dhv:label></td>
					<td><%=SiteIdList.getSelectedValue(TicketDetails
										.getSiteId())%>
					<%
						
					%> <input type="hidden"
						name="siteId" value="<%=TicketDetails.getSiteId()%>"></td>
				</tr>
			</dhv:evaluate>
			<dhv:evaluate if="<%= SiteIdList.size() <= 1 %>">
				<input type="hidden" name="siteId" id="siteId" value="-1" />
						</dhv:evaluate>
		</dhv:include>
		<%--  <tr class="containerBody">
    <td class="formLabel">
      <dhv:label name="followup.richiedente">Impresa</dhv:label>
    </td>
    <td>
                <%= toHtml(TicketDetails.getCompanyName()) %>
          </td>
  </tr>--%>
		<%--<tr class="containerBody">
		<td nowrap class="formLabel">
      <dhv:label name="followup.tipo_animale">Ticket Source</dhv:label>
		</td>
		<td>
      <%= toHtml(TicketDetails.getSourceName()) %>
		</td>
  </tr>  --%>
  <input type="hidden" name="id" id="id"
			value="<%=  TicketDetails.getId() %>" />
		<input type="hidden" name="orgId" id="orgId"
			value="<%=  TicketDetails.getOrgId() %>" />
<tr class="containerBody">
    <td class="formLabel">
      <dhv:label name="">Identificativo Non Conformit�</dhv:label>
    </td>
   
     
      <td>
      		<%= TicketDetails.getIdentificativonc() %>
      </td>
    
  </tr>
  <tr class="containerBody">
    <td class="formLabel">
      <dhv:label name="">Codice FollowUp</dhv:label>
    </td>
   
     
      <td>
      		<%= toHtmlValue(TicketDetails.getIdentificativo()) %>
      </td>
    
  </tr>	
		
		<dhv:include name="" none="true">
		 </tr>
	<tr class="containerBody">
      <td nowrap class="formLabel">
        <dhv:label name="followup.data_richiestas">Data termine per la risoluzione non conformita'</dhv:label>
      </td>
      <td>
        <zeroio:tz  timestamp="<%= TicketDetails.getAssignedDate() %>"  timeZone="<%= TicketDetails.getAssignedDateTimeZone() %>" showTimeZone="false" default="&nbsp;" dateOnly="true" />
       
      </td>
    </tr>
    

    
				<tr class="containerBody">
					<td nowrap class="formLabel"><dhv:label name="">Provvedimenti Adottati</dhv:label>
					</td>
					<td>
					<%
					HashMap<Integer,String> lista=TicketDetails.getListaLimitazioniFollowup();
					Iterator<Integer> it=lista.keySet().iterator();
					while(it.hasNext()){
						int k=it.next();
						out.print(lista.get(k)+",");
						
					}
					
					
					%>
					</td>
				</tr>
				
				<tr class="containerBody">
					<td nowrap class="formLabel"><dhv:label name="">Note</dhv:label>
					</td>
					<td>
					<%=toString(TicketDetails.getNoteFollowup())%>
					</td>
				</tr>
				<% if( TicketDetails.getTipo_nc() == 3 ) { %>
				<tr class="containerBody">
					<td nowrap class="formLabel"><dhv:label name="">Valutazione del rischio n.c. </dhv:label>
					</td>
					<td>
					<%=toString(TicketDetails.getValutazione())%>
					</td>
				</tr>
				<% } %>
		
		</dhv:include>

	</table>