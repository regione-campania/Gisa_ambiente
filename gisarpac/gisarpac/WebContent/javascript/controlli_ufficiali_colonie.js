function eliminaCheckList (idAudit,idControllo,orgId)
{
	if (confirm("Sei Sicuro di voler Eliminare Questa CheckList ? ")) 
	{
	    document.location = 'CheckListColonie.do?command=Delete&id='+idAudit+'&idControllo='+idControllo+'&orgId='+orgId;
	}
	
}

function compilaCheckList(messaggio,orgId,idControllo,idControlloUfficiale,isPrincipale,form)
{

	/*if(confirm(messaggio))
	{*/

		if(isPrincipale=='1')
		{
			if(confirm(messaggio))
			{
			document.forms[form].action='CheckListColonie.do?command=Add&orgId='+orgId+'&idC='+idControllo+'&isPrincipale=true&idControllo='+idControlloUfficiale
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
				document.forms[form].action='CheckListColonie.do?command=Add&orgId='+orgId+'&idC='+idControllo+'&isPrincipale=false&idControllo='+idControlloUfficiale
				setTimestampStartRichiesta();
				document.forms[form].submit();
			}
			}
			else
			{
				document.forms[form].action='CheckListColonie.do?command=Add&orgId='+orgId+'&idC='+idControllo+'&isPrincipale=false&idControllo='+idControlloUfficiale
				setTimestampStartRichiesta();
				document.forms[form].submit();
			}
			
			
			
		}
			

	//}
	
}

function allegaFile(form,gotoPage)
{

document.forms[form].encoding="multipart/form-data";

document.forms[form].action = "ColonieVigilanza.do?command=UploadListaDistribuzione&goto="+gotoPage;
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
document.forms[form].action = "ColonieVigilanza.do?command=DeleteListaDistribuzione&goto="+gotoPage+"&fid="+fid+"&orgId="+orgId+"&folderId="+folderid;

document.forms[form].submit;
}

function aggiornaCategoria(idControllo,orgId)
{
	if (confirm("Con questa azione tutte le checklist associate vengono chiuse ed una nuova categoria di rischio viene associata al canile. Sei sicuro di voler procedere?")) 
	{
		document.details.action='CheckListColonie.do?command=UpdateCategoria&idC='+idControllo+'&orgId='+orgId ;
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


