
<%if (TicketDetails.isflagBloccoCu()==true){
		%>
		<font color = "red" ><%=TicketDetails.getNoteBlocco() %></font><br><br>
	
	<% if (TicketDetails.getClosed() == null) { %>
		
		<% if(TicketDetails.getIdStabilimento() > 0 || TicketDetails.getOrgId() > 0) { %>
		
		<dhv:permission name="operazioni-hd-view">
		<input type="button"
			value="Chiusura per HD"
			onClick="this.form.action='<%=TicketDetails.getURlDettaglio() %>AltreNonConformita.do?command=Chiudi&stabId=<%=TicketDetails.getIdStabilimento()%>&id=<%= TicketDetails.getId() %>';if( confirm('Sei sicuro di voler chiudere La non Conformita? \n Attenzione! La pratica verrà chiusa e non sarà più possibile fare modifiche \n sulla scheda se non con il permesso del supervisore o dell amministratore') ){loadModalWindow();submit()};">
		</dhv:permission>
		<% } else { %>
		<dhv:permission name="operazioni-hd-view">
		<input type="button"
			value="Chiusura per HD"
			onClick="this.form.action='ApicolturaApiariAltreNonConformita.do?command=Chiudi&stabId=<%=TicketDetails.getIdApiario()%>&id=<%= TicketDetails.getId() %>';if( confirm('Sei sicuro di voler chiudere La non Conformita? \n Attenzione! La pratica verrà chiusa e non sarà più possibile fare modifiche \n sulla scheda se non con il permesso del supervisore o dell amministratore') ){loadModalWindow();submit()};">
		</dhv:permission>
		<% } %>
	<% }
			}

		if (TicketDetails.isTrashed() && !TicketDetails.isflagBloccoCu()) {
	%>
	<dhv:permission name="<%=permission_op_edit%>" >
		<input type="button"
			value="<dhv:label name="button.restore">Restore</dhv:label>"
			onClick="javascript:this.form.action='<%=TicketDetails.getURlDettaglio() %>AltreNonConformita.do?command=Restore&id=<%= TicketDetails.getId()%>';submit();">
	</dhv:permission>
	<%
		}else if (!TicketDetails.isflagBloccoCu() && (TicketDetails.getClosed() != null || TicketDetails.isChiusura_attesa_esito()==true)) {
			if (TicketDetails.getClosed() != null && User.getUserRecord().getGruppo_ruolo()==UserUtils.getUserFormId(request, TicketDetails.getEnteredBy()).getGruppo_ruolo())
			{
	%>
	<%if(TicketDetails.getIdStabilimento() > 0 || TicketDetails.getOrgId() > 0) {%>
	<%if (CU.getStatusId()!=2){ %>
	<dhv:permission name="reopen-reopen-view">
		<input type="button"
			value="<dhv:label name="button.reopen">Reopen</dhv:label>"
			onClick="javascript:this.form.action='<%=TicketDetails.getURlDettaglio() %>AltreNonConformita.do?command=ReopenTicket&id=<%= TicketDetails.getId()%><%= (defectCheck != null && !"".equals(defectCheck.trim())?"&defectCheck="+defectCheck:"") %>';loadModalWindow();submit();">
	</dhv:permission>
	<%} } else { %>
	<%if (CU.getStatusId()!=2){ %>
	<dhv:permission name="reopen-reopen-view">
		<input type="button"
			value="<dhv:label name="button.reopen">Reopen</dhv:label>"
			onClick="javascript:this.form.action='ApicolturaApiariAltreNonConformita.do?command=ReopenTicket&id=<%= TicketDetails.getId()%><%= (defectCheck != null && !"".equals(defectCheck.trim())?"&defectCheck="+defectCheck:"") %>';loadModalWindow();submit();">
	</dhv:permission>
	
	<% } } %>
	<%
			}
	
		} else {
			if (TicketDetails.isflagBloccoCu()==false && User.getUserRecord().getGruppo_ruolo()==UserUtils.getUserFormId(request, TicketDetails.getEnteredBy()).getGruppo_ruolo())
			{
	%>
	<%if(TicketDetails.getIdStabilimento() > 0 || TicketDetails.getOrgId() > 0) {%>
	<dhv:permission name="<%=permission_op_edit%>">
		<input type="button"
			value="<dhv:label name="global.button.modify">Modify</dhv:label>"
			onClick="javascript:this.form.action='<%=TicketDetails.getURlDettaglio() %>AltreNonConformita.do?command=ModifyTicket&auto-populate=true<%= (defectCheck != null && !"".equals(defectCheck.trim())?"&defectCheck="+defectCheck:"") %>';loadModalWindow();submit();">
	</dhv:permission>
<%} else { %>
<dhv:permission name="<%=permission_op_edit%>">
		<input type="button"
			value="<dhv:label name="global.button.modify">Modify</dhv:label>"
			onClick="javascript:this.form.action='ApicolturaApiariAltreNonConformita.do?command=ModifyTicket&auto-populate=true<%= (defectCheck != null && !"".equals(defectCheck.trim())?"&defectCheck="+defectCheck:"") %>';loadModalWindow();submit();">
	</dhv:permission>

<% } %>
	
	<dhv:permission name="<%=permission_op_del%>">
		<%
			if ("searchResults".equals(request
								.getParameter("return"))) {
		%>
		<% if(TicketDetails.getIdStabilimento() > 0 || TicketDetails.getOrgId() > 0) { %>
		<input type="button"
			value="<dhv:label name="global.button.delete">Delete</dhv:label>"
			onClick="javascript:popURL('<%=TicketDetails.getURlDettaglio() %>AltreNonConformita.do?command=ConfirmDelete&id=<%= TicketDetails.getId() %>&stabId=<%=TicketDetails.getIdStabilimento()%>&orgId=<%=TicketDetails.getOrgId()%>&return=searchResults&popup=true', 'Delete_ticket','320','200','yes','no');">
		<% } else {%>
			<input type="button"
			value="<dhv:label name="global.button.delete">Delete</dhv:label>"
			onClick="javascript:popURL('ApicolturaApiariAltreNonConformita.do?command=ConfirmDelete&id=<%= TicketDetails.getId() %>&stabId=<%=TicketDetails.getIdApiario()%>&orgId=<%=TicketDetails.getOrgId()%>&return=searchResults&popup=true', 'Delete_ticket','320','200','yes','no');">
		<% }
		
			} else {
		%>
		<% if(TicketDetails.getIdStabilimento() > 0 || TicketDetails.getOrgId() > 0)  {%>
		 <input type="button"
			value="<dhv:label name="global.button.delete">Delete</dhv:label>"
			onClick="javascript:popURL('<%=TicketDetails.getURlDettaglio() %>AltreNonConformita.do?command=ConfirmDelete&id=<%= TicketDetails.getId() %>&stabId=<%=TicketDetails.getIdStabilimento()%>&orgId=<%=TicketDetails.getOrgId()%>&popup=true', 'Delete_ticket','320','200','yes','no');">
		<% } else { %>
		<input type="button"
			value="<dhv:label name="global.button.delete">Delete</dhv:label>"
			onClick="javascript:popURL('ApicolturaApiariAltreNonConformita.do?command=ConfirmDelete&id=<%= TicketDetails.getId() %>&stabId=<%=TicketDetails.getIdApiario()%>&orgId=<%=TicketDetails.getOrgId()%>&popup=true', 'Delete_ticket','320','200','yes','no');">
		<% } %>	 
		<%
			}
		%>
	</dhv:permission>
	<dhv:permission name="<%=permission_op_edit%>">
	<% if(TicketDetails.getIdStabilimento() > 0 || TicketDetails.getOrgId() > 0) {%>
		<input type="button"
			value="Chiudi"
			onClick="this.form.action='<%=TicketDetails.getURlDettaglio() %>AltreNonConformita.do?command=Chiudi&stabId=<%=TicketDetails.getIdStabilimento()%>&id=<%= TicketDetails.getId() %>';if( confirm('Sei sicuro di voler chiudere La non Conformita? \n Attenzione! La pratica verrà chiusa e non sarà più possibile fare modifiche \n sulla scheda se non con il permesso del supervisore o dell amministratore') ){loadModalWindow();submit()};">
	<% } else { %>
	<input type="button"
			value="Chiudi"
			onClick="this.form.action='ApicolturaApiariAltreNonConformita.do?command=Chiudi&stabId=<%=TicketDetails.getIdApiario()%>&id=<%= TicketDetails.getId() %>';if( confirm('Sei sicuro di voler chiudere La non Conformita? \n Attenzione! La pratica verrà chiusa e non sarà più possibile fare modifiche \n sulla scheda se non con il permesso del supervisore o dell amministratore') ){loadModalWindow();submit()};">
	<% } %>
	</dhv:permission>
		<%} %>

	<%
		
		}
	%>