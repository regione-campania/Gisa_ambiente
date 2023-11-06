<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,java.text.DateFormat,org.aspcfs.modules.vigilanza.base.*,com.zeroio.iteam.base.*, org.aspcfs.modules.quotes.base.*,org.aspcfs.modules.base.EmailAddress" %>
<jsp:useBean id="TicketDetails" class="org.aspcfs.modules.vigilanza.base.Ticket" scope="request"/>
<jsp:useBean id="ticketCategoryList" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="product" class="org.aspcfs.modules.products.base.ProductCatalog" scope="request"/>
<jsp:useBean id="customerProduct" class="org.aspcfs.modules.products.base.CustomerProduct" scope="request"/>
<jsp:useBean id="quoteList" class="org.aspcfs.modules.quotes.base.QuoteList" scope="request"/>
<jsp:useBean id="OrgDetails" class="org.aspcfs.modules.aziendeagricole.base.Organization" scope="request"/>
<jsp:useBean id="Provvedimenti" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SanzioniAmministrative" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TitoloNucleo" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TitoloNucleoDue" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TitoloNucleoTre" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TitoloNucleoQuattro" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TitoloNucleoCinque" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TitoloNucleoSei" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TitoloNucleoSette" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TitoloNucleoOtto" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TitoloNucleoNove" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TitoloNucleoDieci" class="org.aspcfs.utils.web.LookupList" scope="request"/>

<jsp:useBean id="EsitoCampione" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="DestinatarioCampione" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoCampione" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SanzioniPenali" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Sequestri" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SiteIdList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="causeList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ticketStateList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="resolutionList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="defectCheck" class="java.lang.String" scope="request"/>
<jsp:useBean id="defect" class="org.aspcfs.modules.troubletickets.base.TicketDefect" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/confirmDelete.js"></script>
<script type="text/javascript">

</script>
<%@ include file="../initPage.jsp" %>
<form name="details" action="AziendeAgricoleVigilanza.do?command=ModifyTicket&auto-populate=true" method="post">
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<td>
  <a href="AziendeAgricole.do">AziendeAgricole</a> > 
  <a href="AziendeAgricole.do?command=Search"><dhv:label name="accounts.SearchResults">Search Results</dhv:label></a> >
  <a href="AziendeAgricole.do?command=Details&orgId=<%=TicketDetails.getOrgId()%>">Scheda Aziende Agricole</a> >
  <a href="AziendeAgricoleVigilanza.do?command=ViewVigilanza&orgId=<%=TicketDetails.getOrgId()%>"><dhv:label name="vigilanza">Tickets</dhv:label></a> >
  <dhv:label name="campione.dettagli">Scheda Controllo Ufficiale</dhv:label>
</td>
</tr>
</table>
<%-- End Trails --%>
<%
	String param1 = "id=" + TicketDetails.getId();
%>
<dhv:container name="aziendeagricole" selected="vigilanza" object="OrgDetails" param='<%= "orgId=" + OrgDetails.getOrgId() %>' hideContainer='<%= isPopup(request) || (defectCheck != null && !"".equals(defectCheck.trim())) %>'>
	<%@ include file="ticket_header_include_vigilanza.jsp"%>
	<%
		if (TicketDetails.isTrashed()) {
	%>
	<dhv:permission name="aziendeagricole-vigilanza-delete">
		<input type="button"
			value="<dhv:label name="button.restore">Restore</dhv:label>"
			onClick="javascript:this.form.action='AziendeAgricoleVigilanza.do?command=Restore&id=<%= TicketDetails.getId()%>';submit();">
	</dhv:permission>
	<%
		} else if (TicketDetails.getClosed() != null) {
	%>
	<%--<dhv:permission name="accounts-accounts-vigilanza-edit">
		<input type="button"
			value="<dhv:label name="button.reopen">Reopen</dhv:label>"
			onClick="javascript:this.form.action='AziendeAgricoleVigilanza.do?command=ReopenTicket&id=<%= TicketDetails.getId()%><%= (defectCheck != null && !"".equals(defectCheck.trim())?"&defectCheck="+defectCheck:"") %>';submit();">
	</dhv:permission>--%>
	<%
		} else {
	%>
	<dhv:permission name="aziendeagricole-vigilanza-add">
		<input type="button"
			value="<dhv:label name="">Continua</dhv:label>"
			onClick="javascript:this.form.action='AziendeAgricoleVigilanza.do?command=ModifyTicket&auto-populate=true<%= (defectCheck != null && !"".equals(defectCheck.trim())?"&defectCheck="+defectCheck:"") %>';submit();">
	</dhv:permission>
	<dhv:permission name="aziendeagricole-vigilanza-edit">
		<input type="button"
			value="<dhv:label name="global.button.modify">Modify</dhv:label>"
			onClick="javascript:this.form.action='AziendeAgricoleVigilanza.do?command=ModifyTicket&auto-populate=true<%= (defectCheck != null && !"".equals(defectCheck.trim())?"&defectCheck="+defectCheck:"") %>';submit();">
	</dhv:permission>
	<%--
      <dhv:permission name="quotes-view">
        <dhv:evaluate if="<%= TicketDetails.getProductId() > 0 %>">
          <input type="button" value="<dhv:label name="ticket.generateQuote">Generate Quote</dhv:label>" onClick="javascript:this.form.action='Quotes.do?command=Details&productId=<%= TicketDetails.getProductId() %>&id=<%= TicketDetails.getId() %>';submit();"/>
        </dhv:evaluate>
      </dhv:permission>
      --%>
	<dhv:permission name="aziendeagricole-vigilanza-delete">
		<%
			if ("searchResults".equals(request
								.getParameter("return"))) {
		%>
		<input type="button"
			value="<dhv:label name="global.button.delete">Delete</dhv:label>"
			onClick="javascript:popURL('AziendeAgricoleVigilanza.do?command=ConfirmDelete&id=<%= TicketDetails.getId() %>&orgId=<%=TicketDetails.getOrgId()%>&return=searchResults&popup=true', 'Delete_ticket','320','200','yes','no');">
		<%
			} else {
		%>
		<input type="button"
			value="<dhv:label name="global.button.delete">Delete</dhv:label>"
			onClick="javascript:popURL('AziendeAgricoleVigilanza.do?command=ConfirmDelete&id=<%= TicketDetails.getId() %>&orgId=<%=TicketDetails.getOrgId()%>&popup=true', 'Delete_ticket','320','200','yes','no');">
		<%
			}
		%>
	</dhv:permission>
	<dhv:permission name="aziendeagricole-vigilanza-edit">
		<input type="button"
			value="<dhv:label name="global.button.close">Chiudi</dhv:label>"
			onClick="javascript:this.form.action='AziendeAgricoleVigilanza.do?command=Chiudi&id=<%= TicketDetails.getId() %>';if( confirm('Sei sicuro di voler chiudere il campione?') ){submit()};">
	</dhv:permission>
	<%
		}
	%>
	<dhv:permission name="aziendeagricole-vigilanza-edit,aziendeagricole-vigilanza-delete">
		<br />&nbsp;<br />
	</dhv:permission>
	<%-- Ticket Information --%>
	<%-- Primary Contact --%>
	<dhv:evaluate if="<%= TicketDetails.getThisContact() != null %>">
		<table cellpadding="4" cellspacing="0" width="100%" class="details">
			<tr>
				<th colspan="2"><strong><dhv:label name="">Primary Contact</dhv:label></strong>
				</th>
			</tr>
			<tr class="containerBody">
				<td class="formLabel"><dhv:label name="contacts.name">Name</dhv:label>
				</td>
				<td><dhv:evaluate
					if="<%= !TicketDetails.getThisContact().getEmployee() %>">
					<dhv:permission name="aziendeagricole-contacts-view">
						<a
							href="javascript:popURL('ExternalContacts.do?command=ContactDetails&id=<%= TicketDetails.getContactId() %>&popup=true&popupType=inline','Details','650','500','yes','yes');"><%=toHtml(TicketDetails.getThisContact()
											.getNameFull())%></a>
					</dhv:permission>
					<dhv:permission name="aziendeagricole-contacts-view" none="true">
						<%=toHtml(TicketDetails.getThisContact()
											.getNameFull())%>
					</dhv:permission>
				</dhv:evaluate> <dhv:evaluate
					if="<%= TicketDetails.getThisContact().getEmployee() %>">
					<dhv:permission name="contacts-internal_contacts-view">
						<a
							href="javascript:popURL('CompanyDirectory.do?command=EmployeeDetails&empid=<%= TicketDetails.getContactId() %>&popup=true&popupType=inline','Details','650','500','yes','yes');"><%=toHtml(TicketDetails.getThisContact()
											.getNameLastFirst())%></a>
					</dhv:permission>
					<dhv:permission name="contacts-internal_contacts-view" none="true">
						<%=toHtml(TicketDetails.getThisContact()
											.getNameLastFirst())%>
					</dhv:permission>
				</dhv:evaluate></td>
			</tr>
			<tr class="containerBody">
				<td class="formLabel"><dhv:label
					name="accounts.accounts_contacts_add.Title">Title</dhv:label></td>
				<td><%=toHtml(TicketDetails.getThisContact()
											.getTitle())%></td>
			</tr>
			<tr class="containerBody">
				<td class="formLabel"><dhv:label
					name="accounts.accounts_add.Email">Email</dhv:label></td>
				<td><%=TicketDetails.getThisContact()
									.getEmailAddressTag(
											"",
											toHtml(TicketDetails
													.getThisContact()
													.getPrimaryEmailAddress()),
											"&nbsp;")%>
				</td>
			</tr>
			<tr class="containerBody">
				<td class="formLabel"><dhv:label
					name="accounts.accounts_add.Phone">Phone</dhv:label></td>
				<td><%=toHtml(TicketDetails.getThisContact()
									.getPrimaryPhoneNumber())%>
				</td>
			</tr>
		</table>
&nbsp;
</dhv:evaluate>
	<table cellpadding="4" cellspacing="0" width="100%" class="details">
		<tr>
			<th colspan="2"><strong><dhv:label
				name="sanzionia.information">Scheda Controllo Ufficiale</dhv:label></strong></th>
		</tr>
		<%--<tr class="containerBody">
    <td class="formLabel">
      <dhv:label name="sanzioni.tipo_richiesta">Ticket State</dhv:label>
    </td>
    <td>
      <dhv:label name="<%="richieste." + TicketDetails.getTipo_richiesta() %>"><%=TicketDetails.getTipo_richiesta()%></dhv:label>
    </td>
  </tr>--%>
		
				<tr class="containerBody">
					<td nowrap class="formLabel"><dhv:label
						name="stabilimenti.site">Site</dhv:label></td>
					<td><%=SiteIdList.getSelectedValue(TicketDetails
										.getSiteId())%>
					<%
					%> 
					<input type="hidden"
						name="siteId" value="<%=TicketDetails.getSiteId()%>"></td>
				</tr>
			
  <input type="hidden" name="id" id="id"
			value="<%=  TicketDetails.getId() %>" />
			
		<input type="hidden" name="orgId" id="orgId"
			value="<%=  TicketDetails.getOrgId() %>" />
 <tr class="containerBody">
    <td class="formLabel">
      <dhv:label name="">Identificativo C.U.</dhv:label>
    </td>
   
     
      <td>
        <%= toHtml(TicketDetails.getPaddedId()) %>
      </td>
    
  </tr>
 <tr class="containerBody">
      <td name="tipoCampione1" id="tipoCampione1" nowrap class="formLabel">
        <dhv:label name="">Tipo di controllo</dhv:label>
      </td>
    <td>
      <%= TipoCampione.getSelectedValue(TicketDetails.getTipoCampione())%>
					<input type="hidden" name="tipoCampione" value="<%=TicketDetails.getTipoCampione() %>">
    </td>
  </tr>
	   <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="campioni.data_richiesta">Data</dhv:label>
    </td>
    <td>
      <zeroio:tz
				timestamp="<%= TicketDetails.getAssignedDate() %>" dateOnly="true"
				timeZone="<%= TicketDetails.getAssignedDateTimeZone() %>"
				showTimeZone="false" default="&nbsp;" /> 
     
    </td>
  </tr>
 
  
  <!-- aggiunto da d.dauria -->
  <% if (((TicketDetails.getNucleoIspettivo() > -1) && (TicketDetails.getComponenteNucleo() != "")   ) || ((TicketDetails.getNucleoIspettivoDue() > -1) && (TicketDetails.getComponenteNucleoDue() != "")) || ((TicketDetails.getNucleoIspettivoTre() > -1) && (TicketDetails.getComponenteNucleoTre() != "")) || ((TicketDetails.getNucleoIspettivoQuattro() > -1) && (TicketDetails.getComponenteNucleoQuattro() != "")) || ((TicketDetails.getNucleoIspettivoCinque() > -1) && (TicketDetails.getComponenteNucleoCinque() != "")) || ((TicketDetails.getNucleoIspettivoSei() > -1) && (TicketDetails.getComponenteNucleoSei() != "")) || ((TicketDetails.getNucleoIspettivoSette() > -1) && (TicketDetails.getComponenteNucleoSette() != "")) || ((TicketDetails.getNucleoIspettivoOtto() > -1) && (TicketDetails.getComponenteNucleoOtto() != "")) || ((TicketDetails.getNucleoIspettivoNove() > -1) && (TicketDetails.getComponenteNucleoNove() != "")) || ((TicketDetails.getNucleoIspettivoDieci() > -1) && (TicketDetails.getComponenteNucleoDieci() != "")) ){%>
    <tr class="containerBody" >
   <td name="" class="formLabel">
     <dhv:label name="">Nucleo Ispettivo</dhv:label>
   </td>
   <td >
   <% if((TicketDetails.getNucleoIspettivo() > -1) && (TicketDetails.getComponenteNucleo() != "")) {%>
     <%=TitoloNucleo.getSelectedValue(TicketDetails.getNucleoIspettivo())%>:
     <%=TicketDetails.getComponenteNucleo() %>
   <% } %>
   <% if(TicketDetails.getNucleoIspettivoDue() > -1) {%>
 	  <%=TitoloNucleoDue.getSelectedValue(TicketDetails.getNucleoIspettivoDue())%>:
 	 <%=TicketDetails.getComponenteNucleoDue() %>
   <% } %> 
   <% if(TicketDetails.getNucleoIspettivoTre() > -1) {%>
 	  <%=TitoloNucleoTre.getSelectedValue(TicketDetails.getNucleoIspettivoTre())%>:
 	 <%= TicketDetails.getComponenteNucleoTre() %>
   <% } %> 
   <% if(TicketDetails.getNucleoIspettivoQuattro() > -1) {%>
 	  <%=TitoloNucleoQuattro.getSelectedValue(TicketDetails.getNucleoIspettivoQuattro())%>:
 	 <%= TicketDetails.getComponenteNucleoQuattro() %>
   <% } %>   					 
   <% if(TicketDetails.getNucleoIspettivoCinque() > -1) {%>
 	  <%=TitoloNucleoCinque.getSelectedValue(TicketDetails.getNucleoIspettivoCinque())%>:
 	 <%= TicketDetails.getComponenteNucleoCinque() %>
   <% } %>  
      <% if(TicketDetails.getNucleoIspettivoSei() > -1) {%>
 	  <%=TitoloNucleoSei.getSelectedValue(TicketDetails.getNucleoIspettivoSei())%>:
 	 <%= TicketDetails.getComponenteNucleoSei() %>
   <% } %>  
      <% if(TicketDetails.getNucleoIspettivoSette() > -1) {%>
 	  <%=TitoloNucleoSette.getSelectedValue(TicketDetails.getNucleoIspettivoSette())%>:
 	 <%= TicketDetails.getComponenteNucleoSette() %>
   <% } %>  
      <% if(TicketDetails.getNucleoIspettivoOtto() > -1) {%>
 	  <%=TitoloNucleoOtto.getSelectedValue(TicketDetails.getNucleoIspettivoOtto())%>:
 	 <%= TicketDetails.getComponenteNucleoOtto() %>
   <% } %>  
      <% if(TicketDetails.getNucleoIspettivoNove() > -1) {%>
 	  <%=TitoloNucleoNove.getSelectedValue(TicketDetails.getNucleoIspettivoNove())%>:
 	 <%= TicketDetails.getComponenteNucleoNove() %>
   <% } %>  
      <% if(TicketDetails.getNucleoIspettivoDieci() > -1) {%>
 	  <%=TitoloNucleoDieci.getSelectedValue(TicketDetails.getNucleoIspettivoDieci())%>:
 	 <%= TicketDetails.getComponenteNucleoDieci() %>
   <% } %>  
  </td>
  </tr>
<%} %> 
  
  
  
  
<dhv:evaluate if="<%= hasText(TicketDetails.getProblem()) %>">
  <tr class="containerBody">
    <td valign="top" class="formLabel">
      <dhv:label name="sanzioni.note">Note</dhv:label>
    </td>
    <td>
      <%= toString(TicketDetails.getProblem()) %>
    </td>
	</tr>
</dhv:evaluate>
<%--<dhv:evaluate if="<%= hasText(TicketDetails.getCause()) %>">
  <tr class="containerBody">
    <td valign="top" class="formLabel">
      <dhv:label name="sanzionia.importo">Codice Accettazione</dhv:label>
    </td>
    <td><%= toHtmlValue(TicketDetails.getCause()) %>
    </td>
  </tr>
  </dhv:evaluate>--%>
   </table>
   <br/>
&nbsp;
<br />
	<%
		if (TicketDetails.isTrashed()) {
	%>
	<dhv:permission name="aziendeagricole-vigilanza-delete">
		<input type="button"
			value="<dhv:label name="button.restore">Restore</dhv:label>"
			onClick="javascript:this.form.action='AziendeAgricoleVigilanza.do?command=Restore&id=<%= TicketDetails.getId()%>';submit();">
	</dhv:permission>
	<%
		} else if (TicketDetails.getClosed() != null) {
	%>
	<%--<dhv:permission name="accounts-accounts-vigilanza-edit">
		<input type="button"
			value="<dhv:label name="button.reopen">Reopen</dhv:label>"
			onClick="javascript:this.form.action='AziendeAgricoleVigilanza.do?command=ReopenTicket&id=<%= TicketDetails.getId()%><%= (defectCheck != null && !"".equals(defectCheck.trim())?"&defectCheck="+defectCheck:"") %>';submit();">
	</dhv:permission>--%>
	<%
		} else {
	%>
	<dhv:permission name="aziendeagricole-vigilanza-add">
		<input type="button"
			value="<dhv:label name="">Continua</dhv:label>"
			onClick="javascript:this.form.action='AziendeAgricoleVigilanza.do?command=ModifyTicket&auto-populate=true<%= (defectCheck != null && !"".equals(defectCheck.trim())?"&defectCheck="+defectCheck:"") %>';submit();">
	</dhv:permission>
	<dhv:permission name="aziendeagricole-vigilanza-edit">
		<input type="button"
			value="<dhv:label name="global.button.modify">Modify</dhv:label>"
			onClick="javascript:this.form.action='AziendeAgricoleVigilanza.do?command=ModifyTicket&auto-populate=true<%= (defectCheck != null && !"".equals(defectCheck.trim())?"&defectCheck="+defectCheck:"") %>';submit();">
	</dhv:permission>
	<%--
  <dhv:permission name="quotes-view">
    <dhv:evaluate if="<%= TicketDetails.getProductId() > 0 %>">
      <input type="button" value="<dhv:label name="ticket.generateQuote">Generate Quote</dhv:label>" onClick="javascript:this.form.action='Quotes.do?command=Display&productId=<%= TicketDetails.getProductId() %>&id=<%= TicketDetails.getId() %>';submit();"/>
    </dhv:evaluate>
  </dhv:permission>
  --%>
	<dhv:permission name="aziendeagricole-vigilanza-delete">
		<%
			if ("searchResults".equals(request
								.getParameter("return"))) {
		%>
		<input type="button"
			value="<dhv:label name="global.button.delete">Delete</dhv:label>"
			onClick="javascript:popURL('AziendeAgricoleVigilanza.do?command=ConfirmDelete&id=<%= TicketDetails.getId() %>&orgId=<%=TicketDetails.getOrgId()%>&return=searchResults&popup=true', 'Delete_ticket','320','200','yes','no');">
		<%
			} else {
		%>
		<input type="button"
			value="<dhv:label name="global.button.delete">Delete</dhv:label>"
			onClick="javascript:popURL('AziendeAgricoleVigilanza.do?command=ConfirmDelete&id=<%= TicketDetails.getId() %>&orgId=<%=TicketDetails.getOrgId()%>&popup=true', 'Delete_ticket','320','200','yes','no');">
		<%
			}
		%>
	</dhv:permission>
	<dhv:permission name="aziendeagricole-vigilanza-edit">
		<input type="button"
			value="<dhv:label name="global.button.close">Chiudi</dhv:label>"
			onClick="javascript:this.form.action='AziendeAgricoleVigilanza.do?command=Chiudi&id=<%= TicketDetails.getId() %>';if( confirm('Sei sicuro di voler chiudere il campione?') ){submit()};">
	</dhv:permission>
	<%
		}
	%>
</dhv:container>
</form>
