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

System.out.println(json.toString());

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
            	console.log(xmlHttp.response)
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
<div align="center">
	<form id="modulo" action="" method="POST" target="_blank">
	<table class="innertable">
			<tr>
				<td class="testa innertd"><img src="http://<%=GISA_CONNESSIONE_HOST %>/gisarpac/moduli/img/arpac_ico.jpg" alt="..." width="100" height="125">
					<div class="boxIdDocumento"></div>
					<div class="boxOrigineDocumento"><%@ include file="../../../hostName.jsp" %></div>
				</td>
				<td class="testa innertd" align="center"><h1>Verbale di Sopralluogo e Campionamento</h1></td>
				<td class="testa innertd" align="right">Doc. n: <u><input type = "text" value = "1" id = "ndoc" size="1" maxlenght="9"></u></td>
			</tr>
	</table>
	<h3> AREA TERRITORIALE - U.O. SUOLO, RIFIUTI E SITI CONTAMINATI <br>
		VERBALE DI ASSISTENZA AI PRELIEVI E RITIRO N. <u><input type="text" id="nver"></u><br>
		D. Lgs. 152/2006 - Parte IV Titolo V<br>
	</h3>
	SITO <u><input type="text" id="sito" size="50"></u> - Sigla campione <u><input type="text" id="sigc" size="10"></u> <br>
	<div style="text-align: justify">
		Il giorno <u><input type="date" id="dver" j_obj="Dati" j_attr="dataInizio"></u> alle ore <u><input type="time" id="over"></u> i sottostritti C.T.P. dott. <u><input type="text" id="ctp"></u>
		e A.T. <u><input type="text" id="at"></u>, tecnici del Dipartimento ARPAC di <u><input type="text" id="dipa1" ></u>, nell'ambito dell'ispezione AIA ordinaria iniziata in data
		<u><input type="date" id="dini"></u>, si sono recati in <u><input type="text" id="luogo" size="50"></u> presso lo stabilimento della soc. <u><input type="text" id="soc"></u>, alla presenza di <u><input type="text" id="presente"></u>, in qualita' di <u><input type="text" id="qualifica"></u>,,
		altri presenti <u><input type="text"/></u> ed hanno effettuato le operazioni di prelievo di un campione di acqua sotterranea
		dal piezometro/pozzo identificato con la sigla <u><input type="text" id="sigp1"></u> e avente coordinate UTM WGS 84: Nord<u><input type="text" id="coon" size="35"></u> - Est <u><input type="text" id="cooe" size="35"></u>.<br>
		<strong>Attivita' svolte:</strong><br>
		<u>PRELIEVO PIEZOMETRI/POZZI</u>: e' stato individuato il piezometro identificato con sigla <u><input type="text" id="sigp2"></u>, collocato a <u><input type="radio" name ="collocato" id="rad1">monte<input type="radio" name ="collocato" id="rad2">valle idrogeologica</u> rispetto alla direzione del flusso della falda idrica sotterranea.<br>
		Si e' proceduto allo spurgo del piezometro/pozzo secondo le procedure previste dal protocollo tecnico adottato dall'ARPAC.<br>
		Preliminarmente all'operazione di spurgo e di campionamento, e' stata effettuata la misura della soggiacenza della falda freatica secondo le procedure previste dal protocollo tecnico.<br>
		Dopo le operazioni descritte, e' stato effettuato il prelievo di n. 1 campione di acqua dalla falda idrica sotterranea, il cui livello statico e' di <u><input type="text" id="mtr"></u> metri dal bocca pozzo / piano campagna.<br>
		Il piezometro/pozzo ha una profondita' di <u><input type="text" id="prof"></u> metri (valore misurato / dichiarato dal presente all'ispezione).<br>
		Lo spurgo e' avvenuto alle ore <u><input type="time" id="hspu"></u>.<br>
		La portata di spurgo e' pari a <u><input type="text" id="limi1"></u> l/min. La portata di campionamento e' pari a <u><input type="text" id="limi2"></u> l/min.<br>
		La descrizione dettagliata delle modalita' di campionamento e' riportata nel protocollo di attivita' adottato dall'ARPAC per i siti contaminati.<br><br>
		Il campione e' stato prelevato in n. 1 aliquota costituita dei seguenti contenitori:
		<ul>
		<strong>
			<li>N. 2 vials vetro della capacita' di 40ml;</li>
			<li>N. 1 contenitore in plastica della capacita' di 50 ml.</li>
		</strong>
		</ul>
		L'aliquota viene posta ognuna in una busta di polietilene, sugellata ed identificata dal numero <u><input type="text" id="nbus"></u> ed indicante la data del prelievo, il numero del presente verbale, la ragione sociale della ditta, le firme dei verbalizzanti e delle persone presenti a tutte le operazioni effettuate.<br>
		Un aliquota viene consegnata al dott. <u><input type="text" id="alid"></u>, per le determinazioni analitiche di parte.<br>
		Un aliquota sara' consegnata al Dipartimento Provinciale ARPAC <u><input type="text" id="dipa2"></u>, per l'accettazione sara' successivamente trasferita all'U.O.C. Siti Contaminati e Bonifiche, per le determinazioni analitiche.<br>
		I parametri da determinare sul campione sono i seguenti:<br>
		<strong>alifatici clorurati cancerogeni, alifatici clorurati non cancerogeni, alifatici alogenati cancerogeni, metalli.</strong><br>
		L'aliquota viene posta in cassette refrigerate per la consegna ai laboratori secondo le prescrizioni riportate nel protocollo di attivita' dell'ARPAC per i siti contaminati.
		<br>
		Il presente verbale viene chiuso alle ore <u><input type="time" id="chiuso"></u>.
	</div>
	<br><input type="button" value="INVIA" class="bottone" onclick="style.display = 'none';catturaHtml(this.form)">
	<br><br>
	<br>
	</form>
		<h3 align="center">DITTA &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp I VERBALIZZANTI</h3>
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
<tr><td>Tipo certificato</td> <td><input type="text" readonly name="tipo" id="tipo" class="formVal" value="VerbaleAS" /></td></tr>
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
<input type="hidden" name="tipoCertificato" id="tipoCertificato" value="VerbaleAS_SIGNED"/>
<input type="hidden" name="stabId" id="stabId" class="formVal" value="<%=idAnagrafica %>"/>
<input type="hidden" readonly name="idGiornataIspettiva" id="idGiornataIspettiva" class="formVal" value="-1" />
<input type="hidden" readonly name="idCampione" id="idCampione" class="formVal" value="<%= idCampione %>" />


<input type="text" name="tipoVerbale" id="tipoVerbale" value="VerbaleAS" />
<input type="text" name="oggetto" id="oggetto" value="AllegatoVerbaleAS" />

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


}

%>
