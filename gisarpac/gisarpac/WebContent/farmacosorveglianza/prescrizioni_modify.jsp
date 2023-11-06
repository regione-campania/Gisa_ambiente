<%-- 
  - Copyright(c) 2004 Dark Horse Ventures LLC (http://www.centriccrm.com/) All
  - rights reserved. This material cannot be distributed without written
  - permission from Dark Horse Ventures LLC. Permission to use, copy, and modify
  - this material for internal use is hereby granted, provided that the above
  - copyright notice and this permission notice appear in all copies. DARK HORSE
  - VENTURES LLC MAKES NO REPRESENTATIONS AND EXTENDS NO WARRANTIES, EXPRESS OR
  - IMPLIED, WITH RESPECT TO THE SOFTWARE, INCLUDING, BUT NOT LIMITED TO, THE
  - IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY PARTICULAR
  - PURPOSE, AND THE WARRANTY AGAINST INFRINGEMENT OF PATENTS OR OTHER
  - INTELLECTUAL PROPERTY RIGHTS. THE SOFTWARE IS PROVIDED "AS IS", AND IN NO
  - EVENT SHALL DARK HORSE VENTURES LLC OR ANY OF ITS AFFILIATES BE LIABLE FOR
  - ANY DAMAGES, INCLUDING ANY LOST PROFITS OR OTHER INCIDENTAL OR CONSEQUENTIAL
  - DAMAGES RELATING TO THE SOFTWARE.
  - 
  - Version: $Id: accounts_modify.jsp 19046 2007-02-07 18:53:43Z matt $
  - Description:
  --%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,java.text.DateFormat,org.aspcfs.modules.farmacosorveglianza.base.*,org.aspcfs.controller.SystemStatus"%>
<%@ page import="org.aspcfs.controller.*,org.aspcfs.utils.*,org.aspcfs.utils.web.*,org.aspcfs.modules.contacts.base.*" %>
<%@page import="org.aspcfs.modules.allevamenti.base.Organization"%><jsp:useBean id="AccountTypeList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="OrgDetails" class="org.aspcfs.modules.farmacosorveglianza.base.Prescrizioni" scope="request"/>
<jsp:useBean id="StateSelect" class="org.aspcfs.utils.web.StateSelect" scope="request"/>
<jsp:useBean id="CountrySelect" class="org.aspcfs.utils.web.CountrySelect" scope="request"/>
<jsp:useBean id="AccountSizeList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SiteList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TicketDetails" class="org.aspcfs.modules.allevamenti.base.Organization" scope="request"/>
<jsp:useBean id="FarmaciList" class="org.aspcfs.modules.farmacosorveglianza.base.FarmaciList" scope="request"/>
<jsp:useBean id="FarmacieList" class="org.aspcfs.modules.farmacosorveglianza.base.FarmacieList" scope="request"/>
<jsp:useBean id="VeterinariList" class="org.aspcfs.modules.farmacosorveglianza.base.VeterinariList" scope="request"/>
<jsp:useBean id="OrganizationList" class="org.aspcfs.modules.allevamenti.base.OrganizationList" scope="request"/>
<jsp:useBean id="SourceList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="idConfezione" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="idTiposomministrazione" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="StageList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoStruttura" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TitoloList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipologiaList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="RatingList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="IndustryList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="OrgAddressTypeList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="OrgEmailTypeList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="contactList" class="org.aspcfs.modules.contacts.base.ContactList" scope="request"/>
<jsp:useBean id="ContactAddressTypeList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="OrgCategoriaRischioList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ContactEmailTypeList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ContactDetails" class="org.aspcfs.modules.contacts.base.Contact" scope="request"/>
<jsp:useBean id="OrgPhoneTypeList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ContactPhoneTypeList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="UserList" class="org.aspcfs.modules.admin.base.UserList" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="SegmentList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SICCodeList" class="org.aspcfs.modules.admin.base.SICCodeList" scope="request"/>
<jsp:useBean id="systemStatus" class="org.aspcfs.controller.SystemStatus" scope="request"/>
<jsp:useBean id="SalutationList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="applicationPrefs" class="org.aspcfs.controller.ApplicationPrefs" scope="application"/>
<jsp:useBean id="TimeZoneSelect" class="org.aspcfs.utils.web.HtmlSelectTimeZone" scope="request"/>
<%@ include file="../initPage.jsp" %>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/checkDate.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/checkString.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/checkPhone.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/checkNumber.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/checkEmail.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/checkNumber.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popCalendar.js"></script>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/spanDisplay.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/confirmDelete.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/checkURL.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/setSalutation.js"></script>
<script language="JavaScript">
  indSelected = 0;
  orgSelected = 1; 
  
function doCheck(form) {
	  
      if (form.dosubmit.value == "false") {
      return true;
    } else {
      return(checkForm(form));
    }
  }
  
function checkForm(form) {
    var formTest = true;
    var formTest2 = true; 
    message = "";
    alertMessage = "";
    	
    
   	 if (formTest && formTest2){
   		 var test = document.addAccount.selectedList;
	     if (test != null) {
	       selectAllOptions(document.addAccount.selectedList);
	     }
	     if(alertMessage != "") {
	       confirmAction(alertMessage);
	     }
	     return true;
   	   	
  }else {
   	    alert(label("check.form", "Form could not be saved, please check the following:\r\n\r\n") + message);
   	    return false;
   	 }     	 
  }

  function resetFormElements() {
    if (document.getElementById) {
      elm1 = document.getElementById("nameFirst1");
      elm2 = document.getElementById("nameMiddle1");
      elm3 = document.getElementById("nameLast1");
      elm4 = document.getElementById("orgname1");
      elm5 = document.getElementById("ticker1");
      elm6 = document.getElementById("accountSize1");
      elm7 = document.getElementById("listSalutation1");
      elm8 = document.getElementById("primarycontact1");
      if (elm1) {
        elm1.style.color = "#000000";
        document.addAccount.nameFirst.style.background = "#ffffff";
        document.addAccount.nameFirst.disabled = false;
      }
      if (elm2) {
        elm2.style.color = "#000000";
        document.addAccount.nameMiddle.style.background = "#ffffff";
        document.addAccount.nameMiddle.disabled = false;
      }
      if (elm3) {
        elm3.style.color = "#000000";
        document.addAccount.nameLast.style.background = "#ffffff";
        document.addAccount.nameLast.disabled = false;
      }
      if (elm4) {
        elm4.style.color = "#000000";
        document.addAccount.name.style.background = "#ffffff";
        document.addAccount.name.disabled = false;
      }
      if (elm5) {
        elm5.style.color = "#000000";
        document.addAccount.ticker.style.background = "#ffffff";
        document.addAccount.ticker.disabled = false;
      }
      if (elm6) {
        elm6.style.color = "#000000";
        document.addAccount.accountSize.style.background = "#ffffff";
        document.addAccount.accountSize.disabled = false;
      }
      if (elm7) {
        elm7.style.color = "#000000";
        document.addAccount.listSalutation.style.background = "#ffffff";
        document.addAccount.listSalutation.disabled = false;
      }
      if (elm8) {
        elm8.style.color = "#000000";
        document.addAccount.primaryContactId.style.background = "#ffffff";
        document.addAccount.primaryContactId.disabled = false;
      }
    }
  }
  function updateFormElements(index) {
    if (document.getElementById) {
      <dhv:include name="accounts-firstname" none="true">
        elm1 = document.getElementById("nameFirst1");
      </dhv:include>
      <dhv:include name="accounts-middlename" none="true">
        elm2 = document.getElementById("nameMiddle1");
      </dhv:include>
      <dhv:include name="accounts-lastname" none="true">
        elm3 = document.getElementById("nameLast1");
      </dhv:include>
      elm4 = document.getElementById("orgname1");
      elm5 = document.getElementById("ticker1");
      elm6 = document.getElementById("accountSize1");
      elm7 = document.getElementById("listSalutation1");
      elm8 = document.getElementById("primarycontact1");
      if (index == 1) {
        indSelected = 1;
        orgSelected = 0;        
        resetFormElements();
        if (elm4) {
          elm4.style.color="#cccccc";
          document.addAccount.name.style.background = "#cccccc";
          document.addAccount.name.value = "";
          document.addAccount.name.disabled = true;
        }
        if (elm5) {
          elm5.style.color="#cccccc";
          document.addAccount.ticker.style.background = "#cccccc";
          document.addAccount.ticker.value = "";
          document.addAccount.ticker.disabled = true;
        }
        if (elm6) {
          elm6.style.color="#cccccc";
          document.addAccount.accountSize.style.background = "#cccccc";
          document.addAccount.accountSize.value = "";
          document.addAccount.accountSize.disabled = true;
        }
      } else {
        indSelected = 0;
        orgSelected = 1;
        resetFormElements();
        if (elm1) {
          elm1.style.color = "#cccccc";
          document.addAccount.nameFirst.style.background = "#cccccc";
          document.addAccount.nameFirst.value = "";
          document.addAccount.nameFirst.disabled = true;
        }
        if (elm2) {
          elm2.style.color = "#cccccc";  
          document.addAccount.nameMiddle.style.background = "#cccccc";
          document.addAccount.nameMiddle.value = "";
          document.addAccount.nameMiddle.disabled = true;
        }
        if (elm3) {
          elm3.style.color = "#cccccc";      
          document.addAccount.nameLast.style.background = "#cccccc";
          document.addAccount.nameLast.value = "";
          document.addAccount.nameLast.disabled = true;
        }
        if (elm7) {
          elm7.style.color = "#cccccc";
          document.addAccount.listSalutation.style.background = "#cccccc";
          document.addAccount.listSalutation.value = -1;     
          document.addAccount.listSalutation.disabled = true;
        }
        if (elm8) {
          elm8.style.color = "#cccccc";
          document.addAccount.primaryContactId.style.background = "#cccccc";
          document.addAccount.primaryContactId.selectedIndex = 0;
          document.addAccount.primaryContactId.disabled = true;
        }
      }
    }
  }
  //-------------------------------------------------------------------
  // getElementIndex(input_object)
  //   Pass an input object, returns index in form.elements[] for the object
  //   Returns -1 if error
  //-------------------------------------------------------------------
  function getElementIndex(obj) {
    var theform = obj.form;
    for (var i=0; i<theform.elements.length; i++) {
      if (obj.name == theform.elements[i].name) {
        return i;
      }
    }
    return -1;
  }
  // -------------------------------------------------------------------
  // tabNext(input_object)
  //   Pass an form input object. Will focus() the next field in the form
  //   after the passed element.
  //   a) Will not focus to hidden or disabled fields
  //   b) If end of form is reached, it will loop to beginning
  //   c) If it loops through and reaches the original field again without
  //      finding a valid field to focus, it stops
  // -------------------------------------------------------------------
  function tabNext(obj) {
    if (navigator.platform.toUpperCase().indexOf("SUNOS") != -1) {
      obj.blur(); return; // Sun's onFocus() is messed up
      }
    var theform = obj.form;
    var i = getElementIndex(obj);
    var j=i+1;
    if (j >= theform.elements.length) { j=0; }
    if (i == -1) { return; }
    while (j != i) {
      if ((theform.elements[j].type!="hidden") && 
          (theform.elements[j].name != theform.elements[i].name) && 
        (!theform.elements[j].disabled)) {
        theform.elements[j].focus();
        break;
        }
      j++;
      if (j >= theform.elements.length) { j=0; }
    }
  } 
  
   
  function update(countryObj, stateObj, selectedValue) {
    var country = document.forms['addAccount'].elements[countryObj].value;
    var url = "ExternalContacts.do?command=States&country="+country+"&obj="+stateObj+"&selected="+selectedValue+"&form=addAccount&stateObj=address"+stateObj+"state";
    window.frames['server_commands'].location.href=url;
  }

  function continueUpdateState(stateObj, showText) {
    if(showText == 'true'){
      hideSpan('state1' + stateObj);
      showSpan('state2' + stateObj);
    } else {
      hideSpan('state2' + stateObj);
      showSpan('state1' + stateObj);
    }
  }

  function updateOwnerList(){
    var sel = document.forms['addAccount'].elements['siteId'];
    var value = sel.options[sel.selectedIndex].value;
    var url = "Requestor.do?command=OwnerJSList&form=addAccount&widget=owner&allowBlank=false&siteId=" + escape(value);
    window.frames['server_commands'].location.href=url;
  }
  
  function selectCarattere(){
  
 		elm1 = document.getElementById("data1");
 		elm2 = document.getElementById("data2");
 		elm3 = document.getElementById("data3");
 		elm4 = document.getElementById("data4");
 		elm5 = document.getElementById("cessazione");
 		car = document.addAccount.source.value;
 	
 		if(car == 1){
 			elm1.style.visibility = "visible";
 			elm2.style.visibility = "visible";
 			elm3.style.visibility = "visible";
 			elm4.style.visibility = "visible";
 			elm5.style.visibility = "visible";
 			
 		}
 		else {
 			elm1.style.visibility = "hidden";
 			elm2.style.visibility = "hidden";
 			elm3.style.visibility = "hidden";
 			elm4.style.visibility = "hidden";
 			elm5.style.visibility = "hidden";
 			document.forms['addAccount'].dateI.value = ""; 
 			document.forms['addAccount'].dateF.value = ""; 
 			document.forms['addAccount'].cessazione.checked = "true";
 		}
 	
  }
</script>
<body >
<form name="addAccount" action="FarmacosorveglianzaPre.do?command=UpdatePre&idPrescrizione=<%= OrgDetails.getIdPrescrizione() %>&auto-populate=true<%= (request.getParameter("popup") != null?"&popup=true":"") %>" onSubmit="return doCheck(this);" method="post">
<%
  boolean popUp = false;
  if(request.getParameter("popup")!=null){
    popUp = true;
  }
%>
<dhv:evaluate if="<%= !popUp %>">
<%-- Trails --%>
<table class="trails" cellspacing="0" class="details">
<tr>
<td>
<a href="FarmacosorveglianzaPre.do?command=SearchFormPre"><dhv:label name="">Prescrizioni</dhv:label></a> > 
<%-- if (request.getParameter("return") != null) {%>
	<% if (request.getParameter("return").equals("list")) {%>
	<a href="FarmacosorveglianzaPre.do?command=SearchFar"><dhv:label name="accounts.SearchResults">Search Results</dhv:label></a> >
	<%} else if (request.getParameter("return").equals("dashboard")) {%>
	<a href="FarmacosorveglianzaPre.do?command=DashboardFar"><dhv:label name="communications.campaign.Dashboard">Dashboard</dhv:label></a> >
	<%}%>
<%} else {%>
<a href="FarmacosorveglianzaPre.do?command=SearchFar"><dhv:label name="accounts.SearchResults">Search Results</dhv:label></a> >--%>
<a href="FarmacosorveglianzaPre.do?command=DetailsPre&idPrescrizione=<%=OrgDetails.getIdFarmacia()%>"><dhv:label name="">Scheda Prescrizione</dhv:label></a> >
<%--}--%>
<dhv:label name="accountsc.modify">Modifica Informazioni Prescrizione</dhv:label>
</td>
</tr>
</table>
<%-- End Trails --%>
</dhv:evaluate>
<dhv:container name="farmacosorveglianza" selected="details" object="OrgDetails" param='<%= "idPrescrizione=" + OrgDetails.getIdPrescrizione() %>' appendToUrl='<%= addLinkParams(request, "popup|popupType|actionId") %>'>
      <input type="hidden" name="modified" value="<%= OrgDetails.getModified() %>">
<% if (request.getParameter("return") != null) {%>
      <input type="hidden" name="return" value="<%=request.getParameter("return")%>">
<%}%>
<input type="submit" value="<dhv:label name="global.button.update">Update</dhv:label>" name="Save" onClick="this.form.dosubmit.value='true';" />
<% if (request.getParameter("return") != null && "list".equals(request.getParameter("return"))) {%>
  <input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.action='FarmacosorveglianzaPre.do?command=DetailsPre&idPrescrizione=<%= OrgDetails.getIdPrescrizione() %>';this.form.dosubmit.value='false';" />
<% } else if (isPopup(request)) { %>
  <input type="button" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onclick="javascript:window.close();" />
<% } else { %>
  <input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.action='FarmacosorveglianzaPre.do?command=DetailsPre&idPrescrizione=<%= OrgDetails.getIdPrescrizione() %>';this.form.dosubmit.value='false';" />
<% } %>
<br />
<dhv:formMessage />
<iframe src="empty.html" name="server_commands" id="server_commands" style="visibility:hidden" height="0"></iframe>
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
      <strong><dhv:label name="accounts.accounts_modify.ModifyPrimaryInformation">Modify Primary Information</dhv:label></strong>
    </th>     
  </tr>
  <dhv:include name="accounts-sites" none="true">
  <dhv:evaluate if="<%= SiteList.size() > 1 %>">
    <tr class="containerBody">
      <td nowrap class="formLabel">
        <dhv:label name="accounts.site">Site</dhv:label>
      </td>
      <td>
        <dhv:evaluate if="<%= User.getSiteId() == -1 %>" >
          <%= SiteList.getHtmlSelect("siteId",OrgDetails.getSiteId()) %>
        </dhv:evaluate>
        <dhv:evaluate if="<%= User.getSiteId() != -1 %>" >
           <%= SiteList.getSelectedValue(User.getSiteId()) %>
          <input type="hidden" name="siteId" value="<%=User.getSiteId()%>" >
        </dhv:evaluate>
      </td>
    </tr>
  </dhv:evaluate> 
  <dhv:evaluate if="<%= SiteList.size() <= 1 %>">
    <input type="hidden" name="siteId" id="siteId" value="-1" />
  </dhv:evaluate>
  </dhv:include>
  <dhv:include name="organization.date1" none="true">
    <tr class="containerBody">
      <td nowrap class="formLabel">
        <dhv:label name="">Data Prescrizione</dhv:label>
      </td>
      <td>
        <zeroio:dateSelect form="addAccount" field="dataPrescrizione" timestamp="<%= OrgDetails.getDataPrescrizione() %>" showTimeZone="false" />
        <%= showAttribute(request, "date1Error") %>
      </td>
    </tr>
  </dhv:include>
  </table>
  </br>
  <table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
      <strong><dhv:label name="">Veterinario Prescrittore</dhv:label></strong>
    </th>
  </tr>
  <tr class="containerBody">
    <td class="formLabel">
      <dhv:label name="campioni.richiedente">Cognome Nome</dhv:label>
    </td>
    <td>
    <select name="idVeterinario" id="idVeterinario">
         <!-- option value="-1" selected>--Nessuno--</option-->
    <%
    
	Iterator j = VeterinariList.iterator();
	if ( j.hasNext() ) {
    int rowid = 0;
    int i = 0;
    while (j.hasNext()) {
    i++;
    rowid = (rowid != 1 ? 1 : 2);
    Veterinari thisOrg = (Veterinari)j.next();
%>
		<option value="<%= thisOrg.getIdVeterinario() %>" <%= (OrgDetails.getIdVeterinario()==thisOrg.getIdVeterinario()) ? "selected" : "" %>><%= thisOrg.getCognome()+" "+thisOrg.getNome() %></option>
		<%}} %>
    </select>
    </td>
  </tr>
</table>
</br>
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
      <strong><dhv:label name="">Allevamento Destinatario</dhv:label></strong>
    </th>
  </tr>
  <tr class="containerBody">
    <td class="formLabel">
      <dhv:label name="campioni.richiedente">Denonimazione Allevamento</dhv:label>
    </td>
    <td>
    <select name="orgId" id="orgId">
         <!-- option value="-1" selected>--Nessuno--</option-->
    <%    
	Iterator t = OrganizationList.iterator();
	if ( t.hasNext() ) {
    int rowid = 0;
    int p = 0;
    while (t.hasNext()) {
    p++;
    rowid = (rowid != 1 ? 1 : 2);
    Organization thisOrg5 = (Organization)t.next();
%>
		<option value="<%= thisOrg5.getOrgId() %>" <%= (OrgDetails.getOrgId()==thisOrg5.getOrgId()) ? "selected" : "" %>><%= thisOrg5.getName() %></option>
		<%}} %>
		</select>
		</td>
		</tr>
</table>
</br>
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
      <strong><dhv:label name="">Farmacia o Deposito Farmaceutico</dhv:label></strong>
    </th>
  </tr>
  <tr class="containerBody">
  <td class="formLabel">
      <dhv:label name="campioni.richiedente">Ragione Sociale</dhv:label>
    </td>
    <td>
    <select name="idFarmacia" id="idFarmacia">
         
    <%    
	Iterator k = FarmacieList.iterator();
	if ( k.hasNext() ) {
    int rowid = 0;
    int l = 0;
    while (k.hasNext()) {
    l++;
    rowid = (rowid != 1 ? 1 : 2);
    Farmacie thisOrg2 = (Farmacie)k.next();
%>
		<option value="<%= thisOrg2.getIdFarmacia() %>" <%= (OrgDetails.getIdFarmacia()==thisOrg2.getIdFarmacia()) ? "selected" : "" %>><%= thisOrg2.getRagioneSociale() %></option>
		<%}} %>
    </select>
    </td>
        </tr>
</table>
</br>
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
      <strong><dhv:label name="">Farmaci Prescritti</dhv:label></strong>
    </th>
  </tr>
  <tr class="containerBody">
  <td class="formLabel">
      <dhv:label name="">Farmaco 1</dhv:label>
    </td>
    <td>
    <select name="idFarmaco1" id="idFarmaco1">
        <!-- option value="-1" selected>--Nessuno--</option-->
    <%    
	Iterator w = FarmaciList.iterator();
	if (w.hasNext() ) {
    int rowid = 0;
    int q = 0;
    while (w.hasNext()) {
    q++;
    rowid = (rowid != 1 ? 1 : 2);
    Farmaci thisOrg3 = (Farmaci)w.next();
%>
		<option value="<%= thisOrg3.getIdFarmaco() %>" <%= (OrgDetails.getIdFarmaco1()==thisOrg3.getIdFarmaco()) ? "selected" : "" %>><%= thisOrg3.getNomeCommerciale() %></option>
		<%}} %>
    </select>
    </td>
        </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="">Quantit� Farmaco 1</dhv:label>
    </td>
    <td>
    	  <input type="text" size="10" name="quantitaFarmaco1" id="quantitaFarmaco1" maxlength="80" value="<%=OrgDetails.getQuantitaFarmaco1() %>">          
    </td>
  </tr>
  <tr class="containerBody">
  <td class="formLabel">
      <dhv:label name="">Farmaco 2</dhv:label>
    </td>
    <td>
    <select name="idFarmaco2" id="idFarmaco2">
         <!-- option value="-1" selected>--Nessuno--</option-->
    <%    
	Iterator e = FarmaciList.iterator();
	if (e.hasNext() ) {
    int rowid = 0;
    int r = 0;
    while (e.hasNext()) {
    r++;
    rowid = (rowid != 1 ? 1 : 2);
    Farmaci thisOrg4 = (Farmaci)e.next();
%>
		<option value="<%= thisOrg4.getIdFarmaco() %>" <%= (OrgDetails.getIdFarmaco2()==thisOrg4.getIdFarmaco()) ? "selected" : "" %>><%= thisOrg4.getNomeCommerciale() %></option>
		<%}}%>
    </select>
    </td>
        </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="">Quantit� Farmaco 2</dhv:label>
    </td>
    <td>
    	  <input type="text" size="10" name="quantitaFarmaco2" id="quantitaFarmaco2" maxlength="80" value="<%=OrgDetails.getQuantitaFarmaco2() %>">          
    </td>
  </tr>
  <dhv:include name="organization.date2" none="true">
    <tr class="containerBody">
      <td nowrap class="formLabel">
        <dhv:label name="">Data Dispensazione</dhv:label>
      </td>
      <td>
        <zeroio:dateSelect form="addAccount" field="dataDispensazione" timestamp="<%= OrgDetails.getDataDispensazione() %>" showTimeZone="false" />
        <%= showAttribute(request, "date2Error") %>
      </td>
    </tr>
  </dhv:include>
</table>
<br>
<%
  boolean noneSelected = false;
%>
<br>
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
	    <strong><dhv:label name="">Informazioni Aggiuntive</dhv:label></strong>
	  </th>
  </tr>
  <tr class="containerBody">
    <td valign="top" nowrap class="formLabel">
      <dhv:label name="">Note</dhv:label>
    </td>
    <td><TEXTAREA NAME="note1" ROWS="3" COLS="50"><%= toString(OrgDetails.getNote1()) %></TEXTAREA></td>
  </tr>
</table>
</br>
  <input type="hidden" name="onlyWarnings" value=<%=(OrgDetails.getOnlyWarnings()?"on":"off")%> />
  <input type="submit" value="<dhv:label name="global.button.update">Update</dhv:label>" name="Save" onClick="this.form.dosubmit.value='true';" />
<% if (request.getParameter("return") != null && "list".equals(request.getParameter("return"))) {%>
  <input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.action='FarmacosorveglianzaPre.do?command=DetailsPre&idPrescrizione=<%= OrgDetails.getIdFarmacia() %>';this.form.dosubmit.value='false';" />
<% } else if (isPopup(request)) { %>
  <input type="button" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onclick="javascript:window.close();" />
<% } else { %>
  <input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.action='FarmacosorveglianzaPre.do?command=DetailsPre&idPrescrizione=<%= OrgDetails.getIdFarmacia() %>';this.form.dosubmit.value='false';" />
<% } %>
  <input type="hidden" name="dosubmit" value="true">
  
  <input type="hidden" name="trashedDate" value="<%=OrgDetails.getTrashedDate()%>">
<% if (request.getParameter("actionplan") != null) { %>
<input type="hidden" name="actionplan" value="<%=request.getParameter("actionplan")%>">
<%}%>
<input type="hidden" name="action1" id="action1" value="modify">
</dhv:container>
</form>