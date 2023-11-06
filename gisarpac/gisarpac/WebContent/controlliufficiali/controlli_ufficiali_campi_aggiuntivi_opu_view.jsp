<script language="JavaScript" TYPE="text/javascript" SRC="javascript/ControlliUfficialiCampiAggiuntiviOpu.js"></script>


<!-- <tr id="Allev01"  style="display:none" class="campiAggiuntiviLinea"> -->
<!-- <td colspan="2" class="formLabel"> -->
<!-- 	<table cellpadding="4" cellspacing="0" width="100%" class="details"> -->
<!-- <tr id="preavviso"   class="containerBody"> -->
<!-- 		<td  class="formLabel"> -->
<!-- 			Effettuato Preavviso -->
<!-- 			</td> -->
<!-- 		<td> -->
<%-- 		<%if ("N".equalsIgnoreCase(TicketDetails.getFlag_preavviso()) ){%>Nessun Preavviso<%}  --%>
<%-- 		else if ("P".equalsIgnoreCase(TicketDetails.getFlag_preavviso()) ){%>Telefono<%}  --%>
<%-- 		else if ("T".equalsIgnoreCase(TicketDetails.getFlag_preavviso()) ){%>Telegramma<%} --%>
<%-- 		else if ("A".equalsIgnoreCase(TicketDetails.getFlag_preavviso()) ){%>Altro<%}  --%>
<%-- 		 else {  %>Nessun Preavviso<%} %> --%>
<!-- 		</td> -->
<!-- 		</tr> -->
		
		
<%-- 		<%if (TicketDetails.getData_preavviso_ba() != null) {%> --%>
<!-- 		<tr id="data_preavviso_ba_tr" class="containerBody"> -->
<!-- 		<td  class="formLabel"> -->
<!-- 			Data Preavviso -->
<!-- 			</td> -->
<!-- 		<td> -->
		
<%-- 		<%=toDateasString(TicketDetails.getData_preavviso_ba())%> --%>
		
<!-- 		</td> -->
<!-- 		</tr> -->
<%-- 		<%}%> --%>
<!-- </table></td></tr> -->


<script>
<% if (request.getAttribute("linea_attivita") != null) {
	ArrayList<LineeAttivita> linee = (ArrayList<LineeAttivita>) request.getAttribute("linea_attivita");
	for (LineeAttivita linea_di_attivita : linee) {
	int idLinea = linea_di_attivita.getId();%>
	controllaCampiAggiuntiviLinea('<%=idLinea%>');
	<%} }%>
</script>
