<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,java.text.DateFormat,org.aspcfs.modules.tamponi.base.*,com.zeroio.iteam.base.*, org.aspcfs.modules.quotes.base.*,org.aspcfs.modules.base.EmailAddress" %>

<%@page import="com.sun.java.swing.plaf.windows.WindowsBorders.ProgressBarBorder"%><jsp:useBean id="TicketDetails" class="org.aspcfs.modules.tamponi.base.Ticket" scope="request"/>
<jsp:useBean id="ticketCategoryList" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="product" class="org.aspcfs.modules.products.base.ProductCatalog" scope="request"/>
<jsp:useBean id="customerProduct" class="org.aspcfs.modules.products.base.CustomerProduct" scope="request"/>
<jsp:useBean id="quoteList" class="org.aspcfs.modules.quotes.base.QuoteList" scope="request"/>
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
<jsp:useBean id="ConseguenzePositivita" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ResponsabilitaPositivita" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="AlimentiNonTrasformati" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="AlimentiNonTrasformatiValori" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="AlimentiTrasformati" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="AlimentiVegetali" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="OrgDetails" class="org.aspcfs.modules.farmacosorveglianza.base.Organization" scope="request"/>
<jsp:useBean id="Provvedimenti" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SanzioniAmministrative" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="EsitoTampone" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="DestinatarioTampone" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoTampone" class="org.aspcfs.utils.web.LookupList" scope="request"/>
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
<%@ include file="../initPage.jsp" %>
<form name="details" action="FarmacieTamponi.do?command=ModifyTicket&auto-populate=true" method="post">
<input type = "hidden" name = "idC" value = "<%=TicketDetails.getIdControlloUfficiale() %>">

<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<td>
    <a href="Farmacosorveglianza.do?command=SearchFormFcie"><dhv:label name="">Farmacosorveglianza</dhv:label></a> > 
<a href="Farmacosorveglianza.do?command=SearchFcie"><dhv:label name="accounts.SearchResults">Search Results</dhv:label></a> >
 <a href="Farmacosorveglianza.do?command=DetailsFcie&idFarmacia=<%=OrgDetails.getOrgId()%>">Dettaglio Farmacosorveglianza</a> >
  <a href="FarmacieVigilanza.do?command=ViewVigilanza&orgId=<%=OrgDetails.getOrgId()%>"><dhv:label name="vigilanza">Tickets</dhv:label></a> >
 <a href="FarmacieVigilanza.do?command=TicketDetails&id=<%= request.getAttribute("idC")%>&orgId=<%=OrgDetails.getOrgId()%>"><dhv:label name="">Controllo Ufficiale</dhv:label></a> >
   <%--a href="Accounts.do?command=ViewTamponi&orgId=<%=TicketDetails.getOrgId()%>"><dhv:label name="tamponi">Tamponi</dhv:label></a> --%>
<dhv:label name="tampone.dettagli">Scheda Tampone</dhv:label>
</td>
</tr>
</table>
<%-- End Trails --%>
<%
	String param1 = "id=" + TicketDetails.getId();
%>
<dhv:container name="farmacosorveglianza" selected="vigilanza" object="OrgDetails" param='<%= "orgId=" + OrgDetails.getOrgId() %>' hideContainer='<%= isPopup(request) || (defectCheck != null && !"".equals(defectCheck.trim())) %>'>

	<%
		if (TicketDetails.isTrashed()) {
	%>
	<dhv:permission name="farmacie-farmacie-tamponi-delete">
		<input type="button"
			value="<dhv:label name="button.restore">Restore</dhv:label>"
			onClick="javascript:this.form.action='FarmacieTamponi.do?command=Restore&id=<%= TicketDetails.getId()%>';submit();">
	</dhv:permission>
	<%
		} else if (TicketDetails.getClosed() != null) {
	%>
	<dhv:permission name="reopen-reopen-view">
		<input type="button"
			value="<dhv:label name="button.reopen">Reopen</dhv:label>"
			onClick="javascript:this.form.action='FarmacieTamponi.do?command=ReopenTicket&id=<%= TicketDetails.getId()%><%= (defectCheck != null && !"".equals(defectCheck.trim())?"&defectCheck="+defectCheck:"") %>';submit();">
	</dhv:permission>
	<%
		} else {
	%>
	<dhv:permission name="farmacie-farmacie-tamponi-edit">
		<input type="button"
			value="<dhv:label name="global.button.modifya">Modifica/Inserisci Esito</dhv:label>"
			onClick="javascript:this.form.action='FarmacieTamponi.do?command=ModifyTicket&auto-populate=true<%= (defectCheck != null && !"".equals(defectCheck.trim())?"&defectCheck="+defectCheck:"") %>';submit();">
	</dhv:permission>
	<%--
      <dhv:permission name="quotes-view">
        <dhv:evaluate if="<%= TicketDetails.getProductId() > 0 %>">
          <input type="button" value="<dhv:label name="ticket.generateQuote">Generate Quote</dhv:label>" onClick="javascript:this.form.action='Quotes.do?command=Details&productId=<%= TicketDetails.getProductId() %>&id=<%= TicketDetails.getId() %>';submit();"/>
        </dhv:evaluate>
      </dhv:permission>
      --%>
	<dhv:permission name="farmacie-farmacie-tamponi-delete">
		<%
			if ("searchResults".equals(request
								.getParameter("return"))) {
		%>
		<input type="button"
			value="<dhv:label name="global.button.delete">Delete</dhv:label>"
			onClick="javascript:popURL('FarmacieTamponi.do?command=ConfirmDelete&id=<%= TicketDetails.getId() %>&orgId=<%=OrgDetails.getOrgId() %>&return=searchResults&popup=true', 'Delete_ticket','320','200','yes','no');">
		<%
			} else {
		%>
		<input type="button"
			value="<dhv:label name="global.button.delete">Delete</dhv:label>"
			onClick="javascript:popURL('FarmacieTamponi.do?command=ConfirmDelete&id=<%= TicketDetails.getId() %>&orgId=<%=OrgDetails.getOrgId() %>&popup=true', 'Delete_ticket','320','200','yes','no');">
		<%
			}
		%>
	</dhv:permission>
	<dhv:permission name="farmacie-farmacie-tamponi-edit">
		<input type="button"
			value="<dhv:label name="global.button.close">Chiudi</dhv:label>"
			onClick="javascript:this.form.action='FarmacieTamponi.do?command=Chiudi&id=<%= TicketDetails.getId() %>';if( confirm('Sei sicuro di voler chiudere il tampone? \n Attenzione! La pratica verr� chiusa e non sar� pi� possibile fare modifiche \n sulla scheda se non con il permesso del supervisore o dell amministratore') ){submit()};">
	</dhv:permission>
	<%
		}
	%>
	
	<table cellpadding="4" cellspacing="0" width="100%" class="details">
		<tr>
			<th colspan="2"><strong><dhv:label
				name="sanzionia.information">Scheda Tampone</dhv:label></strong></th>
		</tr>
		
		
			<%@ include file="/tamponi/tamponi_view.jsp" %>

   </table>
   
 
&nbsp;
<br />
	<%
		if (TicketDetails.isTrashed()) {
	%>
	<dhv:permission name="farmacie-farmacie-tamponi-delete">
		<input type="button"
			value="<dhv:label name="button.restore">Restore</dhv:label>"
			onClick="javascript:this.form.action='FarmacieTamponi.do?command=Restore&id=<%= TicketDetails.getId()%>';submit();">
	</dhv:permission>
	<%
		} else if (TicketDetails.getClosed() != null) {
	%>
	<dhv:permission name="reopen-reopen-view">
		<input type="button"
			value="<dhv:label name="button.reopen">Reopen</dhv:label>"
			onClick="javascript:this.form.action='FarmacieTamponi.do?command=ReopenTicket&id=<%= TicketDetails.getId()%><%= (defectCheck != null && !"".equals(defectCheck.trim())?"&defectCheck="+defectCheck:"") %>';submit();">
	</dhv:permission>
	<%
		} else {
	%>
	<dhv:permission name="farmacie-farmacie-tamponi-edit">
		<input type="button"
			value="<dhv:label name="global.button.modifya">Modifica/Inserisci Esito</dhv:label>"
			onClick="javascript:this.form.action='FarmacieTamponi.do?command=ModifyTicket&auto-populate=true<%= (defectCheck != null && !"".equals(defectCheck.trim())?"&defectCheck="+defectCheck:"") %>';submit();">
	</dhv:permission>
	
	<dhv:permission name="farmacie-farmacie-tamponi-delete">
		<%
			if ("searchResults".equals(request
								.getParameter("return"))) {
		%>
		<input type="button"
			value="<dhv:label name="global.button.delete">Delete</dhv:label>"
			onClick="javascript:popURL('FarmacieTamponi.do?command=ConfirmDelete&id=<%= TicketDetails.getId() %>&orgId=<%=OrgDetails.getOrgId() %>&return=searchResults&popup=true', 'Delete_ticket','320','200','yes','no');">
		<%
			} else {
		%>
		<input type="button"
			value="<dhv:label name="global.button.delete">Delete</dhv:label>"
			onClick="javascript:popURL('FarmacieTamponi.do?command=ConfirmDelete&id=<%= TicketDetails.getId() %>&orgId=<%=OrgDetails.getOrgId() %>&popup=true', 'Delete_ticket','320','200','yes','no');">
		<%
			}
		%>
	</dhv:permission>
	<dhv:permission name="farmacie-farmacie-tamponi-edit">
		<input type="button"
			value="<dhv:label name="global.button.close">Chiudi</dhv:label>"
			onClick="javascript:this.form.action='FarmacieTamponi.do?command=Chiudi&id=<%= TicketDetails.getId() %>';if( confirm('Sei sicuro di voler chiudere il tampone? \n Attenzione! La pratica verr� chiusa e non sar� pi� possibile fare modifiche \n sulla scheda se non con il permesso del supervisore o dell amministratore') ){submit()};">
	</dhv:permission>
	<%
		}
	%>
</dhv:container>
</form>
<%
String msg = (String)request.getAttribute("Messaggio");
if(request.getAttribute("Messaggio")!=null)
{
	%>
	<script>
	
	alert("La pratica non pu� essere chiusa . \n Controllare di aver inserito l'esito.");
	</script>
	<%
}

%>

<%
String msg2 = (String)request.getAttribute("Messaggio2");
if(request.getAttribute("Messaggio2")!=null)
{
	%>
	<script>

	var answer = confirm("Tutte le Attivita Collegate al controllo sono state chiuse . \n Desideri Chiudere il Controllo Ufficiale ? \n Attenzione! La pratica verr� chiusa e non sar� pi� possibile fare modifiche \n sulla scheda se non con il permesso del supervisore o dell amministratore ")

	if (answer){
		
		doSubmit(<%=TicketDetails.getId() %>);
	}


	function doSubmit(idTicket){

		document.details.action="FarmacieTamponi.do?command=Chiudi&id="+idTicket+"&chiudiCu=true'"
		document.details.submit();

		}
	
	</script>
	<%
}

%>
