<input type="hidden" name="org_id" id="org_id" value="<%=TicketDetails.getOrgId()%>" />

<%if (TicketDetails.isflagBloccoCu()==true){
		%>
		<font color = "red" ><%=TicketDetails.getNoteBlocco() %></font><br><br> 
		
		<% if (TicketDetails.getClosed() == null) { %>
		
		<dhv:permission name="operazioni-hd-view">
			<input type="button"
				value="Chiusura per HD"
			onClick="this.form.action='<%=TicketDetails.getURlDettaglio() %>Sanzioni.do?command=Chiudi&id=<%= TicketDetails.getId() %>';if( confirm('Sei sicuro di voler chiudere la sanzione? \n Attenzione! La pratica verrà chiusa e non sarà più possibile fare modifiche \n sulla scheda se non con il permesso del supervisore o dell amministratore') ){loadModalWindow();submit()};">
		</dhv:permission>
			
		<% }
			}

		if (TicketDetails.isTrashed() && TicketDetails.isflagBloccoCu()==false) {
	%>
	<dhv:permission name="<%=permission_op_edit%>" >
		<input type="button"
			value="<dhv:label name="button.restore">Restore</dhv:label>"
			onClick="javascript:this.form.action='<%=TicketDetails.getURlDettaglio() %>Sanzioni.do?command=Restore&id=<%= TicketDetails.getId()%>';submit();">
	</dhv:permission>
	<%
		}else if (TicketDetails.isflagBloccoCu()==false && (TicketDetails.getClosed() != null || TicketDetails.isChiusura_attesa_esito()==true)) {
			if (TicketDetails.getClosed() != null && User.getUserRecord().getGruppo_ruolo()==UserUtils.getUserFormId(request, TicketDetails.getEnteredBy()).getGruppo_ruolo())
			{
	%>
<!-- 	<dhv:permission name="reopen-reopen-view"> -->
<!-- 		<input type="button" -->
<%-- 			value="<dhv:label name="button.reopen">Reopen</dhv:label>" --%>
<%-- 			onClick="javascript:this.form.action='<%=TicketDetails.getURlDettaglio() %>Sanzioni.do?command=ReopenTicket&id=<%= TicketDetails.getId()%><%= (defectCheck != null && !"".equals(defectCheck.trim())?"&defectCheck="+defectCheck:"") %>';loadModalWindow();submit();"> --%>
<!-- 	</dhv:permission> -->
	<%
			}
	
		} else {
			if (TicketDetails.isflagBloccoCu()==false && User.getUserRecord().getGruppo_ruolo()==UserUtils.getUserFormId(request, TicketDetails.getEnteredBy()).getGruppo_ruolo())
			{
	%>
	
	<% if (CU.getStatusId()==1){ %>
	<dhv:permission name="<%=permission_op_edit%>">
		<input type="button"
			value="<dhv:label name="global.button.modify">Modify</dhv:label>"
			onClick="javascript:this.form.action='<%=TicketDetails.getURlDettaglio() %>Sanzioni.do?command=ModifyTicket&auto-populate=true<%= (defectCheck != null && !"".equals(defectCheck.trim())?"&defectCheck="+defectCheck:"") %>';loadModalWindow();submit();">
	</dhv:permission>
	
	
	<dhv:permission name="<%=permission_op_del%>">
		<%
			if ("searchResults".equals(request
								.getParameter("return"))) {
		%>
		<input type="button"
			value="<dhv:label name="global.button.delete">Delete</dhv:label>"
			onClick="javascript:popURL('<%=TicketDetails.getURlDettaglio() %>Sanzioni.do?command=ConfirmDelete&id=<%= TicketDetails.getId() %>&stabId=<%=TicketDetails.getIdStabilimento()%>&orgId=<%=TicketDetails.getOrgId()%>&return=searchResults&popup=true', 'Delete_ticket','320','200','yes','no');">
		<%
			} else {
		%>
		 <input type="button"
			value="<dhv:label name="global.button.delete">Delete</dhv:label>"
			onClick="javascript:popURL('<%=TicketDetails.getURlDettaglio() %>Sanzioni.do?command=ConfirmDelete&id=<%= TicketDetails.getId() %>&stabId=<%=TicketDetails.getIdStabilimento()%>&orgId=<%=TicketDetails.getOrgId()%>&popup=true', 'Delete_ticket','320','200','yes','no');"> 
		<%
			}
		%>
	</dhv:permission>
	
	<%} %>
	
	
	
	<dhv:permission name="<%=permission_op_edit%>">

		<input type="button"
			value="Chiudi"
			onClick="this.form.action='<%=TicketDetails.getURlDettaglio() %>Sanzioni.do?command=Chiudi&id=<%= TicketDetails.getId() %>';if( confirm('Sei sicuro di voler chiudere la sanzione? \n Attenzione! La pratica verrà chiusa e non sarà più possibile fare modifiche \n sulla scheda se non con il permesso del supervisore o dell amministratore') ){loadModalWindow();submit()};">
	
	
	</dhv:permission>
	

	<%
			}//fine blocco
		} 
	%>
	
