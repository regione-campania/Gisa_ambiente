<%@ page import="java.util.*,java.text.DateFormat,org.aspcfs.modules.accounts.base.*,org.aspcfs.modules.opu.base.*,org.aspcfs.modules.contacts.base.*,org.aspcfs.modules.base.Constants" %>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="StabilimentoDettaglio" class="org.aspcfs.modules.opu.base.Stabilimento" scope = "request"/>


<script src="javascript/vendor/moment.min.js"></script>
<script src="javascript/noscia/addNoScia.js"></script>
<script type="text/javascript" src="dwr/interface/SuapDwr.js"> </script>

<script  src="dwr/interface/PopolaCombo.js"> </script>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>

<script src="javascript/gestioneanagrafica/add.js"></script>

<table class="trails" cellspacing="0">
	<tr>
		<td>
			<a href="OpuStab.do?command=SearchForm">ANAGRAFICA STABILIMENTI</a> > 
			<a href="GestioneAnagraficaAction.do?command=Details&altId=${altId}">SCHEDA</a> > TRASFERIMENTO SEDE OPERATIVA
		</td>
	</tr>
</table>

<form class="form-horizontal" role="form" method="post" action="GestioneAnagraficaAction.do?command=TrasferimentoSedeOperativa" onsubmit="return validateForm();">
<b>MODIFICA SCHEDA: TRASFERIMENTO SEDE OPERATIVA</b><br>
<input type="hidden" id="stabId" name="stabId" value="<%=StabilimentoDettaglio.getIdStabilimento()%>"/>
<input type="hidden" id="altId" name="altId" value="<%=StabilimentoDettaglio.getAltId()%>"/>
<input type="hidden" id="id_asl_stab" value="<%=StabilimentoDettaglio.getSedeOperativa().getIdAsl()%>">


<dhv:permission name="trasferimento_sede_stabilimento_tutte_asl-view"> 
	<body onload ="document.getElementById('id_asl_stab').value = '-1'">   
	</body>
</dhv:permission>

<div id="dati_pratica" style="border: 1px solid black; background: #BDCFFF">
<br>
&nbsp;&nbsp;&nbsp;&nbsp;NUMERO PRATICA: ${numeroPratica} <br>
&nbsp;&nbsp;&nbsp;&nbsp;DATA PEC: ${dataPratica} <br>
<br>
<input type="hidden" id="numeroPratica" name="numeroPratica" value="${numeroPratica}"/>
<input type="hidden" id="idTipologiaPratica" name="idTipologiaPratica" value="${tipoPratica}"/>
<input type="hidden" id="idComunePratica" name="idComunePratica" value="${comunePratica}"/>
</div>
<br/>

<table class="details" cellspacing="0" border="0" width="100%" cellpadding="4">
<tbody>
	<tr>
		<th colspan="2">OSA</th>
	</tr>
	<tr>
		<td class="formLabel">Ragione Sociale Impresa</td>
		<td><%=StabilimentoDettaglio.getOperatore().getRagioneSociale()%></td>
	</tr>
	<tr>
		<td class="formLabel">Numero registrazione</td>
		<td><%=StabilimentoDettaglio.getNumero_registrazione()%></td>
	</tr>
	
	<tr>
		<td class="formLabel">ASL</td>
		<td><%=StabilimentoDettaglio.getSedeOperativa().getDescrizioneAsl()%> </td>
	</tr>
	
	
	<tr>
		<th colspan="2">DATI ATTUALE SEDE OPERATIVA</th>
	</tr>
	<tr>
		<td class="formLabel">INDIRIZZO</td>
		<td>
			<%=StabilimentoDettaglio.getSedeOperativa().getDescrizioneToponimo()%>&nbsp;&nbsp;
			<%=StabilimentoDettaglio.getSedeOperativa().getVia() %>&nbsp;&nbsp;
			<%=StabilimentoDettaglio.getSedeOperativa().getCivico() %>&nbsp;&nbsp;
			<%=StabilimentoDettaglio.getSedeOperativa().getCap() %>&nbsp;&nbsp;
		 	<%=StabilimentoDettaglio.getSedeOperativa().getComuneTesto() %>&nbsp;&nbsp;
		 	<%=StabilimentoDettaglio.getSedeOperativa().getDescrizione_provincia() %>
		 </td>
	</tr>
	
	<tr>
		<td class="formLabel">COORDINATE</td>
		<td>
			<%=StabilimentoDettaglio.getSedeOperativa().getLatitudine() %> &nbsp;&nbsp;
		 	<%=StabilimentoDettaglio.getSedeOperativa().getLongitudine() %>
		</td>
	</tr>
		
	
	<tr>
		<th colspan="2">DATI NUOVA SEDE OPERATIVA</th>
	</tr>
	
	<tr>
		<td class="formLabel">INDIRIZZO</td>
		<td> 
			<input type="text" id="toponimo_stabilimento" name="toponimo_stabilimento" placeholder="TOPONIMO" value="" size="10" readonly="">
			<input type="text" id="via_stabilimento" name="_b_via_stab" placeholder="VIA" value="" size="38" readonly="">
			<input type="text" id="civico_stabilimento" name="_b_civico_stab" placeholder="CIVICO" value="" size="10" readonly="">
			<input type="text" id="cap_stabilimento" name="_b_cap_stab" placeholder="CAP" value="" size="5" maxlength="5" onkeydown="return false;" required="" autocomplete="off">
			<input type="text" id="comune_stabilimento" name="comune_stabilimento" placeholder="COMUNE" value="" size="30" readonly="">
			<input type="text" id="provincia_stabilimento" name="provincia_stabilimento" placeholder="PROVINCIA" value="" size="18" readonly="">
			<input type="button" id="ins_indirizzo_stabilimento" value="INSERISCI INDIRIZZO" onclick="inserisciNuovoIndirizzo()">
			<input type="hidden" id="comuneIdStabilimento" name="_b_cod_comune_stab">
			<input type="hidden" id="provinciaIdStabilimento" name="_b_cod_provincia_stab">
			<input type="hidden" id="topIdStabilimento" name="_b_toponimo_stab">
		</td>
	</tr>
	
	<tr>
		<td class="formLabel">COORDINATE</td>
		<td>
			<input type="text" id="lat_stabilimento" name="_b_latitudine_stab" placeholder="LATITUDINE" value="" onkeydown="return false;" required="" autocomplete="off">
			<input type="text" id="long_stabilimento" name="_b_longitudine_stab" placeholder="LONGITUDINE" value="" onkeydown="return false;" required="" autocomplete="off">
			<input type="button" id="calcola_coord_stabilimento" value="CALCOLA COORDINATE" onclick="getCoordinate('toponimo_stabilimento','via_stabilimento','comune_stabilimento','provincia_stabilimento','cap_stabilimento','lat_stabilimento','long_stabilimento')">
		</td>
	</tr>
	
</tbody>
</table>
<br><br>
<center>

<button type="submit" class="yellowBigButton" style="width: 250px;">Salva</button>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

<button type="button" id="torna" class="yellowBigButton" style="width: 250px;"
	onClick="loadModalWindowCustom('Attendere Prego...'); window.location.href='GestioneAnagraficaAction.do?command=ListaPraticheStabilimenti'">Annulla</button>

</center>
</form>
<br><br>

<script src="javascript/noscia/widget.js"></script>
<script>

function validateForm(){
	
	loadModalWindowCustom('Attendere Prego...');
	return true;
}

if(document.getElementById('numeroPratica').value == ''){
	document.getElementById('dati_pratica').style.display = 'none';
	document.getElementById('torna').onclick = function(){
		loadModalWindowCustom('Attendere Prego...');
		window.location.href='GestioneAnagraficaAction.do?command=Details&altId='+ document.getElementById('altId').value;
	};	
}

function inserisciNuovoIndirizzo(){
	openCapWidget('toponimo_stabilimento','topIdStabilimento','via_stabilimento','civico_stabilimento','comune_stabilimento', 'comuneIdStabilimento',
			'cap_stabilimento','provincia_stabilimento','provinciaIdStabilimento','campania', document.getElementById('id_asl_stab').value); 
	document.getElementById('lat_stabilimento').value = '';
	document.getElementById('long_stabilimento').value = '';
}

</script>