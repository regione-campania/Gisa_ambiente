

<tr id="preavviso"   class="containerBody">
		<td  class="formLabel">
			Effettuato Preavviso
			</td>
		<td>
		<%if ("N".equalsIgnoreCase(TicketDetails.getFlag_preavviso()) ){%>Nessun Preavviso<%} %> 
		<%if ("P".equalsIgnoreCase(TicketDetails.getFlag_preavviso()) ){%>Telefono<%} %>
		<%if ("T".equalsIgnoreCase(TicketDetails.getFlag_preavviso()) ){%>Telegramma<%} %>
		<%if ("A".equalsIgnoreCase(TicketDetails.getFlag_preavviso()) ){%>Altro<%} %>
		</td>
		</tr>
		
		
		<%if (TicketDetails.getData_preavviso_ba() != null) {%>
		<tr id="data_preavviso_ba_tr" class="containerBody">
		<td  class="formLabel">
			Data Preavviso
			</td>
		<td>
		
		<%=toDateasString(TicketDetails.getData_preavviso_ba())%>
		
		</td>
		</tr>
		<%}%>