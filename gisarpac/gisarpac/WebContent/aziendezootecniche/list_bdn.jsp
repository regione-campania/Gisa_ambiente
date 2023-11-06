
<%@page import="com.aspcfs.modules.aziendezootecniche.base.IstanzaAllevamentoBdn"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<%@page import="it.izs.bdn.bean.InfoAllevamentoBean"%>


<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<%@ include file="../initPage.jsp" %>


<script src="javascript/jquery-ui.js" type="text/javascript" ></script>



<link rel="stylesheet" type="text/css"
	href="css/jquery-ui-1.9.2.custom.css" />

<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Allevamenti.do"><dhv:label name="allevamenti.allevamenti">Accounts</dhv:label></a> > 
Interroga BDN
</tr>
</table>
<%-- End Trails --%>


<script>
$(function () {
    
   

	$( "#modalDialogDettaglioBdn" ).dialog({
    	autoOpen: false,
        resizable: false,
        closeOnEscape: false,
       	title:"DETTAGLIO ALLEVAMENTO BDN",
       	
        width:750,
        height:900,
        draggable: false,
        modal: true,
        buttons:{
        	 "ESCI" : function() { $(this).dialog("close");}
        }
       
       
    });
});
	    


function visualizzaDettaglio(codiceAzienda,idFiscale,codicepecie)
{
	
	$.ajax({
    	type: 'POST',
   		dataType: "html",
   		async: false,
   		cache: false,
   		url: "AziendeZootecniche.do?command=GetAllevamentoBDN",
		data: "codAzienda="+codiceAzienda+"&mode=VIEW&specieAzienda="+codicepecie+"&idFiscaleAzienda="+idFiscale,

    	success: function(msg) {
    		
    		document.getElementById('modalDialogDettaglioBdn').innerHTML=msg ; 
       	 
       		$('#modalDialogDettaglioBdn').dialog('open');
       		
   		},
   		error: function (err, errore) {
   			alert('ko '+errore);
   		
        }
		});
	
	
	
}

	
	       
</script>



<table cellpadding="8" cellspacing="0" border="0" width="100%" class="pagedList">
  <tr>
      <th >
          <strong>Codice Azienda</strong>
		</th>
		 <th >
          <strong>Denominazione</strong>
		</th>
		 <th >
          <strong>Specie</strong>
		</th>
		
		<th >
          <strong>Proprietario</strong>
		</th>
		<th >
          <strong>Detentore</strong>
		</th>
		<th>
          <strong>Data Inizio Attivita</strong>
		</th>
		<th >
          <strong>Data Fine Attivita</strong>
		</th>
		<th >
          <strong></strong>
		</th>
		
  </tr>

<%
ArrayList<IstanzaAllevamentoBdn> lista = (ArrayList<IstanzaAllevamentoBdn>)request.getAttribute("ListaAllevamenti");
for (IstanzaAllevamentoBdn all : lista)
{
	if(all.getErrore()!=null && all.getErrore().contains("Remote"))
	{
		%>
		<tr>
	    <td colspan="6"><font color="red"><%="I Servizi BDN al momento non sono disponibili" %></font></td></tr>
	    
	    <%
	}
	else
	{
		if(all.getErrore()!=null && !all.getErrore().equals(""))
		{
			%>
			<tr>
		    <td colspan="6"><font color="red"><%="Errore generico nella chiamata ai servizi BDN" %></font></td></tr>
		    
		    <%
		}
		else
		{
			
	%>
	<tr >
    <td><%=all.getCodiceazienda() %></td>
	<td><%=all.getDenominazione() %></td>
	<td> <%=all.getDescrizioneSpecie()%></td>
	<td><%= all.getDenominazioneProprietario()+"<br>"+ all.getIdFiscaleProprietario()  %></td>		
	<td><%= all.getDenominazioneDetentore()+"<br>"+ all.getIdFiscaleDetentore()  %></td>
	<td><%=all.getDataInizioAttivita() %></td>
	<td><%=toHtml(all.getDataFineAttivita()) %></td>
<td>

<form method="post" action="AziendeZootecniche.do?command=GetAllevamentoBDN">

<input type ="hidden" name = "codAzienda" value = "<%=all.getCodiceazienda()%>">
<input type ="hidden" name = "mode" value = "VIEW">
<input type ="hidden" name = "specieAzienda" value = "<%=all.getCodiceSpecie()%>">
<input type ="hidden" name = "idFiscaleAzienda" value = "<%=all.getIdFiscaleAllevamento()%>">
<input type = "submit" value = "Visualizza Dettaglio" > 


</form>




</td>
     </tr>
	
	
	<%
	}}
}


%>
</table>

<div id="modalDialogDettaglioBdn">

</div>
  