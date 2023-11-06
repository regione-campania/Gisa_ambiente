
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,org.aspcfs.modules.campioni.base.*,org.aspcfs.modules.global_search.base.*, org.aspcfs.modules.base.*" %>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="OrgList" class="org.aspcfs.modules.global_search.base.OrganizationListView" scope="session"/>

<%@ include file="../initPage.jsp" %>
<%-- Initialize the drop-down menus --%>
<%@ include file="../initPopupMenu.jsp" %>

<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="CampioniReport.do?command=ViewOperatoriSin"><dhv:label name="">Associa Operatori al modello D</dhv:label></a> 
</td>
</tr>
</table>

<% int columnCount = 0; %>
<body onload="javascript: if(<%=request.getAttribute("redirect")!= null%>) alert('<%=request.getAttribute("redirect")%>');">
<form action="CampioniReport.do?command=SalvaOperatoriSin" method="post" name="visibilitasin" id="visibilitasin">

<table cellpadding="8" cellspacing="0" border="0" width="100%">
  <tr>
    
    <th <% ++columnCount; %>>
       <strong><dhv:label name="">Tipo di Operatore</dhv:label></strong>
    </th>
               
    <th <% ++columnCount; %>>
       <strong><dhv:label name="">Impresa</dhv:label></strong>
    </th>
        
    <th <% ++columnCount; %>>
       <strong><dhv:label name="">ASL</dhv:label></strong>
    </th>
	
	<th <% ++columnCount; %>>
       <strong><dhv:label name="">Visibilità SIN</dhv:label></strong>
    </th>
	
  </tr>
<%
	Iterator j = OrgList.iterator();
	if ( j.hasNext() ) {
    int rowid = 0;
    int i = 0;
    while (j.hasNext()) {
    i++;
    rowid = (rowid != 1 ? 1 : 2);
    OrganizationView thisOrg = (OrganizationView)j.next();
%>
  <tr class="row<%= rowid %>">

	<td nowrap>
      <%= thisOrg.getTipologia_operatore() %>
	</td>

	<td nowrap>
      <%= thisOrg.getName() %>&nbsp;
	</td>
	
	<td nowrap>
      <%= thisOrg.getAsl() %>&nbsp;
	</td>
	<td nowrap>
	
      <input type="radio" name="sin_<%=i%>" value="si" <%=(!thisOrg.getAlertText().equals("N.D") && (!thisOrg.getAlertText().equals(""))) ? ("checked=\"checked\"") : ("")%> >SI
	  <input type="radio" name="sin_<%=i%>" value="no" <%=(thisOrg.getAlertText().equals("N.D")) ? ("checked=\"checked\"") : ("")%> >NO
	</td>	
	
	<input type="hidden" name="org_id_<%=i%>" id="org_id_<%=i%>" value="<%=thisOrg.getOrgId()%>" />
	
  </tr>
  <%} %>
    <input type="hidden" name="size" id="size" value="<%=i%>" />
    <% } %> 
</table>
<input type="submit" value="Salva" name="salva"/>
</form>
</body>
<br/>


