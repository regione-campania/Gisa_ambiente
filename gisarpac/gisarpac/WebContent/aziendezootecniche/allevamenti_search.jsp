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
<jsp:useBean id="ListaStati" class="org.aspcfs.utils.web.LookupList" scope="request"/>



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




<form name="searchAccount" action="AziendeZootecniche.do?command=Search" method="post">
<input type="hidden" name = "searchcodetipoRicerca" value="4">
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="AziendeZootecniche.do?command=Dashboard"><dhv:label name="allevamenti.allevamenti">Allevamenti</dhv:label></a> > 
<dhv:label name="allevamenti.search">Cerca allevamenti</dhv:label>
</td>
</tr>
</table>
<%-- End Trails --%>

</br>
</br>
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
            <input type="text" size="23" name="searchragioneSociale" value="<%= SearchOrgListInfo.getSearchOptionValue("searchragioneSociale") %>">
          </td>
          
        </tr>
              
   
  		
         <tr>
            <td class="formLabel">
            <dhv:label name="">Codice Azienda</dhv:label>
          </td>
          <td>
            <input type="text" size="23" name="searchnumeroRiconoscimento" value="<%= SearchOrgListInfo.getSearchOptionValue("searchnumeroRiconoscimento") %>">
          </td>
        </tr>
         <tr>
            <td class="formLabel">
            <dhv:label name="">Specie Allevamenti</dhv:label>
          </td>
          <td>
            <input type="text" size="23" name="searchAttivita" value="<%= SearchOrgListInfo.getSearchOptionValue("searchAttivita") %>">
          </td>
        </tr>
        
        
        <tr id="tr_stato">
        	<td nowrap class="formLabel">
     		 <dhv:label name="">Stato</dhv:label>
   			 </td> 
    		<td> 
				   <%= ListaStati.getHtmlSelect("searchcodeidStato",-1) %>
			</td>
  		</tr>
       

       
       
        
    
        
     <tr id="asl">
        	<td nowrap class="formLabel">
     		 <dhv:label name="">ASL</dhv:label>
   			 </td> 
    		<td> 
				
	    <dhv:evaluate if="<%= User.getSiteId() == -1 %>" >
          <%= SiteList.getHtmlSelect("searchcodeidAsl",-1) %>
        </dhv:evaluate>
        <dhv:evaluate if="<%= User.getSiteId() != -1 %>" >
           <%= SiteList.getSelectedValue(User.getSiteId()) %>
          <input type="hidden" name="searchcodeidAsl" id="searchcodeidAsl" value="<%=User.getSiteId()%>" >
          
        </dhv:evaluate>
    
			</td>
  		</tr> 

        
        
        </table>
        </td>
        </tr>
</table>

<input type="submit" onclick='loadModalWindow();' value="<dhv:label name="button.search">Search</dhv:label>">


</form>
</body>

