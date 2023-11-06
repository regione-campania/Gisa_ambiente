<%@page import="java.util.Date"%>
<%@page import="ext.aspcfs.modules.apiari.base.ModelloC"%>
<%@page import="ext.aspcfs.modules.apicolture.actions.StabilimentoAction"%>

<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio"%>

<jsp:useBean id="ListaMovimentazioni" class="ext.aspcfs.modules.apiari.base.MovimentazioniList" scope="request" />
<jsp:useBean id="SearchMovimentazioniTutteListInfo" class="org.aspcfs.utils.web.PagedListInfo" scope="session" />
<jsp:useBean id="LookupTipoMovimentazione" class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="LookupStatoAccettazioneMovimentazione" class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="Operatore" class="ext.aspcfs.modules.apiari.base.Operatore" scope="request" />

<%@ include file="../initPage.jsp"%>

<script language="JavaScript" TYPE="text/javascript" SRC="gestione_documenti/generazioneDocumentale.js"></script>

<SCRIPT LANGUAGE="JavaScript" SRC="javascript/CalendarPopup.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" ID="js19">
	var cal19 = new CalendarPopup();
	cal19.showYearNavigation();
	cal19.showYearNavigationInput();
	cal19.showNavigationDropdowns();
</SCRIPT>

<table class="trails" cellspacing="0">
	<tr>
		<td width="100%">APICOLTURA > LISTA MOVIMENTAZIONI</td>
	</tr>
</table>
<br>


<%
if (request.getAttribute("Error")!=null)
{
	%>
	<font color="red">Errore durane l'accettazione: <%=request.getAttribute("Error")%></font>
	<%
}

%>

<%
	Date dataAttuale = (Date) request.getAttribute("dataAttuale");

	int columnCount = 0;
%>

<p>Attenzione! Si ricorda che l'effettivo cambio di consistenza
	degli apiari coinvolti nelle movimentazioni avviene a fine anno con il
	censimento.</p>
<table cellpadding="8" cellspacing="0" border="0" width="100%"
	class="pagedList">
	<tr>

		<th>TIPO MOVIMENTAZIONE</th>
		<th>Data Movimentazione</th>

		<th>AZIENDA ORIGINE</th>
		<th>PROG. APIARIO ORIGINE</th>
		<th>NUM ALVEARI ORIGINE</th>
		<th>AZIENDA DESTINAZIONE</th>
		<th>PROG. APIARIO /<br />SEDE LEGALE AZIENDA DESTINAZIONE
		</th>

		<th>MATERIALE MOVIMENTATO</th>
		<th>Stato Accettazione</th>
		<th>PROG. APIARIO DESTINAZIONE</th>
		<th>STATO SINCRONIZZAZIONE BDN</th>

	</tr>
	<%
		Iterator j = ListaMovimentazioni.iterator();
		if (j.hasNext()) {
	%>
	<BR>
	<br>
	<%
		int rowid = 0;
			int i = 0;
			while (j.hasNext()) {
				i++;
				rowid = (rowid != 1 ? 1 : 2);
				ModelloC thisMovimentazione = (ModelloC) j.next();
	%>

	<tr class="row<%=rowid%>">
		<td><%=LookupTipoMovimentazione.getSelectedValue(thisMovimentazione.getIdTipoMovimentazione())%></td>
		<td><%=toDateasString(thisMovimentazione.getDataMovimentazione())%></td>

		<td><%=thisMovimentazione.getCodiceAziendaOrigine()%></td>
		<td><%=(thisMovimentazione.getProgressivoApiarioOrigine()!=null)?(thisMovimentazione.getProgressivoApiarioOrigine()):("")%></td>
		<td><%=thisMovimentazione.getNumApiariOrigine()%></td>


		<td><%=(thisMovimentazione.getIdTipoMovimentazione() != 3) ? ("CODICE AZIENDA: " + thisMovimentazione
							.getCodiceAziendaDestinazione()) : ("CF: " + thisMovimentazione.getCfPartitaApicoltore()
							+ "<br/>" + "DENOMINAZIONE: " + thisMovimentazione.getDenominazioneApicoltore())%></td>
		<td><%=(thisMovimentazione.getIdTipoMovimentazione() != 3) ? ((thisMovimentazione.getProgressivoApiarioDestinazione()!=null)?(thisMovimentazione.getProgressivoApiarioDestinazione()):("")): (thisMovimentazione.getIndirizzo_dest() + ", " + thisMovimentazione.getComune_dest())%></td>
		<td><%="ALVEARI: " + thisMovimentazione.getNumAlveariDaSpostare() + "<br/>" + "SCIAMI: "
							+ thisMovimentazione.getNumSciamiDaSpostare() + "<br/>" + "PACCHI DI API: "
							+ thisMovimentazione.getNumPacchiDaSpostare() + "<br/>" + "API REGINE: "
							+ thisMovimentazione.getNumRegineDaSpostare() + "<br/>"%></td>

		<td><%=LookupStatoAccettazioneMovimentazione.getSelectedValue(thisMovimentazione.getAccettazioneDestinatario())%></td>

		<td>
			<%=(thisMovimentazione.getProgressivoApiarioDestinazione()!=null)?(thisMovimentazione.getProgressivoApiarioDestinazione()):("") %>
		</td>
		
		<td>
			<%=thisMovimentazione.isSincronizzato_bdn()==true ? "<img src=\"images/verde.gif\">" : "<img src=\"images/rosso.gif\">"%>
		</td>
	</tr>
	<%
		}
	%>
	<%
		} 
		else 
		{
	%>
	<br>
	<br>
	<tr class="containerBody">
		<td colspan="11">NON ESISTONO MOVIMENTAZIONI</td>
	</tr>
	<%
		}
	%>
</table>
<br />
<dhv:pagedListControl object="SearchMovimentazioniTutteListInfo" tdClass="row1" />