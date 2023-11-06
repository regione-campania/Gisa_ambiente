<script>
function verificaStatoControllo(dataChiusura){
	
	if(dataChiusura != null && dataChiusura != '' && dataChiusura != 'null'){
		var f = document.forms['myform'];
		for(var i=0,fLen=f.length;i<fLen;i++){

			if (f.elements[i].type == 'radio' || f.elements[i].type == 'checkbox')
		    { 
		          f.elements[i].disabled = true;
		    } 
			else if (f.elements[i].type == 'submit')
		    { 
		          f.elements[i].className = 'buttonClass';
		  
		    } 
		    else {
			    
		  		f.elements[i].readOnly = true;
		  		f.elements[i].className = 'layout';
		    }
		}
		var g = document.forms['myform'].getElementsByTagName("textarea");
		for(var j=0; j < g.length; j++)
			 g.item(j).className = '';

	//	document.getElementById('stampaId').style.display = 'none';
		document.getElementById('salvaId').style.display = 'none';
		document.getElementById('sId').style.display = 'none';
				
	}
}
</script>

<body onload="javascript:verificaStatoControllo('<%=PnaaDetails.getData_chiusura_campione()%>');
<%--javascript:closeAndRefresh('<%= request.getAttribute("chiudi")%>','<%= request.getAttribute("redirect")%>');--%>
if (typeof window.catturaHtml == 'function') {
catturaHtml(this.gestionePdf); 
this.gestionePdf.submit();}
">

<i><font size="2pt">ALLEGATO 1: Verbale di prelievo (PNAA)</i></font>
<div class="boxIdDocumento"></div>
<div align="right">
<font size="2pt"><b>SCHEDA N.</b></font><br/>
<input class="layout" type="text" readonly="readonly" name="num_scheda" id="num_scheda" value="<%=PnaaDetails.getListaCampiPna().get("a0").get("a0")  %>"/>
</div>
<div align="center">
<font size="4pt"><b>VERBALE DI PRELIEVO (PNAA)</b></font> <br/>
<i><%=(PnaaDetails.getMotivazione()!=null) ? PnaaDetails.getMotivazione() : "" %> </i>
</div>
<div align="right"><b><font size="2pt">
Verbale n. <img src="<%=createBarcodeImage(PnaaDetails.getNumVerbale())%>" />&nbsp;&nbsp;&nbsp;
<input class="layout" type="hidden" readonly="readonly" name="num_verbale" id="num_verbale" value="<%=PnaaDetails.getNumVerbale() %>" />
Data <input class="layout" type="text" readonly="readonly" name="data" id="data" value="<%=PnaaDetails.getData() %>" /></font>
</b>
</div>