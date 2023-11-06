
<%@page import="java.util.ArrayList"%>
<%@page import="org.aspcfs.modules.accounts.base.ComuniAnagrafica"%>
<script>
function openPopup(link){
	  	  window.open(link,'popupSelect',
	              'height=400px,width=400px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');

		}
		
</script>


<%@page import="org.aspcfs.modules.opu.base.DatiMobile"%>


<table cellpadding="4" cellspacing="0" class="details" width="60%" >
	<tr>
		<th colspan="2"><strong><dhv:label name="">Stabilimento attività mobile: Informazioni autoveicolo soggetto a controllo</dhv:label></strong>
		</th>
	</tr>
	
	<tr>
	
	<td valign="top" class="formLabel"><dhv:label name="sanzioni.note">Autoveicolo soggetto a controllo</dhv:label>
	</td>
	
	<td> 
	
	<table cellpadding="5" style="border-collapse: collapse"  width="100%" >
<tr>
<th>Targa/matricola</th>
<th>Tipo</th>
<th>Carta di circolazione</th>
<th>Seleziona</th>
</tr> 


<%
		Iterator<DatiMobile> itDM = OrgDetails.getDatiMobile().iterator();
	
		while (itDM.hasNext()) {
					DatiMobile dm = itDM.next();
					
	%>

<tr>
<td><%=dm.getTarga() %></td>
<td><%=TipoMobili.getSelectedValue(dm.getTipo())%></td>
<td><a href="#" onClick="openPopup('GestioneAllegatiUploadSuap.do?command=DownloadPDF&codDocumento=<%=dm.getCarta() %>&nomeDocumento=<%=dm.getTarga()%>'); return false;">Download</a>    </td>
<td><input type="radio" id="mobile_targa_<%=dm.getId() %>" name="mobile_targa" value="<%=dm.getId() %>" <%=(TicketDetails.getIdTarga()==dm.getId()) ? "checked" : "" %>/>   </td>
</tr>

<% } %>
</table>
	
	
	
			</td>
</tr>
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
      <%
      ArrayList<ComuniAnagrafica> listaComuni = (ArrayList<ComuniAnagrafica>)request.getAttribute("ListaComuni");
      %>
      <select name="comuneControllo" id="comuneControllo" required="required">
      <option value="">Seleziona Comune</option>
      
      <%
      
      for(ComuniAnagrafica com : listaComuni)
      {
    	  %>
    	  <option value="<%=com.getDescrizione()%>" <%=(com.getDescrizione().equals(TicketDetails.getComuneControllo())) ? "selected" : "" %>><%=com.getDescrizione() %></option>
    	  <%
      }
      %>
      </select>
      
      </td>
    </tr>
    

 <tr class="containerBody">
      <td nowrap class="formLabel">
       Luogo
      </td>
      <td><input type = "text" name="luogoControlloTarga" required="required" value="<%=TicketDetails.getLuogoControlloTarga() %>"></td>
    </tr>
    </table>