
<%@page import="org.aspcfs.utils.web.LookupList"%>

<script language="javascript">
function openPopupModules(orgId, ticketId, idCU, url, tipo){
        var res;
        var result;
  
        	  window.open('PrintModulesHTML.do?command=ViewModules&orgId='+orgId+'&ticketId='+ticketId+'&idCU='+idCU+'&url='+url+'&tipo='+tipo,'popupSelect',
              'height=800px,width=1280px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
    		
    		
    		
        
               
        
} 

</script>

 <script type="text/javascript">
 function openModificaModulo(orgId,idCampione,idC, url, mod){
	//var mes = document.getElementById('messaggio_pnaa').value;
	var mes = '';
	
	if( mes != '' && mes != 'null'){
		alert(mes);
	}else{
		
		  window.open('CampioniReport.do?command=ModificaSchedaModulo&idCampione='+idCampione+'&idCU='+idC+'&orgId='+orgId+'&url='+url+'&tipoModulo='+mod,'popupSelect',
				'height=600px,width=800px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
   }				
}
</script>

 <script language="JavaScript" TYPE="text/javascript"
	SRC="gestione_documenti/generazioneDocumentale.js"></script>
	
		
	<% 
	String tipoModulo = null;
	String nomeModulo = null;

      if (PopolaCombo.isPrevistoVerbaleCampione(TicketDetails.getId(), "modello_2")){
    	  tipoModulo = "2";
    	  nomeModulo = "Mod. Microbiologico";
      }
      else if (PopolaCombo.isPrevistoVerbaleCampione(TicketDetails.getId(), "modello_3")){
    	  tipoModulo = "3";
    	  nomeModulo = "Mod. Chimico";
      }
  
	%>
	
	
	
<% if (tipoModulo != null) { %>	
<div align="right" style="padding-left: 210px; margin-bottom: 45px">
<% if (TicketDetails.getClosed()==null) { %>
<br><a href="javascript:openModificaModulo('<%= OrgDetails.getOrgId() %>', '<%= TicketDetails.getId() %>', '<%= TicketDetails.getIdControlloUfficiale() %>', '<%= TicketDetails.getURlDettaglio() %>', '<%=tipoModulo%>' );">
<font size="3px" color="#006699" style="font-weight: bold;">
	Modifica Dati <%=nomeModulo %>
</font>
</a>
<% } %>
<br><a style="text-decoration: none; color:black;" href="javascript:openRichiestaPDF_ModuliCampione('<%= TicketDetails.getId() %>','<%= OrgDetails.getOrgId() %>', '<%= TicketDetails.getIdControlloUfficiale() %>', '<%= TicketDetails.getURlDettaglio() %>', '<%=tipoModulo%>' );">
<input type="button" 
	value="Stampa <%=nomeModulo%>"/> 
</a>
</div>
<%  } %>

<%-- <input type="hidden" name="tipoAnalita" id="tipoAnalita" value="<%=tipoAnalita%>" /> --%>