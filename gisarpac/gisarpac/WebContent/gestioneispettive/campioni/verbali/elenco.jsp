
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
String[] datiProtocolloC4 = PopolaCombo.getDatiProtocolloCampione(idCampione, "VerbaleC4");
int annoProtocolloC4 = Integer.parseInt(datiProtocolloC4[0]);
int numeroProtocolloC4 = Integer.parseInt(datiProtocolloC4[1]);
%>


<div align="right">

<table style="border:1px solid black" cellpadding="10" cellspacing="10">
<tr><th colspan="2">Verbale Campionamento Emissioni in Atmosfera</th></tr>
<tr>
<td>

<% if (annoProtocolloC4 > 0 && numeroProtocolloC4 > 0) {%>
<input type="button" value="Download" onClick="openPopup('GestioneInvioSicra.do?command=DownloadProtocollo&annoProtocollo=<%=annoProtocolloC4 %>&numeroProtocollo=<%=numeroProtocolloC4 %>', 'Protocollo_<%=idCampione %>')"/>
<input type="button" value="Vedi informazioni protocollo" onClick="openPopup('GestioneInvioSicra.do?command=InviaLeggiProtocollo&annoProtocollo=<%=annoProtocolloC4 %>&numeroProtocollo=<%=numeroProtocolloC4 %>', 'Protocollo_<%=idCampione %>')"/>
<% } else { %>
<input type="button" value="Compila" onClick="openPopup('GestioneVerbali.do?command=ViewVerbaleC4&idCampione=<%=idCampione %>', 'VerbaleC4_<%=idCampione %>')"/>
<% } %>
</td>
</tr>
</table>

</div>

<br/><br/>

<% 
String[] datiProtocolloAS = PopolaCombo.getDatiProtocolloCampione(idCampione, "VerbaleAS");
int annoProtocolloAS = Integer.parseInt(datiProtocolloAS[0]);
int numeroProtocolloAS = Integer.parseInt(datiProtocolloAS[1]);
%>

<div align="right">

<table style="border:1px solid black; display:inline-table;" cellpadding="10" cellspacing="10">
<tr><th colspan="2">Verbale Campionamento Acque Sotterranee</th></tr>
<tr>
<td>

<% if (annoProtocolloAS > 0 && numeroProtocolloAS > 0) {%>
<input type="button" value="Download" onClick="openPopup('GestioneInvioSicra.do?command=DownloadProtocollo&annoProtocollo=<%=annoProtocolloAS %>&numeroProtocollo=<%=numeroProtocolloAS %>', 'Protocollo_<%=idCampione %>')"/>
<input type="button" value="Vedi informazioni protocollo" onClick="openPopup('GestioneInvioSicra.do?command=InviaLeggiProtocollo&annoProtocollo=<%=annoProtocolloAS %>&numeroProtocollo=<%=numeroProtocolloAS %>', 'Protocollo_<%=idCampione %>')"/>
<% } else { %>
<input type="button" value="Compila" onClick="openPopup('GestioneVerbali.do?command=ViewVerbaleAcqueSott&idCampione=<%=idCampione %>', 'VerbaleAcqueSott_<%=idCampione %>')"/>
<% } %>
</td>
</tr>
</table>

</div>


<br/><br/>

