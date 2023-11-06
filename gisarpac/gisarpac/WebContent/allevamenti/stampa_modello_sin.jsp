<jsp:useBean id="Piani2" class="org.aspcfs.utils.web.LookupList" scope="request"/>


<script type="text/javascript">
function openModSinLatte(orgId,idControllo,url){
	var res;
	var result;
	var mes = document.getElementById('messaggio_sin').value;
	if( mes != '' && mes != 'null'){
		alert(mes);
	}else{
		window.open('CampioniReport.do?command=ViewSchedaSIN&idControllo='+idControllo+'&orgId='+orgId+'&url='+url+'&tipo=latte','popupSelect',
		'height=800px,width=1280px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
	}		

	
		
}
</script>

<% String messaggio_sin = (String) request.getAttribute("messaggio_sin"); %>
<input type = "hidden" name="messaggio_sin" id="messaggio_sin" value="<%=messaggio_sin%>"/>
<dhv:evaluate if="<%= Piani2.getSelectedValue(TicketDetails.getMotivazione_piano_campione()).contains("57") %>">
<% if(request.getAttribute("link_visibile").equals("si")) { %> 
<%-- <% if(OrgDetails.getSpecieAllev().contains("OVINI") || OrgDetails.getSpecieAllev().contains("CAPRINI")) { %> --%>
	<% //if(OrgDetails.getOrientamentoProd().contains("LATTE") || OrgDetails.getOrientamentoProd().contains("MISTO")){ %>
		<div class="pulsanteStampa" id="stampaSchedaCampione">
			 <%-- <a href="CampioniReport.do?command=StampaSchedaSIN&idControllo=<%=TicketDetails.getId()%>&orgId=<%=TicketDetails.getOrgId()%>&url=<%=TicketDetails.getURlDettaglio() %>&tipo=latte"
				id="verbale" target="_blank">Stampa Modello SIN Latte</a>--%>
				
		   <a href= "#" onclick="javascript:openModSinLatte('<%= TicketDetails.getOrgId() %>','<%=TicketDetails.getId()%>','<%=TicketDetails.getURlDettaglio()%>');"
				id="verbale" target="_self">Stampa Modello SIN Latte</a>
				
				
		</div>
	<% //} %>
<% } %>

<% if(OrgDetails.getSpecieAllev().contains("AVICOLI") || OrgDetails.getSpecieAllev().contains("VOLATILI")) { %>
	<% //if(OrgDetails.getOrientamentoProd().contains("UOVA")){ %>
	<div class="pulsanteStampa" id="stampaSchedaCampione" style="margin-right:10px;">
		<a href="CampioniReport.do?command=StampaSchedaSIN&idControllo=<%=TicketDetails.getId()%>&orgId=<%=TicketDetails.getOrgId()%>&url=<%=TicketDetails.getURlDettaglio() %>&tipo=uova"
			id="verbale" target="_blank">Stampa Modello SIN Uova</a>
	</div>
	<% //}%>
<% }%>

</dhv:evaluate>