<script language="JavaScript" TYPE="text/javascript" SRC="javascript/ControlliUfficialiCampiAggiuntiviOpu.js"></script>

<%-- <tr id="Allev01"  <% if(TicketDetails.getFlag_preavviso()!= null) { %> style="display:block"<% } %> class="campiAggiuntiviLinea"> --%>
<tr id="Allev01"  <% if(TicketDetails.getFlag_preavviso()== null || TicketDetails.getFlag_preavviso().equals("-1")) { %> style="display:none"<% } %>>
<td colspan="2" class="formLabel">
	<table cellpadding="4" cellspacing="0" width="100%" class="details">
<tr id="preavviso"   class="containerBody">
		<td  class="formLabel">
			Effettuato Preavviso
			</td>
		<td>
		<select id= "flag_preavviso" name = "flag_preavviso" onchange="if(document.getElementById('flag_preavviso').value != '-1'&& document.getElementById('flag_preavviso').value!='N'){document.getElementById('data_preavviso_ba_tr').style.display=''}else{document.getElementById('data_preavviso_ba_tr').style.display='none';document.getElementById('data_preavviso_ba').value='';}">
		<option value = "-1" selected="selected" >Seleziona Voce</option>
		<option value = "N" <%if ("N".equalsIgnoreCase(TicketDetails.getFlag_preavviso()) ){%>selected="selected"<%} %>>Nessun Preavviso</option>
		<option value = "P" <%if ("P".equalsIgnoreCase(TicketDetails.getFlag_preavviso()) ){%>selected="selected"<%} %>>Telefono</option>
		<option value = "T" <%if ("T".equalsIgnoreCase(TicketDetails.getFlag_preavviso()) ){%>selected="selected"<%} %>>Telegramma</option>
		<option value = "A" <%if ("A".equalsIgnoreCase(TicketDetails.getFlag_preavviso()) ){%>selected="selected"<%} %>>Altro</option>
		
		</select>
		</td>
		</tr>
		
		<tr id="data_preavviso_ba_tr" <%if( TicketDetails.getFlag_preavviso()==null || TicketDetails.getFlag_preavviso().equals("N") || TicketDetails.getFlag_preavviso().equals("-1")){%>style="display: none"<%}%>class="containerBody">
		<td  class="formLabel">
			Data Preavviso
			</td>
		<td>
		
					<input readonly type="text" id="data_preavviso_ba" name="data_preavviso_ba" size="10" value = "<%=toDateasString(TicketDetails.getData_preavviso_ba())%>"/>
		<a href="#" onClick="cal19.select(document.forms[0].data_preavviso_ba,'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19">
		<img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
		
		</td>
		</tr>
</table></td></tr>


<!-- <script> -->
<%-- recuperaLineaSottoposta('<%=TicketDetails.getId()%>'); --%>
<!-- </script> -->

