<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="ListaPratiche" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="StabilimentoDettaglio" class="org.aspcfs.modules.opu.base.Stabilimento" scope = "request"/>

<%@ page import="org.aspcfs.modules.gestioneanagrafica.base.*" %>
<%@ page import="org.aspcfs.modules.gestioneanagrafica.actions.*" %>
  
  <%@ include file="../initPage.jsp" %>
  
  <script>
  function openPopup(url){
	  window.open(url,'popupSelect',
	         'height=800px,width=1280px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');

		}
  </script>
  
  <%
String nomeContainer = "gestioneanagrafica";
request.setAttribute("Operatore",StabilimentoDettaglio.getOperatore());
String param = "altId="+StabilimentoDettaglio.getAltId();
%>

<dhv:container name="<%=nomeContainer %>"  selected="storicopratiche" object="Operatore" param="<%=param%>"  hideContainer="false">


<%-- Trails --%>
	<table class="trails" cellspacing="0">
	<tr>
		<td>
			<a href="OpuStab.do?command=SearchForm">ANAGRAFICA STABILIMENTI</a> > 
			<a href="GestioneAnagraficaAction.do?command=Details&altId=<%=StabilimentoDettaglio.getAltId()%>"> SCHEDA</a> > 
			Storico Pratiche amministrative
		</td>
	</tr>
	</table>
<%-- Trails --%>


<br>

<center>
<b>Lista pratiche</b><br/>
<i>In questa pagina sono elencate le ultime 100 pratiche eseguite su questo stabilimento.</i>
<br><br>
<table class="table details" id="tabella_pratiche" style="border-collapse: collapse" width="100%" cellpadding="5"> 
<tr>
<th style="text-align:center">Numero pratica</th>
<th style="text-align:center">comune</th>
<th style="text-align:center">data pec</th>
<th style="text-align:center">tipo pratica</th>
<th style="text-align:center">Utente</th> 
<th style="text-align:center">ALLEGATI</th> 
</tr>
<% int j=0; 
for ( int i = 0; i<ListaPratiche.size(); i++) {

	Pratica p = (Pratica) ListaPratiche.get(i);
	String tipoPratica = "";
	if(p.getStatoPratica() == 1){
	
	if (p.getIdTipologiaPratica() == GestioneAnagraficaAction.OP_NUOVO_STAB)
		tipoPratica="INSERIMENTO NUOVO STABILIMENTO"; 
	else if (p.getIdTipologiaPratica() == GestioneAnagraficaAction.OP_AMPLIAMENTO)
		tipoPratica="AMPLIAMENTO";
	else if (p.getIdTipologiaPratica() == GestioneAnagraficaAction.OP_CESSAZIONE)
		tipoPratica="CESSAZIONE";
	else if (p.getIdTipologiaPratica() == GestioneAnagraficaAction.OP_VARIAZIONE)
		tipoPratica="VARIAZIONE TITOLARITA";
	else if (p.getIdTipologiaPratica() == GestioneAnagraficaAction.OP_SOSPENSIONE)
		tipoPratica="SOSPENSIONE";
	else if (p.getIdTipologiaPratica() == GestioneAnagraficaAction.OP_MODIFICA_STATO_LUOGHI)
		tipoPratica="MODIFICA STATO DEI LUOGHI";
	else if (p.getIdTipologiaPratica() == GestioneAnagraficaAction.OP_MODIFICA_TRASFERIMENTO_SEDE)
		tipoPratica="TRASFERIMENTO SEDE";
	%>
<tr class="row<%=j%2%>">
<td align="center"><p><%=p.getNumeroPratica() %></p></td>

<td align="center"><%=p.getComuneRichiedente() %></td>
<td align="center"><%=toDateasString(p.getDataOperazione()) %></td>
<td align="center"><%=tipoPratica %></td>
<td align="center"> <dhv:username id="<%= p.getIdUtente() %>" /></td> 
<td align="center">
	<%String desc_operatore = "";
	if(p.getAltId() != -1){
		desc_operatore = "<hr>DATI IMPRESA E STABILIMENTO<br>" +
				  "<br><b>RAGIONE SOCIALE</b>: " + p.getRagioneSociale() + 
				  "<br><b>PARTITA IVA/CODICE FISCALE IMPRESA</b>: " + p.getPartitaIva() + 
				  "<br><b>NUMERO REGISTRAZIONE</b>: " + p.getNumeroRegistrazione() +
				  "<br><b>INDIRIZZO</b>: " + p.getIndirizzo();
	}
	%>
	<a style="text-decoration:none" 
	href='GestioneAllegatiGins.do?command=ListaAllegati&numeroPratica=<%=p.getNumeroPratica()%>&desc_operatore=<%=desc_operatore.replaceAll("'", " ")%>&alt_id=<%=p.getAltId()%>&stab_id=<%=p.getIdStabilimento()%>&idComunePratica=<%=p.getIdComuneRichiedente()%>'>
	
		<img src="gestione_documenti/images/archivio_icon.png" width="35" title="visualizza allegati"/>
	</a>&nbsp;&nbsp;
	
</td>
</tr>

<% j++;
	}
}
%>
</table>

  		
</dhv:container>
  		

  	
 