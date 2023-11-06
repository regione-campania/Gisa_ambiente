  <jsp:useBean id="SanzioniListNcTerzi" class="org.aspcfs.modules.sanzioni.base.TicketList" scope="request"/>

<%String permesso = TicketDetails.getPermission_ticket(); 
String permesso_nonconformita=permesso+"-nonconformita-view";
String permesso_campioni=permesso+"-campioni-view";


%>

<%@page import="org.aspcfs.utils.UserUtils"%>
<table cellpadding="4" cellspacing="0" width="100%">
     <tr>
 <!-- Se il controllo e aperto e non bloccato -->
   <%if( TicketDetails.getClosed()==null && ! TicketDetails.isflagBloccoCu()){

   %>
	   <% if(TicketDetails.getTipoCampione()!=5 && User.getUserRecord().getGruppo_ruolo()==UserUtils.getUserFormId(request, TicketDetails.getEnteredBy()).getGruppo_ruolo()){ // sorveglianza %>
	     
	  <%
	  
	  %>
    	<td>
    	<%if (!TicketDetails.getURlDettaglio().toLowerCase().contains("acquerete") && TicketDetails.getTipoCampione()!=26){ %>
    	    	<dhv:permission name="<%=permesso_campioni %>">
    		<a href="<%=TicketDetails.getURlDettaglio()%>Campioni.do?command=Add&idC=<%=TicketDetails.getId()%>&idControllo=<%=TicketDetails.getPaddedId() %>&dataC=<%=TicketDetails.getAssignedDate() %>&stabId=<%= (OrgDetails.getIdStabilimento()==-1)?(TicketDetails.getIdStabilimento()):(OrgDetails.getIdStabilimento()) %>&orgId=<%= (OrgDetails.getOrgId()==-1)?(TicketDetails.getOrgId()):(OrgDetails.getOrgId()) %>&altId=<%= (OrgDetails.getAltId()==-1)?(TicketDetails.getAltId()):(OrgDetails.getAltId()) %><%= addLinkParams(request, "popup|popupType|actionId") %>"><dhv:label name="accounts.richiesta.add" >Inserisci Campione</dhv:label></a>
    		</dhv:permission>
    		
    		<%} %>
    	</td>
    	
    	<%}%>
    	
    	
    	 <% if(TicketDetails.getTipoCampione()!=5 /*&& (View==null ||"".equals(View) )*/ && User.getUserRecord().getGruppo_ruolo()==UserUtils.getUserFormId(request, TicketDetails.getEnteredBy()).getGruppo_ruolo()){ // sorveglianza %>
	     
	  
    	<td>
<%--     		<a href="<%=TicketDetails.getURlDettaglio()%>Tamponi.do?command=Add&idC=<%=TicketDetails.getId()%>&idControllo=<%=TicketDetails.getPaddedId() %>&dataC=<%=TicketDetails.getAssignedDate() %>&orgId=<%= (OrgDetails.getOrgId()==-1)?(TicketDetails.getOrgId()):(OrgDetails.getOrgId()) %><%= addLinkParams(request, "popup|popupType|actionId") %>"><dhv:label name="accounts.richiesta.add">Inserisci Tampone</dhv:label></a> --%>
    	</td>
    	
    	<%}%>
    	
    	<%
    	if (NonCList.size()==0 && User.getUserRecord().getGruppo_ruolo()==UserUtils.getUserFormId(request, TicketDetails.getEnteredBy()).getGruppo_ruolo()) 
    	{
    	%>
    	<td>
    	
    	<dhv:permission name="<%=permesso_nonconformita %>">
    	
    		<a href="<%=TicketDetails.getURlDettaglio()%>NonConformita.do?command=Add&idC=<%=TicketDetails.getId()%>&idControllo=<%=TicketDetails.getPaddedId() %>&dataC=<%=TicketDetails.getAssignedDate() %>&stabId=<%= (OrgDetails.getIdStabilimento()==-1)?(TicketDetails.getIdStabilimento()):(OrgDetails.getIdStabilimento()) %>&orgId=<%= (OrgDetails.getOrgId()==-1)?(TicketDetails.getOrgId()):(OrgDetails.getOrgId()) %>&altId=<%= (OrgDetails.getAltId()==-1)?(TicketDetails.getAltId()):(OrgDetails.getAltId()) %><%= addLinkParams(request, "popup|popupType|actionId") %>"><dhv:label name="accounts.richiesta.add">Inserisci Non Conformità Rilevate</dhv:label></a>
    		
    		</dhv:permission>
    	</td>
    	<%} %>
    	
    	
    	<%if( User.getUserRecord().getGruppo_ruolo()==UserUtils.getUserFormId(request, TicketDetails.getEnteredBy()).getGruppo_ruolo()) {%>
    	<td>
    	    	<dhv:permission name="<%=permesso_nonconformita %>">
    	
    		<a href="<%=TicketDetails.getURlDettaglio()%>AltreNonConformita.do?command=Add&idC=<%=TicketDetails.getId()%>&idControllo=<%=TicketDetails.getPaddedId() %>&dataC=<%=TicketDetails.getAssignedDate() %>&stabId=<%= (OrgDetails.getIdStabilimento()==-1)?(TicketDetails.getIdStabilimento()):(OrgDetails.getIdStabilimento()) %>&orgId=<%= (OrgDetails.getOrgId()==-1)?(TicketDetails.getOrgId()):(OrgDetails.getOrgId()) %>&altId=<%= (OrgDetails.getAltId()==-1)?(TicketDetails.getAltId()):(OrgDetails.getAltId()) %><%= addLinkParams(request, "popup|popupType|actionId") %>"><dhv:label name="accounts.richiesta.add">Inserisci Non Conformita' <br><b>NON</b> a carico del soggetto ispezionato</dhv:label></a>
    	</dhv:permission>
    	</td>
    	<%} %>
    	
    	
     </tr>
   </table>
 
   
   <%}
   else
   {
	   if( TicketDetails.isflagBloccoCu() && TicketDetails.isFlagBloccoNonConformita()==false){
		   
		   
	    	if (NonCList.size()==0 && User.getUserRecord().getGruppo_ruolo()==UserUtils.getUserFormId(request, TicketDetails.getEnteredBy()).getGruppo_ruolo()) 
	    	{
	    	%>
	    	<td>
	    	
	    		<font style="color: red"> <a href="#" onclick="alert('Attenzione questa funzione serve a inserire sanzioni in seguito a esito di campioni non conformi.');location.href='<%=TicketDetails.getURlDettaglio()%>NonConformita.do?command=Add&idC=<%=TicketDetails.getId()%>&idControllo=<%=TicketDetails.getPaddedId() %>&dataC=<%=TicketDetails.getAssignedDate() %>&stabId=<%= (OrgDetails.getIdStabilimento()==-1)?(TicketDetails.getIdStabilimento()):(OrgDetails.getIdStabilimento()) %>&orgId=<%= (OrgDetails.getOrgId()==-1)?(TicketDetails.getOrgId()):(OrgDetails.getOrgId()) %><%= addLinkParams(request, "popup|popupType|actionId") %>'"><dhv:label name="accounts.richiesta.add">Aggiungi Sanzione Posticipata Per Esito Campione Non Favorevole</dhv:label></a></font>
	    	</td>
	    	<%}
	    	else
	    	{
	    		if(NonCList.size()>0)
	    		{
	    			%>
	    					    		<font style="color: red"> <a href="#" onclick="alert('Attenzione questa funzione serve a gestire la necessità di inserimento di una sazione fuori tempo massimo per una errata operazione utente che ha inserito e completato il controllo');location.href='<%=TicketDetails.getURlDettaglio()%>NonConformita.do?command=ModifyTicket&id=<%=((org.aspcfs.modules.nonconformita.base.Ticket)NonCList.get(0)).getId() %>&idC=<%=TicketDetails.getId()%>&idControllo=<%=TicketDetails.getPaddedId() %>&dataC=<%=TicketDetails.getAssignedDate() %>&stabId=<%= (OrgDetails.getIdStabilimento()==-1)?(TicketDetails.getIdStabilimento()):(OrgDetails.getIdStabilimento()) %>&orgId=<%= (OrgDetails.getOrgId()==-1)?(TicketDetails.getOrgId()):(OrgDetails.getOrgId()) %>'">Aggiungi Sanzione Posticipata Per Esito Campione Non Favorevole</a></font>
	    			
	
	    			<%
	    		}
	    	}
		   
	   }
	   else
	   {
		   
		   if(  TicketDetails.isflagBloccoCu() && TicketDetails.isFlagBloccoNonConformita()==true){
			   
			   
		    	if (NonCList.size()==0 && User.getUserRecord().getGruppo_ruolo()==UserUtils.getUserFormId(request, TicketDetails.getEnteredBy()).getGruppo_ruolo()) 
		    	{
		    	%>
		    	
		    	<td>
		    	<dhv:permission name="global-sanzione-posticipata-add">
		    		<font style="color: red"> <a href="#" onclick="alert('Attenzione questa funzione serve a gestire la necessità di inserimento di una sazione fuori tempo massimo per una errata operazione utente che ha inserito e completato il controllo');location.href='<%=TicketDetails.getURlDettaglio()%>NonConformita.do?command=Add&idC=<%=TicketDetails.getId()%>&idControllo=<%=TicketDetails.getPaddedId() %>&dataC=<%=TicketDetails.getAssignedDate() %>&stabId=<%= (OrgDetails.getIdStabilimento()==-1)?(TicketDetails.getIdStabilimento()):(OrgDetails.getIdStabilimento()) %>&orgId=<%= (OrgDetails.getOrgId()==-1)?(TicketDetails.getOrgId()):(OrgDetails.getOrgId()) %><%= addLinkParams(request, "popup|popupType|actionId") %>'">Aggiungi Sanzione Posticipata</a></font>
		    	
		    	</dhv:permission>
		    	</td>
		    	<%}
		    	else
		    	{
		    		
		    		if(NonCList.size()>0 && SanzioniList.size()==0)
		    		{
		    			%>
<dhv:permission name="global-sanzione-posticipata-add">
		    		<font style="color: red"> <a href="#" onclick="alert('Attenzione questa funzione serve a gestire la necessità di inserimento di una sazione fuori tempo massimo per una errata operazione utente che ha inserito e completato il controllo');location.href='<%=TicketDetails.getURlDettaglio()%>NonConformita.do?command=ModifyTicket&id=<%=((org.aspcfs.modules.nonconformita.base.Ticket)NonCList.get(0)).getId() %>&idC=<%=TicketDetails.getId()%>&idControllo=<%=TicketDetails.getPaddedId() %>&dataC=<%=TicketDetails.getAssignedDate() %>&stabId=<%= (OrgDetails.getIdStabilimento()==-1)?(TicketDetails.getIdStabilimento()):(OrgDetails.getIdStabilimento()) %>&orgId=<%= (OrgDetails.getOrgId()==-1)?(TicketDetails.getOrgId()):(OrgDetails.getOrgId()) %>'">Aggiungi Sanzione Posticipata</a></font>
		    	
		    	</dhv:permission>		    			
		    			<%
		    		}
		    	}
			   
		   }
		   
		   
	   }
	   
	   
	   
	   
	   if( TicketDetails.isflagBloccoCu() && TicketDetails.isFlagBloccoNonConformitaContoTerzi()==false){
		   
		   
	    	if (AltreNonCList.size()==0 && User.getUserRecord().getGruppo_ruolo()==UserUtils.getUserFormId(request, TicketDetails.getEnteredBy()).getGruppo_ruolo()) 
	    	{
	    	%>
	    	<td>
	    	
	    		<font style="color: red"> <a href="#" onclick="alert('Attenzione questa funzione serve a inserire sanzioni in seguito a esito di campioni non conformi.');location.href='<%=TicketDetails.getURlDettaglio()%>AltreNonConformita.do?command=Add&idC=<%=TicketDetails.getId()%>&idControllo=<%=TicketDetails.getPaddedId() %>&dataC=<%=TicketDetails.getAssignedDate() %>&stabId=<%= (OrgDetails.getIdStabilimento()==-1)?(TicketDetails.getIdStabilimento()):(OrgDetails.getIdStabilimento()) %>&orgId=<%= (OrgDetails.getOrgId()==-1)?(TicketDetails.getOrgId()):(OrgDetails.getOrgId()) %><%= addLinkParams(request, "popup|popupType|actionId") %>'"><dhv:label name="accounts.richiesta.add">Aggiungi Sanzione a Carico di Terzi Posticipata Per Esito Campione Non Favorevole</dhv:label></a></font>
	    	</td>
	    	<%}
	    	else
	    	{
	    		if(AltreNonCList.size()>0  && SanzioniListNcTerzi.size()==0)
	    		{
	    			%>
		<font style="color: red"> <a href="#" onclick="alert('Attenzione questa funzione serve a gestire la necessità di inserimento di una sazione fuori tempo massimo per una errata operazione utente che ha inserito e completato il controllo');location.href='<%=TicketDetails.getURlDettaglio()%>AltreNonConformita.do?command=ModifyTicket&id=<%=((org.aspcfs.modules.altriprovvedimenti.base.Ticket)AltreNonCList.get(0)).getId() %>&idC=<%=TicketDetails.getId()%>&idControllo=<%=TicketDetails.getPaddedId() %>&dataC=<%=TicketDetails.getAssignedDate() %>&stabId=<%= (OrgDetails.getIdStabilimento()==-1)?(TicketDetails.getIdStabilimento()):(OrgDetails.getIdStabilimento()) %>&orgId=<%= (OrgDetails.getOrgId()==-1)?(TicketDetails.getOrgId()):(OrgDetails.getOrgId()) %>'">Aggiungi Sanzione Posticipata a Carica di Terzi Per Esito Campione Non Favorevole</a></font>
	    			
	
	    			<%
	    		}
	    	}
		   
	   }
	   else
	   {
		   
		   if(  TicketDetails.isflagBloccoCu() && TicketDetails.isFlagBloccoNonConformitaContoTerzi()==true){
			   
			   
		    	if (AltreNonCList.size()==0 && User.getUserRecord().getGruppo_ruolo()==UserUtils.getUserFormId(request, TicketDetails.getEnteredBy()).getGruppo_ruolo()) 
		    	{
		    	%>
		    	
		    	<td>
		    	<dhv:permission name="global-sanzione-posticipata-add">
		    		<font style="color: red"> <a href="#" onclick="alert('Attenzione questa funzione serve a gestire la necessità di inserimento di una sazione fuori tempo massimo per una errata operazione utente che ha inserito e completato il controllo');location.href='<%=TicketDetails.getURlDettaglio()%>AltreNonConformita.do?command=Add&idC=<%=TicketDetails.getId()%>&idControllo=<%=TicketDetails.getPaddedId() %>&dataC=<%=TicketDetails.getAssignedDate() %>&stabId=<%= (OrgDetails.getIdStabilimento()==-1)?(TicketDetails.getIdStabilimento()):(OrgDetails.getIdStabilimento()) %>&orgId=<%= (OrgDetails.getOrgId()==-1)?(TicketDetails.getOrgId()):(OrgDetails.getOrgId()) %><%= addLinkParams(request, "popup|popupType|actionId") %>'">Aggiungi Sanzione Posticipata  A carico di Terzi</a></font>
		    	
		    	</dhv:permission>
		    	</td>
		    	<%}
		    	else
		    	{
		    		
		    		if(AltreNonCList.size()>0 && SanzioniListNcTerzi.size()==0)
		    		{
		    			%>
		    			<td>
				<dhv:permission name="global-sanzione-posticipata-add">
		    		<font style="color: red"> <a href="#" onclick="alert('Attenzione questa funzione serve a gestire la necessità di inserimento di una sazione fuori tempo massimo per una errata operazione utente che ha inserito e completato il controllo');location.href='<%=TicketDetails.getURlDettaglio()%>AltreNonConformita.do?command=Add&idC=<%=TicketDetails.getId()%>&idControllo=<%=TicketDetails.getPaddedId() %>&dataC=<%=TicketDetails.getAssignedDate() %>&stabId=<%= (OrgDetails.getIdStabilimento()==-1)?(TicketDetails.getIdStabilimento()):(OrgDetails.getIdStabilimento()) %>&orgId=<%= (OrgDetails.getOrgId()==-1)?(TicketDetails.getOrgId()):(OrgDetails.getOrgId()) %><%= addLinkParams(request, "popup|popupType|actionId") %>'">Aggiungi Sanzione Posticipata  A carico di Terzi</a></font>
		    	
		    	</dhv:permission>	
		    	</td>	    			
		    			<%
		    		}
		    	}
			   
		   }
		   
		   
	   }
	   
	   
   }
   %>
   