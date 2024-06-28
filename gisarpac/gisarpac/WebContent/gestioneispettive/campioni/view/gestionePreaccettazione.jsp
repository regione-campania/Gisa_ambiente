<script type="text/javascript" src="dwr/interface/DwrPreaccettazione.js"> </script>


<% 
String idAnagrafica = request.getParameter("preaccAnagraficaId");
String idCampione = request.getParameter("preaccCampioneId");
String idEnte = request.getParameter("preaccEnteId");
String idLaboratorio = request.getParameter("preaccLaboratorioId");
String idUtente = request.getParameter("preaccUserId");
%>

<script>
function getElencoDaLinea(identificativo_linea, id_ente, id_laboratorio)
{
	DwrPreaccettazione.Preaccettazione_GetElencoDaLinea(identificativo_linea, id_ente, id_laboratorio, {callback:getElencoDaLineaCallBack,async:false});
}
function getElencoDaLineaCallBack(returnValue)
{
	
	var obj;
	obj = JSON.parse(returnValue);
	
	var codiceHtml = '<center><b><font color="red">I nuovi codici preaccettazione possono essere generati direttamente dal dettaglio anagrafica tramite il bottone GENERA PREACCETTAZIONE.</font></b></center>';
	var len= obj.length;
	
	if (len > 0)	{
		codiceHtml = codiceHtml + '<table width= 100% id="tabCodPreacc" border = "2" cellpadding="5" cellspacing="5" class="details">' +
		'<tr><th colspan="8">LISTA CODICI DI PREACCETTAZIONE ASSOCIATI ALL ANAGRAFICA E AL LABORATORIO DI DESTINAZIONE DI QUESTO CAMPIONE</th></tr>'+
		'<tr>' +	
		'<th style="text-align:center">codice preaccettazione</th>' +
		'<th style="text-align:center">matrice campione</th>' +
		'<th style="text-align:center">quesito diagnostico</th>' +
		'<th style="text-align:center">data preaccettazione</th> ' +
		'<th style="text-align:center">ente</th> ' +
		'<th style="text-align:center">laboratorio</th> ' +
		'<th style="text-align:center">utente</th>' +
		'<th style="text-align:center" width= 10%>usa codice</th>' +
		'</tr>';

for( i = 0; i <len ; i++) {
codiceHtml = codiceHtml + '<tr>' +
				'<td style="text-align:center">'+ obj[i].codice +'</td>' +
				'<td style="text-align:center">'+ obj[i].desc_matrice +'</td>' +
				'<td style="text-align:center">'+ obj[i].desc_quesito +'</td>' +
				'<td style="text-align:center">'+ obj[i].data +'</td>' +
				'<td style="text-align:center">'+ obj[i].ente +'</td>' +
				'<td style="text-align:center">'+ obj[i].laboratorio +'</td>' +
				'<td style="text-align:center">'+ obj[i].username +'</td>' +
				'<td align="center"> <input type="radio" id="codpreac" name="codpreac"' +
				'value="'+ obj[i].codice +'" onClick="checkCodicePreaccettazione(this)"/></td>'+
				'</tr>';
}
codiceHtml = codiceHtml + '</table><br/><br/>';
} else {
	codiceHtml = codiceHtml + '<center><b>NON RISULTANO CODICI PREACCETTAZIONE ASSOCIATI ALL ANAGRAFICA E AL LABORATORIO DI DESTINAZIONE DI QUESTO CAMPIONE.</b></center>';
}
	document.getElementById("divListaCodiciPreaccettazione").innerHTML = codiceHtml;
	return returnValue;
}


function checkCodicePreaccettazione(radio){
if (confirm('Associare il codice preaccettazione selezionato al campione?')) {
	associaCampione('<%=idCampione%>', '<%=idUtente%>', radio.value);
}
else {
	radio.checked = false;
}
}

function associaCodiceAlCampione(idCampione, idUtente, idCodicePreacc){
	loadModalWindow();
	associaCampione(idCampione, idUtente, idCodicePreacc);
}

function associaCampione(idCampione, userId, idCodicePreacc){
	DwrPreaccettazione.Preaccettazione_Associacampione(idCampione, userId, idCodicePreacc, {callback:associaCampioneCallBack,async:false});
}
function associaCampioneCallBack(returnValue)
{
 	var obj;
 	obj = JSON.parse(returnValue);
 	var messaggio = obj.messaggio;
 	if (messaggio == 'ok'){
 		alert('Codice preaccettazione associato correttamente.');
 		window.location.href="GestioneCampioni.do?command=View&idCampione=<%=idCampione%>";
 	}
 	else {
 		alert(messaggio);
 	}
     loadModalWindowUnlock();
}

function gestionePreaccettazione(){
	if (document.getElementById("divAssociaPreaccettazione").style.display=="none")
		document.getElementById("divAssociaPreaccettazione").style.display="block";
}

function recuperaCodPreaccettazione(idCampione){
	DwrPreaccettazione.Preaccettazione_RecuperaCodPreaccettazione(idCampione, {callback:recuperaCodPreaccettazioneCallBack,async:false});
}
function recuperaCodPreaccettazioneCallBack(returnValue)
{
	var dati = returnValue;
	var obj;
	obj = JSON.parse(dati);
	
	if(obj.codice_preaccettazione != ""){
		document.getElementById("divMostraPreaccettazione").style.display = 'block';
		document.getElementById("divCodicePreaccettazione").innerHTML = obj.codice_preaccettazione;
		document.getElementById("divAssociaPreaccettazione").style.display = 'none';
	}  else {
		document.getElementById("divMostraPreaccettazione").style.display = 'none';
		getElencoDaLinea("<%=idAnagrafica%>", "<%=idEnte%>", "<%=idLaboratorio%>");
		document.getElementById("divAssociaPreaccettazione").style.display="block";
	}  
}

function recuperaEsitoPreaccettazione(codPreaccettazione){
	DwrPreaccettazione.Preaccettazione_Ritorno_Da_Laboratorio(codPreaccettazione, <%=idUtente%>, 1, {callback:recuperaEsitoPreaccettazioneCallBack,async:false});
}
function recuperaEsitoPreaccettazioneCallBack(returnValue)
{
	var dati = returnValue;
	if(dati != ""){
			document.getElementById("divEsitoPreaccettazione").innerHTML = dati;
		}  else {
			document.getElementById("divEsitoPreaccettazione").innerHTML = "<input type=\"button\" value=\"VERIFICA E SCARICA ESITO\" onClick=\"loadModalWindow();recuperaEsitoPreaccettazione(document.getElementById('divCodicePreaccettazione').innerHTML); loadModalWindowUnlock();\"/>";
		}  
	
}
</script>



<div id="divAssociaPreaccettazione" style="display:none">
<div id ="divListaCodiciPreaccettazione" name="divListaCodiciPreaccettazione"></div>
<br/><br/><br/><br/>
</div>

<div id="divMostraPreaccettazione" style="display:none"> 
<center>
<table class="details" cellpadding="10" cellspacing="10" width="40%">
<tr><th align="center"><center>Codice Preaccettazione</center></th></tr>
<tr><td align="center"><div id ="divCodicePreaccettazione" name="divCodicePreaccettazione"></div></td></tr>
<tr><th align="center"><center>Esito</center></th></tr>
<tr><td align="center"><output id ="divEsitoPreaccettazione" name="divEsitoPreaccettazione"></output></td></tr>
</table>
</center>
<br/><br/>
</div>


<script>
window.onload = function() {
recuperaCodPreaccettazione(document.getElementById("idCampione").value);
recuperaEsitoPreaccettazione(document.getElementById("divCodicePreaccettazione").innerHTML);
}
</script>