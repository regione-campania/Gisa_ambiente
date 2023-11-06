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

<jsp:useBean id="OrgDetails" class="org.aspcfs.modules.opu.base.Stabilimento" scope="request"		/>
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

<table class="trails" cellspacing="0">
<tr>
<td width="100%">
     <dhv:label name=""><a href="<%="GestioneAnagraficaAction"+".do?command=SearchForm" %>" >Gestione Anagrafica Impresa </a>-><a  href="<%="GestioneAnagraficaAction"+".do?command=Details&stabId="+OrgDetails.getIdStabilimento()%>">Scheda Impresa</a> -><a href="<%="GestioneAnagraficaAction"+".do?command=ViewVigilanza&stabId="+OrgDetails.getIdStabilimento()%>"> Controlli Ufficiali </a>-> <a href="<%="GestioneAnagrafica"+"Vigilanza.do?command=TicketDetails&id="+TicketDetails.getIdControlloUfficiale()+"&idStabilimentoopu="+OrgDetails.getIdStabilimento()%>">Scheda controllo</a>->CheckList</dhv:label>

</td>
</tr>
</table>
<%-- End Trails --%>
<%
String container = "gestioneanagrafica";
request.setAttribute("Operatore",OrgDetails.getOperatore());
String param = "altId="+OrgDetails.getAltId();
%>
<dhv:container name="<%=container %>" selected="vigilanza" object="Operatore" param='<%= param%>'>

<form name="addAccountAudit"  method="post" action="<%="GestioneAnagrafica" %>CheckList.do?command=Update&auto-populate=true" onSubmit="return checkForm();" >





  <input type="button" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="window.location.href='<%="GestioneAnagrafica" %>Vigilanza.do?command=TicketDetails&id=<%= request.getAttribute("idCon")%>&altId=<%=OrgDetails.getAltId()%>';this.form.dosubmit.value='false';" />


<%@ include file="../checklist/anagrafica_checklist_modify.jsp" %>



  <input type="button" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="window.location.href='<%="GestioneAnagrafica" %>Vigilanza.do?command=TicketDetails&id=<%= request.getAttribute("idCon")%>&altId=<%=OrgDetails.getAltId()%>';this.form.dosubmit.value='false';" />


</form>
</dhv:container>
</body>
<script>

if(document.getElementById("btnSaveTemp")!=null)
document.getElementById("btnSaveTemp").disabled="";
document.getElementById("btnSave2").disabled="";
document.getElementById("btnSave").disabled="";
</script>