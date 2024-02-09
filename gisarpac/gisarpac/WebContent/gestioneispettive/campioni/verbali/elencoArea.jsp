
<script type="text/javascript" src="dwr/interface/PopolaCombo.js"> </script>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>
 
<script>

function mostraNascondi(div){
	if (document.getElementById(div).style.display=='none')
		document.getElementById(div).style.display='block';
	else
		document.getElementById(div).style.display='none'
}
function openPopupMancatoCampionamento(idArea){
    
	  window.open('GestioneVerbali.do?command=ViewVerbaleMancatoCampionamentoSuolo&idArea='+idArea,'popupSelectMancatoCampionamento'+idArea,
	         'height=800px,width=1280px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');

}

function openPopup(url){
	 window.open(url,'popupSelect',
	'height=800px,width=1280px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
	}
</script>

<script language="JavaScript" TYPE="text/javascript" SRC="gestione_documenti/generazioneDocumentale.js"></script>

<div align="right"><a href="#" onClick="mostraNascondi('divVerbaliMancatoCampionamento'); return false;">Mostra verbali mancato campionamento</a></div>
<div id="divVerbaliMancatoCampionamento" style="display:none">
<% 
int idArea = area.getId(); 
ArrayList<String[]> datiProtocolliMCS = PopolaCombo.getDatiProtocolloArea(idArea, "VerbaleMancatoCampionamentoSuolo");

for (int i = 0; i<datiProtocolliMCS.size(); i++) {
	String[] datiProtocolloMCS = (String []) datiProtocolliMCS.get(i);
	int annoProtocolloMCS = Integer.parseInt(datiProtocolloMCS[0]);
	int numeroProtocolloMCS = Integer.parseInt(datiProtocolloMCS[1]);
%>

<div align="right">

<table style="border:1px solid black; display:inline-table;" cellpadding="10" cellspacing="10">
<tr><th colspan="2">Verbale Mancato Campionamento su suolo</th></tr>
<tr>
<td>

<% if (annoProtocolloMCS > 0 && numeroProtocolloMCS > 0) {%>
<input type="button" value="Download" onClick="openPopup('GestioneInvioSicra.do?command=DownloadProtocollo&annoProtocollo=<%=annoProtocolloMCS %>&numeroProtocollo=<%=numeroProtocolloMCS %>', 'Protocollo_<%=idArea %>')"/>
<input type="button" value="Vedi informazioni protocollo" onClick="openPopup('GestioneInvioSicra.do?command=InviaLeggiProtocollo&annoProtocollo=<%=annoProtocolloMCS %>&numeroProtocollo=<%=numeroProtocolloMCS %>', 'Protocollo_<%=idArea %>')"/>
<% } else { %>
<% } %>
</td>
</tr>
</table>

</div>

<% } %>

<br/><br/>

</div>

<div align="right">

<table style="border:1px solid black; display:inline-table;" cellpadding="10" cellspacing="10">
<tr>
<td>
<input type="button" value="AGGIUNGI MANCATO CAMPIONAMENTO" onclick="openPopupMancatoCampionamento('<%= area.getId() %>')" />
</td>
</tr>
</table>

</div>


<br/><br/>

