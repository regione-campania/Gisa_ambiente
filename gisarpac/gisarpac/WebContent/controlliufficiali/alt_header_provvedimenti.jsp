
<%if (TicketDetails.isflagBloccoCu()==true){
		%>
		<font color = "red" ><%=TicketDetails.getNoteBlocco() %></font><br><br>
	
	<% if (TicketDetails.getClosed() == null) { %>
		
		
		<dhv:permission name="operazioni-hd-view">
		<input type="button"
			value="Chiusura per HD"
			onClick="this.form.action='<%=OrgDetails.getPrefissoAction("") %>AltreNonConformita.do?command=Chiudi&altId=<%=TicketDetails.getAltId()%>&id=<%= TicketDetails.getId() %>';if( confirm('Sei sicuro di voler chiudere La non Conformita? \n Attenzione! La pratica verrà chiusa e non sarà più possibile fare modifiche \n sulla scheda se non con il permesso del supervisore o dell amministratore') ){loadModalWindow();submit()};">
		</dhv:permission>
		
	<% }
			}

		if (TicketDetails.isTrashed() && !TicketDetails.isflagBloccoCu()) {
	%>
	<dhv:permission name="<%=permission_op_edit%>" >
		<input type="button"
			value="<dhv:label name="button.restore">Restore</dhv:label>"
			onClick="javascript:this.form.action='<%=OrgDetails.getPrefissoAction("") %>AltreNonConformita.do?command=Restore&id=<%= TicketDetails.getId()%>';submit();">
	</dhv:permission>
	<%
		}else if (!TicketDetails.isflagBloccoCu() && (TicketDetails.getClosed() != null || TicketDetails.isChiusura_attesa_esito()==true)) {
			if (TicketDetails.getClosed() != null && User.getUserRecord().getGruppo_ruolo()==UserUtils.getUserFormId(request, TicketDetails.getEnteredBy()).getGruppo_ruolo())
			{
	%>
	
	<%if (CU.getStatusId()!=2){ %>
	<dhv:permission name="reopen-reopen-view">
		<input type="button"
			value="<dhv:label name="button.reopen">Reopen</dhv:label>"
			onClick="javascript:this.form.action='<%=OrgDetails.getPrefissoAction("") %>AltreNonConformita.do?command=ReopenTicket&id=<%= TicketDetails.getId()%><%= (defectCheck != null && !"".equals(defectCheck.trim())?"&defectCheck="+defectCheck:"") %>';loadModalWindow();submit();">
	</dhv:permission>
	<%} %>
	<%
			}
	
		} else {
			if (TicketDetails.isflagBloccoCu()==false && User.getUserRecord().getGruppo_ruolo()==UserUtils.getUserFormId(request, TicketDetails.getEnteredBy()).getGruppo_ruolo())
			{
	%>

	<dhv:permission name="<%=permission_op_edit%>">
		<input type="button"
			value="<dhv:label name="global.button.modify">Modify</dhv:label>"
			onClick="javascript:this.form.action='<%=OrgDetails.getPrefissoAction("") %>AltreNonConformita.do?command=ModifyTicket&auto-populate=true<%= (defectCheck != null && !"".equals(defectCheck.trim())?"&defectCheck="+defectCheck:"") %>';loadModalWindow();submit();">
	</dhv:permission>

	
	<dhv:permission name="<%=permission_op_del%>">
		<%
			if ("searchResults".equals(request
								.getParameter("return"))) {
		%>
		
		<input type="button"
			value="<dhv:label name="global.button.delete">Delete</dhv:label>"
			onClick="javascript:popURL('<%=OrgDetails.getPrefissoAction("") %>AltreNonConformita.do?command=ConfirmDelete&id=<%= TicketDetails.getId() %>&altId=<%=TicketDetails.getAltId()%>&return=searchResults&popup=true', 'Delete_ticket','320','200','yes','no');">
		<% 
		
			} else {
		%>
		 <input type="button"
			value="<dhv:label name="global.button.delete">Delete</dhv:label>"
			onClick="javascript:popURL('<%=OrgDetails.getPrefissoAction("") %>AltreNonConformita.do?command=ConfirmDelete&id=<%= TicketDetails.getId() %>&altId=<%=TicketDetails.getAltId()%>&popup=true', 'Delete_ticket','320','200','yes','no');">
	
		<%
			}
		%>
	</dhv:permission>
	<dhv:permission name="<%=permission_op_edit%>">
		<input type="button"
			value="Chiudi"
			onClick="this.form.action='<%=OrgDetails.getPrefissoAction("") %>AltreNonConformita.do?command=Chiudi&altId=<%=TicketDetails.getAltId()%>&id=<%= TicketDetails.getId() %>';if( confirm('Sei sicuro di voler chiudere La non Conformita? \n Attenzione! La pratica verrà chiusa e non sarà più possibile fare modifiche \n sulla scheda se non con il permesso del supervisore o dell amministratore') ){loadModalWindow();submit()};">
	
	</dhv:permission>
		<%} %>

	<%
		
		}
	%>