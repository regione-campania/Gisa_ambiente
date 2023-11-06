
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

<body onload="javascript:verificaStatoControllo('<%=OrgCampione.getData_chiusura_campione()%>'); if (typeof catturaHtml =='function') {catturaHtml(this.gestionePdf);}; if (this.gestionePdf!=null) {this.gestionePdf.submit();}">

<!--  INIZIO HEADER -->
<div class="header">
<TABLE cellpadding="10" style="border-collapse: collapse;table-layout:fixed;" width="100%">
 <col width="15%">
<col width="20%">
<col width="25%">
<col width="15%">
<col width="25%"> 
<TR>
<Td style="border:1px solid black;"><div class="boxIdDocumento"></div><br/><b><center>REGIONE<br> CAMPANIA</center></b>
<br/>
<center><img style="text-decoration: none;" height="80" width="80" documentale_url="" src="gestione_documenti/schede/images/<%=(OrgOperatore.getAsl()!=null) ? OrgOperatore.getAsl().toLowerCase() : ""%>.jpg" />
</center>

</Td>
<TD style="border:1px solid black;text-overflow: ellipsis; overflow: hidden;"><center><b>DIP. DI PREVENZIONE</b></center><BR>
<%-- SERVIZIO <input class="editField" type="text"  name="servizio" id="servizio"  value="<%=valoriScelti.get(z++) %>" size="20" maxlength=""/><br>
U.O. <input class="editField" type="text" name="uo" id="uo"  value="<%=valoriScelti.get(z++) %>" size="20" maxlength="" /><BR>
--%>
SERVIZIO <label class="layout"><%=OrgCampione.getServizio() != null ? OrgCampione.getServizio() : "" %></label><br>
U.O. <label class="layout"><%=OrgCampione.getUo() != null ? OrgCampione.getUo() : ""  %></label><BR>
SEDE <input class="editField" type="text" name="via_amm" id="via_amm"  value="<%=valoriScelti.get(z++) %>"  size="" maxlength="" /></br>
MAIL <input class="editField" type="text" name="mail" id="mail"  value="<%=valoriScelti.get(z++) %>" size="20" maxlength="" /></TD>
<TD style="border:1px solid black;"><b>CAMPIONE EFFETTUATO PER:</b><br> 
<label class="layout"><%= (OrgCampione.getPiano() != null) ? OrgCampione.getPiano().toUpperCase() : "" %></label>
</TD>									
<TD style="border:1px solid black;"><center><b>&nbsp; MOD <%=request.getParameter("tipo")%> &nbsp;</b><BR>
&nbsp; Rev. 6 del &nbsp; <BR>
&nbsp; 25/03/13&nbsp;</center>
</TD>
<TD  style="border:1px solid black;" ><center>
VERBALE<br>PRELEVAMENTO<br>CAMPIONE N.
<br>
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<% if(request.getParameter("tipo").equals("1")) { %>
<img src="<%=createBarcodeImage(OrgCampione.getBarcodeMolluschi())%>" />
<% } else { %>
<img src="<%=createBarcodeImage(OrgCampione.getBarcodePrelievo())%>" />
<% } %>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>
</center>
</TD>
</TR>
</table>
</div>
<!-- FINE HEADER -->