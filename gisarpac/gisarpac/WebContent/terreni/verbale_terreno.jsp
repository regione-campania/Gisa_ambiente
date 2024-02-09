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
<h2>VERBALE DI CAMPIONAMENTO "TERRENO" N. <u><input type="text" value="1" id="nver" size="1"></u> del <u><%= dataInizio %></u></h2>
<h2 style="text-justify: inter-word;text-align: justify;">Il presente verbale viene redatto in attuazione delle attivita' previste dal Decreto Interministeriale 11.03.2014 e dal Decreto Interministeriale 26.02.2016, per la valutazione tecnica della qualita' dei terreni agricoli.</h2>
<div style="text-justify: inter-word;text-align: justify;">
Il giorno <u><%= dataInizio %></u> alle ore <u><input type="time"/></u> il sottoscritto/i <u><%= gruppoIspettivo.replaceAll(";"," ") %></u> tecnico/i della<br>
Direzione Tecnica/del Dipartimento Provinciale di <u><input type="text" placeholder="[Ricavato dalla Giornata Ispettiva]"/></u> // <u><input type="text" placeholder="[Ricavato dalla Giornata Ispettiva]"/></u> // <u><input type="text" placeholder="[Ricavato dalla Giornata Ispettiva]"/></u> dell'ARPAC, unitamente<br>
a: <u><input type="text"/></u> dei Carabinieri Forestali e ai tecnici addetti al campionamento suolo <u><input type="text"/></u><br>
dell'ARPAC Multiservizi Srl, altri presenti <u><input type="text"/></u>,<br>
si sono recati presso il sito identificato con l'ID N. <u><%= id_sito %></u>, Foglio N. <u><%= foglio %></u>, Particella N. <u><%= particella %></u> ubicato nel comune di <u><%= comune %></u> Provincia di <u><input type="text" placeholder="[Ricavato dal Comune]"/></u>, di proprieta'<br>
del/i Sig/gg. <u><input type="text"/></u>,<br>
alla presenza di <u><input type="text"/></u>, in qualita' di <u><input type="text"/></u>, hanno prelevato, come da protocollo di campionamento approvato dal GdL di cui al D.M. del 23/12/2013 in data 14/05/2014, n. 1 campione di suolo per l'analisi dei VOC, n. <u><input type="text"/></u> campioni "elementari" di suolo e  n. 1  campione medio composito di suolo, identificati come riportato nella sottostante tabella:<br>
</div>
<table class="innertable">
	<tr>
		<th class="innerth">Campione di suolo</th>
		<th class="innerth">Codice Identificativo</th>
		<th class="innerth">Coordinata_X</th>
		<th class="innerth">Coordinata_Y</th>
	</tr>
	<tr>
		<td class="innertd">Campione per VOC</td>
		<td class="innertd"><u><input type="text"/></u></td>
		<td class="innertd"><u><input type="text"/></u></td>
		<td class="innertd"><u><input type="text"/></u></td>
	</tr>
	<tr>
		<td class="innertd">Campione Elementare</td>
		<td class="innertd"><u><input type="text"/></u></td>
		<td class="innertd"><u><input type="text"/></u></td>
		<td class="innertd"><u><input type="text"/></u></td>
	</tr>
	<tr>
		<td class="innertd">Campione Elementare</td>
		<td class="innertd"><u><input type="text"/></u></td>
		<td class="innertd"><u><input type="text"/></u></td>
		<td class="innertd"><u><input type="text"/></u></td>
	</tr>
	<tr>
		<td class="innertd">Campione Elementare</td>
		<td class="innertd"><u><input type="text"/></u></td>
		<td class="innertd"><u><input type="text"/></u></td>
		<td class="innertd"><u><input type="text"/></u></td>
	</tr>
	<tr>
		<td class="innertd">Campione Elementare</td>
		<td class="innertd"><u><input type="text"/></u></td>
		<td class="innertd"><u><input type="text"/></u></td>
		<td class="innertd"><u><input type="text"/></u></td>
	</tr>
	<tr>
		<td class="innertd">Campione Elementare</td>
		<td class="innertd"><u><input type="text"/></u></td>
		<td class="innertd"><u><input type="text"/></u></td>
		<td class="innertd"><u><input type="text"/></u></td>
	</tr>
	<tr align="center">
		<td class="innertd">Campione Medio Composito</td>
		<td class="innertd"><u><input type="text"/></u></td>
		<td colspan="2" bgcolor="#e0e0e0"> --------------------------------------------------------------------------- </td>
	</tr>
</table>
<div style="text-justify: inter-word;text-align: justify;">
Nel "punto centrale" della particella catastale, previo scortico dei primi 10 cm di terreno, viene prelevato il terreno destinato all'analisi dei VOC, in due <u><b>aliquote a</b> e <b>b</b></u>, ciascuna  posta in un barattolo di vetro da 500 ml riempito fino all'orlo e chiuso immediatamente. 
La prima aliquota viene inviata all'U.O.C. Siti Contaminati e Bonifiche dell'ARPAC, sita in Via Antiniana n. 55 - Pozzuoli (NA) per le successive analisi e/o per il successivo smistamento presso i laboratori ISPRA e/o altre ARPA e/o UNINA, mentre la seconda viene consegnata alla parte presente sul posto.<br>
Da ciascuno dei <u><input type="text"/></u> "campioni elementari" di suolo, sottoposti a vaglio con maglia da 2 cm., viene prelevata, in un unico esemplare, un'aliquota pari a ¼ circa del peso, riposta in una busta di PE, per eventuali successivi accertamenti e trasportata al laboratorio ARPAC - U.O.C. Siti Contaminati e Bonifiche dell'ARPAC, sita in Via Antiniana n. 55 - Pozzuoli (NA), unitamente al presente verbale, per la conservazione/smistamento.<br>
Il campione "medio composito" di suolo, ottenuto a seguito delle operazioni di omogenizzazione e quartatura delle restanti parti dei cinque campioni elementari, e' stato suddiviso nelle seguenti aliquote/contenitori:<br>
<input type="checkbox" /> <b><u>aliquota c</u></b> e <b><u>aliquota d</u></b>, costituitite da barattoli di vetro scuro (o chiaro avvolto in carta opaca), rispettivamente per la ricerca di diossine/PCB e di Fenoli/IPA/Metalli, Di-2-Etilesilftalato, collocate in un a busta (tipo alimente), sono inviate all'U.O.C. Siti Contaminati e Bonifiche dell'ARPAC per le successive analisi.<br>
<input type="checkbox" /> <b>Per l'aliquota in oggetto, si richiede anche la ricerca dei Fitofarmaci;</b><br>
&nbsp<input type="checkbox" /> <b><u>aliquota e</u></b>, dal peso di ca. 1 Kg, viene posta in busta di polietilene per la ricerca dei parametri agronomici ed inviata all'Universita' degli Studi di Napoli "Federico II" - Dipartimento di Agraria - Sezione Agronomia - Via Universita' 100, 80055 Portici; 
&nbsp<input type="checkbox" /> <b><u>aliquota f</u></b>, posta in barattolo di vetro scuro di ca. 1 L (o chiaro avvolto in carta opaca), a disposizione dell'Autorita' Giudiziaria, viene inviata all'U.O.C. Siti Contaminati e Bonifiche dell'ARPAC;<br>
&nbsp<input type="checkbox" /> <b><u>aliquota g</u></b>, posta in barattolo di vetro scuro di ca. 1 L, da consegnare alla controparte;<br>
&nbsp<input type="checkbox" /> <b><u>aliquota h</u></b>, posta in barattolo di vetro scuro di ca. 1 L (o chiaro avvolto in carta opaca), come campione di riserva, viene inviata all'U.O.C. Siti Contaminati e Bonifiche dell'ARPAC per la custodia o per l'eventuale smistamento presso i laboratori dell'ISPRA e/o altre ARPA.<br>
&nbsp<input type="checkbox" /> <b><u>aliquota i</u></b>, posta in barattolo di vetro scuro di ca. 1 L, da consegnare al laboratorio Regionale Amianto di ARPAC, presso il Dipartimento di Salerno, per il tramite dell'U.O.C. Siti Contaminati e Bonifiche per la ricerca di amianto;<br>
<input type="checkbox" /> <b>Vengono, inoltre, prelevate le seguenti aliquote;</b><br>
&nbsp<input type="checkbox" /> <b><u>aliquota l ed m</u></b>, poste in buste per alimenti, del peso di ca 500 g ciascuna, per la ricerca dei parametri microbiologici. Tali buste sono inviate all'Universita' degli Studi  di Napoli "Federico II" - Dipartimento di Agraria - Sezione Microbiologia - Via Universita' 100, 80055 Portici;<br>
&nbsp<input type="checkbox" /> <b><u>aliquota n</u></b>, poste in buste per alimenti, del peso di ca 500 g ciascuna, per la ricerca dei parametri microbiologici, da consegnare alla controparte. 
Ai fini di soddisfare i diritti alla difesa, il Sig. <u><input type="text"/></u> e' avvertito che ha la facolta', anche attraverso persona di sua fiducia appositamente designata, di presenziare, eventualmente con l'assistenza di un consulente tecnico, all'apertura e successive analisi, relativamente alle aliquote campioni distinte con le lettere <b>a, c, d, i, l</b> ed <b>m</b> di cui al presente verbale. In particolare:<br>
&nbsp<input type="checkbox" /> l'apertura delle aliquote <b>a, c, d,</b> dei campioni di terreno avverra' il giorno <u><input type="date"/></u> alle ore <u><input type="time"/></u> presso l'U.O.C. Siti Contaminati e Bonifiche dell'ARPAC sita in via Antiniana N  55, cap 80078 Pozzuoli (NA), recapito tel. 081/2301968;<br>
&nbsp<input type="checkbox" /> l'apertura dell'<b>aliquota</b> i per la Ricerca di Amianto verra' effettuata il giorno <u><input type="date"/></u> alle ore <u><input type="time"/></u> presso il Dipartimento Provinciale ARPAC di Salerno sito in via Lanzalone 54/56 cap 84100 Salerno, recapito tel. 089/2758001.<br> 
&nbsp<input type="checkbox" /> l'apertura delle aliquote <b>l</b> ed <b>m</b> dei campioni di terreno avverra' il giorno <u><input type="date"/></u> alle ore <u><input type="time"/></u> presso l'Universita' degli Studi  di Napoli "Federico II" - Dipartimento di Agraria - Sezione Microbiologia - Via Universita' 100, 80055 Portici recapito tel 081/2539145.<br>
Il Sig. <u><input type="text"/></u> e'informato che, atteso che la determinazione degli altri parametri viene effettuata anche da Laboratori fuori regione, il diritto alla difesa e' garantito dalla conservazione di un campione di riserva custodito presso il laboratorio preposto. 
In caso di difformita' degli esiti analitici per uno o piu' parametri, il laboratorio preposto ne' dara' comunicazione all'interessato, il quale potra' richiedere la revisione delle analisi, ai sensi dell'art. 223 del D.L.vo n 271/89.<br>
Il presente verbale e' redatto in n <u><input type="text"/></u> (<u><input type="text"/></u>) copie di cui una viene rilasciata, unitamente all'<b>aliquota b</b> (per i VOC) e all'<b>aliquota g</b>, al Sig. <u><input type="text"/></u> che ha  firmato previa integrale lettura  e chiede di inserire le seguenti dichiarazioni:<br>
<u><textarea class="long"></textarea></u><br>
<input type="checkbox"/> Viene inoltre consegnata alla controparte anche l'<b>aliquota n</b> (microbiologici).<br>
Le altre <u><input type="text"/></u> copie del presente verbale vengono rilasciate a: <u><input type="text"/></u>. <br>
Si e' proceduto alla decontaminazione/pulizia delle attrezzature utilizzate tra un campione elementare ed un altro.<br>
Strumentazione utillizzata: <u><input type="text"/></u>.<br>
<b>Informazioni Aggiuntive:</b><br>
<u>Coltivazioni Presenti</u><br>
La particella si presenta:<br>
<input type="checkbox"/>Con coltura in atto
<input type="checkbox"/>Arata
<input type="checkbox"/>Incolta con erba spontanea
<input type="checkbox"/>Non coltivabile
<br>Tipo/i di coltura/e rinvenute, descrizione dello stato di crescita e varie:
<u><textarea class="long"></textarea></u><br>
Sono state effettuate n. <u><input type="text"/></u><br> foto rappresentative delle colture presenti, che verranno tempestivamente trasmesse, in data odierna, a mezzo e-mail all'indirizzo [<u>suoloerifiuti@arpacampania.it</u>], per il seguito di competenza.<br>
<u>Presenza di rifiuti:</u><br>
<input type="checkbox"/>SI
<input type="checkbox"/>NO
<input type="checkbox"/>Parzialmente
<br> Descrizione:
<u><textarea class="long"></textarea></u><br>
<u>Irrigazione</u><br>
Da informazioni acquisite in loco/dal Sig. <u><input type="text"/></u><br> si rappresenta che l'acqua utilizzata per l'irrigazione del terreno oggi indagato deriva da (fiume, canale, rete idrica, altro, specificare) <u><input type="text"/></u>.<br>
<input type="checkbox"/>Se e' quindi proceduto al campionamento delle acque sotterranee prelevate nel pozzo presente nella proprieta', cosi' come da verbale <u><input type="text"/></u> del <u><input type="text"/></u>.<br> 
<b>Note aggiuntive: </b><br><u><textarea class="long"></textarea></u>.<br>
E' stato effettuato un report fotografico disponibile presso ARPAC.
Copia del presente verbale viene rilasciata ai Carabinieri Forestali ed alla parte convenuta.
LCS, alle ore: <u><input type="text"/></u>.<br>
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