<%--Pagina JSP creata da Francesco --%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="java.util.*,org.aspcfs.modules.base.*,org.aspcfs.utils.web.*" %>
<%@ page import="org.aspcfs.utils.*" %>

<%@page import="org.aspcfs.modules.buffer.base.BufferList"%>
<%@page import="org.aspcfs.modules.buffer.base.Buffer"%>
<%@page import="org.aspcfs.modules.buffer.base.Comune"%><jsp:useBean id="BaseList" class="org.aspcfs.utils.web.CustomLookupList" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="DisplayFieldId" class="java.lang.String" scope="request"/>
<jsp:useBean id="DisplayFieldId2" class="java.lang.String" scope="request"/>
<jsp:useBean id="Table" class="java.lang.String" scope="request"/>
<jsp:useBean id="FiltroDesc" class="java.lang.String" scope="request"/>

<jsp:useBean id="FiltroDesc2" class="java.lang.String" scope="request"/>
<jsp:useBean id="FiltroDesc3" class="java.lang.String" scope="request"/>


<jsp:useBean id="LookupSelectorInfo" class="org.aspcfs.utils.web.PagedListInfo" scope="session"/>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></script>
<script>
function checkFiltro() {
  //cancello eventuali spazi all'inizio e alla fine del testo
  var desc = leftTrim(rightTrim(document.elementListView.filtroDesc.value));
 
  document.elementListView.filtroDesc.value = desc;
 //if (desc != "" || desc2!=""){
    elementListView.submit();  
  //} else {
    //document.elementListView.filtroDesc.focus();  
  //}
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
<form name="elementListView" method="post" action="LookupSelector.do?command=PopupSelectorBuffer">
<br />
<%-- <table width="100%" border="0">
  <tr>
    <td>
      <b>Identificativo</b> <input type="text" size="20" name="filtroDesc" value="<%= FiltroDesc %>"/> 
    </td>
     <td><input type="button" value="<dhv:label name="button.search">Search</dhv:label>" onClick="checkFiltro();">
    
  </tr>
</table>
--%>
<div style="height: 350px; overflow: auto;">
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="pagedList">
  <tr>
    <th width="20%">
      <dhv:label name="">Identificativo</dhv:label>
    </th>
    <th width="60%">
      <dhv:label name="contact.Descrizione">Descrizione</dhv:label>
    </th>
    <th width="10%">
      <dhv:label name="">Data</dhv:label>
    </th>
	 <th width="10%">
      <dhv:label name="">Comuni</dhv:label>
    </th>    
  </tr>
  <%
  Iterator j = BaseList.iterator();
  if ( j.hasNext() ) {
    int rowid = 0;
    while (j.hasNext()) {
      rowid = (rowid != 1?1:2);
      //CustomLookupElement thisElt = (CustomLookupElement)j.next();
      Buffer thisElt = (Buffer)j.next();

    
      String description = thisElt.getCodiceBuffer();
      String data = toDateString(thisElt.getDataEvento());
      String shortDescription = thisElt.getDescrizioneBreve();
      String id = Integer.toString(thisElt.getId());
      ArrayList<Comune> listaComuni = thisElt.getListaComuni();
      //String ticketid = thisElt.getValue("ticketid");
      //String unitaMisura = thisElt.getValue("unitamisura");
      //int code = codeString.startsWith("--") ? -1 : Integer.parseInt(codeString);
  %>
  <tr class="row<%= rowid %>">
    <td valign="center">
      <a href="javascript:setParentBuffer('<%= DisplayFieldId %>','<%= StringUtils.jsStringEscape(description.replaceAll("'"," ")) %>','<%= DisplayFieldId2 %>','<%= StringUtils.jsStringEscape(shortDescription).replaceAll("\"","").replaceAll("'"," ") %>','<%=id%>');">
        <%= toHtml(description) %>
      </a>
    </td>
    <td valign="center">
     <%= toHtml(shortDescription) %>
    </td>
     <td valign="center">
     <%= toHtml(data) %>
    </td>
    <td valign="center">
     <%
		for (Comune c : listaComuni)
		{
			out.println("- "+c.getDescrizione()+"<br>");
		}
		%> 
    </td>
  </tr>
<%} }
  
  else {%>
      <tr class="containerBody">
        <td colspan="4">
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
