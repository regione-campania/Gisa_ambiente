

<%@page import="org.aspcfs.modules.oia.base.OiaNodo"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.aspcf.modules.controlliufficiali.base.Piano"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.aspcfs.modules.vigilanza.base.Ticket"%>
<link rel="stylesheet" type="text/css" href="javascript/jquerypluginTableSorter/css/theme.css"></link>



<script>

function settaUnitaOperativa(posizione)
{
	 
	 $('input[name=uoSelect]:checked').val();
	 $('input[name=uoSelect]:checked').attr('uo');
	 
	 if (document.getElementById('tipoIspezionePerContoDiDialog').value=='piano')
		 {
		
		 if ( $('input[name=uoSelect]:checked').length>0 )
			 {
	 document.getElementById('uodescr'+posizione).innerHTML= $('input[name=uoSelect]:checked').attr('uo');
	 document.getElementById('uo'+posizione).value= $('input[name=uoSelect]:checked').val();
	 
	 if (posizione==1)
		 {
		 indice = 2 ;
		 while (document.getElementById('uodescr'+indice)!=null)
			 {
			 document.getElementById('uodescr'+indice).innerHTML= $('input[name=uoSelect]:checked').attr('uo');
			 document.getElementById('uo'+indice).value= $('input[name=uoSelect]:checked').val();
			 indice ++ ;
			 }
		 
		 }
			 }
		 
		 }
	 else
		 {
		 document.getElementById('descrizione_'+posizione).innerHTML= $('input[name=uoSelect]:checked').attr('uo');
		 document.getElementById('per_condo_di'+posizione).value= $('input[name=uoSelect]:checked').val();
		 
		 
		 
		 }
}

$(function () {
	    
	
	
	
	 $( "#dialogPerContoDi" ).dialog({
	    	autoOpen: false,
	        resizable: false,
	        closeOnEscape: false,
	       	title:"LISTA STRUTTURE DPAT",
	        width:850,
	        height:500,
	        draggable: false,
	        modal: true,
	        buttons:{
	        	 "FATTO": function() {settaUnitaOperativa(document.getElementById("posizionePianoDialog").value); $(this).dialog("close"); } ,
	        	 "ESCI" : function() { $(this).dialog("close");}
	        	
	        },
	        show: {
	            effect: "blind",
	            duration: 1000
	        },
	        hide: {
	            effect: "explode",
	            duration: 1000
	        }
	       
	    }).prev(".ui-dialog-titlebar").css("background","#bdcfff");
	 
  
});         
</script>

	<div id ="dialogPerContoDi">
		<%
		ArrayList<OiaNodo> listaDialog = (ArrayList<OiaNodo>)request.getAttribute("StrutturaAsl");
		%>		
	<input type = "hidden" name = "posizionePianoDialog" id = "posizionePianoDialog">	
	<input type = "hidden" name = "tipoIspezionePerContoDiDialog" id = "tipoIspezionePerContoDiDialog">	


<font color="red">Attenzione! Di seguito sono riportate tutte le strutture presenti nello strumento di calcolo per cui è stato eseguito il "Salva e Chiudi".<br>
Qualora non fossero presenti le strutture desiderate, controllare che figurino correttamente nello strumento di calcolo e che quest'ultimo sia stato Salvato/Chiuso.
</font>
<br>

<table  class="tablesorter" id="tablelistastrutture">

	<thead>
		<tr class="tablesorter-headerRow" role="row">
		<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRO TIPO STRUTTURA" class="first-name filter-select"><div class="tablesorter-header-inner">ASL</div></th>
			<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRO TIPO STRUTTURA" class="filter-match tablesorter-header tablesorter-headerUnSorted"><div class="tablesorter-header-inner">TIPOLOGIA STRUTTURA</div></th>
			<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRO PER DESCRIZIONE" class="filter-match tablesorter-header tablesorter-headerUnSorted"><div class="tablesorter-header-inner">DESCRIZIONE STRUTTURA</div></th>
			
			<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="0" data-placeholder="FILTRO PER STRUTTURA APPARTENENZA" class="filter-match tablesorter-header tablesorter-headerUnSorted"><div class="tablesorter-header-inner">STRUTTURA DI APPARTENENZA</div></th>
			<th aria-sort="none" style="-moz-user-select: none;" unselectable="on" aria-controls="table" aria-disabled="false" role="columnheader" scope="col" tabindex="0" data-column="1" data-placeholder="FILTRO PER DESCRIZIONE PIANO" class="filter-false tablesorter-header"><div class="tablesorter-header-inner">&nbsp;</th>
					
		</tr>
	</thead>
	<tbody aria-relevant="all" aria-live="polite">
	
	<%
	if(listaDialog.size()>0){
	for (OiaNodo nodoAsl : listaDialog)
	{
		if(nodoAsl.getLista_nodi().size()>0)
		{
			for (OiaNodo nodoFiglio :nodoAsl.getLista_nodi() )
			{
				if (nodoFiglio.getTipologia_struttura()!=13 && nodoFiglio.getTipologia_struttura()!=14)
				{
				%>
				
				<tr>
				<td><%= toHtml2(SiteIdList.getSelectedValue( nodoFiglio.getId_asl()))%></td>
				<td><%= toHtml2(nodoFiglio.getDescrizione_tipologia_struttura())%></td>
				<td><%=nodoFiglio.getDescrizione_lunga() %></td>
				<td><%=nodoAsl.getDescrizione_lunga() %></td>
				<td><input type="radio" uo="<%=nodoAsl.getDescrizione_lunga().replaceAll("\"", "")+"->"+nodoFiglio.getDescrizione_lunga().replaceAll("\"", "")  %>" name = "uoSelect" value="<%=nodoFiglio.getId()%>"></td>
				</tr>
				
				<%}
			}
			
			for (OiaNodo nodoFiglio :nodoAsl.getLista_nodi() )
			{
				if(nodoFiglio.getLista_nodi().size()>0)
				{
									
					for (OiaNodo nipote :nodoFiglio.getLista_nodi() )
					{
						if (nipote.getTipologia_struttura()!=13 && nipote.getTipologia_struttura()!=14)
						{
						%>
						<tr>
				
			<td><%= toHtml2(SiteIdList.getSelectedValue( nipote.getId_asl()))%></td>
				<td><%= toHtml2(nipote.getDescrizione_tipologia_struttura())%></td>
				<td><%=nipote.getDescrizione_lunga() %></td>
				<td><%=nodoFiglio.getDescrizione_lunga() %></td>
				<td><input type="radio" uo="<%=nodoFiglio.getDescrizione_lunga().replaceAll("\"", "")+"->"+nipote.getDescrizione_lunga().replaceAll("\"", "")  %>" name = "uoSelect" value="<%=nipote.getId()%>"></td>
				
					</tr>	<%}
						
					}
				}
				
				
			}
		}
		
	}
	}
	else
	{
		%>
		<tr>
		<td colspan="5">ATTENZIONE! NESSUN STRUTTURA PRESENTE</td>
		</tr>
		<%
	}
	%>
	
	</tbody>
	
	</table>
	
	
	
		</div>
		
		
	
	
	