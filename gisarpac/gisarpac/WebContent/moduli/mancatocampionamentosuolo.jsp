<%@ page import="org.json.*"%>
<%@ page import="java.util.ArrayList"%>

<%@ page import="org.aspcfs.modules.util.imports.ApplicationProperties" %>
<%@ page import="java.net.InetAddress" %>

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


ArrayList<String> codiciSito = new ArrayList<String>();

String anagraficaIdArea = "";
String anagraficaComune = "";
String anagraficaProvincia = "";

if (((JSONObject) json).has("Anagrafica")){
	JSONObject jsonAnagrafica = (JSONObject) json.get("Anagrafica");
		anagraficaIdArea = jsonAnagrafica.get("riferimentoId").toString();
		anagraficaComune = jsonAnagrafica.get("comune").toString();
		anagraficaProvincia = jsonAnagrafica.get("provincia").toString();
	}	

if (((JSONObject) json).has("Subparticelle")){
	JSONArray jsonSubparticelle = (JSONArray) json.get("Subparticelle");
	for (int i = 0; i<jsonSubparticelle.length(); i++) {
		JSONObject jsonSubparticella = (JSONObject) jsonSubparticelle.get(i);
		codiciSito.add(jsonSubparticella.get("codiceSito").toString());
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
    
    test=replaceAll(test,"�", "a'");
    test=replaceAll(test,"�", "e'");
    test=replaceAll(test,"�", "i'");
    test=replaceAll(test,"�", "o'");
    test=replaceAll(test,"�", "u'");
    
    test=replaceAll(test,"�", "a'");
    test=replaceAll(test,"�", "e'");
    test=replaceAll(test,"�", "i'");
    test=replaceAll(test,"�", "o'");
    test=replaceAll(test,"�", "u'");
    
    test=replaceAll(test,"�", "A'");
    test=replaceAll(test,"�", "E'");
    test=replaceAll(test,"�", "I'");
    test=replaceAll(test,"�", "O'");
    test=replaceAll(test,"�", "U'");
    
    test=replaceAll(test,"�", "A'");
    test=replaceAll(test,"�", "E'");
    test=replaceAll(test,"�", "I'");
    test=replaceAll(test,"�", "O'");
    test=replaceAll(test,"�", "U'");
       
    test=replaceAll(test,"�", "gr.");
    
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
<div align="center">
<h2>VERBALE DI MANCATO CAMPIONAMENTO "TERRENO" N. <u><input type="text" id="nver" size="1"></u> del <u><input type="date"/></u></h2>
<h2 style="text-justify: inter-word;text-align: justify;">Il presente verbale viene redatto in attuazione delle attivita' previste dal Decreto Interministeriale 11.03.2014 e dal Decreto Interministeriale 26.02.2016, per la valutazione tecnica della qualita' dei terreni agricoli.</h2>
<div style="text-justify: inter-word;text-align: justify;">

Il giorno <b><input type="date"/></b> alle ore <u><input type="time"/></u> 
il/i sottoscritto/i <b><input type="text"/></b> tecnico afferente alla <u><input type="text"/></u> dell'ARPAC, unitamente a: <u><input type="text"/></u> dei Carabinieri Forestali 
e ai tecnici addetti al campionamento suolo <u><input type="text"/></u> dell'ARPAC Multiservizi Srl, altri presenti <u><textarea class="long"></textarea></u>, 
si sono recati presso i siti identificati con l'ID N. <br/> 

<%for (int i = 0; i<codiciSito.size(); i++) { %>
<input type="checkbox"/> <%=codiciSito.get(i)%> 
<%} %>
<br/>

del Foglio N. <b><input type="text"/></b> Particelle <b><input type="text"/></b> ubicati nel comune di <b><%=anagraficaComune %></b> Provincia di <b><%=anagraficaProvincia %></b>, 
di proprieta' del/i Sig/gg. <u><input type="text"/></u>, alla presenza di <u><input type="text"/></u>, in qualita' di <u><input type="text"/></u>, 
rappresenta che, <b>NON SI E' PROCEDUTO AL CAMPIONAMENTO</b> per i seguenti motivi: <b><textarea class="long"></textarea></b>

<div style="text-justify: inter-word;text-align: justify;">
Il presente verbale e' redatto in n <u><input type="text"/></u> (<u><input type="text"/></u>) copie di cui una viene rilasciata, al Sig. <u><input type="text"/></u> 
che ha firmato previa integrale lettura e chiede di inserire le seguenti dichiarazioni:
<u><textarea class="long"></textarea></u><br>

E' stato effettuato un report fotografico disponibile presso ARPAC.<br>
Copia del presente verbale viene rilasciata ai Carabinieri Forestali ed alla parte convenuta.
L.C.S., alle ore: <u><input type="time"/></u>.

<br/>
	<div align="center">
	<br><input type="button" value="INVIA" class="bottone" onclick="style.display = 'none';swapType();catturaHtml(this.form)">
	<br><br>
	<br>
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
<tr><td>Tipo certificato</td> <td><input type="text" readonly name="tipo" id="tipo" class="formVal" value="VerbaleMancatoCampionamentoSuolo" /></td></tr>
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
<input type="hidden" name="tipoCertificato" id="tipoCertificato" value="VerbaleMancatoCampionamentoSuolo_SIGNED"/>
<input type="hidden" name="stabId" id="stabId" class="formVal" value="-1"/>
<input type="hidden" readonly name="idGiornataIspettiva" id="idGiornataIspettiva" class="formVal" value="-1" />
<input type="hidden" readonly name="idCampione" id="idCampione" class="formVal" value="-1" />
<input type="hidden" readonly name="idArea" id="idArea" class="formVal" value="<%=anagraficaIdArea%>" />


<input type="text" name="tipoVerbale" id="tipoVerbale" value="VerbaleMancatoCampionamentoSuolo" />
<input type="text" name="oggetto" id="oggetto" value="AllegatoVerbaleMancatoCampionamentoSuolo" />

</form>
</div>
		
<%-- <%= dataInizio %><br> --%>
<%-- <%= id_sito %><br> --%>
<%-- <%= classe_rischio %><br> --%>
<%-- <%= comune %><br> --%>
<%-- <%= foglio %><br> --%>
<%-- <%= particella %><br> --%>
<%-- <%= parte %><br> --%>
<%-- <%= area %><br> --%>
<%-- <%= stato_sito %><br> --%>
<%-- <%= decreto_approvazione %><br> --%>
<%-- <%= gruppoIspettivo %><br> --%>