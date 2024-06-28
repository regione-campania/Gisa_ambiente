<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<%@ include file="../../../initPage.jsp"%>

<jsp:useBean id="jsonCampione" class="org.json.JSONObject" scope="request"/>

<jsp:useBean id="ListaMotivi" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="ListaMatrici" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="ListaComponentiTecnici" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="ListaTipiColture" class="java.util.ArrayList" scope="request"/>

<%@ page import="org.aspcfs.modules.gestioneispettive.base.*"%>
<%@ page import="org.json.*"%>
<%@ page import="org.apache.commons.lang.ArrayUtils"%>

<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery/jquery-1.8.2.js"></script>
<script src="javascript/jquery/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<%@ include file="../../../terreni/util/coordinate.jsp"%>

<script>
function filtraRigheMotivi() {
	
	  // Declare variables
	  var table = document.getElementById("tableMotivi");
	  var input1 = document.getElementById("myInputMotivo");

	  var input, filter, table, tr, td, i, txtValue;
	  
	  filter1 = input1.value.toUpperCase();
	  
	  tr = table.getElementsByTagName("tr");

	  // Loop through all table rows, and hide those who don't match the search query
	  for (i = 0; i < tr.length; i++) {
	    td0 = tr[i].getElementsByTagName("td")[0];
	    td1 = tr[i].getElementsByTagName("td")[1];
	    
	    if (td0) {
	      txtValue0 = td0.textContent || td0.innerText;
	      txtValue1 = td1.textContent || td1.innerText;
	      
	      if (txtValue1.toUpperCase().indexOf(filter1) > -1 ) {
	        tr[i].style.display = "";
	      } else {
	        tr[i].style.display = "none";
	      }
	    }
	  }
	}
	
function filtraRigheMatrici() {
	
	  // Declare variables
	  var table = document.getElementById("tableMatrici");
	  var input1 = document.getElementById("myInputMatrice");

	  var input, filter, table, tr, td, i, txtValue;
	  
	  filter1 = input1.value.toUpperCase();
	  
	  tr = table.getElementsByTagName("tr");

	  // Loop through all table rows, and hide those who don't match the search query
	  for (i = 0; i < tr.length; i++) {
	    td0 = tr[i].getElementsByTagName("td")[0];
	    td1 = tr[i].getElementsByTagName("td")[1];
	    
	    if (td0) {
	      txtValue0 = td0.textContent || td0.innerText;
	      txtValue1 = td1.textContent || td1.innerText;
	      
	      if (txtValue1.toUpperCase().indexOf(filter1) > -1 ) {
	        tr[i].style.display = "";
	      } else {
	        tr[i].style.display = "none";
	      }
	    }
	  }
	}

function filtraRigheTecnici() {
	  // Declare variables
	  var table = document.getElementById("tableGruppoIspettivoTecnici");
	  var input1 = document.getElementById("myInputQualificaTecnici");
	  var input2 = document.getElementById("myInputComponenteTecnici");
	  
	  var input, filter, table, tr, td, i, txtValue;
	  
	  filter1 = input1.value.toUpperCase();
	  filter2 = input2.value.toUpperCase();

	  tr = table.getElementsByTagName("tr");

	  // Loop through all table rows, and hide those who don't match the search query
	  for (i = 0; i < tr.length; i++) {
	    td0 = tr[i].getElementsByTagName("td")[0];
	    td1 = tr[i].getElementsByTagName("td")[1];
	    td2 = tr[i].getElementsByTagName("td")[2];

	    if (td0) {
	      txtValue0 = td0.textContent || td0.innerText;
	      txtValue1 = td1.textContent || td1.innerText;
	      txtValue2 = td2.textContent || td2.innerText;

	      if (txtValue1.toUpperCase().indexOf(filter1) > -1 && txtValue2.toUpperCase().indexOf(filter2) > -1 ) {
	        tr[i].style.display = "";
	      } else {
	        tr[i].style.display = "none";
	      }
	    }
	  }
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

function backForm(form){
	if (confirm("Attenzione. Eventuali modifiche verranno perse. Proseguire?")){
		form.action="GestioneCampioni.do?command=ViewParticella";
		loadModalWindow();
		form.submit();
	}
}

function checkForm(form){ 
	var esito = true;
	var msg = '';
	
	var almenoUnRadio = false;
	var radios = document.getElementsByName("motivoId");
    for (var i = 0, len = radios.length; i < len; i++) {
         if (radios[i].checked) {
        	 almenoUnRadio = true;
          }
     }
	
	if (!almenoUnRadio){
		msg+= "Selezionare una motivo.";
		esito = false;
	}
	
	let dataPrelievo = form.dataPrelievo.value.toString();
	let ore = form.ore.value;
	var numeroVerbale = form.numeroVerbale.value;
	
	if (form.dataPrelievo.value==""){
		msg +="Selezionare la data del prelievo.\n";
		esito = false;	
	}
	if (form.ore.value==""){
		msg +="Selezionare l'ora del prelievo.\n";
		esito = false;	
	} 
	if (numeroVerbale==""){
		msg +="Indicare il numero verbale.\n";
		esito = false;	
	}
	
	var almenoUnaMatrice = false;

	var x = document.getElementsByName("matriceId");
	for (var i = 0; i<x.length; i++) {
		if (x[i].checked){
			almenoUnaMatrice = true;
			
		}
	}
	
	if (!almenoUnaMatrice){
		msg +="Selezionare la matrice.\n";
		esito = false;
	}	
	
	var almenoUnTecnico = false;
	
	var x = document.getElementsByName("componenteTecnicoId");
	for (var i = 0; i<x.length; i++) {
		if (x[i].checked){
			almenoUnTecnico = true;
		}
	}
	
	if (!almenoUnTecnico){
		msg +="Selezionare almeno un tecnico del campionamento..\n"; 
		esito = false;
	}

	var almenoUnAddetto = false;
	
	var nomeAddetto1 = document.getElementById("componenteAddettoNome1").value.trim();
	var nomeAddetto2 = document.getElementById("componenteAddettoNome2").value.trim();
	var nomeAddetto3 = document.getElementById("componenteAddettoNome3").value.trim();
	var cognomeAddetto1 = document.getElementById("componenteAddettoCognome1").value.trim();
	var cognomeAddetto2 = document.getElementById("componenteAddettoCognome2").value.trim();
	var cognomeAddetto3 = document.getElementById("componenteAddettoCognome3").value.trim();
	
	if (nomeAddetto1 != '' && cognomeAddetto1 != '')
		almenoUnAddetto = true;
	if (nomeAddetto2 != '' && cognomeAddetto2 != '')
		almenoUnAddetto = true;
	if (nomeAddetto3 != '' && cognomeAddetto3 != '')
		almenoUnAddetto = true;
	
	if (!almenoUnAddetto){
		msg +="Indicare nome e cognome di almeno un addetto al campionamento.\n"; 
		esito = false;
	}
	
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
		var dataCampione = dataPrelievo + ' ' + ore;
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
		var dataCampione = dataPrelievo + ' ' + ore;
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
		var dataCampione = dataPrelievo + ' ' + ore;
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
		var dataCampione = dataPrelievo + ' ' + ore;
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
		var dataCampione = dataPrelievo + ' ' + ore;
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
	
	if (confirm("I dati del campione saranno aggiornati. Proseguire?")){
		loadModalWindow();
		form.submit();
	}

}
</script>


<center>


<%! public static String fixData(Object objData)
  {
	  String toRet = "";
	  if (objData == null || objData.equals(""))
		  return toRet;
	  String data = objData.toString();
	  String anno = data.substring(0,4);
	  String mese = data.substring(5,7);
	  String giorno = data.substring(8,10);
	  toRet =anno+"-"+mese+"-"+giorno;
	  return toRet;
	  
  }%>
  

<% 
JSONObject jsonAnagrafica = new JSONObject();
if ( ((JSONObject) jsonCampione).has("Anagrafica")){
	jsonAnagrafica = (JSONObject) jsonCampione.get("Anagrafica");
}

int idMotivo = -1;
if ( ((JSONObject) jsonCampione).has("Motivo")) {
JSONObject jsonMotivo = (JSONObject) jsonCampione.get("Motivo");
idMotivo = Integer.parseInt((String) jsonMotivo.get("id")); 
}

int[] idMatrici = {};
if ( ((JSONObject) jsonCampione).has("Matrici")) { 
	JSONArray jsonMatrici = (JSONArray) jsonCampione.get("Matrici");
	idMatrici = new int[jsonMatrici.length()];
	for (int i = 0; i<jsonMatrici.length(); i++) {
		JSONObject jsonMatrice = (JSONObject) jsonMatrici.get(i);
		idMatrici[i] = (int) jsonMatrice.get("id");
	}
}

JSONObject jsonDati = null;
if ( ((JSONObject) jsonCampione).has("Dati")) {
	jsonDati = (JSONObject) jsonCampione.get("Dati"); 
}

int[] idTecnici = {};
if ( ((JSONObject) jsonCampione).has("GruppoTecnici")) { 
	JSONArray jsonGruppoTecnici = (JSONArray) jsonCampione.get("GruppoTecnici");
	idTecnici = new int[jsonGruppoTecnici.length()];
	for (int i = 0; i<jsonGruppoTecnici.length(); i++) {
	JSONObject jsonComponente = (JSONObject) jsonGruppoTecnici.get(i);
	idTecnici[i] = (int) jsonComponente.get("id");
	}
}

JSONObject jsonGruppoAddetti = null;
if ( ((JSONObject) jsonCampione).has("GruppoAddetti")) { 
	jsonGruppoAddetti = (JSONObject) jsonCampione.get("GruppoAddetti");
}

JSONObject jsonDatiVerbaleCampione = new JSONObject();
if ( ((JSONObject) jsonCampione).has("DatiVerbaleCampione")) {
	 jsonDatiVerbaleCampione = (JSONObject) jsonCampione.get("DatiVerbaleCampione");
}

JSONObject jsonCampiServizio = new JSONObject();
if ( ((JSONObject) jsonCampione).has("CampiServizio")) {
	jsonCampiServizio = (JSONObject) jsonCampione.get("CampiServizio");
}
%>

<form name="modificaCampione" action="GestioneCampioni.do?command=UpdateParticella&auto-populate=true" onSubmit="" method="post">
<input type="hidden" id="idCampione" name="idCampione" value="<%=jsonCampiServizio.get("idCampione") %>"/>

<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="20%">
<tr><th colspan="2"><center><b>Modifica CAMPIONAMENTO su PARTICELLA</b></center></th></tr>

<tr><td class="formLabel">Codice Sito</td><td><%=jsonAnagrafica.get("codiceSito") %> <a href="Terreni.do?command=DetailsSubparticella&id=<%=jsonAnagrafica.get("riferimentoId")%>"><b>Torna alla Particella</b></a></td></tr>
<tr><td class="formLabel">Id Campione</td><td><%=jsonCampiServizio.get("idCampione") %> <a href="GestioneCampioni.do?command=ViewParticella&idCampione=<%=jsonCampiServizio.get("idCampione")%>"><b>Torna al campione</b></a></td></tr>

</table>

<br/>

<table class="details" id="tableMotivi" name="tableMotivi" cellpadding="10" cellspacing="10" width="100%">
<col width="5%"/>

<tr>
<th colspan="2"><center><b>MOTIVO</b></center></th>
</tr>

<tr>
<th>Seleziona</th>
<th><input type="text" id="myInputMotivo" onkeyup="filtraRigheMotivi()" placeholder="FILTRA MOTIVO" style="width: 100%"></th>
</tr>

<%for (int i = 0; i<ListaMotivi.size(); i++){
	MotivoCampionamentoParticella mot = (MotivoCampionamentoParticella) ListaMotivi.get(i);
	if (mot.getId() == idMotivo) {%>
	<tr>
	<td>
	<input type="radio" id="motivoId_<%=i %>" name="motivoId" value="<%=mot.getId()%>" <%=mot.getDescrizione().toLowerCase().contains("acque") ? "disabled" : "" %> <%=mot.getId() == idMotivo ? "checked" : "" %>/> 
	<input type="hidden" id="motivoDescrizione_<%=mot.getId()%>" name="motivoDescrizione_<%=mot.getId()%>" value="<%=mot.getDescrizione() %>"/> 
	</td>
	<td><%=mot.getDescrizione() %> <%=mot.getDescrizione().toLowerCase().contains("acque") ? "<font color='red'>Non attualmente disponibile</font>" : "" %> <font color="red">Dato non modificabile</font></td>	
	</tr>
	<% } %>
	<%} %>
</table>

<br/>

<table class="details" id ="tableMatrici" name="tableMatrici" cellpadding="10" cellspacing="10" width="100%" style="border-collapse: collapse">
<col width="5%">
<tr><th colspan="2"><center><b>MATRICE</b></center></th></tr>

<tr>
<th>Seleziona</th>
<th>Matrice</th>
</tr>

<tr>
<th></th>
<th><input type="text" id="myInputMatrice" onkeyup="filtraRigheMatrici()" placeholder="FILTRA MATRICE" style="width: 100%"></th>
</tr>

<% 

if (ListaMatrici.size()>0) {
for (int i = 0; i<ListaMatrici.size(); i++) {
Matrice matrice = (Matrice) ListaMatrici.get(i); 
if (ArrayUtils.contains(idMatrici, matrice.getCode())) {%>
<tr>

<td>
<input type="radio" id ="<%= matrice.getCode()%>" name="matriceId" value="<%= matrice.getCode()%>" <%=matrice.getMatrice().toLowerCase().contains("acque") ? "disabled" : "" %> <%=ArrayUtils.contains(idMatrici, matrice.getCode()) ? "checked" : "" %>/>
<input type="hidden" readonly id ="matriceNome_<%= matrice.getCode()%>" name ="matriceNome_<%= matrice.getCode()%>" value="<%= matrice.getMatrice() %>" />
</td>

<td><%= matrice.getMatrice() %> <%=matrice.getMatrice().toLowerCase().contains("acque") ? "<font color='red'>Non attualmente disponibile</font>" : "" %> <font color="red">Dato non modificabile</font></td>

</tr>
<% } }%>

<%} else { %>
<tr><td colspan="3">MATRICI NON SELEZIONABILI IN QUANTO MANCANTI. PROSEGUIRE.
<input type="hidden" checked readonly id ="-1" name ="matriceId" value="-1"/>
</td></tr>
<%} %>
</table>

<br/>

<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="20%">
<tr><th colspan="2"><center><b>DATI</b></center></th></tr>

<tr><td class="formLabel">Data del prelievo </td><td><input type="date" readonly id="dataPrelievo" name="dataPrelievo" value="<%=fixData(jsonDati.get("dataPrelievo")) %>"/> <font color="red">Dato non modificabile</font></td></tr>
<script>document.getElementById("dataPrelievo").max = new Date().toISOString().split("T")[0];</script>
<tr><td class="formLabel">Ora del prelievo </td><td><input type="time" id="ore" name="ore" value="<%=jsonDati.get("ore") %>"/></td></tr>
<tr><td class="formLabel">Numero Verbale</td><td><input type="text" readonly id="numeroVerbale" name="numeroVerbale" value="<%=jsonDati.get("numeroVerbale") %>" /> <font color="red">Dato non modificabile</font></td></tr>

</table>

<br/>

<table class="details" id ="tableGruppoIspettivoTecnici" name="tableGruppoIspettivoTecnici" cellpadding="10" cellspacing="10" width="100%" style="border-collapse: collapse">
<col width="5%"><col width="15%">
<tr><th colspan="3"><center><b>TECNICI DEL CAMPIONAMENTO</b></center></th></tr>

<tr>
<th></th>
<th>Qualifica</th>
<th>Componente</th>
</tr>

<tr>
<th></th>
<th><input type="text" id="myInputQualificaTecnici" onkeyup="filtraRigheTecnici()" placeholder="FILTRA QUALIFICA" style="width: 100%"></th>
<th><input type="text" id="myInputComponenteTecnici" onkeyup="filtraRigheTecnici()" placeholder="FILTRA COMPONENTE" style="width: 100%"></th>
</tr>

<% 
for (int i = 0; i<ListaComponentiTecnici.size(); i++) {
Componente comp = (Componente) ListaComponentiTecnici.get(i); %>

<tr>
<td>
<input type="checkbox" id ="<%= comp.getId()%>" name="componenteTecnicoId" value="<%= comp.getId()%>" <%=ArrayUtils.contains(idTecnici, comp.getId()) ? "checked" : "" %>/>
<input type="hidden" readonly id ="componenteTecnicoNome_<%= comp.getId()%>" name ="componenteTecnicoNome_<%= comp.getId()%>" value="<%= comp.getNominativo() %>"/>
<input type="hidden" readonly id ="componenteTecnicoQualifica_<%= comp.getId()%>" name ="componenteTecnicoQualifica_<%= comp.getId()%>" value="<%= comp.getNomeQualifica() %>"/>
</td>
<td><%= comp.getNomeQualifica() %></td>
<td><%= comp.getNominativo() %></td>
</tr>
<% } %>

</table>
	

<br/>

<table class="details" id ="tableGruppoIspettivoAddetti" name="tableGruppoIspettivoAddetti" cellpadding="10" cellspacing="10" width="100%" style="border-collapse: collapse">
<col width="5%"><col width="15%">
<tr><th colspan="3"><center><b>ADDETTI AL CAMPIONAMENTO</b></center></th></tr>

<tr><td></td><td>ARPAC MULTISERVIZI</td><td><input type="text" id="componenteAddettoNome1" name="componenteAddettoNome1" placeholder="Nome" size="30" value="<%=jsonGruppoAddetti.get("nome1")%>"/> <input type="text" id="componenteAddettoCognome1" name="componenteAddettoCognome1" placeholder="Cognome" size="30" value="<%=jsonGruppoAddetti.get("cognome1")%>"/></td></tr>
<tr><td></td><td>ARPAC MULTISERVIZI</td><td><input type="text" id="componenteAddettoNome2" name="componenteAddettoNome2" placeholder="Nome" size="30" value="<%=jsonGruppoAddetti.get("nome2")%>"/> <input type="text" id="componenteAddettoCognome2" name="componenteAddettoCognome2" placeholder="Cognome" size="30" value="<%=jsonGruppoAddetti.get("cognome2")%>"/></td></tr>
<tr><td></td><td>ARPAC MULTISERVIZI</td><td><input type="text" id="componenteAddettoNome3" name="componenteAddettoNome3" placeholder="Nome" size="30" value="<%=jsonGruppoAddetti.get("nome3")%>"/> <input type="text" id="componenteAddettoCognome3" name="componenteAddettoCognome3" placeholder="Cognome" size="30" value="<%=jsonGruppoAddetti.get("cognome3")%>"/></td></tr>

</table>

</td></tr>
</table>

<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="30%">
<tr><th colspan="2"><center><b>DATI VERBALE</b></center></th></tr>

<tr><td class="formLabel">Carabinieri forestali</td><td><textarea cols="100" rows="3" id="carabinieriForestali" name="carabinieriForestali" size="50" placeholder="Nominativi"><%=jsonDatiVerbaleCampione.get("carabinieriForestali") %></textarea></td></tr>
<tr><td class="formLabel">Altri partecipanti</td><td>
Nominativi<br/> <textarea cols="100" rows="3" id="altriPartecipanti1" name="altriPartecipanti1" placeholder="Nominativi"><%=jsonDatiVerbaleCampione.get("altriPartecipanti1") %></textarea><br/>Presenti al campionamento in qualita' di<br/> <textarea cols="100" rows="3" id="qualitaAltriPartecipanti1" name="qualitaAltriPartecipanti1" placeholder="In qualità di"><%=jsonDatiVerbaleCampione.get("qualitaAltriPartecipanti1") %></textarea><br/><br/>
Nominativi<br/> <textarea cols="100" rows="3" id="altriPartecipanti2" name="altriPartecipanti2" placeholder="Nominativi"><%=jsonDatiVerbaleCampione.get("altriPartecipanti2") %></textarea><br/>Presenti al campionamento in qualita' di<br/> <textarea cols="100" rows="3" id="qualitaAltriPartecipanti2" name="qualitaAltriPartecipanti2" placeholder="In qualità di"><%=jsonDatiVerbaleCampione.get("qualitaAltriPartecipanti2") %></textarea><br/><br/>
Nominativi<br/> <textarea cols="100" rows="3" id="altriPartecipanti3" name="altriPartecipanti3" placeholder="Nominativi"><%=jsonDatiVerbaleCampione.get("altriPartecipanti3") %></textarea><br/>Presenti al campionamento in qualita' di<br/> <textarea cols="100" rows="3" id="qualitaAltriPartecipanti3" name="qualitaAltriPartecipanti3" placeholder="In qualità di"><%=jsonDatiVerbaleCampione.get("qualitaAltriPartecipanti3") %></textarea><br/></td></tr>
<tr><td class="formLabel">Dati proprietario particella (nome e cognome)</td><td> 

Proprietario<br/>
<textarea cols="100" rows="3" id="datiProprietarioParticella" name="datiProprietarioParticella" placeholder="Nominativo"><%=jsonDatiVerbaleCampione.get("datiProprietarioParticella") %></textarea><br/>

Proprietario presente: SI <input type="radio" id="proprietarioPresenteS" name="proprietarioPresente" value="true" <%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("proprietarioPresente")) ? "checked" : "" %> onChange="checkProprietarioPresente(this)"> NO <input type="radio" id="proprietarioPresenteN" name="proprietarioPresente" value="false" <%=Boolean.FALSE.equals(jsonDatiVerbaleCampione.get("proprietarioPresente")) ? "checked" : "" %> onChange="checkProprietarioPresente(this)">
<div id="divProprietarioPresenteN" <%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("proprietarioPresente")) ? "style=\"display:none\"" : "" %>>Altra persona presente<br/> <textarea cols="100" rows="3" id="datiAltraPersonaPresente" name="datiAltraPersonaPresente" placeholder="Nominativo"><%=jsonDatiVerbaleCampione.get("datiAltraPersonaPresente") %></textarea><br/> In qualita' di<br/> <textarea cols="100" rows="3" id="qualitaAltraPersonaPresente" name="qualitaAltraPersonaPresente" placeholder="In qualità di"><%=jsonDatiVerbaleCampione.get("qualitaAltraPersonaPresente") %></textarea></div>

</td></tr>

</table>

<br/>

<table class="details" cellpadding="10" cellspacing="10" width="100%">

<tr><th colspan="4"><center><b>DATI VERBALE CAMPIONE</b></center></th></tr>

<tr><td class="formLabel" colspan="2">Numero campioni elementari</td><td colspan="2">

<input type="radio" id="numCampioniElementari1" name="numCampioniElementari" value="1" <%=Integer.parseInt((String)jsonDatiVerbaleCampione.get("numCampioniElementari")) == 1 ? "checked" : "" %> onClick="checkCampioniElementari(this)"/> 1
<input type="radio" id="numCampioniElementari2" name="numCampioniElementari" value="2" <%=Integer.parseInt((String)jsonDatiVerbaleCampione.get("numCampioniElementari")) == 2 ? "checked" : "" %> onClick="checkCampioniElementari(this)"/> 2
<input type="radio" id="numCampioniElementari3" name="numCampioniElementari" value="3" <%=Integer.parseInt((String)jsonDatiVerbaleCampione.get("numCampioniElementari")) == 3 ? "checked" : "" %> onClick="checkCampioniElementari(this)"/> 3
<input type="radio" id="numCampioniElementari4" name="numCampioniElementari" value="4" <%=Integer.parseInt((String)jsonDatiVerbaleCampione.get("numCampioniElementari")) == 4 ? "checked" : "" %> onClick="checkCampioniElementari(this)"/> 4
<input type="radio" id="numCampioniElementari5" name="numCampioniElementari" value="5" <%=Integer.parseInt((String)jsonDatiVerbaleCampione.get("numCampioniElementari")) == 5 ? "checked" : "" %> onClick="checkCampioniElementari(this)"/> 5 

</td></tr>

<tr><th>Campione di suolo</th><th>Codice Identificativo</th><th>Coordinata_X</th><th>Coordinata_Y</th></tr>

<tr>
<td>Campione per VOC</td>
<td><input type="text" readonly id="codiceIdentificativoVoc" name="codiceIdentificativoVoc" size="20" value="<%=jsonDatiVerbaleCampione.get("codiceIdentificativoVoc") %>"/></td>
<td><input type="text" id="coordinataXVoc" name="coordinataXVoc" size="20" onKeyUp="validaCoordinateFormato(this)" value="<%=jsonDatiVerbaleCampione.get("coordinataXVoc") %>"/></td>
<td><input type="text" id="coordinataYVoc" name="coordinataYVoc" size="20" onKeyUp="validaCoordinateFormato(this)" value="<%=jsonDatiVerbaleCampione.get("coordinataYVoc") %>"/></td>
</tr>

<% for (int i = 1; i<=5; i++){ %>
<tr id="trCampioneElementare<%=i%>" <%=Integer.parseInt((String)jsonDatiVerbaleCampione.get("numCampioniElementari")) < i ? "style=\"display:none\"" : "" %>>
<td>Campione Elementare</td>
<td><input type="text" readonly id="codiceIdentificativo<%=i %>" name="codiceIdentificativo<%=i %>" size="20" value="<%=jsonDatiVerbaleCampione.get("codiceIdentificativo"+i) %>"/></td>
<td><input type="text" id="coordinataX<%=i %>" name="coordinataX<%=i %>" size="20" onKeyUp="validaCoordinateFormato(this)" value="<%=jsonDatiVerbaleCampione.get("coordinataX"+i) %>"/></td>
<td><input type="text" id="coordinataY<%=i %>" name="coordinataY<%=i %>" size="20" onKeyUp="validaCoordinateFormato(this)" value="<%=jsonDatiVerbaleCampione.get("coordinataY"+i) %>"/></td>
</tr>
<% } %>

<tr>
<td>Campione medio composito</td>
<td><input type="text" id="codiceIdentificativoMedioComposito" name="codiceIdentificativoMedioComposito" size="20" readonly value="<%=jsonDatiVerbaleCampione.get("codiceIdentificativoMedioComposito") %>"/></td>
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
<tr><td><input type="checkbox" id="aliquotaA" name="aliquotaA" value="true" <%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaA")) ? "checked" : "" %> onClick="return false"/>a</td><td><input type="date" id="aliquotaA_data" name="aliquotaA_data" onChange="checkAliquotaData(this)" value="<%=fixData(jsonDatiVerbaleCampione.get("aliquotaA_data")) %>"></td><td><input type="time" id="aliquotaA_ora" name="aliquotaA_ora" value="<%=jsonDatiVerbaleCampione.get("aliquotaA_ora") %>"></td><td></td><td><input type="text" readonly id="aliquotaA_laboratorio" name="aliquotaA_laboratorio" value="ARPAC"/></td></td></tr>
<tr><td><input type="checkbox" id="aliquotaBG" name="aliquotaBG" value="true" <%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaBG")) ? "checked" : "" %> onClick="checkAliquota(this, 'BG')"/>b-g</td><td></td></td><td></td><td><input type="text" readonly id="aliquotaBG_laboratorio" name="aliquotaBG_laboratorio" <%=!Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaBG")) ? "style=\"display:none\"" : "" %> value="ARPAC"/></td></tr>
<tr><td><input type="checkbox" id="aliquotaC" name="aliquotaC" value="true" <%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaC")) ? "checked" : "" %> onClick="return false"/>c</td><td><input type="date" id="aliquotaC_data" name="aliquotaC_data" onChange="checkAliquotaData(this)" value="<%=fixData(jsonDatiVerbaleCampione.get("aliquotaC_data")) %>"></td><td><input type="time" id="aliquotaC_ora" name="aliquotaC_ora" value="<%=jsonDatiVerbaleCampione.get("aliquotaC_ora") %>"></td><td rowspan="2"><input type="checkbox" id="aliquotaCD_fitofarmaci" name="aliquotaCD_fitofarmaci" value="true" <%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaCD_fitofarmaci")) ? "checked" : "" %>/></td><td><input type="text" readonly id="aliquotaC_laboratorio" name="aliquotaC_laboratorio" value="ARPAC"/></td></tr>
<tr><td><input type="checkbox" id="aliquotaD" name="aliquotaD" value="true" <%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaD")) ? "checked" : "" %> onClick="return false"/>d</td><td><input type="date" id="aliquotaD_data" name="aliquotaD_data" onChange="checkAliquotaData(this)" value="<%=fixData(jsonDatiVerbaleCampione.get("aliquotaD_data")) %>"></td><td><input type="time" id="aliquotaD_ora" name="aliquotaD_ora" value="<%=jsonDatiVerbaleCampione.get("aliquotaD_ora") %>"></td><td><input type="text" readonly id="aliquotaD_laboratorio" name="aliquotaD_laboratorio" value="ARPAC"/></td></tr>
<tr><td><input type="checkbox" id="aliquotaE" name="aliquotaE" value="true" <%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaE")) ? "checked" : "" %> onClick="return false"/>e</td><td></td><td></td><td></td><td><input type="text" readonly id="aliquotaE_laboratorio" name="aliquotaE_laboratorio" <%=!Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaE")) ? "style=\"display:none\"" : "" %> size="30" value="Universita' Federico II di Napoli"/></td></tr>
<tr><td><input type="checkbox" id="aliquotaF" name="aliquotaF" value="true" <%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaF")) ? "checked" : "" %> onClick="return false"/>f</td><td></td><td></td><td></td><td><input type="text" readonly id="aliquotaF_laboratorio" name="aliquotaF_laboratorio" value="ARPAC"/></td></tr>
<tr><td><input type="checkbox" id="aliquotaH" name="aliquotaH" value="true" <%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaH")) ? "checked" : "" %> onClick="return false"/>h</td><td></td><td></td><td></td><td><input type="text" readonly id="aliquotaH_laboratorio" name="aliquotaH_laboratorio" value="ARPAC"/></td></tr>
<tr><td><input type="checkbox" id="aliquotaI" name="aliquotaI" value="true" <%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaI")) ? "checked" : "" %> onClick="return false"/>i</td><td><input type="date" id="aliquotaI_data" name="aliquotaI_data" onChange="checkAliquotaData(this)" value="<%=fixData(jsonDatiVerbaleCampione.get("aliquotaI_data")) %>"></td><td><input type="time" id="aliquotaI_ora" name="aliquotaI_ora" value="<%=jsonDatiVerbaleCampione.get("aliquotaI_ora") %>"></td><td></td><td><input type="text" readonly id="aliquotaI_laboratorio" name="aliquotaI_laboratorio" value="ARPAC"/></td></tr>
<tr><td><input type="checkbox" id="aliquotaLM" name="aliquotaLM" value="true"<%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaLM")) ? "checked" : "" %> onClick="checkAliquota(this, 'LM')"/>l-m</td><td><input type="date" id="aliquotaLM_data" name="aliquotaLM_data" onChange="checkAliquotaData(this)" <%=!Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaLM")) ? "style=\"display:none\"" : "" %> value="<%=fixData(jsonDatiVerbaleCampione.get("aliquotaLM_data")) %>"></td><td><input type="time" id="aliquotaLM_ora" name="aliquotaLM_ora" <%=!Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaLM")) ? "style=\"display:none\"" : "" %> value="<%=jsonDatiVerbaleCampione.get("aliquotaLM_ora") %>"></td><td></td><td><input type="text" readonly id="aliquotaLM_laboratorio" name="aliquotaLM_laboratorio" <%=!Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaLM")) ? "style=\"display:none\"" : "" %> size="30" value="Universita' Federico II di Napoli"/></td></tr>
<tr><td><input type="checkbox" id="aliquotaN" name="aliquotaN" value="true"<%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaN")) ? "checked" : "" %> onClick="checkAliquota(this, 'N')"/>n</td><td></td><td></td><td></td><td><input type="text" readonly id="aliquotaN_laboratorio" name="aliquotaN_laboratorio" <%=!Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("aliquotaN")) ? "style=\"display:none\"" : "" %> value="Controparte"/></td></tr>

</table>

</td></tr>
</table>

<br/>

<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="30%">
<tr><th colspan="2"><center><b>DATI CAMPIONAMENTO SUOLO</b></center></th></tr>

<tr><td class="formLabel">La particella campionata risulta</td><td> <% for (int i = 0; i<ListaTipiColture.size(); i++){ TipoColturaParticella t = (TipoColturaParticella) ListaTipiColture.get(i); %> <input type="radio" id="tipoColturaParticellaCodice_<%=t.getCodice()%>" name ="tipoColturaParticellaCodice" value="<%=t.getCodice()%>" onClick="checkTipoColtura(this)" <%=jsonDatiVerbaleCampione.get("tipoColturaCodice").equals(t.getCodice()) ? "checked" : "" %>/> <%=t.getDescrizione() %> <input type="hidden" id="tipoColturaParticellaDescrizione_<%=t.getCodice()%>" name ="tipoColturaParticellaDescrizione_<%=t.getCodice()%>" value="<%=t.getDescrizione()%>"/><% } %>  <textarea cols="100" rows="3" <%="C".equals(jsonDatiVerbaleCampione.get("tipoColturaCodice")) ? "" : "style=\"display:none\"" %> id="tipoColturaParticellaNote" name="tipoColturaParticellaNote" placeholder="Descrivere il tipo coltura e stato"><%=jsonDatiVerbaleCampione.get("tipoColturaNote")%></textarea> <textarea cols="100" rows="3" <%="NC".equals(jsonDatiVerbaleCampione.get("tipoColturaCodice")) ? "" : "style=\"display:none\"" %>  id="tipoColturaParticellaMotivazione" name="tipoColturaParticellaMotivazione" placeholder="Motivazioni"><%=jsonDatiVerbaleCampione.get("tipoColturaMotivazione")%></textarea> </td></tr>
<tr><td class="formLabel">Presenza rifiuti</td><td><input type="radio" id="presenzaRifiutiS" name="presenzaRifiuti" value="S" onClick="checkPresenzaRifiuti(this)" <%=jsonDatiVerbaleCampione.get("presenzaRifiuti").equals("S") ? "checked" : "" %>/> SI <input type="text" <%="S".equals(jsonDatiVerbaleCampione.get("presenzaRifiuti")) ? "" : "style=\"display:none\"" %> id="presenzaRifiutiNote" name="presenzaRifiutiNote" placeholder="Tipo rifiuti" value="<%=jsonDatiVerbaleCampione.get("presenzaRifiutiNote") %>"> <input type="radio" id="presenzaRifiutiN" name="presenzaRifiuti" value="N" onClick="checkPresenzaRifiuti(this)" <%=jsonDatiVerbaleCampione.get("presenzaRifiuti").equals("N") ? "checked" : "" %>/> NO <input type="radio" id="presenzaRifiutiP" name="presenzaRifiuti" value="P" onClick="checkPresenzaRifiuti(this)" <%=jsonDatiVerbaleCampione.get("presenzaRifiuti").equals("P") ? "checked" : "" %>/> PARZIALMENTE <br/><textarea cols="100" rows="3" <%="P".equals(jsonDatiVerbaleCampione.get("presenzaRifiuti")) ? "" : "style=\"display:none\"" %> id="presenzaRifiutiDescrizione" name="presenzaRifiutiDescrizione" placeholder="Descrizione"><%=jsonDatiVerbaleCampione.get("presenzaRifiutiDescrizione") %></textarea></td></tr>

</table>

<br/>

<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="30%">
<tr><th colspan="2"><center><b>DATI IRRIGAZIONE</b></center></th></tr>

<tr><td class="formLabel">Informazioni acquisite</td><td> In Loco <input type="checkbox" id="irrigazioneInLoco" name="irrigazioneInLoco" value="true" <%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("irrigazioneInLoco")) ? "checked" : "" %>/> <textarea cols="100" rows="3" id="irrigazioneInformazioni" name="irrigazioneInformazioni" placeholder="Dal sig... (Nominativo)"><%=jsonDatiVerbaleCampione.get("irrigazioneInformazioni") %></textarea> </td></tr>
<tr><td class="formLabel">Derivazione acqua utilizzata</td><td> <textarea cols="100" rows="3" id="irrigazioneDerivazione" name="irrigazioneDerivazione" size="50" placeholder="Derivazione"><%=jsonDatiVerbaleCampione.get("irrigazioneDerivazione") %></textarea> </td></tr>

</table>

<br/>

<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="30%">
<tr><th colspan="2"><center><b>DATI ACQUE SOTTERRANEE</b></center></th></tr>

<tr><td class="formLabel">Campionamento acque sotterranee</td><td> SI <input type="checkbox" id="pozzoCampionamento" name="pozzoCampionamento" value="true" onClick="checkPozzoCampionamento(this)" <%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("pozzoCampionamento")) ? "checked" : "" %>/> <input type="text" <%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("pozzoCampionamento")) ? "" : "style=\"display:none\"" %> id="pozzoCampionamentoVerbaleNumero" name="pozzoCampionamentoVerbaleNumero" placeholder="Numero verbale" value="<%=jsonDatiVerbaleCampione.get("pozzoCampionamentoVerbaleNumero") %>"> <input type="date" <%=Boolean.TRUE.equals(jsonDatiVerbaleCampione.get("pozzoCampionamento")) ? "" : "style=\"display:none\"" %> id="pozzoCampionamentoVerbaleData" name="pozzoCampionamentoVerbaleData" placeholder="Data verbale" value="<%=fixData(jsonDatiVerbaleCampione.get("pozzoCampionamentoVerbaleData")) %>"/> </td></tr>

</table>

<br/>

<table class="details" cellpadding="10" cellspacing="10" width="100%">
<col width="30%">
<tr><th colspan="2"><center><b>NOTE</b></center></th></tr>

<tr><td class="formLabel">Dichiarazioni Controparte</td><td> <textarea cols="100" rows="3" id="dichiarazioni" name="dichiarazioni" placeholder="Dichiarazioni"><%=jsonDatiVerbaleCampione.get("dichiarazioni") %></textarea> </td></tr>
<tr><td class="formLabel">Strumentazione utilizzata</td><td> <textarea cols="100" rows="3" id="strumentazione" name="strumentazione" placeholder="Strumentazione"><%=jsonDatiVerbaleCampione.get("strumentazione") %></textarea> </td></tr>
<tr><td class="formLabel">Note aggiuntive</td><td> <textarea cols="100" rows="3" id="noteAggiuntive" name="noteAggiuntive" placeholder="Note"><%=jsonDatiVerbaleCampione.get("noteAggiuntive") %></textarea> </td></tr>

</table>

<!-- BOTTONI -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<tr>
<td colspan="2" align="center"><br/><br/>
<input type="button" value="ANNULLA" onclick="backForm(this.form)" style="font-size:40px; background-color:red"/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" style="font-size:40px" value="AGGIORNA" onclick="checkForm(this.form)"/>
</td>
</tr>
</table>
<!-- BOTTONI -->


<!--JSON -->
<br/><br/><br/><br/>
<textarea rows="10" cols="200" readonly id="jsonCampione" name="jsonCampione" <%= (org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON")!= null && org.aspcfs.modules.util.imports.ApplicationProperties.getProperty("GESTIONE_CU_VEDI_JSON").equalsIgnoreCase("si")) ? "" : "style= \"display:none\""%>><%=jsonCampione%></textarea>
<!--JSON -->

</form>

<script>
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







