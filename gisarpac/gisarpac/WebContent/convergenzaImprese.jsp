<script language="JavaScript" TYPE="text/javascript" SRC="dwr/interface/ConvergenzaImprese.js"> </script>
<script language="JavaScript" TYPE="text/javascript" SRC="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>


<script>

var entriesChecked = {}

function checkPremuto(idOperatore, idStabilimento,campochek) //uso stabilimento come chiave
{
	
	
	var checked = campochek.checked;
	if(checked)
	{
		//alert("E' CHECKED");
		entriesChecked[idStabilimento] = idOperatore;
	}
	else
	{
		//alert("E' NON  CHECKED");
		delete entriesChecked[idStabilimento];
	}
	
	
	//CONTROLLO QUALE BOTTONE ATTIVARE:
	
	//se ho selezionato una sola entry, comunque non posso attivare bottoni
	if(Object.keys(entriesChecked).length <= 1)
		return;
	
	
	//scorro nella mappa con tutte le entries checked, e vedo se attivare il bottone per convergenza impianto
	//o per convergenza impresa
		//se tutte le entry hanno stesso id impresa, allora era già stata fatta convergenza per impresa, e disattivo il bottone conv impresa e attivo quello di stabilimento
  	//altrimenti il contrario se esiste almeno un'id impresa diverso 
	var tuttiUguali = true;
	var primoIdOp = entriesChecked[Object.keys(entriesChecked)[0]];
	
  	for(idStabs in entriesChecked)
	{
		if(entriesChecked[idStabs] !== primoIdOp)
		{
			
			tuttiUguali = false;
			break;
		}
	}
  	
  	
}

function intercettaBtnConvImpresa(pIva)
{
	//alert("CONV IMPRESA");
	//richiamo la action mandando la rapp json delle entries premute
	window.open("InterfAnalisiDuplicatiOpu.do?command=PreparaFormPerConvergenzaDuplicatiOperatore&entriesChecked="+JSON.stringify(entriesChecked)+"&pIvaRichiesta="+pIva);
	entriesChecked = {};
}


function eliminaImpreseSenzaStabilimenti(idImpresa)
{
	
	ConvergenzaImprese.eliminaImpreseSenzaStabilimenti(idImpresa,{callback:function(data){alert(data);},async:false});
	}
	
	
function eseguiConvergenzaStabilimento(nameRadio,nomeRadioIndirizzo,nameCheck,button)
{
	
	idScelto = -1 ;
	idSel=-1;
	indice = 0 ;
	var listaElementi = new Array();
	var idIndirizzoScelto =-1 ;
	
	for (i = 0 ; i <  document.getElementsByName(nameRadio).length; i++)
		{
			if (document.getElementsByName(nameRadio)[i].checked)
				{
					 idScelto=document.getElementsByName(nameRadio)[i].value;
					 break;
				}
		}
	
	for (i = 0 ; i <  document.getElementsByName(nomeRadioIndirizzo).length; i++)
	{
		if (document.getElementsByName(nomeRadioIndirizzo)[i].checked)
			{
			idIndirizzoScelto=document.getElementsByName(nomeRadioIndirizzo)[i].value;
				 break;
			}
	}
	
	
	for (i = 0 ; i <  document.getElementsByName(nameCheck).length; i++)
	{
		if (document.getElementsByName(nameCheck)[i].checked)
			{
				 idSel=document.getElementsByName(nameCheck)[i].value;
				 listaElementi[indice]=parseInt(idSel);
				 indice ++ ;
			}
	}
	
	if (idScelto>0 && listaElementi.length>0)
		ConvergenzaImprese.convergenzaStabilimento(idScelto,listaElementi,idIndirizzoScelto,{callback:function(data){alert(data);button.disabled=true;},async:false});
	else
		alert("Assicurati di aver Selezionato UNO stabilimento da mantenere e/o la lista di impresa da raggruppare");

}
function eseguiConvergenza(nameRadio,nomeRadioIndirizzo,nameCheck,button)
{
	
	idScelto = -1 ;
	idSel=-1;
	indice = 0 ;
	var listaElementi = new Array();
	var idIndirizzoScelto =-1 ;
	
	for (i = 0 ; i <  document.getElementsByName(nameRadio).length; i++)
		{
			if (document.getElementsByName(nameRadio)[i].checked)
				{
					 idScelto=document.getElementsByName(nameRadio)[i].value;
					 break;
				}
		}
	
	for (i = 0 ; i <  document.getElementsByName(nomeRadioIndirizzo).length; i++)
	{
		if (document.getElementsByName(nomeRadioIndirizzo)[i].checked)
			{
			idIndirizzoScelto=document.getElementsByName(nomeRadioIndirizzo)[i].value;
				 break;
			}
	}
	
	
	for (i = 0 ; i <  document.getElementsByName(nameCheck).length; i++)
	{
		if (document.getElementsByName(nameCheck)[i].checked)
			{
				 idSel=document.getElementsByName(nameCheck)[i].value;
				 listaElementi[indice]=parseInt(idSel);
				 indice ++ ;
			}
	}
	
	if (idScelto>0 && listaElementi.length>0)
		ConvergenzaImprese.convergenzaImpresa(idScelto,listaElementi,idIndirizzoScelto,{callback:function(data){alert(data);button.disabled=true;},async:false});
	else
		alert("Assicurati di aver Selezionato UNA impresa da mantenere e/o la lista di impresa da raggruppare");

}

</script>

<h1>HAI ESEGUITO LA SCELTA NUM. <%=request.getAttribute("Scelta") %></h1>
<%
StringBuffer output=(StringBuffer)request.getAttribute("Result");
%>


<%=output %>
