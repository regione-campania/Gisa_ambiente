function eliminaProva (idProva,orgId)
{
	if (confirm("Sei sicuro di voler eliminare questa prova? ")) 
	{
	    document.location = 'LaboratoriHACCP.do?command=DeleteProve&id='+idProva+'&orgId='+orgId;
	}
	
}

function aggiungiProva(orgId,form)
{

			document.forms[form].action='ElencoProveHACCP.do?command=Add&orgId='+orgId;
			document.forms[form].submit();
	
}

function modificaProva (idProva,orgId)
{
	
	window.open('ElencoProveHACCP.do?command=Modify&id='+idProva+'&orgId='+orgId+'&popup=true','modificaProve',
	'height=800px,width=680px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=no,resizable=no ,modal=yes');
	
	
}
