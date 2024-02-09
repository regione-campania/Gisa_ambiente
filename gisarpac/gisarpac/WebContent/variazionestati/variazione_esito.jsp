<jsp:useBean id="TicketDetails" class="org.aspcfs.modules.troubletickets.base.Ticket" scope="request"/>
<jsp:useBean id="esitoVariazioneStatoLinee" class="java.lang.String" scope="request"/>
<jsp:useBean id="id" class="java.lang.String" scope="request"/>


<script>
loadModalWindow();
</script>

<% if (esitoVariazioneStatoLinee!=null && !esitoVariazioneStatoLinee.equals("")){ %>
<script>
alert('<%=esitoVariazioneStatoLinee%>');
</script>
<%} %>


<% String url = "";
url = TicketDetails.getURlDettaglioanagrafica()+".do?command=Details";

if (TicketDetails.getTipologia_operatore()==1)
	url+="&orgId="+id;
else if (TicketDetails.getTipologia_operatore()==999)
	url+="&stabId="+id;
%>

<script>
window.location.href = "<%=url%>";
</script>


