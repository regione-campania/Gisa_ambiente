<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="java.util.*,org.aspcfs.modules.troubletickets.base.*" %>
<%@page import="org.aspcfs.modules.allerte.base.*"%>

<jsp:useBean id="ListaDistribuzione" class="org.aspcfs.modules.allerte.base.ListaDistribuzione" scope="request"/>


<%@ include file="../initPage.jsp" %>
<SCRIPT LANGUAGE="JavaScript" SRC="javascript/CalendarPopup.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">document.write(getCalendarStyles());</SCRIPT>
<SCRIPT LANGUAGE="JavaScript" ID="js19">
	var cal19 = new CalendarPopup();
	cal19.showYearNavigation();
	cal19.showYearNavigationInput();
	cal19.showNavigationDropdowns();
</SCRIPT>

<script src='javascript/modalWindow.js'></script>
<script src="http://code.jquery.com/jquery-1.8.2.js"></script>
<script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>


<%if(request.getAttribute("inserito")!=null && request.getAttribute("inserito").equals("OK")){ %>
<script>
window.opener.loadModalWindowCustom('<div style="color:red; font-size: 40px;">Attendere prego.... </div>');
window.opener.location.reload();
window.close();
</script>
<%}%>

<form name="addticket"  action="TroubleTicketsAllerte.do?command=UpdateListaDistribuzione&auto-populate=true" method="post">
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<dhv:label name="allerte.aggiungi">Modifica Lista di distribuzione</dhv:label>
</td>
</tr>
</table>

<%
if (request.getAttribute("allerte.insert.error")!=null)
{
	out.print("<font color = 'red'>"+request.getAttribute("allerte.insert.error")+"</font>");
}

%>
<br>
<%-- End Trails --%>

<dhv:formMessage />
<iframe src="empty.html" name="server_commands" id="server_commands" style="visibility:hidden" height="0"></iframe>
<% if (request.getAttribute("closedError") != null) { %>
  <%= showAttribute(request, "closedError") %>
<%}%>
<%-- include basic troubleticket add form --%>

<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.text.DateFormat, org.aspcfs.modules.actionplans.base.*" %>
<jsp:useBean id="idAllerta" class="java.lang.String" scope="request"/>
<jsp:useBean id="DepartmentList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="FruttaFresca" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="FruttaSecca" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Funghi" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Ortaggi" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Derivati" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Conservati" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Grassi" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Vino" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Zuppe" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="AltriAlimenti" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="AlimentiVegetaliNonTraformati" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="AlimentiVegetaliTraformati" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="lookup_1" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="lookup_2" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="lookup_3" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="lookup_4" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="lookup_5" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="lookup_6" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="lookup_7" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="lookup_8" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="lookup_9" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="lookup_10" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="lookup_11" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="lookup_12" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="lookup_13" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="resolvedByDeptList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="CategoryList" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="TicketDetails" class="org.aspcfs.modules.allerte.base.Ticket" scope="request"/>
<jsp:useBean id="PriorityList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SiteIdList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Provvedimenti" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoAlimento" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Origine" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="AlimentoInteressato" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="NonConformita" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ListaCommercializzazione" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="UnitaMisura" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="AlimentiNonTrasformati" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="AlimentiNonTrasformatiValori" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Amministrative" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Penali" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Sequestri" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SeverityList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SourceList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ticketStateList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Recipient" class="org.aspcfs.modules.contacts.base.Contact" scope="request"/>
<jsp:useBean id="causeList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="resolutionList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="EscalationList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="OrgList" class="org.aspcfs.modules.accounts.base.OrganizationList" scope="request"/>
<jsp:useBean id="OrgDetails" class="org.aspcfs.modules.accounts.base.Organization" scope="request"/>
<jsp:useBean id="SubList1" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="SubList2" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="SubList3" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="UserList" class="org.aspcfs.modules.admin.base.UserList" scope="request"/>
<jsp:useBean id="resolvedUserList" class="org.aspcfs.modules.admin.base.UserList" scope="request"/>
<jsp:useBean id="ContactList" class="org.aspcfs.modules.contacts.base.ContactList" scope="request"/>
<jsp:useBean id="actionPlans" class="org.aspcfs.modules.actionplans.base.ActionPlanList" scope="request"/>
<jsp:useBean id="insertActionPlan" class="java.lang.String" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="defectSelect" class="org.aspcfs.utils.web.HtmlSelect" scope="request"/>
<jsp:useBean id="TimeZoneSelect" class="org.aspcfs.utils.web.HtmlSelectTimeZone" scope="request"/>
<jsp:useBean id="AlimentiTrasformati" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoCampione" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SiteIdListUtil" class="java.util.HashMap" scope="request"/>
<jsp:useBean id="Regioni" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoCampione_batteri" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoCampione_virus" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoCampione_parassiti" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoCampione_fisico" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoCampione_chimico" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoCampione_sottochimico" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoCampione_sottochimico2" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Acque" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoCampione_sottochimico3" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoCampione_sottochimico4" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoCampione_sottochimico5" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoSpecie_latte" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoSpecie_uova" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="systemStatus" class="org.aspcfs.controller.SystemStatus" scope="request"/>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popAccounts.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popServiceContracts.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popAssets.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popProducts.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popURL.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popCalendar.js"></script>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popContacts.js"></SCRIPT>
<script language="JavaScript">


function controlloNumber(campo)
{	

	if(campo!=null && campo.value!='' )
	{
		
	 if (isNaN(campo.value)){
			
			return false ;
		}
	}
		return true ;
}


function selectLista(){


	 sel=document.addticket.ListaCommercializzazione.value;

if(sel=="2"){
	/* sel2=document.addticket.asl_coinvolte;

	for( i = 0 ; i < sel2.length; i++){

sel2[i].checked=true;

		 document.getElementById("cu_"+sel2[i].value).style.display="";
		 document.getElementById("int_"+sel2[i].value).style.display="";
		 }*/
	
}else{

	sel2=document.addticket.asl_coinvolte;

	for( i = 0 ; i < sel2.length; i++){
		document.getElementById("cu_"+sel2[i].value).style.display="none";	
		 document.getElementById("int_"+sel2[i].value).style.display="none";
sel2[i].checked=false;

 
		 }
	mostraAllegato();
	
}

	
	
}


function popLookupSelectorAllerteImpreseElimina(siteid,size)
{	

var clonato = document.getElementById('row_'+siteid+'_'+size);
	
	clonato.parentNode.removeChild(clonato);
	
	size = document.getElementById('size_'+siteid);
	size.value=parseInt(size.value)-1;
}

function abilitaCU(siteId)	{
	
	sel2=document.addticket.asl_coinvolte;
	var len = sel2.length;

	for( i = 0 ; i < len; i++){
		if(sel2[i].value==siteId && sel2[i].checked){
			 document.getElementById("cu_"+siteId).style.display="";
			 document.getElementById("int_"+siteId).style.display="";
			 document.getElementById("orgid_"+siteId).style.display="";
			 document.getElementById('select_'+siteId).style.display="";
			 document.getElementById('selectstabilimenti_'+siteId).style.display="";
			 if(siteId =="16"){
				document.getElementById("colonnaFuoriRegione").style.display="block";
				document.getElementById("noteFuoriRegione").style.display="block";
				}
		}
		else {
			 if(sel2[i].value==siteId){
				document.getElementById("cu_"+siteId).style.display="none";
			 	document.getElementById("int_"+siteId).style.display="none";
			 	document.getElementById("orgid_"+siteId).style.display="none";
			 	document.getElementById('select_'+siteId).style.display="none";
 				document.getElementById('selectstabilimenti_'+siteId).style.display="none";
 				if(siteId =="16"){
				 	document.getElementById("colonnaFuoriRegione").style.display="none";
					document.getElementById("noteFuoriRegione").style.display="none";
				}
//  				var numelementi = document.getElementById("elementi_"+siteId);
//  				alert(numelementi.value);
//  				for(i=1; i <numelementi.value;i++)
// 					 document.getElementById("org_"+siteid+"_"+i).style.display="none"; 
			}
		}
	}
}
	


  function controllo_data(stringa){
	    var espressione = /^[0-9]{2}\/[0-9]{2}\/[0-9]{4}$/;
	    if (!espressione.test(stringa))
	    {
	        return false;
	    }else{
	        anno = parseInt(stringa.substr(6),10);
	        mese = parseInt(stringa.substr(3, 2),10);
	        giorno = parseInt(stringa.substr(0, 2),10);
	        
	        var data=new Date(anno, mese-1, giorno);
	        if(data.getFullYear()==anno && data.getMonth()+1==mese && data.getDate()==giorno){
	            return true;
	        }else{
	            return false;
	        }
	    }
	}



	function confronta_data(data1, data2){
		// controllo validit� formato data
	    if(controllo_data(data1) &&controllo_data(data2)){
			//trasformo le date nel formato aaaammgg (es. 20081103)
	        data1str = data1.substr(6)+data1.substr(3, 2)+data1.substr(0, 2);
			data2str = data2.substr(6)+data2.substr(3, 2)+data2.substr(0, 2);
			//controllo se la seconda data � successiva alla prima
	        if (data2str-data1str<0) {
	           return false ;
	        }else{
				return true ;
	        }
	    }
	}

	
	
  
  function checkForm(form){
    formTest = true;
    message = "";
    
	if(form.motivo_ripianificazione_modifica.value=="")
    {
    	message += label("check.campioni.richiedente.selezionatosssd","- Controllare che \"Motivo Ripianificazione/ambiamento \" sia stato popolato\r\n");
        formTest = false;
    }
    
      
    
  	 if(form.data_lista.value == ""){
    		message += label("check.sanzioni.richiedente.selezionato","- Controllare che il campo \"Data lista\" sia stato popolato\r\n");
    		formTest = false;
    	 }
 		if(form.nome_fornitore.value == ""){
 			message += label("check.sanzioni.richiedente.selezionato","- Controllare che il campo \"Nome fornitore\" sia stato popolato\r\n");
 			formTest = false;
    	 }
 		if(form.data_chiusura.value == ""){
 			message += label("check.sanzioni.richiedente.selezionato","- Controllare che il campo \"Data chiusura\" sia stato popolato\r\n");
 			formTest = false;
 		}
	
 	  
 	
 
	for (i=201; i<=207;i++)
	{
		if (controlloNumber(document.getElementById("cucampo_"+i))==false)
		{
			formTest = false ; 
			message += label("TESTO1","- Il \"Numero CU\" deve essere un valore numerico.\r\n");
			break;
		}
	}
   


	var aslVuote = 0;
	var cuVuoti = 0;
	
	for (var i=201; i<=207;i++){
		var asl =document.getElementById("asl_"+i);
		var cu = document.getElementById("cucampo_"+i);
		
		if (asl.checked){
			aslVuote = 1;
			if (cu.value == '')
				cuVuoti=1;
		}
	}
	
	if (aslVuote==0){
	message += label("check.sanzioni.richiedente.selezionato","- Selezionare almeno un'ASL coinvolta.\r\n");
	formTest = false;
	}
	if (cuVuoti==1){
		message += label("check.sanzioni.richiedente.selezionato","- Controllar di aver inserito il numero di CU per ogni asl coinvolta.\r\n");
		formTest = false;
		}



    if (formTest == false) {
      alert(label("check.form", "Form could not be saved, please check the following:\r\n\r\n") + message);
      return false;
    } else {
      loadModalWindow(); 
      form.submit();
      return true;
    }
  }
  //used when a new contact is added
  function insertOption(text,value,optionListId){
   var obj = document.forms['addticket'].contactId;
   insertIndex= obj.options.length;
   obj.options[insertIndex] = new Option(text,value);
   obj.selectedIndex = insertIndex;
  }
  function changeDivContent(divName, divContents) {
    if(document.layers){
      // Netscape 4 or equiv.
      divToChange = document.layers[divName];
      divToChange.document.open();
      divToChange.document.write(divContents);
      divToChange.document.close();
    } else if(document.all){
      // MS IE or equiv.
      divToChange = document.all[divName];
      divToChange.innerHTML = divContents;
    } else if(document.getElementById){
      // Netscape 6 or equiv.
      divToChange = document.getElementById(divName);
      divToChange.innerHTML = divContents;
    }
    //when the content of any of the select items changes, do something here
    //reset the sc and asset
    if (divName == 'changeaccount') {
      <dhv:include name="ticket.contact" none="false">
      if(document.forms['addticket'].orgId.value != '-1'){
        updateLists();
      }
      </dhv:include>
      <dhv:include name="ticket.contractNumber" none="false">
      changeDivContent('addServiceContract',label('none.selected','None Selected'));
      resetNumericFieldValue('contractId');
      </dhv:include>
      <dhv:include name="ticket.contractNumber" none="false">
      changeDivContent('addAsset',label('none.selected','None Selected'));
      resetNumericFieldValue('assetId');
      </dhv:include>
      <%-- dhv:include name="ticket.laborCategory" none="false">
      changeDivContent('addLaborCategory',label('none.selected','None Selected'));
      resetNumericFieldValue('productId');
      </dhv:include --%>
    }
  }

  function addNewContact(){
    <dhv:permission name="accounts-accounts-contacts-add">
      var acctPermission = true;
    </dhv:permission>
    <dhv:permission name="accounts-accounts-contacts-add" none="true">
      var acctPermission = false;
    </dhv:permission>
    <dhv:permission name="contacts-internal_contacts-add">
      var empPermission = true;
    </dhv:permission>
    <dhv:permission name="contacts-internal_contacts-add" none="true">
      var empPermission = false;
    </dhv:permission>
    var orgId = document.forms['addticket'].orgId.value;
    if(orgId == -1){
      alert(label("select.account.first",'You have to select an Account first'));
      return;
    }
    if(orgId == '0'){
      if (empPermission) {
        popURL('CompanyDirectory.do?command=Prepare&container=false&popup=true&source=troubletickets', 'New_Employee','600','550','yes','yes');
      } else {
        alert(label('no.permission.addemployees','You do not have permission to add employees'));
        return;
      }
    }else{
      if (acctPermission) {
        popURL('Contacts.do?command=Prepare&container=false&popup=true&source=troubletickets&hiddensource=troubletickets&orgId=' + document.forms['addticket'].orgId.value, 'New_Contact','600','550','yes','yes');
      } else {
        alert(label("no.permission.addcontacts","You do not have permission to add contacts"));
        return;
      }
    }
  }

 function resetNumericFieldValue(fieldId){
  document.getElementById(fieldId).value = -1;
 }

 function setAssignedDate(){
  resetAssignedDate();
  if (document.forms['addticket'].assignedTo.value > 0){
    document.forms['addticket'].assignedDate.value = document.forms['addticket'].currentDate.value;
  }
 }

 function resetAssignedDate(){
    document.forms['addticket'].assignedDate.value = '';
 }
 
 function setField(formField,thisValue,thisForm) {
  var frm = document.forms[thisForm];
  var len = document.forms[thisForm].elements.length;
  var i=0;
  for( i=0 ; i<len ; i++) {
    if (frm.elements[i].name.indexOf(formField)!=-1) {
      if(thisValue){
        frm.elements[i].value = "1";
      } else {
        frm.elements[i].value = "0";
      }
    }
  }
 }
 
  function selectUserGroups() {
    var orgId = document.forms['addticket'].orgId.value;
    var siteId = document.forms['addticket'].orgSiteId.value;
    if (orgId != '-1') {
      popUserGroupsListSingle('userGroupId','changeUserGroup', '&userId=<%= User.getUserRecord().getId() %>&siteId='+siteId);
    } else {
      alert(label("select.account.first",'You have to select an Account first'));
      return;
    }
  }
  
  function popKbEntries() {
    var siteId = document.forms['addticket'].orgSiteId.value;
    var form = document.forms['addticket'];
    var catCode = form.elements['catCode'];
    var catCodeValue = catCode.options[catCode.selectedIndex].value;
    if (catCodeValue == '0') {
      alert(label('','Please select a category first'));
      return;
    }
    var subCat1 = form.elements['subCat1'];
    var subCat1Value = subCat1.options[subCat1.options.selectedIndex].value;
  <dhv:include name="ticket.subCat2" none="true">
    var subCat2 = form.elements['subCat2'];
    var subCat2Value = subCat2.options[subCat2.options.selectedIndex].value;
  </dhv:include>
  <dhv:include name="ticket.subCat2" none="true">
    var subCat3 = form.elements['subCat3'];
    var subCat3Value = subCat3.options[subCat3.options.selectedIndex].value;
  </dhv:include>
    var url = 'KnowledgeBaseManager.do?command=Search&popup=true&searchcodeSiteId='+siteId+'&searchcodeCatCode='+catCodeValue;
    url = url + '&searchcodeSubCat1='+ subCat1Value;
  <dhv:include name="ticket.subCat2" none="true">
    url = url + '&searchcodeSubCat2='+ subCat2Value;
  </dhv:include>
  <dhv:include name="ticket.subCat3" none="true">
    url = url + '&searchcodeSubCat3='+ subCat3Value;
  </dhv:include>
    popURL(url, 'KnowledgeBase','600','550','yes','yes');
  }
  
   function selectCarattere(str, n, m){
  
 		elm1 = document.getElementById("dat"+n);
 		elm2 = document.getElementById("dat"+m);
 		
 		
 		if(str == "Provvedimenti"){
 			car = document.addticket.Provvedimenti.value;
 		}
 		if(str == "Amministrative"){
 			car = document.addticket.Amministrative.value;
 		}
 		if(str == "Penali"){
 			car = document.addticket.Penali.value;
 		}
 		
 		if(car == 9 || (car == 6 && str == "Penali")){
 			elm1.style.visibility = "visible";
 			elm2.style.visibility = "visible";
 			
 		}
 		else {
 			elm1.style.visibility = "hidden";
 			elm2.style.visibility = "hidden";
 			
 		}
 	  }

 

function mostraAllegato(){

  lista=document.addticket.ListaCommercializzazione.value;
  

  if(lista==1){
document.getElementById("oggetto").style.display="";



sel2=document.addticket.asl_coinvolte;

for( i = 0 ; i < sel2.length; i++){

sel2[i].checked=false;
document.getElementById("cu_"+sel2[i].value).style.display="none";
document.getElementById("int_"+sel2[i].value).style.display="none";
}
	  }else{
		  document.getElementById("oggetto").style.display="none";
	  
		  }
}




</script>

<DIV ID='modalWindow' CLASS='unlocked'><P CLASS='wait'>Attendere il completamento dell'operazione...</P></DIV>

<form name ="addticket" id="addticket">
<table cellpadding="4" cellspacing="0" width="100%" class="details">
	<tr>
    <th colspan="2">
      <strong><dhv:label name="">Aggiungi Lista di distribuzione</dhv:label></strong>
    </th>
	</tr>
	
  
  
 <tr id="tr_datalista">
  <td nowrap class="formLabel">Data lista</td>
  <td>
  <input class="editField" type="text" readonly id="data_lista" name="data_lista" size="10" value="<%=toDateasString(ListaDistribuzione.getData_lista())%>"/>
<a href="#" onClick="cal19.select(document.forms[0].data_lista,'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19">
<img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a> <font color="red">*</font>
 </td></tr>
 
  <tr id="tr_nomefornitore" >
  <td nowrap class="formLabel">Nome fornitore</td>
 <td>
 <input type="text" id="nome_fornitore" name="nome_fornitore" value="<%=ListaDistribuzione.getNome_fornitore()%>"/> <font color="red">*</font>
 </td></tr>
  
  <dhv:include name="stabilimenti-sites" none="true">
  


<dhv:evaluate if="<%= SiteIdList.size() > 1 %>">
  <input type="hidden" name="numasl" value="<%=SiteIdList.size() %>">
  <tr class="containerBody">
    <td nowrap class="formLabel">
      A.S.L. Coinvolte
    </td>
    <td>
        
        <table class="noborder">
        <%Iterator<Integer> it=SiteIdListUtil.keySet().iterator();
        Hashtable<String, AslCoinvolte> ListaBpi6=ListaDistribuzione.getAsl_coinvolte();
		Iterator<String> iteraKiavi6= ListaDistribuzione.getAsl_coinvolte().keySet().iterator();
        while(it.hasNext()){
        	int code=it.next();
       		String descr=(String)SiteIdListUtil.get(code);
        	AslCoinvolte asl=ListaBpi6.get(descr);
        	if(asl!=null){
        		if(code==16){
        						%>
        		<tr>
        			<td><%=descr %>&nbsp;</td>
        			<td>
        			        <input type = "hidden" name = "asl_coinvolte" value ="<%=code %>">
        			<input type="checkbox" name="asl_coinvolte" id="asl_<%=code %>" checked="checked" disabled="disabled" onclick="abilitaCU(<%=code %>)" value="<%=code %>"></td><td id="int_<%=code %>" style="display:none">&nbsp;Numero C.U.&nbsp;</td><td id="cu_<%=code %>" style="display:none"><input type="text" name="cu_<%=code %>"  id="cucampo_<%=code %>" value="<%=asl.getControlliUfficialiRegionaliPianificati() %>"></td>
        			<td id="colonnaFuoriRegione" style="display:none">
        				<textarea rows="8" cols="50" id = "noteFuoriRegione"  name="noteFuoriRegione"  value = "<%=asl.getNoteFuoriRegione() %>"> 
        				<%=toHtml(asl.getNoteFuoriRegione()) %>
        				</textarea> 
        
        				</td>
        				  <td id="orgid_<%=code %>">
         <input type = "hidden" id = "elementi_<%=code %>" name = "elementi_<%=code %>" <%if(ListaDistribuzione.getImpresaCoinvolta(code)!=null){ if (ListaDistribuzione.getImpresaCoinvolta(code).getImpreseCoinvolte()!=null){ %> value = "<%=ListaDistribuzione.getImpresaCoinvolta(code).getImpreseCoinvolte().size() %>" <%}} %>>
   		<input type = "hidden" id = "size_<%=code %>" name = "size_<%=code %>" <%if(ListaDistribuzione.getImpresaCoinvolta(code)!=null){ if (ListaDistribuzione.getImpresaCoinvolta(code).getImpreseCoinvolte()!=null){ %> value = "<%=ListaDistribuzione.getImpresaCoinvolta(code).getImpreseCoinvolte().size() %>" <%}} %> >
  
        <table id="tab_<%=code %>">
        <tr id="row_<%=code %>" style = "display : none"><td><input type = "text" readonly="readonly" name = "pippo_<%=code %>"></td> <td><input type = "text" readonly="readonly" name = "indirizzo_<%=code %>"></td><td>[<a href="javascript:popLookupSelectorAllerteImpreseElimina()" id="elimina_<%=code %>">[elimina]</a></td></tr>
        
        <%
        int indice =1;
        
        if(ListaDistribuzione.getImpresaCoinvolta(code)!=null)
        {
        	
        	 if(ListaDistribuzione.getImpresaCoinvolta(code).getIndirizziImpreseCoinvolte()!=null)
             {
        ArrayList<String > indirizzi =ListaDistribuzione.getImpresaCoinvolta(code).getIndirizziImpreseCoinvolte();
        for (String s : ListaDistribuzione.getImpresaCoinvolta(code).getImpreseCoinvolte())
        {
        	if(!s.equals("")){
        %>
         <tr id="row_<%=code %>_<%=indice %>"><td><input type = "text" readonly="readonly" name = "pippo_<%=code %>" value = "<%=s %>"></td> <td><input type = "text" readonly="readonly" name = "indirizzo_<%=code %>" value = "<%=indirizzi.get(indice) %>"></td><td>[<a href="javascript:popLookupSelectorAllerteImpreseElimina()" id="elimina_<%=code %>">[elimina]</a></td></tr>
        indice++;
        <%} }
        }}%>
        
        </table>
        
        </td>
        
        <td id = "select_<%=code %>" >
          &nbsp;[<a href="javascript:popLookupSelectorAllerteImprese('codiceFiscaleCorrentista','alertText','organization','',<%=code %>);">Aggiungi Impresa</a>]
        
        </td>
        
        
        <td id = "selectstabilimenti_<%=code %>" >
          &nbsp;[<a href="javascript:popLookupSelectorAllerteStabilimenti('codiceFiscaleCorrentista','alertText','organization','',<%=code %>);"><dhv:label name="">Aggiungi Stabilimento</dhv:label></a>]
        
        </td>
      
        
        </tr>
        <%}else{ %>
        <tr><td><%=descr %>&nbsp;</td><td>
<!--        <input type = "hidden" name = "asl_coinvolte" value ="<%=code %>">-->
        <input type="checkbox" name="asl_coinvolte" id="asl_<%=code %>" checked="checked" onclick="abilitaCU(<%=code %>)" value="<%=code %>"></td><td id="int_<%=code %>" style="display:none">&nbsp;Numero C.U.&nbsp;</td><td id="cu_<%=code %>" ><input type="text" name="cu_<%=code %>" id="cucampo_<%=code %>" value="<%=asl.getControlliUfficialiRegionaliPianificati() %>"></td>
        <td>&nbsp;</td>
        
          <td id="orgid_<%=code %>">
      <input type = "hidden" id = "elementi_<%=code %>" name = "elementi_<%=code %>" <%if(ListaDistribuzione.getImpresaCoinvolta(code)!=null){ if(ListaDistribuzione.getImpresaCoinvolta(code).getImpreseCoinvolte()!=null){ %> value = "<%=ListaDistribuzione.getImpresaCoinvolta(code).getImpreseCoinvolte().size() %>" <%}} %>>
   		<input type = "hidden" id = "size_<%=code %>" name = "size_<%=code %>" <%if(ListaDistribuzione.getImpresaCoinvolta(code)!=null){ if(ListaDistribuzione.getImpresaCoinvolta(code).getImpreseCoinvolte()!=null){ %> value = "<%=ListaDistribuzione.getImpresaCoinvolta(code).getImpreseCoinvolte().size() %>" <%}} %>>
   
        <table id="tab_<%=code %>">
        <tr id="row_<%=code %>" style = "display : none"><td><input type = "text" readonly="readonly" name = "pippo_<%=code %>"></td> <td><input type = "text" readonly="readonly" name = "indirizzo_<%=code %>"></td><td>[<a href="javascript:popLookupSelectorAllerteImpreseElimina()" id="elimina_<%=code %>">[elimina]</a></td></tr>
         <%
        int indice =1;
         if(ListaDistribuzione.getImpresaCoinvolta(code)!=null)
         {
         	
         if(ListaDistribuzione.getImpresaCoinvolta(code).getIndirizziImpreseCoinvolte()!=null)
         {
        ArrayList<String > indirizzi =ListaDistribuzione.getImpresaCoinvolta(code).getIndirizziImpreseCoinvolte();
        for (String s : ListaDistribuzione.getImpresaCoinvolta(code).getImpreseCoinvolte())
        {
        	if(!s.equals("")){
        %>
         <tr id="row_<%=code %>_<%=indice %>"><td><input type = "text" readonly="readonly" name = "pippo_<%=code %>" value = "<%=s %>"></td> <td><input type = "text" readonly="readonly" name = "indirizzo_<%=code %>" value = "<%=indirizzi.get(indice) %>"></td><td>[<a href="javascript:popLookupSelectorAllerteImpreseElimina('<%=code %>','<%=indice%>')" id="elimina_<%=code %>">[elimina]</a></td></tr>
        
        <%
        	}
        }
         }}
        
         indice++;%>
        
        </table>
        
        </td>
        
        <td id = "select_<%=code %>" >
          &nbsp;[<a href="javascript:popLookupSelectorAllerteImprese('codiceFiscaleCorrentista','alertText','organization','',<%=code %>);"><dhv:label name="">Aggiungi Impresa</dhv:label></a>]
        
        </td>
        
        <td id = "selectstabilimenti_<%=code %>" >
          &nbsp;[<a href="javascript:popLookupSelectorAllerteStabilimenti('codiceFiscaleCorrentista','alertText','organization','',<%=code %>);"><dhv:label name="">Aggiungi Stabilimento</dhv:label></a>]
        
        </td>
        </tr>
        <%} %>
        
        
        
        <%} else{
        	
        	if(code == 16) {
        	%>
        	
        	
        	 <tr><td><%=descr %>&nbsp;</td><td><input type="checkbox" name="asl_coinvolte" id="asl_<%=code %>" onclick="abilitaCU(<%=code %>)" value="<%=code %>"></td><td id="int_<%=code %>" style="display:none">&nbsp;Numero C.U.&nbsp;</td><td id="cu_<%=code %>" style="display:none"><input type="text" name="cu_<%=code %>" id="cucampo_<%=code %>" ></td>
        	 
        	 <td id="colonnaFuoriRegione" style="display:none">
       
          <textarea rows="8" cols="50" id = "noteFuoriRegione"  name="noteFuoriRegione" > 
       
        		
        </textarea> 
        
        </td>
        	 
        	   <td id="orgid_<%=code %>">
        <input type = "hidden" id = "elementi_<%=code %>" name = "elementi_<%=code %>" value = "0">
   		<input type = "hidden" id = "size_<%=code %>" name = "size_<%=code %>" value = "0">
   
        <table id="tab_<%=code %>">
        <tr id="row_<%=code %>" style = "display : none"><td><input type = "text" readonly="readonly" name = "pippo_<%=code %>"></td> <td><input type = "text" readonly="readonly" name = "indirizzo_<%=code %>"></td><td>[<a href="javascript:popLookupSelectorAllerteImpreseElimina()" id="elimina_<%=code %>">[elimina]</a></td></tr>
        </table>
        
        </td>
        
        <td id = "select_<%=code %>" style="display: none">
          &nbsp;[<a href="javascript:popLookupSelectorAllerteImprese('codiceFiscaleCorrentista','alertText','organization','',<%=code %>);"><dhv:label name="">Aggiungi Impresa</dhv:label></a>]
        
        </td>
        
        <td id = "selectstabilimenti_<%=code %>" style="display: none">
          &nbsp;[<a href="javascript:popLookupSelectorAllerteStabilimenti('codiceFiscaleCorrentista','alertText','organization','',<%=code %>);"><dhv:label name="">Aggiungi Stabilimento</dhv:label></a>]
        
        </td>
        	 
        	 </tr>
       
        	
        	<%
        }else{
        	
        	%>
        	<tr><td><%=descr %>&nbsp;</td><td><input type="checkbox" name="asl_coinvolte" id="asl_<%=code %>" onclick="abilitaCU(<%=code %>)" value="<%=code %>"></td><td id="int_<%=code %>" style="display:none">&nbsp;Numero C.U.&nbsp;</td><td id="cu_<%=code %>" style="display:none"><input type="text" name="cu_<%=code %>" id="cucampo_<%=code %>" ></td>  <td>&nbsp;</td>
        	
        	  <td id="orgid_<%=code %>">
       <input type = "hidden" id = "elementi_<%=code %>" name = "elementi_<%=code %>" value = "0">
   		<input type = "hidden" id = "size_<%=code %>" name = "size_<%=code %>" value = "0">
   
        <table id="tab_<%=code %>">
        <tr id="row_<%=code %>" style = "display : none"><td><input type = "text" readonly="readonly" name = "pippo_<%=code %>"></td> <td><input type = "text" readonly="readonly" name = "indirizzo_<%=code %>"></td><td>[<a href="javascript:popLookupSelectorAllerteImpreseElimina()" id="elimina_<%=code %>">[elimina]</a></td></tr>
        </table>
        
        </td>
        
        <td id = "select_<%=code %>" style="display: none">
          &nbsp;[<a href="javascript:popLookupSelectorAllerteImprese('codiceFiscaleCorrentista','alertText','organization','',<%=code %>);"><dhv:label name="">Aggiungi Impresa</dhv:label></a>]
        
        </td>
        
        <td id = "selectstabilimenti_<%=code %>" style="display: none">
          &nbsp;[<a href="javascript:popLookupSelectorAllerteStabilimenti('codiceFiscaleCorrentista','alertText','organization','',<%=code %>);"><dhv:label name="">Aggiungi Stabilimento</dhv:label></a>]
        
        </td>
        	</tr>
        	
        	<%
        	
        }
        	
        }
        
        
        }
        
        %>
        
        
        </table>
        
        </td>
      		
      		
      		
      		
    
  </tr>
  </dhv:evaluate> 










 </dhv:include>
 
  
  
  
  
   <tr id="tr_datachiusura">
  <td nowrap class="formLabel">Data chiusura</td>
 <td>
 <input class="editField" type="text" readonly id="data_chiusura" name="data_chiusura" size="10" value="<%=toDateasString(ListaDistribuzione.getData_chiusura())%>"/>
<a href="#" onClick="cal19.select(document.forms[0].data_chiusura,'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19">
<img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a> <font color="red">*</font>
 </td></tr>
 
</table>

	<table cellpadding="4" cellspacing="0" width="100%" class="details">
	<tr>
      <th colspan="2">
        <strong><dhv:label name="">Motivo Ripianificazione/Modifica</dhv:label></strong>
      </th>
	</tr>
	  <tr class="containerBody">
    <td valign="top" class="formLabel">
      <dhv:label name="sanzioni.note">Indicare il motivo del cambiamento</dhv:label>
    </td>
    <td>
      <table border="0" cellspacing="0" cellpadding="0" class="empty">
        <tr>
          <td>
            <textarea name="motivo_ripianificazione_modifica" id="motivo_ripianificazione_modifica" cols="55" rows="8"></textarea><font color ="red">*</font>
          </td>
         </tr>
      </table>
    </td>
	</tr>
</table>


<a name="categories"></a>
<input type="hidden" name="close" value="">
<input type="hidden" name="refresh" value="-1">

<input type="hidden" name="idAllerta" id="idAllerta" value="<%=  idAllerta %>" />
<%= addHiddenParams(request, "popup|popupType|actionId") %>

<input type="hidden" name="idLdd" value="<%=ListaDistribuzione.getId()%>">

<br>
<input type="button" value="MODIFICA LISTA DI DISTRIBUZIONE" name="Save" onClick="return checkForm(this.form)">
<input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.action='TroubleTicketsAllerte.do?command=Details&id=<%=idAllerta%>'">

</form>
</body>