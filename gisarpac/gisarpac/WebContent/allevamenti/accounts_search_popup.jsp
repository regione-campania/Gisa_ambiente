<%-- 
  - Copyright(c) 2004 Dark Horse Ventures LLC (http://www.centriccrm.com/) All
  - rights reserved. This material cannot be distributed without written
  - permission from Dark Horse Ventures LLC. Permission to use, copy, and modify
  - this material for internal use is hereby granted, provided that the above
  - copyright notice and this permission notice appear in all copies. DARK HORSE
  - VENTURES LLC MAKES NO REPRESENTATIONS AND EXTENDS NO WARRANTIES, EXPRESS OR
  - IMPLIED, WITH RESPECT TO THE SOFTWARE, INCLUDING, BUT NOT LIMITED TO, THE
  - IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY PARTICULAR
  - PURPOSE, AND THE WARRANTY AGAINST INFRINGEMENT OF PATENTS OR OTHER
  - INTELLECTUAL PROPERTY RIGHTS. THE SOFTWARE IS PROVIDED "AS IS", AND IN NO
  - EVENT SHALL DARK HORSE VENTURES LLC OR ANY OF ITS AFFILIATES BE LIABLE FOR
  - ANY DAMAGES, INCLUDING ANY LOST PROFITS OR OTHER INCIDENTAL OR CONSEQUENTIAL
  - DAMAGES RELATING TO THE SOFTWARE.
  -   
  - Version: $Id: accounts_search.jsp 18543 2007-01-17 02:55:07Z matt $
  - Description: 
  --%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="org.aspcfs.modules.base.Constants,org.aspcfs.utils.web.*" %>

<%@page import="org.aspcfs.modules.accounts.base.Comuni"%><jsp:useBean id="SearchOrgListInfo" class="org.aspcfs.utils.web.PagedListInfo" scope="session"/>
<jsp:useBean id="AccountStateSelect" class="org.aspcfs.utils.web.StateSelect" scope="request"/>
<jsp:useBean id="ContactStateSelect" class="org.aspcfs.utils.web.StateSelect" scope="request"/>
<jsp:useBean id="CountrySelect" class="org.aspcfs.utils.web.CountrySelect" scope="request"/>
<jsp:useBean id="ComuniList" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="SegmentList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TypeSelect" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="malattie" class="java.util.HashMap" scope="request"/>
<jsp:useBean id="qualifiche" class="java.util.HashMap" scope="request"/>
<jsp:useBean id="SiteList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SpecieAllevata" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="CategoriaSpecie" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="InfoAllevamentoBean" class="it.izs.bdn.bean.InfoAllevamentoBean" scope="request"/>



<jsp:useBean id="OrientamentoProduttivo" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipologiaStruttura" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="StageList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></script>
<script type="text/javascript" src="dwr/interface/PopolaCombo.js"> </script>
        <script type="text/javascript" src="dwr/engine.js"> </script>
        <script type="text/javascript" src="dwr/util.js"></script>
        <script type="text/javascript">


      
        function alertErrorImportCapo(iderrore,descrizione)
        {
			msg = 'Capo non Importato dalla BDN \n';
			msg+='Cod Errore: '+iderrore+'\n';
			msg+='Errore : '+descrizione ;
			alert(msg);
         }
			function popolaComboSpecie()
			{
				PopolaCombo.getValoriComboSpecie(document.searchAccount.searchcodegruppo_specie.value,setSpecieComboCallback) ;
			}
			

          function popolaTipologiaStruttura(value)
          {
             
           	PopolaCombo.getValoriComboTipologiaStruttura(document.searchAccount.searchcodegruppo_specie.value,dateCallback) ;

		  }

          function popolaOrientamentoProduttivo(value)
          {
             
           	PopolaCombo.getValoriComboOrientamentoProduttivo(document.searchAccount.searchcodeTipologiaStruttura.value,document.searchAccount.searchcodegruppo_specie.value,setOerientamentoProdComboCallback) ;

		  }

          function setOerientamentoProdComboCallback(returnValue)
          {
        	  var select = document.forms['searchAccount'].searchcodeOrientamentoProduttivo; //Recupero la SELECT
              

              //Azzero il contenuto della seconda select
              for (var i = select.length - 1; i >= 0; i--)
            	  select.remove(i);

              indici = returnValue [0];
              valori = returnValue [1];
              //Popolo la seconda Select
              for(j =0 ; j<indici.length; j++){
              //Creo il nuovo elemento OPTION da aggiungere nella seconda SELECT
              var NewOpt = document.createElement('option');
              NewOpt.value = indici[j]; // Imposto il valore
              NewOpt.text = valori[j]; // Imposto il testo

              //Aggiungo l'elemento option
              try
              {
            	  select.add(NewOpt, null); //Metodo Standard, non funziona con IE
              }catch(e){
            	  select.add(NewOpt); // Funziona solo con IE
              }
              }


          }
  		
          function setSpecieComboCallback(returnValue)
          {
        	  var select = document.forms['searchAccount'].searchcodespecie_allevamento; //Recupero la SELECT
              

              //Azzero il contenuto della seconda select
              for (var i = select.length - 1; i >= 0; i--)
            	  select.remove(i);

              indici = returnValue [0];
              valori = returnValue [1];
              //Popolo la seconda Select
              for(j =0 ; j<indici.length; j++){
              //Creo il nuovo elemento OPTION da aggiungere nella seconda SELECT
              var NewOpt = document.createElement('option');
              NewOpt.value = indici[j]; // Imposto il valore
              NewOpt.text = valori[j]; // Imposto il testo

              //Aggiungo l'elemento option
              try
              {
            	  select.add(NewOpt, null); //Metodo Standard, non funziona con IE
              }catch(e){
            	  select.add(NewOpt); // Funziona solo con IE
              }
              }


          }

          function dateCallback(returnValue){
            

              var select = document.forms['searchAccount'].searchcodeTipologiaStruttura; //Recupero la SELECT
           

              //Azzero il contenuto della seconda select
              for (var i = select.length - 1; i >= 0; i--)
            	  select.remove(i);

              indici = returnValue [0];
              valori = returnValue [1];
              //Popolo la seconda Select
              for(j =0 ; j<indici.length; j++){
              //Creo il nuovo elemento OPTION da aggiungere nella seconda SELECT
              var NewOpt = document.createElement('option');
              NewOpt.value = indici[j]; // Imposto il valore
              NewOpt.text = valori[j]; // Imposto il testo

              //Aggiungo l'elemento option
              try{
            	  select.add(NewOpt, null); //Metodo Standard, non funziona con IE
              }catch(e){
            	  select.add(NewOpt); // Funziona solo con IE
              }
              }
              
              }
        </script>


<%@ include file="../initPage.jsp" %>

<% Boolean ricercaAllevamentiAssociabiliAttribute = (Boolean)request.getAttribute("ricercaAllevamentiAssociabiliAttribute"); %>

<script language="JavaScript">
  function clearForm() {
    <%-- Account Filters --%>
    document.forms['searchAccount'].searchAccountName.value="";
    document.forms['searchAccount'].searchAccountNumber.value="";
    document.forms['searchAccount'].searchMalattia.selectedValue ="Tutti";
    document.forms['searchAccount'].searchQualifica.selectedValue ="Tutti";
    //document.forms['searchAccount'].searchAccountCity.value="";
    continueUpdateState('2','true');
    document.forms['searchAccount'].searchcodeAccountState3.options.selectedIndex = 0;
    document.forms['searchAccount'].searchAccountState.value = '';
    document.forms['searchAccount'].searchAccountName.focus();
    document.forms['searchAccount'].searchCodiceFiscaleRappresentante.value = '';
    document.forms['searchAccount'].searchcodeCessato.value = '0';

    <%if (ricercaAllevamentiAssociabiliAttribute == null) {%>
    	document.forms['searchAccount'].searchCity.value = '-1';
    <%}%>

    document.forms['searchAccount'].searchcodeTipologiaStruttura.value = '-1';
    document.forms['searchAccount'].searchcodeOrientamentoProduttivo.value = '-1';

    document.forms['searchAccount'].searchMalattia.value = 'Tutti';
    document.forms['searchAccount'].searchQualifica.value = 'Tutti';
    
  
      }
      
      
</script>

<%
// nel caso in cui arrivo nella pagina cliccando su "Azienda Zootecnica"
// dalla scheda di un OSM che non ha allevamenti associati
// visualizzo l'operazione in corso
if (ricercaAllevamentiAssociabiliAttribute != null && ricercaAllevamentiAssociabiliAttribute == true) {
	org.aspcfs.modules.osmregistrati.base.Organization osmACuiAssociareAllevamento = (org.aspcfs.modules.osmregistrati.base.Organization)session.getAttribute("osmACuiAssociareAllevamento");
	%>		
	<div align="center"; style="BACKGROUND-COLOR:#BDCFFF; font-weight:bold; font-size:12;">
		RICERCA ALLEVAMENTO DA ASSOCIARE ALL'OSM "<%=osmACuiAssociareAllevamento.getName()%>"
	</div>
	<br/>
	<%
} 
%>

<%
if (InfoAllevamentoBean!=null && !"".equals(InfoAllevamentoBean.getCodice_errore()))
{
%>
  <body onLoad="alertErrorImportCapo('<%=InfoAllevamentoBean.getCodice_errore() %>','<%=InfoAllevamentoBean.getErrore() %>')">
<%} 
else
{%>
<dhv:include name="allevamenti-search-name" none="true">
  <body onLoad="javascript:document.searchAccount.searchAccountName.focus();clearForm();">
</dhv:include>
<%}%>

<form name="searchAccount" action="Allevamenti.do?command=Search" method="post">

<table cellpadding="2" cellspacing="2" border="0" width="100%">
<tr>
<td width="50%" valign="top">
  <table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
        <tr>
          <th colspan="2">
            <strong><dhv:label name="allevamenti.accountInformationFilters">Account Information Filters</dhv:label></strong>
          </th>
        </tr>
        <tr>
          <td class="formLabel">
            <dhv:label name="">Denominazione</dhv:label>
          </td>
          <td>
            <input type="text" size="23" name="searchAccountName" value="<%= SearchOrgListInfo.getSearchOptionValue("searchAccountName") %>">
          </td>
          
        </tr>
              
   
        
         <tr>
            <td class="formLabel">
            <dhv:label name="">Codice Azienda</dhv:label>
          </td>
          <td>
            <input type="text" size="23" name="searchAccountNumber" value="<%= SearchOrgListInfo.getSearchOptionValue("searchAccountNumber") %>">
          </td>
        </tr>
        <tr>
             <td class="formLabel">
            <dhv:label name="">Codice Fiscale Detentore</dhv:label>
          </td>
          <td>
            <input type="text" size="23" name="searchCodiceFiscaleRappresentante" value="<%= SearchOrgListInfo.getSearchOptionValue("searchCodiceFiscaleRappresentante") %>">
          </td>
        </tr>
        <dhv:include name="accounts-search-segment" none="true">
        <tr>
          <td nowrap class="formLabel">
            <dhv:label name="allevamenti.allevamenti_search.accountSegment">Account Segment</dhv:label>
          </td>
          <td>
            <input type="text" size="23" name="searchAccountSegment" value="<%= SearchOrgListInfo.getSearchOptionValue("searchAccountSegment") %>">
            <dhv:evaluate if="<%= SegmentList.size() > 1 %>">
              <% SegmentList.setJsEvent("onchange=\"javascript:fillAccountSegmentCriteria();\"");%>
              <%= SegmentList.getHtmlSelect("viewOnlySegmentId", -1) %>
            </dhv:evaluate>
          </td>
        </tr>
        </dhv:include>
        <dhv:include name="allevamenti-search-source" none="true">
        <tr style="display: none">
          <td class="formLabel">
            <dhv:label name="allevamenti.accountSource">Account Source</dhv:label>
          </td>
          <td align="left" valign="bottom">
            <select size="1" name="listView">
              <option <%= SearchOrgListInfo.getOptionValue("all") %>><dhv:label name="accounts.all.accounts">All Accounts</dhv:label></option>
              <option <%= SearchOrgListInfo.getOptionValue("my") %>><dhv:label name="accounts.my.accounts">My Accounts</dhv:label></option>
            </select>
          </td>
        </tr>
        </dhv:include>
        <tr>
          <td class="formLabel">
            <dhv:label name="allevamenti.accountStatus">Account Status</dhv:label>
          </td>
          <td align="left" valign="bottom">
            <select size="1" name="searchcodeCessato">
              <option value="-1" ><dhv:label name="">Tutti</dhv:label></option>
              <option value="0" selected="selected"><dhv:label name="">In Attivit�</dhv:label></option>
              <option value="1" ><dhv:label name="">Cessato</dhv:label></option>
              <%-- %>option value="2" <%=(SearchOrgListInfo.getFilterKey("listFilter2") == 2)?"selected":""%>><dhv:label name="">Sospeso</dhv:label></option--%>
              
           
            </select>
          </td>
        </tr>
        <dhv:include name="organization.stage" none="true">
        <dhv:evaluate if="<%= StageList.getEnabledElementCount() > 1 %>">
        <tr>
          <td nowrap class="formLabel">
            <dhv:label name="account.stage">Stage</dhv:label>
          </td>
          <td>
            <%= StageList.getHtmlSelect("searchcodeStageId", SearchOrgListInfo.getSearchOptionValueAsInt("searchcodeStageId")) %>
          </td>
        </tr>
      </dhv:evaluate>  
      </dhv:include>
      <dhv:evaluate if="<%= SiteList.getEnabledElementCount() <= 1 %>">
        <input type="hidden" name="searchcodeStageId" id="searchcodeStageId" value="-1" />
      </dhv:evaluate>
    	

       
        <tr>
          <td nowrap class="formLabel">
            <dhv:label name="stabilimenti.stabilimenti_add.City">City</dhv:label>
          </td>
          <td > 

	<%
	Iterator<Comuni> it = ComuniList.iterator();
	
	if (ricercaAllevamentiAssociabiliAttribute != null && ricercaAllevamentiAssociabiliAttribute == true) {
		org.aspcfs.modules.osmregistrati.base.Organization osmACuiAssociareAllevamento = (org.aspcfs.modules.osmregistrati.base.Organization)session.getAttribute("osmACuiAssociareAllevamento");
		String comuneOsm = osmACuiAssociareAllevamento.getCity().trim().toUpperCase();
		String codiceComuneCorrente = null;
		boolean flagTrovato = false;
		while (it.hasNext())
		{
			Comuni comuneCorrente = it.next();
			if (comuneCorrente.getComune().equals(comuneOsm)) {
				codiceComuneCorrente = comuneCorrente.getCodice();
				flagTrovato = true;
				break;
			}			
		}		
		if (flagTrovato) {
		%>
			<input type="hidden" name="searchCity" value="<%=codiceComuneCorrente%>" />
	        <%=osmACuiAssociareAllevamento.getCity()%>
		<%
		} else {
			// comune non trovato nella lista
		%>
	        <script>
	        alert("Comune OSM non presente nella lista dei comuni");
	        </script>
		<%
		}

	} else {	
	%>

	<select name = "searchCity">
	<option value = "-1">Tutti</option>
	<%
	while (it.hasNext())
	{
		Comuni c = it.next();
		
		%>
		<option value = "<%=c.getCodice() %>"><%=c.getComune() %></option>
		<%	}
	
	%>
	
	</select>
	<%}%>
	
	</td>
        </tr>
        <tr class="containerBody">
          <td nowrap class="formLabel">
            <dhv:label name="allevamenti.allevamenti_add.StateProvince">State/Province</dhv:label>
          </td>
          <td>
            <span name="state31" ID="state31" style="<%= AccountStateSelect.hasCountry(SearchOrgListInfo.getSearchOptionValue("searchcodeAccountCountry"))? "" : " display:none" %>">
              <%= AccountStateSelect.getHtmlSelect("searchcodeAccountState3", SearchOrgListInfo.getSearchOptionValue("searchcodeAccountCountry"),SearchOrgListInfo.getSearchOptionValue("searchcodeAccountState3")) %>
            </span>
            <%-- If selected country is not US/Canada use textfield --%>
            <span name="state41" ID="state41" style="<%= !AccountStateSelect.hasCountry(SearchOrgListInfo.getSearchOptionValue("searchcodeAccountCountry")) ? "" : " display:none" %>">
              <input type="text" size="23" name="searchAccountState" maxlength="2" value="<%= toHtmlValue(SearchOrgListInfo.getSearchOptionValue("searchAccountState")) %>">
            </span>
          </td>
        </tr>
        
    
        
      <dhv:evaluate if="<%= SiteList.size() > 2 %>">
        <tr>
          <td nowrap class="formLabel">
            <dhv:label name="accounts.site">Site</dhv:label>
          </td>
          <td>
           <dhv:evaluate if="<%=User.getUserRecord().getSiteId() == -1 %>" >
            <%= SiteList.getHtmlSelect("searchcodeOrgSiteId", ("".equals(SearchOrgListInfo.getSearchOptionValue("searchcodeOrgSiteId")) ? String.valueOf(Constants.INVALID_SITE) : SearchOrgListInfo.getSearchOptionValue("searchcodeOrgSiteId"))) %>
           </dhv:evaluate>
           <dhv:evaluate if="<%=User.getUserRecord().getSiteId() != -1 %>" >
              <input type="hidden" name="searchcodeOrgSiteId" value="<%= User.getUserRecord().getSiteId() %>">
              <%= SiteList.getSelectedValue(User.getUserRecord().getSiteId()) %>
           </dhv:evaluate>
          </td>
        </tr>
      </dhv:evaluate>  
      <dhv:evaluate if="<%= SiteList.size() <= 2 %>">
        <input type="hidden" name="searchcodeOrgSiteId" id="searchcodeOrgSiteId" value="-1" />
      </dhv:evaluate>

  <tr>
        	<th colspan="2">
        		Attivit&agrave;
        	</th>
        </tr>
        
             <tr class="containerBody">
          <td nowrap class="formLabel">
            <dhv:label name="">Gruppo Specie Allevata / Specie allevata</dhv:label>
          </td>
          <td>
         
<input type="hidden" id = "searchcodegruppo_specie"  name = "searchcodegruppo_specie" value="3"/>
<input type="hidden" id = "searchcodespecie_allevamento"  name = "searchcodespecie_allevamento" value="122"/>
           SUINI
          </td>
        </tr>
        
      
        <tr>
          <td class="formLabel">
            <dhv:label name="">Tipologia Struttura</dhv:label>
          </td>
          <td>
          
          
          <%TipologiaStruttura.setJsEvent("onChange=popolaOrientamentoProduttivo()"); %>
            <%= TipologiaStruttura.getHtmlSelect("searchcodeTipologiaStruttura", -1) %>    </td>
          
        </tr>
        <tr>
          <td class="formLabel">
            <dhv:label name="">Orientamento Produttivo</dhv:label>
          </td>
          <td>
          
         
              <%= OrientamentoProduttivo.getHtmlSelect("searchcodeOrientamentoProduttivo", -1) %>
          </td>
          
        </tr>
         <tr>
        	<th colspan="2">
        		Informazioni Sanitarie
        	</th>
        </tr>
        
        <tr>
          <td class="formLabel">
            <dhv:label name="">Malattia</dhv:label>
          </td>
          <td>
            
            <select name = "searchMalattia">
            <option value = "Tutti">Tutte le Voci </option>
            <%
            
          Iterator<String> it2 =malattie.keySet().iterator();
            while (it2.hasNext())
            {
            	String code = it2.next();
            	String descr =(String) malattie.get(code);
            
            %>
            <option value = "<%=code %>"><%=descr %></option>
            <%
            }
            
            
            %>
          </select>
        </tr>
        <tr>
          <td class="formLabel">
            <dhv:label name="">Codice Qualifica Sanitaria</dhv:label>
          </td>
          <td>
          
          <select name = "searchQualifica">
            <option value = "Tutti">Tutte le Voci </option>
            <%
            
          Iterator<String> it_s =qualifiche.keySet().iterator();
            while (it_s.hasNext())
            {
            	String code = it_s.next();
            	String descr =(String) qualifiche.get(code);
            
            %>
            <option value = "<%=code %>"><%=descr+ " ("+code+")" %></option>
            <%
            }
            
            
            %>
          </select>
          </td>
          
        </tr>
        
        <tr>
        	<th colspan="2">
        		Consistenza sui Capi
        	</th>
        </tr>
        <tr>
          <td class="formLabel">
            <dhv:label name="">Numero capi</dhv:label>
          </td>
          <td>
          <table class = "noborder">
          <tr>
          <td>
          <select name="searchConfronto" onchange="javascript :if(document.searchAccount.searchConfronto.value==-1){document.searchAccount.searchcodeParametro.value =0}">
          <option value = "-1" selected="selected">Nessun Confronto</option>
          <option value = "0">Maggiore</option>
          <option value = "1">Minore</option>
          </select>
          </td>
          <td>di</td>
          <td>
          <select name="searchParametro">
          <option value = "0" selected="selected">0</option>
          <option value = "25">25</option>
          <option value = "50">50</option>
          <option value = "75">75</option>
          <option value = "100">100</option>
          <option value = "150">150</option>
          <option value = "200">200</option>
          <option value = "250">250</option>
          <option value = "300">300</option>
          <option value = "400">400</option>
          <option value = "500">500</option>
          </select>
          
          <td>
          </tr>
          
          </table>
          
          </td>
          </tr>
        
        </table>
        </td>
        </tr>
</table>

<%--dhv:include name="allevamenti-search-contacts" none="true">
  <input type="checkbox" name="searchContacts" value="true" <%= "true".equals(SearchOrgListInfo.getCriteriaValue("searchContacts"))? "checked":""%> />
  <dhv:label name="allevamenti.search.includeContactsInSearchResults">Include contacts in search results</dhv:label><br />
  <br />
</dhv:include--%>
<input type="submit" onclick='loadModalWindow();' value="<dhv:label name="button.search">Search</dhv:label>">
<input type="button" value="<dhv:label name="button.clear">Clear</dhv:label>" onClick="javascript:clearForm();">
<input type="hidden" name="source" value="searchForm">
<input type="hidden" name="popup" id="popup" value="true">

<%
// associazione OSM - azienda zootecnica
if (ricercaAllevamentiAssociabiliAttribute != null && ricercaAllevamentiAssociabiliAttribute == true) {
	%>
	<input type="hidden" name="ricercaAllevamentiAssociabiliParameter" value="1">
	<%
}
%>

<script type="text/javascript">
dwr.engine.setErrorHandler(errorHandler);
dwr.engine.setTextHtmlHandler(errorHandler);

function errorHandler(message, exception){
    //Session timedout/invalidated
    alert('stop '+exception.javaClassName);
    if(exception && exception.javaClassName== 'org.directwebremoting.extend.LoginRequiredException'){
        //Reload or display an error etc.
        window.location.href=window.location.href;
    }
 } 
</script>
</form>
</body>

