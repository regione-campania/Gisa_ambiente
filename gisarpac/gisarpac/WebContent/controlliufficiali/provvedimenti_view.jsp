
	
		
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
	
		
  <input type="hidden" name="id" id="id"
			value="<%=  TicketDetails.getId() %>" />
		<input type="hidden" name="orgId" id="orgId"
			value="<%=  TicketDetails.getOrgId() %>" />

  <tr class="containerBody">
    <td class="formLabel">
      <dhv:label name="">Codice FollowUp</dhv:label>
    </td>
   
     
      <td>
      		<%= toHtmlValue(TicketDetails.getIdentificativo()) %>
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
					<%=toString(TicketDetails.getNote())%>
					</td>
				</tr>
		
		
