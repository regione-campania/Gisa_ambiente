


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
  - Version: $Id: mycfs.jsp 11310 2005-04-13 20:05:00Z mrajkowski $
  - Description: 
  --%>
<%@page import="com.itextpdf.text.log.SysoLogger"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="java.util.*,org.aspcfs.modules.mycfs.base.*,org.aspcfs.modules.accounts.base.NewsArticle,org.aspcfs.modules.mycfs.beans.*" %>
<%@ page import="org.aspcfs.modules.quotes.base.*" %>
<%@ page import="org.aspcfs.modules.troubletickets.base.*" %>
<jsp:useBean id="NewsList" class="org.aspcfs.modules.accounts.base.NewsArticleList" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="NewUserList" class="org.aspcfs.utils.web.HtmlSelect" scope="request"/>
<jsp:useBean id="IndSelect" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="LoginBean" class="org.aspcfs.modules.login.beans.LoginBean" scope="request"/>


<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/tasks.js"></script>
<link href="css/nonconformita.css" rel="stylesheet" type="text/css" />


<script type="text/javascript" src="dwr/interface/PopolaCombo.js"> </script>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>


<link rel="stylesheet" href="css/jquery-ui.css" />
<link rel="stylesheet" href="css/opu.css" />

<script language="javascript">
function checkFirefox(msg)
{

	if(msg!=null && msg!="")
		{
		if(confirm(msg)==false)
			{
			location.href="Login.do?command=Logout";
			}
		}
		
		}
$(document).ready(function() {
	
	$("#dialog").dialog({
        autoOpen: false,
        resizable: true,
        modal: true,
        title: 'Il tuo codice fiscale non è aggiornato. Per favore, contattare il servizio di Help Desk',
        close: function () {
		if ($("#cf").val() == null || $("#cf").val() == "" ){
			DwrUtil.Logout(logout);
		}
            },
            buttons: {
            'Prosegui': function() {
            	$(this).dialog('close'); 
            	}
            }
            
        <%--, buttons: {
            'Salva i dati e prosegui': function() {
              //  alert($("#telefono").val());
             //   alert($("#email").val());
                if ($("#cf").val() != null && $("#cf").val() != ""){
                   // alert("Dati completi");
                    PopolaCombo.aggiornaDatiUtente($("#cf").val(), <%=User.getUserId()%>, salvaCallback);
                	$(this).dialog('close');   
                } else{
               //     alert("Dati incompleti");
                }
            },
            'Rinuncia ed esci dal sistema': function() {
            	//$("#idTipologiaEvento").val(-1);
            	//popolaCampi();
            	PopolaCombo.Logout(logout);
                $(this).dialog('close');
                
               // $('#opener').button('refresh')
            }x
        }--%>
    });

	function logout(value)
	{
		
// 		document.location.href = "/bdu/MyCFS.do?command=Home";
		
	}

	function salvaCallback(value)
	{
		if (value){
// 			document.location.href = "/bdu/MyCFS.do?command=Home";
		}else{
			alert("I dati Inseriti non sono corretti.Inserire un codice fiscale Valido");
			DwrUtil.Logout(logout);
		}
		
	}

<%

if ( application.getAttribute("SUFFISSO_TAB_ACCESSI").equals("") && (User.getUserRecord().getContact().getCodiceFiscale() == null )){
%>
$('#dialog').dialog('open');
<%}%>

});
</script>



<%@ include file="../initPage.jsp" %>
<%
  //returnPage specifies the source of the request ( Accounts/ Home Page ) 
  String returnPage = request.getParameter("return");
   CalendarBean CalendarInfo = (CalendarBean) session.getAttribute(returnPage != null ?returnPage + "CalendarInfo" :"CalendarInfo");
   if(CalendarInfo==null){
       CalendarInfo = new CalendarBean();
       session.setAttribute(returnPage!=null?returnPage + "CalendarInfo":"CalendarInfo",CalendarInfo);
   }
%>


<script>
function rosso(){

	if(document.getElementById('lampeggio')!=null)
	{
document.getElementById('lampeggio').style.color='red';
setTimeout("giallo()",800);
}

}
function giallo(){
	if(document.getElementById('lampeggio')!=null)
	{
document.getElementById('lampeggio').style.color='white';
setTimeout("rosso()",800);
	}

	
}

function rosso_lampeggio(){


	if(document.getElementById('lampeggio2')!=null)
	{
document.getElementById('lampeggio2').style.color='red';
setTimeout("giallo_lampeggio()",500);
}
}
function giallo_lampeggio(){

	if(document.getElementById('lampeggio2')!=null)
	{
document.getElementById('lampeggio2').style.color='white';
setTimeout("rosso_lampeggio()",800);
	}
}
</script>

<script>
setTimeout( "rosso()",500);
setTimeout( "rosso_lampeggio()",200);

</script>


<script type="text/javascript"> 
 function attachClicks () { 
 if (document.getElementById) { 
 var clickedonce = 0; 
 if (document.getElementById('form_submit')!=null){
 document.getElementById('form_submit').onclick = function() {  
  if (clickedonce==1) {  
	  alert('Si prega di attendere il caricamento dei dati');
	  return false;  
  }  
  clickedonce=1;  
  };  }
 } 
 } 
 window.onload = function() { attachClicks(); };  
 </script> 
	

<script type="text/javascript">
  function fillFrame(frameName,sourceUrl){
    window.frames[frameName].location.href=sourceUrl;
  }

  function reopen(){
    window.location.href='MyCFS.do?command=Home';
  }

  function reloadFrames(){
    window.frames['calendar'].location.href='MyCFS.do?command=MonthView&source=Calendar&inline=true&reloadCalendarDetails=true';
  }
 
</script>


<table width="100%">
<col width="50%"><col width="50%">
<tr><td valign="top">



<table cellpadding="0" cellspacing="0" border="0" width="100%">
  <%-- User Selected Info --%>
  <dhv:permission name="products-view" none="true">


  
 
 <strong>
 <font size=2 color="red">
 
 
 <%--
 String comunicazioni=(String)request.getAttribute("comunicazioni");
 if (comunicazioni!=null) {
	 %>
<!--	 <IMG SRC="mycfs/new_message.jpg" WIDTH="45" HEIGHT="30">-->
	 <div id="lampeggio">
	 <%
		 out.println(comunicazioni);
	 %>
	 </div>
	 <%
 }--%>
 
 
 <%

 
  boolean permissionValidazione = false;
  %>
    <dhv:permission name="opu_validazione" none="true">
  <% permissionValidazione = true;%>
  </dhv:permission>
    <dhv:permission name="opu_validazione_riconoscimento" none="true">
      <% permissionValidazione = true;%>
  </dhv:permission>
  
  <% 
 String richieste=(String)request.getAttribute("richieste");
 if (richieste!=null && permissionValidazione) {
 %>
 
	 <div id="lampeggio">
	 <%
		 out.println(richieste);
	 %>
	 </div>
	 <%
 }
 %>
 </font>
 
 </strong>
  
  </dhv:permission>
  <%-- AdsJet users only --%>
  <dhv:permission name="products-view">
  <tr>
    <td colspan="2">
      <table class="pagedListHeader" cellspacing="0">
        <tr>
          <td align="center">
            <strong>Welcome to AdsJet.com.</strong>
          </td>
        </tr>
      </table>
      <table class="pagedListHeader2" cellspacing="0">
        <tr>
          <th>
            You are currently at the "My Home Page" tab in which you can 
            review the status of your pending ad requests and orders.
            From the "Products &amp; Services" tab you can review 
            publication information, as well as manage and place ads.
          </th>
        </tr>
      </table>
    </td>
  </tr>
  </dhv:permission>
  <%-- Calendar and Details --%>
  <style type="text/css">
  div.scroll {
height: 330px;
width: 995px;
overflow: auto;
} 
  </style>
 
  
  <%
 
 

  
  %>

<tr><td align="center">
	<table>
		<tr>
		<td>
		
		<dhv:permission name="myhomepage-scadenzario-view">
		<a class="ovalbutton"  href = "MyCFS.do?command=ListReport" id="form_submit" title ="Lo scadenzario contiene: la lista dei controlli ufficiali aperti con e senza sottoattività (in arancio);la lista dei controlli ufficiali chiusi con almeno un Follow Up (in verde) e la lista dei controlli ufficiali in sorveglianza (in rosso)" style="text-align: center;" > <span>Scadenzario Controlli Ufficiali </span></a>
		</dhv:permission>
		</td>
		</tr>
	</table>
</td></tr>

<%--
<tr><td align="center">
<table style="border: 1px solid black" width="40%" cellpadding="10"><tr><td> 
<center><strong>EVENTO FORMATIVO </strong></center>
<br/>

 Il giorno 20/12/2016 si terrà presso il salone dell' <i>Istituto Zooprofilattico Sperimentale del Mezzogiorno</i> una giornata di formazione con tema:

<br/><br/><center><u>"L'Audit per il Controllo degli Operatori del Settore Alimentare"</u>.</center><br/>
L'evento è rivolto a medici, medici veterinari e biologi.

<strong>
<a href="#" onClick="window.open('mycfs/PROGRAMMA.pdf'); return false">Download</a>
</strong>

</td></tr></table>
</td></tr>

--%>


<%if (User.getRoleId()==39){%>
<tr><td align="center">
	<table>
		<tr>
		<td>
		
		
		<a class="ovalbutton"  href = "MyCFS.do?command=ListaVolture" id="form_submit1"  > <span  >Richieste di Volture </span></a>
		
		</td>
		</tr>
	</table>
</td></tr>



<%} %>



<%

String suffisso = ( "_ext".equalsIgnoreCase((String)request.getServletContext().getAttribute("SUFFISSO_TAB_ACCESSI"))) ?  (String)request.getServletContext().getAttribute("SUFFISSO_TAB_ACCESSI") :"";
%>  
</table>
<%--   
<tr><td colspan="2"><%@ include file="../rilasci_home_page.jsp" %></td></tr>
--%>

<script type="text/javascript">
function showHide(id) {

  if (document.getElementById(id).style.display == "none") {
    document.getElementById(id).style.display = '';
  }

  else {
    document.getElementById(id).style.display = "none";
  }

}
</script>
<br>
<br>

<dhv:permission name="campioni-campioni-preaccettazionesenzacampione-view"> 
<br>
<a href="#" onclick="linkAppPreaccettazioneSIGLA();"><h1 style="color:blue;text-decoration: underline;">App mobile Preaccettazione SIGLA</h1></a>

</dhv:permission>

<dhv:permission name="campioni-campioni-preaccettazionesenzacampione-view"> 
<br>
<a href="#" onclick="linkAppWebGIS();"><h1 style="color:blue;text-decoration: underline;">App mobile WebGIS</h1></a>
<br>
</dhv:permission>


<script>
function linkAppPreaccettazioneSIGLA()
{
	loadModalWindowUnlock();
	window.open('https://play.google.com/store/apps/details?id=com.preaccettazione&hl=it','_blank');
}

function linkAppWebGIS()
{
	loadModalWindowUnlock();
	window.open('https://play.google.com/store/apps/details?id=com.webgis&hl=it','_blank');
}
</script>


<%-- Next section --%>
</td> 

<td valign="top" height="500px">
<table><tr>

<td valign="top" height="500px">
<iframe scrolling="no" src="MyCFS.do?command=PostItVisualizza&tipo=1" id="postit" style="top:0;left: 0;width:auto;height: 200%; border: none; " ></iframe>
</td>
<td valign="top" height="500px">
<iframe scrolling="no" src="MyCFS.do?command=PostItVisualizza&tipo=2" id="postitregione" style="top:0;left: 0;width:auto;height: 200%; border: none; " ></iframe>
</td>
<!-- 
<td valign="top" height="500px">
<iframe scrolling="no" src="MyCFS.do?command=PostItVisualizza&tipo=2" id="postitregione" style="top:0;left: 0;width:auto;height: 200%; border: none; " ></iframe>
</td>

<td valign="top" height="500px">
<iframe scrolling="no" src="MyCFS.do?command=PostItVisualizza&tipo=3" id="postitorsa" style="top:0;left: 0;width:auto;height: 200%; border: none; " ></iframe>
</td>
 -->
</tr></table>
</td>
</tr>
</table>









<br>
<dhv:permission name="myhomepage-miner-view">
<table cellpadding="4" cellspacing="0" width="100%" class="pagedList">
  <tr>
    <td>
      <input type="hidden" name="command" value="Home">
      <table cellpadding="0" cellspacing="0" border="0" width="100%">
    
      </table>
    </td>
  </tr>

</table>
</dhv:permission>

<form name = "home" method="post"></form>
<div id="dialog" title="Dialog Title" style="display: none; height: 900px; width: 900px;" >
<%-- <table>
<tr><td>Nominativo: </td> <td> <%= User.getContactName() %></td></tr>
<tr><td>Codice Fiscale: </td> <td> <input type="text" name="cf" id="cf" value="<%=(User.getUserRecord().getContact().getCodiceFiscale()  != null) ? CfUtil.extractCodiceFiscale(User.getUserRecord().getContact().getCodiceFiscale())  : "" %>"> </td></tr>
</table>
--%>
</div>
  
  <script>
  checkFirefox('<%=LoginBean.getMessage()%>');
  </script>
  
  
  
<!-- INCLUDE PER POPUP MESSAGGIO IMPORTANTE -->
<%-- <%@ include file="popup_messaggio_importante.jsp" %> --%>



