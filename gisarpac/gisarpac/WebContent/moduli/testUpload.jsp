<%@ page import="org.aspcfs.modules.util.imports.ApplicationProperties" %>
<%@ page import="java.net.InetAddress" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<form id="form1" action="" method="post" name="form1" enctype ="multipart/form-data">
	<table>
		<tr><td>Applicativo di provenienza</td> <td><input type="text" readonly name="provenienza" id="provenienza" class="formVal" value="gisa_nt" /></td></tr>
		<tr><td>Id Utente</td> <td><input type="text" readonly name="idUtente" id="idUtente" class="formVal" value="test" /></td></tr>
		<tr><td>Ip Utente</td> <td><input type="text" readonly name="ipUtente" id="ipUtente" class="formVal" value="0.0.0.0" /></td></tr>
		<tr><td>Tipo certificato</td> <td><input type="text" readonly name="tipoCertificato" id="tipoCertificato" class="formVal" value="test" /></td></tr>
		<tr><td>Oggetto</td> <td><input type="text" name="oggetto" id="oggetto" class="formVal" value="test" /></td></tr>
		<tr><td>stabId</td> <td><input type="text" readonly name="stabId" id="stabId" class="formVal" value="-1" /></td></tr>
		<tr><td>ticketId</td> <td><input type="text" readonly name="ticketId" id="ticketId" class="formVal" value="-1" /></td></tr>
		<tr><td>Path</td> <td><input type="text" name="path" id="path" class="formVal" value="<%= ApplicationProperties.getProperty("FIRMA_UPLOAD_CARTELLA") + "\\RT_Signed20230123_15431.pdf" %>" /></td></tr>
		<tr><td>addCors</td> <td><input type="text" name="addCors" id="addCors" class="formVal" value="si" /></td></tr>
	</table>
</form>

<input type="button" onclick="uploadAjax()" value="vai"/>
</body>
</html>

<script>
function uploadAjax()
{
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
            if(xmlHttp.readyState == 4 && xmlHttp.status == 200)
            {
				var obj = JSON.parse(xmlHttp.response);
                alert("Upload avvenuto con successo, codDocumento: " + obj.codDocumento);
                uploadEseguito = true;
               	uploadSicra();
            }
        }
	//invio dei parametri
    xmlHttp.send(parametri);
	
}
</script>