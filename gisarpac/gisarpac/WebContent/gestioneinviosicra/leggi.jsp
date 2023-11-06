<jsp:useBean id="annoProtocollo" class="java.lang.String" scope="request"/>
<jsp:useBean id="dataProtocollo" class="java.lang.String" scope="request"/>
<jsp:useBean id="numeroProtocollo" class="java.lang.String" scope="request"/>
<jsp:useBean id="idDocumento" class="java.lang.String" scope="request"/>
<jsp:useBean id="oggetto" class="java.lang.String" scope="request"/>
<jsp:useBean id="tipoDocumento" class="java.lang.String" scope="request"/>
<jsp:useBean id="tipoDocumentoDescrizione" class="java.lang.String" scope="request"/>
<jsp:useBean id="dataInserimento" class="java.lang.String" scope="request"/>
<jsp:useBean id="tipoFile" class="java.lang.String" scope="request"/>
<jsp:useBean id="base64file" class="java.lang.String" scope="request"/>
<jsp:useBean id="commento" class="java.lang.String" scope="request"/>
<jsp:useBean id="nomeAllegato" class="java.lang.String" scope="request"/>
<jsp:useBean id="esito" class="java.lang.String" scope="request"/>
<jsp:useBean id="faultString" class="java.lang.String" scope="request"/>


<script>
function downloadProtocollo(annoProtocollo, numeroProtocollo){
	var res;
	var result=
		window.open('GestioneInvioSicra.do?command=DownloadProtocollo&annoProtocollo='+annoProtocollo+'&numeroProtocollo='+numeroProtocollo,'popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE FILE IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del file entro qualche secondo...');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
		
	}</script>

<table class="details">
<tr><th colspan="2">PROTOCOLLO SICRA</th></tr>
<tr><td class="formLabel">Anno protocollo</td><td><%=annoProtocollo %></td></tr>
<tr><td class="formLabel">Numero protocollo</td><td><%=numeroProtocollo %></td></tr>
<tr><td class="formLabel">Data protocollo</td><td><%=dataProtocollo %></td></tr>
<tr><td class="formLabel">Id documento</td><td><%=idDocumento %></td></tr>
<tr><td class="formLabel">Oggetto</td><td><%=oggetto %></td></tr>
<tr><td class="formLabel">Tipo documento</td><td><%=tipoDocumentoDescrizione %></td></tr>
<tr><td class="formLabel">Data inserimento</td><td><%=dataInserimento %></td></tr>
<tr><td class="formLabel">Tipo file</td><td><%=tipoFile %></td></tr>
<tr><td class="formLabel">Commento</td><td><%=commento %></td></tr>
<tr><td class="formLabel">Nome allegato</td><td><%=nomeAllegato %></td></tr>
<tr><td class="formLabel">Download</td><td><a href="#" onClick="downloadProtocollo('<%=annoProtocollo%>', '<%=numeroProtocollo%>')">Download</a></td></tr>
<tr><td class="formLabel">Descrizione errore</td><td><%=faultString %></td></tr>

</table>

