<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<%@page import="org.aspcfs.utils.web.*"%>
<%@page import="org.aspcfs.checklist.base.AuditChecklistType"%>
<%@page import="org.aspcfs.checklist.base.AuditChecklist"%>
<%@page import="org.aspcfs.modules.allevamenti.base.Organization"%>
<%@page import="com.darkhorseventures.framework.actions.ActionContext"%>


<jsp:useBean id="applicationPrefs" class="org.aspcfs.controller.ApplicationPrefs" scope="application"/>
<jsp:useBean id="checklistList" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="auditChecklist" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="TicketDetails" class="org.aspcfs.modules.vigilanza.base.Ticket" scope="request"/>
<jsp:useBean id="AuditDetails" class="org.aspcfs.checklist.base.Audit" scope="request"/>
<jsp:useBean id="auditChecklistType" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="typeList" class="org.aspcfs.utils.web.CustomLookupList" scope="request"/>
<jsp:useBean id="OrgDetails" class="org.aspcfs.modules.allevamenti.base.Organization" scope="request"/>
<jsp:useBean id="Audit" class="org.aspcfs.checklist.base.Audit" scope="request"/>
<jsp:useBean id="OrgCategoriaRischioList" class="org.aspcfs.utils.web.LookupList" scope="request"/>

<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popCalendar.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/spanDisplay.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/confirmDelete.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popURL.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/div.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/checkDate.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/checkNumber.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/checklist_controlli.js"></script>

<%@ include file="../initPage.jsp" %>

<link rel="stylesheet" type="text/css" href="css/cssDomanda.css" >

<form name="viewAccountAudit" action="CheckListAllevamenti.do?command=Modify&auto-populate=true&id=<%=Audit.getId()%>&return=details<%= addLinkParams(request, "popup|popupType|actionId") %>" method="post">
<input type="hidden" name="id" value="<%=Audit.getId() %>">
<input type="hidden" name="orgId" value="<%=OrgDetails.getId() %>">
<dhv:evaluate if="<%= !isPopup(request) %>">
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td width="100%">
  <a href="Allevamenti.do"><dhv:label name="">Allevamenti</dhv:label></a> >
  <a href="Allevamenti.do?command=Search"><dhv:label name="accounts.SearchResults">Search Results</dhv:label></a> >
  <a href="Allevamenti.do?command=Details&orgId=<%= OrgDetails.getOrgId() %>">Scheda Allevamento</a> >
  <a href="Allevamenti.do?command=ViewVigilanza&orgId=<%=OrgDetails.getOrgId()%>"><dhv:label name="">Controlli Ufficiali</dhv:label></a> >
      <a href="AllevamentiVigilanza.do?command=TicketDetails&id=<%= request.getAttribute("idC")%>&orgId=<%=OrgDetails.getOrgId()%>"><dhv:label name="">Controllo Ufficiale</dhv:label></a> >
  
  <%--a href="AccountsAuditAllev.do?command=List&orgId=<%= OrgDetails.getOrgId() %>"><dhv:label name="audit">Check List</dhv:label></a> --%>
  <dhv:label name="audit.dettaglioAudit">Scheda Check List</dhv:label>
</td>
</tr>
</table>
<dhv:permission name="allevamenti-allevamenti-report-view">
  <table width="100%" border="0">
    <tr>
       <td nowrap align="right">
        <img src="images/icons/stock_print-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        <%--<a href="Allevamenti.do?command=PrintReport&id=<%= OrgDetails.getId() %>"><dhv:label name="accounts.osa.print">Stampa Scheda Audit</dhv:label></a>--%>
          
          <%--
          if( Audit.getLivelloRischioFinale() == -1 ){ %>
          
         <input type="button" value="Stampa Scheda Check List Provvisorio"	onClick='javascript:location.href="CheckListAllevamenti.do?command=Stampa&id=<%= Audit.getId() %>";'>
      <%
    }
    else {
    %>
        <input type="button" value="Stampa Scheda Check List"	onClick='javascript:location.href= "CheckListAllevamenti.do?command=Stampa&id=<%= Audit.getId() %>";'>
    <%	
    }
    --%>
       <%@ include file="../checklistdocumenti/checklist_stampa.jsp" %> 
      </td>
    </tr>
  </table>
</dhv:permission>
<%-- End Trails --%>
</dhv:evaluate>


<dhv:container name="allevamenti" selected="vigilanza" object="OrgDetails" param='<%= "orgId=" + OrgDetails.getOrgId() %>'>

<%if(TicketDetails.isCategoriaisAggiornata()==false)
{
	
	%>
<dhv:evaluate if="<%= !OrgDetails.isTrashed() %>">
  <input type="hidden" name="idC" value="<%=Audit.getIdControllo() %>">

     <dhv:permission name="allevamenti-allevamenti-audit-edit"><input type="submit" value="<dhv:label name="global.button.modify">Modify</dhv:label>"></dhv:permission>
   
    <input type="hidden" name="idC" value="<%=Audit.getIdControllo() %>">
 
  </dhv:evaluate>
  <%} %>
<br/>
<br/>

<%@ include file="../checklist/checklist_view.jsp" %>


  <%if(TicketDetails.isCategoriaisAggiornata()==false){ 
  %>
  <dhv:evaluate if="<%= !OrgDetails.isTrashed() %>">
     
    <dhv:permission name="allevamenti-allevamenti-audit-edit"><input type="submit" value="<dhv:label name="global.button.modify">Modify</dhv:label>"></dhv:permission>
  
    
  </dhv:evaluate><%
  } %>


</dhv:container>


</form>
