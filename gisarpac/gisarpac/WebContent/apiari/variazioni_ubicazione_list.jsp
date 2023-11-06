
<%@page import="ext.aspcfs.modules.apiari.base.StabilimentoVariazioneUbicazione"%>
<%@page import="org.apache.batik.css.engine.value.ListValue"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="ListaVariazioni" class="ext.aspcfs.modules.apiari.base.VariazioneUbicazioneList" scope="request"/>
<jsp:useBean id="SearchVariazioniUbiListInfo" class="org.aspcfs.utils.web.PagedListInfo" scope="session"/>
<jsp:useBean id="LookupTipoMovimentazione" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="StabilimentoDetails" class="ext.aspcfs.modules.apiari.base.Stabilimento" scope="request" />


<%@ include file="../initPage.jsp" %>


<table class="trails" cellspacing="0">
<tr>
<td width="100%">
 APICOLTURA >
VARIAZIONI UBICAZIONE
</td>
</tr>
</table>
<br>

<%

String param = "stabId="+StabilimentoDetails.getIdStabilimento()+"&opId=" 
		+ StabilimentoDetails.getIdOperatore()+"&searchcodeidApiario="+StabilimentoDetails.getIdStabilimento()+"&searchcodeidAzienda="+StabilimentoDetails.getIdOperatore() +"&searchcodeCodiceAziendaSearch="+StabilimentoDetails.getOperatore().getCodiceAzienda()+"&searchcodeProgressivoApiarioSearch="+StabilimentoDetails.getProgressivoBDA() ;


%>

<dhv:container name="apiari" selected="Scheda"
	object="Operatore" param="<%=param%>" hideContainer="false">
<dhv:pagedListStatus title='<%= showError(request, "actionError") %>' object="SearchVariazioniUbiListInfo"/>
<% int columnCount = 0; %>
<table cellpadding="8" cellspacing="0" border="0" width="100%" class="pagedList">
  <tr>
    
   <th>DataVariazione</th>
   <th>Comune</th>
   <th>Provincia</th>
   <th>Indirizzo</th>
    
  
   
  </tr>
<%
	Iterator j = ListaVariazioni.iterator();
	if ( j.hasNext() ) {
    int rowid = 0;
    int i = 0;
    while (j.hasNext()) {
    i++;
    rowid = (rowid != 1 ? 1 : 2);
    StabilimentoVariazioneUbicazione thisMovimentazione = (StabilimentoVariazioneUbicazione)j.next();
%>

  <tr class="row<%= rowid %>">
	<td><%=toDateasString(thisMovimentazione.getDataVariazione())%></td>
	<td><%=thisMovimentazione.getIndirizzo().getDescrizioneComune()%></td>
	<td><%=thisMovimentazione.getIndirizzo().getDescrizione_provincia()%></td>
	<td><%=thisMovimentazione.getIndirizzo().getVia()%></td>
	
	
	
	
     
  </tr>
<%}%>
<%} else {%>
  <tr class="containerBody">
    <td colspan="7" >
      Nessuna Ubicazione trovato con i parametri di ricerca specificati<br />
    </td>
  </tr>
<%}%>
</table>
<br />
<dhv:pagedListControl object="SearchVariazioniUbiListInfo" tdClass="row1"/>
</dhv:container>