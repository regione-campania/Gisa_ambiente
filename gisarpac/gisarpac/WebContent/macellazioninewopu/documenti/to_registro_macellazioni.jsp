<%@page import="org.aspcfs.modules.macellazioninewopu.utils.ConfigTipo"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio"%>

<%@page import="org.aspcfs.modules.macellazioninewopu.utils.MacelliUtil"%>
<jsp:useBean id="OrgDetails" class="org.aspcfs.modules.opu.base.Stabilimento" scope="request" />

<%@ include file="../../initPage.jsp"%>

<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popCalendar.js"></script>

<script language="JavaScript" TYPE="text/javascript" SRC="dwr/interface/Geocodifica.js"> </script>
<script language="JavaScript" TYPE="text/javascript" SRC="dwr/engine.js"> </script>

<!-- RELATIVO AL NUOVO CALENDARIO CON MESE E ANNO FACILMENTE MODIFICABILI -->
<SCRIPT LANGUAGE="JavaScript" SRC="javascript/CalendarPopup.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="javascript/common.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">document.write(getCalendarStyles());</SCRIPT>
<SCRIPT LANGUAGE="JavaScript" ID="js19">
var cal19 = new CalendarPopup();
cal19.showYearNavigation();
cal19.showYearNavigationInput();
cal19.showNavigationDropdowns();
</SCRIPT>

<SCRIPT LANGUAGE="JavaScript" ID="js19">
var nuoveStampe = false;

function chgAction( button )
{
	if (button.checked){
		action_name = button.value;
    if( action_name=="old" ) {
        document.getElementById('RegistroMacelliForm').action = 'MacellazioniDocumenti.do?command=RegistroMacellazioni';
        nuoveStampe = false;
    }
    else if( action_name=="new" ) {
    	document.getElementById('RegistroMacelliForm').action = 'GestioneDocumenti.do?command=GeneraPDFMacelli';
    	nuoveStampe = true;
    }
	}
}
</script>

<script type="text/javascript">

<%
	ConfigTipo configTipo = (ConfigTipo)request.getSession().getAttribute("configTipo");
%>
function openPopupRegistroMacellazioniPdf(altId){
	var res;
	var result;
	date = document.getElementById('comboDateMacellazione').value ;
	sedutaMacellazione = document.getElementById('comboSedutaMacellazione').value ;
	/*if (document.getElementById('ante_macellazione').checked)
	{
		ante_macellazione = 'on';
	}
	else
	{
		ante_macellazione = 'off';

	}

	if (document.getElementById('notEsitoBSE').checked)
	{
		notEsitoBSE = 'on';
	}
	else
	{
		notEsitoBSE = 'off';
	}
	
	window.open('MacellazioniDocumentiNewOpu.do?command=RegistroMacellazioni&altId='+altId+'&notEsitoBSE='+notEsitoBSE+'&ante_macellazione='+ante_macellazione+'&comboDateMacellazione='+date,'popupSelect',
	'toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=no,resizable=no ,modal=yes');*/
	sedutaMacellazione = 0;
	nuoveStampe = true;
	if (!nuoveStampe){
		window.open('MacellazioniDocumentiNewOpu.do?command=RegistroMacellazioni&altId='+altId+'&comboDateMacellazione='+date,'popupSelect',
		'toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=no,resizable=no ,modal=yes');
		}
		else{
			window.open('GestioneDocumenti.do?command=GeneraPDFMacelli&tipo=Macelli_Registro&altId='+altId+'&comboDateMacellazione='+date+'&comboSedutaMacellazione='+sedutaMacellazione,'popupSelect',
			'toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=no,resizable=no ,modal=yes');
		}

} 

function gestisciCampoDataMacellazione(){
	var select = document.getElementById('comboDateMacellazione'); //Recupero la SELECT

	 var NewOpt = document.createElement('option');
	 NewOpt.value=document.getElementById('campoDataMacellazione').value;
	 NewOpt.text=document.getElementById('campoDataMacellazione').value;
	 NewOpt.selected = true;
	 try{
	 select.add(NewOpt, null); //Metodo Standard, non funziona con IE
	 }
	 catch(e){
		 select.add(NewOpt); 
	 }
	//document.getElementById('campoDataMacellazione').disabled = true;
}
function gestisciComboSedute(sedute){
	var select = document.getElementById('comboSedutaMacellazione');
	select.options.length=0;
	select.style.display='none';
	if (sedute.length> 0) {
			
		for (i=0;i<sedute.length;i++){
			
			var NewOpt = document.createElement('option');
			if(sedute[i]!=0){
				NewOpt.value=sedute[i];
				NewOpt.text="Seduta "+sedute[i];
				 select.style.display='';
			}else{
				NewOpt.value=sedute[i];
				NewOpt.text="Seduta Corrente";
				}
			 try{
				 select.add(NewOpt, null); //Metodo Standard, non funziona con IE
			 }
			 catch(e){
				 select.add(NewOpt); 
			 }
		}
	}
	else {
		/*	select.style.display='none';
		select.options.length=0;
		var NewOpt = document.createElement('option');
		NewOpt.value=0;
		NewOpt.text="Seduta Corrente";
		try{
			 select.add(NewOpt, null); //Metodo Standard, non funziona con IE
		 }
		 catch(e){
			 select.add(NewOpt); 
		 }*/
	}
}

</script>

<!-- ******************************************************************** -->



<table class="trails" cellspacing="0">
	<tr>
		<td>
			<a href="OpuStab.do"><dhv:label name="stabilimenti.stabilimenti">Accounts</dhv:label></a> >
			<%
				if (request.getParameter("return") == null)
				{
			%>
					<a href="OpuStab.do?command=Search"><dhv:label
					name="stabilimenti.SearchResults">Search Results</dhv:label></a> >
					<a href="OpuStab.do?command=Details&altId=<%=OrgDetails.getAltId() %>">Scheda Stabilimento</a> >
			<%
				}
				else if (request.getParameter("return").equals("dashboard"))
				{
			%>
					<a href="OpuStab.do?command=Dashboard"><dhv:label
					name="communications.campaign.Dashboard">Dashboard</dhv:label></a> > <%
				}
			%>
			<a href="MacellazioniNewOpu.do?command=List&altId=<%=OrgDetails.getAltId() %>">Macellazioni</a> > Registro Macellazioni
		</td>
	</tr>
</table>

<%
String param1 = "altId=" + OrgDetails.getAltId()+"&stabId=" + OrgDetails.getIdStabilimento(); request.setAttribute("Operatore",OrgDetails.getOperatore());
%>

<dhv:container 
	name="suapmacelli"
	selected="macellazioni" 
	object="Operatore"  
	param="<%=param1 %>" 
	appendToUrl='<%= addLinkParams(request, "popup|popupType|actionId") %>' 
	>

<br/>
<%
	ArrayList<String> listaDateMacellazione = (ArrayList<String>)request.getAttribute("listaDateMacellazione");
	if(listaDateMacellazione != null && listaDateMacellazione.size() > 0){
	%>
<font color="black"> Inserire la data di macellazione presente nella sezione Visita Post Mortem </font></br></br>

<font color= "green" style="font-weight: bold;"> Saranno inclusi i capi morti Prima della Macellazione e quelli con Mancanza di Esito BSE</font> 

<font color="red"> <%=toHtmlValue( (String)request.getAttribute( "messaggio" ) ) %> </font>
<br/><br/>

<div align="right" style="display:none"> 
<b>Gestione stampe</b><br/>
<input type="radio" id="radio1" name="radio" value="old" onClick="chgAction(this)" checked="checked"/> Vecchia gestione
<input type="radio" id="radio2" name="radio" value="new" onClick="chgAction(this)"/> Nuova gestione  
</div>

<form name="RegistroMacelliForm" id="RegistroMacelliForm" action="GestioneDocumenti.do?command=GeneraPDFMacelli" method="post" >
<input type="hidden" name="tipo" value="Macelli_Registro" />
<input type="hidden" name="altId" value="<%=OrgDetails.getAltId() %>" />
<input type="hidden" name="id_macello" value="<%=OrgDetails.getAltId() %>" />

<%--	<zeroio:dateSelect form="main" field="data" showTimeZone="false" timestamp="<%=new Timestamp( System.currentTimeMillis() ) %>" />  --%>
	
	<select id="comboDateMacellazione" name="comboDateMacellazione" onchange="Geocodifica.getSeduteMacellazione(this.value,<%=OrgDetails.getAltId()%>,gestisciComboSedute)">
		<%for(String dataMacellazione : listaDateMacellazione){%>		
		<option value="<%= dataMacellazione %>" <%if(dataMacellazione.equals(request.getParameter("comboDateMacellazione"))){%> selected="selected"<% } %>  ><%= dataMacellazione %></option>
		<%		
		}
		%>
	</select>
	<!-- SEDUTE DI MACELLAZIONE -->
	<select id="comboSedutaMacellazione" name="comboSedutaMacellazione" style="display:none">
	
	</select>
	
	
	
	<input readonly type="text" style="display: none;" id="campoDataMacellazione" name="campoDataMacellazione" size="10" value="<%=DateUtils.timestamp2string(new Timestamp( System.currentTimeMillis() ))%>" />&nbsp;  
	<a href="#" onClick="cal19.select(document.forms[0].campoDataMacellazione,'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19">
	<img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
	<%-- <input type = "checkbox"  id = "ante_macellazione" name = "ante_macellazione" />
	&nbsp;
	Includi Capi Senza Esito BSE <input type = "checkbox"  id = "notEsitoBSE" name = "notEsitoBSE" />--%> 
	<input type="button" onclick="openPopupRegistroMacellazioniPdf(<%=OrgDetails.getAltId() %>)" value="Procedi" />

</form>
<% } 
	else
	{
		out.println(configTipo.getMessaggioNessunCapoMacellato());
	} 
%>
</dhv:container>

<script type="text/javascript">
onload =  function() {
		Geocodifica.getSeduteMacellazione( document.getElementById('comboDateMacellazione').value,<%=OrgDetails.getAltId()%>,gestisciComboSedute)
};
</script>