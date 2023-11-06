
    <script>
function verificaStatoControllo(dataChiusura){
	
	if(dataChiusura != null && dataChiusura != '' && dataChiusura != 'null'){
		var f = document.forms['myform'];
		for(var i=0,fLen=f.length;i<fLen;i++){

			if (f.elements[i].type == 'radio')
		    { 
		          f.elements[i].disabled = true;
		    } 
			else if (f.elements[i].type == 'submit')
		    { 
		       f.elements[i].className = 'buttonClass';
			   
		    } 
		    else if (f.elements[i].type == 'text'){
			    
		  		f.elements[i].readOnly = true;
		  		//f.elements[i].className = 'layout'; MANDA IN ERRORE IL DOCUMENTALE
		  		f.elements[i].style.background = "#ffffff";
		    }
		}
		var g = document.forms['myform'].getElementsByTagName("textarea");
		for(var j=0; j < g.length; j++)
			 g.item(j).className = '';

		//document.getElementById('stampaId').style.display = 'none';
		if (document.getElementById('salvaId')!=null)
			document.getElementById('salvaId').style.display = 'none';

				
	}
}
</script>

    <script>
function verificaStatoControllo2(dataChiusura){
	
	if(dataChiusura != null && dataChiusura != '' && dataChiusura != 'null'){
	
//document.getElementById('stampaId').style.display = 'none';
		if (document.getElementById('bottoneModifica1')!=null)
			document.getElementById('bottoneModifica1').style.display = 'none';
		if (document.getElementById('bottoneModifica2')!=null)
			document.getElementById('bottoneModifica2').style.display = 'none';
		if (document.getElementById('bottoneModifica3')!=null)
			document.getElementById('bottoneModifica3').style.display = 'none';
				
	}
}
</script>

<body onload="javascript:verificaStatoControllo('<%=OrgCampione.getData_chiusura_campione()%>'); javascript:verificaStatoControllo2('<%=OrgCampione.getData_chiusura_campione()%>'); if (typeof catturaHtml =='function') {catturaHtml(this.gestionePdf);}; if (this.gestionePdf!=null) {this.gestionePdf.submit();}">

<!--  INIZIO HEADER -->
<div class="header">

<table cellpadding="2" style="border-collapse: collapse;table-layout:fixed;" width="100%">
<col width="20%"><col width="60%">
<tr>
<td style="border: 1px solid black"><div class="boxIdDocumento"></div><br/><img style="text-decoration: none;" width="100%" documentale_url="" src="gestione_documenti/schede/images/<%=(OrgOperatore.getAsl()!=null) ? OrgOperatore.getAsl().toLowerCase() : ""%>.jpg" /></td>

<td style="border: 1px solid black; font-size: 13px"><div align="center"><b>AZIENDA USL VALLE D'AOSTA<br/>DIPARTIMENTO DI PREVENZIONE</b><br/><%=OrgCampione.getServizio() != null ? OrgCampione.getServizio() : "" %> <br/>Loc. Amérique, n. 7/L - 11020 QUART (AO)<br/>Tel. 0165/774613 · <u>protocollo@pec.ausl.vda.it</u></div></td>

<td style="border: 1px solid black; font-size: 13px">IDENTIFICAZIONE<br/>UNIVOCA<br/>

<center><b>
<% if (OrgCampione.getBarcodePrelievoNew()!=null && !OrgCampione.getBarcodePrelievoNew().equals("")) { %>
	<%=OrgCampione.getBarcodePrelievoNew()%>
	<%} else { %>
	<%=OrgCampione.getBarcodePrelievo()%>
<%} %>
</b></center>
</td>

</tr>

<tr>

<td colspan="2" style="border: 1px solid black; font-size: 13px"><div align="center">VERBALE DI CAMPIONAMENTO <%=(request.getParameter("tipo").equals("2") ? "MICROBIOLOGICO" : request.getParameter("tipo").equals("3") ? "CHIMICO" : "") %></div></td>

<td style="border: 1px solid black; font-size: 13px">N. ACCETTAZIONE<br/>..................</td>


</tr>

</table>

</div>
<div align="right"><font size="1px">IdCU: <%=OrgCampione.getIdControllo()%> IdCampione:  <%=request.getParameter("ticketId") %></font></div>
<!-- FINE HEADER -->