
function allegaFile(form,gotoPage)
{


	document.forms[form].encoding="multipart/form-data";

document.forms[form].action = "OperatoriFuoriRegioneVigilanza.do?command=UploadListaDistribuzione&goto="+gotoPage;
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
	alert(document.forms[form].action)
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
document.forms[form].action = "OperatoriFuoriRegioneVigilanza.do?command=DeleteListaDistribuzione&goto="+gotoPage+"&fid="+fid+"&orgId="+orgId+"&folderId="+folderid;

document.forms[form].submit;
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