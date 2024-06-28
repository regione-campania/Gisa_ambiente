<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="jsonCampione" class="org.json.JSONObject" scope="request"/>
<jsp:useBean id="ListaTipiColture" class="java.util.ArrayList" scope="request"/>

<%@ page import="org.aspcfs.modules.gestioneispettive.base.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery/jquery-1.8.2.js"></script>
<script src="javascript/jquery/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<script>


function backForm(form){
	form.action="GestioneCampioni.do?command=AddGruppoTecniciAddettiParticella";
	loadModalWindow();
	form.submit();
}

function checkTipoColtura(radio){
	if (radio.checked){
		if (radio.value == "C"){
			document.getElementById("tipoColturaParticellaNote").style.display ="block";
			document.getElementById("tipoColturaParticellaMotivazione").style.display ="none";
			document.getElementById("tipoColturaParticellaMotivazione").value="";
		} else if (radio.value == "NC"){
			document.getElementById("tipoColturaParticellaMotivazione").style.display ="block";
			document.getElementById("tipoColturaParticellaNote").style.display ="none";
			document.getElementById("tipoColturaParticellaNote").value="";
		}
		else{
			document.getElementById("tipoColturaParticellaNote").style.display ="none";
			document.getElementById("tipoColturaParticellaNote").value="";
			document.getElementById("tipoColturaParticellaMotivazione").style.display ="none";
			document.getElementById("tipoColturaParticellaMotivazione").value="";
		}
	}
}

function checkPresenzaRifiuti(radio){
	if (radio.checked){
		if (radio.value == "S"){
			document.getElementById("presenzaRifiutiNote").style.display ="table-row";
			document.getElementById("presenzaRifiutiDescrizione").style.display ="table-row";
		} else if (radio.value == "P"){
			document.getElementById("presenzaRifiutiNote").style.display ="none";
			document.getElementById("presenzaRifiutiNote").value="";
			document.getElementById("presenzaRifiutiDescrizione").style.display ="table-row";
		}
		else{
			document.getElementById("presenzaRifiutiNote").style.display ="none";
			document.getElementById("presenzaRifiutiNote").value="";
			document.getElementById("presenzaRifiutiDescrizione").style.display ="none";
			document.getElementById("presenzaRifiutiDescrizione").value="";
		}
	}
}

function checkProprietarioPresente(radio){
	if (radio.checked && radio.value=='true'){
// 			document.getElementById("divProprietarioPresenteS").style.display ="block";
 			document.getElementById("divProprietarioPresenteN").style.display ="none";
			document.getElementById("datiAltraPersonaPresente").value="";
			document.getElementById("qualitaAltraPersonaPresente").value="";
	}
		else if (radio.checked && radio.value == 'false'){
			//document.getElementById("divProprietarioPresenteS").style.display ="none";
			document.getElementById("divProprietarioPresenteN").style.display ="block";
			//document.getElementById("datiProprietarioParticella").value="";
		}
}

// function checkIrrigazioneInLoco(cb){
// 	if (!cb.checked){
// 			document.getElementById("irrigazioneInformazioni").style.display ="table-row";
// 	}
// 	else{
// 			document.getElementById("irrigazioneInformazioni").style.display ="none";
// 			document.getElementById("irrigazioneInformazioni").value="";
// 		}
// }

function checkPozzoCampionamento(cb){
	if (cb.checked){
			document.getElementById("pozzoCampionamentoVerbaleNumero").style.display ="table-row";
			document.getElementById("pozzoCampionamentoVerbaleData").style.display ="table-row";
	}
	else{
			document.getElementById("pozzoCampionamentoVerbaleNumero").style.display ="none";
			document.getElementById("pozzoCampionamentoVerbaleNumero").value="";
			document.getElementById("pozzoCampionamentoVerbaleData").style.display ="none";
			document.getElementById("pozzoCampionamentoVerbaleData").value="";
		}
}

function checkCampioniElementari(radio){
	
	for (var i = 1; i<=5; i++){
		if (i>radio.value){
			document.getElementById("trCampioneElementare"+i).style.display ="none";
			document.getElementById("coordinataX"+i).value = "";
			document.getElementById("coordinataY"+i).value = "";
		} else {
			document.getElementById("trCampioneElementare"+i).style.display ="table-row";
		}
		
	}			
}

function checkAliquota(cb, val){
	
	if (cb.checked){
		
		if (document.getElementById("aliquota"+val+"_data")!=null)
			document.getElementById("aliquota"+val+"_data").style.display="table-row";
		if (document.getElementById("aliquota"+val+"_ora")!=null)
			document.getElementById("aliquota"+val+"_ora").style.display="table-row";
		if (document.getElementById("aliquota"+val+"_laboratorio")!=null)
			document.getElementById("aliquota"+val+"_laboratorio").style.display="table-row";
		
		checkAliquotaData(cb);

	} else {
		if (document.getElementById("aliquota"+val+"_data")!=null){
			document.getElementById("aliquota"+val+"_data").style.display="none";
			document.getElementById("aliquota"+val+"_data").value="";
			}
		if (document.getElementById("aliquota"+val+"_ora")!=null){
			document.getElementById("aliquota"+val+"_ora").style.display="none";
			document.getElementById("aliquota"+val+"_ora").value="";
			}
		if (document.getElementById("aliquota"+val+"_laboratorio")!=null)
			document.getElementById("aliquota"+val+"_laboratorio").style.display="none";
		
	}
	
	if (document.getElementById("aliquotaBG").checked && document.getElementById("aliquotaLM").checked){
		document.getElementById("aliquotaN").checked = true;
		document.getElementById("aliquotaN_laboratorio").style.display="table-row";
	}
	if (document.getElementById("aliquotaN").checked && (!document.getElementById("aliquotaBG").checked || !document.getElementById("aliquotaLM").checked)){
		alert("L'aliquota n è selezionabile solo se le aliquote b-g-l-m sono selezionate.");
		document.getElementById("aliquotaN").checked = false;
		document.getElementById("aliquotaN_laboratorio").style.display="none";
	}
	
}

function checkAliquotaData(campo){
	var data = campo.value;
	
	if (campo.id == 'aliquotaA_data' || campo.id == 'aliquotaC_data' || campo.id == 'aliquotaD_data'){
		document.getElementById("aliquotaA_data").value=data;
		document.getElementById("aliquotaC_data").value=data;
		document.getElementById("aliquotaD_data").value=data;
	}
	
}
</script>

<%@ include file="../../../terreni/util/coordinate.jsp"%>

<form name="aggiungiCampione" action="GestioneCampioni.do?command=AddRiepilogoParticella&auto-populate=true" onSubmit="" method="post">

<center>

<!-- RIEPILOGO -->
<%@ include file="riepilogoParticella.jsp"%>
<!-- RIEPILOGO -->

<br/>

<% 
String codiceSito = "";
String dataPrelievo = "";
String oraPrelievo = "";

if ( ((JSONObject) jsonCampione).has("Anagrafica")) {
	JSONObject jsonAnagrafica = (JSONObject) jsonCampione.get("Anagrafica");
	codiceSito = jsonAnagrafica.get("codiceSito").toString();
}
if ( ((JSONObject) jsonCampione).has("Dati")) {
	JSONObject jsonDati = (JSONObject) jsonCampione.get("Dati");
	dataPrelievo = jsonDati.get("dataPrelievo").toString();
	oraPrelievo = jsonDati.get("ore").toString();
}


%>

<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="30%">
<tr><th colspan="2"><center><b>DATI VERBALE</b></center></th></tr>

<tr><td class="formLabel">Carabinieri forestali</td><td><textarea cols="100" rows="3" id="carabinieriForestali" name="carabinieriForestali" size="50" placeholder="Nominativi"></textarea></td></tr>
<tr><td class="formLabel">Altri partecipanti</td><td>
Nominativi<br/> <textarea cols="100" rows="3" id="altriPartecipanti1" name="altriPartecipanti1" placeholder="Nominativi"></textarea><br/>Presenti al campionamento in qualita' di<br/> <textarea cols="100" rows="3" id="qualitaAltriPartecipanti1" name="qualitaAltriPartecipanti1" placeholder="In qualità di"></textarea><br/><br/>
Nominativi<br/> <textarea cols="100" rows="3" id="altriPartecipanti2" name="altriPartecipanti2" placeholder="Nominativi"></textarea><br/>Presenti al campionamento in qualita' di<br/> <textarea cols="100" rows="3" id="qualitaAltriPartecipanti2" name="qualitaAltriPartecipanti2" placeholder="In qualità di"></textarea><br/><br/>
Nominativi<br/> <textarea cols="100" rows="3" id="altriPartecipanti3" name="altriPartecipanti3" placeholder="Nominativi"></textarea><br/>Presenti al campionamento in qualita' di<br/> <textarea cols="100" rows="3" id="qualitaAltriPartecipanti3" name="qualitaAltriPartecipanti3" placeholder="In qualità di"></textarea><br/></td></tr>
<tr><td class="formLabel">Dati proprietario particella (nome e cognome)</td><td> 

Proprietario<br/>
<textarea cols="100" rows="3" id="datiProprietarioParticella" name="datiProprietarioParticella" placeholder="Nominativo"></textarea><br/>

Proprietario presente: SI <input type="radio" id="proprietarioPresenteS" name="proprietarioPresente" value="true" checked onChange="checkProprietarioPresente(this)"> NO <input type="radio" id="proprietarioPresenteN" name="proprietarioPresente" value="false" onChange="checkProprietarioPresente(this)">
<div id="divProprietarioPresenteN" style="display:none">Altra persona presente<br/> <textarea cols="100" rows="3" id="datiAltraPersonaPresente" name="datiAltraPersonaPresente" placeholder="Nominativo"></textarea><br/> In qualita' di<br/> <textarea cols="100" rows="3" id="qualitaAltraPersonaPresente" name="qualitaAltraPersonaPresente" placeholder="In qualità di"></textarea></div>

</td></tr>

</table>

<br/>

<table class="details" cellpadding="10" cellspacing="10" width="100%">

<tr><th colspan="4"><center><b>DATI VERBALE CAMPIONE</b></center></th></tr>

<tr><td class="formLabel" colspan="2">Numero campioni elementari</td><td colspan="2">

<input type="radio" id="numCampioniElementari1" name="numCampioniElementari" value="1" onClick="checkCampioniElementari(this)"/> 1
<input type="radio" id="numCampioniElementari2" name="numCampioniElementari" value="2" onClick="checkCampioniElementari(this)"/> 2
<input type="radio" id="numCampioniElementari3" name="numCampioniElementari" value="3" onClick="checkCampioniElementari(this)"/> 3
<input type="radio" id="numCampioniElementari4" name="numCampioniElementari" value="4" onClick="checkCampioniElementari(this)"/> 4
<input type="radio" id="numCampioniElementari5" name="numCampioniElementari" value="5" onClick="checkCampioniElementari(this)"/> 5 

</td></tr>

<tr><th>Campione di suolo</th><th>Codice Identificativo</th><th>Coordinata_X</th><th>Coordinata_Y</th></tr>

<tr>
<td>Campione per VOC</td>
<td><input type="text" readonly id="codiceIdentificativoVoc" name="codiceIdentificativoVoc" size="20" value="<%=codiceSito %>_VOC"/></td>
<td><input type="text" id="coordinataXVoc" name="coordinataXVoc" size="20" onKeyUp="validaCoordinateFormato(this)"/></td>
<td><input type="text" id="coordinataYVoc" name="coordinataYVoc" size="20" onKeyUp="validaCoordinateFormato(this)"/></td>
</tr>

<% for (int i = 1; i<=5; i++){ %>
<tr id="trCampioneElementare<%=i%>" style="display:none">
<td>Campione Elementare</td>
<td><input type="text" readonly id="codiceIdentificativo<%=i %>" name="codiceIdentificativo<%=i %>" size="20" value="<%=codiceSito %>_<%=i%>"/></td>
<td><input type="text" id="coordinataX<%=i %>" name="coordinataX<%=i %>" size="20" onKeyUp="validaCoordinateFormato(this)"/></td>
<td><input type="text" id="coordinataY<%=i %>" name="coordinataY<%=i %>" size="20" onKeyUp="validaCoordinateFormato(this)"/></td>
</tr>
<% } %>

<tr>
<td>Campione medio composito</td>
<td><input type="text" id="codiceIdentificativoMedioComposito" name="codiceIdentificativoMedioComposito" size="20" readonly value="<%=codiceSito%>"/></td>
<td colspan="2">--------------------------</td>
</tr>
</table>

<br/>

<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="30%">
<tr><th colspan="2"><center><b>DATI ALIQUOTE</b></center></th></tr>

<tr><td class="formLabel">Aliquote</td><td style="text-transform:none">


<table cellpadding="10" cellspacing="10" style="border-collapse: collapse">
<tr><th>Aliquota</th><th>Data apertura</th><th>Ora</th><th>Richiesta ricerca fitofarmaci</th><th>Laboratorio di destinazione</th></tr>
<tr><td><input type="checkbox" id="aliquotaA" name="aliquotaA" value="true" checked onClick="return false"/>a</td><td><input type="date" id="aliquotaA_data" name="aliquotaA_data" onChange="checkAliquotaData(this)"></td><td><input type="time" id="aliquotaA_ora" name="aliquotaA_ora"></td><td></td><td><input type="text" readonly id="aliquotaA_laboratorio" name="aliquotaA_laboratorio" value="ARPAC"/></td></td></tr>
<tr><td><input type="checkbox" id="aliquotaBG" name="aliquotaBG" value="true" onClick="checkAliquota(this, 'BG')"/>b-g</td><td></td><td></td><td></td><td><input type="text" readonly id="aliquotaBG_laboratorio" name="aliquotaBG_laboratorio" style="display:none" value="ARPAC"/></td></tr>
<tr><td><input type="checkbox" id="aliquotaC" name="aliquotaC" value="true" checked onClick="return false"/>c</td><td><input type="date" id="aliquotaC_data" name="aliquotaC_data" onChange="checkAliquotaData(this)"></td><td><input type="time" id="aliquotaC_ora" name="aliquotaC_ora"></td><td rowspan="2"><input type="checkbox" id="aliquotaCD_fitofarmaci" name="aliquotaCD_fitofarmaci" value="true"/></td><td><input type="text" readonly id="aliquotaC_laboratorio" name="aliquotaC_laboratorio" value="ARPAC"/></td></tr>
<tr><td><input type="checkbox" id="aliquotaD" name="aliquotaD" value="true" checked onClick="return false"/>d</td><td><input type="date" id="aliquotaD_data" name="aliquotaD_data" onChange="checkAliquotaData(this)"></td><td><input type="time" id="aliquotaD_ora" name="aliquotaD_ora"></td><td><input type="text" readonly id="aliquotaD_laboratorio" name="aliquotaD_laboratorio" value="ARPAC"/></td></tr>
<tr><td><input type="checkbox" id="aliquotaE" name="aliquotaE" value="true" checked onClick="return false"/>e</td><td></td><td></td><td></td><td><input type="text" readonly id="aliquotaE_laboratorio" name="aliquotaE_laboratorio" size="30" value="Universita' Federico II di Napoli"/></td></tr>
<tr><td><input type="checkbox" id="aliquotaF" name="aliquotaF" value="true" checked onClick="return false"/>f</td><td></td><td></td><td></td><td><input type="text" readonly id="aliquotaF_laboratorio" name="aliquotaF_laboratorio" value="ARPAC"/></td></tr>
<tr><td><input type="checkbox" id="aliquotaH" name="aliquotaH" value="true" checked onClick="return false"/>h</td><td></td><td></td><td></td><td><input type="text" readonly id="aliquotaH_laboratorio" name="aliquotaH_laboratorio" value="ARPAC"/></td></tr>
<tr><td><input type="checkbox" id="aliquotaI" name="aliquotaI" value="true" checked onClick="return false"/>i</td><td><input type="date" id="aliquotaI_data" name="aliquotaI_data" onChange="checkAliquotaData(this)"></td><td><input type="time" id="aliquotaI_ora" name="aliquotaI_ora"></td><td></td><td><input type="text" readonly id="aliquotaI_laboratorio" name="aliquotaI_laboratorio" value="ARPAC"/></td></tr>
<tr><td><input type="checkbox" id="aliquotaLM" name="aliquotaLM" value="true" onClick="checkAliquota(this, 'LM')"/>l-m</td><td><input type="date" id="aliquotaLM_data" name="aliquotaLM_data" onChange="checkAliquotaData(this)" style="display:none"></td><td><input type="time" id="aliquotaLM_ora" name="aliquotaLM_ora" style="display:none"></td><td></td><td><input type="text" readonly id="aliquotaLM_laboratorio" name="aliquotaLM_laboratorio" style="display:none" size="30" value="Universita' Federico II di Napoli"/></td></tr>
<tr><td><input type="checkbox" id="aliquotaN" name="aliquotaN" value="true" onClick="checkAliquota(this, 'N')"/>n</td><td></td><td></td><td></td><td><input type="text" readonly id="aliquotaN_laboratorio" name="aliquotaN_laboratorio" style="display:none" value="Controparte"/></td></tr>

</table>

</td></tr>
</table>

<br/>

<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="30%">
<tr><th colspan="2"><center><b>DATI CAMPIONAMENTO SUOLO</b></center></th></tr>

<tr><td class="formLabel">La particella campionata risulta</td><td> <% for (int i = 0; i<ListaTipiColture.size(); i++){ TipoColturaParticella t = (TipoColturaParticella) ListaTipiColture.get(i); %> <input type="radio" id="tipoColturaParticellaCodice_<%=t.getCodice()%>" name ="tipoColturaParticellaCodice" value="<%=t.getCodice()%>" onClick="checkTipoColtura(this)"/> <%=t.getDescrizione() %> <input type="hidden" id="tipoColturaParticellaDescrizione_<%=t.getCodice()%>" name ="tipoColturaParticellaDescrizione_<%=t.getCodice()%>" value="<%=t.getDescrizione()%>"/><% } %>  <textarea cols="100" rows="3" style="display: none" id="tipoColturaParticellaNote" name="tipoColturaParticellaNote" placeholder="Descrivere il tipo coltura e stato"></textarea> <textarea cols="100" rows="3" style="display: none" id="tipoColturaParticellaMotivazione" name="tipoColturaParticellaMotivazione" placeholder="Motivazioni"></textarea> </td></tr>
<tr><td class="formLabel">Presenza rifiuti</td><td><input type="radio" id="presenzaRifiutiS" name="presenzaRifiuti" value="S" onClick="checkPresenzaRifiuti(this)"/> SI <input type="text" style="display:none" id="presenzaRifiutiNote" name="presenzaRifiutiNote" placeholder="Tipo rifiuti"> <input type="radio" checked id="presenzaRifiutiN" name="presenzaRifiuti" value="N" onClick="checkPresenzaRifiuti(this)"/> NO <input type="radio" id="presenzaRifiutiP" name="presenzaRifiuti" value="P" onClick="checkPresenzaRifiuti(this)"/> PARZIALMENTE <br/><textarea cols="100" rows="3" style="display:none" id="presenzaRifiutiDescrizione" name="presenzaRifiutiDescrizione" placeholder="Descrizione"></textarea></td></tr>

</table>

<br/>

<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="30%">
<tr><th colspan="2"><center><b>DATI IRRIGAZIONE</b></center></th></tr>

<tr><td class="formLabel">Informazioni acquisite</td><td> In Loco <input type="checkbox" id="irrigazioneInLoco" name="irrigazioneInLoco" checked value="true" /> <textarea cols="100" rows="3" id="irrigazioneInformazioni" name="irrigazioneInformazioni" placeholder="Dal sig... (Nominativo)"></textarea> </td></tr>
<tr><td class="formLabel">Derivazione acqua utilizzata</td><td> <textarea cols="100" rows="3" id="irrigazioneDerivazione" name="irrigazioneDerivazione" size="50" placeholder="Derivazione"></textarea> </td></tr>

</table>

<br/>

<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="30%">
<tr><th colspan="2"><center><b>DATI ACQUE SOTTERRANEE</b></center></th></tr>

<tr><td class="formLabel">Campionamento acque sotterranee</td><td> SI <input type="checkbox" id="pozzoCampionamento" name="pozzoCampionamento" value="true" onClick="checkPozzoCampionamento(this)"/> <input type="text" style="display:none" id="pozzoCampionamentoVerbaleNumero" name="pozzoCampionamentoVerbaleNumero" placeholder="Numero verbale"> <input type="date" style="display:none" id="pozzoCampionamentoVerbaleData" name="pozzoCampionamentoVerbaleData" placeholder="Data verbale"> </td></tr>

</table>

<br/>

<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="30%">
<tr><th colspan="2"><center><b>NOTE</b></center></th></tr>

<tr><td class="formLabel">Dichiarazioni Controparte</td><td> <textarea cols="100" rows="3" id="dichiarazioni" name="dichiarazioni" placeholder="Dichiarazioni"></textarea> </td></tr>
<tr><td class="formLabel">Strumentazione utilizzata</td><td> <textarea cols="100" rows="3" id="strumentazione" name="strumentazione" placeholder="Strumentazione"></textarea> </td></tr>
<tr><td class="formLabel">Note aggiuntive</td><td> <textarea cols="100" rows="3" id="noteAggiuntive" name="noteAggiuntive" placeholder="Note"></textarea> </td></tr>

</table>

<br/>


<!-- BOTTONI -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<tr>
<td colspan="2" align="center"><br/><br/>
<input type="button" value="INDIETRO" onclick="backForm(this.form)" style="font-size:40px; background-color:red"/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" style="font-size:40px" value="PROSEGUI" onclick="checkForm(this.form)"/>
</td>
</tr>
</table>
<!-- BOTTONI -->

</center>

<!--JSON -->
<br/><br/><br/><br/>
<textarea rows="10" cols="200" readonly id="jsonCampione" name="jsonCampione" <%= (org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON")!= null && org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON").equalsIgnoreCase("si")) ? "" : "style= \"display:none\""%>><%=jsonCampione%></textarea>
<!--JSON -->

</form>

<script>
function checkForm(form){
	var msg = "";
	var esito = true;
	var carabinieriForestali = form.carabinieriForestali.value;
	var altriPartecipanti1 = form.altriPartecipanti1.value;
	var altriPartecipanti2 = form.altriPartecipanti2.value;
	var altriPartecipanti3 = form.altriPartecipanti3.value;
	var qualitaAltriPartecipanti1 = form.qualitaAltriPartecipanti1.value;
	var qualitaAltriPartecipanti2 = form.qualitaAltriPartecipanti2.value;
	var qualitaAltriPartecipanti3 = form.qualitaAltriPartecipanti3.value;
	var proprietarioPresente = form.proprietarioPresenteS.checked;
	var datiProprietarioParticella = form.datiProprietarioParticella.value;
	var datiAltraPersonaPresente = form.datiAltraPersonaPresente.value;
	var qualitaAltraPersonaPresente = form.qualitaAltraPersonaPresente.value;
	var numCampioniElementari = document.querySelector('input[name="numCampioniElementari"]:checked')!= null ? document.querySelector('input[name="numCampioniElementari"]:checked').value : '';
	var tipoColturaParticellaCodice = form.tipoColturaParticellaCodice.value;
	var tipoColturaParticellaNote = form.tipoColturaParticellaNote.value;
	var presenzaRifiutiS = form.presenzaRifiutiS;
	var presenzaRifiutiN = form.presenzaRifiutiN;
	var presenzaRifiutiP = form.presenzaRifiutiP;
	
	var aliquotaA = form.aliquotaA;
	var aliquotaBG = form.aliquotaBG;
	var aliquotaC = form.aliquotaC;
	var aliquotaD = form.aliquotaD;
	var aliquotaE = form.aliquotaE;
	var aliquotaF = form.aliquotaF;
	var aliquotaH = form.aliquotaH;
	var aliquotaI = form.aliquotaI;
	var aliquotaLM = form.aliquotaLM;
	var aliquotaN = form.aliquotaN;
	var aliquotaA_data = form.aliquotaA_data.value;
	var aliquotaC_data = form.aliquotaC_data.value;
	var aliquotaD_data = form.aliquotaD_data.value;
	var aliquotaI_data = form.aliquotaI_data.value;
	var aliquotaLM_data = form.aliquotaLM_data.value;
	var aliquotaA_ora = form.aliquotaA_ora.value;
	var aliquotaC_ora = form.aliquotaC_ora.value;
	var aliquotaD_ora = form.aliquotaD_ora.value;
	var aliquotaI_ora = form.aliquotaI_ora.value;
	var aliquotaLM_ora = form.aliquotaLM_ora.value;
	
	if (carabinieriForestali==""){
		msg +="Indicare CARABINIERI FORESTALI.\n";
		esito = false;	
	}
	
	if (altriPartecipanti1==""){
		msg +="Indicare ALTRI PARTECIPANTI - PRIMA COPPIA.\n";
		esito = false;	
	} 
	
	if (qualitaAltriPartecipanti1==""){
		msg +="Indicare IN QUALITA' DI per ALTRI PARTECIPANTI - PRIMA COPPIA.\n";
		esito = false;	
	}
	
	if ((altriPartecipanti2 != '' && qualitaAltriPartecipanti2 == '') || (altriPartecipanti2 == '' && qualitaAltriPartecipanti2 != '')){
		msg +="Indicare sia NOMINATIVI che IN QUALITA' DI per ALTRI PARTECIPANTI - SECONDA COPPIA.\n";
		esito = false;	
	} 
	
	if ((altriPartecipanti3 != '' && qualitaAltriPartecipanti3 == '') || (altriPartecipanti3 == '' && qualitaAltriPartecipanti3 != '')){
		msg +="Indicare sia NOMINATIVI che IN QUALITA' DI per ALTRI PARTECIPANTI - TERZA COPPIA.\n";
		esito = false;	
	} 
	
	
	if (datiProprietarioParticella==""){
		msg +="Indicare DATI PROPRIETARIO PARTICELLA.\n";
		esito = false;	
	}
	
	if (!proprietarioPresente) {
		if (datiAltraPersonaPresente==""){
			msg +="Indicare ALTRA PERSONA PRESENTE\n";
			esito = false;	
		}
		if (qualitaAltraPersonaPresente==""){
			msg +="Indicare IN QUALITA' DI per ALTRA PERSONA PRESENTE.\n";
			esito = false;	
		}
	}	 
	
	
	var v3 = document.getElementById("coordinataXVoc").value;
	var v4 = document.getElementById("coordinataYVoc").value;
	
	if (v3 == "" || v4 == ""){
		msg +="Compilare le coordinate del campione VOC.\n";
		esito = false;
	}
	
	if (!validaCoordinateCampania(v3, v4)){
		 msg += "Coordinate: Valore errato. Inserire una coppia di coordinate in Campania.\n";
		 esito = false;
	}
	
	if (numCampioniElementari=="" || numCampioniElementari>5){
		msg +="Indicare il Numero Campioni Elementari.\n";
		esito = false;	
	}
	
	for (var i = 1; i<=numCampioniElementari; i++){
		var c3 = document.getElementById("coordinataX"+i).value;
		var c4 = document.getElementById("coordinataY"+i).value;

		if (c3=="" || c4==""){
			msg +="Compilare le coordinate del campione "+i+".\n";
			esito = false;
		}
		
		if (!validaCoordinateCampania(c3, c4)){
			 msg += "Coordinate: Valore errato per campione" +i+". Inserire una coppia di coordinate in Campania.\n";
			 esito = false;
		}
	}
	
	if (tipoColturaParticellaCodice==""){
		msg +="Indicare il tipo di coltura della particella.\n";
		esito = false;	
	}
	if (tipoColturaParticellaCodice == "C" && tipoColturaParticellaNote==""){
		msg +="Specificare il tipo di coltura della particella.\n";
		esito = false;	
	}
	if (!presenzaRifiutiS.checked && !presenzaRifiutiN.checked && !presenzaRifiutiP.checked){
		msg +="Indicare la presenza di rifiuti.\n";
		esito = false;	
	}
	
	if (aliquotaA.checked && (aliquotaA_data == '' || aliquotaA_ora == '')){
		msg +="Indicare DATA e ORA per aliquota a.\n";
		esito = false;	
	} else {
		var data = aliquotaA_data + ' ' + aliquotaA_ora;
		var dataCampione = '<%=dataPrelievo%> <%=oraPrelievo%>';
		const data1 = new Date(data);
		const data2 = new Date(dataCampione);
		if (data1<data2){
			msg +="Indicare una data uguale o successiva alla data di campionamento ("+dataCampione+") per aliquota a.\n";
			esito = false;	
		}	
	}
	
	if (aliquotaC.checked && (aliquotaC_data == '' || aliquotaC_ora == '')){
		msg +="Indicare DATA e ORA per aliquota c.\n";
		esito = false;	
	} else {
		var data = aliquotaC_data + ' ' + aliquotaC_ora;
		var dataCampione = '<%=dataPrelievo%> <%=oraPrelievo%>';
		const data1 = new Date(data);
		const data2 = new Date(dataCampione);
		if (data1<data2){
			msg +="Indicare una data uguale o successiva alla data di campionamento ("+dataCampione+") per aliquota c.\n";
			esito = false;	
		}	
	}
	
	if (aliquotaD.checked && (aliquotaD_data == '' || aliquotaD_ora == '')){
		msg +="Indicare DATA e ORA per aliquota d.\n";
		esito = false;	
	} else {
		var data = aliquotaD_data + ' ' + aliquotaD_ora;
		var dataCampione = '<%=dataPrelievo%> <%=oraPrelievo%>';
		const data1 = new Date(data);
		const data2 = new Date(dataCampione);
		if (data1<data2){
			msg +="Indicare una data uguale o successiva alla data di campionamento ("+dataCampione+") per aliquota d.\n";
			esito = false;	
		}	
	}
	
	if (aliquotaI.checked && (aliquotaI_data == '' || aliquotaI_ora == '')){
		msg +="Indicare DATA e ORA per aliquota i.\n";
		esito = false;	
	} else {
		var data = aliquotaI_data + ' ' + aliquotaI_ora;
		var dataCampione = '<%=dataPrelievo%> <%=oraPrelievo%>';
		const data1 = new Date(data);
		const data2 = new Date(dataCampione);
		if (data1<data2){
			msg +="Indicare una data uguale o successiva alla data di campionamento ("+dataCampione+") per aliquota i.\n";
			esito = false;	
		}	
	}
	
	if (aliquotaLM.checked && (aliquotaLM_data == '' || aliquotaLM_ora == '')){
		msg +="Indicare DATA e ORA per aliquota l-m.\n";
		esito = false;	
	} else {
		var data = aliquotaLM_data + ' ' + aliquotaLM_ora;
		var dataCampione = '<%=dataPrelievo%> <%=oraPrelievo%>';
		const data1 = new Date(data);
		const data2 = new Date(dataCampione);
		if (data1<data2){
			msg +="Indicare una data uguale o successiva alla data di campionamento ("+dataCampione+") per aliquota l-m.\n";
			esito = false;	
		}	
	}
	
	
	if (!esito){
		alert(msg);
		return false;
	}
	
	loadModalWindow();
	form.submit();
}


function prettyPrint() {
    var ugly = document.getElementById('jsonCampione').value;
    var obj = JSON.parse(ugly);
    var pretty = JSON.stringify(obj, undefined, 4);
    document.getElementById('jsonCampione').value = pretty;
}
prettyPrint();
var scroll_height = $("#jsonCampione").get(0).scrollHeight;
$("#jsonCampione").css('height', scroll_height + 'px');
</script>

