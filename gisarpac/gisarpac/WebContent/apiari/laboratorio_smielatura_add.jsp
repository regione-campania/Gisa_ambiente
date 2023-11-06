

<jsp:useBean id="ApicolturaSottospecie" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ApicolturaModalita" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ApicolturaClassificazione" class="org.aspcfs.utils.web.LookupList" scope="request"/>

<jsp:useBean id="TipoAttivitaApi" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="NazioniList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Operatore" class="ext.aspcfs.modules.apiari.base.Operatore" scope="request" />
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session" />
<%@page import="ext.aspcfs.modules.apicolture.actions.CfUtil"%>





<link rel="stylesheet" href="css/jquery-ui.css" />
<link rel="stylesheet" href="css/opu.css" />
<!-- <script language="JavaScript" TYPE="text/javascript" SRC="javascript/suapUtil.js"></script> -->

<script language="JavaScript" TYPE="text/javascript" SRC="javascript/gestoreCodiceFiscale.js"></script>
<SCRIPT src="javascript/apiari.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="javascript/CalendarPopup.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" ID="js19">
	var cal19 = new CalendarPopup();
	cal19.showYearNavigation();
	cal19.showYearNavigationInput();
	cal19.showNavigationDropdowns();
</SCRIPT>
<%@ include file="../initPage.jsp"%>




<script>


function controllaCoordinate()
{
	
	var lat = form.latitudine.value ;
	var longi = form.longitudine.value;
	
	var comune = form.searchcodeIdComuneinput.value ;
	
	var esito = false ;
	
	 $.ajax({
	        type: 'GET',
	        dataType: "json",
	        async:false,
	        url: "http://maps.googleapis.com/maps/api/geocode/json?latlng="+lat+","+longi+"&sensor=false",
	        data: {},
	        success: function(data) {
	            $('#city').html(data);
	            $.each( data['results'],function(i, val) {
	                $.each( val['address_components'],function(i, val) {
	                    if (val['types'] == "locality,political") {
	                        if (val['long_name']!="") {
	                        
	                        	if (val['long_name'] ==comune)
	                        		{
	                        		esito = true;
	                        		$("#coordinateError").html("");
	                        }
	                        	else
	                        		{
	                        		esito =  false ;
	                        	$("#coordinateError").html("<font color='red'>Attenzione ! Le coordinate dell'indirizzo immesso fanno riferimento al comune di : "+val['long_name']+"</font>");
	                        		}
	                        }
	                        else {
	                        	esito =  false ;
	                        }
	                       
	                    }
	                });
	            });
	           
	        },
	        error: function () { console.log('error'); } 
	    }); 
	return esito;
}

function checkForm()
{
	
	
	 	formTest = true;
	    message = "";
	    alertMessage = "";
	   
	    form = document.addstabilimento ;
	    
	    
	   
	    if (form.searchcodeIdComuneinput.value == ""){
	        message += "- Comune Ubicazione richiesto\r\n";
	        formTest = false;
	     }
	    if (form.viaTesto.value == ""){
	        message += "- Indirizzo Ubicazione richiesto\r\n";
	        formTest = false;
	     }
	    
	    if (form.latitudine.value == ""){
	        message += "- Latitudine richiesto\r\n";
	        formTest = false;
	     }
	    if (form.longitudine.value == ""){
	        message += "- Longitudine richiesto\r\n";
	        formTest = false;
	     }
	    
	    var esitoControlloCoordinate = controllaCoordinate();
	    esitoControlloCoordinate = true;
	    
	    if (esitoControlloCoordinate==false)
	    {
	        message += "- Le coordinate dell'indirizzo inserito non corrispondono al comune immesso!\r\n";
	        formTest = false;
	     }
	    
	    
	    if (formTest == false) {
	        alert(label("check.form", "Form could not be saved, please check the following:\r\n\r\n") + message);
	        return false;
	      } else {
	      
	        loadModalWindow();
	        return true;
	      }
		
}
	
	  
	
	
          
/*AUTOCOMPLETAMENTO PER GLI INDIRIZZI*/          
$(function() {
  
    $( "#addressLegaleCity" ).combobox();
    
    $( "#searchcodeIdComune" ).combobox();
    
     

});
 

  
</script>

<form  name="addstabilimento" action="ApicolturaApiari.do?command=InsertLaboratorio&auto-populate=true" method="POST" onsubmit="return checkForm()">

<input type="hidden" name="idOperatore" id="idOperatore" value="<%=Operatore.getIdOperatore()%>">
	
	
	<fieldset>
		<legend><b>DATI UBICAZIONE</b></legend>
		<table cellpadding="4" cellspacing="0" border="0" width="100%"
		class="details">
		
   <tr>
		<td nowrap class="formLabel">Comune</td>
		<td>
			<select name="searchcodeIdComune" id="searchcodeIdComune" class="required">
				<option value=""></option>
			</select>
			<input type = "hidden" id = "inRegione" value= "no">
			<font color = "red">*</font>
					<%=showError(request, "comuneError") %>
			<input type="hidden" name="searchcodeIdComuneTesto" id="searchcodeIdComuneTesto" />
			
		</td>
	</tr>
	
	<tr>
		<td nowrap class="formLabel">
			Cap
		</td>
		<td>
			<input type="text" size="70" name="presso" id ="presso"  style="width: 50px;">
		</td>
	</tr>
	
	<tr id ="searchcodeIdprovinciaTR">

		<td nowrap class="formLabel">
			Sigla Provincia
		</td>
		<td>
			
			<input type="text" readonly="readonly" required="required" name="searchcodeIdprovinciaTesto" id="searchcodeIdprovinciaTesto" />
			<input type="hidden"  required="required" name="searchcodeIdprovincia" id="searchcodeIdprovincia" />
			
		</td>
	</tr>
	
	<tr>
		<td nowrap class="formLabel">
			Indirizzo
		</td>
		<td>
			
			<input type="text" name="viaTesto" id="viaTesto" />
				<font color = "red">*</font>
					<%=showError(request, "indirizzoError") %>
		</td>
	</tr>
	
	
	
	
	<tr>
		<td nowrap class="formLabel">
			Latitudine
		</td>
		<td>
			
			<input type="text" name="latitudine" id="localitaSedeLegale" pattern="-?\d{1,3}\.\d+"  />
			<font color = "red">*</font>
					<%=showError(request, "latitudineError") %>
		</td>
	</tr>
	<tr>
		<td nowrap class="formLabel">
			Longitudine
		</td>
		<td>
			
			<input type="text" name="longitudine" id="localitaSedeLegale" pattern="-?\d{1,3}\.\d+" />
			<font color = "red">*</font>
					<%=showError(request, "longitudineError") %>
					
					<div id ="coordinateError"></div>
		</td>
	</tr>
	
	 <tr style="display:block">
    <td colspan="2">
    <input id="coord2button" type="button" value="Calcola Coordinate" 
    onclick="javascript:showCoordinate(document.getElementById('viaTesto').value, document.forms['addstabilimento'].searchcodeIdComuneinput.value,document.forms['addstabilimento'].searchcodeIdprovinciaTesto.value, document.forms['addstabilimento'].presso.value, document.forms['addstabilimento'].longitudine, document.forms['addstabilimento'].latitudine);" />
     </td>
    </tr>
	
	
		
		</table>
	
	</fieldset>		
	
	
	
		<input type ="submit" value="SALVA" >
</form>









<script>



var campoLat;
var campoLong;
	function showCoordinate(address,city,prov,cap,campo_lat,campo_long)
	{

		   campoLat = campo_lat;
		   campoLong = campo_long;
		   address = trim(address);
		   if (city=='' || prov=='' || address==''){alert('Attenzione! riemprire i campi Comune, Provincia e Indirizzo!');}
		   else{
		   Geocodifica.getCoordinate(address,city,prov,cap,'','','',setGeocodedLatLonCoordinate);
		   }
   
   
}
function setGeocodedLatLonCoordinate(value)
{
	campoLat.value = value[1];;
	campoLong.value =value[0];
	
}


		

</script>
