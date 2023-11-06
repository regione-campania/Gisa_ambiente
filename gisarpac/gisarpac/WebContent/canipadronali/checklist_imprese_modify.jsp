<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<%@page import="org.aspcfs.utils.web.*"									%>
<%@page import="org.aspcfs.checklist.base.*"							%>
<%@page import="com.darkhorseventures.framework.actions.ActionContext"	%>

<jsp:useBean id="applicationPrefs" class="org.aspcfs.controller.ApplicationPrefs" scope="application"	/>
<jsp:useBean id="checklistList" class="java.util.ArrayList" scope="request"								/>
<jsp:useBean id="auditChecklist" class="java.util.ArrayList" scope="request"							/>
<jsp:useBean id="auditChecklistType" class="java.util.ArrayList" scope="request"						/>
<jsp:useBean id="ControlloUfficiale" class="org.aspcfs.modules.vigilanza.base.Ticket" scope="request"	/>
<jsp:useBean id="TicketDetails" class="org.aspcfs.modules.vigilanza.base.Ticket" scope="request"		/>
<jsp:useBean id="typeList" class="org.aspcfs.utils.web.CustomLookupList" scope="request"				/>
<jsp:useBean id="OrgDetails" class="org.aspcfs.modules.canipadronali.base.Proprietario" scope="request"		/>
<jsp:useBean id="Audit" class="org.aspcfs.checklist.base.Audit" scope="request"						/>
<jsp:useBean id="OrgCategoriaRischioList" class="org.aspcfs.utils.web.LookupList" scope="request"		/>

<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popCalendar.js">		</script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js">	</script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/spanDisplay.js">		</script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/div.js">				</script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/checkDate.js">			</script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/checkNumber.js">		</script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/checklist_controlli_modify.js"></script>

<%@ include file="../initPage.jsp" %>

<link rel="stylesheet" type="text/css" href="css/checklist.css" >
<link rel="stylesheet" type="text/css" href="css/cssDomanda.css" >

<body onload="ultimaDomanda(<%=Audit.getIdLastDomanda() %>);inizializzaPunteggio(<%=Audit.getLivelloRischio() %>);aggiornaCategoria();">
<form name="addAccountAudit"  method="post" action="CheckListCaniPadronali.do?command=Update&auto-populate=true&return<%= request.getParameter("return") %>" onSubmit="return checkForm();">
<table class="trails" cellspacing="0">
<tr>
<td width="100%">

  <a href="CaniPadronali.do=command=SearchForm">Anagrafica Cani di proprieta</a> > 
  <a href="CaniPadronali.do=command=Detail&orgId=<%=OrgDetails.getOrgId() %>">Scheda Anagrafica Cani di proprieta</a> > 

  <%--<a href="CaniPadronali.do=command=Detail&orgId=<%=OrgDetails.getOrgId() %>">Scheda Cane Padronale</a> > --%>

  <a href="CaniPadronaliVigilanza.do?command=TicketDetails&id=<%= request.getAttribute("idC")%>&orgId=<%=OrgDetails.getOrgId()%>"><dhv:label name="">Controllo Ufficiale</dhv:label></a> >
  <dhv:label name="audit.aggiungiAudit">Check List</dhv:label>
</td>
</tr>
</table>

<dhv:container name="canipadronali" selected="vigilanza" object="OrgDetails" param='<%= "orgId=" + OrgDetails.getOrgId()%>' >


  <input type="button" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="window.location.href='CaniPadronaliVigilanza.do?command=TicketDetails&id=<%= request.getAttribute("idCon")%>&orgId=<%=OrgDetails.getOrgId()%>';this.form.dosubmit.value='false';" />

<br/>
<br/>


<%@ include file="../checklist/checklist_modify.jsp" %>



  <input type="button" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="window.location.href='CaniPadronaliVigilanza.do?command=TicketDetails&id=<%= request.getAttribute("idCon")%>&orgId=<%=OrgDetails.getOrgId()%>';this.form.dosubmit.value='false';" />

</dhv:container>
</form>
</body>
<script>

if(document.getElementById("btnSaveTemp")!=null)
document.getElementById("btnSaveTemp").disabled="";
document.getElementById("btnSave2").disabled="";
document.getElementById("btnSave").disabled="";
</script>
