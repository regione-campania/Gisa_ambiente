
<script>
function openPopup(link){
	  	  window.open(link,'popupSelect',
	              'height=400px,width=400px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');

		}
		
</script>


<%@page import="org.aspcfs.modules.opu.base.DatiMobile"%>
<%	DatiMobile dm = TicketDetails.getDatiMobile(); %>


<table cellpadding="4" cellspacing="0" class="details" width="100%">

<col width="20%">
	<tr>
		<th colspan="2"><strong><dhv:label name="">Stabilimento attivit� mobile: Informazioni autoveicolo soggetto a controllo</dhv:label></strong>	</th>
	</tr>
	
	
	<tr><td class="formLabel">Targa/matricola</td> <td><%=dm.getTarga() %></td></tr>
	<tr><td class="formLabel">Tipo</td> 	<td><%=TipoMobili.getSelectedValue(dm.getTipo())%></td></tr>
	<tr><td class="formLabel">Carta di circolazione</td> 	<td><a href="#" onClick="openPopup('GestioneAllegatiUploadSuap.do?command=DownloadPDF&codDocumento=<%=dm.getCarta() %>&nomeDocumento=<%=dm.getTarga()%>'); return false;">Download</a></td></tr> 
	</table>
	
	
<br>

<table cellpadding="4" cellspacing="0" class="details" width="60%" >
	<tr>
		<th colspan="2"><strong><dhv:label name="">Luogo Del Controllo</dhv:label></strong>
		</th>
	</tr>
	


 <tr class="containerBody">
      <td nowrap class="formLabel">
       Comune
      </td>
      <td>
     <%=TicketDetails.getComuneControllo() %>
      
      </td>
    </tr>
    

 <tr class="containerBody">
      <td nowrap class="formLabel">
       Luogo
      </td>
      <td>
        <%=TicketDetails.getLuogoControlloTarga() %>
      </td>
    </tr>
    </table>

