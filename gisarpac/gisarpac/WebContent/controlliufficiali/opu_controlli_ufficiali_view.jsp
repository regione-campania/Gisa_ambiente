
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.aspcfs.checklist.base.Audit"%>

<%@page import="java.util.ArrayList"%>
<%@page import="org.aspcfs.modules.login.beans.UserBean"%>
<%@page import="org.aspcfs.modules.oia.base.OiaNodo"%>
<%@page import="org.aspcf.modules.controlliufficiali.base.Piano"%>
<%@page import="org.aspcfs.modules.soa.base.LineaAttivitaSoa"%>
<%@page import="org.aspcfs.modules.lineeattivita.base.LineeAttivita"%>
<jsp:useBean id="BufferDetails" class="org.aspcfs.modules.buffer.base.Buffer" scope="request"/>


<jsp:useBean id="VerificaQuantitativo" class="org.aspcfs.utils.web.LookupList"
	scope="request" />	
<script
	type="text/javascript" src="dwr/interface/PopolaCombo.js"> </script>
	<jsp:useBean id="titoloNucleoTest" class="org.aspcfs.utils.web.LookupList" scope="request"/>
	
<link rel="stylesheet"
	href="http://code.jquery.com/ui/1.9.1/themes/base/jquery-ui.css" />
<script src="http://code.jquery.com/jquery-1.8.2.js"></script>
<script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>

<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>

<script>
function apriChecklist(){
	
	var idTipoChecklist = document.getElementById('accountSize').value;
	var idControllo = document.details.id.value;
	if(document.getElementById('accountSize').value=='-1'  ){
		alert('Selezionare il tipo di checklist.');
		return false;
		}
	
	if (confirm('Sei sicuro che la CheckList Selezionata sia quella corretta?')){
		window.open("ChecklistSorveglianza.do?command=View&idControllo="+idControllo+"&idTipoChecklist="+idTipoChecklist, 'popupChecklist',
        'height=800px,width=1280px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');

	}

}



</script>


<%
String errore = "";
errore = (String)request.getAttribute("Error");
%>
<% if (errore != null && (!errore.equalsIgnoreCase(""))) { %>
<script>
alert("<%=errore%>");
</script>

<% } %>

<input type="hidden" name="stabId" value="<%=TicketDetails.getIdStabilimento()%>">
<input type="hidden" name="idApiario" value="<%=TicketDetails.getIdApiario()%>">
<input type="hidden" name="idStabilimentoopu" value="<%=TicketDetails.getIdStabilimento()%>">



<tr>
	<th colspan="2">Scheda Controllo Ufficiale</th>
</tr>

<%String stato ="";
if (TicketDetails.getStatusId()==TicketDetails.STATO_APERTO)
	stato="<font color=\"green\">Aperto</font>";
else if (TicketDetails.getStatusId()==TicketDetails.STATO_CHIUSO)
	stato="<font color=\"red\">Chiuso</font>";
else if (TicketDetails.getStatusId()==TicketDetails.STATO_RIAPERTO)
	stato="<font color=\"orange\">Riaperto</font>";
else if (TicketDetails.getStatusId()==TicketDetails.STATO_ANNULLATO)
	stato="<font color=\"red\"><strike>Disattivato</strike></font>";
%>
<tr class="containerBody"><td class="formLabel">Stato Controllo</td><td><%=stato %></td></tr>



<tr class="containerBody">
	<td nowrap class="formLabel"><dhv:label name="stabilimenti.site">Site</dhv:label></td>
	<td><%=SiteIdList.getSelectedValue(TicketDetails.getSiteId())%> 
	<input type="hidden" name="siteId" value="<%=TicketDetails.getSiteId()%>"></td>
</tr>

 <tr class="containerBody">
      <td nowrap class="formLabel">
       Operatore Sottoposto a controllo
      </td>
      <td><%="<b>"+OrgDetails.getName()+"<b>" %> </h3></td>
    </tr>
<input type="hidden" name="id" id="id"
	value="<%=TicketDetails.getId()%>" />


<tr class="containerBody">
	<td class="formLabel"><dhv:label name="">Identificativo C.U.</dhv:label>
	</td>


	<td><%=toHtml(TicketDetails.getPaddedId())%> <input type="hidden"
		name="idControlloUfficiale" id="idControlloUfficiale"
		value="<%=TicketDetails.getPaddedId()%>" /> <input type="hidden"
		name="idC" id="idC" value="<%=TicketDetails.getPaddedId()%>" /></td>

</tr>

<%@ include file="../controlliufficiali/controlli_ufficiali_view_tipo.jsp" %>



<%


	if (TicketDetails.isCategoriaisAggiornata() == false && (View==null ||"".equals(View))) {
		if (TicketDetails.getClosed() == null) {
%>

<%
	if (TicketDetails.getTipoCampione() == 5) {

	 	UserBean entered = (UserBean) session
	 						.getAttribute("User");
	 				if (TicketDetails.getNumeroAudit() == 0) {
	 					
	 %>
	 
	 <tr class="containerBody">
		<td name="accountSize1" id="accountSize1" nowrap class="formLabel">
		<dhv:label name="osa.categoriaRischioo" />Scegli Tipo Check List</td>
		<td><%=OrgCategoriaRischioList.getHtmlSelect("accountSize", -1)%>
											
	<br>
		<%
		if(request.getAttribute("ChecklistError")!=null)
		{
		%>
		<font color = "red"><%=request.getAttribute("ChecklistError") %></font>
		<%	
		}
		%>
	 
	 <input type="button" value="Compila Checklist" name="CompilaChecklistPrincipale" onClick="apriChecklist()" /><%
			} 
		%>
		</td>
	</tr>
	<%
		String checklistInserite = "";
					Iterator<Audit> it = Audit.iterator();
					while (it.hasNext()) {
						Audit a = it.next();
						checklistInserite += a.getTipoChecklist() + ";";

					}
	%>
	<input type="hidden" name="checklist_inserite" id="checklist_inserite"
		value="<%=checklistInserite%>">
	<%
		}
%>

<%
	}
	}
%>

<%@ include file="../controlliufficiali/controlli_ufficiali_view_info.jsp" %>





























