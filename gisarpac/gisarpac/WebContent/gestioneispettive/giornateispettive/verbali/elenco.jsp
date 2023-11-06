
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
int idGiornataIspettiva = Integer.parseInt((String) (((JSONObject) jsonGiornataIspettiva.get("CampiServizio")).get("idGiornataIspettiva"))); 
String[] datiProtocollo = PopolaCombo.getDatiProtocollo(idGiornataIspettiva, "VerbaleA6");
int annoProtocollo = Integer.parseInt(datiProtocollo[0]);
int numeroProtocollo = Integer.parseInt(datiProtocollo[1]);
%>


<div align="right">

<table style="border:1px solid black" cellpadding="10" cellspacing="10">
<tr><th colspan="2">Modello A6 Verbale Verifica Ispettiva</th></tr>
<tr>
<td>

<% if (annoProtocollo > 0 && numeroProtocollo > 0) {%>
<input type="button" value="Download" onClick="openPopup('GestioneInvioSicra.do?command=DownloadProtocollo&annoProtocollo=<%=annoProtocollo %>&numeroProtocollo=<%=numeroProtocollo %>', 'Protocollo_<%=idGiornataIspettiva %>')"/>
<input type="button" value="Vedi informazioni protocollo" onClick="openPopup('GestioneInvioSicra.do?command=InviaLeggiProtocollo&annoProtocollo=<%=annoProtocollo %>&numeroProtocollo=<%=numeroProtocollo %>', 'Protocollo_<%=idGiornataIspettiva %>')"/>
<% } else { %>
<input type="button" value="Compila" onClick="openPopup('GestioneVerbali.do?command=ViewVerbaleA6&idGiornataIspettiva=<%=idGiornataIspettiva %>', 'VerbaleA6_<%=idGiornataIspettiva %>')"/>
<% } %>
</td>
</tr>
</table>

</div>

<br/><br/>
