function eliminaCheckList (action,idAudit,idControllo,orgId)
{
	if (confirm("Sei Sicuro di voler Eliminare Questa CheckList ? ")) 
	{
	    document.location = action+'.do?command=Delete&id='+idAudit+'&idControllo='+idControllo+'&stabId='+orgId;
	}
	
}

function compilaCheckList(action,messaggio,orgId,idControllo,idControlloUfficiale,isPrincipale,form)
{

	//if(confirm(messaggio))
	//{
	var AgntUsr=navigator.userAgent.toLowerCase();
	var ExpYes=AgntUsr.indexOf('msie')!=-1?1:0;
	

		if(isPrincipale=='1')
		{
			if(confirm(messaggio))
			{
			document.forms[form].action=action+'.do?command=Add&stabId='+orgId+'&idC='+idControllo+'&isExpo='+ExpYes+'&isPrincipale=true&idControllo='+idControlloUfficiale
			setTimestampStartRichiesta();
			document.forms[form].submit();
			}
			}
		else
		{
			
			checklist_inserite = document.getElementById('checklist_inserite').value.split(';');
			isInserita = false ;
			for(i=0;i<checklist_inserite.length;i++)
			{
				if (checklist_inserite[i]==document.getElementById('accountSize').value)
				{
					isInserita = true ;
				}
			}
			if(isInserita == true)
			{
			if (confirm('Attenzione! La CheckList selezionata e\' stata gia\' inserita. Sei sicuro di voler inserire la stessa checklist') == true)
			{
				document.forms[form].action=action+'.do?command=Add&stabId='+orgId+'&idC='+idControllo+'&isPrincipale=false&isExpo='+ExpYes+'&idControllo='+idControlloUfficiale
				setTimestampStartRichiesta();
				document.forms[form].submit();
			}
			}
			else
			{
				document.forms[form].action=action+'.do?command=Add&stabId='+orgId+'&idC='+idControllo+'&isExpo='+ExpYes+'&isPrincipale=false&idControllo='+idControlloUfficiale
				setTimestampStartRichiesta();
				document.forms[form].submit();
			}
		
			
			
		//}
			

	}
	
}

function allegaFile(form,gotoPage)
{


document.forms[form].action = "OpuVigilanza.do?command=UploadListaDistribuzione&goto="+gotoPage;
formTest = true;
message = "";
if(document.getElementById("fileAllegare").value == "")
{
		message += label("check.vigilanza.richiedente.selezionato","- Richiesto il file da allegare \r\n");
      formTest = false;
	
}
if(document.forms[form].subject.value == "")
{
		message += label("check.vigilanza.richiedente.selezionato","- Richiesto il campo Oggetto \r\n");
      formTest = false;
	
}
if(formTest==true)
{

document.forms[form].submit;

}
else
{
	alert(message);
	return false;
}
}

function eliminaFileAllegato(fid,orgId,folderid,form,gotoPage)
{


	document.forms[form].encoding="multipart/form-data";
document.forms[form].action = "OpuVigilanza.do?command=DeleteListaDistribuzione&goto="+gotoPage+"&fid="+fid+"&stabId="+orgId+"&folderId="+folderid;

document.forms[form].submit;
}

function aggiornaCategoria(action,idControllo,orgId)
{
	if (confirm("Con questa azione tutte le checklist associate vengono chiuse ed una nuova categoria di rischio viene associata all impresa. Sei sicuro di voler procedere?")) 
	{
		document.details.action=action+'.do?command=UpdateCategoria&idC='+idControllo+'&orgId='+orgId ;
		document.details.submit();
	}
}
	
function showCampi(tipoIspezione)
{

	if(tipoIspezione == "7")
	{

		document.getElementById("tableHidden").style.display="";
	}
	else
	{	if (document.getElementById("tableHidden")!=null)
		{ 
			document.getElementById("tableHidden").style.display="none";
	
		}
	}
	
}

function gestioneVisibilitaCodiceAteco(form){
	
	
	if (document.getElementById('id_linea_sottoposta_a_controllo')!= null)
	{
	select = document.getElementById('id_linea_sottoposta_a_controllo').options;
	if (  (document.forms[form].tipoCampione.value == '5') )
	{
		document.getElementById('rigaATECO').style.display = "none";
	} else {
		if(document.getElementById('rigaATECO')!=null)
			document.getElementById('rigaATECO').style.display = "";
		if (  (document.forms[form].tipoCampione.value == '3') ) // audit selezione multipla
		{
			//document.getElementById("lab_linea").innerHTML='selezionare una o piu linee di attivita'

			for (i=0;i <select.length; i++)
			{
				if (select[i].value==-1)
				{
					select[i].text='selezionare una o piu linee di attivita';
					break;
				}
			}
			
			document.getElementById("id_linea_sottoposta_a_controllo").multiple=true ;
			document.getElementById("id_linea_sottoposta_a_controllo").size='5' ;
		}
		if (  (document.forms[form].tipoCampione.value == '4') ) // ispezione selezione singola
		{
			//document.getElementById("lab_linea").innerHTML='selezionare una linea di attivita'

			for (i=0;i <select.length; i++)
			{
				if (select[i].value==-1)
				{
					select[i].text='selezionare una linea di attivita';
					break;
				}
			}
			document.getElementById("id_linea_sottoposta_a_controllo").multiple=false ;
			document.getElementById("id_linea_sottoposta_a_controllo").size='1' ;
		}	
		
	}
	}
	
}

