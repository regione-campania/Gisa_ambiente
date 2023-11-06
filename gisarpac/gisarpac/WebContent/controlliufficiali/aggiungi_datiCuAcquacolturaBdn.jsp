<jsp:useBean id="TicketDetails" class="org.aspcfs.modules.vigilanza.base.Ticket" scope="request"/>
<jsp:useBean id="orgDetail" class="org.aspcf.modules.controlliufficiali.base.Organization" scope="request"/>
<jsp:useBean id="DatiCuAcquacolturaBdn" class="org.aspcf.modules.controlliufficiali.base.DatiCuAcquacolturaBdn" scope="request"/>
<jsp:useBean id="Response" class="java.lang.String" scope="request"/>
<jsp:useBean id="listaVeterinari" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="SpecieList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="criteriList" class="org.aspcfs.utils.web.LookupList" scope="request"/>

<%@ include file="../initPage.jsp" %>

<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery-1.8.2.js"></script>
<script src="javascript/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<!-- RELATIVO AL NUOVO CALENDARIO CON MESE E ANNO FACILMENTE MODIFICABILI -->
<SCRIPT LANGUAGE="JavaScript" SRC="javascript/CalendarPopup.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="javascript/common.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">document.write(getCalendarStyles());</SCRIPT>
<SCRIPT LANGUAGE="JavaScript" ID="js19">
	var cal19 = new CalendarPopup();
	cal19.showYearNavigation();
	cal19.showYearNavigationInput();
	cal19.showNavigationDropdowns();
</SCRIPT>

<script>
function checkForm(form){
	var invio = form.inviosinvsa.value;
	
	var msg = "Salvare i dati inseriti?";
	
	if (invio =='invia')
		msg+="\n\n I dati saranno inviati automaticamente in BDN.";
	else
		msg+="\n\n ATTENZIONE. E' stato selezionato di NON inviare i dati in BDN.";
	
if (confirm(msg)){
	loadModalWindow();
	form.submit();
}
	
}

</script>

<% 
if (Response != null && !Response.equals("")) 
{ 
%>
<table width="100%">
<tr style="background:yellow"><th colspan="2">ESITO INVIO</th></tr>
<tr><td><%=Response %>
</td></tr>
</table>
<br/>
<% } %>	


<form id = "addAccount" name="addAccount" action="PrintReportVigilanza.do?command=SalvaDatiCuAcquacolturaBdn&auto-populate=true" method="post">

<table class="details">
<tr><th colspan="2">DATI CU ACQUACOLTURA</th></tr>

<tr>
	<td>
		ID CONTROLLO
	</td> 
	<td> 
		<input type="text" readonly id="idControllo" name="idControllo" value="<%=TicketDetails.getId() %>"/> 
	</td> 
</tr>
<tr>
	<td>
		CODICE ASL
	</td> 
	<td>
		<input type="text" id="aslCodice" name="aslCodice" value="<%=((DatiCuAcquacolturaBdn.getAslCodice()!=null && !DatiCuAcquacolturaBdn.getAslCodice().equals("")) ? (toHtml(DatiCuAcquacolturaBdn.getAslCodice())) : ((TicketDetails.getSiteId()>0)?("R" + TicketDetails.getSiteId()):(""))) %>"/>
	</td>
</tr>
<tr>
	<td>
		CODICE AZIENDA 
	</td> 
	<td>
		<input type="text" id="aziCodice" name="aziCodice" value="<%=((DatiCuAcquacolturaBdn.getAziCodice()!=null && !DatiCuAcquacolturaBdn.getAziCodice().equals("")) ? (toHtml(DatiCuAcquacolturaBdn.getAziCodice())) : (TicketDetails.getCodice_azienda())) %>"/>
	</td>
</tr>
<tr>
	<td>
		CODICE FISCALE PROPRIETARIO
	</td> 
	<td>
		<input type="text" id="idFiscaleProprietario" name="idFiscaleProprietario" value="<%=((DatiCuAcquacolturaBdn.getIdFiscaleProprietario()!=null && !DatiCuAcquacolturaBdn.getIdFiscaleProprietario().equals("")) ? (toHtml(DatiCuAcquacolturaBdn.getIdFiscaleProprietario())) : ("")) %>"/>
	</td>
</tr>

<tr>
	<td>
		CODICE GRUPPO SPECIE
	</td> 
	<td>
		<%=SpecieList.getHtmlSelect("gspCodice",DatiCuAcquacolturaBdn.getGspCodice()) %>
	</td>
</tr>

<tr>
	<td>
		CODICE CRITERIO O MOTIVO DEL CONTROLLO
	</td> 
	<td>
		<%=criteriList.getHtmlSelect("critCodice",DatiCuAcquacolturaBdn.getCritCodice()) %>
	</td>
</tr>

<tr>
	<td>
		DATA CONTROLLO
	</td> 
	<td>
	<%
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	%>
		<input type="text" id="dataControllo" name="dataControllo" value="<%=((DatiCuAcquacolturaBdn.getDataControllo()!=null && !DatiCuAcquacolturaBdn.getDataControllo().equals("")) ? (toHtml(DatiCuAcquacolturaBdn.getDataControllo())) : (sdf.format(new java.util.Date(TicketDetails.getAssignedDate().getTime())))) %>"/>
	</td>
</tr>

<tr>
	<td> 
		<input type="radio" id="invia" name="inviosinvsa" value="invia" checked>Inviare in Bdn
	</td> 
	<td>
		<input type="radio" id="noninvia" name="inviosinvsa" value="noninvia">NON inviare in Bdn
	</td>
</tr>

<tr>
	<td colspan="2">
		<input type="button" value="SALVA" onClick="checkForm(this.form)"/>
	</td>
</tr>
</table>

<DIV ID='modalWindow' CLASS='unlocked'><P CLASS='wait'>Attendere il completamento dell'operazione...</P></DIV>

