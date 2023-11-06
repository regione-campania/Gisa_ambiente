<%@ page import="java.util.*,org.aspcfs.modules.checklist_sorveglianza.base.*" %>
<jsp:useBean id="listaChecklistSorveglianza" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="tipologiaChecklistList" class="org.aspcfs.utils.web.LookupList" scope="request"/>

<script>
function apriChecklist(idIstanza){
	window.open("ChecklistSorveglianza.do?command=View&idIstanza="+idIstanza, 'popupChecklist',
        'height=800px,width=1280px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
}


</script>

<% if (listaChecklistSorveglianza.size()>0) { %>

<table class="details" cellpadding="4" cellspacing="0" width="100%">
<tr><th>NOME CHECKLIST</th> <th>Stato</th> <th>Punteggio</th> <th>Categoria di rischio</th></tr>

<% for (int i = 0; i<listaChecklistSorveglianza.size(); i++) {
Istanza ist = (Istanza) listaChecklistSorveglianza.get(i);%>
<tr>
<td><a href="#" onClick="apriChecklist('<%=ist.getId()%>')"><%=tipologiaChecklistList.getSelectedValue(ist.getIdTipoChecklist()) %></a></td>
<td><%=ist.isBozza() ? "TEMPORANEA" : "DEFINITIVA" %></td>
<td><%=ist.getPunteggioTotale() %></td>
<td><%=(!ist.isBozza() && ist.getCategoriaRischioQualitativa()!=null )? ist.getCategoriaRischioQualitativa() : "" %></td>
</tr>
<% } %>
</table>
<br/>
<% } %>