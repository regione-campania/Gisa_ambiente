<script type="text/javascript" src="dwr/interface/PopolaCombo.js"> </script>
<script type="text/javascript" src="dwr/interface/DwrPreaccettazione.js"> </script>
<script type="text/javascript">
	function delete_campione_callback(returnValue){
		if (returnValue){
			window.location.href='Campioni.do?command=ViewElencoPrenotazioni&orgId='+<%=OrgDetails.getOrgId()%>;
		}
		else {
			alert('Impossibile cancellare campione.');
		}
	}

	function delete_campione(ticketid,idCU,orgId,idstab){
		if (idCU!="-1"){
			popURL('<%=TicketDetails.getURlDettaglio() %>Campioni.do?command=ConfirmDelete&id='+ticketid+'&stabId='+idstab+'&orgId='+orgId+'&popup=true', 'Delete_ticket','320','200','yes','no');
		} else{
			PopolaCombo.delete_campione(ticketid,delete_campione_callback);
		}
	}

	function openUltimiDocumenti(orgId, tipo, ticketId, idCU, tipoSin){
		var res;
		var result;
		
		window.open('GestioneDocumenti.do?command=GestioneDownloadUltimoPdf&orgId='+orgId+'&tipo='+tipo+'&ticketId='+ticketId+'&idCU='+idCU+'&tipoSin='+tipoSin,'open_window', 'height=295px,width=595px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');}
</script>

<script>
function completaDati(){
	var nomeAction = '<%=TicketDetails.getURlDettaglio()%>'+'Campioni.do';
	document.details.action='Campioni.do?command=ViewCompletaCampione&id=<%=TicketDetails.getId()%>&orgId=<%=OrgDetails.getOrgId()%>&ck_mot=<%=request.getAttribute("ck_mot")%>&ck_nv=<%=request.getAttribute("ck_nv")%>&ck_dp=<%=request.getAttribute("ck_dp")%>&ck_mat=<%=request.getAttribute("ck_mat")%>&ck_an=<%=request.getAttribute("ck_an")%>&input='+nomeAction;
	document.details.submit();
}
</script>

<% if(TicketDetails.isflagBloccoCu()==false){
	if (TicketDetails.isTrashed() ) {%>
	
		<dhv:permission name="<%=perm_op_delete%>">
		<input type="button" value="<dhv:label name="button.restore">Restore</dhv:label>"
		onClick="javascript:this.form.action='<%=TicketDetails.getURlDettaglio() %>Campioni.do?command=Restore&id=<%=TicketDetails.getId()%>;this.form.submit();'">
		</dhv:permission>
		
<% } 
	else if (TicketDetails.getClosed() != null) { 
	String scelta = (String) request.getAttribute("html_or_pdf");
	String gestione_pnaa = (String) request.getAttribute("gestione_pnaa");
	
	if(TicketDetails.getIdStabilimento() > 0 || TicketDetails.getOrgId() > 0){
	%>
		<dhv:permission name="reopen-reopen-view">
		<input type="button" value="<dhv:label name="button.reopen">Reopen</dhv:label>"
		onClick="loadModalWindow();javascript:location.href='<%=TicketDetails.getURlDettaglio() %>Campioni.do?command=ReopenTicket&id=<%=TicketDetails.getId()%>&stabId=<%=TicketDetails.getIdStabilimento() %>'">
		</dhv:permission>
 	<% } else { %>
 	<dhv:permission name="reopen-reopen-view">
		<input type="button" value="<dhv:label name="button.reopen">Reopen</dhv:label>"
		onClick="loadModalWindow();javascript:location.href='<%=TicketDetails.getURlDettaglio() %>Campioni.do?command=ReopenTicket&id=<%=TicketDetails.getId()%>&stabId=<%=TicketDetails.getIdApiario() %>'">
		</dhv:permission>
 	<% } %>
		<dhv:permission name="impresa-linkprintmodules-view">
	<%	if (1==1 || TicketDetails.getSiteId() == 204 || TicketDetails.getSiteId() == 202) {
			if (scelta.equals("HTML") && numero_include.equals("1")) {
				if (TicketDetails.getURlDettaglio()!= null &&  !TicketDetails.getURlDettaglio().startsWith("Acque") && (gestione_pnaa == null || !gestione_pnaa.equals("true"))) {	%>
					<%@ include file="/campioni/campioni_stampa_moduli_precompilati.jsp"%>
					<%} 
					} else if (numero_include.equals("1")){ %>
						<div align="right" style="padding-left: 210px; margin-bottom: 45px">
						<a href="javascript:openPopupModulesPdf('<%=OrgDetails.getOrgId()%>', '<%=TicketDetails.getId()%>' );">
						<font size="3px" color="#006699" style="font-weight: bold;">
						Stampa moduli precompilati</font></a></div>
					<% }
			} %>
		</dhv:permission>
		<%	} 
	else { 
		String flag = (String) request.getAttribute("flag");
		String scelta = (String) request.getAttribute("html_or_pdf");
		String gestione_pnaa = (String) request.getAttribute("gestione_pnaa");%>

			<dhv:permission name="<%=perm_op_delete%>">
			<input type="button" value="<dhv:label name="global.button.delete">Delete</dhv:label>"
			onClick="javascript:delete_campione('<%=TicketDetails.getId()%>','<%=TicketDetails.getIdControlloUfficiale()%>','<%=OrgDetails.getOrgId()%>','<%=OrgDetails.getIdStabilimento()%>');">
			</dhv:permission>

			<dhv:permission name="<%=perm_op_edit %>">
			<%	if (flag != null && flag.equals("1")) { //devi completare il campione... %>
				<input type="button" value="<dhv:label name="global.button.close">Chiudi</dhv:label>"
				onClick="javascript:alert('Attenzione! La pratica non può essere chiusa perchè i dati del campione non sono completi');">
			<%} 
			else { %>
				<input type="button" value="<dhv:label name="global.button.close">Chiudi</dhv:label>"
				onClick="javascript:this.form.action='<%=TicketDetails.getURlDettaglio() %>Campioni.do?command=Chiudi&stabId=<%=(OrgDetails.getIdStabilimento()>0)?(OrgDetails.getIdStabilimento()):(OrgDetails.getOrgId())%>&id=<%=TicketDetails.getId()%>';if( confirm('Sei sicuro di voler chiudere il campione? \n Attenzione! La pratica verrà chiusa e non sarà più possibile fare modifiche \n sulla scheda se non con il permesso del supervisore o dell amministratore') ){loadModalWindow();submit()};">
			<% }
			if (flag.equals("1")) {%>
				<input type="button" value="completa campione" id="completa"
				onClick="javascript:completaDati();" onmouseover="javascript:ddrivetip('Completa il campione con le informazioni non inserite in fase di prenotazione',150,'lightyellow');"
				onmouseout="javascript:hideddrivetip();">
			<% }%>
			</dhv:permission>

			<dhv:permission name="impresa-linkprintmodules-view">
			<% if(1==1 || TicketDetails.getSiteId() == 204 || TicketDetails.getSiteId() == 202) {		
				if (scelta.equals("HTML") && numero_include.equals("1")) {
					if (TicketDetails.getURlDettaglio()!= null &&  !TicketDetails.getURlDettaglio().startsWith("Acque") && (gestione_pnaa == null || !gestione_pnaa.equals("true")))
						{
						%>
							<%@ include file="/campioni/campioni_stampa_moduli_precompilati.jsp"%>
					<%}	
					} 
				else if (numero_include.equals("1")){	%>
			<div align="right" style="padding-left: 210px; margin-bottom: 45px">
			<a href="javascript:openPopupModulesPdf('<%=OrgDetails.getOrgId()%>', '<%=TicketDetails.getId()%>' );">
			<font size="3px" color="#006699" style="font-weight: bold;">
			Stampa moduli precompilati</font></a></div>
			<%}	
				}%>
			</dhv:permission>
			<%}
	}//fine blocco cuuuuuuuuuuuuuuu
			 else {	%>
				<font color = "red" ><%=TicketDetails.getNoteBlocco() %></font><br><br>
				<% if(TicketDetails.getClosed() == null) { 
					String flag = (String) request.getAttribute("flag");%>
		
		<dhv:permission name="operazioni-hd-view">
		<% if (flag != null && flag.equals("1")) { //devi completare il campione...	%>
		<input type="button" value="Chisura per HD"
		onClick="javascript:alert('Attenzione! La pratica non può essere chiusa perchè i dati del campione non sono completi');">
		<% } 
		else { %>
		<input type="button" value="Chiusura per HD"
		onClick="javascript:this.form.action='<%=TicketDetails.getURlDettaglio() %>Campioni.do?command=Chiudi&stabId=<%=OrgDetails.getOrgId()%>&id=<%=TicketDetails.getId()%>';if( confirm('Sei sicuro di voler chiudere il campione? \n Attenzione! La pratica verrà chiusa e non sarà più possibile fare modifiche \n sulla scheda se non con il permesso del supervisore o dell amministratore') ){submit()};">
		<% }%>
		</dhv:permission>
		
		<% if (flag!=null && flag.equals("1")) { %>
		<input type="button" value="completa campione" id="completa"
		onClick="javascript:completaDati();"
		onmouseover="javascript:ddrivetip('Completa il campione con le informazioni non inserite in fase di prenotazione',150,'lightyellow');"
		onmouseout="javascript:hideddrivetip();">
		<% }
		}
				}%>

		<!--  GESTIONE ESITI CAMPIONE -->

		<dhv:permission name="<%=perm_op_edit %>">
		<% if (!TicketDetails.isEsitoCampioneChiuso() || !TicketDetails.isInformazioniLaboratorioChiuso()){ 
		
			if(TicketDetails.getIdStabilimento() >0){
		%>
		<input type="button" style="background-color:#CC3300" value="Salva"
		onClick="javascript:this.form.action='<%=TicketDetails.getURlDettaglio()%>Campioni.do?command=UpdateTicketEsiti&id=<%=TicketDetails.getId()%>&stabId=<%=TicketDetails.getIdStabilimento()%>';if( confirm('Sei sicuro di voler salvare gli esiti? \n Attenzione! La modifica degli esiti degli analiti verrà chiusa e non sarà più possibile fare modifiche \n sulla scheda se non con il permesso del supervisore o dell amministratore') ){ if (checkFormEsiti()){submit()}};">
			<%} else {%>
				<input type="button" style="background-color:#CC3300" value="Salva"
			onClick="javascript:this.form.action='<%=TicketDetails.getURlDettaglio()%>Campioni.do?command=UpdateTicketEsiti&id=<%=TicketDetails.getId()%>&stabId=<%=TicketDetails.getIdApiario()%>';if( confirm('Sei sicuro di voler salvare gli esiti? \n Attenzione! La modifica degli esiti degli analiti verrà chiusa e non sarà più possibile fare modifiche \n sulla scheda se non con il permesso del supervisore o dell amministratore') ){ if (checkFormEsiti()){submit()}};">
			<%}%>
		<% } %>
		</dhv:permission>

		<dhv:permission name="riapertura_esiti_campioni-add">
		<% if (TicketDetails.isInformazioniLaboratorioChiuso()){ 
		
			if(TicketDetails.getIdStabilimento() >0){
		%>
		<input type="button" style="background-color:#CC3300" value="Riapri informazioni laboratorio"
		onClick="javascript:this.form.action='<%=TicketDetails.getURlDettaglio()%>Campioni.do?command=RiapriTicketEsiti&id=<%=TicketDetails.getId()%>&stabId=<%=TicketDetails.getIdStabilimento()%>';if( confirm('Sei sicuro di voler proseguire? \n La sezione Informazioni campione da laboratorio sarà nuovamente modificabile.') ){submit()};">
		<%} else{ %>
			<input type="button" style="background-color:#CC3300" value="Riapri informazioni laboratorio"
		onClick="javascript:this.form.action='<%=TicketDetails.getURlDettaglio()%>Campioni.do?command=RiapriTicketEsiti&id=<%=TicketDetails.getId()%>&stabId=<%=TicketDetails.getIdApiario()%>';if( confirm('Sei sicuro di voler proseguire? \n La sezione Informazioni campione da laboratorio sarà nuovamente modificabile.') ){submit()};">

		<% } 
			}%>
		</dhv:permission>


