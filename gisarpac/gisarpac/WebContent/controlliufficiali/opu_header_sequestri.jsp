<%

		if (TicketDetails.isTrashed()) {
			
	%>
	<dhv:permission name="<%=permission_op_edit%>" >
		<input type="button"
			value="<dhv:label name="button.restore">Restore</dhv:label>"
			onClick="javascript:this.form.action='<%=OrgDetails.getAction() %>Sequestri.do?command=Restore&id=<%= TicketDetails.getId()%>';submit();">
	</dhv:permission>
	<%
		}else if (TicketDetails.getClosed() != null || TicketDetails.isChiusura_attesa_esito()==true) {
			if (TicketDetails.getClosed() != null && User.getUserRecord().getGruppo_ruolo()==UserUtils.getUserFormId(request, TicketDetails.getEnteredBy()).getGruppo_ruolo())
			{
				
	%>
	<dhv:permission name="reopen-reopen-view">
		<input type="button"
			value="<dhv:label name="button.reopen">Reopen</dhv:label>"
			onClick="javascript:this.form.action='<%=OrgDetails.getAction() %>Sequestri.do?command=ReopenTicket&id=<%= TicketDetails.getId()%><%= (defectCheck != null && !"".equals(defectCheck.trim())?"&defectCheck="+defectCheck:"") %>';submit();">
	</dhv:permission>
	<%	
			}
	
		} else {
			if(User.getUserRecord().getGruppo_ruolo()==UserUtils.getUserFormId(request, TicketDetails.getEnteredBy()).getGruppo_ruolo())
			{
			
	%>
	<dhv:permission name="<%=permission_op_edit%>">
		<input type="button"
			value="<dhv:label name="global.button.modify">Modify</dhv:label>"
			onClick="javascript:this.form.action='<%=OrgDetails.getAction() %>Sequestri.do?command=ModifyTicket&auto-populate=true<%= (defectCheck != null && !"".equals(defectCheck.trim())?"&defectCheck="+defectCheck:"") %>';submit();">
	</dhv:permission>
	
	<dhv:permission name="<%=permission_op_del%>">
		<%
			if ("searchResults".equals(request
								.getParameter("return"))) {
		%>
		<input type="button"
			value="<dhv:label name="global.button.delete">Delete</dhv:label>"
			onClick="javascript:popURL('<%=OrgDetails.getAction() %>Sequestri.do?command=ConfirmDelete&id=<%= TicketDetails.getId() %>&stabId=<%=TicketDetails.getIdStabilimento()%>&orgId=<%=TicketDetails.getOrgId()%>&return=searchResults&popup=true', 'Delete_ticket','320','200','yes','no');">
		<%
			} else {
		%>
		 <input type="button"
			value="<dhv:label name="global.button.delete">Delete</dhv:label>"
			onClick="javascript:popURL('<%=OrgDetails.getAction() %>Sequestri.do?command=ConfirmDelete&id=<%= TicketDetails.getId() %>&stabId=<%=TicketDetails.getIdStabilimento()%>&orgId=<%=TicketDetails.getOrgId()%>&popup=true', 'Delete_ticket','320','200','yes','no');"> 
		<%
			}
		%>
	</dhv:permission>
	<dhv:permission name="<%=permission_op_edit%>">
	
		<input type="button"
			value="Chiudi"
			onClick="javascript:alert('ATTENZIONE! Qualora siano state controllate, nel corso dello stesso controllo, piu linee attivita occorre inserire piu controlli (uno per ogni linea attivita sottoposta a controllo)');this.form.action='<%=OrgDetails.getAction() %>Sequestri.do?command=Chiudi&id=<%= TicketDetails.getId() %>';if( confirm('Sei sicuro di voler chiudere il Sequestro? \n Attenzione! La pratica verrà chiusa e non sarà più possibile fare modifiche \n sulla scheda se non con il permesso del supervisore o dell amministratore') ){submit()};">
	
	
	</dhv:permission>
	
	
	<%
			}
		}
	%>