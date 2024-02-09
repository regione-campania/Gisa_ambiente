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

<% String dataInizio = (String)request.getAttribute("dataInizio"); %>
<% String id_sito = (String)request.getAttribute("id_sito"); %>
<% String classe_rischio = (String)request.getAttribute("classe_rischio"); %>
<% String comune = (String)request.getAttribute("comune"); %>
<% String foglio = (String)request.getAttribute("foglio"); %>
<% String particella = (String)request.getAttribute("particella"); %>
<% String parte = (String)request.getAttribute("parte"); %>
<% String area = (String)request.getAttribute("area"); %>
<% String stato_sito = (String)request.getAttribute("stato_sito"); %>
<% String decreto_approvazione = (String)request.getAttribute("decreto_approvazione"); %>
<% String gruppoIspettivo = (String)request.getAttribute("gruppoIspettivo"); %>

<script src="https://code.jquery.com/jquery-1.8.2.js"></script>
<script src="https://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
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
<div align="center">
<h2>VERBALE DI MANCATO CAMPIONAMENTO "TERRENO" N. <u><input type="text" value="1" id="nver" size="1"></u> del <u><%= dataInizio %></u></h2>
<h2 style="text-justify: inter-word;text-align: justify;">Il presente verbale viene redatto in attuazione delle attivita' previste dal Decreto Interministeriale 11.03.2014 e dal Decreto Interministeriale 26.02.2016, per la valutazione tecnica della qualita' dei terreni agricoli.</h2>
<div style="text-justify: inter-word;text-align: justify;">
Il giorno <u><%= dataInizio %></u> alle ore <u><input type="time"/></u> il/i sottoscritto/i <u><%= gruppoIspettivo.replaceAll(";"," ") %></u> tecnico <br>
afferente alla <u><input type="text" placeholder="[Ricavato dalla Giornata Ispettiva]"/></u> // <u><input type="text" placeholder="[Ricavato dalla Giornata Ispettiva]"/></u> // <u><input type="text" placeholder="[Ricavato dalla Giornata Ispettiva]"/></u> dell'ARPAC, unitamente<br>
a: <u><input type="text"/></u> dei Carabinieri Forestali e ai tecnici addetti al campionamento suolo <u><input type="text"/></u><br>
dell'ARPAC Multiservizi Srl, altri presenti <u><input type="text"/></u>,<br>
si sono recati presso il sito identificato con l'ID N. <u><%= id_sito %></u>, Foglio N. <b><%= foglio %></b>, N. <u><%= particella %></u> Particelle <br>
_____________________________________________________ ubicati nel comune di <b><%= comune %></b> Provincia di <b><input type="text" placeholder="[Ricavato dal Comune]"/></b>, di proprieta'<br>
del/i Sig/gg. <u><input type="text"/></u>,<br>
alla presenza di <u><input type="text"/></u>, in qualita' di <u><input type="text"/></u>, rappresenta che, <b>NON SI E' PROCEDUTO AL CAMPIONAMENTO</b>per i seguenti motivi:<b>_________________________________<br>
____________________________________________________________________________________________________________________________________________________________<br>
</b>

<div style="text-justify: inter-word;text-align: justify;">
Il presente verbale e' redatto in n <u><input type="text"/></u> (<u><input type="text"/></u>) copie di cui una viene rilasciata, al Sig. <u><input type="text"/></u> che ha  firmato previa integrale lettura  e chiede di inserire le seguenti dichiarazioni:<br>
<u><textarea class="long"></textarea></u><br>
E'stato effettuato un report fotografico disponibile presso ARPAC.<br>
Copia del presente verbale viene rilasciata ai Carabinieri Forestali ed alla parte convenuta.
L.C.S., alle ore: <u><input type="text"/></u>.<br>
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
<tr><td>Tipo certificato</td> <td><input type="text" readonly name="tipo" id="tipo" class="formVal" value="VerbaleA6" /></td></tr>
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
<input type="hidden" name="tipoCertificato" id="tipoCertificato" value="VerbaleA6_SIGNED"/>
<input type="hidden" name="stabId" id="stabId" class="formVal" value="-1"/>
<input type="hidden" readonly name="idGiornataIspettiva" id="idGiornataIspettiva" class="formVal" value="-1" />
<input type="hidden" readonly name="idCampione" id="idCampione" class="formVal" value="-1" />


<input type="text" name="tipoVerbale" id="tipoVerbale" value="VerbaleA6" />
<input type="text" name="oggetto" id="oggetto" value="AllegatoVerbaleA6" />

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