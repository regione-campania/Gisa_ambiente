<%@ page import="java.util.*,java.text.DateFormat,org.aspcfs.modules.accounts.base.*,org.aspcfs.modules.opu.base.*,org.aspcfs.modules.contacts.base.*,org.aspcfs.modules.base.Constants" %>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="StabilimentoDettaglio" class="org.aspcfs.modules.opu.base.Stabilimento" scope = "request"/>


<script src="javascript/vendor/moment.min.js"></script>
<script src="javascript/noscia/addNoScia.js"></script>
<script type="text/javascript" src="dwr/interface/SuapDwr.js"> </script>
<script type="text/javascript" src="dwr/interface/DWRnoscia.js"> </script>

<script  src="dwr/interface/PopolaCombo.js"> </script>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>

<script src="javascript/gestioneanagrafica/add.js"></script>

<table class="trails" cellspacing="0">
	<tr>
		<td>
			<a href="GestioneAnagraficaAction.do?command=ListaPraticheStabilimenti">PRATICHE SUAP 2.0</a> > NUOVA PRATICA
		</td>
	</tr>
</table>

<form id="inserimentoPratica" name="inserimentoPratica" class="form-horizontal" role="form" method="post" action="" >
<br>
<input type="hidden" id="stabId" name="stabId" value="<%=StabilimentoDettaglio.getIdStabilimento()%>"/>
<input type="hidden" id="altId" name="altId" value="<%=StabilimentoDettaglio.getAltId()%>"/>
<input type="hidden" id="aslUtente" value="<%=User.getSiteId()%>"/>
<input type="hidden" id="idAggiuntaPratica" name="idAggiuntaPratica" value="<%=System.currentTimeMillis() %><%=new Random().nextInt(10000) %>"/>

<!-- 
<center>
<div style="border: 1px solid black; background: #BDCFFF">
Numero Pratica: 
<input type="radio" id="numeroPraticaAutomatico" name="numeroPraticaSelezione" value="automatico" checked onClick="mostraNascondiNumeroPratica(this.value)"/> Genera automaticamente
<input type="radio" id="numeroPraticaManuale" name="numeroPraticaSelezione" value="manuale" onClick="mostraNascondiNumeroPratica(this.value)"/> Inserisci manualmente 
<input type="text" id="numeroPratica" name="numeroPratica" size="25" maxlength="25" autocomplete="off"
	style="visibility:hidden" onblur="controllaEsistenzaNumeroPratica(this.value.trim())"/>
</div>
</center>
<br/>
 -->
<table id="tabella_crea_pratica" class="details" cellspacing="0" border="0" width="100%" cellpadding="4">
<tbody>
	<tr>
		<th colspan="4">Dati pratica</th>
	</tr>
	<tr>
		<th style="text-align:center; width:25%;"><p>NUMERO PRATICA</p></th>
		<th style="text-align:center; width:25%;"><p>COMUNE</p></th>
		<th style="text-align:center; width:25%;"><p>DATA PEC</p></th>
		<th style="text-align:center; width:25%;"><p>TIPO PRATICA</p></th>
	</tr>
	<tr>
		<td style="text-align:center;">
			<p><input type="text" id="numeroPratica" name="numeroPratica" size="40" autocomplete="off" /></p>
		</td>
	
		<td style="text-align:center;">
			<%if(StabilimentoDettaglio.getIdStabilimento() > 0){ %>
				<select id="comune_richiedente" name="comune_richiedente" >
					<option value="<%=StabilimentoDettaglio.getSedeOperativa().getComune()%>"><%=StabilimentoDettaglio.getSedeOperativa().getComuneTesto()%></option>
				</select>
				<input type="hidden" id="comune_stab_recuperato" value="<%=StabilimentoDettaglio.getSedeOperativa().getComune()%>" >
				<input type="hidden" id="comune_stab_recuperato_nome" value="<%=StabilimentoDettaglio.getSedeOperativa().getComuneTesto()%>" >
			<%} else {%>
				<select id="comune_richiedente" name="comune_richiedente" onchange="cambio_comune_richiedente();">
				</select>
			<%} %>
		</td>
	
		<td style="text-align:center;">
			<input placeholder="DATA PEC" type="text" id="data_richiesta" name="data_richiesta" autocomplete="off" size="15" style="text-align:center;" required>
		</td>

		<td style="text-align:center;"> 
		
		<%if(StabilimentoDettaglio.getIdStabilimento() == 0){ %>
			<select id="idTipologiaPratica" name="idTipologiaPratica" onchange="visualizza_piva()">
					<option value="1">NUOVO STABILIMENTO</option>
					<option value="2">AMPLIAMENTO</option>
					<option value="3">CESSAZIONE</option>
					<option value="4">VARIAZIONE TITOLARITA'</option>
					<option value="6">MODIFICA STATO DEI LUOGHI</option>
					<option value="7">TRASFERIMENTO SEDE</option>
				</select> 
			<%} else {%>
				<select id="idTipologiaPratica" name="idTipologiaPratica">
					<option value="2">AMPLIAMENTO</option>
					<option value="3">CESSAZIONE</option>
					<option value="4">VARIAZIONE TITOLARITA'</option>
					<option value="6">MODIFICA STATO DEI LUOGHI</option>
					<option value="7">TRASFERIMENTO SEDE</option>
				</select> 
			<%} %>
		</td>
	</tr>
	
	<tr id="tr_riepilogo_stab_sez" style="display: none">
		<th colspan="4">dati impresa/stabilimento</th>
	</tr>
	
	<tr id="tr_dati_cerca_stab" style="display: none">
		<td class="formLabel"><p>Partita Iva/Codice fiscale impresa</p></td>
		<td colspan="3">
			<input type="text" id="partita_iva" title="inserire 11 caratteri numerici"  maxlength="11" />
			<input type="button" value="cerca stabilimento" onclick="cerca_stabilimento_suap();"/> 		
		</td>
	</tr>

	<tr id="tr_riepilogo_stab" style="display: none">
		<td class="formLabel"><p>RIEPILOGO STABILIMENTO SELEZIONATO</p></td>
		<td colspan="3"><div id="riepilogo_stab"></div> </td>
	</tr>
	
	<tr id="button_aggiungi_allegati">
		<th colspan="4">lista allegati &nbsp;&nbsp;&nbsp;<input type="button" value="seleziona allegati" onclick="apri_lista_allegati();"/></th>
	</tr>
		
</tbody>
</table>
<br><br>


<!-- 
<button type="submit" class="btn btn-primary" style="width: 250px;" onclick="salva_pratica('2')">Salva ed inserisci nuova pratica</button>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
-->
<table width="100%" cellpadding="4">
<tr>
	<td align="left">
		<input type="button" class="yellowBigButton" style="width: 250px;" 
			onclick="salva_pratica('3')" value="Salva temporaneo" />
	</td>
	<td align="center">
		<input type="button" class="yellowBigButton" style="width: 450px; height: 70px;" 
			onclick="salva_pratica('1')" value="Salva e continua"/>
	</td>
	<td align="right">
		<input type="button" class="yellowBigButton" style="width: 250px;"
			onClick="loadModalWindowCustom('Attendere Prego...'); window.location.href='GestioneAnagraficaAction.do?command=ListaPraticheStabilimenti'"
			value="Annulla"/>
	</td>
</tr>
</table>


<input type="hidden" id="tipo_output"  name="tipo_output"/>
</form>

<br><br>

<div id='dialogstabilimenti'/>
<div id='popup_lista_allegati' />
<script src="javascript/gestioneanagrafica/lista_allegati_pratica.js"></script>
<script>

var numero_pratica = '';
var comune_pratica = '';
function validateForm(){

	if(document.getElementById("numeroPratica").value.trim() == ''){
		
		if (confirm('Attenzione: non hai inserito il numero pratica, il sistema ne genererà automaticamente uno!') == false){
			return false;
		}
	}
	
	if(document.getElementById('data_richiesta').value.trim() == ''){
		alert('inserire data pec');
		return false;
	}
	
	controllaEsistenzaNumeroPratica(document.getElementById("numeroPratica").value.trim(), document.getElementById("comune_richiedente").value);
	
	if(numero_pratica == document.getElementById("numeroPratica").value.trim() 
				&& comune_pratica == document.getElementById("comune_richiedente").value){
		
		var alertmess = "Numero pratica "  + numero_pratica + 
						" non utilizzabile perchè risulta già assegnato ad un'altra pratica.\n" +
						"Per visualizzare i dettagli del numero pratica inserito andare in RICERCA PRATICA."; 
		alert(alertmess);
		document.getElementById("numeroPratica").value = "";
		return false;
	}
	
	var campi = document.getElementById("inserimentoPratica").getElementsByTagName("input"); 
	for (var x = 0; x<campi.length; x++){
		var campo = campi[x];
		if (campo.name.includes("header_")>0 && campo.value == ''){
			alert('Attenzione. Allegare tutta la documentazione richiesta.');
			return false;
		}
	}
	
	loadModalWindowCustom("Attendere Prego...");
	return true;
	
}

function salva_pratica(scelta_output){
	
	document.getElementById('tipo_output').value = scelta_output;
	document.getElementById('inserimentoPratica').action = "GestioneAnagraficaAction.do?command=InserisciPratica";
	if(validateForm()){
		document.getElementById('inserimentoPratica').submit();
	}
	
}

function visualizza_piva(){
	if (document.getElementById('idTipologiaPratica').value == '1'){
		document.getElementById('tr_riepilogo_stab_sez').style='display: none';
		document.getElementById('tr_dati_cerca_stab').style='display: none';
		document.getElementById('tr_riepilogo_stab').style='display: none';
		document.getElementById('stabId').value = '0';
		document.getElementById('altId').value = '-1';
	}else{
		document.getElementById('tr_riepilogo_stab_sez').style='display: block inline-block';
		document.getElementById('tr_dati_cerca_stab').style='display: block inline-block';
		document.getElementById('partita_iva').value = '';	
		document.getElementById('stabId').value = '0';
		document.getElementById('altId').value = '-1';
		document.getElementById('tr_riepilogo_stab').style='display: block inline-block';
		document.getElementById('riepilogo_stab').innerHTML = '<span></span>';
	}
}


popup_date('data_richiesta');


function popup_date(elemento_html_data){
	$( '#' + elemento_html_data ).datepicker({
		  dateFormat: 'dd-mm-yy',
		  changeMonth: true,
		  changeYear: true,
		  yearRange: '-100:+3',
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



if(document.getElementById('stabId').value == '0' ){
	popola_select_popup('GetComuneByAsl.do?command=Search&idAsl='+document.getElementById('aslUtente').value , 'comune_richiedente');
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
			$('#'+id_elemento).children().remove();
		  	for (var i = 0; i < obj.length; i++) {
		  		$('#'+id_elemento).append('<option value="'+obj[i].id+'">'+obj[i].nome+'</option>');
		  	}
		  	loadModalWindowUnlock();
        },
        fail: function(xhr, textStatus, errorThrown){
        	alert('request failed');
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


function controllaEsistenzaNumeroPratica(numeroPratica, comune_ric)
{
	loadModalWindowCustom('Verifica esistenza pratica in corso. Attendere...');
	DWRnoscia.controlloEsistenzaNumeroPratica(numeroPratica,comune_ric,{callback:controllaEsistenzaNumeroPraticaCallBack,async:false});
}

function controllaEsistenzaNumeroPraticaCallBack(val)
{	
	var aslutente = trim(document.getElementById("aslUtente").value);
	var dati = val;
	var objresp;
	objresp = JSON.parse(dati);
	var len = objresp.length;
	if (len > 0){
		
		var praticaobj;
		praticaobj = objresp[0];
		
		numero_pratica = praticaobj.numero_pratica;
		comune_pratica = praticaobj.id_comune_richiedente;
		loadModalWindowUnlock();	
		
	} else {
		loadModalWindowUnlock();
		}
}



var objStab;
function cerca_stabilimento_suap()
{
	var partita_iva = document.getElementById('partita_iva').value;
	var comune = document.getElementById('comune_richiedente').value;
	document.getElementById('stabId').value = '0';
	document.getElementById('altId').value = '-1';
	document.getElementById('riepilogo_stab').innerHTML = '<span></span>';
	if (trim(partita_iva.toString()) != ''){
		loadModalWindowCustom('Ricerca stabilimento in corso. Attendere');
		DWRnoscia.cercaStabilimentoPraticaSuap(partita_iva, comune, {callback:recuperaDatiStabilimentoCallBack,async:true});
	}else{
		alert('inserire una partita iva!');
	}
}
   
$(function() {
	
	 $('#dialogstabilimenti').dialog({
		title : 'RISULTATI RICERCA STABILIMENTO CON LA PARTITA IVA INSERITA : ',
         autoOpen: false,
         resizable: false,
         closeOnEscape: false,
         width:850,
         height:350,
         draggable: false,
         modal: true,
	     buttons: {
			 'STABILIMENTO SELEZIONATO': function() {
				var stabilimentoDaInserire = getRadioValue('radiostabsele'); 
				selezionaStabilimento(stabilimentoDaInserire);
                                loadModalWindowUnlock();
				$( this ).dialog('close');
			},
			'ESCI': function() {
                                loadModalWindowUnlock();
				$( this ).dialog('close');
			}
      }
 });
	 
});

function getRadioValue(theRadioGroup)
{
    var elements = document.getElementsByName(theRadioGroup);
    for (var i = 0, l = elements.length; i < l; i++)
    {
        if (elements[i].checked)
        {
            return elements[i].value;
        }
    }
}
	
function recuperaDatiStabilimentoCallBack(returnValue)
{
	var dati = returnValue;
	var obj;
	obj = JSON.parse(dati);
	objStab = obj;
	var len = obj.length;
	if (len > 0){
		var htmlText='<br>'; 
		htmlText+='<table border=\'1\' cellpadding=\'4\'><tr><th>RAGIONE SOCIALE</th><th>Partita IVA/Codice fiscale impresa</th><th>INDIRIZZO</th><th>NUMERO REGISTRAZIONE</th><th></th></tr>';
		for (i = 0; i < len; i++){
			htmlText+='<tr><td align=\'center\'>' + obj[i].ragione_sociale + 
							'</td><td align=\'center\'>' + obj[i].partita_iva + 
							'</td><td align=\'center\'>' + obj[i].indirizzo + 
							'</td><td align=\'center\'>' + obj[i].numero_registrazione + 
					  		'</td><td align=\'center\'><input type=\'radio\' id=\'radiostabsele\' name=\'radiostabsele\' value=\''+i+'\'></td></tr>';
		}
		htmlText+='</table>';
        $('#dialogstabilimenti').html(htmlText);
        $('#dialogstabilimenti').dialog('open');
		
	} else {
				alert('Attenzione, nessuno stabilimento trovato per il comune e la partita iva inseriti!!!');
                loadModalWindowUnlock();
        }
	
}

function selezionaStabilimento(stabilimentoScelto){
	var obj = objStab[stabilimentoScelto];
	document.getElementById('stabId').value = obj.stabid;
	document.getElementById('altId').value = obj.altid;
	
	document.getElementById('riepilogo_stab').innerHTML = '<span>' + 
														  '<b>ragione sociale</b>: ' + obj.ragione_sociale + 
														  '<br><b>partita iva/Codice fiscale impresa</b>: ' + obj.partita_iva + 
														  '<br><b>indirizzo stabilimento</b>: ' + obj.indirizzo +
														  '<br><b>numero registrazione</b>: ' + obj.numero_registrazione +
														  '</span>';
}

function cambio_comune_richiedente(){
	document.getElementById('stabId').value = "0";
	document.getElementById('altId').value = "-1";
	document.getElementById('partita_iva').value = "";
	document.getElementById('riepilogo_stab').innerHTML = "";
}

$(function() {
	
	 $('#popup_lista_allegati').dialog({
		title : 'Lista allegati da aggiungere alla pratica',
        autoOpen: false,
        resizable: false,
        closeOnEscape: false,
        width:1000,
        height:550,
        draggable: false,
        modal: true,
	     buttons: {
			 'torna alla pratica e completa inserimento allegati': function() {
				 aggiungi_allegati_alla_pratica();
                               loadModalWindowUnlock();
				$( this ).dialog('close');
			},
			'ESCI': function() {
                               loadModalWindowUnlock();
				$( this ).dialog('close');
			}
     }
});
	 
});

function apri_lista_allegati(){
	
	var htmlText='<br>';
	htmlText+='<table border=\'1\' cellpadding=\'4\' width=\'100%\'>';
	htmlText+='<tr><th  width=\'5%\'>SIGLA</th><th  width=\'85%\'>Descrizione</th><th  width=\'10%\'>seleziona</th></tr>';
	for (var i = 0 in allegati) {
			htmlText+='<tr><td align=\'center\'>' + allegati[i].code + 
			'</td><td align=\'rigth\'>' + allegati[i].desc + 
	  		'</td><td align=\'center\'><input type=\'checkbox\' id=\'allegato_'+i+'\' name=\'allegato_'+i+'\'></td></tr>';
		}
		htmlText+='</table>';
        $('#popup_lista_allegati').html(htmlText);
        $('#popup_lista_allegati').dialog('open');

}

function aggiungi_allegati_alla_pratica(){
	
	var popup_lista_alleg = document.getElementById("popup_lista_allegati").getElementsByTagName("input"); 
	
	for (var x = 0; x < popup_lista_alleg.length; x++){
		var campo_alleg = popup_lista_alleg[x];
		if (campo_alleg.checked == true){
			if(document.getElementById("tr_header_" + allegati[x].code) == null){
				//alert("allegato " + allegati[x].code + " non presente" );
				var sigla_allegato = allegati[x].code;
				
				var trfield = document.createElement('tr');
				trfield.setAttribute('id','tr_header_' + sigla_allegato);
				document.getElementById('tabella_crea_pratica').appendChild(trfield);
				
				var tdfield1 = document.createElement('td');
			    tdfield1.setAttribute('class', 'formLabel');
				tdfield1.innerHTML = '<p><b>ALLEGATO ' + sigla_allegato +'</b></p>';
				document.getElementById('tr_header_' + sigla_allegato).appendChild(tdfield1);
				
				var tdfield2 = document.createElement('td');
				tdfield2.setAttribute('colspan', '3');
				var texthtml = "";
				texthtml += "<a href = \"javascript:openUploadAllegatoGins(document.getElementById('idAggiuntaPratica').value, '"+sigla_allegato+"', 'GINS_Pratica')\" id='allega'>Allega file</a>";
				texthtml += "<input type='hidden' readonly='readonly' id='header_"+ sigla_allegato +"' name='header_"+ sigla_allegato +"'/>";
				texthtml += "<label id='titolo_"+ sigla_allegato +"' name='titolo_"+ sigla_allegato +"'></label>";
				texthtml += "<input type='button' style='float: right;' value='rimuovi allegato' onclick='rimuovi_linea(\"tr_header_" + sigla_allegato + "\")'/>";
				tdfield2.innerHTML = texthtml;
				document.getElementById('tr_header_' + sigla_allegato).appendChild(tdfield2);
			}
			
		}
	}
	
}

function rimuovi_linea(idtr){
	var child = document.getElementById(idtr);
	child.parentNode.removeChild(child);
}


</script>