<%@ page import="org.aspcfs.modules.util.imports.ApplicationProperties" %>
<%@ page import="java.net.InetAddress" %>
<%@ page import="org.json.*"%>

<%@ include file="../initPage.jsp"%>

<%
// Leggo l'url a cui sono connesso attualmente
String HEADER_URI = request.getRequestURI();
String HEADER_URL = request.getRequestURL().toString();
String HEADER_DOMINIO = HEADER_URL.replaceAll(HEADER_URI, "").replaceAll("https://", "").replaceAll("http://", "");
if (HEADER_DOMINIO.indexOf(":")>0)
	HEADER_DOMINIO = HEADER_DOMINIO.substring(0, HEADER_DOMINIO.indexOf(":"));
System.out.println("### HEADER_DOMINIO: " +HEADER_DOMINIO);

// Istanzio le url che usero' per connettermi
String GISA_CONNESSIONE_HOST = "";

//ATTENZIONE. PER FUNZIONARE SUL FILEHOST DEVE ESSERCI ESATTAMENTE 131.1.255.97 colarpac.gisacampania.it srvGISAW srvDOCUMENTALEW srvDOCUMENTALE 


String GISA_HOST = "";
String GISA_IP = "";
String GISA_PORTA = "";

GISA_IP = InetAddress.getByName("srvGISAW").getHostAddress();
GISA_HOST = java.net.InetAddress.getByName(java.net.InetAddress.getByName("srvGISAW").getHostAddress()).getHostName();
GISA_PORTA = ApplicationProperties.getProperty("APP_PORTA_GISA");

if (GISA_PORTA!=null && GISA_PORTA.equals(":80"))
	GISA_PORTA = "";

System.out.println("### GISA_IP+GISA_PORTA: " +GISA_IP+GISA_PORTA);
System.out.println("### GISA_HOST+GISA_PORTA: " +GISA_HOST+GISA_PORTA);

if (!HEADER_DOMINIO.contains("colarpac")){ //SE MI SONO CONNESSO TRAMITE colarpac.gisacampania.it
	GISA_CONNESSIONE_HOST = HEADER_DOMINIO+GISA_PORTA;
} else { //SE MI SONO CONNESSO TRAMITE IP
	GISA_CONNESSIONE_HOST = GISA_HOST+GISA_PORTA;
}

System.out.println("### GISA_CONNESSIONE_HOST: " +GISA_CONNESSIONE_HOST);
%>

<% org.json.JSONObject json = new JSONObject(request.getParameter("json"));

String idCampione = "";

String datiOre = "";
String datiNumeroVerbale = "";
String datiDataPrelievo = "";

String anagraficaArea = "";
String anagraficaParticellaCatastale = "";
String anagraficaFoglioCatastale = "";
String anagraficaComune = "";
String anagraficaCoordinateY = "";
String anagraficaClasseRischio = "";
String anagraficaCoordinateX = "";
String anagraficaCodiceSito = "";
String anagraficaProvincia = "";

String gruppoTecnici = "";
String gruppoAddetti = "";

boolean datiVerbaleProprietarioPresente = false;
String datiVerbaleProprietario = "";
String datiVerbaleAltraPersonaPresente = "";
String datiVerbaleQualitaAltraPersonaPresente = "";

String datiVerbaleAltriPartecipanti1 = "";
String datiVerbaleQualitaAltriPartecipanti1 = "";
String datiVerbaleAltriPartecipanti2 = "";
String datiVerbaleQualitaAltriPartecipanti2 = "";
String datiVerbaleAltriPartecipanti3 = "";
String datiVerbaleQualitaAltriPartecipanti3 = "";
int datiVerbaleNumCampioniElementari = 0;
String datiVerbaleCodiceIdentificativoVoc = "";
String datiVerbaleCoordinataXVoc = "";
String datiVerbaleCoordinataYVoc = "";
String datiVerbaleCodiceIdentificativo1 = "";
String datiVerbaleCoordinataX1 = "";
String datiVerbaleCoordinataY1 = "";
String datiVerbaleCodiceIdentificativo2 = "";
String datiVerbaleCoordinataX2 = "";
String datiVerbaleCoordinataY2 = "";
String datiVerbaleCodiceIdentificativo3 = "";
String datiVerbaleCoordinataX3 = "";
String datiVerbaleCoordinataY3 = "";
String datiVerbaleCodiceIdentificativo4 = "";
String datiVerbaleCoordinataX4 = "";
String datiVerbaleCoordinataY4 = "";
String datiVerbaleCodiceIdentificativo5 = "";
String datiVerbaleCoordinataX5 = "";
String datiVerbaleCoordinataY5 = "";
String datiVerbaleCodiceIdentificativoMedioComposito = "";
String datiVerbaleTipoColturaCodice = "";
String datiVerbaleTipoColturaNote = "";
String datiVerbaleTipoColturaMotivazione = "";
String datiVerbalePresenzaRifiuti = "";
String datiVerbalePresenzaRifiutiNote = "";
String datiVerbalePresenzaRifiutiDescrizione = "";
String datiVerbaleCarabinieriForestali = "";

boolean datiVerbaleAliquotaA = false;
boolean datiVerbaleAliquotaBG = false;
boolean datiVerbaleAliquotaC = false;
boolean datiVerbaleAliquotaD = false;
boolean datiVerbaleAliquotaCD_fitofarmaci = false;
boolean datiVerbaleAliquotaE = false;
boolean datiVerbaleAliquotaF = false;
boolean datiVerbaleAliquotaH = false;
boolean datiVerbaleAliquotaI = false;
boolean datiVerbaleAliquotaLM = false;
boolean datiVerbaleAliquotaN = false;

String datiVerbaleAliquotaA_data = "";
String datiVerbaleAliquotaA_ora = "";
String datiVerbaleAliquotaBG_data = "";
String datiVerbaleAliquotaBG_ora = "";
String datiVerbaleAliquotaC_data = "";
String datiVerbaleAliquotaC_ora = "";
String datiVerbaleAliquotaD_data = "";
String datiVerbaleAliquotaD_ora = "";
String datiVerbaleAliquotaE_data = "";
String datiVerbaleAliquotaE_ora = "";
String datiVerbaleAliquotaF_data = "";
String datiVerbaleAliquotaF_ora = "";
String datiVerbaleAliquotaH_data = "";
String datiVerbaleAliquotaH_ora = "";
String datiVerbaleAliquotaI_data = "";
String datiVerbaleAliquotaI_ora = "";
String datiVerbaleAliquotaLM_data = "";
String datiVerbaleAliquotaLM_ora = "";
String datiVerbaleAliquotaN_data = "";
String datiVerbaleAliquotaN_ora = "";

String datiVerbaleDichiarazioni = "";
String datiVerbaleStrumentazione = "";

boolean datiVerbaleIrrigazioneInLoco = false;
String datiVerbaleIrrigazioneDerivazione = "";
String datiVerbaleIrrigazioneInformazioni = "";

boolean datiVerbalePozzoCampionamento = false;
String datiVerbalePozzoCampionamentoVerbaleData = "";
String datiVerbalePozzoCampionamentoVerbaleNumero = "";

String datiVerbaleNoteAggiuntive = "";

if ( ((JSONObject) json).has("Campione")) {
	JSONObject jsonCampione = (JSONObject) json.get("Campione");
	
	if (((JSONObject) jsonCampione).has("CampiServizio")){
		JSONObject jsonCampiServizio = (JSONObject) jsonCampione.get("CampiServizio");
		idCampione = jsonCampiServizio.get("idCampione").toString();
	}	
	
	if (((JSONObject) jsonCampione).has("Dati")){
		JSONObject jsonDati = (JSONObject) jsonCampione.get("Dati");
		datiDataPrelievo = jsonDati.get("dataPrelievo").toString();
		datiOre = jsonDati.get("ore").toString();
		datiNumeroVerbale = jsonDati.get("numeroVerbale").toString();
	}		

	if (((JSONObject) jsonCampione).has("GruppoTecnici")){
		JSONArray jsonGruppoTecnici = (JSONArray) jsonCampione.get("GruppoTecnici");
		for (int i = 0; i<jsonGruppoTecnici.length(); i++) {
			JSONObject jsonComponente = (JSONObject) jsonGruppoTecnici.get(i);
			gruppoTecnici+= jsonComponente.get("nominativo") + " ("+jsonComponente.get("qualifica") + ") / ";
			}		
	}
	
	if (((JSONObject) jsonCampione).has("GruppoAddetti")){
		JSONArray jsonGruppoAddetti = (JSONArray) jsonCampione.get("GruppoAddetti");
		for (int i = 0; i<jsonGruppoAddetti.length(); i++) {
			JSONObject jsonComponente = (JSONObject) jsonGruppoAddetti.get(i);
			gruppoAddetti+= jsonComponente.get("nominativo") + " ("+jsonComponente.get("qualifica") + ") / ";
			}		
	}
		
	if (((JSONObject) jsonCampione).has("Anagrafica")){
		JSONObject jsonAnagrafica = (JSONObject) jsonCampione.get("Anagrafica");
		anagraficaCodiceSito = jsonAnagrafica.get("codiceSito").toString();
		anagraficaFoglioCatastale = jsonAnagrafica.get("foglioCatastale").toString();
		anagraficaParticellaCatastale = jsonAnagrafica.get("particellaCatastale").toString();
		anagraficaComune = jsonAnagrafica.get("comune").toString();
		anagraficaProvincia = jsonAnagrafica.get("provincia").toString();
	}	

	if (((JSONObject) jsonCampione).has("DatiVerbaleCampione")){
		JSONObject jsonDatiVerbale = (JSONObject) jsonCampione.get("DatiVerbaleCampione");
		
		datiVerbaleProprietarioPresente = (boolean) jsonDatiVerbale.get("proprietarioPresente");
		datiVerbaleProprietario = jsonDatiVerbale.get("datiProprietarioParticella").toString();
		datiVerbaleAltraPersonaPresente = jsonDatiVerbale.get("datiAltraPersonaPresente").toString();
		datiVerbaleQualitaAltraPersonaPresente = jsonDatiVerbale.get("qualitaAltraPersonaPresente").toString();

		datiVerbaleAltriPartecipanti1 = jsonDatiVerbale.get("altriPartecipanti1").toString();
		datiVerbaleQualitaAltriPartecipanti1 = jsonDatiVerbale.get("qualitaAltriPartecipanti1").toString();
		datiVerbaleAltriPartecipanti2 = jsonDatiVerbale.get("altriPartecipanti2").toString();
		datiVerbaleQualitaAltriPartecipanti2 = jsonDatiVerbale.get("qualitaAltriPartecipanti2").toString();
		datiVerbaleAltriPartecipanti3 = jsonDatiVerbale.get("altriPartecipanti3").toString();
		datiVerbaleQualitaAltriPartecipanti3 = jsonDatiVerbale.get("qualitaAltriPartecipanti3").toString();
		datiVerbaleNumCampioniElementari =  Integer.parseInt(jsonDatiVerbale.get("numCampioniElementari").toString());
		datiVerbaleCodiceIdentificativoVoc = jsonDatiVerbale.get("codiceIdentificativoVoc").toString();
		datiVerbaleCoordinataXVoc = jsonDatiVerbale.get("coordinataXVoc").toString();
		datiVerbaleCoordinataYVoc = jsonDatiVerbale.get("coordinataYVoc").toString();
		datiVerbaleCodiceIdentificativo1 = jsonDatiVerbale.get("codiceIdentificativo1").toString();
		datiVerbaleCoordinataX1 = jsonDatiVerbale.get("coordinataX1").toString();
		datiVerbaleCoordinataY1 = jsonDatiVerbale.get("coordinataY1").toString();
		datiVerbaleCodiceIdentificativo2 = jsonDatiVerbale.get("codiceIdentificativo2").toString();
		datiVerbaleCoordinataX2 = jsonDatiVerbale.get("coordinataX2").toString();
		datiVerbaleCoordinataY2 = jsonDatiVerbale.get("coordinataY2").toString();
		datiVerbaleCodiceIdentificativo3 = jsonDatiVerbale.get("codiceIdentificativo3").toString();
		datiVerbaleCoordinataX3 = jsonDatiVerbale.get("coordinataX3").toString();
		datiVerbaleCoordinataY3 = jsonDatiVerbale.get("coordinataY3").toString();
		datiVerbaleCodiceIdentificativo4 = jsonDatiVerbale.get("codiceIdentificativo4").toString();
		datiVerbaleCoordinataX4 = jsonDatiVerbale.get("coordinataX4").toString();
		datiVerbaleCoordinataY4 = jsonDatiVerbale.get("coordinataY4").toString();
		datiVerbaleCodiceIdentificativo5 = jsonDatiVerbale.get("codiceIdentificativo5").toString();
		datiVerbaleCoordinataX5 = jsonDatiVerbale.get("coordinataX5").toString();
		datiVerbaleCoordinataY5 = jsonDatiVerbale.get("coordinataY5").toString();
		datiVerbaleCodiceIdentificativoMedioComposito = jsonDatiVerbale.get("codiceIdentificativoMedioComposito").toString();
		datiVerbaleTipoColturaCodice = jsonDatiVerbale.get("tipoColturaCodice").toString();
		datiVerbaleTipoColturaNote = jsonDatiVerbale.get("tipoColturaNote").toString();
		datiVerbaleTipoColturaMotivazione = jsonDatiVerbale.get("tipoColturaMotivazione").toString();
		datiVerbalePresenzaRifiuti = jsonDatiVerbale.get("presenzaRifiuti").toString();
		datiVerbalePresenzaRifiutiNote = jsonDatiVerbale.get("presenzaRifiutiNote").toString();
		datiVerbalePresenzaRifiutiDescrizione = jsonDatiVerbale.get("presenzaRifiutiDescrizione").toString();
		datiVerbaleCarabinieriForestali = jsonDatiVerbale.get("carabinieriForestali").toString();
		
		datiVerbaleAliquotaA = (boolean) jsonDatiVerbale.get("aliquotaA");
		datiVerbaleAliquotaBG = (boolean) jsonDatiVerbale.get("aliquotaBG");
		datiVerbaleAliquotaC = (boolean) jsonDatiVerbale.get("aliquotaC");
		datiVerbaleAliquotaD = (boolean) jsonDatiVerbale.get("aliquotaD");
		datiVerbaleAliquotaCD_fitofarmaci = (boolean) jsonDatiVerbale.get("aliquotaCD_fitofarmaci");
		datiVerbaleAliquotaE = (boolean) jsonDatiVerbale.get("aliquotaE");
		datiVerbaleAliquotaF = (boolean) jsonDatiVerbale.get("aliquotaF");
		datiVerbaleAliquotaH = (boolean) jsonDatiVerbale.get("aliquotaH");
		datiVerbaleAliquotaI = (boolean) jsonDatiVerbale.get("aliquotaI");
		datiVerbaleAliquotaLM = (boolean) jsonDatiVerbale.get("aliquotaLM");
		datiVerbaleAliquotaN = (boolean) jsonDatiVerbale.get("aliquotaN");
		
		datiVerbaleAliquotaA_data = jsonDatiVerbale.get("aliquotaA_data").toString();
		datiVerbaleAliquotaA_ora = jsonDatiVerbale.get("aliquotaA_ora").toString();
		datiVerbaleAliquotaBG_data = jsonDatiVerbale.get("aliquotaBG_data").toString();
		datiVerbaleAliquotaBG_ora = jsonDatiVerbale.get("aliquotaBG_ora").toString();
		datiVerbaleAliquotaC_data = jsonDatiVerbale.get("aliquotaC_data").toString();
		datiVerbaleAliquotaC_ora = jsonDatiVerbale.get("aliquotaC_ora").toString();
		datiVerbaleAliquotaD_data = jsonDatiVerbale.get("aliquotaD_data").toString();
		datiVerbaleAliquotaD_ora = jsonDatiVerbale.get("aliquotaD_ora").toString();
		datiVerbaleAliquotaE_data = jsonDatiVerbale.get("aliquotaE_data").toString();
		datiVerbaleAliquotaE_ora = jsonDatiVerbale.get("aliquotaE_ora").toString();
		datiVerbaleAliquotaF_data = jsonDatiVerbale.get("aliquotaF_data").toString();
		datiVerbaleAliquotaF_ora = jsonDatiVerbale.get("aliquotaF_ora").toString();
		datiVerbaleAliquotaH_data = jsonDatiVerbale.get("aliquotaH_data").toString();
		datiVerbaleAliquotaH_ora = jsonDatiVerbale.get("aliquotaH_ora").toString();
		datiVerbaleAliquotaI_data = jsonDatiVerbale.get("aliquotaI_data").toString();
		datiVerbaleAliquotaI_ora = jsonDatiVerbale.get("aliquotaI_ora").toString();
		datiVerbaleAliquotaLM_data = jsonDatiVerbale.get("aliquotaLM_data").toString();
		datiVerbaleAliquotaLM_ora = jsonDatiVerbale.get("aliquotaLM_ora").toString();
		datiVerbaleAliquotaN_data = jsonDatiVerbale.get("aliquotaN_data").toString();
		datiVerbaleAliquotaN_ora = jsonDatiVerbale.get("aliquotaN_ora").toString();
		
		datiVerbaleDichiarazioni = jsonDatiVerbale.get("dichiarazioni").toString();
		datiVerbaleStrumentazione = jsonDatiVerbale.get("strumentazione").toString();
		datiVerbaleIrrigazioneInLoco = (boolean) jsonDatiVerbale.get("irrigazioneInLoco");
		datiVerbaleIrrigazioneDerivazione = jsonDatiVerbale.get("irrigazioneDerivazione").toString();
		datiVerbaleIrrigazioneInformazioni = jsonDatiVerbale.get("irrigazioneInformazioni").toString();
		
		datiVerbalePozzoCampionamento = (boolean) jsonDatiVerbale.get("pozzoCampionamento");
		datiVerbalePozzoCampionamentoVerbaleNumero = jsonDatiVerbale.get("pozzoCampionamentoVerbaleNumero").toString();
		datiVerbalePozzoCampionamentoVerbaleData = jsonDatiVerbale.get("pozzoCampionamentoVerbaleData").toString();

		datiVerbaleNoteAggiuntive = jsonDatiVerbale.get("noteAggiuntive").toString();

	}
	
}

%>



<script src="../javascript/jquery/jquery-1.8.2.js"></script> 
<script src="../javascript/jquery/ui/1.9.1/jquery-ui.js"></script>
<script crossorigin type="text/javascript" src="https://localhost:7777/files/fcsign.js"></script>
<script>

function swapType(){
	$('textarea').each(function () {
		var value = $(this).val();
	    var style = $(this).attr('class');
	    var textbox = $(document.createElement('input')).attr('class', style);
	    textbox.attr('type','text');
	    textbox.val(value);
	    $(this).replaceWith(textbox);
	});
	
	$('input[type=time]').each(function () {
		var value = $(this).val();
	    var style = $(this).attr('class');
	    var textbox = $(document.createElement('input')).attr('class', style);
	    textbox.attr('type','text');
	    textbox.val(value);
	    $(this).replaceWith(textbox);
	});
}


  	function installCertificate(){
	try {
  
			fcsign.callback = installCertificateEnd;
			fcsign.installManagedCertificate('https://localhost:7777/files/Firma GrafoCerta (FEA).fck');
		}

	catch(err) {
  		if(err.message == 'fcsign is not defined'){
  			alert("Assicurarsi di aver installato correttamente l'sdk 'fcsing' e di accedere a questa pagina tramite Dipositivo Abilitato alla firma grafometrica.");
  			window.close();
  		}
		}
	}

	//installCertificate();

	function installCertificateEnd(response){
		if (response.success)
			alert("Dispositivo Abilitato");
		else
			alert("Qualcosa e' andato storto :/")
	}
	

function fixCaratteriSpeciali(test){
    
    test=replaceAll(test,"à", "a'");
    test=replaceAll(test,"è", "e'");
    test=replaceAll(test,"ì", "i'");
    test=replaceAll(test,"ò", "o'");
    test=replaceAll(test,"ù", "u'");
    
    test=replaceAll(test,"á", "a'");
    test=replaceAll(test,"é", "e'");
    test=replaceAll(test,"í", "i'");
    test=replaceAll(test,"ó", "o'");
    test=replaceAll(test,"ú", "u'");
    
    test=replaceAll(test,"À", "A'");
    test=replaceAll(test,"È", "E'");
    test=replaceAll(test,"Ì", "I'");
    test=replaceAll(test,"Ò", "O'");
    test=replaceAll(test,"Ù", "U'");
    
    test=replaceAll(test,"Á", "A'");
    test=replaceAll(test,"É", "E'");
    test=replaceAll(test,"í", "I'");
    test=replaceAll(test,"Ó", "O'");
    test=replaceAll(test,"Ú", "U'");
       
    test=replaceAll(test,"°", "gr.");
    
    test=replaceAll(test,"<", "-");
    test=replaceAll(test,">", "-");

    return test;
}

function popolaCampi(){
    var inputs, index;

inputs = document.getElementsByTagName('input');
for (index = 0; index < inputs.length; ++index) {
    if (inputs[index].type=='text')
        inputs[index].setAttribute("value", fixCaratteriSpeciali(inputs[index].value));
    else if (inputs[index].type=='time'){
        inputs[index].setAttribute("value", fixCaratteriSpeciali(inputs[index].value));
    }
    else if (inputs[index].type=='date'){
        if (inputs[index].value!=null && inputs[index].value!='') {
            inputs[index].setAttribute("value", inputs[index].value.substring(8,10)+"/"+inputs[index].value.substring(5,7)+"/"+inputs[index].value.substring(0,4));
        }
    }
    else if ((inputs[index].type=='radio' || inputs[index].type=='checkbox') && inputs[index].checked){
        inputs[index].setAttribute("type", "text");
        inputs[index].setAttribute("value", "[X]");
    }
    else if ((inputs[index].type=='radio' || inputs[index].type=='checkbox') && !inputs[index].checked){
        inputs[index].setAttribute("type", "text");
        inputs[index].setAttribute("value", "[ ]");
    }
}
}

function replaceAll(str, find, replace) {
      return str.replace(new RegExp(find, 'g'), replace);
}

function catturaHtml(form){
    popolaCampi();
    h=document.getElementById('codicehtml').innerHTML;
	document.getElementById("htmlcode").value = h;
	submitAjax();
}

function inviaform() {
    window.open('','popup','width=600,height=600');
    document.getElementById('formFN').submit();
}



function submitAjax()
{
	//creazione formdata + conversione in stringa (chiave=valore & chiave=valore...)
	var parametri = new URLSearchParams(new FormData(form1)).toString();

    var xmlHttp = new XMLHttpRequest();
	//apertura della connessione con parametro "true" (necessario per POST)
	xmlHttp.open("post", "GestioneDocumenti.do?command=GeneraPDF&returnTipo=json",true);
	//header necessario per il POST alla servlet
	xmlHttp.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
		//attesa della risposta
        xmlHttp.onreadystatechange = function()
        {	
			//elaborazione della risposta
            if(xmlHttp.readyState == 4 && xmlHttp.status == 200)
            {
				var obj = JSON.parse(xmlHttp.response);
				window.open("GestioneDocumenti.do?command=DownloadPDF&codDocumento=" + obj.codDocumento + "&titolo=" + obj.titolo, "_blank");
				document.getElementById("fileName").value = obj.titolo;
				inviaform();
            }
        }
	//invio dei parametri
    xmlHttp.send(parametri);	
}


</script>

<div id="codicehtml">
<html>
<title>VERBALE VERIFICA ISPETTIVA</title>

<link rel="stylesheet" type="text/css" media="screen" href="<%=request.getScheme() %>://<%=GISA_CONNESSIONE_HOST %>/gisarpac/moduli/css/screen.css" />
<link rel="stylesheet" type="text/css" media="print"  href="<%=request.getScheme() %>://<%=GISA_CONNESSIONE_HOST %>/gisarpac/moduli/css/print.css" />

<body>

<img src="http://<%=GISA_CONNESSIONE_HOST %>/gisarpac/moduli/img/arpac_ico.jpg" alt="..." width="100" height="125">

<center>
<h2>VERBALE DI CAMPIONAMENTO "TERRENO" N. <u><%= datiNumeroVerbale %></u> del <u><%= toDateasStringFromString(datiDataPrelievo) %></u></h2>
<h2 style="text-justify: inter-word;text-align: justify; line-height: 18px">Il presente verbale viene redatto in attuazione delle attivita' previste dal Decreto Interministeriale 11.03.2014 e dal Decreto Interministeriale 26.02.2016, per la valutazione tecnica della qualita' dei terreni agricoli.</h2>
</center>

<div style="/*text-justify: inter-word;text-align: justify; */line-height: 18px">
Il giorno <u><%= toDateasStringFromString(datiDataPrelievo) %></u> alle ore <u><%= datiOre %></u>  
il sottoscritto/i <u><%= gruppoTecnici.replaceAll(";"," ") %></u> dell'ARPAC, 
unitamente a: <u><%=datiVerbaleCarabinieriForestali %></u> dei Carabinieri Forestali 
e ai tecnici addetti al campionamento suolo <u><%=gruppoAddetti.replaceAll(";"," ") %></u> dell'ARPAC Multiservizi Srl,<br/>  
altri presenti <u><% if (!datiVerbaleAltriPartecipanti1.equals("")) { %> <%= datiVerbaleAltriPartecipanti1 %> in qualita' di <%=datiVerbaleQualitaAltriPartecipanti1%><%} %> <% if (!datiVerbaleAltriPartecipanti2.equals("")) { %>, <%= datiVerbaleAltriPartecipanti2 %> in qualita' di <%=datiVerbaleQualitaAltriPartecipanti2%><%} %> <% if (!datiVerbaleAltriPartecipanti3.equals("")) { %>, <%= datiVerbaleAltriPartecipanti3 %> in qualita' di <%=datiVerbaleQualitaAltriPartecipanti3%><%} %> </u>  <br/>
si sono recati presso il sito identificato con l'ID N. <u><%= anagraficaCodiceSito %></u>, Foglio N. <u><%= anagraficaFoglioCatastale %></u>, Particella N. <u><%= anagraficaParticellaCatastale %></u> ubicato nel comune di <u><%= anagraficaComune %></u> Provincia di <u><%= anagraficaProvincia %></u>,   

<%=!datiVerbaleProprietarioPresente ? "<s>" : "" %>di proprieta' del/i Sig/gg. <u><%=datiVerbaleProprietarioPresente ? datiVerbaleProprietario : ""%></u><%=!datiVerbaleProprietarioPresente ? "</s>" : "" %>, 
<%=datiVerbaleProprietarioPresente ? "<s>" : "" %>alla presenza di <u><%=!datiVerbaleProprietarioPresente ? datiVerbaleAltraPersonaPresente : "________________________" %></u>, in qualita' di <u><%=!datiVerbaleProprietarioPresente ? datiVerbaleQualitaAltraPersonaPresente : "________________________"%></u><%=datiVerbaleProprietarioPresente ? "</s>" : "" %>,  

<br/>

hanno prelevato, come da protocollo di campionamento approvato dal GdL di cui al D.M. del 23/12/2013 in data 14/05/2014, n. 1 campione di suolo per l'analisi dei VOC, n. <u><%=datiVerbaleNumCampioniElementari %></u> campioni "elementari" di suolo e  n. 1  campione medio composito di suolo, identificati come riportato nella sottostante tabella:
<br/>

<table class="innertable">
	<tr>
		<th class="innerth">Campione di suolo</th>
		<th class="innerth">Codice Identificativo</th>
		<th class="innerth">Coordinata_X</th>
		<th class="innerth">Coordinata_Y</th>
	</tr>
	<tr>
		<td class="innertd">Campione per VOC</td>
		<td class="innertd"><u><%=datiVerbaleCodiceIdentificativoVoc %></u></td>
		<td class="innertd"><u><%=datiVerbaleCoordinataXVoc %></td>
		<td class="innertd"><u><%=datiVerbaleCoordinataYVoc %></td>
	</tr>
	
	<% if (datiVerbaleNumCampioniElementari>0){ %>
	<tr>
		<td class="innertd">Campione Elementare</td>
		<td class="innertd"><u><%=datiVerbaleCodiceIdentificativo1 %></u></td>
		<td class="innertd"><u><%=datiVerbaleCoordinataX1 %></td>
		<td class="innertd"><u><%=datiVerbaleCoordinataY1 %></td>
	</tr>
	<%} %>
	<% if (datiVerbaleNumCampioniElementari>1){ %>
	<tr>
		<td class="innertd">Campione Elementare</td>
		<td class="innertd"><u><%=datiVerbaleCodiceIdentificativo2 %></u></td>
		<td class="innertd"><u><%=datiVerbaleCoordinataX2 %></td>
		<td class="innertd"><u><%=datiVerbaleCoordinataY2 %></td>
	</tr>
	<%} %>
	<% if (datiVerbaleNumCampioniElementari>2){ %>
	<tr>
		<td class="innertd">Campione Elementare</td>
		<td class="innertd"><u><%=datiVerbaleCodiceIdentificativo3 %></u></td>
		<td class="innertd"><u><%=datiVerbaleCoordinataX3 %></td>
		<td class="innertd"><u><%=datiVerbaleCoordinataY3 %></td>
	</tr>
	<%} %>
	<% if (datiVerbaleNumCampioniElementari>3){ %>
	<tr>
		<td class="innertd">Campione Elementare</td>
		<td class="innertd"><u><%=datiVerbaleCodiceIdentificativo4 %></u></td>
		<td class="innertd"><u><%=datiVerbaleCoordinataX4 %></td>
		<td class="innertd"><u><%=datiVerbaleCoordinataY4 %></td>
	</tr>
	<%} %>
	<% if (datiVerbaleNumCampioniElementari>4){ %>
	<tr>
		<td class="innertd">Campione Elementare</td>
		<td class="innertd"><u><%=datiVerbaleCodiceIdentificativo5 %></u></td>
		<td class="innertd"><u><%=datiVerbaleCoordinataX5 %></td>
		<td class="innertd"><u><%=datiVerbaleCoordinataY5 %></td>
	</tr>
	<%} %>
	<tr align="center">
		<td class="innertd">Campione Medio Composito</td>
		<td class="innertd"><u><%=datiVerbaleCodiceIdentificativoMedioComposito %></u></td>
		<td colspan="2" bgcolor="#e0e0e0"> --------------------------------------------------------------------------- </td>
	</tr>
</table>

<div style="/*text-justify: inter-word;text-align: justify; */line-height: 18px">
Nel "punto centrale" della particella catastale, previo scortico dei primi 10 cm di terreno, viene prelevato il terreno destinato all'analisi dei VOC, in due 

<% if (datiVerbaleAliquotaA){ %><b><u>aliquote a</u></b> <%} else {%><s><b><u>aliquote a</u></b></s><%} %> 
<% if (datiVerbaleAliquotaBG){ %> e <b><u>b</u></b> <%} else {%><s>e <b><u>b</u></b></s><%} %>, <br/>

ciascuna  posta in un barattolo di vetro da 500 ml riempito fino all'orlo e chiuso immediatamente. <br/>
La prima aliquota viene inviata all'U.O.C. Siti Contaminati e Bonifiche dell'ARPAC, sita in Via Antiniana n. 55 - Pozzuoli (NA) per le successive analisi e/o per il successivo smistamento presso i laboratori ISPRA e/o altre ARPA e/o UNINA, mentre la seconda viene consegnata alla parte presente sul posto.<br/>
Da ciascuno dei <u><%=datiVerbaleNumCampioniElementari %></u> "campioni elementari" di suolo, sottoposti a vaglio con maglia da 2 cm., viene prelevata, in un unico esemplare, un'aliquota pari a ¼ circa del peso, riposta in una busta di PE, per eventuali successivi accertamenti e trasportata al laboratorio ARPAC - U.O.C. Siti Contaminati e Bonifiche dell'ARPAC, sita in Via Antiniana n. 55 - Pozzuoli (NA), unitamente al presente verbale, per la conservazione/smistamento.<br/>
Il campione "medio composito" di suolo, ottenuto a seguito delle operazioni di omogenizzazione e quartatura delle restanti parti dei cinque campioni elementari, e' stato suddiviso nelle seguenti aliquote/contenitori:<br/>

<% if (datiVerbaleAliquotaC){ %><input type="checkbox" checked disabled/> <b><u>aliquota c</u></b> <%} else {%><input type="checkbox" disabled/> <s><b><u>aliquota c</u></b></s><%} %> 
e 
<% if (datiVerbaleAliquotaD){ %><input type="checkbox" checked disabled/> <b><u>aliquota d</u></b> <%} else {%><input type="checkbox" disabled/> <s><b><u>aliquota d</u></b></s><%} %> 
, costituitite da barattoli di vetro scuro (o chiaro avvolto in carta opaca), rispettivamente per la ricerca di diossine/PCB e di Fenoli/IPA/Metalli, Di-2-Etilesilftalato, collocate in un a busta (tipo alimente), sono inviate all'U.O.C. Siti Contaminati e Bonifiche dell'ARPAC per le successive analisi.<br/>

<% if (datiVerbaleAliquotaCD_fitofarmaci){ %><input type="checkbox" checked disabled/> <%} else {%><input type="checkbox" disabled/><%} %> <b>Per l'aliquota in oggetto, si richiede anche la ricerca dei Fitofarmaci;</b><br/>

<% if (datiVerbaleAliquotaE){ %><input type="checkbox" checked disabled/> <b><u>aliquota e</u></b>, dal peso di ca. 1 Kg, viene posta in busta di polietilene per la ricerca dei parametri agronomici ed inviata all'Universita' degli Studi di Napoli "Federico II" - Dipartimento di Agraria - Sezione Agronomia - Via Universita' 100, 80055 Portici; <%} else {%><input type="checkbox" disabled/> <s><b><u>aliquota e</u></b>, dal peso di ca. 1 Kg, viene posta in busta di polietilene per la ricerca dei parametri agronomici ed inviata all'Universita' degli Studi di Napoli "Federico II" - Dipartimento di Agraria - Sezione Agronomia - Via Universita' 100, 80055 Portici;</s><%} %><br/>

<% if (datiVerbaleAliquotaF){ %><input type="checkbox" checked disabled/> <b><u>aliquota f</u></b>, posta in barattolo di vetro scuro di ca. 1 L (o chiaro avvolto in carta opaca), a disposizione dell'Autorita' Giudiziaria, viene inviata all'U.O.C. Siti Contaminati e Bonifiche dell'ARPAC; <%} else {%><input type="checkbox" disabled/> <s><b><u>aliquota f</u></b>, posta in barattolo di vetro scuro di ca. 1 L (o chiaro avvolto in carta opaca), a disposizione dell'Autorita' Giudiziaria, viene inviata all'U.O.C. Siti Contaminati e Bonifiche dell'ARPAC;</s><%} %><br/>

<% if (datiVerbaleAliquotaBG){ %><input type="checkbox" checked disabled/> <b><u>aliquota g</u></b>, posta in barattolo di vetro scuro di ca. 1 L, da consegnare alla controparte; <%} else {%><input type="checkbox" disabled/> <s><b><u>aliquota g</u></b>, posta in barattolo di vetro scuro di ca. 1 L, da consegnare alla controparte;</s><%} %><br/>

<% if (datiVerbaleAliquotaH){ %><input type="checkbox" checked disabled/> <b><u>aliquota h</u></b>, posta in barattolo di vetro scuro di ca. 1 L (o chiaro avvolto in carta opaca), come campione di riserva, viene inviata all'U.O.C. Siti Contaminati e Bonifiche dell'ARPAC per la custodia o per l'eventuale smistamento presso i laboratori dell'ISPRA e/o altre ARPA. <%} else {%><input type="checkbox" disabled/> <s><b><u>aliquota h</u></b>, posta in barattolo di vetro scuro di ca. 1 L (o chiaro avvolto in carta opaca), come campione di riserva, viene inviata all'U.O.C. Siti Contaminati e Bonifiche dell'ARPAC per la custodia o per l'eventuale smistamento presso i laboratori dell'ISPRA e/o altre ARPA.</s><%} %><br/>

<% if (datiVerbaleAliquotaI){ %><input type="checkbox" checked disabled/> <b><u>aliquota i</u></b>, posta in barattolo di vetro scuro di ca. 1 L, da consegnare al laboratorio Regionale Amianto di ARPAC, presso il Dipartimento di Salerno, per il tramite dell'U.O.C. Siti Contaminati e Bonifiche per la ricerca di amianto; <%} else {%><input type="checkbox" disabled/> <s><b><u>aliquota i</u></b>, posta in barattolo di vetro scuro di ca. 1 L, da consegnare al laboratorio Regionale Amianto di ARPAC, presso il Dipartimento di Salerno, per il tramite dell'U.O.C. Siti Contaminati e Bonifiche per la ricerca di amianto;</s><%} %><br/>

<b>Vengono, inoltre, prelevate le seguenti aliquote;</b><br/>

<% if (datiVerbaleAliquotaLM){ %><input type="checkbox" checked disabled/> <b><u>aliquota l e m</u></b>, poste in buste per alimenti, del peso di ca 500 g ciascuna, per la ricerca dei parametri microbiologici. Tali buste sono inviate all'Universita' degli Studi  di Napoli "Federico II" - Dipartimento di Agraria - Sezione Microbiologia - Via Universita' 100, 80055 Portici; <%} else {%><input type="checkbox" disabled/> <s><b><u>aliquota l e m</u></b>, poste in buste per alimenti, del peso di ca 500 g ciascuna, per la ricerca dei parametri microbiologici. Tali buste sono inviate all'Universita' degli Studi  di Napoli "Federico II" - Dipartimento di Agraria - Sezione Microbiologia - Via Universita' 100, 80055 Portici;</s><%} %><br/>

<% if (datiVerbaleAliquotaN){ %><input type="checkbox" checked disabled/> <b><u>aliquota n</u></b>, poste in buste per alimenti, del peso di ca 500 g ciascuna, per la ricerca dei parametri microbiologici, da consegnare alla controparte. <%} else {%><input type="checkbox" disabled/> <s><b><u>aliquota n</u></b>, poste in buste per alimenti, del peso di ca 500 g ciascuna, per la ricerca dei parametri microbiologici, da consegnare alla controparte.</s><%} %><br/>

Ai fini di soddisfare i diritti alla difesa, il Sig. <u><%= datiVerbaleProprietarioPresente ? datiVerbaleProprietario : datiVerbaleAltraPersonaPresente %></u> e' avvertito che ha la facolta', anche attraverso persona di sua fiducia appositamente designata, di presenziare, eventualmente con l'assistenza di un consulente tecnico, all'apertura e successive analisi, relativamente alle aliquote campioni distinte con le lettere  
<b>
<% if (datiVerbaleAliquotaA){ %>a<%} else { %><s>a</s><%} %>, 
<% if (datiVerbaleAliquotaC){ %>c<%} else { %><s>c</s><%} %>, 
<% if (datiVerbaleAliquotaD){ %>d<%} else { %><s>d</s><%} %>, 
<% if (datiVerbaleAliquotaI){ %>i<%} else { %><s>i</s><%} %>, 
<% if (datiVerbaleAliquotaLM){ %>l<%} else { %><s>l</s><%} %> 
ed 
<% if (datiVerbaleAliquotaLM){ %>m<%} else { %><s>m</s><%} %> 
</b>
 
di cui al presente verbale. In particolare:<br/>

<% if (datiVerbaleAliquotaA){ %>
<input type="checkbox" checked disabled /> 
l'apertura dell'aliquota <b>a</b> dei campioni di terreno avverra' il giorno <u><%=datiVerbaleAliquotaA_data %></u> alle ore <u><%=datiVerbaleAliquotaA_ora %></u> presso l'U.O.C. Siti Contaminati e Bonifiche dell'ARPAC sita in via Antiniana N  55, cap 80078 Pozzuoli (NA), recapito tel. 081/2301968;
<%} else { %>
<input type="checkbox" disabled /> 
<s>l'apertura dell'aliquota <b>a</b> dei campioni di terreno avverra' il giorno <u>_____________</u> alle ore <u>___________</u> presso l'U.O.C. Siti Contaminati e Bonifiche dell'ARPAC sita in via Antiniana N  55, cap 80078 Pozzuoli (NA), recapito tel. 081/2301968;</s>
<%} %>
<br/>

<% if (datiVerbaleAliquotaC){ %>
<input type="checkbox" checked disabled /> 
l'apertura dell'aliquota <b>c</b> dei campioni di terreno avverra' il giorno <u><%=datiVerbaleAliquotaC_data %></u> alle ore <u><%=datiVerbaleAliquotaC_ora %></u> presso l'U.O.C. Siti Contaminati e Bonifiche dell'ARPAC sita in via Antiniana N  55, cap 80078 Pozzuoli (NA), recapito tel. 081/2301968;
<%} else { %>
<input type="checkbox" disabled /> 
<s>l'apertura dell'aliquota <b>c</b> dei campioni di terreno avverra' il giorno <u>_____________</u> alle ore <u>___________</u> presso l'U.O.C. Siti Contaminati e Bonifiche dell'ARPAC sita in via Antiniana N  55, cap 80078 Pozzuoli (NA), recapito tel. 081/2301968;</s>
<%} %>
<br/>

<% if (datiVerbaleAliquotaD){ %>
<input type="checkbox" checked disabled /> 
l'apertura dell'aliquota <b>d</b> dei campioni di terreno avverra' il giorno <u><%=datiVerbaleAliquotaD_data %></u> alle ore <u><%=datiVerbaleAliquotaD_ora %></u> presso l'U.O.C. Siti Contaminati e Bonifiche dell'ARPAC sita in via Antiniana N  55, cap 80078 Pozzuoli (NA), recapito tel. 081/2301968;
<%} else { %>
<input type="checkbox" disabled /> 
<s>l'apertura dell'aliquota <b>d</b> dei campioni di terreno avverra' il giorno <u>_____________</u> alle ore <u>___________</u> presso l'U.O.C. Siti Contaminati e Bonifiche dell'ARPAC sita in via Antiniana N  55, cap 80078 Pozzuoli (NA), recapito tel. 081/2301968;</s>
<%} %>
<br/>

<% if (datiVerbaleAliquotaI){ %>
<input type="checkbox" checked disabled /> 
l'apertura dell'aliquota <b>i</b> per la Ricerca di Amianto verra' effettuata il giorno <u><%=datiVerbaleAliquotaI_data %></u> alle ore <u><%=datiVerbaleAliquotaI_ora %></u> presso il Dipartimento Provinciale ARPAC di Salerno sito in via Lanzalone 54/56 cap 84100 Salerno, recapito tel. 089/2758001.
<%} else { %>
<input type="checkbox" disabled /> 
<s>l'apertura dell'aliquota <b>i</b> per la Ricerca di Amianto verra' effettuata il giorno <u>_____________</u> alle ore <u>_____________</u> presso il Dipartimento Provinciale ARPAC di Salerno sito in via Lanzalone 54/56 cap 84100 Salerno, recapito tel. 089/2758001.</s>
<%} %>
<br/>

<% if (datiVerbaleAliquotaLM){ %>
<input type="checkbox" checked disabled /> 
l'apertura delle aliquote <b>l</b> ed <b>m</b> dei campioni di terreno avverra' il giorno <u><%=datiVerbaleAliquotaLM_data %></u> alle ore <u><%=datiVerbaleAliquotaLM_ora %></u> presso l'Universita' degli Studi  di Napoli "Federico II" - Dipartimento di Agraria - Sezione Microbiologia - Via Universita' 100, 80055 Portici recapito tel 081/2539145.
<%} else { %>
<input type="checkbox" disabled /> 
<s>l'apertura delle aliquote <b>l</b> ed <b>m</b> dei campioni di terreno avverra' il giorno <u>_____________</u> alle ore <u>_____________</u> presso l'Universita' degli Studi  di Napoli "Federico II" - Dipartimento di Agraria - Sezione Microbiologia - Via Universita' 100, 80055 Portici recapito tel 081/2539145.</s>
<%} %>
<br/>

Il Sig. <u><%= datiVerbaleProprietarioPresente ? datiVerbaleProprietario : datiVerbaleAltraPersonaPresente %></u> e'informato che, atteso che la determinazione degli altri parametri viene effettuata anche da Laboratori fuori regione, il diritto alla difesa e' garantito dalla conservazione di un campione di riserva custodito presso il laboratorio preposto.<br/>  
In caso di difformita' degli esiti analitici per uno o piu' parametri, il laboratorio preposto ne' dara' comunicazione all'interessato, il quale potra' richiedere la revisione delle analisi, ai sensi dell'art. 223 del D.L.vo n 271/89.<br/>
Il presente verbale e' redatto in n <u><input type="text" style="width:60px"/></u> (<u><input type="text"/></u>) copie di cui una viene rilasciata,<br/>  

<% if (datiVerbaleAliquotaBG){ %> unitamente all'<b>aliquota b</b> (per i VOC) e all'<b>aliquota g</b><%} else { %> <s> unitamente all'<b>aliquota b</b> (per i VOC) e all'<b>aliquota g</b></s> <%} %>,<br/>   

al Sig. <u><%= datiVerbaleProprietarioPresente ? datiVerbaleProprietario : datiVerbaleAltraPersonaPresente %></u> che ha  firmato previa integrale lettura  e chiede di inserire le seguenti dichiarazioni:<br/>
<u><%=datiVerbaleDichiarazioni %></u><br/>

<% if (datiVerbaleAliquotaN){ %> <input type="checkbox" checked disabled/> Viene inoltre consegnata alla controparte anche l'<b>aliquota n</b> (microbiologici).<%} else { %> <input type="checkbox" disabled/> <s>Viene inoltre consegnata alla controparte anche l'<b>aliquota n</b> (microbiologici).</s> <% } %><br/>

Le altre <u><input type="text" style="width:60px"/></u> copie del presente verbale vengono rilasciate a: <u><input type="text"/></u>. <br/>
Si e' proceduto alla decontaminazione/pulizia delle attrezzature utilizzate tra un campione elementare ed un altro.<br/>
Strumentazione utillizzata: 
<u><%=datiVerbaleStrumentazione %></u>.<br/>

<b>Informazioni Aggiuntive:</b><br/>
<u>Coltivazioni Presenti</u><br/>
La particella si presenta:<br/>
<input type="checkbox" <%=datiVerbaleTipoColturaCodice.equals("C") ? "checked" : "" %> disabled/>Con coltura in atto 
<input type="checkbox" <%=datiVerbaleTipoColturaCodice.equals("A") ? "checked" : "" %> disabled/>Arata 
<input type="checkbox" <%=datiVerbaleTipoColturaCodice.equals("I") ? "checked" : "" %> disabled/>Incolta con erba spontanea 
<input type="checkbox" <%=datiVerbaleTipoColturaCodice.equals("NC") ? "checked" : "" %> disabled/>Non coltivabile 
<br/>

Tipo/i di coltura/e rinvenute, descrizione dello stato di crescita e varie: <br/>
<u><%= datiVerbaleTipoColturaCodice.equals("C") ? datiVerbaleTipoColturaNote : datiVerbaleTipoColturaCodice.equals("NC") ? datiVerbaleTipoColturaMotivazione : ""%></u><br/>
Sono state effettuate n. <u><input type="text" style="width:60px"/></u> foto rappresentative delle colture presenti, che verranno tempestivamente trasmesse, in data odierna, a mezzo e-mail all'indirizzo [<u>suoloerifiuti@arpacampania.it</u>], per il seguito di competenza.<br/>

<u>Presenza di rifiuti:</u><br/>
<input type="checkbox" <%=datiVerbalePresenzaRifiuti.equals("S") ? "checked" : "" %> disabled/>SI 
<input type="checkbox" <%=datiVerbalePresenzaRifiuti.equals("N") ? "checked" : "" %> disabled/>NO 
<input type="checkbox" <%=datiVerbalePresenzaRifiuti.equals("P") ? "checked" : "" %> disabled/>Parzialmente  
<br/> 
Descrizione:
<u><%=datiVerbalePresenzaRifiutiNote %> <%=datiVerbalePresenzaRifiutiDescrizione %></u><br/>

<u>Irrigazione</u><br/>
Da informazioni acquisite 
<%if (datiVerbaleIrrigazioneInLoco) { %>in loco<%} else { %><s>in loco</s><%} %>
/
<%if (!datiVerbaleIrrigazioneInLoco) { %>dal Sig. <%= datiVerbaleIrrigazioneInformazioni %>  <%} else { %><s>dal Sig. _____________________</s><%} %><br/>
si rappresenta che l'acqua utilizzata per l'irrigazione del terreno oggi indagato deriva da (fiume, canale, rete idrica, altro, specificare) 
<u><%=datiVerbaleIrrigazioneDerivazione %></u>.
<br/>

<% if (datiVerbalePozzoCampionamento){ %><input type="checkbox" checked disabled/> Si e' quindi proceduto al campionamento delle acque sotterranee prelevate nel pozzo presente nella proprieta', cosi' come da verbale <u><%=datiVerbalePozzoCampionamentoVerbaleNumero %></u> del <u><%=datiVerbalePozzoCampionamentoVerbaleData %></u>.<%} else { %><input type="checkbox" disabled/> <s>Si e' quindi proceduto al campionamento delle acque sotterranee prelevate nel pozzo presente nella proprieta', cosi' come da verbale <u>________________</u> del <u>______________</u>.</s><%} %>
<br/>
 
<b>Note aggiuntive:</b>
<br/>
<u><%=datiVerbaleNoteAggiuntive %></u>.
<br/>

E' stato effettuato un report fotografico disponibile presso ARPAC.<br/>
Copia del presente verbale viene rilasciata ai Carabinieri Forestali ed alla parte convenuta.<br/>
LCS, alle ore: <u><input type="time"/></u>.
<br/>

<div align="center">
<br><input type="button" value="INVIA" class="bottone" onclick="style.display = 'none';swapType();catturaHtml(this.form)">
<br><br>
<br/>
</div>
<h2 align="center">LA PARTE &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp IL VERBALIZZANTE</h2><br><br><br>

</div>
</div>
</body>

</html>
</div>


<div style="display:none">
<form id="form1" action="" method="post" name="form1"  target="_blank">
<table>
<tr><td>Applicativo di provenienza</td> <td><input type="text" readonly name="app_name" id="app_name" class="formVal" value="gisa_nt" /></td></tr>
<tr><td>Id Utente</td> <td><input type="text" readonly name="idUtente" id="idUtente" class="formVal" value="6567" /></td></tr>
<tr><td>Ip Utente</td> <td><input type="text" readonly name="ipUtente" id="ipUtente" class="formVal" value="0.0.0.0" /></td></tr>
<tr><td>Tipo certificato</td> <td><input type="text" readonly name="tipo" id="tipo" class="formVal" value="VerbaleCampionamentoSuolo" /></td></tr>
<tr><td>Tipo timbro</td> <td><input type="text" readonly name="tipoTimbro" id="tipoTimbro" class="formVal" value="GISA" /></td></tr>
<tr><td>stabId</td> <td><input type="text" readonly name="stabId" id="stabId" class="formVal" value="-1" /></td></tr>
<tr><td>idGiornataIspettiva</td> <td><input type="text" readonly name="idGiornataIspettiva" id="idGiornataIspettiva" class="formVal" value="-1" /></td></tr>
<tr><td>Fixa Html</td> <td><input type="text" name="fixaHtml" id="fixaHtml" class="formVal" value="si" /></td></tr>
<tr><td>Sorgente HTML</td> <td> <input type="text" name="htmlcode" class="formVal" id="htmlcode" > <br/></td></tr>
</table>

</form>

</div>
<div style="display:none">
<form id="formFN" action="/gisarpac/moduli/firmaPDF.jsp" method="post" name="formFN" target="popup">
<input type="text" name="fileName" id="fileName" value="">

<input type="hidden" name="idUtente" id="idUtente" value="6567"/>
<input type="hidden" name="tipoCertificato" id="tipoCertificato" value="VerbaleCampionamentoSuolo_SIGNED"/>
<input type="hidden" name="stabId" id="stabId" class="formVal" value="-1"/>
<input type="hidden" readonly name="idGiornataIspettiva" id="idGiornataIspettiva" class="formVal" value="-1" />
<input type="hidden" readonly name="idCampione" id="idCampione" class="formVal" value="<%=idCampione%>" />


<input type="text" name="tipoVerbale" id="tipoVerbale" value="VerbaleCampionamentoSuolo" />
<input type="text" name="oggetto" id="oggetto" value="AllegatoVerbaleCampionamentoSuolo" />

</form>
</div>
		
