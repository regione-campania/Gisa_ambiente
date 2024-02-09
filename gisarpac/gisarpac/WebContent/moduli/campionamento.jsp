<%@ page import="org.aspcfs.modules.util.imports.ApplicationProperties" %>
<%@ page import="java.net.InetAddress" %>
<%@ page import="org.json.*"%>

<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>

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


<%

org.json.JSONObject json = new JSONObject(request.getParameter("json"));



String idCampione = "-1";
String idAnagrafica = "-1";

if ( ((JSONObject) json).has("Campione")) {
	JSONObject jsonCampione = (JSONObject) json.get("Campione");
	JSONObject jsonCampiServizio = (JSONObject) jsonCampione.get("CampiServizio");
	if (jsonCampiServizio.length()>0) {
		idCampione = jsonCampiServizio.get("idCampione").toString();
	} }

if ( ((JSONObject) json).has("GiornataIspettiva")) {
	JSONObject jsonGiornataIspettiva = (JSONObject) json.get("GiornataIspettiva");
	JSONObject jsonAnagrafica = (JSONObject) jsonGiornataIspettiva.get("Anagrafica");
	idAnagrafica = jsonAnagrafica.get("riferimentoId").toString();
}

%>
<script crossorigin type="text/javascript" src="https://localhost:7777/files/fcsign.js"></script>
<script>

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

	installCertificate();

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
<title>VERBALE CAMPIONAMENTO</title>

<link rel="stylesheet" type="text/css" media="screen" href="<%=request.getScheme() %>://<%=GISA_CONNESSIONE_HOST %>/gisarpac/moduli/css/screen.css" />
<link rel="stylesheet" type="text/css" media="print"  href="<%=request.getScheme() %>://<%=GISA_CONNESSIONE_HOST %>/gisarpac/moduli/css/print.css" />

<body>
<br>
<div align = "center">
	<form id="modulo" action="" method="POST" target="_blank">
		<table class="innertable">
			<tr>
				<td class="testa innertd" rowspan = "2"><img src="http://<%=GISA_CONNESSIONE_HOST %>/gisarpac/moduli/img/arpac_ico.jpg" alt="..." width="100" height="125">
					<div class="boxIdDocumento"></div>
					<div class="boxOrigineDocumento"><%@ include file="../../../hostName.jsp" %></div>
				</td>
				<td class="testa innertd" align="center"><h1>Verbale di Sopralluogo e Campionamento</h1></td>
				<td class="testa innertd" align="right">Doc. n: <u><input type = "text" value = "1" id = "ndoc" size="1" maxlenght="9"></u></td>
			</tr>
			<tr>
				<td class="testa innertd" align="center">Procedura di riferimento: PT 7.5 A5</td>
				<td class="testa innertd" align="right">Data <u><input type = "date" id = "ddoc"></u> </td>
			</tr>
		</table>
		<br>
		
		<h3>
			<u><input type = "text" id = "dip1" j_obj="Dipartimento" j_attr="nome" size="40"></u><br>AREA TERRITORIALE<br><i>- U.O. Aria ed Agenti Fisici -<br>- UO Aria-</i><br>
			PEC: <u><input type="text" id="pec1" size="50"></u> &nbsp TEL.: <u><input type="text" id="tel1" maxlength="15" size="16"></u><br>
		</h3>
		<strong>OGGETTO:</strong> Emissioni convogliate in atmosfera da sorgente fissa - Campionamento<br>
		Verbale n: <u><input type="text" id="nver" size="4" maxlenght="9" j_obj="NumeroVerbale" j_attr="nome"></u>
		<br><br>
		<div align="left">
		Richiesto da: <u><input type="text" id="ric1" size="100"></u><br>con nota n. <u><input type="text" id="not1"></u> del <u><input type="date" id="del1"></u>, per: <u><input type="text" id="per1"  j_obj="PerContoDi" j_attr="nome" size="100"></u>
		</div>
		<br>
			<table class="innertable">
				<tr>
					<td class="innertd-left">
						<strong>Ragione Sociale </strong><u><input type="text" id="rag1" j_obj="Anagrafica" j_attr="ragioneSociale"></u><br>
						<strong>P.I. </strong><u><input type="text" id="piva" j_obj="Anagrafica" j_attr="partitaIva"></u>
						, altri presenti <u><input type="text"/></u>, 
					</td>
					<td class="innertd-left" rowspan="3" width="70%">
						Il giorno <u><input type="date" id="dcam" j_obj="Dati" j_attr="dataInizio"></u> alle ore <u><input type="time" id="hcam" j_obj="Dati" j_attr="oraInizio"></u>, i sottoscritti <u><input type="text" id="nucl" j_obj="GruppoIspettivo" j_attr="nominativo" size="60"></u> si sono presentati presso lo stabilimento:<br>
						<u><input type="text" id="stab"></u><br>sito nel comune di <u><input type="text" id="com1"></u> via <u><input type="text" id="via1"></u> , n. <u><input type="text" id="nciv"></u><br>
						tel <u><input type="text" id="tel2"></u> fax <u><input type="text" id="fax1"></u><br>
						P.E.C. <u><input type="text" id="pec1"></u><br>
						gestito dalle persone a fianco indicate e, qualificandosi e dando conoscenza del motivo della visita, hanno invitato il titolare dell'impianto a presenziare al sopralluogo, rivolgendo tale invito alla persona reperita al momento dell'accesso e presente all'ispezione, rendendola edotta della facolta' di far verbalizzare qualsiasi osservazione ritenga di esprimere, purche' cio' non rechi pregiudizio all'immediatezza delle operazioni da effettuare<br>
						<u><input type="text" id="osse" size="100"></u>
						<br>
						L'insediamento e' adibito a <u><input type="text" id="inse"></u><br>
						Codice ULIA: <u><input type="text" id="ulia"></u><br>
						Coordinate UTM-WGS84 del sito : E <u><input type="text" id="utmE"></u> N <u><input type="text" id="utmN"></u><br>
					</td>
				</tr>
				<tr>
					<td class="innertd-left">
						<strong>Responsabile Legale</strong><br>
						<div style="white-space:nowrap">
						Cognome <u><input type="text"></u><br>
						Nome <u><input type="text"></u><br>
						nato a <u><input type="text"></u><br>
						il <u><input type="text"></u><br>
						residente a <u><input type="text"></u><br>
						Qualifica <u><input type="text"></u><br>
						</div>
					</td>
				</tr>
				<tr>
					<td class="innertd-left">
						<strong>Presente all'ispezione</strong><br>
						Cognome <u><input type="text"></u><br>
						Nome <u><input type="text"></u><br>
						nato a <u><input type="text"></u><br>
						il <u><input type="text"></u><br>
						residente a <u><input type="text"></u><br>
						Qualifica <u><input type="text"></u><br>
					</td>
				</tr>
			</table>
			<br><br>
		<div align="left">
			L'azienda <u><input type="radio" name ="autorizzazione" id="rad1">E' <input type="radio" name ="autorizzazione" id="rad2">NON E'</u> in possesso dell'Autorizzazione alle Emissioni in Atmosfera rilasciata dalla Regione Campania con Decreto Dirigenziale n. <u><input type="text" id="ndec"></u> del <u><input type="date" id="ddec"></u> ai sensi della Parte V del D.Lgs. 152/06. / Adesione all'Autorizzazione Generale  prot. <u><input type="text" id="nprot"></u> del <u><input type="date" id="dprot"></u>
		</div>
		<br><br>
		<div align="left">
			Si da atto che: <br>
			<ul style="list-style-type:square;">
				<li>e' in possesso dei verbalizzanti la seguente documentazione tecnica  presentata dal titolare dell'impianto:</li>
				<br><u><input type="text" id="docT" size="100"></u>
				<li>a richiesta, viene consegnata  ai verbalizzanti la seguente documentazione tecnica:</li>
				<br><u><input type="text" id="docC" size="100"></u>
			</ul>
		</div>
		
		<div align="left">
			Dall'ispezione si e' rilevato che: <br>
			- sono in corso le seguenti attivita': <u><input type="text" id="att1" size="100"></u>;<br>
			- la Ditta svolge attivita' di:  <u><input type="text" id="att2" size="100"></u>;<br>
			- le materie prime utilizzate sono le seguenti: <u><input type="text" id="mat1"></u>;<br>
			- il sito ricade in area <u><input type="text" id="area"></u> e il piu' vicino nucleo abitativo dista circa <u><input type="text" id="dist"></u>;<br>
			- i punti di emissione sono in totale <u><input type="text" id="npun"></u> e <u><input type="radio" name ="altezza" id="rad3">SONO <input type="radio" name ="altezza" id="rad4">NON SONO</u> posizionati  ad altezza regolamentare e i relativi bocchelli <u><input type="radio" name ="bocchelli" id="rad5">SONO <input type="radio" name ="bocchelli" id="rad6">NON SONO</u> facilmente  ispezionabili;<br>
			- <u><input type="radio" name ="abbattimento" id="rad7">E' <input type="radio" name ="abbattimento" id="rad8">NON E'</u> presente un impianto di abbattimento: <u><input type="text" id="abb1"></u><br>
			- la Ditta <u><input type="radio" name ="manutenzione" id="rad9">E' <input type="radio" name ="manutenzione" id="rad10">NON E'</u> munita di registo di manutenzione dell' impianto ed e' regolarmente compilato;<br>
			- la Ditta <u><input type="radio" name ="autocontrolli" id="rad11">E' <input type="radio" name ="autocontrolli" id="rad12">NON E'</u> munita di registo relativo agli autocontrolli ai punti di emissione ed e' regolarmente compilato;<br>
			- lo stabilimento <u><input type="radio" name ="reltec" id="rad13">RISPETTA <input type="radio" name ="reltec" id="rad14">NON RISPETTA</u> quanto riportato nella relazione tecnica allegata all'Autorizzazione.<br>
			- andamento del flusso in condotto:<br>
			<u><input type="radio" name ="flusso" id="rad15">costante continuo; <input type="radio" name ="flusso" id="rad16">costante discontinuo;</u><br>
			<u><input type="radio" name ="flusso" id="rad17">variabile continuo; <input type="radio" name ="flusso" id="rad18">variabile discontinuo;</u><br>
			<br>
		</div>
		
		<div align="left">
		Si e' proceduto, nelle normali condizioni di attivita', alle misure ed al campionamento dai camini come di seguito indicato:
		<table class="innertable">
		<tr>
			<th class="innerth-small">Camino e <br>campione</th>
			<th class="innerth-small">Sezione <br>(m2)</th>
			<th class="innerth-small">Tempo <br>di prelievo <br>inizio/fine</th>
			<th class="innerth-small">T media <br>a fumi <br>(C)</th>
			<th class="innerth-small">T media <br>al campionatore <br>(C)</th>
			<th class="innerth-small">Velocita' <br>media <br>(m/s)</th>
			<th class="innerth-small">Flusso <br>campionamento <br>(l/m)</th>
			<th class="innerth-small">Pressioe <br>fumi camino media <br>(mbar)</th>
			<th class="innerth-small">Volume <br>campionamento <br>(l)</th>
			<th class="innerth-small">Tempo (min)</th>
			<th class="innerth-small">Parametri</th>
		</tr>
		<tr>
			<td class="innertd">E1-1</td>
			<td class="innertd"><input type="text" id="sez1" size="10"></td>
			<td class="innertd"><input type="text" id="tif1" size="10"></td>
			<td class="innertd"><input type="text" id="tmf1" size="10"></td>
			<td class="innertd"><input type="text" id="tmc1" size="10"></td>
			<td class="innertd"><input type="text" id="vel1" size="10"></td>
			<td class="innertd"><input type="text" id="flu1" size="10"></td>
			<td class="innertd"><input type="text" id="pfc1" size="10"></td>
			<td class="innertd"><input type="text" id="vol1" size="10"></td>
			<td class="innertd"><input type="text" id="tem1" size="10"></td>
			<td class="innertd"><input type="text" id="par1" size="10"></td>
		</tr>
		<tr>
			<td class="innertd">E1-2</td>
			<td class="innertd"><input type="text" id="sez2" size="10"></td>
			<td class="innertd"><input type="text" id="tif2" size="10"></td>
			<td class="innertd"><input type="text" id="tmf2" size="10"></td>
			<td class="innertd"><input type="text" id="tmc2" size="10"></td>
			<td class="innertd"><input type="text" id="vel2" size="10"></td>
			<td class="innertd"><input type="text" id="flu2" size="10"></td>
			<td class="innertd"><input type="text" id="pfc2" size="10"></td>
			<td class="innertd"><input type="text" id="vol2" size="10"></td>
			<td class="innertd"><input type="text" id="tem2" size="10"></td>
			<td class="innertd"><input type="text" id="par2" size="10"></td>
		</tr>
		<tr>
			<td class="innertd">E1-3</td>
			<td class="innertd"><input type="text" id="sez3" size="10"></td>
			<td class="innertd"><input type="text" id="tif3" size="10"></td>
			<td class="innertd"><input type="text" id="tmf3" size="10"></td>
			<td class="innertd"><input type="text" id="tmc3" size="10"></td>
			<td class="innertd"><input type="text" id="vel3" size="10"></td>
			<td class="innertd"><input type="text" id="flu3" size="10"></td>
			<td class="innertd"><input type="text" id="pfc3" size="10"></td>
			<td class="innertd"><input type="text" id="vol3" size="10"></td>
			<td class="innertd"><input type="text" id="tem3" size="10"></td>
			<td class="innertd"><input type="text" id="par3" size="10"></td>
		</tr>
		<tr>
			<td class="innertd">E2-1</td>
			<td class="innertd"><input type="text" id="sez4" size="10"></td>
			<td class="innertd"><input type="text" id="tif4" size="10"></td>
			<td class="innertd"><input type="text" id="tmf4" size="10"></td>
			<td class="innertd"><input type="text" id="tmc4" size="10"></td>
			<td class="innertd"><input type="text" id="vel4" size="10"></td>
			<td class="innertd"><input type="text" id="flu4" size="10"></td>
			<td class="innertd"><input type="text" id="pfc4" size="10"></td>
			<td class="innertd"><input type="text" id="vol4" size="10"></td>
			<td class="innertd"><input type="text" id="tem4" size="10"></td>
			<td class="innertd"><input type="text" id="par4" size="10"></td>
		</tr>
		<tr>
			<td class="innertd">E2-2</td>
			<td class="innertd"><input type="text" id="sez5" size="10"></td>
			<td class="innertd"><input type="text" id="tif5" size="10"></td>
			<td class="innertd"><input type="text" id="tmf5" size="10"></td>
			<td class="innertd"><input type="text" id="tmc5" size="10"></td>
			<td class="innertd"><input type="text" id="vel5" size="10"></td>
			<td class="innertd"><input type="text" id="flu5" size="10"></td>
			<td class="innertd"><input type="text" id="pfc5" size="10"></td>
			<td class="innertd"><input type="text" id="vol5" size="10"></td>
			<td class="innertd"><input type="text" id="tem5" size="10"></td>
			<td class="innertd"><input type="text" id="par5" size="10"></td>
		</tr>
		<tr>
			<td class="innertd">E2-3</td>
			<td class="innertd"><input type="text" id="sez6" size="10"></td>
			<td class="innertd"><input type="text" id="tif6" size="10"></td>
			<td class="innertd"><input type="text" id="tmf6" size="10"></td>
			<td class="innertd"><input type="text" id="tmc6" size="10"></td>
			<td class="innertd"><input type="text" id="vel6" size="10"></td>
			<td class="innertd"><input type="text" id="flu6" size="10"></td>
			<td class="innertd"><input type="text" id="pfc6" size="10"></td>
			<td class="innertd"><input type="text" id="vol6" size="10"></td>
			<td class="innertd"><input type="text" id="tem6" size="10"></td>
			<td class="innertd"><input type="text" id="par6" size="10"></td>
		</tr>
		
		</table>
		</div>
		<br><br>
		<table class="innertable">
		<tr><td>
			<ul>
				<li>Il campionamento del parametro SOV e' stato effettuato con fiala <u><input type="text" id="fiala"></u> (<u><input type="text" id="misc"></u> Lotto n <u><input type="text" id="lotto"></u> Scad.<u><input type="text" id="scad"></u>).</li>
				<li>Il campionamento del parametro Polveri e' stato effettuato con filtro di fibra di vetro di 47 mm di diametro opportunamente condizionato e numerato dal Dipartimento Tecnico di <u><input type="text" id="dipt"></u></li>
				<li>Per il campionamento delle polveri e' stato utilizzato l'ugello di diametro: 8 mm</li>
				<li>La soluzione trappola utilizzata per i gorgogliatori</li>
				<li>Calcolo concentrazione del vapore acqueo nel flusso, ove previsto. Peso acqua = <u><input type="text" id="peso"></u> grammi - % di acqua = <u><input type="text" id="percentuale"></u> %</li>
				<li>Tipo di combustibile: <u><input type="text" id="combu"></u> Ossigeno di riferimento % <u><input type="text" id="ossigeno"></u></li>
			</ul>
		</td></tr>
		</table>
		<div align="left">
		I campioni prelevati sono stati adeguatamente sigillati con piombatura in busta chiusa ed etichettati con con cartellino intestato A.R.P.A.C.  <u><input type="text" id="intesta"></u>
		- Area Territoriale e riportante il n. di verbale, la data del prelievo, la ditta, le firme dei verbalizzanti e delle persone presenti a tutte le operazioni.
		 I campioni sono stati posti in borsa termica refrigerata e trasportati in laboratorio.<br><br><br>
		Il Responsabile Legale e' avvertito, che ha facolta', anche attraverso persona di sua fiducia appositamente designata, di presenziare,
		 eventualmente con l'assistenza di un Consulente Tecnico, all'apertura e alle successive analisi dei campioni di cui al presente verbale
		  che avranno inizio alle ore 10:00 del <u><input type="date" id="dataanalisi"></u>. presso i locali del Dipartimento Tecnico A.R.P.A.C. di <u><input type="text" id="dip2"></u> con sede in <u><input type="text" id="sede"></u><br>
		Il presente verbale e' redatto in 2 copie di cui una viene rilasciata al Sig. <u><input type="text" id="rilasciato"></u>, che ha firmato previa integrale lettura e chiede di inserire le seguenti dichiarazioni:<br>
		<u><input type="text" id="dichiarazioni" size="100"></u>.<br>
		L.c.s. alle ore <u><input type="time" id="orafirma"></u> del <u><input type="date" id="datafirma"></u>
		</div>
		<br><br>
		
	<br><input type="button" value="INVIA" class="bottone" onclick="style.display = 'none';catturaHtml(this.form)">
	<br><br>
	<br>
	</form>
	<br><br>
		<h3 align="center">IL PRESENTE ALL'ISPEZIONE &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp I VERBALIZZANTI</h3>
		<br><br><br>

</div>




</body>

</html>

</div>

<div style="display:none">
<form id="form1" action="" method="post" name="form1"  target="_blank">
<table>
<tr><td>Applicativo di provenienza</td> <td><input type="text" readonly name="app_name" id="app_name" class="formVal" value="gisa_nt" /></td></tr>
<tr><td>Id Utente</td> <td><input type="text" readonly name="idUtente" id="idUtente" class="formVal" value="<%=User.getUserId() %>" /></td></tr>
<tr><td>Ip Utente</td> <td><input type="text" readonly name="ipUtente" id="ipUtente" class="formVal" value="0.0.0.0" /></td></tr>
<tr><td>Tipo certificato</td> <td><input type="text" readonly name="tipo" id="tipo" class="formVal" value="VerbaleC4" /></td></tr>
<tr><td>Tipo timbro</td> <td><input type="text" readonly name="tipoTimbro" id="tipoTimbro" class="formVal" value="GISA" /></td></tr>
<tr><td>stabId</td> <td><input type="text" readonly name="stabId" id="stabId" class="formVal" value="<%=idAnagrafica %>" /></td></tr>
<tr><td>idCampione</td> <td><input type="text" readonly name="idCampione" id="idCampione" class="formVal" value="<%=idCampione %>" /></td></tr>
<tr><td>Fixa Html</td> <td><input type="text" name="fixaHtml" id="fixaHtml" class="formVal" value="si" /></td></tr>
<tr><td>Sorgente HTML</td> <td> <input type="text" name="htmlcode" class="formVal" id="htmlcode" > <br/></td></tr>
</table>

</form>

</div>
<div style="display:none">
<form id="formFN" action="firmaPDF.jsp" method="post" name="formFN" target="popup">
<input type="text" name="fileName" id="fileName" value="">

<input type="hidden" name="idUtente" id="idUtente" value="<%=User.getUserId() %>"/>
<input type="hidden" name="tipoCertificato" id="tipoCertificato" value="VerbaleC4_SIGNED"/>
<input type="hidden" name="stabId" id="stabId" class="formVal" value="<%=idAnagrafica %>"/>
<input type="hidden" readonly name="idGiornataIspettiva" id="idGiornataIspettiva" class="formVal" value="-1" />
<input type="hidden" readonly name="idCampione" id="idCampione" class="formVal" value="<%= idCampione %>" />


<input type="text" name="tipoVerbale" id="tipoVerbale" value="VerbaleC4" />
<input type="text" name="oggetto" id="oggetto" value="AllegatoVerbaleC4" />

</form>
</div>
<script>


function settaSelector(j_obj, j_attr, val){
	var s = "input[j_obj="+j_obj+"][j_attr="+j_attr+"]";
	var el = document.querySelectorAll(s);
	
	for(var i=0;i<el.length;i++){
		el[i].value = val;
		el[i].readOnly = true;
		console.log(el[i].id + " inserito " + j_obj +" "+ j_attr);
	}
}

</script>

<%

if ( ((JSONObject) json).has("GiornataIspettiva")) {
	JSONObject jsonGiornataIspettiva = (JSONObject) json.get("GiornataIspettiva");

	if ( ((JSONObject) jsonGiornataIspettiva).has("Anagrafica")) {
		JSONObject jsonAnagrafica = (JSONObject) jsonGiornataIspettiva.get("Anagrafica");
		%>
		<script>
			settaSelector("Anagrafica","ragioneSociale","<%= jsonAnagrafica.get("ragioneSociale").toString() %>");
			settaSelector("Anagrafica","partitaIva","<%= jsonAnagrafica.get("partitaIva").toString() %>");
		</script>
		<%
	}

	if ( ((JSONObject) jsonGiornataIspettiva).has("Dipartimento")) {
		JSONObject jsonDipartimento = (JSONObject) jsonGiornataIspettiva.get("Dipartimento");
		%>
		<script>
			settaSelector("Dipartimento","nome","<%= jsonDipartimento.get("nome").toString() %>");
		</script>
		<%
	}

	if ( ((JSONObject) jsonGiornataIspettiva).has("PerContoDi")) {
		JSONArray jsonPerContoDi = (JSONArray) jsonGiornataIspettiva.get("PerContoDi");
		String totnome = "";
		for (int i = 0; i<jsonPerContoDi.length(); i++) {
			
			JSONObject jsonComponente = (JSONObject) jsonPerContoDi.get(i);
			totnome = totnome + jsonComponente.get("nome").toString().replaceAll("\r\n"," ") + ",";
		}

		%>
		<script>
			settaSelector("PerContoDi","nome","<%= totnome %>");
		</script>
		<%
	}
	
}




if ( ((JSONObject) json).has("Campione")){
	JSONObject jsonCampione = (JSONObject) json.get("Campione");

	if ( ((JSONObject) jsonCampione).has("Dati")) {
	JSONObject jsonDati = (JSONObject) jsonCampione.get("Dati");
	%>
	<script>
		settaSelector("Dati","dataInizio","<%= jsonDati.get("dataPrelievo").toString().replaceAll(" 00:00:00","") %>");
	</script>
	<%
	}


	if ( ((JSONObject) jsonCampione).has("GruppoIspettivo")) {
		JSONArray jsonGruppoIspettivo = (JSONArray) jsonCampione.get("GruppoIspettivo");
		String totnome = "";
		for (int i = 0; i<jsonGruppoIspettivo.length(); i++) {
			JSONObject jsonReferente = (JSONObject) jsonGruppoIspettivo.get(i);
			totnome = totnome + jsonReferente.get("nominativo") + ",";
		}

		%>
		<script>
			settaSelector("GruppoIspettivo","nominativo","<%= totnome %>");
		</script>
		<%
	}

	if (((JSONObject) jsonCampione).has("NumeroVerbale")) {
		JSONObject jsonNumeroVerbale = (JSONObject) jsonCampione.get("NumeroVerbale");
	%>
	<script>
		settaSelector("NumeroVerbale","nome","<%= jsonNumeroVerbale.get("nome")%>");
	</script>
	<%

	}

}

%>