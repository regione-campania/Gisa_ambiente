<jsp:useBean id="TicketDetails" class="org.aspcfs.modules.troubletickets.base.Ticket" scope="request"/>

<% 
String redirect = "";
redirect = TicketDetails.getURlDettaglio()+"Vigilanza.do?command=TicketDetails";
redirect+="&id="+TicketDetails.getId();

if (TicketDetails.getIdStabilimento()>0)
	redirect +="&stabId="+TicketDetails.getIdStabilimento()+"&idStabilimentoopu="+TicketDetails.getIdStabilimento();
if (TicketDetails.getOrgId()>0)	
	redirect +="&orgId="+TicketDetails.getOrgId();
if (TicketDetails.getIdApiario()>0)	
	redirect +="&idApiario="+TicketDetails.getIdApiario();
if (TicketDetails.getAltId()>0)
	redirect +="&altId="+TicketDetails.getAltId();
%>

<% if (TicketDetails.getId()>0) { %>
	<script>
	loadModalWindow();
	window.location.href="<%=redirect%>";
	</script>
<% } else { %>

<font color="red">Controllo ufficiale non trovato.</font>
<% } %>