
<%@page import="ext.aspcfs.modules.apiari.base.StabilimentoVariazioneDetentore"%>
<%@page import="ext.aspcfs.modules.apiari.base.StabilimentoVariazioneCensimento"%>
<%@page import="ext.aspcfs.modules.apiari.base.StabilimentoVariazioneUbicazione"%>
<%@page import="org.apache.batik.css.engine.value.ListValue"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="ListaVariazioni" class="ext.aspcfs.modules.apiari.base.VariazioneDetentoreList" scope="request"/>
<jsp:useBean id="SearchVariazioniDetListInfo" class="org.aspcfs.utils.web.PagedListInfo" scope="session"/>
<jsp:useBean id="LookupTipoMovimentazione" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="StabilimentoDetails" class="ext.aspcfs.modules.apiari.base.Stabilimento" scope="request" />


<%@ include file="../initPage.jsp" %>


<table class="trails" cellspacing="0">
<tr>
<td width="100%">
APICOLTURA >
VARIAZIONI DETENTORE
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


<dhv:pagedListStatus title='<%= showError(request, "actionError") %>' object="SearchVariazioniDetListInfo"/>
<% int columnCount = 0; %>
<table cellpadding="8" cellspacing="0" border="0" width="100%" class="pagedList">
  <tr>
    
   <th>Data Variazione</th>
   <th>Nominativo</th>
   <th>Codice Fiscale</th>
    
  
   
  </tr>
<%
	Iterator j = ListaVariazioni.iterator();
	if ( j.hasNext() ) {
    int rowid = 0;
    int i = 0;
    while (j.hasNext()) {
    i++;
    rowid = (rowid != 1 ? 1 : 2);
    StabilimentoVariazioneDetentore thisMovimentazione = (StabilimentoVariazioneDetentore)j.next();
%>

  <tr class="row<%= rowid %>">
	<td><%=toDateasString(thisMovimentazione.getDataVariazione())%></td>
	<td><%=thisMovimentazione.getSoggettoFisico().getCognome()+" "+thisMovimentazione.getSoggettoFisico().getNome()%></td>
	<td><%=thisMovimentazione.getSoggettoFisico().getCodFiscale()%></td>
	
	
	
	
     
  </tr>
<%}%>
<%} else {%>
  <tr class="containerBody">
    <td colspan="7" >
      Nessun Detentore trovato con i parametri di ricerca specificati<br />
    </td>
  </tr>
<%}%>
</table>
<br />
<dhv:pagedListControl object="SearchVariazioniDetListInfo" tdClass="row1"/>
</dhv:container>