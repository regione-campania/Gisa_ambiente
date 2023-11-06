
<%@page import="java.util.ArrayList"%>
<%@page import="org.aspcfs.modules.programmazzionecu.base.ProgrammazioneDettaglio"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>

<%@page import="org.aspcfs.utils.web.LookupElement"%><jsp:useBean id="MonitoraggioProgrammazioniCampioniInfo" class="org.aspcfs.utils.web.PagedListInfo" scope="session"/>
<jsp:useBean id="ListaCU" class="org.aspcfs.modules.programmazzionecu.base.ProgrammazioniDettaglioList" scope="request"/>
<jsp:useBean id="ListaPianiLookup" class="org.aspcfs.utils.web.LookupList" scope="request"/>

<br><br>
<%@ include file="../initPage.jsp" %>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/spanDisplay.js"></SCRIPT>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/confirmDelete.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popURL.js"></script>


<dhv:pagedListStatus title='<%= showError(request, "actionError") %>' object="MonitoraggioProgrammazioniCampioniInfo"/>

<table class="pagedList" cellpadding="4" cellspacing="0" border="0" width="100%" >

<thead>
<tr>

<th>Tipo Operatore</th>		
<th>Ragione Sociale</th>
<th>Asl</th>
<th>id CU</th>
<th>id Campione</th>

<th>Data Controllo</th>
<th>Piano Monitoraggio</th>
<th>Stato</th>
<th>Identificativo CU</th>
<th>Identificativo Campione</th>
<th>Numero Verbale</th>
<th>Data Referto</th>
<th>Codice Osa</th>
<th>Sede Oeprativa</th>
<th>Unita Operativa</th>
</tr>
</thead>
<tbody>
<%

Iterator it = ListaCU.iterator();
while (it.hasNext())
{
ProgrammazioneDettaglio det = (ProgrammazioneDettaglio) it.next();

LookupElement elem = ListaPianiLookup.getElement(det.getPiano());

%>


<tr>
<td > <%=toHtml(det.getTipo_operatore()) %></td>
<td> <%=toHtml(det.getRagione_sociale())  %></td>
<td> <%=toHtml(det.getAsl())%></td>
<td> <%=toHtml(det.getId_controllo()+"") %></td>
<td> <%=toHtml(det.getId_campione()+"") %></td>
<td> <%=toHtml(det.getDatacontrollo()) %></td>
<td> <%=toHtml(det.getPiano()) %></td>
<td><%=det.getStato()  %></td>
<td><%=det.getIdentificativo_cu() %></td>
<td><%=det.getIdentificativo_campione()  %></td>
<td><%=det.getNum_verbale()  %></td>
<td><%=det.getData_campione()  %></td>
<td> <%=toHtml(det.getCodice_osa()) %></td>
<td> <%=toHtml(det.getComune_so()) %></td>
<td> <%=toHtml(det.getUo()) %></td>
</tr>
<%	
}

%>
</tbody>

</table>
  <dhv:pagedListControl object="MonitoraggioProgrammazioniCampioniInfo"/>