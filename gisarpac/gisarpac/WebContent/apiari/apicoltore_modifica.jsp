

<%@page import="ext.aspcfs.modules.apiari.base.Delega"%>
<%@page import="java.util.Iterator"%>
<%@page import="ext.aspcfs.modules.apicolture.actions.CfUtil"%>

<jsp:useBean id="StabilimentoDettaglio"
	class="ext.aspcfs.modules.apiari.base.Stabilimento" scope="request" />


<jsp:useBean id="TipoAttivitaApi"
	class="org.aspcfs.utils.web.LookupList" scope="request" />

<jsp:useBean id="LookupStati" class="org.aspcfs.utils.web.LookupList"
	scope="request" />

<jsp:useBean id="ApicolturaSottospecie"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="ApicolturaModalita"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="ApicolturaClassificazione"
	class="org.aspcfs.utils.web.LookupList" scope="request" />

<jsp:useBean id="NazioniList" class="org.aspcfs.utils.web.LookupList" scope="request"/>


<link rel="stylesheet" href="css/jquery-ui.css" />
<link rel="stylesheet" href="css/opu.css" />

<script language="JavaScript" TYPE="text/javascript" SRC="javascript/gestoreCodiceFiscale.js"></script>
<SCRIPT src="javascript/apiari.js"></SCRIPT>



<link rel="stylesheet" type="text/css" href="javascript/jquerypluginTableSorter/css/theme.css"></link>
<link rel="stylesheet" type="text/css" href="javascript/jquerypluginTableSorter/css/jquery.tablesorter.pages.css"></link>
<script type="text/javascript" src="javascript/jquerypluginTableSorter/jquery.tablesorter.js"></script>
<script type="text/javascript" src="javascript/jquerypluginTableSorter/jquery.tablesorter.pager.js"></script>
<script type="text/javascript" src="javascript/jquerypluginTableSorter/jquery.tablesorter.widgets.js"></script>
<script type="text/javascript" src="javascript/jquerypluginTableSorter/tableJqueryFilterApi.js"></script>
<SCRIPT LANGUAGE="JavaScript" SRC="javascript/CalendarPopup.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" ID="js19">
	var cal19 = new CalendarPopup();
	cal19.showYearNavigation();
	cal19.showYearNavigationInput();
	cal19.showNavigationDropdowns();
</SCRIPT>


<link rel="stylesheet" href="css/jquery-ui.css" />
<link rel="stylesheet" href="css/opu.css" />



<script>


function checkFormApicoltore()
{
	
	
	 	formTest = true;
	    message = "";
	    alertMessage = "";
	   
	    form = document.apicoltoreModifica ;
	    
	    
	    if (form.dataInizio.value == ""){
	        message += "- Data inizio richiesta\r\n";
	        formTest = false;
	     }
	    
	   
	    if (form.idTipoAttivita.value == "-1"){
	        message += "- Tipo Attivita richiesto\r\n";
	        formTest = false;
	     }
	    
	    if (form.domicilioDigitale.value == ""){
	        message += "- Domicilio Digitale(Pec) richiesto\r\n";
	        formTest = false;
	     }
	    if (form.telefono1.value == ""){
	        message += "- Telefono Fisso richiesto\r\n";
	        formTest = false;
	     }
	    if (form.telefono2.value == ""){
	        message += "- Telefono Cellulare richiesto\r\n";
	        formTest = false;
	     }
	    
	    
	    
	    
	    
	    if (formTest == false) {
	        alert(label("check.form", "Form could not be saved, please check the following:\r\n\r\n") + message);
	        return false;
	      } else {
	      
	        loadModalWindow();
	        form.submit();
	        return true;
	      }
		
}


	function mostraCampoExtra(value)
	
	{
		if (value=='1')
			{
				document.getElementById("extraField").style.display="";
			}
		else
			{
			document.getElementById("extraField").style.display="none";
			}
	}
	
	


		    
	 
     



  
  

  
</script>

<%@ include file="../initPage.jsp"%>
<form  name="apicoltoreModifica" action="ApicolturaAttivita.do?command=UpdateApicoltore&auto-populate=true" method="POST" onsubmit="return checkForm()">


<input type="hidden" name="idStabilimento" id="idStabilimento" value="<%=StabilimentoDettaglio.getIdStabilimento() %>">
	
	<fieldset>
		<legend><b>ANAGRAFICA ATTIVITA</b></legend>
		<table cellpadding="4" cellspacing="0" border="0" width="100%"
		class="details">
		 <tr>
    <th colspan="2">
      <strong>MODIFICA ATTIVITA DI APICOLTURA</strong>
    </th>
  </tr>
  
  


		<tr>
		<td nowrap class="formLabel">Comune Sede Legale</td>
		<td>
			<%=StabilimentoDettaglio.getOperatore().getSedeLegale().getDescrizioneComune() %>
			
		</td>
	</tr>
	
	<tr>
		<td nowrap class="formLabel">
			Cap
		</td>
		<td>
			<%=StabilimentoDettaglio.getOperatore().getSedeLegale().getCap() %> 
		</td>
	</tr>
	
	<tr id ="searchcodeIdprovinciaTR">

		<td nowrap class="formLabel">
			Sigla Provincia
		</td>
		<td>
		<%=StabilimentoDettaglio.getOperatore().getSedeLegale().getDescrizione_provincia() %> 
			
			
			
		</td>
	</tr>
	
		
		<tr>
			<td nowrap class="formLabel">Denominazione</td>
			<td><%=StabilimentoDettaglio.getOperatore().getRagioneSociale()%> </td>
		</tr>
		
		
		
		
			
			<tr>
				<td class="formLabel" nowrap  >Codice Fiscale Proprietario</td>
				<td>
				<%=StabilimentoDettaglio.getOperatore().getRappLegale().getCodFiscale() %> 
				</td>
			</tr>
			
			<tr>
				<td nowrap class="formLabel">Proprietario (cognome e nome)</td>
				<td>
				<%=StabilimentoDettaglio.getOperatore().getRappLegale().getNome()+" "+StabilimentoDettaglio.getOperatore().getRappLegale().getCognome() %> 
				</td>

			</tr>
			
			
			<tr>
				<td class="formLabel" nowrap>Data Inizio Attivita</td>
				<td>
				<input type="text" size="70" name="dataInizio"
					id="dataInizioAttivita" readonly="readonly" class="required" placeholder="dd/MM/YYYY" <%=toDateasString(StabilimentoDettaglio.getOperatore().getDataInizio()) %>>
					
					<a href="#" onClick="cal19.select(document.forms['apicoltoreModifica'].dataInizioAttivita,'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19">
				<img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
					
					<font color="red">*</font>
					
				</td>
			</tr>
			
			
	<tr>
		<td nowrap class="formLabel">
			Indirizzo Sede Legale
		</td>
		<td>
			
			<%=StabilimentoDettaglio.getOperatore().getSedeLegale().getVia() %>
		</td>
	</tr>
	
	
	<tr>
		<td nowrap class="formLabel">
			Tipo Attivita
		</td>
		<td>
		<%
		TipoAttivitaApi.setJsEvent("onchange='mostraCampoExtra(this.value);'");
		%>
			<%=TipoAttivitaApi.getHtmlSelect("idTipoAttivita", StabilimentoDettaglio.getOperatore().getIdTipoAttivita()) %>
			
			<div id = "extraField" style="display: none">Annesso Laboratorio (Per Produzione Primaria) <input type = "checkbox" <% if(StabilimentoDettaglio.getOperatore().isFlagProduzioneConLaboratorio()){out.println("checked=\"checked\"");}%>
			name="produzioneConLaboratorio"></div>
			<font color="red">*</font>
			      				<%=showError(request, "tipoAttivitaError") %>
			      				<script>
			      				mostraCampoExtra("<%=StabilimentoDettaglio.getOperatore().getIdTipoAttivita()%>");
			      				</script>
			
			
		</td>
	</tr>
	
	<tr>
    		<td nowrap class="formLabel">
      			Domicilio Digitale<br>(Pec)
    		</td>
    		<td>
      			<input  type="email" size="100" name="domicilioDigitale" value="<%=toHtml2(StabilimentoDettaglio.getOperatore().getDomicilioDigitale()) %>" >    
      			<font color="red">*</font>
      			<%=showError(request, "domicilioDigitaleError") %>
      			
    		</td>
  		</tr>
  		
  		<tr>
    		<td nowrap class="formLabel">
      			Telefono Fisso
    		</td>
    		<td>
      			<input type="text" size="70" name="telefono1" value="<%=toHtml2(StabilimentoDettaglio.getOperatore().getTelefono1()) %>" >    
      			<font color="red">*</font>
      			<%=showError(request, "telefonoFissoError") %>
    		</td>
  		</tr>
  		
  		<tr>
    		<td nowrap class="formLabel">
      			Telefono Cellulare
    		</td>
    		<td>
      			<input type="text" size="70" name="telefono2" value="<%=toHtml2(StabilimentoDettaglio.getOperatore().getTelefono2()) %>" >    
      			<font color="red">*</font>
      				<%=showError(request, "telefonoCellulareError") %>
    		</td>
  		</tr>
  		
  		<tr>
    		<td nowrap class="formLabel">
      			Fax
    		</td>
    		<td>
      			<input type="text" size="70" name="fax" >    
    		</td>
  		</tr>
  		
  		

	

	
	</table>
	
	</fieldset>
	<br>
	<br>	
	

</form>











