<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@page import="org.aspcfs.modules.aia.base.StabilimentoAIA"%>
<%@page import="org.aspcfs.modules.aia.base.ImpresaAIA"%>
    

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<jsp:useBean id="TipoImpresaList" class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="NazioniList" class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="ComuniList" class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="StabilimentoDettaglio"
	class="org.aspcfs.modules.aia.base.StabilimentoAIA" scope="request" />
<jsp:useBean id="ImpresaDettaglio"
	class="org.aspcfs.modules.aia.base.ImpresaAIA" scope="request" />
<jsp:useBean id="JsonIPPC" class="org.json.JSONArray" scope="request" />
<jsp:useBean id="JsonDecreti" class="org.json.JSONArray" scope="request" />

<script src="javascript/vendor/moment.min.js"></script>
<script src="javascript/noscia/addNoScia.js"></script>
<script src="javascript/noscia/codiceFiscale.js"></script>



<script src="javascript/gestioneanagrafica/add.js"></script>

<script>

</script>


</head>
<body>
<form name="updateIppc" action="StabilimentoAIA.do?command=UpdateIppc" onSubmit="return validateForm()" method="post">

<table class="table details" id="tabella_linee" style="border-collapse: collapse" width="100%" cellpadding="5"> 
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
 
 	 			<input type="button" id="pulisciform" name="pulisciform" value="pulisci schermata" style="display: none" onclick="var link = 'StabilimentoAIA.do?command=UpdateIppc';window.location.href=link;">
 	 				<input type="hidden" id="id_stabilimento" name="id_stabilimento" value="<%=StabilimentoDettaglio.getIdStabilimento()%>">	
				<tbody><tr id="tr_ippc_id_sezione">
					<th colspan="2">CODICI IPPC
							<input type="button" id="ippc_id_sezione" value="aggiungi codice ippc" onclick="aggiungi_ippc();">
							 	 				<input type="hidden" id="principale_check" name="principale_check" value="false">	
							
					</th>
				</tr>
				
														<% 
														int i;
														for ( i = 0; i < JsonIPPC.length(); i++) {%>
														<tr id="descrizione_<%=i+1%>">
															<td class="formLabel" id="td1_descrizione_<%=i+1%>">CODICI IPPC
																	<input type="button" value="elimina Ippc" onclick="rimuovi_ippc('descrizione_<%=i+1%>')">
																</td>
																<td>	
														 <% if(JsonIPPC.getJSONObject(i).get("principale").equals("true")) { %>(CODICE
														PRINCIPALE)<script>document.getElementById("principale_check").value="true" </script> <%}else{%> (CODICE SECONDARIO) <%}%> <br> <b>CATEGORIA
															IMPIANTO-&gt;CODICE IPPC-&gt;DESCRIZIONE</b><br><%=JsonIPPC.getJSONObject(i).get("categoria")%>
														-&gt;<%=JsonIPPC.getJSONObject(i).get("codice")%>-&gt;<%=JsonIPPC.getJSONObject(i).get("descrizione")%><br>

														<b>Data inizio validita codice ippc</b>:<%=JsonIPPC.getJSONObject(i).get("data_inizio_attivita")%> <br> <b>Stato</b>: <%=JsonIPPC.getJSONObject(i).get("stato")%><br>
														<br>
													<br> 	</td>
													<input type="hidden" id="descrizione_<%=i+1%>_codice_univoco" name="descrizione_<%=i+1%>_codice_univoco" value="<%=JsonIPPC.getJSONObject(i).get("id_ippc")%>">
													<input type="hidden" id="check_descrizione_<%=i+1%>_codice_univoco" name="check_descrizione_codice_univoco" value="<%=JsonIPPC.getJSONObject(i).get("id_ippc")%>">
													<input type="hidden" id="check_id_<%=i+1%>_codice_univoco" name="check_id_<%=i+1%>_codice_univoco" value="<%=JsonIPPC.getJSONObject(i).get("id")%>">
													<input type="hidden" id="descrizione_<%=i+1%>_principale" name="descrizione_<%=i+1%>_principale" value="<%=JsonIPPC.getJSONObject(i).get("principale")%>">
													</tr>												
													<%}%>
 	 				<input type="hidden" id="numero_ippc" name="numero_ippc" value="<%=i+1%>">	
 	 				<input type="hidden" id="numero_ippc_effettivo" name="numero_ippc_effettivo" value="<%=i%>">	
 	 				
 	 				
<div id='dialogimprese'/>
<div id='popupippc'/>
<script src="javascript/noscia/widget.js"></script>
<script src="javascript/gestioneanagrafica/aggiungiIppc.js"></script>
</tbody></table>            
<br><br>
<center>

<button type="submit" class="yellowBigButton" style="width: 250px;">SALVA</button>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" class="yellowBigButton" style="width: 250px;" value="ANNULLA" onclick="var link = 'StabilimentoAIA.do?command=Details&stabId=<%=StabilimentoDettaglio.getIdStabilimento()%>';			
       		window.location.href=link;">

</center>
</div>
</form>
<br><br>
<script>





function validateForm()
{
	var num_linee = document.getElementById('numero_ippc_effettivo').value;
	if(num_linee == '0'){
		alert('Selezionare almeno un CODICE IPPC');
		return false;
	}
	
	
	if(document.getElementById("principale_check").value=="false"){
		alert('Deve esserci almeno un codice IPPC principale');
		return false;
	}
	

	
	
	
    loadModalWindowCustom("Attendere Prego...");
	return true;
}



function nazioneReset(){
	if(document.getElementById('nazione_nascita_rapp_legale').value != 106)
	{
		document.getElementById('tr_comune_nascita_rapp_legale').style='display: none';
		document.getElementById('tr_comune_nascita_estero_rapp_legale').style='display: block inline-block';
		document.getElementById('comune_nascita_estero_rapp_legale').style='display: block inline-block';
                document.getElementById('comune_nascita_estero_rapp_legale').disabled = true;
                document.getElementById('comune_nascita_estero_rapp_legale').value='';
                document.getElementById('comune_nascita_rapp_legale').disabled = true;
		document.getElementById('calcola_cf_rapp_legale').style='display: none';
	}else{
		document.getElementById('tr_comune_nascita_rapp_legale').style='display: block inline-block';
		document.getElementById('tr_comune_nascita_estero_rapp_legale').style='display: none';
		document.getElementById('comune_nascita_estero_rapp_legale').style='display: none';
		document.getElementById('comune_nascita_estero_rapp_legale').value='';
                document.getElementById('comune_nascita_estero_rapp_legale').disabled = true;
                document.getElementById('comune_nascita_rapp_legale').disabled = false;
		document.getElementById('calcola_cf_rapp_legale').style='display: block inline-block';
                document.getElementById('cf_rapp_legale').value = '';
	} 
}
function nazioneResetResi(){

if(document.getElementById('nazione_residenza_rapp_legale').value != 106)
{
	document.getElementById('indirizzo_residenza_rapp_legale').style='display: none';
	document.getElementById('tr_comune_residenza_estero_rapp_legale').style='display: block inline-block';
	document.getElementById('comune_residenza_estero_rapp_legale').style='display: block inline-block'; 
	document.getElementById('comune_residenza_estero_rapp_legale').value='';
	document.getElementById('toponimo_residenza_rapp_legale').value='';
	document.getElementById('via_residenza_rapp_legale').value='';
	document.getElementById('civico_residenza_rapp_legale').value='';
	document.getElementById('cap_residenza_rapp_legale').value='';
	document.getElementById('comune_residenza_rapp_legale').value='';
	document.getElementById('provincia_residenza_rapp_legale').value='';
	document.getElementById('comuneIdResidenzaRappLegale').value='';
	document.getElementById('topIdResidenzaRappLegale').value='';
	document.getElementById('provinciaIdResidenzaRappLegale').value='';        
}else{
	document.getElementById('indirizzo_residenza_rapp_legale').style='display: block inline-block';
	document.getElementById('tr_comune_residenza_estero_rapp_legale').style='display: none';
	document.getElementById('comune_residenza_estero_rapp_legale').style='display: none';
	document.getElementById('comune_residenza_estero_rapp_legale').value='';
}
}

function nazioneResetNazi(){

if(document.getElementById('nazione_sede_legale').value != 106)
{
	document.getElementById('indirizzo_sede_legale').style='display: none';
	document.getElementById('tr_comune_estero_sede_legale').style='display: block inline-block';
	document.getElementById('comune_estero_sede_legale').style='display: block inline-block';
	document.getElementById('comune_estero_sede_legale').value='';
            document.getElementById('cap_sede_legale').removeAttribute('required');
            
            document.getElementById('toponimo_sede_legale').value='';
	document.getElementById('via_sede_legale').value='';
	document.getElementById('civico_sede_legale').value='';
	document.getElementById('cap_sede_legale').value='';
	document.getElementById('comune_sede_legale').value='';
	document.getElementById('provincia_sede_legale').value='';
	document.getElementById('comuneIdSedeLegale').value='';
	document.getElementById('topIdSedeLegale').value='';
	document.getElementById('provinciaIdSedeLegale').value=''; 
            
}else{
	document.getElementById('indirizzo_sede_legale').style='display: block inline-block';
	document.getElementById('tr_comune_estero_sede_legale').style='display: none';
	document.getElementById('comune_estero_sede_legale').style='display: none';
	document.getElementById('comune_estero_sede_legale').value='';
            document.getElementById('cap_sede_legale').setAttribute('required', '');
}
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
</script>


<!-- FORZO SALTO DELLA SCELTA TIPO STABILIMENTO -->
<!-- FORZO SALTO DELLA SCELTA TIPO STABILIMENTO -->


<script>


if(document.getElementById("nazione_residenza_rapp_legale").value!=106){
	nazioneResetResi();
	document.getElementById("comune_residenza_estero_rapp_legale").value="<%=StabilimentoDettaglio.getImpresa().getSoggettoFisico().getIndirizzo().getComuneTesto()%>"
}


if(document.getElementById("nazione_nascita_rapp_legale").value!=106){
	nazioneReset();
	document.getElementById("comune_nascita_estero_rapp_legale").value="<%=StabilimentoDettaglio.getImpresa().getSoggettoFisico().getComuneNascita()%>"
}
</script>

</body>
</html>