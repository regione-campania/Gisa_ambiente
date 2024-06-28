<%@ page import="org.aspcfs.modules.util.imports.ApplicationProperties" %>
<%@ page import="java.net.InetAddress" %>
<%@ page import="org.json.*"%>

<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>

<%

String HOST_GISA_RISORSE = ApplicationProperties.getProperty("HOST_GISA_RISORSE");
System.out.println("### HOST_GISA_RISORSE: " +HOST_GISA_RISORSE);

%>


<%

JSONObject json = new JSONObject(request.getParameter("json"));



String idGiornataIspettiva = "-1";
String idAnagrafica = "-1";

if ( ((JSONObject) json).has("CampiServizio")) {
	JSONObject jsonCampiServizio = (JSONObject) json.get("CampiServizio");
	if (jsonCampiServizio.length()>0) {
		idGiornataIspettiva = jsonCampiServizio.get("idGiornataIspettiva").toString();
	} }

if ( ((JSONObject) json).has("Anagrafica")) {
	JSONObject jsonAnagrafica = (JSONObject) json.get("Anagrafica");
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
  			//alert("Assicurarsi di aver installato correttamente l'sdk 'fcsing' e di accedere a questa pagina tramite Dipositivo Abilitato alla firma grafometrica.");
  			//window.close();
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
<title>VERBALE VERIFICA ISPETTIVA</title>

<link rel="stylesheet" type="text/css" media="screen" href="<%=HOST_GISA_RISORSE %>/gisarpac/moduli/css/screen.css" />
<link rel="stylesheet" type="text/css" media="print"  href="<%=HOST_GISA_RISORSE %>/gisarpac/moduli/css/print.css" />


<body>
<br>
<div align = "center">
	<form id="modulo" action="" method="POST" target="_blank">
		<table class="innertable">
			<tr>
				<td class="testa innertd" rowspan = "2"><img src="<%=HOST_GISA_RISORSE %>/gisarpac/moduli/img/arpac_ico.jpg" alt="..." width="100" height="125">
					<div class="boxIdDocumento"></div>
					<div class="boxOrigineDocumento"><%@ include file="../../../hostName.jsp" %></div>
				</td>
				<td class="testa innertd" align="center"><h1>Verbale di Verifica Ispettiva</h1></td>
				<td class="testa innertd" align="right">Doc. n: <u><input type = "text" value = "1" id = "ndoc" size="1"></u></td>
			</tr>
			<tr>
				<td class="testa innertd" align="center">Procedura di riferimento: PT 7.5 A6</td>
				<td class="testa innertd" align="right">Data<u><input type="date" id="dver" j_obj="Dati" j_attr="dataInizio"></u> </td>
			</tr>
		</table>
		<br>
		
		<h3><strong>VERBALE DI VERIFICA ISPETTIVA N:</strong>
		<u><input type = "text" value = "1" id = "nver" size="1"></u></h3>
		N: <u><input type = "text" value = "1" id = "ngio" size="1"></u> giornata di Verifica Ispettiva
		<br><br>
		<div align = "left">
		Il giorno <u><input type="date" id="dver" j_obj="Dati" j_attr="dataInizio"></u> alle ore <u><input type="time" id="hver" j_obj="Dati" j_attr="oraInizio"></u>, il Gruppo Ispettivo	prosegue la visita presso lo stabilimento
		<u><input type="text" id="stab" value="" j_obj="Anagrafica" j_attr="ragioneSociale"></u>,
		<br><br>
			<table>
				<tr>
					<th>Per ARPAC presenti:</th>
				</tr>
				<tr>
					<td>.<u><input type="text" placeholder="Nome e Cognome" id="arp1" j_obj="GruppoIspettivo" j_attr="nominativo0"></u></td>
					<td><u><input type="text" placeholder="Qualifica" id="qua1" j_obj="GruppoIspettivo" j_attr="qualifica0" size="45%"></u></td>
				</tr>
				<tr>
					<td>.<u><input type="text" placeholder="Nome e Cognome" id="arp2" j_obj="GruppoIspettivo" j_attr="nominativo1"></u></td>
					<td><u><input type="text" placeholder="Qualifica" id="qua2" j_obj="GruppoIspettivo" j_attr="qualifica1" size="45%"></u></td>
				</tr>
				<tr>
					<td>.<u><input type="text" placeholder="Nome e Cognome" id="arp3" j_obj="GruppoIspettivo" j_attr="nominativo2"></u></td>
					<td><u><input type="text" placeholder="Qualifica" id="qua3" j_obj="GruppoIspettivo" j_attr="qualifica2" size="45%"></u></td>
				</tr>
				<tr>
					<td>.<u><input type="text" placeholder="Nome e Cognome" id="arp4" j_obj="GruppoIspettivo" j_attr="nominativo3"></u></td>
					<td><u><input type="text" placeholder="Qualifica" id="qua4" j_obj="GruppoIspettivo" j_attr="qualifica3" size="45%"></u>&nbsp,</td>
				</tr>
				<tr>
					<th>Per la Societa' sono presenti:</th>
				</tr>
				<tr>
					<td>.<u><input type="text" placeholder="Nome e Cognome" id="soc1" j_obj="Anagrafica" j_attr="gestore"></u></td>
					<td><u><input type="text" placeholder="Qualifica" id="qso1" value="Gestore dello stabilimento" readonly></u></td>
				</tr>
				<tr>
					<td>.<u><input type="text" placeholder="Nome e Cognome" id="soc2" j_obj="Anagrafica" j_attr="responsabile"></u></td>
					<td><u><input type="text" placeholder="Qualifica" id="qso2" value="Responsabile IPPC" readonly></u></td>
				</tr>
				<tr>
					<td>.<u><input type="text" placeholder="Nome e Cognome" id="soc3"></u></td>
					<td><u><input type="text" placeholder="Qualifica" id="qso3"></u></td>
				</tr>
				<tr>
					<td>.<u><input type="text" placeholder="Nome e Cognome" id="soc4"></u></td>
					<td><u><input type="text" placeholder="Qualifica" id="qso4"></u></td>
				</tr>
				<tr>
					<th>Altri Presenti:</th>
				</tr>
				<tr>
					<td>.<u><input type="text" placeholder="Nome e Cognome" id="al1"></u></td>
					<td><u><input type="text" placeholder="Qualifica" id="qso_1"></u></td>
				</tr>
				<tr>
					<td>.<u><input type="text" placeholder="Nome e Cognome" id="al2"></u></td>
					<td><u><input type="text" placeholder="Qualifica" id="qso_2"></u></td>
				</tr>
				<tr>
					<td>.<u><input type="text" placeholder="Nome e Cognome" id="al3"></u></td>
					<td><u><input type="text" placeholder="Qualifica" id="qso_3"></u></td>
				</tr>
			</table>
			<br>
			Nel corso della giornata odierna sono state svolte le seguenti verifiche dell'allegato tecnico:
			<br><br>
			<div style="overflow-x:auto;">
			<table class="innertable tab">
			
				<tr >
					<th class="innerth th1">Tipo verifica</th>
					<th class="innerth th1">&nbsp Matrice</th>
					<th class="innerth th1">&nbsp Conclusa</th>
					<th class="innerth th1">&nbsp Note</th>
				</tr>
				
				<% if ( ((JSONObject) json).has("TipiVerifica")) { 
JSONArray jsonTipiVerifica = (JSONArray) json.get("TipiVerifica");
if (jsonTipiVerifica.length()>0) {%>
<% for (int i = 0; i<jsonTipiVerifica.length(); i++) {
JSONObject jsonTipoVerifica = (JSONObject) jsonTipiVerifica.get(i);
%>
<tr >
					<td class="innertd td<%=i+1%>"><input type="text" id="tve<%=i+1%>" value=<%=jsonTipoVerifica.get("nome") %>></td>
					<td class="innertd td<%=i+1%>"><input type="text" id="mat<%=i+1%>"></td>
					<td class="innertd td<%=i+1%>"><input type="checkbox" id="sta<%=i+1%>  "></td>
					<td class="innertd td<%=i+1%>"><textarea id="not<%=i+1%>" style="width:500px;height:60px;"></textarea></td>
				</tr>

<br/>
<% } %>
</td></tr>
<%} } %>
				
			</table>
			</div>
			<br><br>
			<br>
			Sono state effettuate le seguenti misure e i seguenti prelievi:
			<br><br>
			<div align="center" style="overflow-x:auto;">
			<table class="innertable tab">
				<tr  align="center">
					<th class="innerth th1">Matrice</th>
					<th class="innerth th1">&nbsp Misura/Prelievo</th>
					<th class="innerth th1">&nbsp Verbale Campionamento del ...</th>
					<th class="innerth th1">&nbsp Note</th>
				</tr>
				<tr align="center">
					<td class="innertd td1"><input type="text" id="mat7"></td>
					<td class="innertd td1"><input type="text" id="mip7"></td>
					<td class="innertd td1"><input type="date" id="dat7"></td>
					<td class="innertd td1"><textarea id="not7" style="width:500px;height:60px;"></textarea></td>
				</tr>
				<tr align="center">
					<td class="innertd td1"><input type="text" id="mat8"></td>
					<td class="innertd td1"><input type="text" id="mip8"></td>
					<td class="innertd td1"><input type="date" id="dat8"></td>
					<td class="innertd td1"><textarea id="not8" style="width:500px;height:60px;"></textarea></td>
				</tr>
				<tr align="center">
					<td class="innertd td1"><input type="text" id="mat9"></td>
					<td class="innertd td1"><input type="text" id="mip9"></td>
					<td class="innertd td1"><input type="date" id="dat9"></td>
					<td class="innertd td1"><textarea id="not9" style="width:500px;height:60px;"></textarea></td>
				</tr>
				<tr align="center">
					<td class="innertd td1"><input type="text" id="mat10"></td>
					<td class="innertd td1"><input type="text" id="mip10"></td>
					<td class="innertd td1"><input type="date" id="dat10"></td>
					<td class="innertd td1"><textarea id="not10" style="width:500px;height:60px;"></textarea></td>
				</tr>
				<tr align="center">
					<td class="innertd td1"><input type="text" id="mat11"></td>
					<td class="innertd td1"><input type="text" id="mip11"></td>
					<td class="innertd td1"><input type="date" id="dat11"></td>
					<td class="innertd td1"><textarea id="not11" style="width:500px;height:60px;"></textarea></td>
				</tr>
				<tr align="center">
					<td class="innertd td1"><input type="text" id="mat12"></td>
					<td class="innertd td1"><input type="text" id="mip12"></td>
					<td class="innertd td1"><input type="date" id="dat12"></td>
					<td class="innertd td1"><textarea id="not12" style="width:500px;height:60px;"></textarea></td>
				</tr>
			</table>
			</div>
			<br><br>
			
			<br>
			Il Gruppo Ispettivo ha acquisito la seguente documentazione:
			<br><br>
			<div align="center" style="overflow-x:auto;">
			<table class="innertable tab ">
				<tr  align="center">
					<th class="innerth th1">Documento</th>
					<th class="innerth th1">&nbsp Riferimento</th>
					<th class="innerth th1">&nbsp Formato</th>
					<th class="innerth th1">&nbsp Note</th>
				</tr>
				<tr align="center">
					<td class="innertd td1"><input type="text" id="doc1"></td>
					<td class="innertd td1"><input type="text" id="rif1"></td>
					<td class="innertd td1"><input type="text" id="for1"></td>
					<td class="innertd td1"><textarea id="not13" style="width:500px;height:60px;"></textarea></td>
				</tr>
				<tr align="center">
					<td class="innertd td1"><input type="text" id="doc2"></td>
					<td class="innertd td1"><input type="text" id="rif2"></td>
					<td class="innertd td1"><input type="text" id="for2"></td>
					<td class="innertd td1"><textarea id="not14" style="width:500px;height:60px;"></textarea></td>
				</tr>
				<tr align="center">
					<td class="innertd td1"><input type="text" id="doc3"></td>
					<td class="innertd td1"><input type="text" id="rif3"></td>
					<td class="innertd td1"><input type="text" id="for3"></td>
					<td class="innertd td1"><textarea id="not15" style="width:500px;height:60px;"></textarea></td>
				</tr>
				<tr align="center">
					<td class="innertd td1"><input type="text" id="doc4"></td>
					<td class="innertd td1"><input type="text" id="rif4"></td>
					<td class="innertd td1"><input type="text" id="for4"></td>
					<td class="innertd td1"><textarea id="not16" style="width:500px;height:60px;"></textarea></td>
				</tr>
				<tr align="center">
					<td class="innertd td1"><input type="text" id="doc5"></td>
					<td class="innertd td1"><input type="text" id="rif5"></td>
					<td class="innertd td1"><input type="text" id="for5"></td>
					<td class="innertd td1"><textarea id="not17" style="width:500px;height:60px;"></textarea></td>
				</tr>
				<tr align="center">
					<td class="innertd td1"><input type="text" id="doc6"></td>
					<td class="innertd td1"><input type="text" id="rif6"></td>
					<td class="innertd td1"><input type="text" id="for6"></td>
					<td class="innertd td1"><textarea id="not18" style="width:500px;height:60px;"></textarea></td>
				</tr>
			</table>
			</div>
			<br><br>
			<table class="tab"><tr><td class="td1">
			L'odierna attivita' ispettiva e' iniziata alle ore <u><input type="time" id="oini" j_obj="Dati" j_attr="oraInizio"></u> e si e' conclusa alle ore <u><input type="time" id="ofin" j_obj="Dati" j_attr="oraFine"></u><br>
			Non essendo state concluse tutte le attivita' di verifica previste dal Piano di controllo, la Verifica Ispettiva e' aggiornata al giorno <u><input type="date" id="drin"></u> alle ore <u><input type="time" id="orin"></u><br><br>
			<strong>A tale fine si comunica quanto segue: </strong><br>
			<u><input type="text" id="com1" size="55%" maxlength="60"></u> <br><br>
			<strong>L'Azienda presenta le seguenti osservazioni: </strong><br>
			<u><input type="text" id="com2" size="55%" maxlength="60"></u> <br><br>
			<strong>Il programma dell'ispezione proposto durante  la  riunione, in accordo tra il Gruppo Ispettivo e l'Azienda, viene modificato come segue: </strong><br>
			<u><input type="text" id="com3" size="55%" maxlength="60"></u>
			</td></tr></table> <br><br>
			
			<u><input type="text" id="lfir"></u>, il <u><input type="date" id="dfir" j_obj="Dati" j_attr="dataCompilazione"></u>
		</div>
		<br>
		<div align="left">
		<table>
			<tr>
				<th>Per il Gruppo Ispettivo (G.I.)</th>
				<th>Per l'Azienda</th>
			</tr>
			<br>
			<tr>
				<td>.<u><input type="text" id="arp5" j_obj="GruppoIspettivo" j_attr="nominativo0"></u><br>(Coordinatore della Verifica Ispettiva) &nbsp &nbsp </td>
				<td>.<u><input type="text" id="soc5" j_obj="Anagrafica" j_attr="responsabile"></u><br>(Responsabile IPPC)</td>
			</tr>
			<tr>
				<td>.<u><input type="text" id="arp6" j_obj="GruppoIspettivo" j_attr="nominativo1"></u></td>
				<td>.<u><input type="text" id="soc6"></u></td>
			</tr>
			<tr>
				<td>.<u><input type="text" id="arp7" j_obj="GruppoIspettivo" j_attr="nominativo2"></u></td>
				<td>.<u><input type="text" id="soc7"></u></td>
			</tr>
			<tr>
				<td>.<u><input type="text" id="arp8" j_obj="GruppoIspettivo" j_attr="nominativo3"></u></td>
				<td>.<u><input type="text" id="soc8"></u></td>
			</tr>
		</table>
		</div>
		<div>
		
		
		
		
		
		
	<br><input type="button" value="INVIA" class="bottone" onclick="style.display = 'none';catturaHtml(this.form)">
	<br><br>
	<br>
	</form>
	</u><p align="center" ><b>&nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp FIRMA G.I. &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp &nbsp FIRMA dei presenti all'ispezione per l'azienda</b></p><br><br><br>

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
<tr><td>Tipo certificato</td> <td><input type="text" readonly name="tipo" id="tipo" class="formVal" value="VerbaleA6" /></td></tr>
<tr><td>Tipo timbro</td> <td><input type="text" readonly name="tipoTimbro" id="tipoTimbro" class="formVal" value="GISA" /></td></tr>
<tr><td>stabId</td> <td><input type="text" readonly name="stabId" id="stabId" class="formVal" value="<%=idAnagrafica %>" /></td></tr>
<tr><td>idGiornataIspettiva</td> <td><input type="text" readonly name="idGiornataIspettiva" id="idGiornataIspettiva" class="formVal" value="<%=idGiornataIspettiva %>" /></td></tr>
<tr><td>Fixa Html</td> <td><input type="text" name="fixaHtml" id="fixaHtml" class="formVal" value="si" /></td></tr>
<tr><td>Sorgente HTML</td> <td> <input type="text" name="htmlcode" class="formVal" id="htmlcode" > <br/></td></tr>
</table>

</form>

</div>
<div style="display:none">
<form id="formFN" action="firmaPDF.jsp" method="post" name="formFN" target="popup">
<input type="text" name="fileName" id="fileName" value="">

<input type="hidden" name="idUtente" id="idUtente" value="<%=User.getUserId() %>"/>
<input type="hidden" name="tipoCertificato" id="tipoCertificato" value="VerbaleA6_SIGNED"/>
<input type="hidden" name="stabId" id="stabId" class="formVal" value="<%=idAnagrafica %>"/>
<input type="hidden" readonly name="idGiornataIspettiva" id="idGiornataIspettiva" class="formVal" value="<%=idGiornataIspettiva %>" />
<input type="hidden" readonly name="idCampione" id="idCampione" class="formVal" value="-1" />


<input type="text" name="tipoVerbale" id="tipoVerbale" value="VerbaleA6" />
<input type="text" name="oggetto" id="oggetto" value="AllegatoVerbaleA6" />

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

if ( ((JSONObject) json).has("Anagrafica")) {
	JSONObject jsonAnagrafica = (JSONObject) json.get("Anagrafica");
	%>
	<script>
	settaSelector("Anagrafica","ragioneSociale","<%= jsonAnagrafica.get("ragioneSociale").toString() %>");
	settaSelector("Anagrafica","responsabile","<%= jsonAnagrafica.get("responsabile").toString() %>");
	settaSelector("Anagrafica","gestore","<%= jsonAnagrafica.get("gestore").toString() %>");

	</script>
	<%
}

if ( ((JSONObject) json).has("Dati")) {
	JSONObject jsonDati = (JSONObject) json.get("Dati");
	%>
	<script>
	settaSelector("Dati","dataInizio","<%= jsonDati.get("dataInizio").toString().replaceAll(" 00:00:00","") %>");
	settaSelector("Dati","oraInizio","<%= jsonDati.get("oraInizio").toString() %>");
	settaSelector("Dati","oraFine","<%= jsonDati.get("oraFine").toString() %>");
	</script>
	<%
}

if ( ((JSONObject) json).has("GruppoIspettivo")) {
	JSONArray jsonNucleo = (JSONArray) json.get("GruppoIspettivo");
	for (int i = 0; i<jsonNucleo.length(); i++) {
		JSONObject jsonComponente = (JSONObject) jsonNucleo.get(i);
		%>
		<script>
			settaSelector("GruppoIspettivo","nominativo"+"<%= i %>","<%= jsonComponente.get("nominativo") %>");
			settaSelector("GruppoIspettivo","qualifica"+"<%= i %>","<%= jsonComponente.get("qualifica") %>");
		</script>
		<%
	}
}




%>