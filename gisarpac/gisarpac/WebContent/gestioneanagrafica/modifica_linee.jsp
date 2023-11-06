<%@page import="org.aspcfs.modules.opu.base.LineaProduttiva"%>
<%@ page import="java.util.*,java.text.DateFormat,org.aspcfs.modules.accounts.base.*,org.aspcfs.modules.opu.base.*,org.aspcfs.modules.contacts.base.*,org.aspcfs.modules.base.Constants" %>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="StabilimentoDettaglio" class="org.aspcfs.modules.opu.base.Stabilimento" scope = "request"/>
<jsp:useBean id="ListaStati" class="org.aspcfs.utils.web.LookupList" scope="request"/>

<script src="javascript/noscia/addNoScia.js"></script>
<script  src="dwr/interface/PopolaCombo.js"> </script>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>

<table class="trails" cellspacing="0">
	<tr>
		<td>
			<a href="GestioneAnagraficaAction.do?command=ListaPraticheStabilimenti">Gestione Anagrafica</a> > 
			<a href="GestioneAnagraficaAction.do?command=Details&altId=${altId}">SCHEDA</a> > Modifica Linee Stabilimento
		</td>
	</tr>
</table>

<form class="form-horizontal" role="form" method="post" action="GestioneAnagraficaAction.do?command=UpdateLinee" onsubmit="return validateForm();">
<b>ERRATA CORRIGE: MODIFICA LINEE STABILIMENTO</b><br>
<input type="hidden" id="altId" name="altId" value="<%=StabilimentoDettaglio.getAltId()%>"/>
<input type="hidden" id="numero_linee" name="numero_linee" value="<%=StabilimentoDettaglio.getListaLineeProduttive().size()%>"/>
<input type="hidden" id="tipo_attivita_stab" value="<%=StabilimentoDettaglio.getTipoAttivita() %>"/>
<table class="table details" id="tabella_linee" style="border-collapse: collapse" width="100%" cellpadding="5"> 
	<tr>
		<th width="47%">LINEA ATTUALE</th>
		<th width="5%">SELEZIONA</th>	
		<th width="48%">NUOVA LINEA</th>	
	</tr>
	
	<% 
	for(int i = 0; i < StabilimentoDettaglio.getListaLineeProduttive().size(); i++ ){ %>
  		<%LineaProduttiva lp = (LineaProduttiva) StabilimentoDettaglio.getListaLineeProduttive().get(i); %>
  		<tr>
  			<td>
  				NUM. REGISTRAZIONE: <b><%=lp.getNumeroRegistrazione() %></b><br>
  				<%=lp.getDescrizione_linea_attivita() %><br>
  				
  				<%if(StabilimentoDettaglio.getTipoAttivita() == 1){ %>
  					TIPO ATTIVITA: <b>CON SEDE FISSA</b><br>
  				<%} else { %>
  					TIPO ATTIVITA: <b>SENZA SEDE FISSA</b><br>
  				<%} %>
  				<%if(lp.getTipo_carattere() == 1){%>
  					CARATTERE: <b>PERMANENTE</b><br>
  				<%}else if(lp.getTipo_carattere() == 2){%>
  				CARATTERE: <b>TEMPORANEA</b><br>
  				<%} %>
  				DATA INIZIO: <b><%=lp.getDataInizioString().replaceAll("/", "-") %></b><br>
  				<%if(!lp.getDataFineString().equalsIgnoreCase("")){ %>
  					DATA FINE: <b><%=lp.getDataFineString().replaceAll("/", "-") %></b><br>
  					<%} %>

  				STATO: <b><%=ListaStati.getSelectedValue(lp.getStato()) %></b><br>
  				CUN: <b><%=lp.getCodiceNazionale()!= null && !lp.getCodiceNazionale().equalsIgnoreCase("")?lp.getCodiceNazionale():"" %></b>
  				
  				<input type="hidden" id="id_rel_stab_lp_<%=i%>" name="id_rel_stab_lp_<%=i%>" value="<%=lp.getId_rel_stab_lp()%>"/>
  				<input type="hidden" id="id_linea_produttiva_old_<%=i%>" value="<%=lp.getId() %>"/>
  				<input type="hidden" id="stato_linea_produttiva_old_<%=i%>" value="<%=lp.getStato() %>"/>
  				<input type="hidden" id="id_macroarea_old_<%=i%>" value="<%=lp.getIdMacroarea() %>" />
  				<input type="hidden" id="id_aggregazione_old_<%=i%>" value="<%=lp.getIdCategoria() %>" />
  				<input type="hidden" id="id_attivita_old_<%=i%>" value="<%=lp.getIdAttivita() %>" />
				<input type="hidden" id="tipo_carattere_old_<%=i%>" value="<%=lp.getTipo_carattere() %>" />
				<input type="hidden" id="data_inizio_old_<%=i%>" value="<%=lp.getDataInizioString().replaceAll("/", "-") %>" />
				<input type="hidden" id="data_fine_old_<%=i%>" value="<%=lp.getDataFineString().replaceAll("/", "-") %>" />
  				<input type="hidden" id="cun_old_<%=i%>" 
  					value="<%=lp.getCodiceNazionale()!= null && !lp.getCodiceNazionale().equalsIgnoreCase("")?lp.getCodiceNazionale():"" %>" />
  			</td>
  			<td  align="center">
  				<input type="checkbox" id="checkmodificalinea_<%=i%>" name="checkmodificalinea_<%=i%>" 
  					onclick="verificaEsistenzaControlli(<%=lp.getId_rel_stab_lp()%>,this, '<%=i%>')" value="si">
  			</td>
  			<td>
  				<div id="div_<%=i%>" />
  			</td>
  			
  		</tr>
		<%} %> 
	
</table><hr>
<br><br>
<center>
<button type="submit" class="yellowBigButton" style="width: 250px;">Salva</button>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

<button type="button" class="yellowBigButton" style="width: 250px;" onClick="loadModalWindowCustom('Attendere Prego...'); window.location.href='GestioneAnagraficaAction.do?command=Details&altId=${altId}'">Annulla</button>

</center>
</form>
<br><br>

<input type="hidden" id="select_lista_stati_linea" name="select_lista_stati_linea" value="<%=ListaStati.getHtmlSelect("lista_stati", 0) %>" >

<div id='popuplineeattivita'/>
<script>
function validateForm()
{
	var n_linee = document.getElementById('numero_linee').value;
	var checked = false;
	for(var i=0; i < n_linee; i++){
		if(document.getElementById('checkmodificalinea_' + i).checked == true){
			checked = true;
		}
	}
	
	if(!checked){
		if(confirm("Attenzione! Non hai modificato alcuna linea, tornare al dettaglio dello stabilimento?")==true)
		{
			loadModalWindowCustom('Attendere Prego...'); 
			window.location.href='GestioneAnagraficaAction.do?command=Details&altId=' + document.getElementById('altId').value;		
		}else{
			return false;
		}
	}
	
	for(var i=0; i < n_linee; i++){
		if(document.getElementById('checkmodificalinea_' + i).checked == true){
			for(var j=0; j < n_linee; j++){
					var id_linea_old = document.getElementById('id_linea_produttiva_old_' + j).value;
					var stato_linea_old = document.getElementById('stato_linea_produttiva_old_' + j).value;
					var id_linea_new = document.getElementById('id_linea_produttiva_' + i).value;
					var stato_linea_new = document.getElementById('stato_' + i).value;
					
					
					if(id_linea_old == id_linea_new && stato_linea_old == '0' && stato_linea_new == '0' && i != j){
						alert('Attenzione! Non e\' possibile modificare una linea con un altra già presente ed in stato attivo.');
						return false;
					}
				}
		}
	}
	
	loadModalWindowCustom("Attendere Prego...");
	return true;
}

var fieldCheck ;
var idLinea ;
var numero_riga;
var id_macroarea_old;
var id_aggregazione_old;
var id_attivita_old;
var id_stato_old;
var tipo_carattere_old;
var data_inizio_old;
var data_fine_old;
var cun_old;
var tipo_attivita_fissa;
function verificaEsistenzaControlli(idRelStabLp,field, numeroriga)
{
	if(field.checked==true){
		fieldCheck=field;
		idLinea = idRelStabLp;
		PopolaCombo.getNumeroControlliSuLinea(idRelStabLp,verificaEsistenzaControlliCallback);
		numero_riga = numeroriga;
		id_macroarea_old = document.getElementById('id_macroarea_old_' + numero_riga).value;
		id_aggregazione_old = document.getElementById('id_aggregazione_old_' + numero_riga).value;
		id_attivita_old = document.getElementById('id_attivita_old_' + numero_riga).value;
		id_stato_old = document.getElementById('stato_linea_produttiva_old_' + numero_riga).value;
		tipo_carattere_old = document.getElementById('tipo_carattere_old_' + numero_riga).value;
		data_inizio_old = document.getElementById('data_inizio_old_' + numero_riga).value;
		data_fine_old = document.getElementById('data_fine_old_' + numero_riga).value;
		cun_old = document.getElementById('cun_old_' + numero_riga).value;
		tipo_attivita_fissa = document.getElementById('tipo_attivita_stab').value;
	}else{
		document.getElementById('div_' + numeroriga).innerHTML = "";
	}
				
	
	
}

function verificaEsistenzaControlliCallback(valRet)
{
	if(valRet>0)
		{
		if(confirm("Attenzione sulla linea che si intende variare sono presenti "+valRet+" controlli ufficiali.\nIntendi Continuare?")==true)
			{
				aggiungi_linea();
			}else{
				fieldCheck.checked=false;
			}

	}else{
		aggiungi_linea();
	}
}


$(function() {
	
	 $('#popuplineeattivita').dialog({
		title : 'MODIFICA LINEA DI ATTIVITA',
        autoOpen: false,
        resizable: false,
        closeOnEscape: false,
        width:1200,
        height:550,
        draggable: false,
        modal: true,
	     buttons: {
			 'MODIFICA': function() {   
				var data_inizio_attivita = document.getElementById('data_inizio').value.toString();
				var data_fine_attivita = document.getElementById('data_fine').value.toString();
				var tipo_carat_id = document.getElementById('tipo_carattere').value.toString();
				var cun_nuovo = document.getElementById('cun_popup').value;
				var tipo_carat_testo;
				if (document.getElementById('tipo_carattere').value == '1'){
					tipo_carat_testo = 'PERMANENTE';
				} else {
					tipo_carat_testo = 'TEMPORANEA';
				}
				var cod_univ_ml = document.getElementById('linea_attivita').value;
				var ok_insert_popup = verifica_inserimento_linea(cod_univ_ml, data_inizio_attivita, data_fine_attivita, tipo_carat_id, cun_nuovo);
				if(ok_insert_popup){
					aggiungi_riga(tipo_carat_testo, data_inizio_attivita, data_fine_attivita, cod_univ_ml, tipo_carat_id, cun_nuovo);
	                loadModalWindowUnlock();
					$( this ).dialog('close');
				}
               
			},
			'ANNULLA': function() {
					fieldCheck.checked=false;
                	loadModalWindowUnlock();
					$( this ).dialog('close');
			}
     }
});
	 
});

function aggiungi_linea(){
	var htmlText='<br>';
	htmlText += '<fieldset>'+
					'<legend><b>INDICARE LINEA DI ATTIVITA</b></legend>'+
					'<table style="width:100%;">'+
						'<tr>'+
							'<td colspan="2" width="100%" align="left">'+
								'<div style="width:100%;"></div>'+
							'</td>'+
						'</tr>'+
						'<tr id="tr_macroarea_popup">'+
							'<td style="width:10%" align="left">'+
								'<p>MACROAREA</p>'+
							'</td>'+
							'<td style="width:80%" align="left">'+
								'<select id="macroarea"></select>'+
							'</td>'+
						'</tr>'+
						
						'<tr id="tr_aggregazione_popup">'+
							'<td style="width:10%" align="left">'+
								'<p>AGGREGAZIONE</p>'+
								'</td>'+
								'<td style="width:80%" align="left">'+
									'<select id="aggregazione"></select>'+
								'</td>'+
						'</tr>'+
						
						'<tr id="tr_linea_attivita_popup">'+
							'<td style="width:10%" align="left">'+
								'<p>LINEA ATTIVITA</p>'+
							'</td>'+
							'<td style="width:80%" align="left">'+
								'<select id="linea_attivita"></select>'+
							'</td>'+
						'</tr>'+

						'<tr>'+
							'<td colspan="2" align="left">'+
								'<div></div>'+
							'</td>'+
						'</tr>'+
						
						'<tr id="tr_tipo_carattere_popup">'+
							'<td style="width:10%" align="left">'+
								'<p>TIPO CARATTERE</p>'+
							'</td>'+
							'<td style="width:80%" align="left">'+
								'<select id="tipo_carattere">'+
									'<option value="1">PERMANENTE</option>' +
									'<option value="2">TEMPORANEA</option>' +
								'</select>'+
							'</td>'+
						'</tr>'+
						
						'<tr id="tr_data_inizio_popup">'+
							'<td style="width:15%" align="left">' +
								'<p>DATA INIZIO ATTIVITA</p>' +
							'</td>'+
							'<td style="width:80%" align="left">' +
								'<input placeholder="DATA INIZIO ATTIVITA" type="text" id="data_inizio" autocomplete="off">' +
							 '</td>' +
						 '</tr>' +
						 
						 '<tr id="tr_data_fine_popup">'+
							 '<td style="width:15%" align="left">' +
								'<p>DATA FINE ATTIVITA</p>' +
							'</td>'+
							'<td style="width:80%" align="left">' +
								'<input placeholder="DATA FINE ATTIVITA" type="text" id="data_fine" autocomplete="off">' +
							'</td>'+
						'</tr>'+
						
					'</table>'+
				'</fieldset>'+
				'<br><fieldset id="field_cun">' +
				'<legend><b>DATI AGGIUNTIVI LINEA</b></legend>'+
					'<table style="width:100%;">'+
						'<tr>'+
							'<td colspan="2" align="left">'+
								'<div></div>'+
							'</td>'+
						'</tr>'+
						'<tr id="tr_stato_linea">'+
							'<td style="width:15%" align="left">' +
								'<p>STATO LINEA</p>' +
							'</td>'+
							'<td style="width:80%" align="left">' +
								document.getElementById('select_lista_stati_linea').value +
							 '</td>' +
						 '</tr>' +
						 '<tr id="tr_data_cun">'+
							'<td style="width:15%" align="left">' +
								'<p>CUN</p>' +
							'</td>'+
							'<td style="width:80%" align="left">' +
								'<input placeholder="CUN" type="text" id="cun_popup" autocomplete="off">' +
								'&emsp; <font color="red">' +
								'Attenzione! In caso di OSM RICONOSCIUTI il CUN va inserito senza il carattere ALFA poiche tale carattere viene automaticamente generato dal sistema' +
								'</font>' +
							 '</td>' +
						 '</tr>' +
					
					'</table>'+
				'</fieldset>';
	
	$('#popuplineeattivita').html(htmlText);
	$('#popuplineeattivita').dialog('open');
	//$('#tr_data_fine_popup').css({"visibility":"hidden"});
	popup_date('data_inizio','0');
	popup_date('data_fine','+3Y');
	$('#tipo_carattere').change(function(){
		if(document.getElementById('tipo_carattere').value == '2'){
			$('#data_fine').val(null);
			$('#tr_data_fine_popup').css({"visibility":"visible"});
		} else {
			$('#data_fine').val(null);
			$('#tr_data_fine_popup').css({"visibility":"hidden"});
		}
	});
	
	$('#tipo_carattere').val(tipo_carattere_old);
	$('#data_inizio').val(data_inizio_old);
	
	if(tipo_carattere_old == '2' || data_fine_old != ''){
		$('#data_fine').val(data_fine_old);
		$('#tr_data_fine_popup').css({"visibility":"visible"})
	}else {
		$('#data_fine').val(null);
		$('#tr_data_fine_popup').css({"visibility":"hidden"});
	}
	
	$('#lista_stati').val(id_stato_old);
	$('#cun_popup').val(cun_old);
	
	popola_select_popup('GestioneAnagraficaGetDatiLinea.do?command=Search&tiporichiesta=macroarea'+'&tipoattivita='+tipo_attivita_fissa, 'macroarea');
	popola_select_popup('GestioneAnagraficaGetDatiLinea.do?command=Search&tiporichiesta=aggregazione&idmacroarea='+id_macroarea_old+'&tipoattivita='+tipo_attivita_fissa, 'aggregazione');
	popola_select_popup('GestioneAnagraficaGetDatiLinea.do?command=Search&tiporichiesta=lineaattivita&idaggregazione='+id_aggregazione_old+'&tipoattivita='+tipo_attivita_fissa, 'linea_attivita');
	$('#macroarea').val(id_macroarea_old);
	$('#aggregazione').val(id_aggregazione_old);
	$('#linea_attivita').val(id_attivita_old);
	
	$('#macroarea').change(function(){
		if(document.getElementById('macroarea').value != ''){
			$('#aggregazione').children().remove();
			$('#aggregazione').append('<option value="" selected="selected">SELEZIONA AGGREGAZIONE</option>');
			$('#tr_aggregazione_popup').css({"visibility":"visible"});
			$('#linea_attivita').children().remove();
			$('#linea_attivita').append('<option value="" selected="selected">SELEZIONA LINEA ATTIVITA</option>');
			$('#tr_linea_attivita_popup').css({"visibility":"hidden"});
			popola_select_popup('GestioneAnagraficaGetDatiLinea.do?command=Search&tiporichiesta=aggregazione&idmacroarea='+
					document.getElementById('macroarea').value+'&tipoattivita='+tipo_attivita_fissa, 'aggregazione');
		}else{
			$('#aggregazione').children().remove();
			$('#aggregazione').append('<option value="" selected="selected">SELEZIONA AGGREGAZIONE</option>');
			$('#tr_aggregazione_popup').css({"visibility":"hidden"});
			$('#linea_attivita').children().remove();
			$('#linea_attivita').append('<option value="" selected="selected">SELEZIONA LINEA ATTIVITA</option>');
			$('#tr_linea_attivita_popup').css({"visibility":"hidden"});
		}
	});
	
	$('#aggregazione').change(function(){
		if(document.getElementById('aggregazione').value != ''){
			$('#linea_attivita').children().remove();
			$('#linea_attivita').append('<option value="" selected="selected">SELEZIONA LINEA ATTIVITA</option>');
			$('#tr_linea_attivita_popup').css({"visibility":"visible"});
			popola_select_popup('GestioneAnagraficaGetDatiLinea.do?command=Search&tiporichiesta=lineaattivita&idaggregazione='+
					document.getElementById('aggregazione').value+'&tipoattivita='+tipo_attivita_fissa, 'linea_attivita');
		}else{
			$('#linea_attivita').children().remove();
			$('#linea_attivita').append('<option value="" selected="selected">SELEZIONA LINEA ATTIVITA</option>');
			$('#tr_linea_attivita_popup').css({"visibility":"hidden"});
			
		}
	});
}


function popola_select_popup(urlservice, id_elemento){
	
	loadModalWindow();
 	$.ajax({  	    
       url: urlservice,
       dataType: "text",
       async:false,
       success: function(dati) { 	 
	   	    var obj;
	   	    try {
				console.log(dati);
	       		obj = JSON.parse(dati);
			} catch (e) {
				alert(e instanceof SyntaxError); // true
				loadModalWindowUnlock();
				return false;
			}
			
			obj = JSON.parse(dati);	  	
		  	for (var i = 0; i < obj.length; i++) {
		  		$('#'+id_elemento).append('<option value="'+obj[i].code+'">'+obj[i].description+'</option>');
		  	}
		  	loadModalWindowUnlock();
       },
       fail: function(xhr, textStatus, errorThrown){
       	alert('request failed');
      	}
         
 	});
 	
}

function popup_date(elemento_html_data,max_data){
	$( '#' + elemento_html_data ).datepicker({
		  dateFormat: 'dd-mm-yy',
		  changeMonth: true,
		  changeYear: true,
		  yearRange: '-100:+3',
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

function verifica_inserimento_linea(cod_univ_ml, data_inizio_attivita, data_fine_attivita, tipo_carattere_id, cun_popup_inserito){
	var esito = false;
	var messagioerrore = '';
	var esitocun = false;
	
	if(tipo_carattere_id == '1'){
		if(cod_univ_ml != '' && data_inizio_attivita != ''){
			esito = true;
		}else{
			messagioerrore = 'selezionare i campi obbligatori';	
			esito = false;
		}
	}else if(tipo_carattere_id == '2'){
		if(cod_univ_ml != '' && data_inizio_attivita != '' && data_fine_attivita != ''){
			
			var arr1 = data_inizio_attivita.split("-");
			var arr2 = data_fine_attivita.split("-");
			
			var d1 = new Date(arr1[2],arr1[1]-1,arr1[0]);
			var d2 = new Date(arr2[2],arr2[1]-1,arr2[0]);
			
			var r1 = d1.getTime();
			var r2 = d2.getTime();
			
			var diff = r2 - r1;

			if(diff < 0){
				messagioerrore = 'la data inizio attivita non puo essere successiva alla data fine attivita';
				esito = false;
			} else {
				esito = true;
			}
			
		}else{
			messagioerrore = 'selezionare i campi obbligatori';
			esito = false;
		}
	}
	
	
	var url = "CunRichiesto.do?command=Search&codiceLinea=" + cod_univ_ml;
	
	var request = $.ajax({
		url : url,
		async: false,
		dataType : "json"
	});

	request.done(function(result) {
		
		if(result.cun_obbligatorio == '1'){
			if(trim(cun_popup_inserito) != ''){
				esitocun = true;
			}else{
				messagioerrore = 'Attenzione! La linea selezionata richiede obbligatoriamente il cun';
				document.getElementById('cun_popup').value = cun_old;
				esitocun = false;
			}
		}else{
			esitocun = true;
		}
	});
	request.fail(function(jqXHR, textStatus) {
		console.log('Error');
		
	});

	if (esito && esitocun){
		if(trim(cun_popup_inserito) == trim(cun_old)){
			return true;
		}else if(verificaEsistenzaCun(document.getElementById('cun_popup'))){
			return true;
		}else{
			document.getElementById('cun_popup').value = cun_old;
			return false;
		}
		
	}else{
		alert(messagioerrore);
		return false;
	}
}


function aggiungi_riga(tipo_carattere, data_inizio_attivita, data_fine_attivita, codice_univoco, tipo_carattere_id, cun_nuovo){
	var urlservice = "GestioneAnagraficaGetDatiLinea.do?command=Search&tiporichiesta=datilineaattivita&idlineaattivita=" + codice_univoco;
	loadModalWindow();
 	$.ajax({  	    
       url: urlservice,
       dataType: "text",
       async:false,
       success: function(dati) { 	 
	   	    var obj;
	   	    try {
				console.log(dati);
	       		obj = JSON.parse(dati);
			} catch (e) {
				alert(e instanceof SyntaxError); // true
				loadModalWindowUnlock();
				return false;
			}
			
			obj = JSON.parse(dati);	  	
		  	for (var i = 0; i < obj.length; i++) {
		  		aggiungi_riga_gui(
		  				obj[i].macroarea, 
		  				obj[i].aggregazione, 
		  				obj[i].attivita, 
		  				tipo_carattere, 
		  				data_inizio_attivita, 
		  				data_fine_attivita, 
		  				obj[i].codice.replace(/[?]/g, '-'), 
		  				tipo_carattere_id,
		  				obj[i].id,
		  				cun_nuovo)
		  	}
		  	loadModalWindowUnlock();
       },
       fail: function(xhr, textStatus, errorThrown){
       	alert('request failed');
      	}
         
 	});
}

function aggiungi_riga_gui(macroarea, aggregazione, attivita, tipo_carattere, data_inizio_attivita, 
							data_fine_attivita, codice_univoco, tipo_carattere_id, id_linea, cun_nuovo){
		
		var stato = document.getElementById('lista_stati').value;		
		var stato_testo = document.getElementById('lista_stati').options[document.getElementById('lista_stati').selectedIndex].innerHTML;
		var html_testo_modifica = "";
		var tipo_attivita_label = "";
		if (tipo_attivita_fissa == "1"){
			tipo_attivita_label = "CON SEDE FISSA";
		} else {
			tipo_attivita_label = "SENZA SEDE FISSA";
		}
		
		html_testo_modifica = html_testo_modifica +
								'<input type="hidden" id="id_linea_produttiva_' +numero_riga+ '" name="id_linea_produttiva_' +numero_riga+ '" value="'+id_linea+'">' +
								'<input type="hidden" id="data_inizio_' +numero_riga+ '" name="data_inizio_' +numero_riga+ '" value="'+data_inizio_attivita+'">' +
								'<input type="hidden" id="tipo_carattere_' +numero_riga+ '" name="tipo_carattere_' +numero_riga+ '" value="'+tipo_carattere_id+'">' +
								'<input type="hidden" id="stato_' +numero_riga+ '" name="stato_' +numero_riga+ '" value="'+stato+'">' +
								'<input type="hidden" id="cun_' +numero_riga+ '" name="cun_' +numero_riga+ '" value="'+cun_nuovo+'">' +
								'<span>'+macroarea+
								'<br>->'+aggregazione+
								'<br>->'+attivita+
								
								'<br><br>tipo attivita: &emsp;<b>' + tipo_attivita_label + '</b>' +
								'<br>tipo carattere: &emsp;<b>' + tipo_carattere + '</b>' +
								'<br>data inizio attivita: &emsp;<b>' + data_inizio_attivita + '</b>';
		
		if(tipo_carattere_id == '2' || data_fine_old != '')
		{
			html_testo_modifica = html_testo_modifica + 
								'<br>data fine attivita: &emsp;<b>' + data_fine_attivita + '</b>'+
								'<br>stato: &emsp;<b>' + stato_testo + '</b>'+
								'<br>cun: &emsp;<b>' + cun_nuovo +'</b></span>' +
								'<input type="hidden" id="data_fine_' +numero_riga+ '" name="data_fine_' +numero_riga+ '" value="'+data_fine_attivita+'">';
		}else{
			html_testo_modifica = html_testo_modifica + 
								'<br>stato: &emsp;<b>' + stato_testo + '</b>' + 
								'<br>cun: &emsp;<b>' + cun_nuovo +'</b></span>';
		}
		document.getElementById('div_' + numero_riga).innerHTML = html_testo_modifica;
}

function trim(str) {
    try {
        if (str && typeof(str) == 'string') {
            return str.replace(/^\s*|\s*$/g, "");
        } else {
            return '';
        }
    } catch (e) {
        return str;
    }
}

</script>