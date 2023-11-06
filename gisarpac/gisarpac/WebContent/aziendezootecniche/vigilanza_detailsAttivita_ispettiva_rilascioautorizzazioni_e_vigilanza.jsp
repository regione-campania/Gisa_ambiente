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
<jsp:useBean id="OrgDetails" class="com.aspcfs.modules.aziendezootecniche.base.IstanzaProduttiva" scope="request"/>

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
	
	if (pm.getCodice_interno().equals("982") || ( pm.getDescrizione().toLowerCase().contains("benessere animale") || pm.getDescrizione().toLowerCase().contains("20 piano") || pm.getDescrizione().toLowerCase().contains("benessere animale") || pm.getDescrizione().toLowerCase().contains("49 piano"))){
		invioBenessereAnimale = true ;
	}
}
%>
	<%-- End Trails --%>
	<%
	String param1 = "id=" + TicketDetails.getId();
%>
	<dhv:container name="aziendezootecniche" selected="vigilanza"
		object="OrgDetails" param='<%= "orgId=" + OrgDetails.getAltId() %>'
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
			<input type="button"
				onclick="location.href='AllevamentiVigilanza.do?command=SendControlloBenessere&tipo=puntuale&id=<%=TicketDetails.getId() %>'"
				value="Invia Al Ministero">
			<%	 } %>
		</dhv:permission>
		<%-- INCLUSIONE DETTAGLIO CONTROLLO UFFICIALE--%>
		<%if (TicketDetails.getEsito_import()!=null){ %>
		<table cellpadding="4" cellspacing="0" width="100%" class="details">
			<tr>
				<th colspan="2">Esito Invio Ministero</th>
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
		<%
   if(Audit.size()!=0)  { %>
		<table cellpadding="4" cellspacing="0" width="100%" class="details">
			<th colspan="5" style="background-color: rgb(204, 255, 153);">
				<strong> <dhv:label name="">Check List</dhv:label>
			</strong>
			</th>
			<tr>
				<th>Tipo Check List</th>
				<%--th><b><dhv:label name="">Livello Rischio</dhv:label></b></th--%>
				<th><b><dhv:label name="">Stato</dhv:label></b></th>
				<th><b><dhv:label name="">Punteggio Check List</dhv:label></b></th>
				<th>&nbsp;</th>
			</tr>
			<%		int category = -1;
            Iterator itr = Audit.iterator();
            if (itr.hasNext()){
              int rowid = 0;
              int i = 0;
              while (itr.hasNext()){
                i++;
                rowid = (rowid != 1 ? 1 : 2);
                org.aspcfs.checklist.base.Audit thisAudit = (org.aspcfs.checklist.base.Audit)itr.next();
                punteggioAccumulato += thisAudit.getLivelloRischio();
                category = thisAudit.getCategoria();
    %>
			<tr class="row<%=rowid%>">
				<td><a
					href="CheckListAllevamenti.do?command=View&id=<%= thisAudit.getId()%>&aggiorna=<%=thisAudit.isAggiornaCategoria() %>"><%= toHtml(OrgCategoriaRischioList.getSelectedValue(thisAudit.getTipoChecklist())) %></a>
				</td>
				<td class="formLabelTD"><%=thisAudit.getStato() %></td>
				<td class="formLabelTD"><%= ((thisAudit.getLivelloRischio()>0) ? (toHtml(String.valueOf(thisAudit.getLivelloRischio()))) : ("-")) %>
				</td>
				<td>
					<%if (TicketDetails.isCategoriaisAggiornata()==false) {%> <a
					href="javascript:eliminaCheckList(<%=thisAudit.getId() %>,<%=TicketDetails.getId() %>,<%=OrgDetails.getAltId() %>)">Elimina</a>
					<%}else	{%> &nbsp; <%	}%>
				</td>
			</tr>
			<%}%>
			<tr class="containerBody">
				<td colspan="5" name="punteggio" id="punteggio" nowrap
					class="formLabelNew"><dhv:label name="">
						<b>Punteggio Totale Check List:</b>
					</dhv:label> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <%= request.getAttribute("PunteggioCheckList") %>
				</td>
			</tr>
			<tr class="containerBody">
				<td colspan="5" nowrap class="formLabel"><b><dhv:label
							name="">Categoria Rischio Attribuita con Questo controllo:</dhv:label></b>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <%if(TicketDetails.getCategoriaRischio()>0) {%>
					<%= toHtml(String.valueOf(TicketDetails.getCategoriaRischio())) %>
					<%} %></td>
			</tr>
			<%}else{%>
			<tr class="containerBody">
				<td colspan="5"><dhv:label
						name="accounts.accounts_asset_list_include.NoAuditFound">Nessuna Check List compilata.</dhv:label>
				</td>
			</tr>
			<%}%>
		</table>
		</br>
		<%}   //controllo se � in sorveglianza
	%>
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
			file="../controlliufficiali/controlli_ufficiali_adeguamento_schede_zoot_opu_view.jsp"%><br>
		
		<%@ include
			file="../controlliufficiali/header_controlli_ufficiali.jsp"%>
	</dhv:container>
</form>
<% String flag=(String)request.getAttribute("Chiudi");
if(flag!=null){
if(flag.equals("1")){ %>
<script>
	alert("Questo Controllo Ufficiale non puo essere chiuso .Ci sono Attivit� collegate che non sono state ancora chiuse.");
</script>
<%  }else if(flag.equals("2")){ %>
<script>
	alert("Questo Controllo Ufficiale non puo essere chiuso. Assicurarsi di aver chiuso tutte le sottoattivit� e aggiornato la categoria di rischio per l'ultima check list inserita(Inserire Check list e aggiornare categoria rishio).");
</script>
<% }else if(flag.equals("3")){ %>
<script>			alert("Chiusura del controllo ufficiale effettuata correttamente."); </script>
<%}else if(flag.equals("4")){ %>
<srcipt>	alert("Controllo Ufficiale chiuso in attesa di esito (sottosezione Tamponi o Campioni)."); </srcipt>
<%	}}  %>