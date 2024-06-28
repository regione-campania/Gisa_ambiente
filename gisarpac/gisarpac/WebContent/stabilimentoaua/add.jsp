<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<jsp:useBean id="TipoImpresaList" class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="NazioniList" class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="ComuniList" class="org.aspcfs.utils.web.LookupList" scope="request" />


<script src="javascript/vendor/moment.min.js"></script>
<script src="javascript/noscia/addNoScia.js"></script>
<script src="javascript/noscia/codiceFiscale.js"></script>
  <link rel="stylesheet" href="//code.jquery.com/ui/1.13.2/themes/base/jquery-ui.css">
  <link rel="stylesheet" href="/resources/demos/style.css">
  <script src="https://code.jquery.com/jquery-3.6.0.js"></script>
  <script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
<script type="text/javascript" src="dwr/interface/DWRnoscia.js"> </script>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>
<script src="javascript/gestioneanagrafica/add.js"></script>


<script>




</script>


</head>
<body>
<form name="addStab" action="StabilimentoAUA.do?command=Insert" onSubmit="return validateForm()" method="post">
 <div id="tipo_linee" style="display:none">
<center>
	<h2>Stai per inserire uno stabilimento:</h2>
	<select id="tipo_linee_attivita" style="text-align:center; font-size: 20px ;width: 400px;">
		<option value="1">con sede fissa</option>
	</select>
	</center>
	
	<br><br><br>
	<input type="button" value="avanti" class="yellowBigButton" style="width: 250px;"
		onclick="gestione_tipo_scheda_inserimento()" />
		</div>
<table class="table details" id="tabella_linee" style="border-collapse: collapse" width="100%" cellpadding="5"> 
 	 			<input type="button" id="pulisciform" name="pulisciform" value="pulisci schermata" style="display: none" onclick="var link = 'StabilimentoAIA.do?command=Add';window.location.href=link;">
 	 				<input type="hidden" id="id_stabilimento" name="id_stabilimento">	
				<tbody><tr id="tr_dati_impresa_id">
					<th colspan="2">DATI IMPRESA  
					</th>
				</tr>
 	 						<tr id="tr_ragione_sociale_impresa" title="" size="70" required="true">
				<td class="formLabel">RAGIONE SOCIALE</td>
				<td>
					<input type="text" id="ragione_sociale_impresa" name="ragione_sociale" value="" size="70" required="true" title="inserire ragione sociale impresa">
			</td></tr>
			<tr id="tr_cf_impresa" title="" size="70" >
				<td class="formLabel">CODICE FISCALE</td>
				<td>
					<input type="text" id="codice_fiscale_impresa" name="codice_fiscale_impresa" value="" size="70" required="true" title="inserire codice fiscale impresa">
			</td></tr>
			<th colspan="2">DATI STABILIMENTO 
					</th>
				</tr>
 	 							<tr id="tr_ciureg" title="" size="70" required="true">
				<td class="formLabel">CIUREG</td>
				<td>
					<input type="text" id="ciureg" name="ciureg" value="" size="50" required="true" title="inserire ciureg " onchange="controlloCiureg()">
			</td></tr>
			
				<tr id="tr_ciuprov" title="" size="70" required="true">
				<td class="formLabel">CIUPROV</td>
				<td>
					<input type="text" id="ciuprov" name="ciuprov" value="" size="50" required="true" title="inserire ciuprov ">
			</td></tr>
        	<tr id="tr_anno" title="" size="70" required="true">
				<td class="formLabel">ANNO</td>
				<td>
					<input type="text" id="anno" name="anno" value="" size="20" required="true" title="inserire anno">
			</td></tr>
			<tr id="tr_mesi_attivita" title="" size="70"">
				<td class="formLabel">MESI DI ATTIVITA'</td>
				<td>
					<input type="text" id="mesi_attivita" name="mesi_attivita" value="" size="20" required="true" title="inserire mesi attivita">
			</td></tr>
			<tr id="tr_schede_aut" title="" size="70"">
				<td class="formLabel">NUM. SCHEDE DI AUTORIZZAZIONE</td>
				<td>
				<input type="number" id="schede_aut" name="schede_aut" placeholder="" value="" size="10" min=0 >
			</td></tr>
			
				<tr id="tr_stabilimento_id_sezione">
					<th colspan="2">DATI IMPIANTO 
					</th>
				</tr>
				<tr id="indirizzo_stabilimento">
				<td class="formLabel">INDIRIZZO</td>	
				<td>
								<input type="text" id="toponimo_stabilimento" name="toponimo_stabilimento" placeholder="TOPONIMO" value="" size="10" readonly="">
								<input type="text" id="via_stabilimento" name="via_stab" placeholder="VIA" value="" size="38" readonly="">
								<input type="text" id="civico_stabilimento" name="civico_stab" placeholder="CIVICO" value="" size="10" readonly="">
								<input type="text" id="cap_stabilimento" name="cap_stab" placeholder="CAP" value="" size="5" maxlength="5" onkeydown="return false;" required autocomplete="off">
								<input type="text" id="comune_stabilimento" name="comune_stabilimento" placeholder="COMUNE" value="" size="30" readonly="">
								<input type="text" id="provincia_stabilimento" name="provincia_stabilimento" placeholder="PROVINCIA" value="" size="18" readonly="">
					 			<input type="button" id="ins_indirizzo_stabilimento" value="INSERISCI INDIRIZZO" onclick="openCapWidget('toponimo_stabilimento','topIdStabilimento','via_stabilimento','civico_stabilimento','comune_stabilimento', 'comuneIdStabilimento','cap_stabilimento','provincia_stabilimento','provinciaIdStabilimento','valledaosta')" >     
        		</td>
				</tr>
        	
 	 				<input type="hidden" id="provinciaIdStabilimento" name="cod_provincia_stab">	
 	 				<input type="hidden" id="comuneIdStabilimento" name="cod_comune_stab">	
 	 				<input type="hidden" id="topIdStabilimento" name="toponimo_stab">	
				<tr id="coordinate_stabilimento">
				<td class="formLabel">COORDINATE GEOGRAFICHE</td>	
				<td>
								<input type="text" id="lat_stabilimento" name="latitudine_stab" placeholder="X" value="" onfocusout="this.value=this.value.replace(/[^0-9.]+/,''); if (this.value.length==0 || !this.value.includes('.') || this.value.charAt(0) == '.' || this.value.charAt(this.value.length-1) == '.') {alert('Valorizzare le coordinate nel formato xx.yyyy'); this.value=''; return false}" required="" autocomplete="off">
								<input type="text" id="long_stabilimento" name="longitudine_stab" placeholder="Y" value="" onfocusout="this.value=this.value.replace(/[^0-9.]+/,''); if (this.value.length==0 || !this.value.includes('.') || this.value.charAt(0) == '.' || this.value.charAt(this.value.length-1) == '.') {alert('Valorizzare le coordinate nel formato xx.yyyy'); this.value=''; return false}" required="" autocomplete="off">
					 			<input type="button" id="calcola_coord_stabilimento" value="CALCOLA COORDINATE" onclick="getCoordinate('toponimo_stabilimento','via_stabilimento','comune_stabilimento','provincia_stabilimento','cap_stabilimento','lat_stabilimento','long_stabilimento')">     
        		</td>
				</tr>
        	
			
        	
			<tr id="tr_asl_stabilimento" title="" placeholder="dipartimento" readonly="" size="40px">
				<td class="formLabel">DIPARTIMENTO</td>
				<td>
					<input type="text" id="asl_stabilimento" name="asl_stabilimento" value="" placeholder="dipartimento" readonly="" size="40px">
 
			</td></tr>
				<th colspan="2">Scheda Autorizzativa
					</th>
				
				<tr id="tr_estremi" title="" size="70"">
				<td class="formLabel">ESTREMI</td>
				<td>
					<input type="text" id="estremi" name="estremi" value="" size="40" required="true" title="inserire estremi">
			</td></tr>
 	 				<tr id="tr_rilascio" title="" size="70"">
				<td class="formLabel">DATA RILASCIO</td>
				<td>
					<input type="date" id="rilascio" name="rilascio" value="" size="40" required="true" title="inserire rilascio">
			</td></tr>
			<tr id="tr_scadenza" title="" size="70"">
				<td class="formLabel">DATA SCADENZA</td>
				<td>
					<input type="date" id="scadenza" name="scadenza" value="" size="40" required="true" title="inserire scadenza">
			</td></tr>
			<tr id="tr_ente" title="" size="50">
				<td class="formLabel">ENTE</td>
				<td>
				<select id="ente" name="ente" >
				<option value="provincia">Provincia</option>
				<option value="provincia">Regione</option>
				<option value="provincia">Ministero Ambiente</option>
				
				</select>
			</td></tr>
			
			<tr id="tr_ente" title="" size="50">
				<td class="formLabel">TIPO AUTORIZZAZIONE</td>
				<td>
					<input type="text" id="tipo_aut" name="tipo_aut" value="" size="40" required="true" title="inserire tipo_aut">
			</td></tr>
			
			<tr id="tr_ente" title="" size="50">
				<td class="formLabel">OPERAZIONI R AUTORIZZATE</td>
				<td>
					<input type="text" id="op_r_autorizzate" name="op_r_autorizzate" value="" size="40" required="true" title="inserire tipo_aut">
			</td></tr>
			
			<tr id="tr_ente" title="" size="50">
				<td class="formLabel">OPERAZIONI D AUTORIZZATE</td>
				<td>
					<input type="text" id="op_d_autorizzate" name="op_d_autorizzate" value="" size="40" required="true" title="inserire tipo_aut">
			</td></tr>
			
			<tr id="tr_ente" title="" size="50">
				<td class="formLabel">Gestionee VFU</td>
				<td>
					<input type="checkbox" id="vfu" name="vfu"  size="40"  title="inserire tipo_aut">
			</td></tr>
			
			<tr id="tr_ente" title="" size="50">
				<td class="formLabel">Gestionee RAEE</td>
				<td>
					<input type="checkbox" id="raee" name="raee"  size="40"  title="inserire tipo_aut">
			</td></tr>
			
			<tr id="tr_ente" title="" size="50">
				<td class="formLabel">INCENERIMENTO</td>
				<td>
					<input type="checkbox" id="incenerimento" name="incenerimento"  size="40"  title="inserire tipo_aut">
			</td></tr>
			
			<tr id="tr_ente" title="" size="50">
				<td class="formLabel">AUTORIZZAZIONE EOW</td>
				<td>
					<input type="checkbox" id="eow" name="eow"  size="40"  title="inserire tipo_aut">
			</td></tr>
			
				<tr id="tr_stabilimento_id_sezione">
					<th colspan="2">DATI SCHEDA AUTORIZZATIVA
					</th>
				</tr>
				<tr id="tr_ente" title="" size="50">
				<td class="formLabel">CAPACITA COMPLESSIVA AUTORIZZAZIONE</td>
				<td>
					<input type="number" min=0 id="capacita" name="capacita" value="" size="40" required="true" title="inserire tipo_aut">
			</td></tr>
			
			<tr id="tr_ente" title="" size="50">
				<td class="formLabel">COINCENERIMENTO</td>
				<td>
					<input type="text" id="coincenerimento" name="coincenerimento" value="" size="40" required="true" title="inserire tipo_aut">
			</td></tr>
			
			<tr id="tr_ente" title="" size="50">
				<td class="formLabel">CATEGORIA DISCARICA</td>
				<td>
					<input type="text" id="categoria_discarica" name="categoria_discarica" value="" size="40" required="true" title="inserire tipo_aut">
			</td></tr>
			
			<tr id="tr_ente" title="" size="50">
				<td class="formLabel">CAPACITA RESIDUA</td>
				<td>
					<input type="number" min=0 id="capacita_residua" name="capacita_residua" value="" size="40" required="true" title="inserire tipo_aut">
			</td></tr>
			
			
			<tr id="tr_ente" title="" size="50">
				<td class="formLabel">CAPACITA RIF PERICOLOSI</td>
				<td>
					<input type="number" min=0 id="capacita_pericolosi" name="capacita_pericolosi" value="" size="40" required="true" title="inserire tipo_aut">
			</td></tr>
			
			<tr id="tr_ente" title="" size="50">
				<td class="formLabel">CAPACITA RIF NON PERICOLOSI</td>
				<td>
					<input type="number" min=0 id="capacita_non_pericolosi" name="capacita_non_pericolosi" value="" size="40" required="true" title="inserire tipo_aut">
			</td></tr>
			
<div id='dialogimprese'/>
<script src="javascript/noscia/widget.js"></script>
</tbody></table>            
<br><br>
<center>

<button type="submit" class="yellowBigButton" style="width: 250px;">SALVA</button>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" class="yellowBigButton" style="width: 250px;" value="ANNULLA" onclick="var link = 'StabilimentoAIA.do?command=SearchForm';			
       		window.location.href=link;">

</center>
</div>
</form>
<br><br>
<script>





function validateForm()
{

    loadModalWindowCustom("Attendere Prego...");
    return true;
}






function popup_date1(){
	$( '#data_nascita_rapp_legale' ).datepicker({
		  dateFormat: 'dd-mm-yy',
		  changeMonth: true,
		  changeYear: true,
		  yearRange: '-100:+3',					
		  maxDate: '-18Y', 
onSelect: function(){
document.getElementById('cf_rapp_legale').value = '';
},
		  dayNamesMin : [ 'do', 'lu', 'ma', 'me', 'gi', 've', 'sa' ],
		  monthNamesShort :['Gennaio','Febbraio','Marzo','Aprile','Maggio','Giugno', 'Luglio','Agosto','Settembre','Ottobre','Novembre','Dicembre'],
		  beforeShow: function(input, inst) {
               setTimeout(function () {
                          var offsets = $('#data_nascita_rapp_legale').offset();
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
                          var offsets = $('#data_nascita_rapp_legale').offset();
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
	
	popup_date1();
	
	
	
	
	
function controlloCiureg(){
	ciureg = document.getElementById("ciureg").value
	if (trim(ciureg.toString()) != ''){
		DWRnoscia.controlloEsistenzaAuaCiureg(ciureg, {callback:recuperaDatiImpresaCallBack,async:true});
	}
}

function recuperaDatiImpresaCallBack(returnValue)
{
	console.log(returnValue)
	
	if(returnValue != "" || returnValue == null || returnValue == null){
		alert("CIUREG GIA' PRESENTE NEL SISTEMA");
		document.getElementById("ciureg").value=""
	}
}



</script>







</body>
</html>