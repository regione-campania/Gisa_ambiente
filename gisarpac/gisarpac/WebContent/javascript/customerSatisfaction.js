 $(function() {
            	var Return;
            	$( "#dialogCustomerSatisfaction" ).dialog({
                	autoOpen: false,
                    resizable: false,
                    draggable:false,
                    modal: true,
                    width:650,
                    height:300
                   
            });
 });

function openCustomerSatisfaction()
{
	
	if (document.getElementById("iniTime").value!='')
	{
	$(document).ready(function() {
		
		$('#dialogCustomerSatisfaction').dialog('open');
		});
	}}
	


function closeCustomerSatisfaction()
{
$('#dialogCustomerSatisfaction').dialog('close');
disabilita=0 ;
document.getElementById('iniTime').value='';
}
var disabilita = 0 ;

function saveSatisfaction( data_operazione, username, soddisfatto, descrizione_problema, operazione_eseguita,longtimeini,longtimeend)
{
	
	
	if (soddisfatto=='no' && descrizione_problema.trim().length<15)
		{
		alert('Attenzione, si prega di fornire una descrizione di almeno 15 caratteri per il problema riscontrato.');
		}
	else
		{
		if (document.getElementById("check").checked && document.getElementById("tel").value.trim()=='')
			{
			alert('Attenzione se desiderate essere contattati dal nostro servizio  help-desk fornire un recapito telefonico valido!');

			}
		else
			{
		if (disabilita==0 && document.getElementById('iniTime').value!=''){
			if (document.getElementById("tel").value != '')
				descrizione_problema+="\n [DESIDERO ESSERE CONTATTATO AL "+document.getElementById("tel").value+"]";
				disabilita = 1 ;
				DwrCustomSatisfaction.insertCustomSatisfaction(data_operazione, username, soddisfatto, descrizione_problema, operazione_eseguita,longtimeini,longtimeend,{callback:saveSatisfactionCallBack});
				
		}
			}
		}
}


function calcolaTempoEsecuzione( longtimeini,longtimeend,comando,action)
{
	

		if ( document.getElementById('iniTime').value!=''){
					DwrCustomSatisfaction.calcolaTempoEsecuzioneCustomSatisfaction(longtimeini,longtimeend,comando,action,{callback:calcolaTempoEsecuzioneCallBack});
				
		}
			
		
}




function calcolaTempoEsecuzioneCallBack(secondi)
{
	if (secondi<20)
		document.getElementById("label_tempo_esecuzione").innerHTML="<h3>OPERAZIONE ESEGUITA IN "+secondi+" SECONDI</h3>"

}

function saveSatisfactionCallBack(val)
{

	closeCustomerSatisfaction();
}