<%

int idGiornataIspettivaAllegati = -1;
try {idGiornataIspettivaAllegati = Integer.parseInt((String) (((JSONObject) jsonGiornataIspettiva.get("CampiServizio")).get("idGiornataIspettiva")));} catch (Exception e) {} 
ArrayList<String> datiAllegati = PopolaCombo.getDatiAllegati(idGiornataIspettivaAllegati);

%>


<script>
function openUploadAllegatoGiornataIspettiva(idGiornataIspettiva, tipoUpload){
var res;
var result;
	
window.open('GestioneAllegatiGiornateIspettive.do?command=PrepareUploadAllegato&tipo='+tipoUpload+'&tipoAllegato='+tipoUpload+'&idGiornataIspettiva='+idGiornataIspettiva,null,
		'height=450px,width=520px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=no,resizable=no ,modal=yes');
} 

function openDeleteAllegatoGiornataIspettiva(idGiornataIspettiva, codDocumento){

	if(confirm('Attenzione. Questo allegato sarà eliminato dal sistema. Proseguire?')) {
		
	window.open('GestioneAllegatiGiornateIspettive.do?command=DeleteFile&codDocumento='+codDocumento+'&idGiornataIspettiva='+idGiornataIspettiva,null,
			'height=450px,width=480px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=no,resizable=no ,modal=yes');
	}
} 
	
</script>
		
		

<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="10%"><col width="20%"><col width="30%"><col width="20%">
<tr><th colspan="5"><center>LISTA ALLEGATI <dhv:permission name="opu-vigilanza-add"><input type="button" onClick="javascript:openUploadAllegatoGiornataIspettiva('<%=idGiornataIspettivaAllegati%>', 'AllegatoGiornataIspettiva')" id="allega" value="INSERISCI ALLEGATO"/></dhv:permission></center></th></tr>
<tr><th>Codice Allegato</th><th>Nome allegato</th><th>Oggetto allegato<th>Inserito da</th><th>Inserito il</th></tr>


<%for (int i = 0; i<datiAllegati.size(); i++){
	String[] datiAllegato = datiAllegati.get(i).split(";;");%>

<tr>
<td><a href="#" onClick="openPopup('GestioneAllegatiGiornateIspettive.do?command=DownloadPDF&codDocumento=<%=datiAllegato[0] %>&nomeDocumento=<%=datiAllegato[1] %>'); return false;"><%=datiAllegato[0] %> </a></td>
<td><a href="#" onClick="openPopup('GestioneAllegatiGiornateIspettive.do?command=DownloadPDF&codDocumento=<%=datiAllegato[0] %>&nomeDocumento=<%=datiAllegato[1] %>'); return false;"><%=datiAllegato[1] %> </a></td>
<td><a href="#" onClick="openPopup('GestioneAllegatiGiornateIspettive.do?command=DownloadPDF&codDocumento=<%=datiAllegato[0] %>&nomeDocumento=<%=datiAllegato[1] %>'); return false;"><%=datiAllegato[2] %> </a></td>
<td><dhv:username id="<%=datiAllegato[4] %>" /> </td>
<td><%=toDateasStringFromString(datiAllegato[3]) %> <dhv:permission name="opu-vigilanza-add"><input type="button" style="background-color:red" value="Elimina" onClick="openDeleteAllegatoGiornataIspettiva('<%=idGiornataIspettivaAllegati %>', '<%=datiAllegato[0] %>'); return false;"/></dhv:permission></td>
</tr>
<% } %>

<% if (datiAllegati.size() == 0) { %>
<tr><td colspan="5">NON SONO PRESENTI ALLEGATI.</td></tr>
<% } %>
</table>
