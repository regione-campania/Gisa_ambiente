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
<jsp:useBean id="SearchOpuListInfo" class="org.aspcfs.utils.web.PagedListInfo" scope="session"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="SiteList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ComuniList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="CodiceIppc" class="org.aspcfs.utils.web.LookupList" scope="request"/>

<jsp:useBean id="ListaStati" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="tipoRicerca" class="org.aspcfs.utils.web.LookupList" scope="request"/>

<script src="javascript/aggiuntaCampiEstesiScia.js"></script>
	<jsp:useBean id="normeList" class="org.aspcfs.utils.web.LookupList"
	scope="request" /> 
<%@ include file="../initPage.jsp" %>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></script>
  <link href="css/tooltip.css" rel="stylesheet" type="text/css" />
<script src="javascript/tooltip.js" type="text/javascript"></script>
        <script type="text/javascript" src="dwr/engine.js"> </script>
        <script type="text/javascript" src="dwr/util.js"></script>
<SCRIPT src="javascript/suapUtil.js"></SCRIPT>    
<script type="text/javascript" src="dwr/interface/PopolaCombo.js"> </script>
<script type="text/javascript" src="javascript/tabber.js"></script>

<link href="css/nonconformita.css" rel="stylesheet" type="text/css" />


    
   <script>
   function gestisciComune(){
	   
	   var elt = document.getElementById("searchcodeidComune");
       if (elt.selectedIndex > -1)
	  	   document.getElementById('searchcomuneSedeProduttiva').value = elt.options[elt.selectedIndex].text;
   }
   
   function getValoriComboNorme(valore)
   {
	   PopolaCombo.getValoriComboNorme(valore,getValoriComboNormeCallback);
   }
   
   function getValoriComboNormeCallback(returnValue)
   {
	   var select = document.getElementById("searchcodeIdNorma");
	   
	 //Azzero il contenuto della seconda select
	     for (var i = select.length - 1; i >= 0; i--)
	   	  select.remove(i);

	 
	   
         
	   var  indici = returnValue [0];
	    var valori = returnValue [1];
	     //Popolo la seconda Select
	    
	     
	    	  var NewOpt = document.createElement('option');
	          NewOpt.value = -1; // Imposto il valore
	     	 	NewOpt.text = '--SELEZIONA NORMA--'; // Imposto il testo
	          	NewOpt.title = valori[i];
	          //Aggiungo l'elemento option
	          try
	          {
	        	  	select.add(NewOpt, null); //Metodo Standard, non funziona con IE
	          }catch(e){
	        	  select.add(NewOpt); // Funziona solo con IE
	          }
	      
	     if (indici.length>0)
	     {
	     for(j =0 ; j<indici.length; j++){
	     //Creo il nuovo elemento OPTION da aggiungere nella seconda SELECT
	     var NewOpt = document.createElement('option');
	     NewOpt.value = indici[j]; // Imposto il valore
	     if(valori[j] != null)
	     	NewOpt.text = valori[j]; // Imposto il testo
	     	NewOpt.title = valori[j];
	     //Aggiungo l'elemento option
	     try
	     {
	   	  	select.add(NewOpt, null); //Metodo Standard, non funziona con IE
	     }catch(e){
	   	  select.add(NewOpt); // Funziona solo con IE
	     }
	     }
	     }

	   
   }
   function clearForm(form){
	   var inp = form.getElementsByTagName('input');
	   for(var i in inp){
	       if(inp[i].type == "text"){
	           inp[i].value='';
	       }
	   }
	   var asl = form.searchcodeidAsl;
	   asl.value="-1";
	   
	   var stato = form.searchcodeidStato;
	   stato.value="-1";
	   
	   var sel = form.getElementsByTagName('select');
	   for(var i in sel){
	           sel[i].value='';
	   }
   }
   
   function checkForm(form){

	   
	 	loadModalWindow();
	   	form.submit();
   }
   
  
   </script>     


<%-- Trails --%>

<table class="trails" cellspacing="0">
<tr>
<td>
<a href="StabilimentoAIA.do?command=SearchForm"><dhv:label name="">Anagrafica Impianti</dhv:label></a> >
Ricerca
</td>
</tr>
</table>
<%-- End Trails --%>




<div class="tabber">
	<div class="tabbertab">
	<h2>Ricerca</h2>
	<form name="searchAccount1" id = "searchAccount1" action="StabilimentoAIA.do?command=Search" method="post">
	<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
        <tr>
          <th colspan="2">
            <strong><dhv:label name="">Ricerca</dhv:label></strong>
          </th>
        </tr>
        
        <tr style="display:none">
        	<td nowrap class="formLabel" >
     		 <dhv:label name="">NORMA DI RIFERIMENTO / TIPOLOGIA</dhv:label>
   			 </td> 
    		<td> 
    		<%=normeList.getHtmlSelect("searchcodeIdNorma", -1) %>
 </td>
 </tr>
        <tr style="display:none">
        	<td nowrap class="formLabel" >
     		 <dhv:label name="">CERCA IN</dhv:label>
   			 </td> 
    		<td> 
    		<%=tipoRicerca.getHtmlSelect("searchcodetipoRicerca", -1) %>
 </td>
 </tr>
 
 
   <tr id="asl">
        	<td nowrap class="formLabel">
     		 <dhv:label name="">DIPARTIMENTO</dhv:label>
   			 </td> 
    		<td> 
				
<%-- 	    <dhv:evaluate if="<%= User.getSiteId() == -1 %>" > --%>
          <%= SiteList.getHtmlSelect("searchcodeidAsl",-1) %>
<%--         </dhv:evaluate> --%>
<%--         <dhv:evaluate if="<%= User.getSiteId() != -1 %>" > --%>
<%--            <%= SiteList.getSelectedValue(User.getSiteId()) %> --%>
<%--           <input type="hidden" name="searchcodeidAsl" id="searchcodeidAsl" value="<%=User.getSiteId()%>" > --%>
          
<%--         </dhv:evaluate> --%>
    
			</td>
  		</tr> 
  		
  		 <tr id="tr_stato">
        	<td nowrap class="formLabel">
     		 <dhv:label name="">Stato</dhv:label>
   			 </td> 
    		<td> 
				   <%= ListaStati.getHtmlSelect("searchcodeidStato",0) %>
			</td>
  		</tr>
  		
  		
  <tr>
          <td class="formLabel">
            <dhv:label name="lab.denom">Nome/Ditta/Ragione sociale</dhv:label>
          </td>
          <td>
            <input type="text" maxlength="70" size="50" name="searchragioneSociale" id="searchRagioneSociale" value="">
          </td>
        </tr>
        
         <tr>
        	<td nowrap class="formLabel">
     		 <dhv:label name="">Partita Iva</dhv:label>
   			 </td> 
    		<td> 
				<input  type="text" maxlength="11" size="50" name="searchpartitaIva"  id="searchpartitaIva" value="">
			</td>
  		</tr>
  		
  		<tr>
        	<td nowrap class="formLabel">
     		 <dhv:label name="">Comune</dhv:label>
   			 </td> 
    		<td> 
    		<%ComuniList.setJsEvent("onChange=gestisciComune()"); %>
				<%=ComuniList.getHtmlSelect("searchcodeidComune",-2)%>
				<input type="hidden" id="searchcomuneSedeProduttiva" name = "searchcomuneSedeProduttiva"/>
			</td>
  		</tr>
  		
  		<tr>
        	<td nowrap class="formLabel">
     		 <dhv:label name="">Codice Ippc Primario</dhv:label>
   			 </td> 
    		<td> 
				<%=CodiceIppc.getHtmlSelect("searchcodecodiceIppc",-1)%>
			</td>
  		</tr>
  		
  		<tr>
        	<td nowrap class="formLabel">
     		 <dhv:label name="">Codice Ippc Secondario</dhv:label>
   			 </td> 
    		<td> 
				<%=CodiceIppc.getHtmlSelect("searchcodecodiceIppc2",-1)%>
			</td>
  		</tr>
  		
<!--   		 <tr id='targa_tr'> -->
<!--         	<td nowrap class="formLabel"> -->
<%--      		 <dhv:label name="">Targa</dhv:label> --%>
<!--    			 </td>  -->
<!--     		<td>  -->
<!-- 				<input  type="text" maxlength="15" size="50" name="searchtarga" value=""> -->
<!-- 			</td> -->
<!--   		</tr> -->
  
 <!--  
  <tr>
        	<td nowrap class="formLabel" >
     		 <dhv:label name="">Descrizione Linea</dhv:label>
   			 </td> 
    		<td> 
    		<input type="text" name="searchAttivita" style="width: 35%">
    		
    		<img title="<%="INDICARE LA DESCRIZIONE DELLA LINEA DI ATTIVITA. ESEMPIO : (COMMERCIO CARNE)".toUpperCase() %>" class="masterTooltip" src="images/questionmark.png" width="20"/>
 </td>
 </tr>
 -->
 </table>
 <input type="button" id="search" name="search" value="Ricerca" onClick="checkForm(document.forms['searchAccount1']);"/>
 <%
if (User.getRoleId()!=Role.RUOLO_COMUNE)
{
%> 
<input type="button" value="<dhv:label name="button.clear">Clear</dhv:label>" onClick="clearForm(document.forms['searchAccount1']);">

<%} %>
<input type="hidden" name="source" value="searchForm">
        </form>
	
	</div>
 
  
  
</div>


<iframe src="empty.html" name="server_commands" id="server_commands" style="visibility:hidden" height="0"></iframe>


<!--  
<div>
	<a href="Terreni.do?command=TerreniList">Terreni Investigati</a>
</div> -->