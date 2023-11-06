<%@ page import="java.util.*,java.text.DateFormat,org.aspcfs.modules.accounts.base.*,org.aspcfs.modules.opu.base.*,org.aspcfs.modules.contacts.base.*,org.aspcfs.modules.base.Constants" %>
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
			<a href="GestioneAnagraficaAction.do?command=Details&altId=${altId}">SCHEDA</a> > MODIFICA STATO DEI LUOGHI
		</td>
	</tr>
</table>

<form class="form-horizontal" role="form" method="post" action="GestioneAnagraficaAction.do?command=ModificaStatoDeiLuoghi" onsubmit="return validateForm();">
<b>MODIFICA SCHEDA: MODIFICA STATO DEI LUOGHI</b><br>
<input type="hidden" id="stabId" name="stabId" value="<%=StabilimentoDettaglio.getIdStabilimento()%>"/>
<input type="hidden" id="altId" name="altId" value="<%=StabilimentoDettaglio.getAltId()%>"/>
<input type="hidden" id="id_asl_stab" value="<%=StabilimentoDettaglio.getSedeOperativa().getIdAsl()%>">
<input type="hidden" id="tipo_linee_attivita" value="<%=StabilimentoDettaglio.getTipoAttivita()%>" />


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
		<th colspan="2">STABILIMENTO</th>
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
		<td class="formLabel">INDIRIZZO</td>
		<td>
			<%=StabilimentoDettaglio.getSedeOperativa().getDescrizioneToponimo()%>&nbsp;&nbsp;
			<%=StabilimentoDettaglio.getSedeOperativa().getVia() %>&nbsp;&nbsp;
			<%=StabilimentoDettaglio.getSedeOperativa().getCivico() %>&nbsp;&nbsp;
			<%=StabilimentoDettaglio.getSedeOperativa().getCap() %>&nbsp;&nbsp;
		 	<%=StabilimentoDettaglio.getSedeOperativa().getComuneTesto() %>&nbsp;&nbsp;
		 	<%=StabilimentoDettaglio.getSedeOperativa().getDescrizione_provincia() %>
		 </td>
		 <input type="hidden" id="data_inizio_stab" name="data_inizio_stab" value="<%=StabilimentoDettaglio.getDataInizioAttivitaString().replaceAll("/", "-") %>">
	</tr>
	
	<tr>
		<th colspan="2">POSSIBILI OPERAZIONI</th>
	</tr>
	
	<tr>
		<td class="formLabel">TIPO</td>
		<td>
			<select id="tipo_operazione" name="_b_tipo_operazione" 
				onchange="if(this.value != '')
							{
								document.getElementById('tr_dettaglio').style='display: block inline-block';
								document.getElementById('tr_data_operazione').style='display: block inline-block';
							}
						  else{
						  		document.getElementById('tr_dettaglio').style='display: none';
						  		document.getElementById('tr_data_operazione').style='display: none';
						  		document.getElementById('data_operazione').value='';
						  	   }" >
				<option value="">--SELEZIONA TIPO OPERAZIONE--</option>
				<option value="ampliamento locale">AMPLIAMENTO LOCALE</option>
				<option value="modifica della struttura del locale">MODIFICA DELLA STRUTTURA DEL LOCALE</option>
			</select> 
		</td>
	</tr>
	<tr id="tr_data_operazione" style="display: none">
		<td class="formLabel"> <p>DATA</p> </td>
		<td>
			<input placeholder="DATA OPERAZIONE" type="text" id="data_operazione" name="_b_data_operazione" autocomplete="off" size="15" style="text-align:center;" required>
		</td>
	</tr>
	<tr id="tr_dettaglio" style="display: none;">
		<td class="formLabel">DETTAGLI</td>
		<td> <textarea id="dettagli_operazione" name="_b_dettagli_operazione" placeholder="dettagli operazione..." required></textarea> </td>
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


<script>

function validateForm(){
	
	if(document.getElementById("tipo_operazione").value==''){
		alert("Attenzione. Selezionare un operazione!");
		return false;
	} else if (document.getElementById("dettagli_operazione").value.trim()==''){
		alert("Attenzione. Inserire dettaglio dell\' operazione!");
		document.getElementById("dettagli_operazione").value = '';
		return false;
	}
	
	loadModalWindowCustom('Attendere Prego...');
	return true;
	
}

if(document.getElementById('tipo_linee_attivita').value == '2'){
	alert('Attenzione: Operazione di modifica stato dei luoghi non consentita per osa senza sede fissa!');
	loadModalWindowCustom('Attendere Prego...');
	window.location.href='GestioneAnagraficaAction.do?command=Details&altId='+ document.getElementById('altId').value;
}

if(document.getElementById('numeroPratica').value == ''){
	document.getElementById('dati_pratica').style.display = 'none';
	document.getElementById('torna').onclick = function(){
		loadModalWindowCustom('Attendere Prego...');
		window.location.href='GestioneAnagraficaAction.do?command=Details&altId='+ document.getElementById('altId').value;
	};
	
}

popup_date('data_operazione', document.getElementById('data_inizio_stab').value, '0');

function popup_date(elemento_html_data, min_data, max_data){
	$( '#' + elemento_html_data ).datepicker({
		  dateFormat: 'dd-mm-yy',
		  changeMonth: true,
		  changeYear: true,
		  yearRange: '-100:+3',
		  minDate: min_data,
		  maxDate: max_data,
		  dayNamesMin : [ 'do', 'lu', 'ma', 'me', 'gi', 've', 'sa' ],
		  monthNamesShort :['Gennaio','Febbraio','Marzo','Aprile','Maggio','Giugno', 'Luglio','Agosto','Settembre','Ottobre','Novembre','Dicembre'],
		  beforeShow: function(input, inst) {
              setTimeout(function () {
                         var offsets = $('#' + elemento_html_data).offset();
                         var top = offsets.top - 100;
                         inst.dpDiv.css({ top: top, left: offsets.left});
                         $(".ui-datepicker-next").hide();
							$(".ui-datepicker-prev").hide();
							$(".ui-state-default").css({'font-size': 15});
							$(".ui-datepicker-title").css({'text-align': 'center'});
							$(".ui-datepicker-calendar").css({'text-align': 'center'});
               });
             },
        onChangeMonthYear: function(year, month, inst) {
              setTimeout(function () {
                         var offsets = $('#' + elemento_html_data).offset();
                         var top = offsets.top - 100;
                         inst.dpDiv.css({ top: top, left: offsets.left});
                         $(".ui-datepicker-next").hide();
							$(".ui-datepicker-prev").hide();
							$(".ui-state-default").css({'font-size': 15});
							$(".ui-datepicker-title").css({'text-align': 'center'});
							$(".ui-datepicker-calendar").css({'text-align': 'center'});
               });
             }                                                  
		});
}

</script>