<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Download moduli</title>
</head>
<body>
	<%
	String path = "trasportoanimali/modellitrasporti";
		String modulo = (String)request.getAttribute("nomeModulo");
		String nomeDocumento="Allegato A1";
		String pathDocumentoDoc = "";	
		String pathDocumentoPdf = "";
		if (modulo.equals("A1")){
			nomeDocumento = "Allegato A1 (RICHIESTA)";
			pathDocumentoDoc = path+"/ALL A1 RICHIESTA AUTORIZZAZIONE sotto 8 ore.doc";
			pathDocumentoPdf = path+"/ALL A1 RICHIESTA AUTORIZZAZIONE sotto 8 ore.pdf";
		}
		if (modulo.equals("A2")){
			nomeDocumento = "Allegato A2 (RICHIESTA)";
			pathDocumentoDoc = path+"/ALL A2 RICHIESTA AUTORIZZAZIONE sopra 8 ore.doc";
			pathDocumentoPdf = path+"/ALL A2 RICHIESTA AUTORIZZAZIONE sopra 8 ore.pdf";
		}
		if (modulo.equals("B")){
			nomeDocumento = "Modulo B - Checklist";
			pathDocumentoDoc = path+"/CHECKLIST.doc";
			pathDocumentoPdf = path+"/CHECKLIST.pdf";
		}
		if (modulo.equals("E")){
			nomeDocumento = "Allegato E - Richiesta Omologazione";
			pathDocumentoDoc = path+"/OMOLOGAZIONE.doc";
			pathDocumentoPdf = path+"/OMOLOGAZIONE.pdf";
		}
		if (modulo.equals("G")){
			nomeDocumento = "Allegato G - Autodichiarazione Prod. Primario";
			pathDocumentoDoc = path+"/ALL G autodichiarazione PRODUZ PRIMARIA.doc";
			pathDocumentoPdf = path+"/ALL G autodichiarazione PRODUZ PRIMARIA.pdf";
		}
		if (modulo.equals("H")){
			nomeDocumento = "Allegato H - Autodichiarazione Equidi";
			pathDocumentoDoc = path+"/ALL H autodichiarazione CAVALLI.doc";
			pathDocumentoPdf = path+"/ALL H autodichiarazione CAVALLI.pdf";
		}
		
	%>
	<br>
	<table align="center" border="1">
		<tr>
			<th bgcolor="#FF9933" colspan="2">
				<font color="#FFFFFF"><%= nomeDocumento%></font>
			</th>
		</tr>
		<tr>
			<td><center>
				
						<%
								if (!pathDocumentoDoc.equals("")){
									%>
									
										<a target="_blank" href="<%=pathDocumentoDoc %>"><img src="DownloadModuli/icona_word.jpg" width="30" height="30"></a>
									
									<%
								}
							%>
							</center>
						</td>
					
						<td><center>
							<%
								if (!pathDocumentoPdf.equals("")){
									%>
									
										<a target="_blank" href="<%=pathDocumentoPdf %>"><img src="DownloadModuli/icona_pdf.jpg" width="30" height="30"></a>
									
									<%
								}
							%></center>
						</td>
					
		</tr>
	</table>
	<% %>
</body>
</html>
