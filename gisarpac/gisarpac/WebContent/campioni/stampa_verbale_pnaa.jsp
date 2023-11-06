<script type="text/javascript">
function openModPnaa(orgId,idCampione,url, idC, mod){
	//var mes = document.getElementById('messaggio_pnaa').value;
	var mes = '';
	
	if( mes != '' && mes != 'null'){
		alert(mes);
	}else{
		
		  window.open('CampioniReport.do?command=ViewSchedaPNAA2&idCampione='+idCampione+'&idCU='+idC+'&orgId='+orgId+'&url='+url+'&tipo='+mod,'popupSelect',
				'height=800px,width=1280px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
   }				
}
</script>
 
 <script type="text/javascript">
 function openModificaPnaa(orgId,idCampione,url, idC, mod){
	//var mes = document.getElementById('messaggio_pnaa').value;
	var mes = '';
	
	if( mes != '' && mes != 'null'){
		alert(mes);
	}else{
		
		  window.open('CampioniReport.do?command=ModificaSchedaPNAA2&idCampione='+idCampione+'&idCU='+idC+'&orgId='+orgId+'&url='+url+'&tipo='+mod,'popupSelect',
				'height=600px,width=800px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
   }				
}
</script>

<dhv:permission name="stampa-verbale-pnaa-view">
<%	if (1==1 || TicketDetails.getSiteId() == 204 || TicketDetails.getSiteId() == 202) {%>
<% String messaggio_pnaa = (String) request.getAttribute("gestione_pnaa"); %>
<input type = "hidden" name="messaggio_pnaa" id="messaggio_pnaa" value="<%=messaggio_pnaa%>"/>

<% if(messaggio_pnaa != null && !messaggio_pnaa.equals("") && messaggio_pnaa.equals("true")) { %>

<% if (TicketDetails.getClosed()==null){ %>
<dhv:permission name="stampa-verbale-pnaa-edit">
<div class="pulsanteModifica" id="ModificaSchedaPNAA">
	<a href= "#" onclick="javascript:openModificaPnaa('<%= TicketDetails.getOrgId() %>','<%=TicketDetails.getId()%>','<%=TicketDetails.getURlDettaglio()%>','<%=TicketDetails.getIdControlloUfficiale() %>','19');"
	id="verbale" target="_self">Modifica Scheda PNAA </a>		
	</div>
</dhv:permission>
<% } %>
	<div class="pulsanteStampa" id="stampaSchedaCampione">
	<a href= "#" onclick="javascript:openModPnaa('<%= (TicketDetails.getOrgId()<0)?(TicketDetails.getIdStabilimento()):(TicketDetails.getOrgId()) %>','<%=TicketDetails.getId()%>','<%=TicketDetails.getURlDettaglio()%>','<%=TicketDetails.getIdControlloUfficiale() %>','19');"
	id="verbale" target="_self">Stampa Verbale Prelievo PNAA</a>		
	</div>
<% } 
}%>	

</dhv:permission>