<%-- 
  - Copyright(c) 2004 Dark Horse Ventures LLC (http://www.centriccrm.com/) All
  - rights reserved. This material cannot be distributed without written
  - permission from Dark Horse Ventures LLC. Permission to use, copy, and modify
  - this material for internal use is hereby granted, provided that the above
  - copyright notice and this permission notice appear in all copies. DARK HORSE
  - VENTURES LLC MAKES NO REPRESENTATIONS AND EXTENDS NO WARRANTIES, EXPRESS OR
  - IMPLIED, WITH RESPECT TO THE SOFTWARE, INCLUDING, BUT NOT LIMITED TO, THE
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
<%@ page import="java.util.*,java.text.DateFormat,java.text.SimpleDateFormat,java.util.Date,org.aspcfs.modules.farmacosorveglianza.base.*,org.aspcfs.modules.contacts.base.*, org.aspcfs.modules.base.Constants" %>
<%@page import="org.aspcfs.modules.audit.base.Audit"%>
<jsp:useBean id="SourceList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="OrgCategoriaRischioList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="StageList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SiteList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TitoloList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="RatingList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoStruttura" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoLocale" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="OrgDetails" class="org.aspcfs.modules.farmacosorveglianza.base.Organization" scope="request"/>
<jsp:useBean id="Audit" class="org.aspcfs.modules.audit.base.Audit" scope="request"/>
<jsp:useBean id="SegmentList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SICCodeList" class="org.aspcfs.modules.admin.base.SICCodeList" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="applicationPrefs" class="org.aspcfs.controller.ApplicationPrefs" scope="application"/>
<jsp:useBean id="refreshUrl" class="java.lang.String" scope="request"/>
<%@ include file="../initPage.jsp" %>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popURL.js"></script>
<%if (refreshUrl!=null && !"".equals(refreshUrl)){ %>
<script language="JavaScript" TYPE="text/javascript">
parent.opener.window.location.href='<%=refreshUrl%><%= request.getAttribute("actionError") != null ? "&actionError=" + request.getAttribute("actionError") :""%>';
</script>
<%}%>	

<%@ include file="../../controlliufficiali/diffida_list.jsp" %>

<dhv:evaluate if="<%= !isPopup(request) %>">
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Farmacosorveglianza.do?command=SearchFormFcie"><dhv:label name="">Operatori Farmaceutici</dhv:label></a> > 
<%-- if (request.getParameter("return") == null) { %>
<a href="Farmacosorveglianza.do?command=SearchFcie"><dhv:label name="">Risultati Ricerca</dhv:label></a> >
<%} else if (request.getParameter("return").equals("dashboard")) {%>
<a href="Farmacosorveglianza.do?command=DashboardFcie"><dhv:label name="communications.campaign.Dashboard">Dashboard</dhv:label></a> >
<%}--%>
<dhv:label name="">Scheda Operatore Farmaceutico</dhv:label>
</td>
</tr>
</table>
<%-- End Trails --%>


</dhv:evaluate>
<dhv:permission name="farmacosorveglianza-farmacosorveglianza-report-view">
  <table width="100%" border="0">
    <tr>
      <td nowrap align="right">
        <%-- 
        <img src="images/icons/stock_print-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        <a href="Farmacosorveglianza.do?command=PrintReport&id=<%= OrgDetails.getId() %>"><dhv:label name="accounts.osa.print">Stampa Scheda O.S.A.</dhv:label></a>
       --%>
      </td>
    </tr>
  </table>
</dhv:permission>
<% String param1 = "orgId=" + OrgDetails.getIdFarmacia();
   %>
  
<dhv:container name="farmacosorveglianza" selected="details" object="OrgDetails" param="<%= param1 %>" appendToUrl='<%= addLinkParams(request, "popup|popupType|actionId") %>' hideContainer="<%= OrgDetails.isTrashed() %>">
<input type="hidden" name="idFarmacia" value="<%= OrgDetails.getIdFarmacia() %>"> 
<dhv:evaluate if="<%=OrgDetails.isTrashed()%>">
    <dhv:permission name="farmacosorveglianza-farmacosorveglianza-edit">
      <input type="button" value="<dhv:label name="button.restore">Restore</dhv:label>"	onClick="javascript:window.location.href='Farmacosorveglianza.do?command=Restore&idFarmacia=<%= OrgDetails.getIdFarmacia() %>';">
    </dhv:permission>
</dhv:evaluate>
<dhv:evaluate if="<%=!OrgDetails.isTrashed()%>">
 
    <dhv:permission name="farmacosorveglianza-farmacosorveglianza-edit"><input type="button"  value="<dhv:label name="global.button.modify">Modify</dhv:label>"	onClick="javascript:window.location.href='Farmacosorveglianza.do?command=ModifyFcie&idFarmacia=<%= OrgDetails.getIdFarmacia() %><%= addLinkParams(request, "popup|actionplan") %>';"></dhv:permission>
  
  
    <%--dhv:permission name="farmacosorveglianza-farmacosorveglianza-edit">
      <input type="button" value="<dhv:label name="global.button.Enable">Enable</dhv:label>" 	onClick="javascript:window.location.href='Farmacosorveglianza.do?command=Enable&idFarmacia=<%= OrgDetails.getIdFarmacia() %>';">
    </dhv:permission--%>
 

 </dhv:evaluate>  	
 <%if( (OrgDetails.getStatoLab() != -1   && OrgDetails.getStatoLab() != 0) || (OrgDetails.getStatoLab() == -1 && OrgDetails.getStato() != null && !OrgDetails.getStato().equalsIgnoreCase("attivo")  ) ){ %>
  	
  	<%} 
  else
  	{%>
  
  
  <!-- MODIFICA CESSAZIONE OSA ANCHE SU QUESTO CAVALIERE ------------------------------------>
 	<dhv:permission name="osa-cessazione-pregressa-view">
	
		<center>
			<span style="width:50px;"  >
			 <br>
			 <p style="color:red; font-weight:bold;" >Per cessare senza importare premere su 'CESSAZIONE OSA'</p>
			 <input class="yellowBigButton" type="button" value="CESSAZIONE OSA" onclick="openPopUpCessazioneAttivita();" width="120px;">
			 </span>
			 <br><br>
			 <br>
		</center>
	 </dhv:permission>
	 
	<jsp:include page="../dialog_cessazione_attivita.jsp"> 
		 <jsp:param value="<%=OrgDetails.getOrgId() %>" name="idAnagrafica"/>
		 <jsp:param value="Farmacosorveglianza.do?command=CessazioneAttivita" name="urlSubmitCessazione"/>
		 <jsp:param value="<%=OrgDetails.getDataInizio() != null ? new SimpleDateFormat("yyyy-MM-dd").format(new Date(OrgDetails.getDataInizio().getTime())) : "" %>" name="data_inizio" />
	</jsp:include>
	
<!------------------------------------------------------------------------------------------------> 

<!-- MODIFICA SOSPENSIONE OSA ANCHE SU QUESTO CAVALIERE ------------------------------------>
 	<dhv:permission name="osa-cessazione-pregressa-view">
	
		<center>
			<span style="width:50px;"  >
			 <br>
			 <p style="color:red; font-weight:bold;" >Per sospendere senza importare premere su 'SOSPENSIONE OSA'</p>
			 <input class="yellowBigButton" type="button" value="SOSPENSIONE OSA" onclick="openPopUpSospensioneAttivita();" width="120px;">
			 </span>
			 <br><br>
			 <br>
		</center>
	 </dhv:permission>
	 
	<jsp:include page="../dialog_sospensione_attivita.jsp"> 
		 <jsp:param value="<%=OrgDetails.getOrgId() %>" name="idAnagrafica"/>
		 <jsp:param value="Farmacosorveglianza.do?command=SospensioneAttivita" name="urlSubmitSospensione"/>
		 <jsp:param value="<%=OrgDetails.getDataInizio() != null ? new SimpleDateFormat("yyyy-MM-dd").format(new Date(OrgDetails.getDataInizio().getTime())) : "" %>" name="data_inizio" />
	</jsp:include>
	
<!------------------------------------------------------------------------------------------------> 
  
  
  
<%} %>


<!--  -->
<dhv:permission name="opu-import-add">
<center><font color="red"><b><%="Lo stabilimento ha linee non aggiornate." %></b></font></center>
  <div align="center">
 	 <br/> 
 		<%--<input type="button" class="yellowBigButton" value="AGGIORNA LINEE DI ATTIVITA' PREGRESSE DA MASTERLIST" 
 		onClick="openPopupLarge('Accounts.do?command=PrepareUpdateLineePregresse&orgId=<%=OrgDetails.getOrgId() %>&lda_prin=<%=linea_attivita_principale.getId() %>')"
 		--%>
 	<%-- onClick="loadModalWindow();window.location.href='OpuStab.do?command=PrepareUpdateLineePregresse&stabId=<%=StabilimentoDettaglio.getIdStabilimento() %>'"--%>
 	<input type="button" class="yellowBigButton"s
				value="Importa in Anagrafica stabilimenti"
			    onClick="javascript:window.location.href='OpuStab.do?command=CaricaImport&orgId=<%=OrgDetails.getOrgId()%>'">
 <br/><br/>	
 	</div>

</dhv:permission>

	<dhv:permission name="farmacosorveglianza-farmacosorveglianza-delete">
	<input type="button" value="Elimina" onClick="javascript:popURLReturn('Farmacosorveglianza.do?command=ConfirmDelete&id=<%=OrgDetails.getId()%>&popup=true','Farmacosorveglianza.do?command=Search', 'Delete_account','320','200','yes','no');">
	</dhv:permission>
	  

<dhv:permission name="note_hd-view">
<jsp:include page="../note_hd/link_note_hd.jsp">
<jsp:param name="riferimentoId" value="<%=OrgDetails.getOrgId() %>" />
<jsp:param name="riferimentoIdNomeTab" value="organization" />
</jsp:include> <br><br>
</dhv:permission>

<jsp:include page="../preaccettazionesigla/button_preaccettazione.jsp">
    <jsp:param name="riferimentoIdPreaccettazione" value="<%=OrgDetails.getOrgId() %>" />
    <jsp:param name="riferimentoIdNomePreaccettazione" value="orgId" />
    <jsp:param name="riferimentoIdNomeTabPreaccettazione" value="organization" />
    <jsp:param name="userIdPreaccettazione" value="<%=User.getUserId() %>" />
</jsp:include>
<br/><br/>	

<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
   <tr>
    <th colspan="2">
      <strong><dhv:label name="">Informazioni Principali</dhv:label></strong>
    </th>
  </tr>
  <% String st = SiteList.getSelectedValue(OrgDetails.getSiteId()); 
if(st.equals("--Nessuno--")){ %>    
<%}else{ %>
  <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="accounts.site">Site</dhv:label>
    </td>
    <td>
      <%= SiteList.getSelectedValue(OrgDetails.getSiteId()) %>
      <input type="hidden" name="siteId" value="<%=OrgDetails.getSiteId()%>" >
    </td>
   
  </tr>
  <dhv:evaluate if="<%= SiteList.size() <= 0 %>">
    <input type="hidden" name="siteId" id="siteId" value="-1" />
  </dhv:evaluate>
  
  <%} %>
    
      <tr class="containerBody">
        <td nowrap class="formLabel" name="orgname1" id="orgname1">
          <dhv:label name="">Impresa</dhv:label>
        </td>
        <td>
          <%= toHtmlValue(OrgDetails.getRagioneSociale()) %>&nbsp;
       </td>
      </tr>
      <tr class="containerBody">
        <td nowrap class="formLabel" name="orgname1" id="orgname1">
          <dhv:label name="">Stato</dhv:label>
        </td>
        <td>
        <%if(OrgDetails.getStato()==null || OrgDetails.getStato().equals("")){ %>
          <%="Attivo"%>
          <%}else{ %>
          <%= toHtml(OrgDetails.getStato()) %>&nbsp;
          <%} %>
          <%if(OrgDetails.getDataCambioStato()!=null && !OrgDetails.getDataCambioStato().equals("")){ %>
          In Data<%} %> &nbsp;<zeroio:tz timestamp="<%= OrgDetails.getDataCambioStato() %>" dateOnly="true" showTimeZone="false" default="&nbsp;"/>
       </td>
      </tr>
      <dhv:evaluate if="<%= hasText(OrgDetails.getCitta()) %>">
  <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="">Comune</dhv:label>
    </td>
    <td>
       <%= toHtml(OrgDetails.getCitta()) %>&nbsp;
    </td>
  </tr>
</dhv:evaluate>
      
    <dhv:evaluate if="<%= hasText(OrgDetails.getIndirizzo()) %>">
    	<tr class="containerBody">
			<td nowrap class="formLabel">
      			<dhv:label name="">Indirizzo</dhv:label>
			</td>
			<td>
         		<%= toHtml(OrgDetails.getIndirizzo()) %>&nbsp;
			</td>
		</tr>
  	</dhv:evaluate>  
<dhv:evaluate if="<%= hasText(OrgDetails.getProvincia()) %>">
  <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="">Provincia</dhv:label>
    </td>
    <td>
       <%= toHtml(OrgDetails.getProvincia()) %>&nbsp;
    </td>
  </tr>
</dhv:evaluate>
  <%Double lat = OrgDetails.getLatitudine();
  String latitude = lat.toString();
  Double lon = OrgDetails.getLongitudine();
  String longitude = lon.toString();
  %>
  <dhv:evaluate if="<%= hasText(latitude) %>">
    <tr class="containerBody">
			<td nowrap class="formLabel">
      <dhv:label name="">Latitudine</dhv:label>
			</td>
			<td>
			<%--= toHtml((OrgDetails.getLatitudine() != 0.0 || OrgDetails.getLatitudine() != 0.0) ? String.valueOf(OrgDetails.getLatitudine()) : "") --%>
             <%= toHtml(latitude) %>&nbsp;
			</td>
		</tr>
  </dhv:evaluate>
  <dhv:evaluate if="<%= hasText(longitude) %>">
    <tr class="containerBody">
			<td nowrap class="formLabel">
      <dhv:label name="">Longitudine</dhv:label>
			</td>
			<td>
         <%= toHtml(longitude) %>&nbsp;
			</td>
		</tr>
  </dhv:evaluate>
   <tr class="containerBody" >
      <td nowrap class="formLabel">
        <dhv:label name="osaa.livelloRischio" >Categoria di Rischio</dhv:label>
      </td>
      <td>
         <% if (OrgDetails.getCategoriaRischio() == 0 || OrgDetails.getCategoriaRischio() == -1)
         {
        	 out.print("3");
         }
         else
         {
        	 out.print(OrgDetails.getCategoriaRischio());
         }
         %>
      </td>
    </tr>
    <tr class="containerBody" >
      <td nowrap class="formLabel">
        <dhv:label name="osaa.livelloRischio" >Prossimo Controllo</br>con la tecnica della Sorveglianza</dhv:label>
      </td>
      <td>
      <% SimpleDateFormat dataPC = new SimpleDateFormat("dd/MM/yyyy");
        java.util.Date datamio = new java.util.Date(System.currentTimeMillis());
		Timestamp d = new Timestamp (datamio.getTime()); %>
         <%= (((OrgDetails.getDataProssimoControllo()!=null))?(dataPC.format(OrgDetails.getDataProssimoControllo())):(dataPC.format(d)))%>
      </td>
    </tr>
</table>
<br/>

 <%if(hasText(OrgDetails.getNumRicIngrosso())){ %>
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
	    <strong><dhv:label name="">Commercio Ingrosso</dhv:label></strong>
	  </th>
  </tr>
 <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="">Data Ricezione Autorizzazione</dhv:label>
    </td>
    <td>
    	<zeroio:tz timestamp="<%= OrgDetails.getDataRicIngrosso() %>" dateOnly="true" showTimeZone="false" default="&nbsp;"/>
    </td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="">Numero Autorizzazione</dhv:label>
    </td>
    <td>
      <%=toHtml(OrgDetails.getNumRicIngrosso().trim()) %>&nbsp;
    </td>
  </tr>
</table>
<br/>
<%} %>
 <%if(hasText(OrgDetails.getNumRicDettaglio().trim())){ %>
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
	    <strong><dhv:label name="">Vendita Dettaglio</dhv:label></strong>
	  </th>
  </tr>
 <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="">Data Ricezione Autorizzazione</dhv:label>
    </td>
    <td>
    	<zeroio:tz timestamp="<%= OrgDetails.getDataRicDettaglio() %>" dateOnly="true" showTimeZone="false" default="&nbsp;"/>
    </td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="">Numero Autorizzazione</dhv:label>
    </td>
    <td>
      <%=toHtml(OrgDetails.getNumRicDettaglio().trim()) %>&nbsp;
    </td>
  </tr>
</table>
<br />
<%} %>

<dhv:evaluate if="<%=OrgDetails.isTrashed()%>">
    <dhv:permission name="farmacosorveglianza-farmacosorveglianza-edit">
      <input type="button" value="<dhv:label name="button.restore">Restore</dhv:label>"	onClick="javascript:window.location.href='Farmacosorveglianza.do?command=RestoreFcie&idFarmacia=<%= OrgDetails.getIdFarmacia() %>';">
    </dhv:permission>
</dhv:evaluate>
<dhv:evaluate if="<%=!OrgDetails.isTrashed()%>">
  
    <dhv:permission name="farmacosorveglianza-farmacosorveglianza-edit"><input type="button"  value="<dhv:label name="global.button.modify">Modify</dhv:label>"	onClick="javascript:window.location.href='Farmacosorveglianza.do?command=ModifyFcie&idFarmacia=<%= OrgDetails.getIdFarmacia() %><%= addLinkParams(request, "popup|actionplan") %>';"></dhv:permission>
 
    <%--dhv:permission name="farmacosorveglianza-farmacosorveglianza-edit">
      <input type="button" value="<dhv:label name="global.button.Enable">Enable</dhv:label>" 	onClick="javascript:window.location.href='Farmacosorveglianza.do?command=EnableFcie&idFarmacie=<%= OrgDetails.getIdFarmacia() %>';">
    </dhv:permission--%>
  
</dhv:evaluate>
</dhv:container>
<input type="hidden" name="source" value="searchForm">
<%= addHiddenParams(request, "popup|popupType|actionId") %>
<% if (request.getParameter("return") != null) { %>
<input type="hidden" name="return" value="<%=request.getParameter("return")%>">
<%}%>
<% if (request.getParameter("actionplan") != null) { %>
<input type="hidden" name="actionplan" value="<%=request.getParameter("actionplan")%>">
<%}%>