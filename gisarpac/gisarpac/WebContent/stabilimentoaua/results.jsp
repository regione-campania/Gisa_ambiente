
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
  - Version: $Id: accounts_list.jsp 18543 2007-01-17 02:55:07Z matt $
  - Description:
  --%>
<%@page import="com.itextpdf.text.log.SysoLogger"%>
<%@page import="org.aspcfs.modules.aua.base.StabilimentoAUA"%>

<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,org.aspcfs.modules.aua.base.*, org.aspcfs.modules.base.*" %>
<jsp:useBean id="StabilimentiList" class="org.aspcfs.modules.aua.base.RicercaList" scope="request"/>
<jsp:useBean id="SearchOpuListInfo" class="org.aspcfs.utils.web.PagedListInfo" scope="session"/>
<jsp:useBean id="SiteIdList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="tipoOperatore" class="org.aspcfs.utils.web.LookupList" scope="request"/>

<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<%@ include file="../initPage.jsp" %>
<%-- Initialize the drop-down menus --%>
<%@ include file="../initPopupMenu.jsp" %>



<SCRIPT LANGUAGE="JavaScript" SRC="javascript/CalendarPopup.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" ID="js19">
	var cal19 = new CalendarPopup();
	cal19.showYearNavigation();
	cal19.showYearNavigationInput();
	cal19.showNavigationDropdowns();
</SCRIPT>


<script>
	window.numRegTrovati = []; //USATA DAL BOTTONE PER SCARICARE GLI XML
	var timerControlloTokenModale;
	 


	

	
	function intercettaBtnScaricaArchivioXml(nomeform)
	{
		
		if(window.numRegTrovati.length == 0)
		{
			alert("StabilimentiList RISULTATI VUOTA");
			return false;
		}
		
		//concateno i numeri reg e li passo alla servlet che genera l'archivio xml, separandoli da un -
		var stringaToSend = "";
		for(var i = 0; i<  window.numRegTrovati.length; i++)
		{
			if(numRegTrovati[i].numReg == undefined || numRegTrovati[i].numReg  == null || numRegTrovati[i].numReg == 'null')
				continue;
			//console.log(window.numRegTrovati[i].numReg)
			stringaToSend += numRegTrovati[i].numReg + "-";
		}
		//levo ultimo trattino separatore
		stringaToSend = stringaToSend.substring(0,stringaToSend.length-1);
		console.log(stringaToSend);
		//creo per il form un nuovo hidden input
		var hiddenInput = document.createElement("input");
		hiddenInput.setAttribute("type","hidden");
		hiddenInput.setAttribute("name","numRegStab");
		hiddenInput.setAttribute("value",stringaToSend);
		document.forms[nomeform].appendChild(hiddenInput);
		console.log("invio");
		
		
		/*-- il server riceve questo token, e quando ha terminato l'invio del file lo setta come cookie, in modo tale che
		lato client possiamo sapere quando è apparsa la finestra del download, e quindi togliamo la modal */
		var hiddenInputTokenModale = document.createElement("input");
		hiddenInputTokenModale.setAttribute("type","hidden");
		hiddenInputTokenModale.setAttribute("name","tokenPerUnlockModal");
		var token = Math.floor(Math.random()*1000);
		hiddenInputTokenModale.setAttribute("value",token);
		document.forms[nomeform].appendChild(hiddenInputTokenModale);
		 
		/*setto il polling per quando il client avrà settato il cookie che indica che abbiamo ricevuto il file in download
		elimino prima eventuali polling già registrati e faccio unlock di un'eventuale finestra già aperta di caricamento*/
		if(timerControlloTokenModale !== undefined)
		{
			clearInterval(timerControlloTokenModale); //pulisco vecchio timer
			loadModalWindowUnlock(); //chiudo eventuale finestra modale caricamento aperta
		}
		
		//registro il timer
		timerControlloTokenModale = setInterval(function()
		{
			//ogni tot tempo devo controllare se è stato settato come cookie il token inviato alla richiesta
			if(document.cookie.contains("tokenPerUnlockModal"))
			{
				//elimino il cookie
				delete_cookie("tokenPerUnlockModal");
				console.log("download arrivato");
				//elimino il timer
				clearInterval(timerControlloTokenModale);
				//sblocco la modale
				loadModalWindowUnlock();
				
				
			}
			else
			{
				console.log("download non arrivato");
			}
		},300);
		
		//prima di fare il submit avvio la modale
		loadModalWindow();
		
		return true; //parte il submit
	}
	
	function delete_cookie(name) {
	    document.cookie = name + '=;expires=Thu, 01 Jan 1970 00:00:01 GMT;';
	};
	

	
</script>

<style>

	.campoSchiarito
	{
		opacity : 0.5;
	}

</style>


<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td> 
<a href="StabilimentoAUA.do?command=SearchForm"><dhv:label name="">Anagrafica stabilimenti</dhv:label></a> >
<a href="StabilimentoAUA.do?command=SearchForm"><dhv:label name="">Ricerca</dhv:label></a>>

<script>

</script>


<dhv:label name="">Risultato Ricerca</dhv:label>
</td>
</tr>
</table>
<%-- End Trails --%>
<dhv:evaluate if="<%= (User.getRoleType() > 0) %>" >
<table class="note" cellspacing="0">
  <tr>
    <th><img src="images/icons/stock_about-16.gif" border="0" align="absmiddle"/></th>
    <td><dhv:label name="accounts.manage">Select an account to manage.</dhv:label></td>
  </tr>
</table>
</dhv:evaluate>
	<center>
		<h3>ELENCO ATTIVITA' CORRISPONDENTI AI PARAMETRI DI RICERCA</h3>
	</center>
<dhv:permission name="opu-generazione-xml-anagrafiche-view">
 <table name="block_Featured_Article"  width="100%" border="0" cellpadding="5" cellspacing="0">
 <tbody>
	<tr>
	<td align="right">
		<form name="hiddenFormGenerazioneXml" method="post" action="generazioneXmlAnagrafica" 
			onsubmit=" return intercettaBtnScaricaArchivioXml('hiddenFormGenerazioneXml'); ">
		<input type="submit" value="SCARICA IN FORMATO XML" />
		
		</form>
	</td>
	</tr>
 	
 </tbody>
 </table>
</dhv:permission>

<dhv:pagedListStatus title='<%= showError(request, "actionError") %>' object="SearchOpuListInfo"/>
<% int columnCount = 0; %>
<table cellpadding="8" cellspacing="0" border="0" style="width: 100%" class="pagedList">
  <tr>
  
       
    <th nowrap <% ++columnCount; %>>
     <div align="center">
      <dhv:label name="">Nome/Ditta/Ragione Sociale</dhv:label>
    	</div>  
    </th>  
    
    
     <th   <% ++columnCount; %>>
     	    <div align="center">
          <strong><dhv:label name="">Ciureg</dhv:label></strong>
          </div>
        </th>
    
    
    
     <th   nowrap <% ++columnCount; %>>
        <div align="center">
      <dhv:label name="">DIPARTIMENTO</dhv:label>
     	</div>
    </th>
    
     <th   nowrap <% ++columnCount; %>>
       <div align="center">
      <dhv:label name="">Sede produttiva</dhv:label>
      </div>
    </th>
    
        <th   <% ++columnCount; %>>
       	 <div align="center">
          <strong><dhv:label name="">Tipologia Attività</dhv:label></strong>
          </div>
        </th>     
        

          <th  <% ++columnCount; %>>
           <div align="center">
          <strong><dhv:label name="">N. Identificativo<br/>/CUN</dhv:label></strong>
          </div>
        </th>  
        
        
        
        
    
         <th   nowrap <% ++columnCount; %>>
          <div align="center">
      <dhv:label name="">Stato</dhv:label>
      </div>
    </th>
    
  
  </tr>
  <script>
  console.log(<%=StabilimentiList.getIdAsl()%>)
  </script>
<%


	

	
	Integer i=0;
	Iterator j0 = StabilimentiList.iterator();
	if ( j0.hasNext()  ) {
		 System.out.println("RIFERIMENTO ID: "+j0.toString());
	
		 
    for(i=0; i<StabilimentiList.size(); i++){
		RicercaAUA thisStabCompare = null;
		RicercaAUA thisStab = (RicercaAUA)StabilimentiList.get(i);
		if (i>0){
		 thisStabCompare = (RicercaAUA)StabilimentiList.get(i-1);
		}else{
		 thisStabCompare = null;
		}
		if(i==0 || thisStabCompare.getRiferimentoId() != thisStab.getRiferimentoId()){
%>

  <tr  class="row1">
      
	<td  valign="center" align="center" style="width: 15%;">
	<div >
<%-- 	<a onclick="intercettaAction('<%=temp.getURlDettaglioanagrafica()+".do?command=Details&"+StabilimentiList.getRiferimentoIdNome()+"="+StabilimentiList.getRiferimentoId() %>')" id="<%= toHtml(StabilimentiList.getRagioneSociale().toUpperCase()) %>" href="#"><%= toHtml(StabilimentiList.getRagioneSociale().toUpperCase()) %></a> --%>
		<a  id="<%= toHtml(thisStab.getRagioneSociale().toUpperCase()) %>" href="StabilimentoAUA.do?command=Details&<%=thisStab.getRiferimentoIdNome()%>=<%=thisStab.getRiferimentoId()%><%=(thisStab.getTipologia()== 1999) ? "&container=archiviati" : "" %>"><%=  toHtml(thisStab.getRagioneSociale().toUpperCase()) %></a>	
	
	</div>
	</td>
	
	  <td valign="center"  align="center"  nowrap style="width: 10%;" >
	  <div >
	  <%=   toHtml2(thisStab.getPartitaIva())   %>
	  </div>
	  </td>	
	
	
	<td valign="center" align="center"  nowrap style="width: 5%;" >
	<div >
	<%=  thisStab.getAsl() %>
	</div>
	</td>
	
	<td valign="center" align="center"  nowrap style="width: 10%;" >
	<div >
	<%= (thisStab.getIndirizzoSedeProduttiva()!=null)? ( toHtml2(thisStab.getIndirizzoSedeProduttiva().replaceAll(",", "<br>"))   ) :"N.D."  %>
	</div>
	</td>
	
	
	
	<%if( thisStab.getTipoAttivita().toUpperCase().contains("CON SEDE FISSA")){ %>
      
       	<td valign="center" align="center"  nowrap style="width: 15%;">
       	 
       	<%= toHtml2(thisStab.getTipoAttivita())  %>
       	<%=( thisStab.getTipoAttivita() != null && thisStab.getTipoAttivita().toLowerCase().contains("senza sede fissa") &&  thisStab.getTarga()!=null && !"".equals(thisStab.getTarga()) ) ?  ("<br/>TARGA:<b>"+toHtml2(thisStab.getTarga()) )+"</b>" : ( thisStab.getTipoAttivita().toLowerCase().contains("senza sede fissa") ? "<br/><b>TARGA</b>: N.D." : "" )  %>
       	 
       	</td>
       	<%
       		System.out.println(thisStab.getTipoAttivita().toLowerCase().contains("senza sede fissa"));
       		System.out.println(thisStab.getTipoAttivita());
       		System.out.println(thisStab.getTarga());
        
        }
        else
        {
        	%>
        	  <%if( ! thisStab.getTipoAttivita().toUpperCase().contains("CON SEDE FISSA")){ %>
      
       	<td valign="center" align="center"  nowrap style="width: 15%;">
       	 
       	<%= toHtml2(thisStab.getTipoAttivita())  %>
       	<%=( thisStab.getTipoAttivita() != null && (thisStab.getTipoAttivita().toLowerCase().contains("senza sede fissa") || thisStab.getTipoAttivita().toLowerCase().contains("senza sede fissa")) &&  thisStab.getTarga()!=null && !"".equals(thisStab.getTarga()) ) ?  ("<br/>TARGA:<b>"+toHtml2(thisStab.getTarga()) )+"</b>" : ( thisStab.getTipoAttivita().toLowerCase().contains("mobile") ? "<br/><b>TARGA</b>: N.D." : "" )  %>
       	 
       	</td>
       	<%}
        }
        %>
	
<td valign="center" align="center" nowrap style="width: 5%;">
    <div  >
    <%System.out.println("CODICE IPPC: "+thisStab.getN_linea()); %>
   <span style="text-transform:none"><%= thisStab.getN_linea() %></span>
   
   <%= thisStab.getMatricola()!=null && !"".equals(thisStab.getMatricola()) ?  ("<br/>MATRICOLA/<br/>NUMERO IDENTIFICATIVO:<b>"+toHtml2(thisStab.getMatricola()) ) : ""   %>
   
   </div>
    </td>
      
        

       	
   
    
     
        
       </td>
       <td valign="center" align="center"  nowrap style="width: 15%;"><%= toHtml2(thisStab.getStato())  %> <%= toHtml2(thisStab.getStatoImpresa())  %> </td>
      	
  
	
  </tr>
        <%}else{%>
       
      
       
       
       <%} %>
      
      	
       	
   
    <script>
    //VALORIZZO LA STRUTTURA DATI CHE MANTIENE TUTTI NUM REG STABILIMENTI TROVATI
    
    	
    	window.numRegTrovati.push(
    			{
    				
    				
    				numReg : '<%=thisStab.getNumeroRegistrazione() %>' 
    				
    			}
    	);
    
    </script>  	 
<%
   }}%>


</table>
 
 <BR>
 
 
<dhv:pagedListControl object="SearchOpuListInfo" tdClass="row1"/>


<div id = "dialogGestioneScia">



</div>





    

