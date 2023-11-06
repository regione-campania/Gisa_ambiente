function eliminaCheckList (idAudit,idControllo,orgId)
{
	if (confirm("Sei Sicuro di voler Eliminare Questa CheckList ? ")) 
	{
	    document.location = 'CheckListSoa.do?command=Delete&id='+idAudit+'&idControllo='+idControllo+'&orgId='+orgId;
	}
	
}

function compilaCheckList(messaggio,orgId,idControllo,idControlloUfficiale,isPrincipale,form)
{

	//if(confirm(messaggio))
	//{

		if(isPrincipale=='1')
		{
			if(confirm(messaggio))
			{
			document.forms[form].action='CheckListSoa.do?command=Add&orgId='+orgId+'&idC='+idControllo+'&isPrincipale=true&idControllo='+idControlloUfficiale
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
				document.forms[form].action='CheckListSoa.do?command=Add&orgId='+orgId+'&idC='+idControllo+'&isPrincipale=false&idControllo='+idControlloUfficiale
				setTimestampStartRichiesta();
				document.forms[form].submit();
			}
			}
			else
			{
				document.forms[form].action='CheckListSoa.do?command=Add&orgId='+orgId+'&idC='+idControllo+'&isPrincipale=false&idControllo='+idControlloUfficiale
				setTimestampStartRichiesta();
				document.forms[form].submit();
			}
			
			
		//}
			

	}
	
}

function allegaFile(form,gotoPage)
{


	document.forms[form].encoding="multipart/form-data";

document.forms[form].action = "SoaVigilanza.do?command=UploadListaDistribuzione&goto="+gotoPage;
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
document.forms[form].action = "SoaVigilanza.do?command=DeleteListaDistribuzione&goto="+gotoPage+"&fid="+fid+"&orgId="+orgId+"&folderId="+folderid;

document.forms[form].submit;
}

function aggiornaCategoria(idControllo,orgId,form)
{
	if (confirm("Con questa azione tutte le checklist associate vengono chiuse ed una nuova categoria di rischio viene associata all impresa. Sei sicuro di voler procedere?")) 
	{
		document.details.action='CheckListSoa.do?command=UpdateCategoria&idC='+idControllo+'&orgId='+orgId ;
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
	
	
	
	if ( (document.forms[form].tipoCampione.value == 5) )
	{
		document.getElementById('rigaATECO').style.display = "none";
	} else {
		
		document.getElementById('rigaATECO').style.display = "";
		orgId=document.forms[form].orgId.value ;
		if (  (document.forms[form].tipoCampione.value == '3') ) // audit selezione multipla
		{
			document.getElementById('tipo_selezione').value = 'true';
			document.getElementById("link_seleziona").innerHTML='selezionare una o piu linee di attivita'
		}
		if (  (document.forms[form].tipoCampione.value == '4') ) // ispezione selezione singola
		{
			document.getElementById("link_seleziona").innerHTML='selezionare una linea di attivita';

			document.getElementById('tipo_selezione').value = 'false';
			
			  var clonato = document.getElementById('la_stab_soa');
			  clonato.style.display="none"; 	
			 // clonato.getElementsByTagName('INPUT')[0].value = '';
			  //clonato.getElementsByTagName('INPUT')[1].value = '';
			  clone=clonato.cloneNode(true);
			  flagSelezione = false ; 
			 
			  elem_num = document.getElementById('num_linee');
			  
			  elem_num_int = parseInt(elem_num.value);
			  if (elem_num_int>1)
			  for(i=1 ;i<=elem_num_int ; i++)
			  {
				  
				  clonato.parentNode.removeChild(document.getElementById('la_stab_soa'+i));
				  elem_num.value -=1 ; 
			  }
		}	
		
	}
	
}




