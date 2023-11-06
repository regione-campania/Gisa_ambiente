<%@page import="org.aspcfs.modules.opu.base.*"%>
<%@page import="org.aspcfs.utils.web.LookupElement"%>

<jsp:useBean id="Anagrafica" class="org.aspcfs.modules.gestionexml.base.AnagraficaXML" scope="request"/>
<jsp:useBean id="NazioniList" class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="ToponimiList" class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="msg" class="java.lang.String" scope="request" />
<jsp:useBean id="codiceUscita" class="java.lang.String" scope="request" />
<jsp:useBean id="stabilimentiList" class="org.aspcfs.modules.opu.base.StabilimentoList" scope="request" />

<link rel="stylesheet" href="css/jquery-ui.css" />
<link rel="stylesheet" href="css/opu.css" />
<script f src="dwr/interface/SuapDwr.js"> </script>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>
<script src="javascript/datepicker/jquery.plugin.js"></script>
<script type="text/javascript" src="javascript/jquery.plugin.js"></script>
<script src="javascript/parsedate.js"></script>
<script type="text/javascript" src="javascript/jquery.steps_modify.js"></script>
<script src="javascript/jquery-ui.js"></script>
<SCRIPT src="javascript/xml.js"></SCRIPT>
<SCRIPT src="javascript/suapUtil.js"></SCRIPT>
<script src="javascript/jquery.form.js"></script>
<style>
   .td {
   border-right: 1px solid #C1DAD7;
   border-bottom: 1px solid #C1DAD7;
   background: #fff;
   padding: 6px 6px 6px 12px;
   color: #6D929B;
   }
   #progress {
   position: relative;
   width: 400px;
   border: 1px solid #ddd;
   padding: 1px;
   border-radius: 3px;
   }
   #bar {
   background-color: #B4F5B4;
   width: 0%;
   height: 20px;
   border-radius: 3px;
   }
   #percent {
   position: absolute;
   display: inline-block;
   top: 3px;
   left: 48%;
   }
   input[readonly]
   {
   background-color:grey;
   }
   table.one {border-collapse:collapse;}
   td.b {
   border-style:solid;
   border-width:1px;
   border-color:#333333;
   padding:10px;
   }
</style>
<SCRIPT LANGUAGE="JavaScript" SRC="javascript/CalendarPopup.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="javascript/common.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">document.write(getCalendarStyles());</SCRIPT>
<SCRIPT LANGUAGE="JavaScript" ID="js19">
   var cal99 = new CalendarPopup();
   cal99.showYearNavigation();
   cal99.showYearNavigationInput();
   cal99.showNavigationDropdowns();
</SCRIPT> 
<%@ page import="java.util.*"%>
<%@ include file="../initPage.jsp"%>

<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>


<script>

function rifiutaRichiesta(id){
	if (confirm("Attenzione. Questa pratica sara' rifiutata e posta in uno stato non processabile. Sei sicuro di voler proseguire?")){
		loadModalWindow();
		window.location.href="GestioneXML.do?command=RifiutaRichiesta&idAnagraficaXML="+id;
	}
}

function selezionaLinea(indice, id){
	if (confirm('ATTENZIONE. Procedere alla modifica della linea? I dati inseriti finora saranno persi se non salvati. Cliccare OK per procedere, cliccare ANNULLA per salvare prima i dati tramite il bottone SALVA.')){
		loadModalWindow();
		window.location.href="GestioneXML.do?command=PrepareSelezionaLinea&id="+id+"&indice="+indice;
}
}


function calcolaCap(idComune, topon, indir, campo){	
   	SuapDwr.getCap(idComune, topon, indir, campo,{callback:calcolaCapCallBack,async:false});
   }
   
   
   function calcolaCapCallBack(val){
   	var campo = val[1];
   	var value = val[0];
   	document.getElementById(campo).value = value;
   }
   
  /*AUTOCOMPLETAMENTO PER GLI INDIRIZZI*/          
   $(function() {
       $( "#addressLegaleCountry" ).combobox();
       $( "#addressLegaleCity" ).combobox();
       $( "#comuneNascita" ).combobox();
       $( "#addressLegaleLine1" ).combobox();
       $( "#searchcodeIdComune" ).combobox();
       $( "#searchcodeIdprovincia" ).combobox();
       $( "#via" ).combobox();
       $( "#searchcodeIdComuneStab" ).combobox();
       $( "#searchcodeIdprovinciaStab" ).combobox();
       $( "#viaStab" ).combobox();
   });
   
   function nascondiCap(codnaz, idcap, idbottone)
   {
   			if( codnaz != "106" ) 
   			{  
   				document.getElementById(idbottone).type = "hidden";
   				document.getElementById(idcap).type = "hidden";
   				} else {
   					document.getElementById(idbottone).type = "button";
   					document.getElementById(idcap).type = "text";
   					}
   }
   
function checkForm(form){
	
	var addressSedeLegaleCountryinput = form.searchcodeIdprovinciainput;
	var addressSedeLegaleCityinput = form.searchcodeIdComuneinput
	var addressSedeLegaleLine1input = form.viainput;
	var capSedeLegale = form.presso; 
	var codFiscaleSoggetto = form.codFiscaleSoggetto;
	var operazione = form.operazione;
	var idLinea1 = form.idLinea1;

	var msg = "";
	
	
	if (operazione.value.toLowerCase().includes("apertura") || operazione.value.toLowerCase().includes("subingresso")){

		if (addressSedeLegaleCountryinput.value=="")
			msg+="[SEDE LEGALE] Indicare la provincia.\n";
		if (addressSedeLegaleCityinput.value=="")
			msg+="[SEDE LEGALE] Indicare il comune.\n";
		if (addressSedeLegaleLine1input.value=="")
			msg+="[SEDE LEGALE] Indicare l'indirizzo.\n";
		if (capSedeLegale.value=="")
			msg+="[SEDE LEGALE] Indicare il CAP.\n";
		if (codFiscaleSoggetto.value=="")
			msg+="[RAPP. LEGALE] Indicare il codice fiscale.\n";
		if (idLinea1.value=="")
			msg+="[LINEA] Indicare la linea.\n";
	}
	
	if (operazione.value.toLowerCase().includes("chiusura") || operazione.value.toLowerCase().includes("trasferimento") || operazione.value.toLowerCase().includes("modifiche")){
		var checked = false;
		var radios = document.getElementsByName('anagraficaGisa');
		for (var i = 0; i < radios.length; i++) {
		    if (radios[i].checked) 
		        checked = true;	 
		}
		
		if (checked == false)
			msg+="[OPERAZIONE] Indicare un'anagrafica GISA su cui effettuare questa operazione.\n";
	}
	
	
	if (msg!=""){
		alert(msg);
		return false;
	}
	else
		return true;
}

function salvaDati(form){
   	
	   if (!checkForm(form))
	   return false;
	   
if (confirm("Salvare i dati attuali? Lo stabilimento non sara' processato.")){
		document.getElementById("salva").value="salva";
		form.submit();
}
else
	return false;
	
}

   function processaDati(form){
   	
	   if (!checkForm(form))
	   return false;
	   
   if (confirm("ATTENZIONE: confermare i dati attuali e processare lo stabilimento?")){
	   	loadModalWindow();
   		form.submit();
   }
   else
   	return false;
   	
   }
   
   
</script>
  
  <center><h2>Caricamento in anagrafica record XML</h2></center>
  
  <script>
function mostraNascondiXmlOriginale(check) {
	if (check.checked)
		document.getElementById("xmlOriginale").style.display="block";
	else
		document.getElementById("xmlOriginale").style.display="none";
}

</script>

<input type="checkbox" onClick="mostraNascondiXmlOriginale(this)"/> Mostra XML originale<br/>
<table id="xmlOriginale" name="xmlOriginale" width="100%" cellpadding="4" cellspacing="4" style="background-color:yellow; display:none">
<tr><td><pre><code><%=Anagrafica.getXmlOriginale().replaceAll("<", "&lt;") %></code></pre></td></tr>
</table><br/><br/>


<% if (codiceUscita!=null && codiceUscita.equals("1")) { %>
<script>
alert('XML PROCESSATO CON SUCCESSO. REINDIRIZZAMENTO IN ANAGRAFICA');
loadModalWindow();
window.location.href="OpuStab.do?command=Details&stabId=<%=msg%>";
</script>
<% } else if (codiceUscita!=null && codiceUscita.equals("-1") && !msg.equals("")) { %>
<script>
alert("ERRORE: <%=msg%>");
</script>
<% } %>
    
  <form id = "addAccount" name="addAccount" action="GestioneXML.do?command=CompletaProcessaRichiesta&auto-populate=true" method="post">
   
   <input type="hidden" name="idAnagraficaXML"	id="idAnagraficaXML" value="<%=Anagrafica.getId()%>">
   
    
            <%
           
            String domicilioDigitale = "";
             if (Anagrafica.getImpresaPec()!=null)
            	domicilioDigitale = Anagrafica.getImpresaPec();
             
            int nazioneSedeLegale = 106;
            if (Anagrafica.getLegaleIdNazione()>0)
            	nazioneSedeLegale = Anagrafica.getLegaleIdNazione();
            
            int provinciaSedeLegale = -1;
            if (Anagrafica.getLegaleIdProvincia()>0)
            	provinciaSedeLegale = Anagrafica.getLegaleIdProvincia(); 
            
            String descrizioneProvinciaSedeLegale = "";
             if (Anagrafica.getLegaleIdProvincia()>0)
            	descrizioneProvinciaSedeLegale = Anagrafica.getLegaleDescrizioneProvincia(); 
            
            int comuneSedeLegale = -1;
             if (Anagrafica.getLegaleIdComune()>0)
            	comuneSedeLegale = Anagrafica.getLegaleIdComune();
            
            String descrizioneComuneSedeLegale = "";
             if (Anagrafica.getLegaleIdComune()>0)
            	descrizioneComuneSedeLegale = Anagrafica.getLegaleDescrizioneComune();
            
            int toponimoSedeLegale = -1;
            if (Anagrafica.getLegaleIdToponimo()>0)
            	toponimoSedeLegale = Anagrafica.getLegaleIdToponimo();  
            
            String descrizioneToponimoSedeLegale = "VIA";
            if (Anagrafica.getLegaleIdToponimo()>0)
            	descrizioneToponimoSedeLegale = Anagrafica.getLegaleDescrizioneToponimo();  
            
            String viaSedeLegale = "";
             if (Anagrafica.getLegaleIndirizzo()!=null)
            	viaSedeLegale = Anagrafica.getLegaleIndirizzo();  
           
            String civicoSedeLegale = "";
             if (Anagrafica.getLegaleCivico()!=null)
            	civicoSedeLegale = Anagrafica.getLegaleCivico();  
            
            String capSedeLegale = "";
             if (Anagrafica.getLegaleCap()!=null)
            	capSedeLegale = Anagrafica.getLegaleCap();  
            
            String nomeRappresentante = "";
             if (Anagrafica.getSoggettoNome()!=null)
            	nomeRappresentante = Anagrafica.getSoggettoNome();  
            
            String cognomeRappresentante = "";
            if (Anagrafica.getSoggettoCognome()!=null)
            	cognomeRappresentante = Anagrafica.getSoggettoCognome();
            
            String codiceFiscaleRappresentante = "";
             if (Anagrafica.getSoggettoCf()!=null)
            	codiceFiscaleRappresentante = Anagrafica.getSoggettoCf();  
            
             %>
            

  		
  		
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">

<tr><th colspan="2">Dati XML</th></tr>

<tr>
<td class="formLabel">Operazione</td>
<td><%=Anagrafica.getOperazione() %></td>
</tr>

<% 	if (Anagrafica.getOperazione()!= null && (!Anagrafica.getOperazione().toLowerCase().contains("apertura") && !Anagrafica.getOperazione().toLowerCase().contains("subingresso"))){ 
for (int i = 0; i<stabilimentiList.size(); i++){
	Stabilimento stab = (Stabilimento) stabilimentiList.get(i);%>

<tr><td class="formLabel">Anagrafica di riferimento GISA</td> <td> <input type="radio" <%=Anagrafica.getAnagraficaGisa() == stab.getIdStabilimento() ? "checked" : "" %> name="anagraficaGisa" id ="anagraficaGisa_<%=stab.getIdStabilimento()%>" value="<%=stab.getIdStabilimento()%>"/> <a href="#" onClick="window.open('OpuStab.do?command=Details&stabId=<%=stab.getIdStabilimento()%>')"><%=stab.getOperatore().getRagioneSociale() %> (<%=toHtml(stab.getSedeOperativa().getDescrizioneToponimo()) %> <%=stab.getSedeOperativa().getVia() %> <%=stab.getSedeOperativa().getCivico() %>, <%=stab.getSedeOperativa().getDescrizioneComune() %>)</a></td></tr>

<%  } } %>

<tr>
<td class="formLabel">Data Protocollo</td>
<td><%=Anagrafica.getDataProtocollo() %></td>
</tr>

<tr>
<td class="formLabel">Stato</td>
<td> <%if (Anagrafica.getProcessStato()==0) { %>DA PROCESSARE<% } else if (Anagrafica.getProcessStato()==2) { %> RESPINTA da  <dhv:username id="<%= Anagrafica.getProcessBy() %>" /> il <%=toDateasString(Anagrafica.getProcessData()) %> <%} else if (Anagrafica.getProcessStato()==1) { %> PROCESSATA da  <dhv:username id="<%= Anagrafica.getProcessBy() %>" /> il <%=toDateasString(Anagrafica.getProcessData()) %> <%} %> </td>
</tr>


<tr><th colspan="2">Dati Impresa</th></tr>

<tr>
<td class="formLabel">Ragione Sociale Impresa</td>
<td><%=Anagrafica.getImpresaRagioneSociale() %>  <font color="red">(*)</font> </td>
</tr>

<tr>
<td class="formLabel">Partita IVA</td>
<td><%=Anagrafica.getImpresaPartitaIva() %>  <font color="red">(*)</font></td>
</tr>

<tr>
<td class="formLabel">Codice Fiscale</td>
<td><%=Anagrafica.getImpresaCf() %></td>
</tr>


<tr>
<td class="formLabel" nowrap>DOMICILIO DIGITALE(PEC)</td>
<td><input type="text" size="70" maxlength="70" id="domicilioDigitale" name="domicilioDigitale" value="<%= domicilioDigitale%>"></td>
</tr>

<tr><th colspan="2">Sede Legale</th></tr>

<tr><td class="formLabel">Nazione</td>
 <td>
                     <% NazioniList.setJsEvent("onchange=\"sbloccoProvincia('nazioneSedeLegale','searchcodeIdprovincia','searchcodeIdComune','via')\""); %> 
                     <% NazioniList.setJsEvent("onChange=\"nascondiCap(this.value,'presso','butCapSL')\""); %>
                     <%=NazioniList.getHtmlSelect("nazioneSedeLegale", nazioneSedeLegale)%>
                     
                     <script>
                     $('#nazioneSedeLegale option[value!="106"]').remove();
                     </script>
                     
                  </td>
               </tr>
               <tr id="searchcodeIdprovinciaTR">
                  <td class="formLabel">PROVINCIA</td>
                  <td>
                     <select name="searchcodeIdprovincia" id="searchcodeIdprovincia" class="required">
                     
                     <% if (provinciaSedeLegale>0) {%>
                     <option value="<%=provinciaSedeLegale%>"><%=descrizioneProvinciaSedeLegale %></option>
                     <%} %>
                     
                        <option value=""></option>
                     </select>
                     <input type="hidden" name="searchcodeIdprovinciaTesto" id="searchcodeIdprovinciaTesto" />
                  <font color="red">(*)</font></td>
               </tr>
               <tr>
                  <td class="formLabel">COMUNE</td>
                  <td><select name="searchcodeIdComune" id="searchcodeIdComune" class="required">
                   <% if (comuneSedeLegale>0) {%>
                     <option value="<%=comuneSedeLegale%>"><%=descrizioneComuneSedeLegale %></option>
                     <%} %>
                     </select> 
                     <input type="hidden" name="searchcodeIdComuneTesto" id="searchcodeIdComuneTesto" />
                  <font color="red">(*)</font></td>
               </tr>
               <tr>
                  <td class="formLabel" >INDIRIZZO</td>
                  <td>
                     <table class="noborder">
                        <tr>
                           	<td>
						
							<%=ToponimiList.getHtmlSelect("toponimoSedeLegale", descrizioneToponimoSedeLegale)%>
							</td>
                           <td>
                              <select name="via" id="via" class="required">
                              
                              <%if(viaSedeLegale!=null && !viaSedeLegale.equals(""))
								{
									%>
									<option value="<%=viaSedeLegale%>" selected="selected"><%=viaSedeLegale %></option>
									
									<%
								}%>
								
                              </select>
                           </td>
                           <td>
                              <input type="text" name="civicoSedeLegale"
                                 id="civicoSedeLegale" size="5" placeholder="NUM." maxlength="15"
                                 required="required"  value="<%= civicoSedeLegale%>">
                           </td>
                           <td><input type="text" name="presso" id="presso" size="4"  value="<%= capSedeLegale%>"
                              placeholder="CAP" maxlength="5" required="required"> <input
                              type="button" value="Calcola CAP"  id="butCapSL"
                              onclick="if (document.getElementById('searchcodeIdComune').value!=''){ calcolaCap(document.getElementById('searchcodeIdComune').value, document.getElementById('toponimoSedeLegale').value, document.getElementById('viainput').value, 'presso') };" />
                           </td>
                        </tr>
                     </table>
                  <font color="red">(*)</font> </td>
               </tr>


<tr><th colspan="2">Dati stabilimento</th></tr>


<tr>
<td class="formLabel">Indirizzo</td>
<td><%=Anagrafica.getOperativaIndirizzo()%></td>
</tr>

<tr>
<td class="formLabel">Civico</td>
<td><%=Anagrafica.getOperativaCivico() %></td>
</tr>

<tr>
<td class="formLabel">Comune</td>
<td><%=Anagrafica.getOperativaDescrizioneComune() %>  <font color="red">(*)</font></td>
</tr>


<tr><th colspan="2">Rappresentante legale</th></tr>

 <tr>
                  <td class="formLabel">NOME</td>
                  <td><input type="text" size="70" id="nome" name="nome" value="<%=nomeRappresentante%>"> 
                  </td>
               </tr>
               <tr>
                  <td class="formLabel"><label for="cognome-2">COGNOME </label></td>
                  <td><input type="text" size="70" id="cognome" name="cognome" class="required" value="<%=cognomeRappresentante%>"> 
                  </td>
               </tr>
              
               <tr>
                  <td class="formLabel" nowrap >CODICE FISCALE</td>
                  <td><input type="text" name="codFiscaleSoggetto"  value="<%=codiceFiscaleRappresentante%>"
                      id="codFiscaleSoggetto" class="required" maxlength="16" /> <font color="red">(*)</font></td>
               </tr>
               
               
               
      <tr> <th colspan="2">Linea attività</th>        </tr>
               <tr>
<td class="formLabel">Attivita'</td>
<td>
<%if (Anagrafica.getLineaId1()>0) { %><%=Anagrafica.getLineaDescrizione1()%> <% } %>   <font color="red">(*)</font> 
<% if (Anagrafica.getProcessStato()==0) {%><input type="button" value="Seleziona Linea" onClick="selezionaLinea(1, '<%=Anagrafica.getId()%>')" /><br/><br/> <% } %>

<%if (Anagrafica.getLineaId2()>0) { %><%=Anagrafica.getLineaDescrizione2()%>    <font color="red">(*)</font> 
<% if (Anagrafica.getProcessStato()==0) {%><input type="button" value="Seleziona Linea" onClick="selezionaLinea(2, '<%=Anagrafica.getId()%>')" /><br/><br/> <% } } %>

<%if (Anagrafica.getLineaId3()>0) { %><%=Anagrafica.getLineaDescrizione3()%>  <font color="red">(*)</font> 
<% if (Anagrafica.getProcessStato()==0) {%><input type="button" value="Seleziona Linea" onClick="selezionaLinea(3, '<%=Anagrafica.getId()%>')" /><br/><br/> <% } } %>

<%if (Anagrafica.getLineaId4()>0) { %><%=Anagrafica.getLineaDescrizione4()%>  <font color="red">(*)</font> 
<% if (Anagrafica.getProcessStato()==0) {%><input type="button" value="Seleziona Linea" onClick="selezionaLinea(4, '<%=Anagrafica.getId()%>')" /><br/><br/> <% } } %>

<%if (Anagrafica.getLineaId5()>0) { %><%=Anagrafica.getLineaDescrizione5()%>  <font color="red">(*)</font> 
<% if (Anagrafica.getProcessStato()==0) {%><input type="button" value="Seleziona Linea" onClick="selezionaLinea(5, '<%=Anagrafica.getId()%>')" /><br/><br/> <%} } %>

<%if (Anagrafica.getLineaId6()>0) { %><%=Anagrafica.getLineaDescrizione6()%> <font color="red">(*)</font> 
<% if (Anagrafica.getProcessStato()==0) {%><input type="button" value="Seleziona Linea" onClick="selezionaLinea(6, '<%=Anagrafica.getId()%>')" /><br/><br/> <% } } %>

<%if (Anagrafica.getLineaId7()>0) { %><%=Anagrafica.getLineaDescrizione7()%>  <font color="red">(*)</font> 
<% if (Anagrafica.getProcessStato()==0) {%><input type="button" value="Seleziona Linea" onClick="selezionaLinea(7, '<%=Anagrafica.getId()%>')" /><br/><br/> <% } } %>

<%if (Anagrafica.getLineaId8()>0) { %><%=Anagrafica.getLineaDescrizione8()%>    <font color="red">(*)</font> 
<% if (Anagrafica.getProcessStato()==0) {%><input type="button" value="Seleziona Linea" onClick="selezionaLinea(8, '<%=Anagrafica.getId()%>')" /><br/><br/> <% } } %>

<%if (Anagrafica.getLineaId9()>0) { %><%=Anagrafica.getLineaDescrizione9()%>    <font color="red">(*)</font> 
<% if (Anagrafica.getProcessStato()==0) {%><input type="button" value="Seleziona Linea" onClick="selezionaLinea(9, '<%=Anagrafica.getId()%>')" /><br/><br/> <% } } %>

<%if (Anagrafica.getLineaId10()>0) { %><%=Anagrafica.getLineaDescrizione10()%>    <font color="red">(*)</font> 
<% if (Anagrafica.getProcessStato()==0) {%><input type="button" value="Seleziona Linea" onClick="selezionaLinea(10, '<%=Anagrafica.getId()%>')" /><br/><br/> <% } } %>
</td>
</tr>


</table>

<center>
<% if (Anagrafica.getProcessStato()==0) {%>
<input type="button" value="RIFIUTA" onClick="rifiutaRichiesta('<%=Anagrafica.getId()%>')"/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" value="SALVA"  onClick="salvaDati(this.form)" />
<input type="button" value="SALVA E PROCESSA" onClick="processaDati(this.form)"/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" value="ANNULLA" onClick="window.location.href='GestioneXML.do?command=Default'"/>
<% } %>
</center>
      
<input type="hidden" id="salva" name="salva" value=""/>
<input type="hidden" id="operazione" name="operazione" value="<%=Anagrafica.getOperazione()%>"/>
<input type="hidden" id="idLinea1" name="idLinea1" value="<%=Anagrafica.getLineaId1()%>"/>

   </form>




