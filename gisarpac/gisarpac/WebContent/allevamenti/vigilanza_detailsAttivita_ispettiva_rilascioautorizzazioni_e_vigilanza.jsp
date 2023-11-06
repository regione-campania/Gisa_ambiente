<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio"%>
<%@ page
	import="java.util.*,java.text.DateFormat,org.aspcfs.modules.vigilanza.base.*,com.zeroio.iteam.base.*, org.aspcfs.modules.quotes.base.*,org.aspcfs.modules.base.EmailAddress"%>
<%@page import="org.aspcfs.modules.allevamenti.base.Organization"%>
<%@page
	import="org.aspcf.modules.controlliufficiali.action.AccountVigilanza"%>
<jsp:useBean id="TicketDetails"
	class="org.aspcfs.modules.vigilanza.base.Ticket" scope="request" />
<jsp:useBean id="TicList"
	class="org.aspcfs.modules.campioni.base.TicketList" scope="request" />
<jsp:useBean id="SanzioniList"
	class="org.aspcfs.modules.sanzioni.base.TicketList" scope="request" />
<jsp:useBean id="SequestriList"
	class="org.aspcfs.modules.sequestri.base.TicketList" scope="request" />
<jsp:useBean id="NonCList"
	class="org.aspcfs.modules.nonconformita.base.TicketList"
	scope="request" />
<jsp:useBean id="Audit" class="org.aspcfs.checklist.base.AuditList"
	scope="request" />
<jsp:useBean id="ReatiList"
	class="org.aspcfs.modules.reati.base.TicketList" scope="request" />
<jsp:useBean id="TamponiList"
	class="org.aspcfs.modules.tamponi.base.TicketList" scope="request" />
<jsp:useBean id="ticketCategoryList"
	class="org.aspcfs.modules.troubletickets.base.TicketCategoryList"
	scope="request" />
<jsp:useBean id="product"
	class="org.aspcfs.modules.products.base.ProductCatalog" scope="request" />
<jsp:useBean id="customerProduct"
	class="org.aspcfs.modules.products.base.CustomerProduct"
	scope="request" />
<jsp:useBean id="quoteList"
	class="org.aspcfs.modules.quotes.base.QuoteList" scope="request" />
	
	
	
	<jsp:useBean id="ProvvedimentiList" class="org.aspcfs.modules.prvvedimentinc.base.TicketList" scope="request"/>
<jsp:useBean id="AltreNonCList" class="org.aspcfs.modules.altriprovvedimenti.base.TicketList" scope="request"/>


<jsp:useBean id="AuditTipo" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="OrgDetails"
	class="org.aspcfs.modules.allevamenti.base.Organization"
	scope="request" />
<jsp:useBean id="Provvedimenti" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="OrgCategoriaRischioList"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="OrgCategoriaRischioList2"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="SanzioniAmministrative"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="TitoloNucleo" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="TitoloNucleoDue"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="TitoloNucleoTre"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="TitoloNucleoQuattro"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="TitoloNucleoCinque"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="TitoloNucleoSei"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="TitoloNucleoSette"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="TitoloNucleoOtto"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="TitoloNucleoNove"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="TitoloNucleoDieci"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="EsitoCampione" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="DestinatarioCampione"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="TipoCampione" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="SanzioniPenali" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="fileItem" class="com.zeroio.iteam.base.FileItem"
	scope="request" />
<jsp:useBean id="Sequestri" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="SiteIdList" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="causeList" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="ticketStateList"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="resolutionList" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="defectCheck" class="java.lang.String" scope="request" />
<jsp:useBean id="defect"
	class="org.aspcfs.modules.troubletickets.base.TicketDefect"
	scope="request" />
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean"
	scope="session" />
<jsp:useBean id="IspezioneMacrocategorie"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="EsitoControllo" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="DistribuzionePartita"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="DestinazioneDistribuzione"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="ArticoliAzioni" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="AzioniAdottate" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<script language="JavaScript" TYPE="text/javascript"
	SRC="javascript/confirmDelete.js"></script>
<script language="JavaScript" TYPE="text/javascript"
	SRC="javascript/controlli_ufficiali_allevamenti.js"></script>
<%@ include file="../initPage.jsp"%>
<form name="details"
	action="AllevamentiVigilanza.do?command=ModifyTicket&auto-populate=true"
	method="post">
	<%-- Trails --%>
	<table class="trails" cellspacing="0">
		<tr>
			<td>
			<td><a href="Allevamenti.do"><dhv:label name="">Allevamenti</dhv:label></a>
				> <a href="Allevamenti.do?command=Search"><dhv:label
						name="accounts.SearchResults">Search Results</dhv:label></a> > <a
				href="Allevamenti.do?command=Details&orgId=<%=TicketDetails.getOrgId()%>"><dhv:label
						name="">Scheda Allevamento</dhv:label></a> > <a
				href="Allevamenti.do?command=ViewVigilanza&orgId=<%=TicketDetails.getOrgId()%>"><dhv:label
						name="vigilanza">Tickets</dhv:label></a> > <dhv:label
					name="campione.dettagli">Scheda Controllo Ufficiale</dhv:label></td>
		</tr>
	</table>
	<%
boolean invioBenessereAnimale = false ;
for(Piano pm :TicketDetails.getPianoMonitoraggio()) {
	
	if ( (pm.getCodice_interno() != null && pm.getCodice_interno().equals("982")) || (pm.getCodice_interno() != null && pm.getCodice_interno().equals("983")) || ( pm.getDescrizione().toLowerCase().contains("benessere animale") || pm.getDescrizione().toLowerCase().contains("20 piano") || pm.getDescrizione().toLowerCase().contains("benessere animale") || pm.getDescrizione().toLowerCase().contains("49 piano"))){
		invioBenessereAnimale = true ;
	}
}
%>
	<%-- End Trails --%>
	<%
	String param1 = "id=" + TicketDetails.getId();
%>
	<dhv:container name="allevamenti" selected="vigilanza"
		object="OrgDetails" param='<%= "orgId=" + OrgDetails.getOrgId() %>'
		hideContainer='<%= isPopup(request) || (defectCheck != null && !"".equals(defectCheck.trim())) %>'>
		<%@ include file="ticket_header_include_vigilanza.jsp"%>
		<%
	String permission_op_edit = TicketDetails.getPermission_ticket()+"-vigilanza-edit" ;
	String permission_op_del = TicketDetails.getPermission_ticket()+"-vigilanza-delete" ;
	%>
		<%@ include
			file="../controlliufficiali/header_controlli_ufficiali.jsp"%>
		<%@ include
			file="../controlliufficiali/controlli_ufficiali_stampa_verbale_ispezione.jsp"%>
		<dhv:permission name="chkbns-chkbns-view">
			<%@ include
				file="../controlliufficiali/controlli_ufficiali_stampa_chk_bns.jsp"%>
		</dhv:permission>
		<dhv:permission name="ricompila-b11-view">
			<%
if (request.getAttribute("conformitaB11") != null && request.getAttribute("conformitaB11").equals("true")) {	
%>
			<input type="button"
				onclick="location.href='AllevamentiVigilanza.do?command=RicompilaSchedaB11&id=<%=TicketDetails.getId() %>'"
				value="Ricompila Checklist Atto B11 aggiornata">
			<% } %>
		</dhv:permission>
		<dhv:permission name="allevamenti-allevamenti-ba-view">
			<%

if (invioBenessereAnimale==true && TicketDetails.getClosed()!=null && ( TicketDetails.getEsito_import()==null || (TicketDetails.getEsito_import()!= null && TicketDetails.getEsito_import().equalsIgnoreCase("ko")))) {
%>
<div align="center">
<input type="button" onclick="loadModalWindow(); location.href='AllevamentiVigilanza.do?command=SendControlloBenessere&tipo=puntuale&id=<%=TicketDetails.getId() %>'" value="Invia Al Ministero (Benessere animale)">
</div><br/><br/>
				
			<%	 } %>
		</dhv:permission>
		
		<%if (invioBenessereAnimale && TicketDetails.getClosed()==null && TicketDetails.getEsito_import()!=null && TicketDetails.getEsito_import().equalsIgnoreCase("ko")){ %>
		<script>
		alert("Attenzione. Il controllo e' stato inviato con esito KO con la motivazione riportata in questa pagina. Pertanto il controllo e la lista di riscontro benessere sono stati riaperti.");
		</script>
		<%} %>
		
		<%-- INCLUSIONE DETTAGLIO CONTROLLO UFFICIALE--%>
		<%if (TicketDetails.getEsito_import()!=null){ %>
		<table cellpadding="4" cellspacing="0" width="100%" class="details">
			<tr>
				<th colspan="2">Esito Invio Ministero (Benessere animale)</th>
			</tr>
			<tr class="containerBody">
				<td nowrap class="formLabel">Esito</td>
				<td><%=TicketDetails.getEsito_import() %></td>
			</tr>
			<tr class="containerBody">
				<td nowrap class="formLabel">Data Invio</td>
				<td><%=TicketDetails.getData_import() %></td>
			</tr>
			<tr class="containerBody">
				<td nowrap class="formLabel">Descrizione Errore</td>
				<td><%=(TicketDetails.getDescrizione_errore()!= null && !"".equals(TicketDetails.getDescrizione_errore())? TicketDetails.getDescrizione_errore() : "" ) %></td>
			</tr>
		</table>
		<%} %>
		
		
		<%if (TicketDetails.getEsito_import_b11()!=null){ %>
		<table cellpadding="4" cellspacing="0" width="100%" class="details">
			<tr>
				<th colspan="2">Esito Invio Ministero (Condizionalità Atto B11)</th>
			</tr>
			<tr class="containerBody">
				<td nowrap class="formLabel">Esito</td>
				<td><%=TicketDetails.getEsito_import_b11() %></td>
			</tr>
			<tr class="containerBody">
				<td nowrap class="formLabel">Data Invio</td>
				<td><%=TicketDetails.getData_import_b11() %></td>
			</tr>
			<tr class="containerBody">
				<td nowrap class="formLabel">Descrizione Errore</td>
				<td><%=(TicketDetails.getDescrizione_errore_b11()!= null && !"".equals(TicketDetails.getDescrizione_errore_b11())? TicketDetails.getDescrizione_errore_b11() : "" ) %></td>
			</tr>
		</table>
		<%} %>
		
		
		<br>
		<br>
		<table cellpadding="4" cellspacing="0" width="100%" class="details">
			<%@ include file="../controlliufficiali/controlli_ufficiali_view.jsp"%>
			<%@ include
				file="../controlliufficiali/controlli_ufficiali_info_preavviso_view.jsp"%>
		</table>
		<br>
		<br>
		<%-- INCLUSIONE DETTAGLIO SISTEMA ALLARME RAPIDO --%>
		<%@ include
			file="../controlliufficiali/controlli_ufficiali_allarmerapido_view.jsp"%>
		<br>
		<br>
		<% int punteggioAccumulato = 0; %>
		<%@ include
			file="../controlliufficiali/controlli_ufficiali_sottoattivita.jsp"%>
	
 <% if (TicketDetails.getTipoCampione() == 5){ %>
	<jsp:include page="../controlliufficiali/controlli_ufficiali_checklist_sorveglianza.jsp">
    <jsp:param name="idControllo" value="<%=TicketDetails.getId() %>" />
    </jsp:include>
  <% } %> 


		<%@ include
			file="../controlliufficiali/controlli_ufficiali_dettaglio_sottoattivita.jsp"%>
		<br />
		<% if(TicketDetails.getTipoCampione()!=5){ // sorveglianza %>
		<table cellpadding="4" cellspacing="0" width="100%" class="details">
			<tr>
				<th colspan="3"><strong><dhv:label name="">Punteggio Controllo Ufficiale</dhv:label></strong>
				</th>
			</tr>
			<dhv:evaluate
				if="<%= TicketDetails.getEstimatedResolutionDate()!=null %>">
				<tr class="containerBody">
					<td class="formLabel"><dhv:label
							name="sanzionia.data_ispezione">Data</dhv:label></td>
					<td><zeroio:tz
							timestamp="<%= TicketDetails.getEstimatedResolutionDate() %>"
							dateOnly="true"
							timeZone="<%= TicketDetails.getEstimatedResolutionDateTimeZone() %>"
							showTimeZone="false" default="&nbsp;" /></td>
				</tr>
			</dhv:evaluate>
			<dhv:evaluate if="<%= (TicketDetails.getPunteggio() > -1) %>">
				<tr class="containerBody">
					<td name="punteggio" id="punteggio" nowrap class="formLabel">
						<dhv:label name="">Punteggio Accumulato </dhv:label>
					</td>
					<td><%= toHtmlValue(TicketDetails.getPunteggio()) %> <input
						type="hidden" name="punteggio" id="punteggio" size="20"
						maxlength="256" /></td>
				</tr>
			</dhv:evaluate>
			<%//if(punteggioAccumulato<=3) {%>
			<dhv:evaluate>
				<tr class="containerBody">
					<td nowrap class="formLabel"><dhv:label name="">Esito </dhv:label>
					</td>
					<td></td>
				</tr>
			</dhv:evaluate>
			<%//} %>
			<dhv:evaluate if="<%= hasText(TicketDetails.getSolution()) %>">
				<tr class="containerBody">
					<td valign="top" class="formLabel"><dhv:label
							name="sanzionia.azioni">Ulteriori Note</dhv:label></td>
					<td><%= toString(TicketDetails.getSolution()) %></td>
				</tr>
			</dhv:evaluate>
		</table>
		<% } %>
		&nbsp;
<br />
		<%@ include
			file="../controlliufficiali/controlli_ufficiali_adeguamento_schede_zoot_view.jsp"%><br>
		
		<%@ include
			file="../controlliufficiali/header_controlli_ufficiali.jsp"%>
	</dhv:container>
</form>
<% String flag=(String)request.getAttribute("Chiudi");
if(flag!=null){
if(flag.equals("1")){ %>
<script>
	alert("Questo Controllo Ufficiale non puo essere chiuso .Ci sono Attività collegate che non sono state ancora chiuse.");
</script>
<%  }else if(flag.equals("2")){ %>
<script>
	alert("Questo Controllo Ufficiale non puo essere chiuso. Assicurarsi di aver chiuso tutte le sottoattività e aggiornato la categoria di rischio per l'ultima check list inserita(Inserire Check list e aggiornare categoria rishio).");
</script>
<% }else if(flag.equals("3")){ %>
<script>			alert("Chiusura del controllo ufficiale effettuata correttamente."); </script>
<%}else if(flag.equals("4")){ %>
<srcipt>	alert("Controllo Ufficiale chiuso in attesa di esito (sottosezione Tamponi o Campioni)."); </srcipt>
<%	}}  %>