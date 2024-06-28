<%@ page import="org.aspcfs.modules.util.imports.ApplicationProperties" %>
<%@ page import="java.net.InetAddress" %>


<%
//Leggo l'url a cui sono connesso attualmente
String HEADER_URI = request.getRequestURI();
String HEADER_URL = request.getRequestURL().toString();
String HEADER_DOMINIO = HEADER_URL.replaceAll(HEADER_URI, "").replaceAll("https://", "").replaceAll("http://", "");
if (HEADER_DOMINIO.indexOf(":")>0)
	HEADER_DOMINIO = HEADER_DOMINIO.substring(0, HEADER_DOMINIO.indexOf(":"));
System.out.println("### HEADER_DOMINIO: " +HEADER_DOMINIO);


int idGiornataIspettiva = -1;
int idCampione = -1;
int idArea = -1;

try {idGiornataIspettiva = Integer.parseInt(request.getParameter("idGiornataIspettiva"));} catch (Exception e) {}
try {idCampione = Integer.parseInt(request.getParameter("idCampione"));} catch (Exception e) {}
try {idArea = Integer.parseInt(request.getParameter("idArea"));} catch (Exception e) {}

System.out.println("campione "+idCampione);
System.out.println("giornata "+idGiornataIspettiva);
System.out.println("area "+idArea);

%>


<!DOCTYPE HTML>
<head>
  <script crossorigin type="text/javascript" src="https://localhost:7777/files/fcsign.js"></script>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
  <title>Firma Certa Web Test</title>
</head>
<body>

<script type="text/javascript">

//var upload = 'http://www.gisacampania.it/firma/web/upload.php';
//var upload = "http://172.16.3.114:8080/gisarpac/GestioneAllegatiUpload.do?command=UploadFile";
var upload = '<%= ApplicationProperties.getProperty("FIRMA_UPLOAD_PAGINA") %>';
var uploadEseguito = false;
var contaErrore = 0;
//var upload = 'http://172.16.0.45/serverDocumentale/UploadFileWrapper';
//ip 172.16.3.189:8089
fcHttpServerOfflineCallback = serverOfLine;



function serverOfLine() 
{
  alert('Local server offline');
}

function genericEnd(response)
{
   if (!response.success)
	  alert(" genericEnd - error : " + response.errorMessage + " (" +response.errorCode+")")
 }

function addLink(e, text, url)
{
  var a = document.createElement('a');
  var linkText = document.createTextNode(text);
  a.appendChild(linkText);
  a.title = text;
  a.href = url;
  a.target= "_blank";
  document.getElementById(e).appendChild(a);
  var br = document.createElement('br');
  document.getElementById(e).appendChild(br);
}

function signEnd(response)
{
	
   document.getElementById('img').style.visibility = 'hidden';
   if (!response.success)
	  alert(response.errorMessage || "Has not been produced any file")
   else
   {
	   
	  if (document.getElementById('checkmemory').checked)
      {
	    document.getElementById('pdf').setAttribute('src','https://localhost:7777/files/memory/signeddocument.pdf');
        //document.getElementById('uploadButtons').style.display = 'inline';
	  }	
	  else	  
	  {
	   // document.getElementById('pdf').setAttribute('src','RT_Signed.pdf');
	  }		  

		if (response.signedDocument) 
		{
			document.getElementById('uploadSignedDocument').style.visibility = 'visible';
			addLink("fcdoclink","Signed document", response.signedDocument);
		}

    }
   
}

function signStart()
{
    var sel = document.getElementById('readers');
	var tablets = document.getElementById('tablets');
	//var fileUrl = 'https://localhost:7777/files/valorizzato.pdf';
	var fileUrl = 'https://localhost:7777/files/' + getReturnName();
	//alert('verifica file'+fileUrl);
	var uploadUrl = upload;
	
	if (document.getElementById('checkmemory').checked || document.getElementById('checksave').checked)
	{
	   uploadUrl = '';
	}

	//document.getElementById('uploadSignedDocument').style.visibility = 'visible';
    document.getElementById('img').style.visibility = 'visible';

    fcsign.extraParams = 'UrlTSA=https://timestamp.firmacerta.it;UsernameTSA=demo;PasswordTSA=l4C4s0n010';
    if (sel.selectedIndex>=0) {
	    fcsign.extraParams = fcsign.extraParams + ';ReaderName='+sel.options[sel.selectedIndex].text;
		if (sel.options[sel.selectedIndex].value == 'r')
		  fcsign.extraParams = fcsign.extraParams + ';UsernameRS='+document.getElementById('utente').value+';PasswordRS='+document.getElementById('password').value
		else
		  fcsign.extraParams = fcsign.extraParams + ';Pin='+document.getElementById('pin').value;
	}
	
	if (tablets.selectedIndex>=0) {
		tablet = JSON.parse(tablets.options[tablets.selectedIndex].getAttribute("tablet"));
		if (tablet.isTabletPC) {
			fcsign.extraParams = fcsign.extraParams + ';AdvancedSignature.FromTabletPC=1;AdvancedSignature.TabletPCModel='+tablet.modelAsString;
		} else {
			fcsign.extraParams = fcsign.extraParams + ';AdvancedSignature.FromTabletPC=0;AdvancedSignature.TabletModel='+tablet.modelAsString;
		}
	}

	//fcsign.templateUrl = 'https://localhost:7777/files/7301.fct';
	//fcsign.sign(fileUrl,'7301.pdf',uploadUrl,'7301_Signed.pdf');
	
	//alert("uploadUrl->" + uploadUrl + " \nfilesigned->" + 'RT_Signed.pdf');

	var d = Date.now();
	var date = new Date(d);
	
	var SS = date.getSeconds().toString(); //secondi
	if(SS >= 0 && SS < 10){SS = "0" + SS.toString();}else{SS = SS.toString();}
	
	var	MM = date.getMinutes().toString(); //minuti
	if(MM >= 0 && MM < 10){MM = "0" + MM.toString();}else{MM = MM.toString();}

	var HH = date.getHours().toString(); //ore
	if(HH >= 0 && HH < 10){HH = "0" + HH.toString();}else{HH = HH.toString();}
	
	var gg = date.getDate(); //giorni
	if(gg > 0 && SS < 10){gg = "0" + gg.toString();}else{gg = gg.toString();}
	
	var mm = date.getMonth() + 1; //mesi
	if(mm > 0 && mm < 10){mm = "0" + mm.toString();}else{mm = mm.toString();}
	
	var aa = date.getFullYear().toString(); //anni
	
	var ts = aa + mm + gg +"_"+ HH + MM + SS; //timestamp yymmdd_HHMMSS
	
	var filename = getReturnName().replaceAll('.pdf','') + '_Signed' + ts + '.pdf';
	var cartella = "<%= ApplicationProperties.getProperty("FIRMA_UPLOAD_CARTELLA") %>";
	//var cartella = 'C:\\Users\\US\\Desktop\\allegatiFirma\\';
	var percorso = cartella + filename;
	var b = getReturnName();
	if(b.includes("A6") == true){
		fcsign.templateUrl = '<%=ApplicationProperties.getProperty("TEMPLATE_CARTELLA")%>/ispettivaA6.fct';
	}else if(b.includes("C4") == true){
		fcsign.templateUrl = '<%=ApplicationProperties.getProperty("TEMPLATE_CARTELLA")%>/ispettivaA6.fct';
	}else if(b.includes("AS") == true){
		fcsign.templateUrl = '<%=ApplicationProperties.getProperty("TEMPLATE_CARTELLA")%>/campioneAcqueSott.fct';
	}else if(b.includes("VerbaleCampionamentoSuolo") == true){
		fcsign.templateUrl = '<%=ApplicationProperties.getProperty("TEMPLATE_CARTELLA")%>/CampionamentoSuolo.fct';
	}else if(b.includes("VerbaleMancatoCampionamentoSuolo") == true){
		fcsign.templateUrl = '<%=ApplicationProperties.getProperty("TEMPLATE_CARTELLA")%>/MancatoCampionamento.fct';
	}
// 	fcsign.sign(fileUrl,'RT.pdf', uploadUrl, filename);
	fcsign.sign(fileUrl,'RT.pdf', uploadUrl, filename);
	//document.getElementById('uploadButtons').style.visibility = 'visible';
	document.getElementById('path').value = percorso;
	document.getElementById('filename').value = filename;	
	document.getElementById('pathFile').value = percorso;
	document.getElementById('nomeAllegato').value = filename;
	
	fcsign.callback = signEnd;


}

function readersEnd(response)
{
   document.getElementById('img').style.visibility = 'hidden';
   if (!response.success)
	  alert(response.errorMessage || "Has not been produced any result")
   else
   {
      document.getElementById('readers').options.length = 0;
	  for (var i=0; i<response.readers.length;i++){
       opt = new Option(response.readers[i].name, response.readers[i].remote ? 'r' : response.readers[i].smartCard ? 's' : 'n');
       document.getElementById('readers').options[i] = opt;
      }
      readerChange(document.getElementById('readers'));
   }
}
function getReaders()
{
    document.getElementById('img').style.visibility = 'visible';
	fcsign.callback = readersEnd;
	fcsign.readers(false, true);
}

function tabletsEnd(response)
{
   document.getElementById('img').style.visibility = 'hidden';
   if (!response.success)
	  alert(response.errorMessage || "Has not been produced any result")
   else
   {
      document.getElementById('tablets').options.length = 0;
	  for (var i=0; i<response.tablets.length;i++){
       opt = new Option(response.tablets[i].name);
	   opt.setAttribute("tablet", JSON.stringify(response.tablets[i]));
       document.getElementById('tablets').options[i] = opt;
      }
   }
}

function getTablets()
{
    document.getElementById('img').style.visibility = 'visible';
	fcsign.callback = tabletsEnd;
	fcsign.getSupportedTablets(document.getElementById('tabletconnected').checked);
}

function readerChange(selectObj)
{
   var idx = selectObj.selectedIndex;
   if (idx>=0) {
	   if (selectObj.options[idx].value == 'r') {
		 document.getElementById('localReader').style.display = 'none';
		 document.getElementById('remoteReader').style.display = 'inline';
	   } else if (selectObj.options[idx].value == 's') {
		 document.getElementById('localReader').style.display = 'inline';
		 document.getElementById('remoteReader').style.display = 'none';
	   } else if (selectObj.options[idx].value == 'n') {
		 document.getElementById('localReader').style.display = 'none';
		 document.getElementById('remoteReader').style.display = 'none';
	   }
   }
}

function installCertificate()
{
    document.getElementById('img').style.visibility = 'visible';
	fcsign.callback = installCertificateEnd;
	fcsign.installManagedCertificate('https://localhost:7777/files/Firma GrafoCerta (FEA).fck');
}

function installCertificateEnd(response)
{
   document.getElementById('img').style.visibility = 'hidden';
   if (response.success)
	  getReaders();
   else
	  alert(response.errorMessage || "Has not been produced any result");
}

function showDocument()
{
	fcsign.callback = null;
	fcsign.showDocumentToTheSigner(srcPdf,'',false)
}

function loadDocument()
{
	fcsign.callback = function (response) {
							if (!response.success)
								alert(response.errorMessage)
							else
							{
								document.getElementById('fcdoclink').innerHTML = '';
								//document.getElementById('uploadButtons').style.display = 'none';
								addLink("fcdoclink","Original document", response.document);
							}
					  };	
	fcsign.loadDocumentInMemory(srcPdf);
}

function clearMemory()
{
	fcsign.callback = function (response) {
							if (response.success)
							{
								document.getElementById('fcdoclink').innerHTML = '';
								//document.getElementById('uploadButtons').style.display = 'none';
							}

					  };		
	fcsign.clearMemory();
}

function selectSignaturePosition()
{
	fcsign.callback = function (data) {
							if (data.success)
								alert('position='+JSON.stringify(data.position));
					  }
	fcsign.selectSignaturePosition(srcPdf,'')
}

function displayManagerEnd(response)
{
	if (response.success) {
		if (response.hasOwnProperty('isPlaying')) {
			alert('isPlaying='+response.isPlaying)
		}
	}
}

function showImageOnTablet()
{
   fcsign.callback = displayManagerEnd;	
   fcsign.displayManager('show', 'https://localhost:7777/files/file.jpg', true);

}

function displayManagerActionChange(selectObj)
{
   var idx = selectObj.selectedIndex;
   if (idx>=0) {
	  fcsign.callback = displayManagerEnd;	
	  fcsign.displayManager(selectObj.options[idx].value)
   }

}

function uploadSignedDocument()
{
	fcsign.callback = genericEnd;	
	fcsign.uploadSignedDocumentFromMemory(upload, 'RT_Signed.pdf', document.getElementById('checkzip').checked ? 1:0);
}


function getReturnName(){
	var a = document.getElementById('check').value;
	
	if (a.includes("RECUPERATO_") == true)
	{
		return a.slice(11);
	}
	else
	{
		return a;
	}
	
};


function uploadAjax()
{
	var b = getReturnName();

	 if(b.includes("VerbaleCampionamentoSuolo") == true || b.includes("VerbaleMancatoCampionamentoSuolo") == true){
		 let email = prompt("eventuali e-mail dei carabinieri forestali a cui verranno inviati i documenti firmati (nel caso le e-mail siano piu' di una, separarle con un punto e virgola [ ; ] )", "");
		 let text;
		 if (email == null || email == "") {
		 } else {
		   document.getElementById("mailDestinatari").value=email;
		 }	 }
	
	if(document.getElementById('path').value == ''){
		alert("Errore! Firmare il documento prima di confermare");
		return;
	}
	//creazione formdata + conversione in stringa (chiave=valore & chiave=valore...)
	var parametri = new URLSearchParams(new FormData(form1)).toString();
			
    var xmlHttp = new XMLHttpRequest();
	//apertura della connessione con parametro "true" (necessario per POST)
	xmlHttp.open("post", "GestioneAllegatiUpload.do?command=UploadFile",true);
	//header necessario per il POST alla servlet
	xmlHttp.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
		//attesa della risposta
        xmlHttp.onreadystatechange = function()
        {
			//elaborazione della risposta
            if(xmlHttp.readyState == 4 && xmlHttp.status == 200 && uploadEseguito == false)
            {
            	console.log(xmlHttp.response);
				var obj = JSON.parse(xmlHttp.response);
                alert("Upload avvenuto con successo, codDocumento: " + obj.codDocumento);
                uploadEseguito = true;
               	uploadSicra();
            }
        }
	//invio dei parametri
    xmlHttp.send(parametri);
}

function uploadSicra()
{
	document.getElementById('img').style.visibility = 'visible';
	document.getElementById('uploadSignedDocument').style.visibility = 'hidden';
	//creazione formdata + conversione in stringa (chiave=valore & chiave=valore...)
	var parametri = new URLSearchParams(new FormData(formSicra)).toString();
	
	var xmlHttp = new XMLHttpRequest();
	//apertura della connessione con parametro "true" (necessario per POST)
	xmlHttp.open("post", "GestioneInvioSicra.do?command=InviaInserisciProtocolloEAnagrafiche&returnTipo=json",true);
	//header necessario per il POST alla servlet
	xmlHttp.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
		//attesa della risposta
       xmlHttp.onreadystatechange = function()
        {
			//elaborazione della risposta
           if(xmlHttp.readyState == 4 && xmlHttp.status == 200)
            {
            	var obj = JSON.parse(xmlHttp.response);
            	if(obj.Esito == "OK"){
            		alert("Upload verso Sicra avvenuto con successo");
    				window.opener.opener.location.reload();
    				window.opener.close();
    				window.close();
            	}else if(obj.Esito == "KO"){
            		alert(obj.faultString);
            		window.location.reload();
            	}
            	
            }
        }
	//invio dei parametri
    xmlHttp.send(parametri);
	
  
}

</script>
<br>
<div  class="container-sm">
	<h2 align="center"><strong>FIRMA <%= request.getParameter("fileName") %></strong></h2>
</div>
<input hidden type="text" id="check" name="check" value="<%= request.getParameter("fileName")%>"/>
<br>
<div class="container-sm">
	<select id='readers' onchange="readerChange(this)" hidden></select>
	<div id="localReader" style="display: none">
		Pin
		<input id='pin' type="password"/>
	</div>
	<div id="remoteReader" style="display: none">
		Utente
		<input id='user' type="text"/>
		Password
		<input id='password' type="password"/>
	</div>
	<input type="button" value="Tablets list" onclick="getTablets()" hidden />
	<br>
	<br>
	<div align="center">
	Dispositivo: 
	<select class="form-select" id='tablets'></select>
	</div>
	<input type="checkbox" id="tabletconnected" checked="true" hidden />
	<input type="button" value="Show document" onclick="showDocument()" hidden />
	<input type="button" value="Select signature position" onclick="selectSignaturePosition()" hidden />
	<input type="button" value="Show image on tablet" onclick="showImageOnTablet()" hidden />

	<select id='displayManagerAction' onchange="displayManagerActionChange(this)" hidden>
		<option value="pause">Pause</option>
		<option value="resume">Resume</option>
		<option value="reset">Reset</option>
		<option value="status">Status</option>
	</select>
	<br>
	<br>
</div>
<div align="center" class="container-sm">
   <br>
   <!-- ALL IN ONE -->
	<br>
	<div id="signButtons" style="visibility: visible">
	<input type="button" value="Sign" id="signButton" class="btn btn-success" onclick="installCertificate();getReaders();getTablets('true');signStart();this.style.display = 'none';"/>
	<br>
	</div>
	<div style="visibility: hidden">
    <input type="checkbox" id="checksave">Save pdf in local storage</input>
    <input type="checkbox" id="checkmemory">Sign document in memory</input>
	<br>
	</div>
	<img id='img' src="loader.gif" width="16" height="16" style="visibility: hidden"/>
	<div id="fcdoclink"></div>
	<div id="uploadButtons" style="visibility: visible">
		<input id="uploadSignedDocument" class="btn btn-success" type="button" value="Conferma e invia" onclick="uploadAjax()" />
	</div> 
</div>
<br><br>
<div style="display:none" id = "divform">
<form id="form1" action="" method="post" name="form1" enctype ="multipart/form-data">
	<table>
		<tr><td>Applicativo di provenienza</td> <td><input type="text" readonly name="provenienza" id="provenienza" class="formVal" value="gisa_nt" /></td></tr>
		<tr><td>Id Utente</td> <td><input type="text" readonly name="idUtente" id="idUtente" class="formVal" value="<%=request.getParameter("idUtente")%>" /></td></tr>
		<tr><td>Ip Utente</td> <td><input type="text" readonly name="ipUtente" id="ipUtente" class="formVal" value="0.0.0.0" /></td></tr>
		<tr><td>Tipo certificato</td> <td><input type="text" readonly name="tipo" id="tipo" class="formVal" value="<%=request.getParameter("tipoCertificato")%>" /></td></tr>
		<tr><td>Oggetto</td> <td><input type="text" name="oggetto" id="oggetto" class="formVal" value="<%=request.getParameter("tipoCertificato")%>" /></td></tr>
		<tr><td>stabId</td> <td><input type="text" readonly name="stabId" id="stabId" class="formVal" value="<%=request.getParameter("stabId")%>" /></td></tr>
		<tr><td>ticketId</td> <td><input type="text" readonly name="ticketId" id="ticketId" class="formVal" value="<%= idGiornataIspettiva > 0 ? idGiornataIspettiva : idCampione > 0 ? idCampione : -1%>" /></td></tr>
		<tr><td>Path</td> <td><input type="text" name="path" id="path" class="formVal" value="" /></td></tr>
		<tr><td>addCors</td> <td><input type="text" name="addCors" id="addCors" class="formVal" value="si" /></td></tr>
		<tr><td>filename</td> <td><input type="text" name="filename" id="filename" class="formVal" value="" /></td></tr>
		<tr><td>jsonEntita</td> <td><input type="textarea" name="jsonEntita" id="jsonEntita" class="formVal" value="{'idStabilimentoAIA':<%=request.getParameter("stabId")%>,'idGiornataIspettiva':<%=idGiornataIspettiva%>}" /></td></tr>
		
	</table>
</form>
<br>
<form id="formSicra" action="" method="post" name="formSicra" enctype ="multipart/form-data">
	<table>
		<tr><td>tipoVerbale</td> <td><input type="text" name="tipoVerbale" id="tipoVerbale" value="<%=request.getParameter("tipoVerbale")%>" /></td></tr>
		<tr><td>oggetto</td> <td><input type="text" name="oggetto" id="oggetto" value="<%=request.getParameter("oggetto")%>" /></td></tr>
		<tr><td>nomeAllegato</td> <td><input type="text" name="nomeAllegato" id="nomeAllegato" value="" /></td></tr>
		<tr><td>tipoFile</td> <td><input type="text" name="tipoFile" id="tipoFile" value="PDF" /></td></tr>
		<tr><td>pathFile</td> <td><input type="text" name="pathFile" id="pathFile" size="100" value="" /></td></tr>
		<tr><td>idGiornataIspettiva</td> <td><input type="text" name="idGiornataIspettiva" id="idGiornataIspettiva" value="<%=idGiornataIspettiva%>" />
		<tr><td>idCampione</td> <td><input type="text" name="idCampione" id="idCampione" value="<%=idCampione%>" />
		<tr><td>idArea</td> <td><input type="text" name="idArea" id="idArea" value="<%=idArea%>" />
		<tr><td>mailDestinatari</td> <td><input type="text" name="mailDestinatari" id="mailDestinatari" value="" />
		<tr><td>invioMail</td> <td><input type="text" name="invioMail" id="invioMail" value="si" />
		
		
		
		
		</td></tr> 
	</table>
</form>

</div>

</body>
<script>
getTablets();

//document.getElementById("file").value = "C:\Users\admin\Downloads\TEST_G22-000182.pdf"; 
</script>



</html>

