<%@page import="org.aspcfs.modules.macellazioninew.utils.ConfigTipo"%>
<%@page import="org.aspcfs.modules.util.imports.ApplicationProperties"%>
<%@page import="java.util.ArrayList"%>
<jsp:useBean id="OrgDetails" class="org.aspcfs.modules.stabilimenti.base.Organization" scope="request" />
<%@ include file="../initPage.jsp"%>

<%
	String param1 = "orgId=" + OrgDetails.getOrgId();
	ConfigTipo configTipo = (ConfigTipo)request.getSession().getAttribute("configTipo");
%>
<dhv:container 
	name="<%=(OrgDetails.isMacelloUngulati()) ? ("stabilimenti_macellazioni_ungulati") : ("stabilimenti") %>"
	selected="macellazioni" 
	object="OrgDetails" 
	param="<%=param1 %>" 
	appendToUrl='<%= addLinkParams(request, "popup|popupType|actionId") %>' 
	hideContainer="<%= !OrgDetails.getEnabled() || OrgDetails.isTrashed() %>">

<dhv:permission name="stabilimenti-stabilimenti-macellazioni-add">
	<a href="MacellazioniNew.do?command=NuovoCapo&<%=param1 %>">Aggiungi Capo</a>
</dhv:permission>

<dhv:permission name="stabilimenti-stabilimenti-macellazioni-view">
	<a href="MacellazioniDocumentiNew.do?command=ToRegistroMacellazioni&<%=param1 %>">Registro Macellazioni</a>
</dhv:permission>

<dhv:permission name="stabilimenti-stabilimenti-macellazioni-view">
	<a href="MacellazioniDocumentiNew.do?command=ToArt17&<%=param1 %>">Articolo 17</a>
</dhv:permission>

<dhv:permission name="stabilimenti-stabilimenti-macellazioni-view">
	<a href="MacellazioniDocumentiNew.do?command=ToMod10&<%=param1 %>">Modello 10</a>
</dhv:permission>

<%if(ApplicationProperties.getProperty("visibilita_link_macelli").equals("si")){ %>
<dhv:permission name="stabilimenti-stabilimenti-macellazioni-view">
	<a href="MacellazioniDocumentiNew.do?command=ToMortiStalla&<%=param1 %>">Anim. morti in stalla/trasporto</a>
</dhv:permission>



<dhv:permission name="stabilimenti-stabilimenti-macellazioni-view">
	<a href="MacellazioniDocumentiNew.do?command=ToBSE&<%=param1 %>">Modulo BSE</a>
</dhv:permission>



<dhv:permission name="stabilimenti-stabilimenti-macellazioni-view">
	<a href="MacellazioniDocumentiNew.do?command=ToAbbattimento&<%=param1 %>">Abbattimento</a>
</dhv:permission>


<br/><br/>


<dhv:permission name="stabilimenti-stabilimenti-macellazioni-view">
	<a href="MacellazioniNew.do?command=PrintBRCRilevazioneMacelli&file=BRC_rilevazione_macelli.xml&<%=param1 %>">BRC rilevazione macelli</a>
</dhv:permission>

<dhv:permission name="stabilimenti-stabilimenti-macellazioni-view">
	<a href="MacellazioniNew.do?command=PrintTBCRilevazioneMacelli&file=TBC_rilevazione_macelli.xml&<%=param1 %>">TBC rilevazione macelli</a>
</dhv:permission>

<dhv:permission name="stabilimenti-stabilimenti-macellazioni-view">
	<a href="MacellazioniNew.do?command=ToModelloIdatidosi&<%=param1 %>">Modello idatidosi</a>
</dhv:permission>

<dhv:permission name="stabilimenti-stabilimenti-macellazioni-view">
	<a href="MacellazioniNew.do?command=PrintModelloMarchi&file=modello_marchi.xml&<%=param1 %>">Modello marchi</a>
</dhv:permission>

<dhv:permission name="stabilimenti-stabilimenti-macellazioni-view">
	<a href="MacellazioniNew.do?command=PrintMacellazioneAnimaliInfetti&file=macellazione_animali_infetti.xml&<%=param1 %>">Macellazione animali infetti</a>
</dhv:permission>

<dhv:permission name="stabilimenti-stabilimenti-macellazioni-view">
	<a href="MacellazioniNew.do?command=PrintDisinfezioneMezziTrasporto&file=disinfezione_mezzi_di_trasporto.xml&<%=param1 %>">Disinfezione mezzi di trasporto</a>
</dhv:permission>
<%} %>


&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="red"><br/><%=toHtmlValue( (String)request.getAttribute( "messaggio" ) ) %></font>

<br/><br/>
 Attenzione! Si ricorda che per concludere definitivamente la seduta di macellazione occorre stampare l'articolo 17 e che tutti i dati saranno riportati nel registro di macellazione.
 
<table border="1" bordercolor="#729FCF" align="center" style="text-align: center;" width="500px">
<tr>
<th>Capi Macellati</th>
<th>Capi NON Macellati</th>
</tr>
<tr>
<td>

<%
ArrayList<String> listaDateMacellazione = (ArrayList<String>)request.getAttribute("listaDateMacellazione");
if(listaDateMacellazione.size() > 0){
%>
<form name="macellazioniForm" action="MacellazioniNew.do?command=List" method="post">
	<input type="hidden" name="orgId" value="<%=OrgDetails.getOrgId() %>" />
	<p>Seleziona la data di macellazione</p>
	<select id="comboDateMacellazione" name="comboDateMacellazione">
	<%for(String dataMacellazione : listaDateMacellazione){%>		
	<option value="<%= dataMacellazione %>" <%if(dataMacellazione.equals(request.getParameter("comboDateMacellazione"))){%> selected="selected"<% } %>  ><%= dataMacellazione %></option>
	<%		
	}
	%>
<!--	<option value="-1" <%if("-1".equals(request.getParameter("comboDateMacellazione"))){%> selected="selected"<% } %>>Capi non macellati</option>-->
	</select>
	<input readonly type="text" id="campoDataMacellazione" name="campoDataMacellazione" size="10" style="display: none" />&nbsp;  
	<a href="#" onClick="cal19.select(document.forms[0].campoDataMacellazione,'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19">
	<img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
	<input type="submit" value="Procedi"></input>
</form>

<%} %>

</td>
<td>
<form name="macellazioniForm" action="MacellazioniNew.do?command=List" method="post">
	<input type="hidden" name="orgId" value="<%=OrgDetails.getOrgId() %>" />
	<input type="hidden" name="comboDateMacellazione" value="-1" />
	<input type="submit" value="Procedi"></input>
</form>
</td>
</tr>
</table>

<%
if(listaDateMacellazione.size() > 0){
%>
<form name="macellazioniForm" action="MacellazioniNew.do?command=AddSedutaMacellazione" onsubmit="return(confirm('Cliccando su OK verr� chiusa definitivamente la corrente seduta di Macellazione e aperta la nuova per la giornata selezionata'))" method="post">
<input type="hidden" name="orgId" value="<%=OrgDetails.getOrgId() %>" />
<p>Aggiungi una seduta di macellazione</p>
	<select id="comboDateMacellazione" name="comboDateMacellazione">
	<%for(String dataMacellazione : listaDateMacellazione){%>		
	<option value="<%= dataMacellazione %>" <%if(dataMacellazione.equals(request.getParameter("comboDateMacellazione"))){%> selected="selected"<% } %>  ><%= dataMacellazione %></option>
	<%		
	}
	%>
	<input type="submit" value="Aggiungi"></input>
</form>
<% } %>



<br/>
		<% String dataMacellaz = ""; %>
		<%
		if(request.getParameter("comboDateMacellazione") != null && !request.getParameter("comboDateMacellazione").equals("") ){ 
			dataMacellaz = request.getParameter("comboDateMacellazione");
		%>
			Lista capi <%= dataMacellaz.equals("-1") ? "non macellati" : "macellati il " + dataMacellaz %>
		<%}else if(listaDateMacellazione.size() > 0){ 
			dataMacellaz = listaDateMacellazione.get(0);
		%>
			Lista capi del <%= dataMacellaz %>
		<%} %>
		
		<form name="macellazioniForm" method="post" action="MacellazioniNew.do?command=List">
			<input type="hidden" name="orgId" value="<%=OrgDetails.getOrgId() %>" />
			<input type = "hidden" name = "comboDateMacellazione"  value="<%=dataMacellaz %>"/>
	       <%=request.getAttribute( "tabella" )%>
	    </form>
	    
	 <script type="text/javascript">
            function onInvokeAction(id) {
                $.jmesa.setExportToLimit(id, '');
                $.jmesa.createHiddenInputFieldsForLimitAndSubmit(id);
            }
            function onInvokeExportAction(id) {
                var parameterString = $.jmesa.createParameterStringForLimit(id);
                alert(parameterString);
                //location.href = 'MacellazioniNew.do?command=List&' + parameterString;
            }
    </script>
 
</dhv:container>