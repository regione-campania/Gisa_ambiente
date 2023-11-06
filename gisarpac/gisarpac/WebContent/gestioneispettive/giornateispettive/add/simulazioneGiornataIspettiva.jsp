<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="http://code.jquery.com/jquery-1.8.2.js"></script>
<script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<script>
function checkForm(form){
	loadModalWindow();
	form.submit();
}
</script>

<form name="aggiungiCU" action="GestioneGiornateIspettive.do?command=Simulazione&auto-populate=true" onSubmit="" method="post">

<center>
<b>Simulazione inserimento Giornays Ispettiva</b><br/>
Inserire il JSON (anche parziale). Il sistema tenterà di tradurlo in tentativo di inserimento.<br/>

<textarea rows="10" cols="200" id="jsonGiornataIspettiva" name="jsonGiornataIspettiva">
{"FascicoloIspettivo":{"dataInizio":"2022-08-16 00:00:00","numero":"1234","id":22},"Tecnica":{"nome":"Ispezione AIA straordinaria","id":2},"Dipartimento":{"nome":"Dipartimento Provinciale di Avellino","id":201},"Utente":{"userId":13},"GruppoIspettivo":[{"referente":true,"nominativo":"UTENTE_NA UTENTE_NA","qualifica":"Dirigente Apicale","idStruttura":"45","id":23,"responsabile":false,"struttura":"Dipartimento Provinciale di Caserta->Area Territoriale->Test"},{"referente":false,"nominativo":"CVCV CVCV","qualifica":"Dirigente Apicale","idStruttura":"45","id":24,"responsabile":true,"struttura":"Dipartimento Provinciale di Caserta->Area Territoriale->Test"}],"PerContoDi":[{"nome":"Dipartimento Provinciale di Avellino -> STRUTTURA COMPLESSA -> Area Territoriale -> struttura semplice avellino","id":"44"}],"Esami":[{"nome":"Decreto AIA","id":"9"},{"nome":"Eventuali esposti, ordinanze","id":"10"}],"TipiVerifica":[{"nome":"Emissioni in acqua","id":"3"},{"nome":"Emissioni in aria","id":"2"},{"nome":"Rifiuti 3.2.5","id":"4"},{"nome":"Rumore","id":"9"},{"nome":"Suolo e sottosuolo","id":"5"}],"Linee":[{"codice":"M138-A20759-L41882","nome":"Altre Attivita' -> 6.6a -> Altre Attivita'->6.6a->Impianti per l'allevamento intensivo di pollame o di suini con più di: a) 40.000 posti pollame","id":"1176"}],"Dati":{"note":"nnnn","dataInizio":"2022-08-16","dataFine":"2022-08-16","oraInizio":"11:01","oraFine":"18:00"},"Anagrafica":{"partitaIva":"300290657","riferimentoId":2149,"ragioneSociale":"CISAM SRL (SPA)","riferimentoIdNomeTab":"opu_stabilimento"},"EmissioniAtmosferaCamini":[],"Motivi":[{"nome":"Comunicazioni dell'azienda di esecuzione di interventi","id":"5"},{"nome":"Valutazioni dell'agenzia","id":"3"}]}</textarea>

<!-- BOTTONI -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<tr>
<td colspan="2" align="center"><input type="button" style="font-size:40px" value="PROSEGUI" onclick="checkForm(this.form)"/>
</td>
</tr>
</table>
<!-- BOTTONI -->

</center>

</form>