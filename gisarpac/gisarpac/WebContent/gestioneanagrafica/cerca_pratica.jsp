<%@ page import="java.util.*,java.text.DateFormat,org.aspcfs.modules.accounts.base.*,org.aspcfs.modules.opu.base.*,org.aspcfs.modules.contacts.base.*,org.aspcfs.modules.base.Constants" %>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>


<script src="javascript/vendor/moment.min.js"></script>

<table class="trails" cellspacing="0">
	<tr>
		<td>
			<a href="GestioneAnagraficaAction.do?command=ListaPraticheStabilimenti">PRATICHE SUAP 2.0</a> > RICERCA PRATICA
		</td>
	</tr>
</table>

<form id="ricercaPratica" name="ricercaPratica" class="form-horizontal" role="form" method="post" 
			action="GestioneAnagraficaAction.do?command=SearchPraticheAmministrative" onsubmit="return validateForm();">

<input type="hidden" id="aslUtente" value="<%=User.getSiteId()%>"/>
<br><br>

<table id="tabella_cerca_pratica" class="details" cellspacing="0" border="0" width="100%" cellpadding="4">
<tbody>
	<tr>
		<th colspan="2">Dati ricerca &nbsp;&nbsp;&nbsp; <input type="button" value="pulisci" onclick="pulisci_form()"/></th>
	</tr>
	
	<tr>
		<td class="formLabel"><p>NUMERO PRATICA</p></td>
		<td>
			<input placeholder="NUMERO PRATICA" type="text" id="numero_pratica" name="numero_pratica" autocomplete="off"  pattern="[A-Za-z0-9]{1,}"  size="40" style="text-align:center;">
		</td>
	</tr>
	
	<tr>
		<td class="formLabel"><p>COMUNE</p></td>
		<td>
			<select id="comune_richiedente" name="comune_richiedente" style="text-align:center;"></select>
		</td>
	</tr>
	<tr>
		<td class="formLabel"> <p>DATA PEC</p> </td>
		<td>
			<input placeholder="DATA PEC" type="text" id="data_richiesta" name="data_richiesta" autocomplete="off" size="15" style="text-align:center;">
		</td>
	</tr>
	
	<tr>
		<td class="formLabel"><p>TIPO PRATICA</p></td>
		<td>
			<select id="idTipologiaPratica" name="idTipologiaPratica" style="text-align:center;">
					<option value=""> -- TIPO PRATICA -- </option>
					<option value="1">NUOVO STABILIMENTO</option>
					<option value="2">AMPLIAMENTO</option>
					<option value="3">CESSAZIONE</option>
					<option value="4">VARIAZIONE TITOLARITA'</option>
					<option value="6">MODIFICA STATO DEI LUOGHI</option>
					<option value="7">TRASFERIMENTO SEDE</option>
				</select> 
		</td>
	</tr>
	
</tbody>
</table>
<br><br>
<center>

<button type="submit" class="yellowBigButton" style="width: 250px;">CERCA</button>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

<button type="button" class="yellowBigButton" style="width: 250px;" 
	onClick="loadModalWindowCustom('Attendere Prego...'); window.location.href='GestioneAnagraficaAction.do?command=ListaPraticheStabilimenti'">ANNULLA</button>

</center>
</form>
<br><br>

<script>

function validateForm(){
	
	loadModalWindowCustom('Attendere Prego...');
	return true;
	
}

function pulisci_form(){
	document.getElementById('numero_pratica').value = '';
	document.getElementById('comune_richiedente').value = '';
	document.getElementById('data_richiesta').value = '';
	document.getElementById('idTipologiaPratica').value = '';
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


popola_select_popup('GetComuneByAsl.do?command=Search&idAsl='+document.getElementById('aslUtente').value , 'comune_richiedente');


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
			$('#'+id_elemento).append('<option value=""> -- COMUNE -- </option>');
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


</script>