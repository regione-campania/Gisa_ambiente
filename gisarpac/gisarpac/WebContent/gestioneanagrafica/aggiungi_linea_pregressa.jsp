<%@page import="org.aspcfs.modules.opu.base.LineaProduttiva"%>
<%@ page import="java.util.*,java.text.DateFormat,org.aspcfs.modules.accounts.base.*,org.aspcfs.modules.opu.base.*,org.aspcfs.modules.contacts.base.*,org.aspcfs.modules.base.Constants" %>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="StabilimentoDettaglio" class="org.aspcfs.modules.opu.base.Stabilimento" scope = "request"/>
<jsp:useBean id="ListaStati" class="org.aspcfs.utils.web.LookupList" scope="request"/>

<script  src="dwr/interface/PopolaCombo.js"> </script>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>
<script src="javascript/noscia/addNoScia.js"></script>

<table class="trails" cellspacing="0">
	<tr>
		<td>
			<a href="GestioneAnagraficaAction.do?command=ListaPraticheStabilimenti">Gestione Anagrafica</a> > 
			<a href="GestioneAnagraficaAction.do?command=Details&altId=${altId}">SCHEDA</a> > AGGIUNGI LINEA PREGRESSA	
		</td>
	</tr>
</table>

<form class="form-horizontal" role="form" method="post" action="GestioneAnagraficaAction.do?command=AddLineaPregressa" onsubmit="return validateForm();">
<b>MODIFICA SCHEDA: AGGIUNGI LINEA PREGRESSA</b><br>
<input type="hidden" id="stabId" name="stabId" value="<%=StabilimentoDettaglio.getIdStabilimento()%>"/>
<input type="hidden" id="altId" name="altId" value="<%=StabilimentoDettaglio.getAltId()%>"/>
<input type="hidden" id="tipo_attivita_stab" value="<%=StabilimentoDettaglio.getTipoAttivita() %>"/>
<input type="hidden" id="numero_linee" name="numero_linee" value="<%=StabilimentoDettaglio.getListaLineeProduttive().size()%>"/>

<table class="details" cellspacing="0" border="0" width="100%" cellpadding="4">
<tbody>
	<tr>
		<th colspan="2">Riepilogo</th>
	</tr>
	<tr>
		<td class="formLabel">Numero registrazione</td>
		<td><%=StabilimentoDettaglio.getNumero_registrazione()%></td>
	</tr>
	<tr>
		<td class="formLabel">Ragione Sociale Impresa</td>
		<td><%=StabilimentoDettaglio.getOperatore().getRagioneSociale()%></td>
	</tr>
	<tr>
		<td class="formLabel">Data inizio attivita'</td>
		<td><%=StabilimentoDettaglio.getDataInizioAttivitaString().replaceAll("/", "-")%>
		<input type="hidden" id="data_inizio_stab" name="data_inizio_stab" value="<%=StabilimentoDettaglio.getDataInizioAttivitaString().replaceAll("/", "-") %>">
		</td>
	</tr>
	<tr>
		<td class="formLabel">Linee produttive</td>
		<td>
			<table class="details" cellspacing="0" border="0" width="100%" cellpadding="4"> 
				<% 
				for(int i = 0; i < StabilimentoDettaglio.getListaLineeProduttive().size(); i++ ){ %>
			  		<%LineaProduttiva lp = (LineaProduttiva) StabilimentoDettaglio.getListaLineeProduttive().get(i); %>
			  		<tr>
			  			<td style="width:10%">
			  				<%=lp.getNumeroRegistrazione() %>
			  			</td>
			  			<td>
			  				<div id="div_linee_<%=i%>" ></div>
			  				<input type="hidden" id="linea_<%=i%>" name="linea_<%=i%>" value="<%=lp.getDescrizione_linea_attivita() %>" >
			  				<input type="hidden" id="id_lp_<%=i%>" name="id_lp_<%=i%>" value="<%=lp.getId()%>">
			  			</td>	
			  		</tr>
					<%} %> 
				
			</table>
		</td>
	</tr>
	
	<tr>
		<td class="formLabel">Aggiungi linea pregressa</td>
		<td>
			<table class="details" cellspacing="0" border="0" width="100%" cellpadding="4">
				
				<tr id="tr_macroarea">
					<td style="width:10%"> <p>MACROAREA</p> </td>
					<td>
						<select id="macroarea"><option value="" selected="selected">SELEZIONA MACROAREA</option></select>
					</td>
				</tr>
						
				<tr id="tr_aggregazione">
					<td style="width:10%"> <p>AGGREGAZIONE</p> </td>
						<td>
							<select id="aggregazione"><option value="" selected="selected">SELEZIONA AGGREGAZIONE</option></select>
						</td>
				</tr>
					
				<tr id="tr_linea_attivita">
					<td style="width:10%"> <p>LINEA ATTIVITA'</p> </td>
					<td>
						<select id="linea_attivita" name="linea_attivita"><option value="" selected="selected">SELEZIONA LINEA ATTIVITA'</option></select>
					</td>
				</tr>
					<td style="width:10%"> <p>LINEA SELEZIONATA</p> </td>
					<td id="desc_linea_selezionata"></td>
				<tr>
					
				</tr>
				
				<tr>
					<td style="width:10%"> <p>TIPO CARATTERE</p> </td>
					<td>
						<select id="tipo_carattere">
							<option value="1">PERMANENTE</option>
							<option value="2">TEMPORANEA</option>
						</select>
					</td>
				</tr>
						
				<tr id="tr_data_inizio">
					<td style="width:10%"> <p>DATA INIZIO ATTIVITA</p> </td>
					<td>
						<input placeholder="DATA INIZIO ATTIVITA" type="text" id="data_inizio" name="data_inizio" autocomplete="off" required="true">
					</td>
				 </tr>
						 
				 <tr id="tr_data_fine">
					 <td style="width:10%"> <p>DATA FINE ATTIVITA</p> </td>
					<td>
						<input placeholder="DATA FINE ATTIVITA" type="text" id="data_fine" name="data_fine" autocomplete="off">
					</td>
				 </tr>
				
				<tr id="tr_cun_linea_pregressa">
					 <td style="width:10%"> <p>CUN</p> </td>
					<td>
						<input placeholder="CUN" type="text" id="cun_linea_pregressa" name="cun_linea_pregressa" autocomplete="off" value="">
					</td>
				 </tr>	
			</table>
		</td>
	</tr>
	
</tbody>
</table>
<br><br>
<center>
<button type="submit" class="yellowBigButton" style="width: 250px;">Salva</button>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

<button type="button" class="yellowBigButton" style="width: 250px;" onClick="loadModalWindowCustom('Attendere Prego...'); window.location.href='GestioneAnagraficaAction.do?command=Details&altId=${altId}'">Annulla</button>

</center>
</form>
<br><br>

<script>

function validateForm(){
	
	for(var i=0; i< document.getElementById('numero_linee').value; i++){
		if(document.getElementById('id_lp_' + i).value ==document.getElementById('linea_attivita').value ){
			alert('La linea selezionata � gi� presente sullo stabilimento!');
			return false;
		}
	}
	
	if(document.getElementById('linea_attivita').value == ''){
		alert('Attenzione! Selezionare una linea');
		return false;
	}
	
	if(document.getElementById('tipo_carattere').value == '2')
	{
	
		var data_iniziale = document.getElementById('data_inizio').value;
		var data_finale = document.getElementById('data_fine').value;
		
		if(data_finale == ''){
			alert('Attenzione! per attivita temporanea bisogna inserire la data fine attivita');
			return false;
		}

		var arr1 = data_iniziale.split("-");
		var arr2 = data_finale.split("-");

		var d1 = new Date(arr1[2],arr1[1]-1,arr1[0]);
		var d2 = new Date(arr2[2],arr2[1]-1,arr2[0]);

		var r1 = d1.getTime();
		var r2 = d2.getTime();
		var diff = r2 - r1;

		if(diff < 0){
			alert('la data inizio attivita non puo essere successiva alla data fine attivita');
			return false;
		}
	}
	
	var url = "CunRichiesto.do?command=Search&codiceLinea=" + document.getElementById('linea_attivita').value;
	var cun_richiesto = false;
	var request = $.ajax({
		url : url,
		async: false,
		dataType : "json"
	});

	request.done(function(result) {
		if(result.cun_obbligatorio == '1'){
			if(trim(document.getElementById('cun_linea_pregressa').value) == ''){
				
				cun_richiesto = true;
			}
		}
	});
	request.fail(function(jqXHR, textStatus) {
		console.log('Error');
		
	});
	
	if(cun_richiesto){
		alert('Attenzione! La linea selezionata richiede obbligatoriamente il cun');
		return false;
	}
	
	if(!verificaEsistenzaCun(document.getElementById('cun_linea_pregressa'))){
		return false;
	}
	
	loadModalWindowCustom('Attendere Prego...'); 
	return true;
}

for(var i=0; i< document.getElementById('numero_linee').value; i++){
	var desc = document.getElementById('linea_' + i).value;
	var res = desc.split("->");
	document.getElementById('div_linee_' + i).innerHTML = res[0] + '-><br>' + res[1] + '-><br>' + res[2];
}

$('#aggregazione').prop("disabled",true);
$('#linea_attivita').prop("disabled",true);
$('#data_fine').prop("disabled",true);
popup_date('data_inizio', '-100Y', '0');
popup_date('data_fine', '-100Y', '+3Y');
$('#tipo_carattere').change(function(){
	if(document.getElementById('tipo_carattere').value == '2'){
		$('#data_fine').val(null);
		$('#data_fine').prop("disabled",false);
	} else {
		$('#data_fine').val(null);
		$('#data_fine').prop("disabled",true);
	}
});

popola_select_linea('GestioneAnagraficaGetDatiLinea.do?command=Search&tiporichiesta=macroarea'+'&tipoattivita='
			+document.getElementById('tipo_attivita_stab').value, 'macroarea');

$('#macroarea').change(function(){
	if(document.getElementById('macroarea').value != ''){
		$('#aggregazione').prop("disabled",false);
		$('#aggregazione').children().remove();
		$('#aggregazione').append('<option value="" selected="selected">SELEZIONA AGGREGAZIONE</option>');
		popola_select_linea('GestioneAnagraficaGetDatiLinea.do?command=Search&tiporichiesta=aggregazione&idmacroarea='+
				document.getElementById('macroarea').value+'&tipoattivita='
				+document.getElementById('tipo_attivita_stab').value, 'aggregazione');
		$('#linea_attivita').prop("disabled",true);
		$('#linea_attivita').children().remove();
		$('#linea_attivita').append('<option value="" selected="selected">SELEZIONA LINEA ATTIVITA</option>');
		document.getElementById('desc_linea_selezionata').innerHTML = '';
		
	}else{
		$('#aggregazione').prop("disabled",true);
		$('#aggregazione').children().remove();
		$('#aggregazione').append('<option value="" selected="selected">SELEZIONA AGGREGAZIONE</option>');
		$('#linea_attivita').prop("disabled",true);
		$('#linea_attivita').children().remove();
		$('#linea_attivita').append('<option value="" selected="selected">SELEZIONA LINEA ATTIVITA</option>');
		document.getElementById('desc_linea_selezionata').innerHTML = '';
		
	}
});

$('#aggregazione').change(function(){
	if(document.getElementById('aggregazione').value != ''){
		$('#linea_attivita').children().remove();
		$('#linea_attivita').append('<option value="" selected="selected">SELEZIONA LINEA ATTIVITA</option>');
		$('#linea_attivita').prop("disabled",false);
		popola_select_linea('GestioneAnagraficaGetDatiLinea.do?command=Search&tiporichiesta=lineaattivita&idaggregazione='+
				document.getElementById('aggregazione').value+'&tipoattivita='
				+document.getElementById('tipo_attivita_stab').value, 'linea_attivita');
		document.getElementById('desc_linea_selezionata').innerHTML = '';
	}else{
		$('#linea_attivita').children().remove();
		$('#linea_attivita').append('<option value="" selected="selected">SELEZIONA LINEA ATTIVITA</option>');
		$('#linea_attivita').prop("disabled",true);
		document.getElementById('desc_linea_selezionata').innerHTML = '';
		
	}
});

$('#linea_attivita').change(function(){
	if(document.getElementById('linea_attivita').value != ''){
		document.getElementById('desc_linea_selezionata').innerHTML = '<b>' +
			document.getElementById('macroarea').options[document.getElementById('macroarea').selectedIndex].innerHTML + '-><br>' +
			document.getElementById('aggregazione').options[document.getElementById('aggregazione').selectedIndex].innerHTML + '-><br>' +
			document.getElementById('linea_attivita').options[document.getElementById('linea_attivita').selectedIndex].innerHTML + '</b>';
	}else{
		document.getElementById('desc_linea_selezionata').innerHTML = '';
	}
});

function popola_select_linea(urlservice, id_elemento){
	
	
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
				
				return false;
			}
			
			obj = JSON.parse(dati);	  	
		  	for (var i = 0; i < obj.length; i++) {
		  		$('#'+id_elemento).append('<option value="'+obj[i].code+'">'+obj[i].description+'</option>');
		  	}
		  	
       },
       fail: function(xhr, textStatus, errorThrown){
       	alert('request failed');
      	}
         
 	});
 	
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
