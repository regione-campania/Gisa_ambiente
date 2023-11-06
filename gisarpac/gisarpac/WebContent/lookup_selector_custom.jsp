<%--Pagina JSP creata da Francesco --%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="java.util.*,org.aspcfs.modules.base.*,org.aspcfs.utils.web.*" %>
<%@ page import="org.aspcfs.utils.*" %>
<jsp:useBean id="BaseList" class="org.aspcfs.utils.web.CustomLookupList" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="DisplayFieldId" class="java.lang.String" scope="request"/>
<jsp:useBean id="DisplayFieldId2" class="java.lang.String" scope="request"/>
<jsp:useBean id="Table" class="java.lang.String" scope="request"/>
<jsp:useBean id="FiltroDesc" class="java.lang.String" scope="request"/>
<jsp:useBean id="LookupSelectorInfo" class="org.aspcfs.utils.web.PagedListInfo" scope="session"/>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></script>
<script>
function checkFiltro() {
  //cancello eventuali spazi all'inizio e alla fine del testo
  var desc = leftTrim(rightTrim(document.elementListView.filtroDesc.value));
  document.elementListView.filtroDesc.value = desc;
  if (desc != ""){
    elementListView.submit();  
  } else {
    document.elementListView.filtroDesc.focus();  
  }
}

function leftTrim(stringa) {
  while (stringa.substring(0,1) == ' ') {
    stringa = stringa.substring(1, stringa.length);
  }
  return stringa;
}

function rightTrim(stringa) {
  while (stringa.substring(stringa.length-1, stringa.length) == ' ') {
    stringa = stringa.substring(0,stringa.length-1);
  }
  return stringa;
}

</script>
<%@ include file="initPage.jsp" %>
<body onload="javascript:document.elementListView.filtroDesc.focus()">
<form name="elementListView" method="post" action="LookupSelector.do?command=PopupSelectorCustom">
<br />

<table width="100%" border="0">
  <tr>
    <td>
    <%if(request.getAttribute("table")!=null)
    	{%>
    	<input type = "hidden" name = "table" value = "<%=request.getAttribute("table") %>">
    	<%} %>
      <b>Descrizione</b> <input type="text" size="20" name="filtroDesc" value="<%= FiltroDesc %>"/> <input type="button" value="<dhv:label name="button.search">Search</dhv:label>" onClick="checkFiltro();">
    </td>
  </tr>
</table>
<div style="height: 350px; overflow: auto;">
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="pagedList">
  <tr>
    <th width="20%">
      <dhv:label name="contact.option">Option</dhv:label>
    </th>
    <th width="80%">
      <dhv:label name="contact.Descrizione">Descrizione</dhv:label>
    </th>
  </tr>
  <%
  Iterator j = BaseList.iterator();
  if ( j.hasNext() ) {
    int rowid = 0;
    while (j.hasNext()) {
      rowid = (rowid != 1?1:2);
      CustomLookupElement thisElt = (CustomLookupElement)j.next();
      boolean enabled = thisElt.getValue("enabled") == "true" ? true : false;
      boolean defaultItem = thisElt.getValue("default_item") == "true" ? true : false;
      String description = thisElt.getValue("description");
      String shortDescription = thisElt.getValue("short_description");
      String codeString = thisElt.getValue("code");
      int code = codeString.startsWith("--") ? -1 : Integer.parseInt(codeString);
  %>
  <tr class="row<%= rowid %>">
    <td valign="center">
      <a href="javascript:setParentValue2('<%= DisplayFieldId %>','<%= StringUtils.jsStringEscape(description) %>','<%= DisplayFieldId2 %>','<%= StringUtils.jsStringEscape(shortDescription) %>');">
        <%= toHtml(description) %>
      </a>
    </td>
    <td valign="center">
      <%= toHtml(shortDescription) %>
    </td>
  </tr>
<%} } else {%>
      <tr class="containerBody">
        <td colspan="2">
          <dhv:label name="calendar.noOptionsAvailable.text">No options are available.</dhv:label>
        </td>
      </tr>
<%}%>
</table>
</div>
<input type="hidden" name="rowcount" value="0">
<input type="hidden" name="displayFieldId" value="<%= DisplayFieldId %>">
<input type="hidden" name="displayFieldId2" value="<%= DisplayFieldId2 %>">
<input type="hidden" name="table" value="<%= Table %>">
<input type="button" value="<dhv:label name="button.cancel">Cancel</dhv:label>" onClick="javascript:window.close()">
<br />
</form>
</body>
