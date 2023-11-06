
<%@page import="org.aspcf.modules.controlliufficiali.base.Motivazioni"%>
<%@ include file="../initPage.jsp" %>
    <%@ page import=" org.aspcfs.modules.util.imports.ApplicationProperties"%>
    <%@page import="java.net.InetAddress"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<jsp:useBean id="OrgOperatore" class="org.aspcf.modules.controlliufficiali.base.Organization" scope="request"/>
<jsp:useBean id="OrgUtente" class="org.aspcf.modules.controlliufficiali.base.OrganizationUtente" scope="request"/>
<%-- <jsp:useBean id="OggettoControllo" class="org.aspcf.modules.controlliufficiali.base.OggettoControllo" scope="request"/> --%>
<jsp:useBean id="MotivoIspezione" class="org.aspcf.modules.controlliufficiali.base.MotivoIspezione" scope="request"/>
<jsp:useBean id="oggettoDelControllo" class="java.lang.String" scope="request"/>


<%!
	
	public static String fixValore(String code) {
	if (code ==null || code.equals("null") || code.equals(""))
		return "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	else
		return code;
	
}
%>

<script language="JavaScript" TYPE="text/javascript"
	SRC="gestione_documenti/generazioneDocumentale.js"></script>
	
	     
<script>
	function checkSubmit() {
		myVar=confirm("Sei sicuro di voler salvare in modo definitivo i dati? Se sì, non sarà più possibile modificare i dati inseriti.");
		if(myVar=="1")
		{
			document.myform.submit();
			//window.opener.location.href ='AccountVigilanza.do?command=TicketDetails&id=214431&orgId=762051';
		 	//window.close();
		}
		
	}

	function closeAndRefresh(chiudi,url,bozza) {
		if(chiudi == "si")
		{
			self.close();
			window.opener.location.href = url;
		 	
		}

		if(bozza == 'false'){
			var f = document.forms['myform'];
			for(var i=0,fLen=f.length;i<fLen;i++){
			  f.elements[i].readOnly = true;
			  f.elements[i].className = 'layout';
			}
			var g = document.forms['myform'].getElementsByTagName("textarea");
			for(var j=0; j < g.length; j++)
				 g.item(j).className = 'textdim2';
				 
			document.getElementById('stampaId').className = 'buttonClass';
			document.getElementById('idbutn').style.display = 'none';
			document.getElementById('generaPDFInit').className = 'buttonClass';		
		}
		
	}
	

	
</script>

</HEAD>
<BODY  onload="javascript:closeAndRefresh('<%= request.getAttribute("chiudi")%>','<%= request.getAttribute("redirect")%>','<%= request.getAttribute("bozza") %>')"> 


<form method="post" name="myform" action="PrintReportVigilanza.do?command=SaveUserFields&idControllo=<%=MotivoIspezione.getIdControllo()%>&orgId=<%=OrgOperatore.getOrgId()%>&url=<%=OrgOperatore.getOperatoreUrl()%>">

<!-- INIT DOCUMENTALE -->
	<%@ include file="/gestione_documenti/initDocumentale.jsp" %>
<!-- FINE INIT DOCUMENTALE -->

<!-- INIZIO HEADER -->
	<%@ include file="/controlliufficiali/mod5_header.jsp" %>
<!-- FINE HEADER -->

<div class="boxOrigineDocumento"><%@ include file="../../../hostName.jsp" %></div> 

<font size="1px">IdCU: <%=MotivoIspezione.getIdControllo()%></font><br/>

<div id="idbutn" style="display:block;"><input type="button" class = "buttonClass" value ="Salva in modalità definitiva" onclick="this.form.bozza.value='false';javascript:checkSubmit();"/></div>
<input id="stampaId" type="button" class = "buttonClass" value ="Stampa" onclick="window.print();" style="display:none"/>
<input type="hidden" id = "bozza" name = "bozza" value="">
<input type="hidden" id = "orgId" name = "orgId" value="<%=OrgOperatore.getOrgId()%>">

<%-- onclick="this.form.bozza.value='false';" --%>

<%if (!request.getParameter("bozza").equals("true") ) {%>

<%-- <a style="text-decoration: none; color:black;" href="javascript:openRichiestaPDF_Modello5('<%=MotivoIspezione.getIdControllo()%>','<%= OrgOperatore.getOperatoreUrl() %>','<%= OrgOperatore.getOrgId() %>','5','modello5');"> --%>
<!--               <input type="button" value="Genera e Stampa PDF (nuovo bottone)"/>  -->
<!-- </a> -->
<!-- <br> -->

<input type="button" id ="generaPDFInit" class="buttonClass"  value="Genera e Stampa PDF" 	
onClick="javascript:openRichiestaPDF_Modello5('<%=MotivoIspezione.getIdControllo()%>','<%= OrgOperatore.getOperatoreUrl() %>','<%= OrgOperatore.getOrgId() %>','5','modello5');" />

<!-- <input type="button" id ="generaPDFInit" class="buttonClass"  value="Genera e Stampa PDF (vecchio bottone)" 	 -->
<!-- onClick="window.scrollTo(0,document.body.scrollHeight); document.getElementById('generaPDF').click()" /> -->
<%} %>


<P class="main">L'anno <input class="layout" type="text" readonly name="" id="" value="<%= OrgOperatore.getAnnoReferto()%>" size="4" maxlength="4"/> addì <input class="layout" type="text" readonly name="" id="" value="<%= OrgOperatore.getGiornoReferto()%>" size="2" maxlength="2" /> del mese di <input class="layout" type="text" readonly name="" value="<%= OrgOperatore.getMeseReferto()%>" id="" size="10" maxlength="10"/> 
alle ore <input class="editField" type="text" value="<%=OrgUtente.getOre()%>" name="ore" id="ore" size="5" maxlength="5"/> 
i sottoscritti <br/>

<% if (OrgOperatore.getComponente_nucleo()!=null) {%> <label class="layout"><%= fixValore(OrgOperatore.getComponente_nucleo()) %></label> <%} %> 
<% if (OrgOperatore.getComponente_nucleo_due()!=null) {%> <label class="layout"><%= fixValore(OrgOperatore.getComponente_nucleo_due()) %></label> <%} %> 
<% if (OrgOperatore.getComponente_nucleo_tre()!=null) {%> <label class="layout"><%= fixValore(OrgOperatore.getComponente_nucleo_tre()) %></label> <%} %> 
<% if (OrgOperatore.getComponente_nucleo_quattro()!=null) {%> <label class="layout"><%= fixValore(OrgOperatore.getComponente_nucleo_quattro()) %></label> <%} %> 
<% if (OrgOperatore.getComponente_nucleo_cinque()!=null) {%> <label class="layout"><%= fixValore(OrgOperatore.getComponente_nucleo_cinque()) %></label> <%} %> 
<% if (OrgOperatore.getComponente_nucleo_sei()!=null) {%> <label class="layout"><%= fixValore(OrgOperatore.getComponente_nucleo_sei()) %></label> <%} %> 
<% if (OrgOperatore.getComponente_nucleo_sette()!=null) {%> <label class="layout"><%= fixValore(OrgOperatore.getComponente_nucleo_sette()) %></label> <%} %> 
<% if (OrgOperatore.getComponente_nucleo_otto()!=null) {%> <label class="layout"><%= fixValore(OrgOperatore.getComponente_nucleo_otto()) %></label> <%} %> 
<% if (OrgOperatore.getComponente_nucleo_nove()!=null) {%> <label class="layout"><%= fixValore(OrgOperatore.getComponente_nucleo_nove()) %></label> <%} %> 
<% if (OrgOperatore.getComponente_nucleo_dieci()!=null) {%> <label class="layout"><%= fixValore(OrgOperatore.getComponente_nucleo_dieci()) %></label> <%} %> 


<br><br>qualificandosi, si sono presentati presso:
</P>
<P class="main">
<%-- <% System.out.println("Nome: "+OrgOperatore.getRagione_sociale()); %> --%>
<U><b>Stabilimento/azienda/altro</b>(luogo dell'ispezione):</U> 
Comune di <input class="layout" type="text"  readonly  name="" id="" size="88" maxlength="" value="<%= (OrgOperatore.getComune() != null ) ? OrgOperatore.getComune() : "" %>" /> 
alla via <input class="layout" type="text"  readonly  name="" id="" maxlenght="70" size="70" value="<%= (OrgOperatore.getIndirizzo() != null ) ? OrgOperatore.getIndirizzo() : "" %>" /> 
n° <input class="layout" type="text" readonly  name="" id="" size="6" maxlength ="6"/> 
ric.CE n° <input class="layout" type="text" readonly  size="40" name="" id="" value="<%= (OrgOperatore.getApproval_number() != null) ? OrgOperatore.getApproval_number() : ""%>"/> 
regist./cod.az./targa/n.seriale <input class="layout" type="text" readonly name="" id="" size= "30" maxlenght="30" value="<%= (OrgOperatore.getN_reg() != null) ? OrgOperatore.getN_reg() : "" %>" /> 
linea di attività ispezionata <input class="layout" type="text" readonly  name="" id="" size="121" maxlength="" value="<%= (OrgOperatore.getTipologia_att() != null ) ? OrgOperatore.getTipologia_att() : ""%>" />.<br>
<U><b>Nome/ditta/Ragione/Denominazione sociale: </b></U><input class="layout" readonly type="text" name="ragione_sociale" id="ragione_sociale" value="<%= (OrgOperatore.getRagione_sociale() != null) ?  OrgOperatore.getRagione_sociale().replace('"',' ') : ""%>" size="102" maxlength=""/>
sede legale in <input class="layout" type="text" readonly  name="" id="" size="50" maxlength="" value="<%= ((String )OrgOperatore.getSede_legale()) != null ? OrgOperatore.getSede_legale() : ""%>" /> 
alla via <input class="layout" type="text" readonly  name="" id="" size="50" maxlength="" value="<%= ((String )OrgOperatore.getIndirizzo_legale()) != null ? OrgOperatore.getIndirizzo_legale() : "" %>" /> 
n° <input class="layout" type="text" readonly  name="" id="" size="6" maxlength="6"/> <br>
PI/CF <input class="layout" type="text" readonly  name="" id="" size="40" maxlength="16" value="<%= (String )OrgOperatore.getCodice_fiscale()%>" /> 
legale rappr. sig. <input class="layout" type="text" readonly  name="" id="" size="80" maxlength=""/ value="<%= ((String )OrgOperatore.getLegale_rapp()) !=null ? OrgOperatore.getLegale_rapp(): "" %>" > 
nato a <input class="layout" type="text" readonly  name="" id="" size="20" maxlength="" value="<%= ((String )OrgOperatore.getLuogo_nascita_rappresentante()) != null ? (String)OrgOperatore.getLuogo_nascita_rappresentante() :  "" %>"/> 
il <input class="layout" type="text" readonly  name="" id="" size="2" maxlength="2" value="<%= OrgOperatore.getGiornoNascita()%>"/>/
<input class="layout" type="text" readonly  name="" id="" size="2" maxlength="2" value="<%= OrgOperatore.getMeseNascita()%>"/>/
<input class="layout" type="text" readonly  name="" id="" size="4" maxlength="4" value="<%= OrgOperatore.getAnnoNascita()%>"/> 
e residente in <input class="layout" type="text" name="luogo_residenza" id="luogo_residenza" value="<%=OrgUtente.getResidenza_legale()%>" size="30" maxlength="" /> 
alla via <input class="layout" type="text" name="indirizzo_legale_rappresentante" id="indirizzo_legale_rappresentante" size="50" maxlength="" value="<%= OrgUtente.getIndirizzo_legale()%>" /> 
n° <input class="editField" type="text" name="num_civico_rappresentante" id="num_civico_rappresentante" value="<%=OrgUtente.getNumero_legale() %>" size="6" maxlength="6"/> 
domicilio digitale <input class="editField" type="text" name="domicilio_digitale" id="domicilio_digitale" size="50" maxlength="" value="<%= (OrgOperatore.getDomicilioDigitale() != null && !OrgOperatore.getDomicilioDigitale().equals("null")) ? OrgOperatore.getDomicilioDigitale() : ""%>" /> <br>
<U><b>Presente all'ispezione:</b></U> 
sig. <input class="editField" type="text" name="nome_presente_ispezione" id="nome_presente_ispezione" value="<%=OrgUtente.getNome_presente_ispezione()%>" size="120" maxlength=""/>
nato a <input class="editField" type="text" name="luogo_nascita_presente_ispezione" id="luogo_nascita_presente_ispezione" value="<%=OrgUtente.getLuogo_nascita_presente_ispezione()%>" size="90" maxlength=""/> 
il <input class="editField" type="text" name="giorno_presente_ispezione" id="giorno_presente_ispezione" value="<%=OrgUtente.getGiorno_presente_ispezione()%>" size="2" maxlength="2"/>/
<input class="editField" type="text" name="mese_presente_ispezione" id="mese_presente_ispezione" value="<%=OrgUtente.getMese_presente_ispezione()%>" size="2" maxlength="2"/>/
<input class="editField" type="text" name="anno_presente_ispezione" id="anno_presente_ispezione" value="<%=OrgUtente.getAnno_presente_ispezione()%>" size="4" maxlength="4"/> 
e residente in <input class="editField" type="text" name="luogo_residenza_presente_ispezione" id="luogo_residenza_presente_ispezione" value="<%=OrgUtente.getLuogo_residenza_presente_ispezione()%>" size="60" maxlength=""/> 
alla via <input class="editField" type="text" name="via_ispezione" id="via_ispezione"  value="<%=OrgUtente.getVia_ispezione()%>" size="70" maxlength=""/> 
n° <input class="editField" type="text" name="num_civico_presente_ispezione" id="num_civico_presente_ispezione" value="<%=OrgUtente.getNum_civico_presente_ispezione()%>" size="6" maxlength="6"/> 
doc.ident. <input class="editField" type="text" name="doc_identita_presente_ispezione" id="doc_identita_presente_ispezione" value="<%=OrgUtente.getDoc_identita_presente_ispezione()%>" size="20" maxlength="" />. 
Questi si è dichiarato quale incaricato della ricezione di atti ed è stato avvisato della facoltà di farsi assistere da un legale di fiducia.<br><br>
</P> 
<table width="100%">
<tr>
<td>
<U><b>Motivo del controllo ufficiale</b></U>:
<% 

String attivita = "";
attivita +=(MotivoIspezione.getAttivitaHtml() != null ) ?  MotivoIspezione.getAttivitaHtml().toUpperCase() : "";
String piani = "";
piani +=(MotivoIspezione.getPianoHtml() != null ) ?  MotivoIspezione.getPianoHtml().toUpperCase() : "";

String vuoto = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
%>
<br/>
<%if(!attivita.equals("")) { %>
	<span class="checkedItem">&nbsp;Attività: </span>
	<label class="layout"><%=attivita%></label><br/>
<% } else {%>
	<span class="NocheckedItem">&nbsp;Attivita: </span>
	<label class="layout"><%=vuoto%></label><br/>
<% } %>

<%if(!piani.equals("")) { %>
	<span class="checkedItem">&nbsp;Piano di monitoraggio: </span>
	<label class="layout"><%=piani%></label><br/>
<% } else {%>
	<span class="NocheckedItem">&nbsp;Piano di monitoraggio: </span>
	<label class="layout"><%=vuoto%></label><br/>
<% } %>

</td>
</tr>
</table>

<h3>Aree di indagine controllate</h3> 
<label class="layout"><%=oggettoDelControllo %></label><br/><br/>

<P class="main">
L'Unità organizzat. responsabile del procedimento è quella sopraindicata, presso la cui sede la parte può prendere visione degli atti e presentare memorie scritte e documenti. Il responsabile del procedimento è  <input class="editField" type="text" name="responsabile_procedimento" size="50" id="responsabile_procedimento" value="<%=OrgUtente.getResponsabile_procedimento()%>" maxlength="" />.<br>
Descrizione dei provvedimenti <U>non</U> causati da n.c. a carico del soggetto ispezionato:<br>
<textarea rows="4" cols="50" class="textDim" readonly><%= OrgOperatore.getListProvNC() %>
</textarea><br>
</P>

<P class="main"> <b>Osservazioni rilevate:</b><br>
<textarea rows="4" cols="50" class="textDim" readonly><%=OrgOperatore.getDescrizione_ncf()%></textarea><br>
Punteggio *: <input class="layout" type="text" readonly  name="" value="<%=OrgOperatore.getPunteggio_formale()%>" id="" size="5" maxlength="5"/><br>
Valutazione del rischio caratterizzato dalla presenza delle Osservazioni (motivazioni di fatto):<br>
<textarea rows="4" cols="50"  class="textDim" readonly>
<%=OrgOperatore.getValutazione_formale()%>"
</textarea><br>

Follow up delle Osservazioni (dispositivo del provvedim. amministr.): visto Reg. CE 882/04, L.241/90, DPR 320/54 ed il P.R.I. si dispone che <br>
<textarea rows="4" cols="50" class="textDim" readonly><%=OrgOperatore.getFollowUpFormale()%></textarea><br>(ex art.54 Reg. CE 882/04, avverso il provvedim. ammin. si può ricorrere al T.A.R. entro 60 giorni dalla data di notifica)<br><br>
<b>Inadeguatezze rilevate:</b><br>
<textarea rows="4" cols="50" class="textDim" readonly>
<%=OrgOperatore.getDescrizione_ncs()%>
</textarea><br>
Punteggio *: <input class="layout" type="text" readonly  name="" id="" value="<%=OrgOperatore.getPunteggio_significativo()%>" size="5" maxlength="5"/><br>
Valutazione del rischio caratterizzato dalla presenza delle inadeguatezze (motivazioni di fatto)<br>
<textarea rows="4" cols="50" class="textDim" readonly><%=OrgOperatore.getValutazione_significativa()%></textarea><br>
Follow up delle inadeguatezze (dispositivo del provvedim. amministr.): visto Reg. CE 882/04, L.241/90, DPR 320/54, ed il P.R.I. si dispone che <br>
<textarea rows="4" cols="50" class="textDim" readonly><%=OrgOperatore.getFollowUpSign()%></textarea><br>
(ex art.54 Reg. CE 882/04, avverso il provvedim. ammin. si può ricorrere al T.A.R. entro 60 giorni dalla data di notifica)<br><br>
<b>Non conformità rilevate:</b><br> 
<textarea rows="4" cols="50"  class="textDim" readonly><%=OrgOperatore.getDescrizione_ncg()%></textarea><br>
Punteggio *: <input class="layout" type="text" readonly  name="" id="" value="<%=OrgOperatore.getPunteggio_grave()%>" size="5" maxlength="5" /><br><br>

<b>Follow up delle n.c. </b>:
<ol>
<% 
    int i = 0;
	ArrayList<String> key = new ArrayList<String> ();
	ArrayList<String> value = new ArrayList<String> ();
   if(OrgUtente.getGravi() != null){
	   StringTokenizer st = new StringTokenizer(OrgUtente.getGravi(),"=;");
	   while(st.hasMoreTokens()){
		  ++i;
		  key.add(st.nextToken());
		  value.add(st.nextToken());		
		}   
   }
   	for (int j=i; j<=16; j++){
   		value.add("");
   	}
%>	
<li> 
<% if(OrgOperatore.isNcgCheck1()) { %>
   	<span class="checkedItem"> &nbsp;si è proceduto alla contestazione di illecit<input class="editField" type="text" name="gravi_1" id="gravi_1" value="<%= value.get(0) %>" maxlength="1" size="1"/> 
amministrativ<input class="editField" type="text" name="gravi_2" id="gravi_2" value="<%= value.get(1)%>" maxlength="1" size="1"/> 
con verbal<input class="editField" type="text"  name="gravi_3" id="gravi_3" value="<%= value.get(2) %>" size="1" maxlength="1"/> 
n.<input class="layout" type="text"  name="proc_verb" id="proc_verb" value="<%= OrgOperatore.getProcessiVerbali() %>" size="25" maxlength="25"/>
</span>
<% } else { %>
	<span class="NocheckedItem"> &nbsp;si è proceduto alla contestazione di illecit<input class="editField" type="text"  name="gravi_1" id="gravi_1" value="<%= value.get(0) %>" maxlength="1" size="1"/> 
amministrativ<input class="editField" type="text" name="gravi_2" id="gravi_2" value="<%= value.get(1)%>" maxlength="1" size="1"/> 
con verbal<input class="editField" type="text" name="gravi_3" id="gravi_3" value="<%= value.get(2) %>" size="1" maxlength="1"/> 
n.<input class="layout" type="text" name="proc_verb" id="proc_verb" value="<%= OrgOperatore.getProcessiVerbali() %>" size="25" maxlength="25"/>
</span>
<% } %>
<li>
<% if(OrgOperatore.isNcgCheck2()) { %>
   	<span class="checkedItem"> &nbsp;si procederà, se del caso e/o previo ulteriori accertamenti, alla notifica di illecit
<input class="editField" type="text" name="gravi_4" id="gravi_4" value="<%= value.get(3) %>" maxlength="1" size="1" /> 
amministrativ<input class="editField" type="text" name="gravi_5" id="gravi_5" value="<%= value.get(4) %>" size="1" maxlength="1"/> 
con att<input class="editField" type="text" name="gravi_6" id="gravi_6" value="<%= value.get(5) %>" maxlength="1" size="1"/> a parte
</span>
<% } else { %>
<span class="NocheckedItem"> &nbsp;si procederà, se del caso e/o previo ulteriori accertamenti, alla notifica di illecit
<input class="editField" type="text" name="gravi_4" id="gravi_4" value="<%= value.get(3) %>" maxlength="1" size="1" /> 
amministrativ<input class="editField" type="text" name="gravi_5" id="gravi_5" value="<%= value.get(4) %>" size="1" maxlength="1"/> 
con att<input class="editField" type="text" name="gravi_6" id="gravi_6" value="<%= value.get(5) %>" maxlength="1" size="1"/> a parte
</span>
<% } %>
<li> 
<% if(OrgOperatore.isNcgCheck7()) { %>
<span class="checkedItem"> &nbsp;vista la L. 116/14 si diffida l'operatore a eliminare la non conformità n. 
<input class="editField" type="text" name="gravi_13" id="gravi_13" value="<%= value.get(12) %>" maxlength="5" size="5" /> 
entro il termine di 20 giorni. 
</span>
<% } else { %>
<span class="NocheckedItem"> &nbsp;vista la L. 116/14 si diffida l'operatore a eliminare la non conformità n. 
<input class="editField" type="text" name="gravi_13" id="gravi_13" value="<%= value.get(12) %>" maxlength="5" size="5" /> 
entro il termine di 20 giorni. 
</span>
<% } %>
<li> 
<% if(OrgOperatore.isNcgCheck3()) { %>
   	<span class="checkedItem"> &nbsp;visto il Reg. CE 882/04, la L. 689/81 e la DGRC n. 623/14, in seguito alla rilevazione di illecito amministrativo, si è proceduto al sequestro amministrativo delle cose <u>confiscabili</u> 
elencate ne<input class="editField" type="text" name="gravi_7" id="gravi_7" value="<%= value.get(6)%>" size="1" maxlength="1"/> 
verbal<input class="editField" type="text" name="gravi_8" id="gravi_8" value="<%= value.get(7) %>" size="1" maxlength="1"/>n.
<input class="layout" type="text" name="" id="" value="" size="4" maxlength="4"/>. 
</span>
<% } else { %>
<span class="NocheckedItem"> &nbsp;visto il Reg. CE 882/04, la L. 689/81 e la DGRC n.623/14, in seguito alla rilevazione di illecito amministrativo, si è proceduto al sequestro amministrativo delle cose confiscabili 
elencate ne<input class="editField" type="text" name="gravi_7" id="gravi_7" value="<%= value.get(6)%>" size="1" maxlength="1"/> 
verbal<input class="editField" type="text" name="gravi_8" id="gravi_8" value="<%= value.get(7) %>" size="1" maxlength="1"/>n.
<input class="layout" type="text" name="" id="" value="" size="4" maxlength="4"/>. 
</span>
<% } %>
<li>
<% if(OrgOperatore.isNcgCheck4()) { %>
   	<span class="checkedItem"> &nbsp;si è proceduto al sequestro penale delle cose elencate ne
<input class="editField" type="text" name="gravi_9" id="gravi_9" value="<%= value.get(8) %>" size="1" maxlength="1"/> verbal
<input class="editField" type="text" name="gravi_10" id="gravi_10" value="<%=value.get(9) %>" size="1" maxlength="1"/> n.
<input class="layout" type="text" name="" id="" value="" size="4" maxlength="4"/> 
</span>
<% } else { %>
<span class="NocheckedItem"> &nbsp;si è proceduto al sequestro penale delle cose elencate ne
<input class="editField" type="text" name="gravi_9" id="gravi_9" value="<%= value.get(8) %>" size="1" maxlength="1"/> verbal
<input class="editField" type="text" name="gravi_10" id="gravi_10" value="<%=value.get(9) %>" size="1" maxlength="1"/> n.
<input class="layout" type="text" name="" id="" value="" size="4" maxlength="4"/> 
</span>
<% } %>
<li>
<% if(OrgOperatore.isNcgCheck5()) { %>
   	<span class="checkedItem"> &nbsp;visto il Reg. CE 882/04,
 L. 241/90, L 283/62 ed il P.R.I. si è proceduto al blocco/sequestro sanitario delle cose elencate ne
 <input class="editField" type="text" name="gravi_11" id="gravi_11" value="<%=value.get(10) %>" size="1" maxlength="1"/> 
 verbal<input class="editField" type="text" name="gravi_12" id="gravi_12" value="<%= value.get(11) %>" size="1" maxlength="1"/> 
 n.<input class="layout" type="text" name="" id="" value="" size="4" maxlength="4"/> 
 che forma parte integrante del presente provvedimento amministrativo  
</span>
<% } else { %>
<span class="NocheckedItem"> &nbsp;visto il Reg. CE 882/04,
 L. 241/90, L 283/62 ed il P.R.I. si è proceduto al blocco/sequestro sanitario delle cose elencate ne
 <input class="editField" type="text" name="gravi_11" id="gravi_11" value="<%=value.get(10) %>" size="1" maxlength="1"/> 
 verbal<input class="editField" type="text" name="gravi_12" id="gravi_12" value="<%= value.get(11) %>" size="1" maxlength="1"/> 
 n.<input class="layout" type="text" name="" id="" value="" size="4" maxlength="4"/> 
 che forma parte integrante del presente provvedimento amministrativo  
</span>
<% } %>
<li>
<% if(OrgOperatore.isNcgCheck6()) { %>
   	<span class="checkedItem"> &nbsp; visto Reg. CE 882/04, L. 241/90, DPR 320/54 ed il P.R.I. si dispone che (dispositivo del provved. amministr.):<br>   
	<textarea rows="4" cols="50"  class="textDim"><%=OrgOperatore.getFollowUpGravi()%></textarea><br>		
</span>
<% } else { %>
<span class="NocheckedItem"> &nbsp; visto Reg. CE 882/04, L. 241/90, DPR 320/54 ed il P.R.I. si dispone che (dispositivo del provved. amministr.): <br>  
	<textarea rows="4" cols="50"  class="textDim"><%=OrgOperatore.getFollowUpGravi()%></textarea><br>		  
</span>
<% } %>
</ol>
Valutazione del rischio caratterizzato dalla presenza delle n.c.  (motivazioni di fatto da redigere solo nei sopraelencati casi <b>6)</b> e <b>7)</b>):<br>	
<textarea rows="4" cols="50"  class="textDim"><%=(OrgOperatore.getValutazione_grave()) != null ? OrgOperatore.getValutazione_grave() : "" %></textarea><br>
(ex art. 54 Reg CE 882/04, nei casi 6) e 7) avverso il provvedimen. ammin. si può ricorrere al T.A.R. entro 60 giorni dalla data di notifica).<br>
Il presente all'ispezione spontaneamente dichiara che:<br>
<textarea rows="4" cols="50" class="textDim" id="dichiarazione" name="dichiarazione"><%=(OrgUtente.getDichiarazione()!=null && !OrgUtente.getDichiarazione().equals("")) ? OrgUtente.getDichiarazione() : "" %>
</textarea><br>
Ai sensi degli art. 21 bis e quater L. 241/90 il presente provvedimento ha efficacia immediata in quanto cautelare e urgente. Essendo susseguente ad ispezione, al presente provvedimento si applica la deroga ex art.7 p. 1 L. 241/90 in materia di
comunicazione di avvio del procedimento. Si avvisa che alla scadenza del termine concesso per la risoluzione delle n.c., si procederà a nuova ispezione con spese a carico del soggetto.  In materia di sicurezza alimentare, la mancata risoluzione 
delle n.c. comporterà la contestazione di illecito amministrativo. Ai sensi dell'art. 13 D.L.vo 196/03 si informa che i dati  
personali potranno essere inviati ad uffici interni o P.A. esterne con finalità che riguardano la definizione della presente 
procedura e degli atti conseguenti. Consci delle sanzioni previste per le dichiarazioni mendaci, gli ispettori dichiarano che 
per nessuno di loro esistono conflitti d'interesse nello svolgimento della presente ispezione.<br> 
Raccolta evidenze:<br>
<textarea rows="4" cols="50" class="textDim" id="note" name="note"><%=(OrgUtente.getNote()!=null && !OrgUtente.getNote().equals("")) ? OrgUtente.getNote() : OrgOperatore.getProblem() %>
</textarea><br>
Data chiusura ispez. <input class="layout" type="text" readonly  name="" id="" size="2" maxlength="2" value="<%=OrgOperatore.getGiorno_chiusura()%>"/>/<input class="layout" type="text" readonly  name="" id="" size="2" maxlength="2" value="<%=OrgOperatore.getMese_chiusura()%>"/>/<input class="layout" type="text" readonly  name="" id="" size="4" maxlength="4" value="<%=OrgOperatore.getAnno_chiusura()%>"/> Punteggio tot. delle n.c. <input class="layout" type="text" readonly name="" id="" size="5" maxlength="5" value="<%=OrgOperatore.getPunteggio_ispezione()%>"/>.
Fatto in n.<input class="editField" type="text" id="" value="<%=OrgUtente.getNumero_copie()%>" id="numero_copie" name="numero_copie" maxlength="4" size="4"> copie originali, letto, confermato, sottoscritto e consegnato. (*) n. 1 punto per ogni osservazione, n. 7 punti per ogni inadeguatezza, n. 50 punti per ogni n.c.. Nelle ispezioni effettuate nella sorveglianza, i punteggi delle n.c. sono già contabilizzati nelle check list. N.C. = Non Conformità
<br><br>
</P>
<P> IL PRESENTE ALL'ISPEZIONE &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; IL LEGALE DI FIDUCIA &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; GLI OPERATORI DEL CONTROLLO UFFICIALE 
</DIV>
</BODY>   
</FORM>

<dhv:permission name="server_documentale-view">
<%if (!request.getParameter("bozza").equals("true") ) {%>
<!--  BOX DOCUMENTALE -->
	 <jsp:include page="../gestione_documenti/boxDocumentale.jsp">
    <jsp:param name="orgId" value="<%=request.getParameter("orgId") %>" />
     <jsp:param name="ticketId" value="0" />
      <jsp:param name="tipo" value="5" />
       <jsp:param name="idCU" value="<%=request.getParameter("idControllo") %>" />
        <jsp:param name="url" value="<%=request.getParameter("url") %>" />
</jsp:include>
<!--  BOX DOCUMENTALE -->
<% } %>
</dhv:permission>
