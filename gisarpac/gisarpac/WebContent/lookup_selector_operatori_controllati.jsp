<%--Pagina JSP creata da Francesco --%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="java.util.*,org.aspcfs.modules.base.*,org.aspcfs.utils.web.*" %>
<%@ page import="org.aspcfs.utils.*" %>
<jsp:useBean id="BaseList" class="org.aspcfs.utils.web.CustomLookupList" scope="request"/>
<jsp:useBean id="SearchOrgListInfo" class="org.aspcfs.utils.web.PagedListInfo" scope="session"/>
<jsp:useBean id="SiteIdList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="LookupSelectorInfo" class="org.aspcfs.utils.web.PagedListInfo" scope="session"/>
<link type="text/css" href="css/ui.all.css" rel="stylesheet" />
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></script>
<script type="text/javascript">
function checkFiltro() {

    elementListView.submit();  

}
function clearR(){
	document.elementListView.searchcodeidAsl.value = "-1";
	document.elementListView.ragioneSociale.value = "";
}

</script>
<%@ include file="initPage.jsp" %>


<body style="overflow-y: scroll;" >
<%-- Trails --%>

<% 

String tipoA = (String)request.getParameter("tipoA");
String tipoI = (String)request.getParameter("tipoI");
String indiceImpresa = (String)request.getParameter("displayFieldId");
String siteId = (String)request.getParameter("idAsl");
String codAteco = (String)request.getParameter("codAteco");
%>


<center><strong>LISTA OPERATORI</strong></center>
<br/>
<br/>
<form name="elementListView" method="post" action="LookupSelector.do?command=PopupSelectorCustomPuntiSbarco&displayFieldId=<%= indiceImpresa%>" >
<input type = "hidden" name = "tipoA" value = "<%= tipoA %>">
<input type = "hidden" name = "tipoI" value = "<%= tipoI %>">
<input type = "hidden" name = "indiceImpresa" value = "<%= indiceImpresa %>">
<input type = "hidden" name = "cod_ateco" value = "<%= codAteco %>">
<br />
<table width="100%" border="0">
  <tr >
    <td>
<b>ASL&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b> 
      
<%
	int idAsl =-1;
	/*if(request.getAttribute("idAsl")!=null)
	{
		idAsl = Integer.parseInt((String)(request.getAttribute("idAsl")));
	}*/
	if(request.getAttribute("siteId")!=null)
	{
		idAsl = Integer.parseInt((String)(request.getAttribute("siteId")));
	}
	
%>
<%=SiteIdList.getHtmlSelect("searchcodeidAsl",BaseList.getIdAsl()) %>
</td>
    
  </tr>
  <tr >
  <td>
  <b>Ragione Sociale : </b> 
  <input type = "text" name = "searchAccountName" value = "<%=BaseList.getAccountName() %>">
  </td>
  </tr>
  
  <tr >
  <td>
  <%-- <b> CODICE ATECO : </b> 
  <select name="searchcodeAteco" value="-1" id="tipo" >
	  <option value="-1">-- SELEZIONA VOCE --</option>
	  <option value="03.11.00">03.11.00</option>
	  <option value="03.12.00">03.12.00</option>
	  <option value="03.21.00">03.21.00</option>
	  <option value="03.22.00">03.22.00</option>
  </select>
   --%>
  </td>
  </tr>
  
  <tr >
  <td>
  <b> Tipo Operatore : </b> 
  <input type="checkbox" name="searchAbusivo" value="abusivo"/>Abusivo&nbsp;
  <input type="checkbox" name="searchImpresa" value="imbarcazione"/>Imbarcazione&nbsp;
  </td>
  </tr>
  
  <tr >
    <td><input type="button" value="<dhv:label name="button.search">Search</dhv:label>" onClick="checkFiltro();">
    <input type="button" value="Pulisci" onClick="clearR()">
    
    <input type="button" value="Inserisci Operatore Abusivo" onClick="javascript:window.location.href='Abusivismi.do?command=Add&popup=true'" />
    
   
  </td></tr>
</table>

<br>

<dhv:pagedListStatus title='<%= showError(request, "actionError") %>' object="SearchOrgListInfo"/>
<% int columnCount = 0; %>


<table cellpadding="5" cellspacing="0" border="0" width="100%" class="pagedList">
  <tr>
    <th width="20%">
     Ragione Sociale
    </th>
     <th width="10">
      Tipo Operatore
    </th>
    <th width="10%">
      Asl
    </th>
     <th width="30%">
     	Num. reg
    </th>
      <th width="30%">
     	COMUNE 
    </th>
  </tr>

<%
  Iterator j = BaseList.iterator();
  if ( j.hasNext() ) {
    int rowid = 0;
    while (j.hasNext()) {
      rowid = (rowid != 1?1:2);
      CustomLookupElement thisElt = (CustomLookupElement)j.next();
     
    
      String ragioneSociale = thisElt.getValue("name");
      String citta = thisElt.getValue("city");
      String indirizzo = thisElt.getValue("addrline1");
      String prov = thisElt.getValue("state");
      String zip = thisElt.getValue("postalcode");
      String orgId = thisElt.getValue("org_id");
      String partitaIva = thisElt.getValue("partita_iva");
      String num_reg = thisElt.getValue("account_number");
      //String codice_ateco = "";
      String targa = thisElt.getValue("nome_correntista");
      
      if(targa != null && !targa.equals("")) {
    	  targa = thisElt.getValue("nome_correntista");
      }
      else {
    	  targa = "ND";  
      }
      
      
      if(num_reg != null && !num_reg.equals("")) {
    	  num_reg = thisElt.getValue("account_number");
      }
      else {
    	  num_reg = "ND";  
      }
      
      String aslDescr = thisElt.getValue("asldescr");
      String tipologia = thisElt.getValue("tipologia"); 
      if(tipologia.equals("17") || tipologia.equals("999")) {
    	   tipologia = "IMBARCAZIONE";
    	 //  codice_ateco = thisElt.getValue("codice");
      }
      else {
    	  tipologia = "ABUSIVO";
    	  //codice_ateco = "ND";  
      }
    	  
      
      //int code = codeString.startsWith("--") ? -1 : Integer.parseInt(codeString);
  %>
  <tr class="row<%= rowid %>">
    <td valign="center">
      <a href="javascript:setOperatoreField('<%= toHtml(ragioneSociale).replaceAll("'"," ").toUpperCase() %>' , '<%= toHtml(tipologia) %>','<%= toHtml(num_reg).replaceAll("'"," ").toUpperCase() %>','<%= toHtml(targa).replaceAll("'"," ").toUpperCase() %>','<%= toHtml(orgId) %>')">
        <%= toHtml(ragioneSociale) %>
      </a>
    </td>
    <td valign="center">
     <%= toHtml(tipologia) %>
    </td>
    <td valign="center">
     <%= toHtml(aslDescr)%>
    </td>
    <td valign="center">
    	<%= toHtml(num_reg) %>
    </td>
    <td valign="center">
    	<%= toHtml(citta) %>
    </td>
  </tr>
<%} }
  
 
else {%>
  <tr class="containerBody">
    <td colspan="<%= SearchOrgListInfo.getSearchOptionValue("searchcodeOrgSiteId").equals(String.valueOf(Constants.INVALID_SITE))?columnCount+1:columnCount %>">
      <dhv:label name="">No accounts found with the specified search parameters.</dhv:label><br />
      <a href="LookupSelector.do?command=PopupSelectorCustomPuntiSbarco&displayFieldId=<%= indiceImpresa%>"><dhv:label name="">Modifica Ricerca</dhv:label></a>.
    </td>
  </tr>
<%}%>
</table>
<br />
<dhv:pagedListControl object="SearchOrgListInfo" tdClass="row1"/>
</form></body>
<script type="text/javascript" >
function clear()
{
	alert('pulisci form');
//	document.elementListView.searchcodeidAsl.value = "-1";-->
//	document.elementListView.ragioneSociale.value = "";
}
</script>

