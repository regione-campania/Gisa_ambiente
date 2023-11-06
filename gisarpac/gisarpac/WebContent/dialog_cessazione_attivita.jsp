<SCRIPT LANGUAGE="JavaScript" SRC="javascript/CalendarPopup.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="javascript/common.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">document.write(getCalendarStyles());</SCRIPT>
<SCRIPT LANGUAGE="JavaScript" ID="js19">
	var cal19 = new CalendarPopup();
	cal19.showYearNavigation();
	cal19.showYearNavigationInput();
	cal19.showNavigationDropdowns();
</SCRIPT>
<script>

function nascondiBottoni(form){
	form.salvaCessazione.disabled = true;
	form.esciCessazione.disabled = true;
	form.salvaCessazione.value = "ATTENDERE";
}



function openPopUpCessazioneAttivita()
{
	
	$( "#dialogCessazioneAttivita" ).dialog("open");
	}
$(function () {
	    
	 
	 $.fx.speeds._default = 1000;
	 
	 $( "#dialogCessazioneAttivita" ).dialog({
	    	autoOpen: false,
	        resizable: false,
	        closeOnEscape: false,
	       	title:"CESSAZIONE ATTIVITA'",
	        width:850,
	        height:370,
	        draggable: false,
	        modal: true,
	        
	        show: {
	            effect: "blind",
	            duration: 1000
	        },
	        hide: {
	            effect: "explode",
	            duration: 1000
	        }
	       
	    }).prev(".ui-dialog-titlebar");
	 
  
});         
</script>


<div id="dialogCessazioneAttivita">

<form method="post" action="<%=request.getParameter("urlSubmitCessazione")%>" onsubmit="return checkDataCessazione(cambiaFormatoData(document.forms[0].elements['dataCessazioneAttivita'].value));nascondiBottoni(this);">

<input type = "hidden" name="idAnagrafica" value="<%=request.getParameter("idAnagrafica") %>">
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
      <strong>INDICARE LA DATA DI CESSAZIONE ATTIVITA' </strong>
    </th>
  </tr>
   
    <tr>
      <td nowrap class="formLabel">
        Data
      </td>
      <td>
      
       <input type = "text" pattern="\d{1,2}/\d{1,2}/\d{4}" name="dataCessazioneAttivita"  id = "dataCessazioneAttivita" required="required" >
      	<a href="#" onClick="cal19.select(document.getElementById('dataCessazioneAttivita'),'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19">
		<img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
		
			
      </td>
    </tr>
    
      <tr>
      <td nowrap class="formLabel">
        Note
      </td>
      <td>
      <textarea rows="8" cols="50" name="noteCessazione"></textarea>		
      </td>
    </tr>
    
     <tr>
      <td colspan="2">
     
       
         <!-- <p align="left" style="margin-left: 2">
         <b>
         (ATTENZIONE) : L'operazione di Cessazione di Ufficio va utilizzata solo nel caso in cui la data di cessazione
         				di attivit� sia antecedente alla delibera 318/15.
       					Si  rende noto che un utilizzo scorretto di questa funzione potrebbe comportare incongruenze in
						fase di estrazione e rendicontazione dei dati.
       	</b>			
       		</p>		 -->	 
		      					 		
      </td>
    </tr>
   
    
</table>
 <input type="submit" value="SALVA" id="salvaCessazione">
 <input type="button" value="ESCI" id="esciCessazione" onclick="javasript:$( '#dialogCessazioneAttivita' ).dialog('close');">
</form>

</div>



<script>
	
	/*da dd/MM/yyyy che e' il formato atteso dal server a yyyy-MM-dd che e' il formato per il date di js */
	function cambiaFormatoData(originalStrDate)
	{
		if(originalStrDate.trim().length == 0)
			return '';
		
		var t = originalStrDate.split("/");
		var finalStrDate =  t[2]+"-"+t[1]+"-"+t[0];
		return finalStrDate;
	}
	
	function checkDataCessazione(strDataCessazione)
	{
		
		try
		{
			if(strDataCessazione == undefined || strDataCessazione.trim().length == 0)
			{

				//alert("DATA INVALIDA");
				return false;
			}
			var todayDate = new Date();
			var cessazioneDate = new Date(strDataCessazione);
			if(todayDate < cessazioneDate)
			{
				alert("Attenzione, la data di cessazione deve essere nel passato.")
				
				//alert("DATA INVALIDA");
				return false;
			}
			else
			{
				var strDataInizio = '<%= request.getParameter("data_inizio") != null ? request.getParameter("data_inizio") : ""%>';
				if(strDataInizio.trim().length > 0)
				{
					var dataInizioDate = new Date(strDataInizio);
					if(cessazioneDate < dataInizioDate)
					{
						alert("Attenzione, la data di cessazione non puo' essere precedente alla data inizio attivita' ("+strDataInizio+")");

						//alert("DATA INVALIDA");
						return false;
					}
				}
				
				
			}
			
			//alert("DATA VALIDA");
			return true;
		}
		catch(E)
		{
			//alert("DATA INVALIDA");
			return true;
		}
		
	}
</script>
