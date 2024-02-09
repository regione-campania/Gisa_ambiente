
<script type="text/javascript" src="dwr/interface/PopolaCombo.js"> </script>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>
 
<script>
function openPopup(url){
 window.open(url,'popupSelect',
'height=800px,width=1280px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
}
</script>

<script language="JavaScript" TYPE="text/javascript" SRC="gestione_documenti/generazioneDocumentale.js"></script>

<% 
int idCampione = Integer.parseInt((String) (((JSONObject) jsonCampione.get("CampiServizio")).get("idCampione"))); 
String[] datiProtocolloCS = PopolaCombo.getDatiProtocolloCampione(idCampione, "VerbaleCampionamentoSuolo");
int annoProtocolloCS = Integer.parseInt(datiProtocolloCS[0]);
int numeroProtocolloCS = Integer.parseInt(datiProtocolloCS[1]);
%>

<div align="right">

<table style="border:1px solid black; display:inline-table;" cellpadding="10" cellspacing="10">
<tr><th colspan="2">Verbale Campionamento su suolo</th></tr>
<tr>
<td>

<% if (annoProtocolloCS > 0 && numeroProtocolloCS > 0) {%>
<input type="button" value="Download" onClick="openPopup('GestioneInvioSicra.do?command=DownloadProtocollo&annoProtocollo=<%=annoProtocolloCS %>&numeroProtocollo=<%=numeroProtocolloCS %>', 'Protocollo_<%=idCampione %>')"/>
<input type="button" value="Vedi informazioni protocollo" onClick="openPopup('GestioneInvioSicra.do?command=InviaLeggiProtocollo&annoProtocollo=<%=annoProtocolloCS %>&numeroProtocollo=<%=numeroProtocolloCS %>', 'Protocollo_<%=idCampione %>')"/>
<% } else { %>
<input type="button" value="Compila" onClick="openPopup('GestioneVerbali.do?command=ViewVerbaleCampionamentoSuolo&idCampione=<%=idCampione %>', 'VerbaleCampionamentoSuolo_<%=idCampione %>')"/>
<% } %>
</td>
</tr>
</table>

</div>

<br/><br/>

