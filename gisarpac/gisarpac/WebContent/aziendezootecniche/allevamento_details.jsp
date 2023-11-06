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
  - Version: $Id: accounts_details.jsp 19045 2007-02-07 18:06:22Z matt $
  - Description: 
  --%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,java.text.DateFormat,org.aspcfs.modules.allevamenti.base.*,org.aspcfs.modules.contacts.base.*,org.aspcfs.modules.base.Constants" %>
<jsp:useBean id="SourceList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Allevamento" class="com.aspcfs.modules.aziendezootecniche.base.IstanzaProduttiva" scope="request"/>


<%@ include file="../initPage.jsp" %>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popURL.js"></script>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></script>

<table class="trails" cellspacing="0">
<tr>
<td>
<a href="AziendeZootecniche.do?command=Dashboard"><dhv:label name="allevamenti.allevamenti">Allevamenti</dhv:label></a> > 
<a href="AziendeZootecniche.do?command=Search"><dhv:label name="allevamenti.allevamenti">Risultati Ricerca</dhv:label></a> > 
Scheda Azienda Zootecnica
</td>
</tr>
</table>

<br>
<br>
<%@ include file="../../controlliufficiali/diffida_list.jsp" %>


<dhv:permission name="allevamenti-allevamenti-report-view">
  <table width="100%" border="0">
    <tr>
      <td nowrap align="right">
      
         <script language="JavaScript" TYPE="text/javascript"
	SRC="gestione_documenti/generazioneDocumentale.js"></script>
	
     
      		<img src="images/icons/stock_print-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        <input type="button" title="Stampa Scheda" value="Stampa Scheda"		onClick="openRichiestaPDFOpuRichiestaAnagrafica('<%=Allevamento.getAltId()%>', '32');">
 
 
      </td>
    </tr>
  </table>
</dhv:permission>



<% String param1 = "altId=" + Allevamento.getAltId();%>
<%
System.out.println("Param1 "+param1);
%>
<dhv:container name="aziendezootecniche" selected="details" object="Allevamento" param="<%= param1 %>" appendToUrl='<%= addLinkParams(request, "popup|popupType|actionId") %>' hideContainer="false" >
<input type="hidden" name="altId" value="<%= Allevamento.getAltId() %>">



<jsp:include page="../schede_centralizzate/iframe.jsp">
    <jsp:param name="objectId" value="<%=Allevamento.getAltId() %>" />
     <jsp:param name="tipo_dettaglio" value="32" />
       <jsp:param name="objectIdName" value="alt_id" />
     
     </jsp:include>


<br>
<%@ include file="../aziendezootecniche/adeguamento_schede_zoot_view.jsp" %>

<br>
  
<br /><br />
<!-- INTERROGAZIONE WEB SERVICE BDN -->

	<input type="button" value="COMPARA DATI CON BDN" onclick="window.open('AziendeZootecniche.do?command=CompareWS&denominazione=<%=Allevamento.getAllevamento().getRagioneSociale().replaceAll("\"", "&quot;").replaceAll("'", "|") %>&altId=<%= Allevamento.getAltId() %>&codiceAzienda=<%=Allevamento.getAzienda().getCodiceAzienda() %>&pIva=<%=Allevamento.getAllevamento().getIdFiscaleAllevamento().trim() %>&codSpecie=<%= ""+Allevamento.getCodiceSpecie() %>','popupSelect',
		'height=400px,width=580px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=no,resizable=no ,modal=yes')">
		
	<br />
		
	<br />


</dhv:container>



</body>