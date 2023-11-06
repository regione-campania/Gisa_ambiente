<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,java.text.DateFormat,org.aspcfs.modules.troubletickets.base.*,com.zeroio.iteam.base.*, org.aspcfs.modules.quotes.base.*,org.aspcfs.modules.base.EmailAddress" %>
<%@page import="org.aspcfs.modules.allerte_new.base.AslCoinvolte"%>
<%@page import="org.aspcfs.modules.allerte_new.base.ListaDistribuzione"%>
<%@page import="org.aspcfs.modules.allerte_new.base.ImpreseCoinvolte"%>
<%@page import="org.aspcfs.modules.campioni.base.Analita"%>
<%@page import="java.util.Date"%>
<%@page import="org.aspcfs.modules.allerte_new.base.Ticket"%><jsp:useBean id="TicketDetails" class="org.aspcfs.modules.allerte_new.base.Ticket" scope="request"/>
<jsp:useBean id="ticketCategoryList" class="org.aspcfs.modules.troubletickets.base.TicketCategoryList" scope="request"/>
<jsp:useBean id="product" class="org.aspcfs.modules.products.base.ProductCatalog" scope="request"/>
<jsp:useBean id="customerProduct" class="org.aspcfs.modules.products.base.CustomerProduct" scope="request"/>
<jsp:useBean id="quoteList" class="org.aspcfs.modules.quotes.base.QuoteList" scope="request"/>
<jsp:useBean id="OrgDetails" class="org.aspcfs.modules.accounts.base.Organization" scope="request"/>
<jsp:useBean id="Provvedimenti" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoAlimento" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Origine" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="AlimentoInteressato" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="NonConformita" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ListaCommercializzazione" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="AltriAlimenti" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="AlimentiNonTrasformati" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="AlimentiNonTrasformatiValori" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="AlimentiTrasformati" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="AlimentiVegetali" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoCampione" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="UnitaMisura" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SanzioniAmministrative" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SanzioniPenali" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Sequestri" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SiteIdList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="causeList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ticketStateList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Regioni" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="resolutionList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="defectCheck" class="java.lang.String" scope="request"/>
<jsp:useBean id="defect" class="org.aspcfs.modules.troubletickets.base.TicketDefect" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="tipoNotifica" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Errore" class="java.lang.String" scope="request"/>


<script language="JavaScript" TYPE="text/javascript" SRC="javascript/confirmDelete.js"></script>


<SCRIPT LANGUAGE="JavaScript" SRC="javascript/CalendarPopup.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">document.write(getCalendarStyles());</SCRIPT>
<SCRIPT LANGUAGE="JavaScript" ID="js19">
	var cal19 = new CalendarPopup();
	cal19.showYearNavigation();
	cal19.showYearNavigationInput();
	cal19.showNavigationDropdowns();
</SCRIPT>

<script>

function openPopupAggiungiLista(id){
  window.open('TroubleTicketsAllerteNew.do?command=AddListaDistribuzione&idAllerta='+id,'popupSelect',
      'height=400px,width=1080px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
	}	


</script>



<script type="text/javascript">

function checkInt( form )
{
	var input		= form.cu.value;
	input 			= input.replace(/\s/g,'');
	input 			= (input.length == 0) ? ( "-1" ) : ( input ) ;
	var ret			= false;
	var int_value	= -1;
	messaggio1 = "" ;
	
	try
	{
		int_value = parseInt( input );
		
		if( int_value > -1 )
		{
			ret = true;
		}
		else
		{
			ret = false;
		}
	}
	catch (e)
	{
		ret = false;
	}


	if( !ret )
	{
		messaggio1+=label("", " - Inserire un valore intero non negativo \n ");
		
		
		
	}
	else
	{

		cuRegione=document.getElementById("cuRegione").value;	
		cuasl=document.getElementById("cu_pianificati").value;
		

		if(cuasl < cuRegione){
			
		if(document.details.motivazione.value==""){

			messaggio1 +=label("", " - Si � scelto di ridurre il numero di controlli pianificati dal nodo regionale.Indicare i motivi");
			ret = false ;

		}
			
		}

		if(ret == false)
		{
			alert( messaggio1 );
		}
		else
		{
			ret = confirm( "Sicuro di Voler Pianificare " + int_value + " C.U.?" );
		}
		

		
		
		
	}
	
	return ret;
}
function mostraMotivo(){

	

	
	cuRegione=document.getElementById("cuRegione").value;	
cuasl=document.getElementById("cu_pianificati").value;


if(cuasl!=""){
if(cuasl==cuRegione){
	
document.getElementById("descr").style.display="none";
	
}else{
	document.getElementById("descr").style.display=""
}

	
}
	
}


function openconfirm(msg,cueseguiti ,idAllerta,chiusuraUfficio,idAslUtente,numero_cu_seguiti,cu_pianificati,tipo_alimenti,specie_alimenti)
{

	window.open('TroubleTicketsAllerteNew.do?command=PupUpConfirmChiusura&msg='+msg+'&cueseguiti='+cueseguiti+'&idAllerta='+idAllerta+'&chiusuraUfficio='+chiusuraUfficio+'&idAslUtente='+idAslUtente+'&numero_cu_seguiti='+numero_cu_seguiti+'&cu_pianificati='+cu_pianificati+'&tipo_alimenti='+tipo_alimenti+'&specie_alimenti='+specie_alimenti,null,
	'height=350px,width=650px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=no,resizable=no ,modal=yes');
	
}

function openchiusuraAllerta(idAllerta)
{
	  window.open('TroubleTicketsAllerteNew.do?command=PrepareChiusuraAllerta&idAllerta='+idAllerta,'popupSelect',
      'height=400px,width=400px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');

	
}


function openchiusuraLista(idLista)
{
	  window.open('TroubleTicketsAllerteNew.do?command=PrepareChiusuraLista&idLista='+idLista,'popupSelect',
      'height=400px,width=400px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');

	
}


function openallegatoF(idAllerta)
{
	  window.open('TroubleTicketsAllerteNew.do?command=PrepareAllegatoF&idAllerta='+idAllerta,'popupSelect',
      'height=400px,width=400px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');

	
}


function showInserimentoNumeroNotifica(val){
	if (val=='1'){
		document.getElementById("divInsertNumeroNotifica").style.display="none";
		document.getElementById("divNumeroNotifica").style.display="block";
	} else {
		document.getElementById("divInsertNumeroNotifica").style.display="block";
		document.getElementById("divNumeroNotifica").style.display="none";
	}

}

function inserisciNumeroNotifica(form, idAllerta){
	 
	var numero = document.getElementById("numeroNotifica").value;
	
	if (numero== null || trim(numero) == ''){
		alert('Attenzione. Compilare il campo Numero notifica.');
		return false;
	}
		
	if (confirm("La modifica al numero notifica sar� salvata. Proseguire?")){
		loadModalWindow();
	
		form.action = 'TroubleTicketsAllerteNew.do?command=InsertNumeroNotifica&idAllerta='+idAllerta;
		form.submit();
	}
	
}

</script>

<script>


$(document).ready(function() {	

	
	//select all the a tag with name equal to modal
	$('a[name=modal]').click(function(e) {
		//Cancel the link behavior
		e.preventDefault();
		
		//Get the A tag
		var id = $(this).attr('href');
	
		//Get the screen height and width
		var maskHeight = $(document).height();
		var maskWidth = $(window).width();
	
		//Set heigth and width to mask to fill up the whole screen
		$('#mask').css({'width':maskWidth,'height':maskHeight});
		
		//transition effect		
		$('#mask').fadeIn(1000);	
		$('#mask').fadeTo("slow",0.8);	
	
		//Get the window height and width
		var winH = $(window).height();
		var winW = $(window).width();
              
		//Set the popup window to center
		$(id).css('top',  winH/2-$(id).height()/2);
		$(id).css('left', winW/2-$(id).width()/2);
	
		//transition effect
		$(id).fadeIn(2000); 
	
	});
	
	//if close button is clicked
	$('.window .close').click(function (e) {
		//Cancel the link behavior
		e.preventDefault();
		
		$('#mask').hide();
		$('.window').hide();
	});		
	
	//if mask is clicked
	$('#mask').click(function () {
		$(this).hide();
		$('.window').hide();
	});			
	
});

</script>
<style>
body {
font-family:verdana;
font-size:15px;
}

a {color:#333; text-decoration:none}
a:hover {color:#ccc; text-decoration:none}

#mask {
  position:absolute;
  left:0;
  top:0;
  z-index:9000;
  background-color:#000;
  display:none;
}
  
#boxes .window {
  position:absolute;
  left:0;
  top:0;
  width:675px;
  height:358;
  display:none;
  z-index:9999;
  padding:20px;
}

#boxes #dialog {
  width:675px; 
  height:380;
  padding:10px;
  background-color:#ffffff;
}

 #dialog4 {
  width:675px; 
  height:380;
  padding:10px;
  background-color:#ffffff;
}

 #dialog5 {
  width:675px; 
  height:380;
  padding:10px;
  background-color:#ffffff;
}

#boxes #dialog1 {
  width:375px; 
  height:203px;
}

#dialog1 .d-header {
  background:url(images/login-header.png) no-repeat 0 0 transparent; 
  width:375px; 
  height:150px;
}

#dialog1 .d-header input {
  position:relative;
  top:60px;
  left:100px;
  border:3px solid #cccccc;
  height:22px;
  width:200px;
  font-size:15px;
  padding:5px;
  margin-top:4px;
}

#dialog1 .d-blank {
  float:left;
  background:url(images/login-blank.png) no-repeat 0 0 transparent; 
  width:267px; 
  height:53px;
}

#dialog1 .d-login {
  float:left;
  width:108px; 
  height:53px;
}

#boxes #dialog2 {
  background:url(images/notice.png) no-repeat 0 0 transparent; 
  width:326px; 
  height:229px;
  padding:50px 0 20px 25px;
}
</style>

<div id="boxes">

<%-- IL CAMPO SRC � DA AGGIUSTARE --%>
<div id="dialog4" class="window" width="600" height="380">
  <jsp:include page="view_data.jsp"/>
</div>

<div id="dialog5" class="window" width="600" height="380">
  <jsp:include page="view_data_lista.jsp"/>
</div>

<%-- <iframe id="dialog" class="window" src="TroubleTicketsAllerteNew.do?command=DownloadAllegatoFRegione&id=<%=TicketDetails.getId() %>" width="600" height="380"> --%>
<!--   <a href="#"class="close"/>Close it</a> -->
<!-- </iframe> -->


<!-- Mask to cover the whole screen -->
  <div id="mask"></div>

</div>

<%@ include file="../initPage.jsp" %>

<%if( User.getSiteId() > 0 ) {%>

<body>

<%} 

%>

<% if (Errore!=null && !Errore.equals("")){ %>
<font color="red"><%=Errore %></font>
<% } %>


<form name="details" action="TroubleTicketsAllerteNew.do?command=Modify&auto-populate=true" method="post">
<%-- Trails --%>
<input type="hidden" name = "risposta" id = "risposta">
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="TroubleTicketsAllerteNew.do"><dhv:label name="sanzioniss">Allerta</dhv:label></a> >
<%
	if (defectCheck != null && !"".equals(defectCheck.trim())) {
%>
  <a href="TroubleTicketDefects.do?command=View"><dhv:label name="tickets.defects.viewDefects">View Defects</dhv:label></a> >
  <a href="TroubleTicketDefects.do?command=Details&defectId=<%= defectCheck %>"><dhv:label name="tickets.defects.defectDetails">Defect Details</dhv:label></a> >
<%
  	} else {
  %>
<%
	if ("yes"
				.equals((String) session.getAttribute("searchTickets"))) {
%>
  <a href="TroubleTicketsAllerteNew.do?command=SearchTicketsForm"><dhv:label name="tickets.searchForm">Search Form</dhv:label></a> >
  <a href="TroubleTicketsAllerteNew.do?command=SearchTickets"><dhv:label name="accounts.SearchResults">Search Results</dhv:label></a> >
<%
  	} else {
  %> 
  <a href="TroubleTicketsAllerteNew.do?command=Home"><dhv:label name="sanzioni.visualizzaee">Visualizza Allerte</dhv:label></a> >
<%
   	}
   %>
<%
	}
%>


<dhv:label name="sanzioni.dettagliss">Scheda Allerte</dhv:label>
</td>
</tr>
</table>
<%-- End Trails --%>
<%
	String param1 = "id=" + TicketDetails.getId();
%>
<dhv:container name="allerte" selected="details" object="TicketDetails"
	param="<%= param1 %>"
	hideContainer='<%= isPopup(request) || (defectCheck != null && !"".equals(defectCheck.trim())) %>'>
	<%--@ include file="ticket_header_include.jsp"--%>
	<%
		if (TicketDetails.isTrashed()) {
	%>
	<dhv:permission name="allerte-allerte-delete">
		<input type="button"
			value="<dhv:label name="button.restore">Restore</dhv:label>"
			onClick="javascript:this.form.action='TroubleTicketsAllerteNew.do?command=Restore&id=<%= TicketDetails.getId()%>';submit();">
	</dhv:permission>
	<%
		} else if (TicketDetails.getDataChiusura() != null) {
	%>
	
	
	
	<%
		} else {
	%>
	
	<% if (TicketDetails.getResolutionDate()==null ) { %>
	<dhv:permission name="allerte-allerte-edit">
		<input type="button"
			value="<dhv:label name="global.button.modify">Modify</dhv:label>"
			onClick="javascript:this.form.action='TroubleTicketsAllerteNew.do?command=Modify&auto-populate=true<%= (defectCheck != null && !"".equals(defectCheck.trim())?"&defectCheck="+defectCheck:"") %>';submit();">
	</dhv:permission>
	
<%-- 	<dhv:permission name="allerte-allerte-edit"> --%>
<!-- 		<input type="button" -->
<%-- 			value="<dhv:label name="g">Ripianifica</dhv:label>" --%>
<%-- 			onClick="javascript:this.form.action='TroubleTicketsAllerte.do?command=Modify&ripianifica=true&auto-populate=true<%= (defectCheck != null && !"".equals(defectCheck.trim())?"&defectCheck="+defectCheck:"") %>';submit();"> --%>
<%-- 	</dhv:permission> --%>
	
	
	<dhv:permission name="allerte-allerte-edit">
		<input type="button"
			value="<dhv:label name="g">Ripianifica</dhv:label>"
onClick="javascript:this.form.action='TroubleTicketsAllerteNew.do?command=PrepareRipianifica&id=<%=TicketDetails.getId() %>';loadModalWindow();submit();">
	</dhv:permission>
	<%} %>
	
	
	<dhv:permission name="allerte-allerte-delete">
		<%
			if ("searchResults".equals(request
								.getParameter("return"))) {
		%>
		<input type="button"
			value="<dhv:label name="global.button.delete">Delete</dhv:label>"
			onClick="javascript:popURL('TroubleTicketsAllerteNew.do?command=ConfirmDelete&id=<%= TicketDetails.getId() %>&return=searchResults&popup=true', 'Delete_ticket','520','200','yes','no');">
		<%
			} else {
		%>
		<input type="button"
			value="<dhv:label name="global.button.delete">Delete</dhv:label>"
			onClick="javascript:popURL('TroubleTicketsAllerteNew.do?command=ConfirmDelete&id=<%= TicketDetails.getId() %>&popup=true', 'Delete_ticket','520','200','yes','no');">
		<%
			}
		%>
	</dhv:permission>
	
	<% if (TicketDetails.getResolutionDate()==null ) { %>
	<dhv:permission name="allerte-allerte-chiusura-view">
	<input type="button" value="Chiusura Allerta" onclick="openchiusuraAllerta(<%=TicketDetails.getId() %>)"/>
	</dhv:permission>
	<%} else { %>
	
	ALLERTA CHIUSA 
	

	
	<% } %>

	
		<% if (TicketDetails.getListaCommercializzazione()!=2 || 1==1){ %>
<%@ include file="allertedocumenti/prepareAllegatoF.jsp" %>
		<br/> 	<br/> 
	<%} %>
	
	<%-- if(User.getSiteId() == -1){%>
	<%if( TicketDetails.isChiudibile( User.getSiteId() ) ){ 
		 %>
		<input 
			type="button" 
			value="Chiusura Allerta per Tutte le Asl"
		onclick="openchiusuraAllerta(<%=cuEseguiti %>, <%=TicketDetails.getId() %>,0,<%=User.getSiteId() %>,0,0)"/>
		 
		 
	<%}else{
		
		if(TicketDetails.getDataChiusura()==null){
		//TroubleTicketsAllerte.do?command=ChiudiAllerta&chiusuraUfficio=1&id=<%=TicketDetails.getId() %>
		
		<input 
			type="button" 
			value="Chiusura Forzata Allerta Per Tutte le Asl"
			onclick="openchiusuraAllerta(<%=cuEseguiti %>, <%=TicketDetails.getId() %>,1,<%=User.getSiteId() %>,0,0)"/>
			
		<%
		}
	}
	}else{

	%>
	<%if( TicketDetails.isChiudibile( User.getSiteId() ) ){ 
		 %>

		<input 
			type="button" 
			value="Chiusura Allerta e Invio Allegato F"
					
		onclick="openchiusuraAllerta(<%=cuEseguiti %>, <%=TicketDetails.getId() %>,0,<%=User.getSiteId() %>,0,<%=cupianificati %>)"/>
		 
	<%}else{
		
		if(TicketDetails.getAslCoinvolta(User.getSiteId()).getData_chiusura() ==null){
		
		<input 
			type="button" 
			value="Chiusura Forzata Allerta e Invio Allegato F"
		onclick="openchiusuraAllerta(<%=cuEseguiti %>, <%=TicketDetails.getId() %>,1,<%=User.getSiteId() %>,<%=ac3.getCu_eseguiti()%>,<%=cupianificati %>)"/>
		
		
		<%
		}
	}
	
	} --%>
	
	
	
	
	
	
	
	
	
	<%
		}
	%>
	

<%--
if( User.getSiteId() > 0 ) {

%>

<dhv:permission name="allerte-allerte-chiusura-view">
<input type = "button" value = "Scarica Allegato F" onclick="javascript : document.details.action ='TroubleTicketsAllerte.do?command=DownloadAllegatoF&tipo_file=pdf&ticketid=<%=TicketDetails.getId() %>'; document.details.submit() ">
</dhv:permission>
&nbsp;&nbsp;
<!-- 				<a  href="#dialog4" name = "modal" onclick="document.getElementById('dialog').src=''+document.getElementById('dialog').src+'&tipoAlimenti='+document.getElementById('tipoAlimenti').value+'&specie_alimenti='+document.getElementById('specie_alimenti').value">Legenda</a> -->
		

<%
}
else
{
	
		%>

		
		<dhv:permission name="allerte-allerte-chiusura-view">

				<a  href="#dialog" name = "modal" onclick="document.getElementById('dialog').src=''+document.getElementById('dialog').src+'&tipoAlimenti='+document.getElementById('tipoAlimenti').value+'&specie_alimenti='+document.getElementById('specie_alimenti').value">Scarica Allegato F</a>
		
		</dhv:permission>
		&nbsp;&nbsp;
	
		
		<%
	
}
--%>

		


<%

	int size = SiteIdList.size();
%>
<% if (TicketDetails.getListaCommercializzazione()==2){%>

<% Hashtable<Integer,ListaDistribuzione> liste= TicketDetails.getListe_distribuzione();
	Iterator<Integer> it=liste.keySet().iterator();
	int ldd=0;
	while(it.hasNext()){
	ldd=it.next();
	ListaDistribuzione lista = (ListaDistribuzione) liste.get(ldd);
		
	%>
	<table cellpadding="4" cellspacing="0" width="100%" class="details">
	<tr><th colspan="2">Info allerta</th></tr>
	<tr class="containerBody"><td nowrap class="formLabel"> Lista di distribuzione	</td>
	<td>SENZA</td>
	</tr>
	<tr class="containerBody"><td nowrap class="formLabel"> ASL Coinvolte	</td>
	<td><%=lista.getAsl_coinvolteAsString() %></td>
	</tr>
	</table>
	
	
	<%@ include file="tabella_info_cu2.jsp" %>

	<br/>
	<%}%>

<%} else { %>

	<table cellpadding="4" cellspacing="0" width="100%" class="details">
	<tr><th colspan="2">Info allerta</th></tr>
	<tr class="containerBody"><td nowrap class="formLabel"> Lista di distribuzione	</td>
	<td>CON</td>
	</tr>
	</table>
<br/>
<% Hashtable<Integer,ListaDistribuzione> liste= TicketDetails.getListe_distribuzione();
	Iterator<Integer> it=liste.keySet().iterator();
	int ldd=0;
	while(it.hasNext()){
	ldd=it.next();
	ListaDistribuzione lista = (ListaDistribuzione) liste.get(ldd);
	%>
	
	<table cellpadding="4" cellspacing="0" width="100%" class="details">
	<tr><th colspan="2">LISTA DI DISTRIBUZIONE <%=ldd %> 
		
	</th></tr>
	
	<tr class="containerBody"><td nowrap class="formLabel"> Data lista	</td>
	<td><%=toDateasString(lista.getData_lista()) %></td>
	</tr>
	<tr class="containerBody"><td nowrap class="formLabel"> Data chiusura	</td>
	<td><%=toDateasString(lista.getData_chiusura()) %>  <%= (lista.isChiusura_forzata()) ? "<font color=\"red\">CHIUSURA FORZATA</font>" : "" %> </td>
	</tr>
	<tr class="containerBody"><td nowrap class="formLabel"> Nome fornitore	</td>
	<td><%=((lista.getNome_fornitore()!=null && !lista.getNome_fornitore().equals("null")) ? lista.getNome_fornitore() : "") %></td>
	</tr>
	<tr class="containerBody"><td nowrap class="formLabel"> ASL Coinvolte	</td>
	<td><%=(lista.getAsl_coinvolteAsString() != null ? lista.getAsl_coinvolteAsString() : "") %></td>
	</tr>
	</table>
	
	
	
	
	
<%@ include file="tabella_info_cu2.jsp" %>
	
			
<%}%>

<%} %>





	<table cellpadding="4" cellspacing="0" width="100%" class="details">
	<tr><%if(session.getAttribute("problemaInvioMail")!=null && session.getAttribute("problemaInvioMail").equals("si")){
%>
<p><font color="red">Attenzione! L'allerta � stata inserita/modificata correttamente ma non � stato possibile inviare i messaggi di PEC.</font></p>
<%} %>
	</tr>
		<tr>
			<th colspan="<%=(User.getSiteId()!=-1)?("2"):(size)  %>"><strong><dhv:label
				name="sanzioni.informationxx">Scheda Allerta</dhv:label></strong></th>
		</tr>
		
		
<%-- 		<%if(ListaCommercializzazione.size() > 1) {%> --%>
<!-- 				<tr class="containerBody"> -->
<%-- 					<td nowrap class="formLabel"><dhv:label --%>
<%-- 						name="stabilimenti.sitefff">Lista di Distribuzione</dhv:label></td> --%>
<%-- 					<td colspan="<%=size %>"><%=ListaCommercializzazione.getSelectedValue(TicketDetails --%>
<%-- 										.getListaCommercializzazione())%> --%>
<!-- 					 <input type="hidden" -->
<%-- 						name="siteId" value="<%=TicketDetails.getListaCommercializzazione()%>"></td> --%>
<!-- 		</tr> -->
<%--         <%} %> --%>
		<% if(TicketDetails.getDataChiusura() != null && TicketDetails.isChiusuraUfficio()) {%>
			<tr class="containerBody">
					<td nowrap class="formLabel">Esito accertamenti finali</td>
					<td colspan="<%=size %>"><%= "Allerta Chiusa in quanto Rientrata" %>
					</td>
				</tr>
		
		<%} %>
		
		
		
<%-- 		<dhv:include name="" none="true"> --%>
<%-- 			<dhv:evaluate if="<%= SiteIdList.size() > 1 %>"> --%>
<!-- 				<tr class="containerBody"> -->
<!-- 					<td nowrap class="formLabel">A.S.L. Coinvolte</td> -->
<%-- 					<td colspan="<%=size %>"><%= TicketDetails.getAsl_coinvolteAsString() %> --%>
<!-- 					 <input type="hidden" -->
<%-- 						name="siteId" value="<%=TicketDetails.getSiteId()%>"></td> --%>
<!-- 				</tr> -->
<%-- 			</dhv:evaluate> --%>
<%-- 			<dhv:evaluate if="<%= SiteIdList.size() <= 1 %>"> --%>
<!-- 				<input type="hidden" name="siteId" id="siteId" value="-1" /> -->
<%-- 			</dhv:evaluate> --%>
<%-- 		</dhv:include> --%>
	
	
  		<input type="hidden" name="id" id="id" value="<%=  TicketDetails.getId() %>" />
		<input type="hidden" name="orgId" id="orgId"
			value="<%=  TicketDetails.getOrgId() %>" />
 <%if(TicketDetails.getDataApertura() != null) {
 
 %>
		<tr class="containerBody">
			<td nowrap class="formLabel"><dhv:label
				name="sanzioni.data_richiestass">Data Apertura</dhv:label></td>
			<td colspan="<%=size %>">
			  <zeroio:tz timestamp="<%= TicketDetails.getDataApertura() %>" dateOnly="true" timeZone="<%= TicketDetails.getAssignedDateTimeZone() %>" showTimeZone="false" default="&nbsp;"/>
	
            </td>
		</tr>
 <%} %>
 
 <%if(TicketDetails.getDataChiusura()!=null) {%>
 
 <tr class="containerBody">
			<td nowrap class="formLabel"><dhv:label
				name="sanzioni.data_richiestass">Data Chiusura</dhv:label></td>
			<td colspan="<%=size %>">
			<zeroio:tz timestamp="<%= TicketDetails.getDataChiusura() %>" dateOnly="true" timeZone="<%= TicketDetails.getAssignedDateTimeZone() %>" showTimeZone="false" default="&nbsp;"/>
	
            </td>
		</tr>
 
 <%} %>
 
 <%if(TicketDetails.getIdAllerta() != null) {%>
 <tr class="containerBody">
    <td valign="top" class="formLabel">
      <dhv:label name="">Identificativo Allerta</dhv:label>
    </td>
    <td colspan="<%=size %>">
         <%= TicketDetails.getIdAllerta() %>
    </td> 
    </tr>
 <%} %>
 
 


<tr class="containerBody">
      <td name="orig"  nowrap class="formLabel">
        <dhv:label name="">Comunitaria</dhv:label>
      </td>
     <td colspan="<%=size %>">
      <input type = "checkbox" disabled="disabled" <%if(TicketDetails.isFlagTipoAllerta()==true){%>checked="checked"<%}%> name = "flag_pubblicazione_allerte"/>
      </td>
      
      
 </tr>
 
 
 <tr class="containerBody">
    <td valign="top" class="formLabel">
      <dhv:label name="">Unit� di Misura per Quantita</dhv:label>
    </td>
    <td colspan="<%=size %>">
         <%=UnitaMisura.getSelectedValue(TicketDetails.getUnitaMisura()) %>
    </td> 
    </tr>
 
  <tr class="containerBody">
    <td valign="top" class="formLabel">
      <dhv:label name=""> Tipo Notifica</dhv:label>
    </td>
    <td colspan="<%=size %>">
         <%=tipoNotifica.getSelectedValue(TicketDetails.getTipo_notifica_allerta()) %>
     </td> 
    </tr>
<tr class="containerBody">
    <td valign="top" class="formLabel">
      <dhv:label name=""> Numero Notifica</dhv:label>
    </td>
    <td colspan="<%=size %>">
        <div id="divNumeroNotifica"><%=toHtmlValue(TicketDetails.getNumero_notifica_allerta()) %> 
        
        <dhv:permission name="allerte-allerte-numeronotifica-add">
        <%if (TicketDetails.getNumero_notifica_allerta()==null || TicketDetails.getNumero_notifica_allerta().equals("")){ %>
        <input type="button" value="inserisci" onClick="showInserimentoNumeroNotifica(0)"/>
        <%} %>
        </dhv:permission>
        
         </div>
        <div id="divInsertNumeroNotifica" style="display:none">
        <input type="text" id="numeroNotifica" name="numeroNotifica" value="" maxlength="10"/> <input type="button" value="salva" onClick="inserisciNumeroNotifica(this.form, '<%=TicketDetails.getId()%>')"/> 
         <a href="#" onClick="showInserimentoNumeroNotifica(1);return false;"><b>Annulla</b></a>
        </div>
    </td> 
    </tr>
	    	
	    	
 

		 <%if(TicketDetails.getProgressivoAllerta() > -1) { %>
       <tr class="containerBody">
			<td nowrap class="formLabel"><dhv:label
				name="sanzioni.data_richiestass">Progressivo Allerta</dhv:label></td>
			<td colspan="<%=size %>">
				<%= toHtmlValue(TicketDetails.getProgressivoAllerta()) %>
            </td>
		</tr> 
       <%} %>

	
		<%if(Origine.size() > 1) {%>
				<tr class="containerBody">
					<td nowrap class="formLabel"><dhv:label
						name="stabilimenti.sitefff">Origine</dhv:label></td>
					<td colspan="<%=size %>"><%=Origine.getSelectedValue(TicketDetails
										.getOrigine())%>
					 <input type="hidden"
						name="siteId" value="<%=TicketDetails.getOrigine()%>">
						&nbsp;&nbsp;&nbsp;
						<%if(TicketDetails.getOrigineAllerta()>-1)
						{
							if(TicketDetails.getOrigine()==1 || TicketDetails.getOrigine()==2){
						%>
						
						Origine da Asl: <%=SiteIdList.getValueFromId(TicketDetails.getOrigineAllerta()) %>
						<%}else{
						
						%>
							Origine da Regione: <%=Regioni.getValueFromId(TicketDetails.getOrigineAllerta()) %>
						
						<%} 
						
						}
						%>
						
						</td>
		</tr>
        <%} %>
 <%if(TicketDetails.isFlag_produzione()==true){%>


<tr class="containerBody">
      <td name="orig"  nowrap class="formLabel">
        <dhv:label name="">Pubblicazione</dhv:label>
      </td>
     <td colspan="<%=size %>">
      <input type = "checkbox" disabled="disabled" <%if(TicketDetails.isFlag_produzione()==true){%>checked="checked"<%} %> name = "flag_pubblicazione_allerte" onclick="abilitapubblicazione(this)"/>
      </td>
      
      
 </tr>
  <tr class="containerBody">
      <td name="orig"  nowrap class="formLabel">
        <dhv:label name="">Data Inizio pubblicazione</dhv:label>
      </td>
    <td colspan="<%=size %>">
      
      <%=TicketDetails.getData_inizio_pubblicazioneString() %>
      </td>
      
      
 </tr>
 <tr class="containerBody">
      <td name="orig"  nowrap class="formLabel">
        <dhv:label name="">Data Fine pubblicazione</dhv:label>
      </td>
    <td colspan="<%=size %>">
      
      <%=TicketDetails.getData_fine_pubblicazioneString() %>
      </td>
      
      
 </tr>
 
 <tr class="containerBody">
      <td name="orig"  nowrap class="formLabel">
        <dhv:label name="">Tipo di Rischio</dhv:label>
      </td>
   
      
      <td colspan="<%=size %>">  
       <textarea rows="5" cols="30" name = "tipo_rischio_allerte" readonly="readonly"><%=TicketDetails.getTipo_rischio() %></textarea>
      </td>
      
      
 </tr>
 
 <tr class="containerBody">
      <td name="orig"  nowrap class="formLabel">
        <dhv:label name="">Provvedimenti/Esito Accertamenti</dhv:label>
      </td>
    
      
      <td colspan="<%=size %>">  
     <textarea rows="5" cols="30" name = "provvedimenti_esito_allerte" readonly="readonly"><%=TicketDetails.getProvvedimento_esito() %></textarea>
      </td>
      
      
 </tr>
 


          
   <%} %>
	
	<%ArrayList<Analita> tipi_a= TicketDetails.getTipi_Campioni(); %>
	
	<% if(tipi_a.isEmpty()) {	%>   
	<tr class="containerBody">
	<td nowrap class="formLabel"><dhv:label
		name="stabilimenti.sitefff">Azione non conforme Per</dhv:label></td>
					 <td colspan="<%=size %>">
    <table class="noborder">
    <tr>
    <td>
    
    <% if (TicketDetails.getTipoCampione()>0){ %>
    
      <%="<b>- Tipo di Esame:</b> "+TipoCampione.getSelectedValue(TicketDetails
    		  .getTipoCampione())%>
					<input type="hidden" name="provvedimenti"
						value="<%=TicketDetails.getTipoCampione() %>">
						
						
					
						
						
						<%
						HashMap<Integer,String> tipi= TicketDetails.getTipiCampioni();
						
						if(TicketDetails.getTipoCampione()==5){
							
							Iterator<Integer> set=tipi.keySet().iterator();
							int kiave=0;
							out.print("<br><b> - Ricerca di: </b>");
							while(set.hasNext()){
							 kiave=set.next();
								out.print(tipi.get(kiave)+", ");
						
							}
						
							HashMap<Integer,String> tipiChimici=TicketDetails.getTipiChimiciSelezionati();
							Iterator<Integer> set1=tipiChimici.keySet().iterator();
							int kiave1=0;
							out.print("<br><b>- Per:</b> ");
							while(set1.hasNext()){
								 kiave1=set1.next();
								out.print(""+tipiChimici.get(kiave1)+",");
						
							}
							
						}else{
						
						Iterator<Integer> set=tipi.keySet().iterator();
						while(set.hasNext()){
							int kiave=set.next();
							out.print("<br><b> - Ricerca di:</b> "+tipi.get(kiave)+",");
							
							}
							}
						
						%></br>
						<%="<b>- Descrizione: </b>"+ TicketDetails.getNoteAnalisi() %>
						
						
			<% } %>			
						</td>
					</tr>
			</table>
    </td>
  </tr>
		
	<% } else { %>
		 <tr class="containerBody">
		    <td valign="top" class="formLabel">
		      <dhv:label name="sanzioni.note">Azione non conforme per</dhv:label>
		    </td>
		    <td>
		    <table class="noborder">
		    <%	    
	
						int i=0 ;
						for(Analita a : tipi_a)
						{
							i++ ;
							int chiave = a.getIdAnalita();
							String descrizione = a.getDescrizione();
							out.print("<tr><td> "+i+") "+descrizione+"</td>");
						
						}
						%>
			<input type="hidden" id="numeroAnaliti" name="numeroAnaliti" value="<%=i%>">
						
			<tr><td><% if(TicketDetails.getNoteAnalisi() != null && !TicketDetails.getNoteAnalisi().equals("")) { %>
				<%="Note : "+TicketDetails.getNoteAnalisi() %>
				<% } else { %>
					<%="Note : N.D"%>
					<% } %>
			</td></tr>
		</table>
    </td>
  </tr>
  <% } %>
        

		<dhv:evaluate if="<%= hasText(TicketDetails.getProblem()) %>">
			<tr class="containerBody">
				<td class="formLabel" valign="top"><dhv:label
					name="sanzioni.note">Note</dhv:label></td>
				<td colspan="<%=size %>" valign="top">
				<%
					//Show audio files so that they can be streamed
							Iterator files = TicketDetails.getFiles().iterator();
							while (files.hasNext()) {
								FileItem thisFile = (FileItem) files.next();
								if (".wav".equalsIgnoreCase(thisFile.getExtension())) {
				%> <a
					href="TroubleTicketsDocuments_asl.do?command=Download&stream=true&tId=<%= TicketDetails.getId() %>&fid=<%= thisFile.getId() %>"><img
					src="images/file-audio.gif" border="0" align="absbottom"><dhv:label
					name="tickets.playAudioMessage">Play Audio Message</dhv:label></a><br />
				<%
					}
							}
				%> <%=toHtml(TicketDetails.getProblem())%> <input type="hidden"
					name="problem" value="<%=toHtml(TicketDetails.getProblem())%>">
				</td>
			</tr>
		</dhv:evaluate>
		<dhv:evaluate if="<%= hasText(TicketDetails.getCause()) %>">
			<tr class="containerBody">
				<td valign="top" class="formLabel"><dhv:label
					name="sanzioni.importo">Importo da Pagare (euro)</dhv:label></td>
				<td colspan="<%=size %>"><%=toHtmlValue(TicketDetails.getCause())%> <input
					type="hidden" name="importo" id="orgId"
					value="<%=  TicketDetails.getCause() %>" /></td>
			</tr>
		</dhv:evaluate>
		<dhv:evaluate if="<%= hasText(TicketDetails.getSolution()) %>">
			<tr class="containerBody">
				<td valign="top" class="formLabel"><dhv:label
					name="sanzioni.azioni">Ulteriori Azioni</dhv:label></td>
				<td colspan="<%=size %>"><%=toString(TicketDetails.getSolution())%><%-- </textarea>--%></td>
			</tr>
		</dhv:evaluate>
		
		<dhv:include name="" none="true">
			<dhv:evaluate
				if="<%= TicketDetails.getSanzioniAmministrative() > -1 %>">
				<tr class="containerBody">
					<td nowrap class="formLabel"><dhv:label name="">Sanzioni Amministrative</dhv:label>
					</td>
					<td colspan="<%=size %>"><%=SanzioniAmministrative
										.getSelectedValue(TicketDetails
												.getSanzioniAmministrative())%>
					<dhv:evaluate if="<%= TicketDetails.getSanzioniAmministrative() == 9%>">
						&nbsp; Descrizione:&nbsp;<%= TicketDetails.getDescrizione2()%>
					</dhv:evaluate>
					<input type="hidden" name="sanzioniamm"
						value="<%=TicketDetails.getSanzioniAmministrative() %>">
					</td>
				</tr>
			</dhv:evaluate>
		</dhv:include>
		<dhv:include name="" none="true">
			<dhv:evaluate if="<%= TicketDetails.getSanzioniPenali() > -1 %>">
				<tr class="containerBody">
					<td nowrap class="formLabel"><dhv:label name="">Sanzioni Penali</dhv:label>
					</td>
					<td colspan="<%=size %>"><%=SanzioniPenali.getSelectedValue(TicketDetails
										.getSanzioniPenali())%>
					<dhv:evaluate if="<%= TicketDetails.getSanzioniPenali() == 6 %>">
										&nbsp; Descrizione:&nbsp;<%= TicketDetails.getDescrizione3()%>
					</dhv:evaluate>
					<input type="hidden" name="sanzionipen"
						value="<%=TicketDetails.getSanzioniPenali() %>"></td>
				</tr>
			</dhv:evaluate>
		</dhv:include>
		<dhv:include name="" none="true">
			<dhv:evaluate if="<%= (TicketDetails.getTipoSequestro() != false ) || (TicketDetails.getTipoSequestroDue() != false) || (TicketDetails.getTipoSequestroTre() != false) || (TicketDetails.getTipoSequestroQuattro() != false) %>">
		     <tr class="containerBody">
					<td nowrap class="formLabel"><dhv:label name="">Sequestri</dhv:label>
					</td>
					<td colspan="<%=size %>">
					 <% if(TicketDetails.getTipoSequestro() == true) {%>
					  Alimenti <input type="checkbox" checked disabled> <%} %>
					  <% if(TicketDetails.getTipoSequestroDue() == true) {%>
					  Attrezzature <input type="checkbox" checked disabled> <%} %>
					  <% if(TicketDetails.getTipoSequestroTre() == true) {%>
					  Locale <input type="checkbox" checked disabled> <%} %>
					  <% if(TicketDetails.getTipoSequestroQuattro() == true) {%>
					  Stabilimento <input type="checkbox" checked disabled> <%} %>
					</td>
				</tr>
			</dhv:evaluate>
		</dhv:include>			  
		
		
		<dhv:include name="ticket.defect" none="false">
			<tr class="containerBody">
				<td class="formLabel"><dhv:label name="tickets.defects.defect">Defect</dhv:label>
				</td>
				<td colspan="<%=size %>"><%=toHtml(defect.getTitle())%> <dhv:evaluate
					if="<%= hasText(defect.getTitle()) && defect.isDisabled() %>">(X)</dhv:evaluate>
				</td>
			</tr>
		</dhv:include>


		
		<tr class="containerBody">
			<td class="formLabel"><dhv:label
				name="accounts.accounts_calls_list.Entered">Entered</dhv:label></td>
			<td colspan="<%=size %>"><dhv:username id="<%= TicketDetails.getEnteredBy() %>" /> <zeroio:tz
				timestamp="<%= TicketDetails.getEntered() %>"
				timeZone="<%= User.getTimeZone() %>" showTimeZone="false" /></td>
		</tr>
		<tr class="containerBody">
			<td class="formLabel"><dhv:label
				name="accounts.accounts_contacts_calls_details.Modified">Modified</dhv:label>
			</td>
			<td colspan="<%=size %>"><dhv:username id="<%= TicketDetails.getModifiedBy() %>" /> <zeroio:tz
				timestamp="<%= TicketDetails.getModified() %>"
				timeZone="<%= User.getTimeZone() %>" showTimeZone="false" /></td>
		</tr>
		<%if(TicketDetails.getResolutionDate() != null) { %>
		<tr class="containerBody">
			<td class="formLabel"><dhv:label
				name="">Data definitiva di trasmissione dati</dhv:label>
			</td>
			<td colspan="<%=size %>"><dhv:username id="<%= TicketDetails.getResolvedBy()>0 ? TicketDetails.getResolvedBy() : TicketDetails.getModifiedBy()%>" /> 
			<%= getLongDate(TicketDetails.getResolutionDate()) %>
				
				<%= (TicketDetails.isChiusuraUfficio()) ? "<font color=\"red\">CHIUSURA FORZATA</font>" : "" %> 
				<%= (TicketDetails.isChiusuraUfficio()) ? " [NOTE]: "+ TicketDetails.getNote_motivazione() : "" %> 
				
				</td>
		</tr>
		<% } %>
	</table>
	
	<br><br>
	
	
	<table cellpadding="4" cellspacing="0" width="100%" class="details">
	
	<tr>
				<th colspan="2"><strong><dhv:label name="">Oggetto della Allerta</dhv:label></strong>
				</th>
			</tr>
	
	<tr class="containerBody">
      <td id="" nowrap class="formLabel">
        <dhv:label name="">Descrizione Breve</dhv:label>
      </td>
  <td>
  <%=toHtml(TicketDetails.getDescrizioneBreve()) %>
   </td>
	</tr>
	
	
	<% HashMap<Integer,String> matrici= TicketDetails.getMatrici();
		String tipoAlimenti = "" ;
	    String specie_alimenti = "" ;
		if(matrici.isEmpty()) {
	%>   
		<%@ include file="../tipi_alimenti_details.jsp" %>
		
	<% } else { %>
		 <tr class="containerBody">
    <td valign="top" class="formLabel">
      <dhv:label name="sanzioni.note">Matrice</dhv:label>
    </td>
    <td>
    <table class="noborder">
    
						<%
						
						Iterator<Integer> itMatrici = matrici.keySet().iterator();
						int i = 0 ;
						while(itMatrici.hasNext())
						{
							i++ ;
							int chiave = itMatrici.next();
							String descrizione = TicketDetails.getMatrici().get(chiave);
							out.print("<tr><td> "+i+") "+descrizione+"</td></tr>");
							tipoAlimenti += "Matrice ";
							specie_alimenti += descrizione;
						}
						%>
						<% if(i==0){%>
							N.D
						<% } %>
			<tr>
			<td>
				<% if(TicketDetails.getNoteAlimenti()!=null && ! "".equals(TicketDetails.getNoteAlimenti()) ){%>
						NOTE : <%=TicketDetails.getNoteAlimenti() %> 
				<% } else { %>
					<b>Note: </b>N.D
				<% } %>
			</td></tr>
		</table>
</td></tr>
	<% } %>
	
	<input type = "hidden" name = "tipoAlimenti" id = "tipoAlimenti" value = "<%=tipoAlimenti %>">
	<input type = "hidden" name = "specie_alimenti" id = "specie_alimenti" value = "<%=specie_alimenti %>">
       
       <tr class="containerBody">
    <td valign="top" class="formLabel">
      Denominazione Prodotto
    </td>
    <td>    
    <%=toHtml(TicketDetails.getDenominazione_prodotto()) %>
    </td>
    
    </tr>
    <tr class="containerBody">
    <td valign="top" class="formLabel">
     Numero del Lotto
    </td>
    <td>    
    <%=toHtml(TicketDetails.getNumero_lotto()) %>
    </td>
    
    </tr>
    <tr class="containerBody">
    <td valign="top" class="formLabel">
      Fabbricante o Produttore
    </td>
    <td>    
    <%=toHtml(TicketDetails.getFabbricante_produttore()) %>
    </td>
    
    </tr>
    <%if (TicketDetails.getData_scadenza_allerta()!=null)
    	{
    	String data_scadenza = "" ;
    	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    	data_scadenza = sdf.format((new java.util.Date(TicketDetails.getData_scadenza_allerta().getTime())));
    	%>
    <tr class="containerBody">
    <td valign="top" class="formLabel">
      Data Scadenza/termine minimo di conservazione
    </td>
    <td>    
       <%= data_scadenza %>
    </td>
    
    </tr>
   <%} %>
	
	</table>
	
	
	
	

</dhv:container>
</form>






<%
if(User.getSiteId()>0)
{
%>
</body>
<%}%>



