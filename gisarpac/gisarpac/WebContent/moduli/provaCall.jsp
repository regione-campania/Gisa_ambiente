<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>test</title>
</head>
<body>

<button onclick="openPopup('GestioneInvioSicra.do?command=LeggiProtocollo&annoProtocollo=2023&numeroProtocollo=1')">TEST CHIAMATA</button>


<script>
function openPopup(url){
	
	var parametri = "tipoVerbale=VerbaleA6&oggetto=AllegatoVerbaleA6&nomeAllegato=VerbaleA6G24-0000009_Signed20240112_125758.pdf&tipoFile=PDF&idGiornataIspettiva=218&idCampione=-1"

	//creazione formdata + conversione in stringa (chiave=valore & chiave=valore...)
	
	var xmlHttp = new XMLHttpRequest();
	//apertura della connessione con parametro "true" (necessario per POST)
	xmlHttp.open("get", "https://sicrawebapi.arpacampania.it/client/services/ProtocolloSoap?CID=gisa_test",true);
	//header necessario per il POST alla servlet
	xmlHttp.setRequestHeader('Content-type', 'application/xml');
	xmlHttp.setRequestHeader('Access-Control-Allow-Origin', '*');

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
	alert(xmlHttp.response)
 }
</script>
  
</body>
</html>