<%@page import="org.aspcfs.modules.opu.base.LineaProduttiva"%>
<%@ page import="java.util.*,java.text.DateFormat,org.aspcfs.modules.accounts.base.*,org.aspcfs.modules.opu.base.*,org.aspcfs.modules.contacts.base.*,org.aspcfs.modules.base.Constants" %>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="StabilimentoDettaglio" class="org.aspcfs.modules.opu.base.Stabilimento" scope = "request"/>
<jsp:useBean id="ListaStati" class="org.aspcfs.utils.web.LookupList" scope="request"/>

<script src="javascript/vendor/moment.min.js"></script>

<script type="text/javascript" src="dwr/interface/SuapDwr.js"> </script>

<script  src="dwr/interface/PopolaCombo.js"> </script>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>

<script src="javascript/gestioneanagrafica/add.js"></script>


<table class="trails" cellspacing="0">
	<tr>
		<td>
			<a href="OpuStab.do?command=SearchForm">ANAGRAFICA STABILIMENTI</a> > 
			<a href="GestioneAnagraficaAction.do?command=Details&altId=${altId}">SCHEDA</a> > CESSAZIONE
		</td>
	</tr>
</table>

<form class="form-horizontal" role="form" method="post" action="GestioneAnagraficaAction.do?command=Cessazione" onsubmit="return validateForm();">
<b>MODIFICA SCHEDA: CESSAZIONE</b><br>
<input type="hidden" id="stabId" name="stabId" value="<%=StabilimentoDettaglio.getIdStabilimento()%>"/>
<input type="hidden" id="altId" name="altId" value="<%=StabilimentoDettaglio.getAltId()%>"/>

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

<table class="details" id="tabella_stab" cellspacing="0" border="0" width="100%" cellpadding="4">
<tbody>
	
	
	<tr>
		<td class="formLabel">Data inizio attivita'</td>
		<td>&nbsp;<%=StabilimentoDettaglio.getDataInizioAttivitaString().replaceAll("/", "-")%>
		<input type="hidden" id="data_inizio_stab" name="data_inizio_stab" value="<%=StabilimentoDettaglio.getDataInizioAttivitaString().replaceAll("/", "-") %>">
		</td>
	</tr>
	
	<tr>
		<td class="formLabel">cessazione osa</td>
		<td>
			&nbsp;CESSARE L'INTERO OSA &nbsp; 
			<input type="checkbox" id="cessa_stabilimento" name="cessa_stabilimento" onclick="gestisciCessazioneStab(this)"/>&nbsp;
			
		</td>
	</tr>
	<tr id="tr_data_cessazione" style="display: none">
		<td class="formLabel" style="width:10%"> <p>DATA CESSAZIONE</p> </td>
		<td>
			<input placeholder="DATA CESSAZIONE" type="text" id="data_cessazione" name="data_cessazione" autocomplete="off" size="15" style="text-align:center;">
		</td>
	</tr>
	<tr id="tr_note" style="display: none">
		<td class="formLabel" style="width:10%"> <p>NOTE</p> </td>
		<td>
			<textarea placeholder="note aggiuntive" id="cessa_stabilimento_note" name="cessa_stabilimento_note"></textarea>
		</td>
	</tr>
</tbody>
</table>
<br>

<table class="details" id="tabella_linee" cellspacing="0" border="0" width="100%" cellpadding="4"> 
<tr>
		<th colspan="4">Linee produttive</th>
</tr>
<% int linea_inserita = 0;
for(int i = 0; i < StabilimentoDettaglio.getListaLineeProduttive().size(); i++ ){ %>
 		<%LineaProduttiva lp = (LineaProduttiva) StabilimentoDettaglio.getListaLineeProduttive().get(i); %>
 		<%if(lp.getStato() != 4){%>
  			<tr id="tr_linea_<%=linea_inserita%>"> 			
	  			<td>
	  				<div id="div_linee_<%=linea_inserita%>" style="padding: 5px;" >
	  				Num. registrazione: <b><%=lp.getNumeroRegistrazione() %></b><br>
	  				<% String[] desc = lp.getDescrizione_linea_attivita().split("->"); %>
	  				<%=desc[0] %>-><br> <%=desc[1] %>-><br> <%=desc[2] %><br>
	  				</div>
	  				<input type="hidden" id="linea_<%=linea_inserita%>" name="linea_<%=linea_inserita%>" value="<%=lp.getDescrizione_linea_attivita() %>" >
	  				<input type="hidden" id="id_lp_<%=linea_inserita%>" name="id_lp_<%=linea_inserita%>" value="<%=lp.getId()%>">
	  				<input type="hidden" id="id_rel_stab_lp_<%=linea_inserita%>" name="id_rel_stab_lp_<%=linea_inserita%>" value="<%=lp.getId_rel_stab_lp()%>">
	  				<input type="hidden" id="codice_lp_<%=linea_inserita%>" name="codice_lp_<%=linea_inserita%>" value="<%=lp.getCodice()%>">
	  				<input type="hidden" id="stato_lp_<%=linea_inserita%>" name="stato_lp_<%=linea_inserita%>" value="<%=lp.getStato()%>">
	  				<input type="hidden" id="data_inizio_lp_<%=linea_inserita%>" name="data_inizio_lp_<%=linea_inserita%>" 
	  					value="<%=lp.getDataInizioString().replaceAll("/", "-") %>">
	  			</td>	
	  			<td align="center">
	  				<input type="checkbox" id="cessa_linea_<%=linea_inserita%>" name="cessa_linea_<%=linea_inserita%>" 
	  					onclick="gestisciCessazioneLinea(<%=linea_inserita%>, this)" />
	  			</td>
	  			<td id="td_data_cessazione_<%=linea_inserita%>" align="center" style="display: none">
	  				<input placeholder="DATA CESSAZIONE" type="text" id="data_cessazione_<%=linea_inserita%>" 
	  					name="data_cessazione_<%=linea_inserita%>" autocomplete="off" size="15" style="text-align:center;"><br>
	  			</td>
	  			<td id="td_cessa_linea_note_<%=linea_inserita%>" align="center" style="display: none">
	  				<textarea placeholder="note aggiuntive" id="cessa_linea_note_<%=linea_inserita%>" name="cessa_linea_note_<%=linea_inserita%>"></textarea>
	  			</td>
  			</tr>
  		<%linea_inserita++;
  		} %>
	<%} %> 
	<input type="hidden" id="numero_linee" name="numero_linee" value="<%=linea_inserita%>">
	
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
	
	if(!(document.getElementById('cessa_stabilimento').checked)){
		var linee_checked = 0;
		for(var i=0; i < document.getElementById('numero_linee').value; i++){
			if(document.getElementById('cessa_linea_' + i).checked)
				linee_checked++;					
		}
		if(linee_checked == 0){
			alert('Attenzione! nessuna linea selezionata');
			return false;
		}
		
	}

	//da implementare action java, mettere return true con loadModalWindowCustom('Attendere Prego...')
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

popup_date('data_cessazione', document.getElementById('data_inizio_stab').value, '0');

for(var i=0; i < document.getElementById('numero_linee').value; i++){
	popup_date('data_cessazione_' + i, document.getElementById('data_inizio_lp_' + i).value, '0');
}

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

function gestisciCessazioneStab(campo_check){
	if(campo_check.checked){
		document.getElementById('tabella_linee').style.display = 'none';
		document.getElementById('tr_data_cessazione').style.display = '';
		document.getElementById('data_cessazione').setAttribute('required', '');
		document.getElementById('tr_note').style.display = '';
	}else{
		document.getElementById('tabella_linee').style.display = '';
		document.getElementById('tr_data_cessazione').style.display = 'none';
		document.getElementById('data_cessazione').removeAttribute('required');
		document.getElementById('data_cessazione').value = '';
		document.getElementById('tr_note').style.display = 'none';
		for(var i=0; i < document.getElementById('numero_linee').value; i++){
			document.getElementById('cessa_linea_' + i).checked = false;
			document.getElementById('td_data_cessazione_' + i).style.display = 'none';
			document.getElementById('td_cessa_linea_note_' + i).style.display = 'none';
			document.getElementById('cessa_linea_note_' + i).value = '';
			document.getElementById('data_cessazione_' + i).removeAttribute('required');
			document.getElementById('data_cessazione_' + i).value = '';
		}
	}
}

function gestisciCessazioneLinea(numero_linea, campo_check){
	if(campo_check.checked){
		document.getElementById('td_data_cessazione_' + numero_linea).style.display = '';
		document.getElementById('td_cessa_linea_note_' + numero_linea).style.display = '';
		document.getElementById('data_cessazione_' + numero_linea).setAttribute('required', '');
	}else{
		document.getElementById('td_data_cessazione_' + numero_linea).style.display = 'none';
		document.getElementById('td_cessa_linea_note_' + numero_linea).style.display = 'none';
		document.getElementById('cessa_linea_note_' + numero_linea).value = '';
		document.getElementById('data_cessazione_' + numero_linea).removeAttribute('required');
		document.getElementById('data_cessazione_' + numero_linea).value = '';
	}
}


</script>
