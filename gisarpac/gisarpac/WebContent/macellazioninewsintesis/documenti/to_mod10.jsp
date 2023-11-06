<%@page import="org.aspcfs.modules.macellazioninewsintesis.utils.ConfigTipo"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio"%>

<%@page import="org.aspcfs.modules.macellazioninewsintesis.utils.MacelliUtil"%>

<%@page import="org.aspcfs.modules.util.imports.ApplicationProperties"%>
<jsp:useBean id="OrgDetails" class="org.aspcfs.modules.sintesis.base.SintesisStabilimento" scope="request" />

<script language="JavaScript" TYPE="text/javascript" SRC="dwr/interface/Geocodifica.js"> </script>
<script language="JavaScript" TYPE="text/javascript" SRC="dwr/engine.js"> </script>

<%@ include file="../../initPage.jsp"%>

<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popCalendar.js"></script>

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

<script type="text/javascript">


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


function openPopupModules(){
	var res;
	var result;

	altId = document.getElementById("altId").value ; 
	id_macello = document.getElementById("id_macello").value ; 
	url = document.getElementById("url").value ; 
	tipo = document.getElementById("tipo").value ; 
	sessione_macellazione = document.getElementById('comboSedutaMacellazione').value
	comboDateMacellazione  = document.getElementById("comboDateMacellazione").value ; 
		window.open('PrintModulesHTML.do?command=ViewModello10Macelli&sessione_macellazione='+sessione_macellazione+'&altId='+altId+'&id_macello='+id_macello+'&url='+url+'&tipo='+tipo+'&comboDateMacellazione='+comboDateMacellazione,'popupSelect',
		'height=800px,width=1280px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		
} 

</script>


<!-- ******************************************************************** -->

<%
	ConfigTipo configTipo = (ConfigTipo)request.getSession().getAttribute("configTipo");
%>

<table class="trails" cellspacing="0">
	<tr>
		<td>
			<a href="StabilimentoSintesisAction.do"><dhv:label name="stabilimenti.stabilimenti">Accounts</dhv:label></a> >
			<%
				if (request.getParameter("return") == null)
				{
			%>
					<a href="StabilimentoSintesisAction.do?command=ListaStabilimenti"><dhv:label
					name="stabilimenti.SearchResults">Search Results</dhv:label></a> >
					<a href="StabilimentoSintesisAction.do?command=DettaglioStabilimento&altId=<%=OrgDetails.getAltId() %>">Scheda Stabilimento</a> >
			<%
				}
				else if (request.getParameter("return").equals("dashboard"))
				{
			%>
					<a href="StabilimentoSintesisAction.do?command=Dashboard"><dhv:label
					name="communications.campaign.Dashboard">Dashboard</dhv:label></a> > <%
				}
			%>
			<a href="MacellazioniNewSintesis.do?command=List&altId=<%=OrgDetails.getAltId() %>">Macellazioni</a> > Modello 10
		</td>
	</tr>
</table>

<%
String param1 = "altId=" + OrgDetails.getAltId()+"&stabId=" + OrgDetails.getIdStabilimento(); request.setAttribute("Operatore",OrgDetails.getOperatore());
%>

<dhv:container 
	name="sintesismacelli"
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
	<font color="black"> Inserire la data di macellazione presente nella sezione Visita Post Mortem / Libero Consumo </font></br></br>
	
	* Nella combo sono presenti le ultime <%= ApplicationProperties.getProperty("numero_date_macellazione_combo") %> date di macellazione. Per date antecedenti � possibile usare il calendario.
	
	<font color="red"> <%=toHtmlValue( (String)request.getAttribute( "messaggio" ) ) %> </font>
	<br/><br/>
	
	<form name="main" action="PrintModulesHTML.do?command=ViewModello10Macelli" method="post" >
	<input type="hidden" name="altId" id="altId"  value="<%=OrgDetails.getAltId() %>" />
	<input type="hidden" name="id_macello" id="id_macello" value="<%=OrgDetails.getAltId() %>" />
	<input type="hidden" name="url" id="url" value="Stabilimenti" />
	<input type = "hidden" name = "tipo" id="tipo" value = "10">
		
		<select id="comboDateMacellazione" name="comboDateMacellazione" onchange="Geocodifica.getSeduteMacellazione(this.value,<%=OrgDetails.getAltId()%>,gestisciComboSedute)">
		<%for(String dataMacellazione : listaDateMacellazione){%>		
		<option value="<%= dataMacellazione %>" <%if(dataMacellazione.equals(request.getParameter("comboDateMacellazione"))){%> selected="selected"<% } %>  ><%= dataMacellazione %></option>
		<%		
		}
		%>
		</select>
		

	<select id="comboSedutaMacellazione" name="comboSedutaMacellazione" >
			<option value="0" selected="selected" >0</option>
			<option value="1" >1</option>
			<option value="2"  >2</option>
			<option value="3"  >3</option>
	</select>
		
		<input readonly type="text" style="display: none;" id="campoDataMacellazione" name="campoDataMacellazione" size="10" value="<%=DateUtils.timestamp2string(new Timestamp( System.currentTimeMillis() ))%>" />&nbsp;  
		<a href="#" onClick="cal19.select(document.forms[0].campoDataMacellazione,'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19">
		<img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
		
		<input type="button" onclick="openPopupModules()" value="Procedi" /><br>
		Attenzione ! generando il modello 10 per una seduta non sar� piu possibile modificare/inserire capi per la seduta su cui si effettua la stampa!
	
	</form>
 <%} 
	else
	{
 		out.println(configTipo.getMessaggioNessunTamponePerCapiMacellati());
 	}
%>	
</dhv:container>

