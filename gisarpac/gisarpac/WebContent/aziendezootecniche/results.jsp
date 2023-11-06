
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
<%@page import="org.aspcfs.modules.opu.base.Stabilimento"%>
<%@page import="org.aspcfs.modules.troubletickets.base.Ticket"%>

<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,org.aspcfs.modules.ricercaunica.base.*, org.aspcfs.modules.base.*" %>
<jsp:useBean id="StabilimentiList" class="org.aspcfs.modules.ricercaunica.base.RicercaList" scope="request"/>
<jsp:useBean id="SearchOpuListInfoAllevamenti" class="org.aspcfs.utils.web.PagedListInfo" scope="session"/>
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



<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td> 
Allevamenti ->


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
		<h3>ELENCO ALLEVAMENTI CORRISPONDENTI AI PARAMETRI DI RICERCA</h3>
	</center>



<dhv:pagedListStatus title='<%= showError(request, "actionError") %>' object="SearchOpuListInfoAllevamenti"/>
<% int columnCount = 0; %>
<table cellpadding="8" cellspacing="0" border="0" style="width: 100%" class="pagedList">
  <tr>
  
   <th <% ++columnCount; %>>
   		  <div align="center">
          <strong><dhv:label name="">Norma di Riferimento / Tipologia</dhv:label></strong>
          </div>
        </th>  
       
        
    <th nowrap <% ++columnCount; %>>
     <div align="center">
      <dhv:label name="">Nome/Ditta/Ragione Sociale</dhv:label>
    	</div>  
    </th>  
    
    
     <th   <% ++columnCount; %>>
     	    <div align="center">
          <strong><dhv:label name="">Identificativo fiscale</dhv:label></strong>
          </div>
        </th>
    
    
    
     <th   nowrap <% ++columnCount; %>>
        <div align="center">
      <dhv:label name="">ASL</dhv:label>
     	</div>
    </th>
    
     <th   nowrap <% ++columnCount; %>>
       <div align="center">
      <dhv:label name="">Sede produttiva</dhv:label>
      </div>
    </th>
    

          <th   <% ++columnCount; %>>
           <div align="center">
          <strong><dhv:label name="">Num.<br/>riconoscimento/<br>CUN/<br>Codice azienda</dhv:label></strong>
          </div>
        </th> 
      
     
         <th   <% ++columnCount; %>>
          <div align="center">
          <strong><dhv:label name="">Attivita</dhv:label></strong>
          </div>
        </th>  
        
    
         <th   nowrap <% ++columnCount; %>>
          <div align="center">
      <dhv:label name="">Stato</dhv:label>
      </div>
    </th>
    
  <%
	
	
	HashMap<String,ArrayList<RicercaOpu>> ordPerRifId = new HashMap<String,ArrayList<RicercaOpu>>();
	
	Iterator j0 = StabilimentiList.iterator();
	if ( j0.hasNext()  ) {
		
		
		
    //ordino i risultati per numero getRiferimentoId
    while (j0.hasNext()) 
    {
    	
    	RicercaOpu org0 = (RicercaOpu)j0.next();
    	String rifId = org0.getRiferimentoId()+""+org0.getRiferimentoIdNomeCol();
    	
    	System.out.print("\n rag:"+org0.getRagioneSociale()+" rifid:"+rifId);
    	
    	if(!ordPerRifId.containsKey(rifId))
    	{
    		ordPerRifId.put(rifId,new ArrayList<RicercaOpu>());
    		System.out.println("E' IL PRIMO");
    	}
    	
    	ordPerRifId.get(rifId).add(org0);
    }
    
    
  
    	
    
    
    int rowid = 0;
    int i = 0;	
    Iterator j = ordPerRifId.keySet().iterator();
    String lastRifId = "";
    
    boolean campoToShow = true;
    
    
    while(j.hasNext())
    {
    	 i++;
    	String key = (String)j.next();
    	ArrayList<RicercaOpu> lista =(ArrayList<RicercaOpu>) ordPerRifId.get(key);
    	
    	rowid = (rowid != 1 ? 1 : 2);
    int numIterazioni = 1;	
   for(RicercaOpu thisOrg :lista)
   {
   
    	
%>

<%Ticket temp = new Ticket();
temp.setTipologia_operatore(thisOrg.getTipologia());
	%>
	

  <tr class="row<%= rowid %>" >
    
    <td valign="center" align="center" nowrap style="width: 5%;">
    <div class="<%= campoToShow ? "" : "campoSchiarito" %>" >
   <%= toHtml2(thisOrg.getNorma()) %>
   <%
   if(thisOrg.getRiferimentoIdNomeTab().equalsIgnoreCase("suap_ric_scia_stabilimento"))
   {
	   %>
	   <br>(PRATICA IN ITINERE)
	   <%
   }
   %>
   </div>
    </td>
    
    
      
    <%if(numIterazioni==1){ %>
	<td  valign="center" align="center" style="width: 15%;" rowspan="<%=lista.size()%>">
	<div class="<%= campoToShow ? "" : "campoSchiarito" %>" >
<%-- 	<a onclick="intercettaAction('<%=temp.getURlDettaglioanagrafica()+".do?command=Details&"+thisOrg.getRiferimentoIdNome()+"="+thisOrg.getRiferimentoId() %>')" id="<%= toHtml(thisOrg.getRagioneSociale().toUpperCase()) %>" href="#"><%= toHtml(thisOrg.getRagioneSociale().toUpperCase()) %></a> --%>
	
	<a  id="<%= toHtml(thisOrg.getRagioneSociale().toUpperCase()) %>" href="AziendeZootecniche.do?command=Details&altId=<%=thisOrg.getRiferimentoId() %>"><%=  toHtml(thisOrg.getRagioneSociale().toUpperCase()) %></a>
	</div>
	</td>
	<%}
    
    %>
	
	 <%if(numIterazioni==1){ %>
	  <td valign="center"  align="center"  nowrap style="width: 10%;" rowspan="<%=lista.size()%>">
	  <div class="<%= campoToShow ? "" : "campoSchiarito" %>" >
	  <%=   toHtml2(thisOrg.getPartitaIva())   %>
	  </div>
	  </td>	
	<%} %>
	
	
	 <%if(numIterazioni==1){ %>
	<td valign="center" align="center"  nowrap style="width: 5%;" rowspan="<%=lista.size()%>">
	<div class="<%= campoToShow ? "" : "campoSchiarito" %>" >
	<%=  toHtml2(thisOrg.getAsl())   %>
	</div>
	</td>
	<%} %>
	
	 <%if(numIterazioni==1){ %>
	<td valign="center" align="center"  nowrap style="width: 10%;" rowspan="<%=lista.size()%>">
	<div class="<%= campoToShow ? "" : "campoSchiarito" %>" >
	<%= (thisOrg.getIndirizzoSedeProduttiva()!=null)? ( toHtml2(thisOrg.getIndirizzoSedeProduttiva().replaceAll(",", "<br>"))   ) :"N.D."  %>
	</div>
	</td>
	<%} %>
	
	
      
  <%if(numIterazioni==1){ %>
        <td valign="center" align="center"  nowrap style="width: 10%;" rowspan="<%=lista.size()%>">
      <div class="<%= campoToShow ? "" : "campoSchiarito" %>" >
      <%=(thisOrg.getNumAut()!=null) ? (  toHtml(thisOrg.getNumAut())  ) : "N.D." %>
      </div>
      </td>
      <%} %>
      
       
       	
       	
        <td valign="left" align="left"  nowrap style="width: 15px;" title="<%=  (thisOrg.getAttivita()!=null ) ? ( toHtml2(thisOrg.getAttivita()) ) : "" %>">
        <%
        if(thisOrg.getAttivita()!=null && thisOrg.getAttivita().contains("->")  )
        {
        String[] lineaA = thisOrg.getAttivita().split("->");
        for(int indice=0;indice<lineaA.length;indice++)
        {
        	
        	if(lineaA[indice].length()>50)
        	{
        	out.print(lineaA[indice].substring(0,50)+" ..." +"<br>");
        	}
        	else
        		out.print(lineaA[indice] +"<br>");
        }
        }
        else
        {
        	if(thisOrg.getAttivita()!=null && thisOrg.getAttivita().length()>50)
        	{
        	out.print(thisOrg.getAttivita().substring(0,40)+" ..." +"<br>");
        	}
        	else
        		if(thisOrg.getAttivita()!=null )
        			out.print(thisOrg.getAttivita() +"<br>");
        		else
        			out.print("LINEA NON SPECIFICATA");
        }
        if(thisOrg.getAttivita()!=null )
        {
       %>
        
        <img  style="width:15px" src="images/questionmark.png"></img>
        <%} %>
        </td>
      
      	<td valign="center" align="center"  nowrap style="width: 15%;"><%= toHtml2(thisOrg.getStato())  %> <%= toHtml2(thisOrg.getStatoImpresa())  %> </td>
      	
  
	
  </tr>
       	
   
   
<%
numIterazioni++;
   }}%>

<%} else {%>

  <tr class="containerBody">
    <td colspan="<%= SearchOpuListInfoAllevamenti.getSearchOptionValue("searchcodeOrgSiteId").equals(String.valueOf(Constants.INVALID_SITE))?columnCount+1:columnCount %>">
     Nessun risultato trovato nell'anagrafica selezionata.<br />
      <a href="OpuStab.do?command=SearchForm">Torna alla ricerca</a>.
    </td>
  </tr>
<%}%>
</table>
 
 <BR>
 <dhv:permission name="opu-generazione-xml-anagrafiche-view">
 <table name="block_Featured_Article"  width="100%" border="0" cellpadding="5" cellspacing="0">
 <tbody>
	<tr>
	<td align="right">
		<form name="hiddenFormGenerazioneXml" method="get" action="generazioneXmlAnagrafica" 
			onsubmit=" return intercettaBtnScaricaArchivioXml('hiddenFormGenerazioneXml'); ">
		<input type="submit" value="SCARICA IN FORMATO XML" />
		
		</form>
	</td>
	</tr>
 	
 </tbody>
 </table>
 </dhv:permission>
 
<dhv:pagedListControl object="SearchOpuListInfoAllevamenti" tdClass="row1"/>







    

