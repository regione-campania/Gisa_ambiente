
<%@page import="org.aspcf.modules.checklist_benessere.base.Capitolo"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.aspcf.modules.checklist_benessere.base.Domanda"%>

<%@page import="org.aspcf.modules.checklist_benessere.base.Risposta"%>
<jsp:useBean id="Allevamento" class="org.aspcf.modules.controlliufficiali.base.Organization" scope="request"/>
<jsp:useBean id="AslList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ChecklistIstanza" class="org.aspcf.modules.checklist_benessere.base.ChecklistIstanza" scope="request"/>
<jsp:useBean id="Risposta" class="org.aspcf.modules.checklist_benessere.base.Risposta" scope="request"/>
<jsp:useBean id="domandePerrisposta_succ" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="numAllegato" class="java.lang.String" scope="request"/>
<jsp:useBean id="numCapitoli" class="java.lang.String" scope="request"/>
<jsp:useBean id="totale_punteggio_A" class="java.lang.String" scope="request"/>
<jsp:useBean id="totale_punteggio_B" class="java.lang.String" scope="request"/>
<jsp:useBean id="totale_punteggio_C" class="java.lang.String" scope="request"/>
<jsp:useBean id="totale_punteggio" class="java.lang.String" scope="request"/>
<jsp:useBean id="AzFields" class="org.aspcf.modules.controlliufficiali.base.AziendeZootFields" scope="request"/>
<jsp:useBean id="Ticket" class="org.aspcfs.modules.vigilanza.base.Ticket" scope="request"/>

<jsp:useBean id="ChecklistIstanzaCGO" class="org.aspcf.modules.checklist_benessere.base.ChecklistIstanzaCGO" scope="request"/>
<jsp:useBean id="ChecklistIstanzaCGO_2018" class="org.aspcf.modules.checklist_benessere.base.ChecklistIstanzaCGO_2018" scope="request"/> 

<%@ include file="../../../initPage.jsp" %>

<%@ include file="allegato_b11_js.jsp" %>


<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>


<%
if(request.getAttribute("Aggiornato")!=null)
{
	String urlDettaglio ="";
	if (Allevamento.getIdStabilimento()>0)
		urlDettaglio = "OpuStab";
	else
		urlDettaglio="Allevamenti";
%>
<script type="text/javascript">

//window.opener.location.href=window.opener.location.href;
	window.opener.loadModalWindow();
window.opener.location.href='<%=urlDettaglio%>Vigilanza.do?command=TicketDetails&id=<%=Allevamento.getIdControllo()%>&orgId=<%=Allevamento.getOrgId()%>&stabId=<%=Allevamento.getIdStabilimento()%>';

if (confirm('Salvataggio Avvenuto con Successo ! Vuoi Uscire dal Modello ?')==true){

	window.close();
}

</script>
<%} %>
<% String specie = Allevamento.getSpecie_allev();
   String codice_specie = Allevamento.getCodice_specie();
   if (codice_specie == null)
   codice_specie = "-1";  


%>

<input type="hidden" name="orgId" id="orgId" value="<%=Allevamento.getOrgId()%>"/>
<input type="hidden" name="stabId" id="stabId" value="<%=Allevamento.getIdStabilimento()%>"/>

<body >

<div class="boxIdDocumento"></div>
<div class="boxOrigineDocumento"><%@ include file="../../../hostName.jsp" %></div>

<br/><br/><br/> <!-- FACCIO POSTO PER BOX ID DOCUMENTO IN GENERA PDF -->

<form method="post" name="myform" action="PrintModulesHTML.do?command=UpdateChecklistBenessere&idControllo=<%=Allevamento.getIdControllo()%>&orgId=<%=Allevamento.getOrgId()%>&stabId=<%=Allevamento.getIdStabilimento()%>&specie=-1&auto-populate=true">


 <input type="hidden" name="idAlleg" id="idAlleg" value="15" />


<input type="hidden" name="orgId" id="orgId" value="<%=Allevamento.getOrgId()%>"/>
<input type="hidden" name="stabId" id="stabId" value="<%=Allevamento.getIdStabilimento()%>"/>

<body onload="" >

<% String versioneChecklistString = (String) request.getAttribute("versioneChecklist");
int versioneChecklist = -1;
if (versioneChecklistString!=null && !versioneChecklistString.equals(""))
	versioneChecklist = Integer.parseInt(versioneChecklistString);

%>

<% if (versioneChecklist == 3){ %>
<%@ include file="b11_frontespizio_cgo.jsp" %>
<% } else if (versioneChecklist == 4){ %>
<%@ include file="b11_frontespizio_cgo_2018.jsp" %>
<% } else {%> 
<%@ include file="b11_frontespizio_new.jsp" %>
<%} %>


<div class="fine" style="height: 50px;">&nbsp;</div>

<div align="right"><font color="red"><b>Si ricorda che la risposta "NO" genera una non conformità.</b></font></div>

<table class="tableClass" cellpadding="9" cellspacing="0" border="1" width="100%" class="details">
 	
   <% 
   Risposta curr = null ;
   int cap = 0 ;
   int iddom = 0 ;
   
   	  Iterator<Risposta> it = ChecklistIstanza.getRisposte().iterator();
	  int index = -1;
      while(it.hasNext()){
    	    
  	  		Risposta risposta = it.next();
  	  		
  	  		
  	  		
      
      		
  %>
  	<%
  	
  	 if(curr ==null || curr.getIdCap_fKey() != risposta.getIdCap_fKey() ) { 
  		cap++;
  		iddom = 0 ;
  		
  	%>
  		<tr>
  			<td <%=("checkbox".equals(risposta.getTipoCapitolo()) ||  "nocheck".equals(risposta.getTipoCapitolo())) ? "colspan='5' " : "colspan='2'"  %> style="font-weight: bold;background-color: gray;">
  				<%=risposta.getDescCap()%>
  			</td>
  			<%
  			
  			
  			if (!"nocheck".equals(risposta.getTipoCapitolo()) && !"checkbox".equals(risposta.getTipoCapitolo()))
  			{
  			%>
  			<td style="font-weight: bold;background-color: gray;">SI</td>
  			<td style="font-weight: bold;background-color: gray;">NO</td>
			<td style="font-weight: bold;background-color: gray;">N.A.</td>

  			<%} %>
  		</tr>   
	<% 
	curr = risposta ; 
	++index;
	}
	
	iddom = iddom + 1 ;
   	 
    		Risposta risposta_succ = risposta;
    		
  	%>	
  	
			<tr class="containerBody">
			<input type = "hidden" name="idRisposta_<%=cap %>_<%=iddom %>" value="<%=risposta.getId()%>"/>
			<%if ("nocheck".equals( risposta_succ.getTipoDomanda()))
			{
				
				%>
				
				
				<td colspan="5">
				<input type="hidden"  name="tipocapitolo_<%=cap%>_<%=(iddom)%>" id="tipocapitolo_<%=cap%>_<%=(iddom)%>" value="<%=risposta_succ.getTipoCapitolo()%>"/>
				<input type="hidden"  name="tipodomanda_<%=cap%>_<%=(iddom)%>" id="tipodomanda_<%=cap%>_<%=(iddom)%>" value="<%=risposta_succ.getTipoDomanda()%>"/>
				
				<%=risposta_succ.getDescDom() %></td>
				<%}
			else{
				if ("checkbox".equals( risposta_succ.getTipoDomanda()))
				{
					
				
					%>
				
				<td><%=(iddom) %></td>	
				<td colspan="4">
				
				
			
				<input type="checkbox"  <%= (ChecklistIstanza.isBozza()==false ) ? "disabled" : ""%>   name="esito_<%=cap%>_<%=(iddom)%>"  id="esito_si_<%=cap%>_<%=(iddom)%>" value="si" <%=(Boolean.TRUE.equals(risposta_succ.isEsito())) ? "checked=\"checked\"" : "" %>> 
				
				<%=risposta_succ.getDescDom() %>
				<input type="hidden"  name="tipocapitolo_<%=cap%>_<%=(iddom)%>" id="tipocapitolo_<%=cap%>_<%=(iddom)%>" value="<%=risposta_succ.getTipoCapitolo()%>"/>
				<input type="hidden"  name="tipodomanda_<%=cap%>_<%=(iddom)%>" id="tipodomanda_<%=cap%>_<%=(iddom)%>" value="<%=risposta_succ.getTipoDomanda()%>"/>
  					
				</td>	
				
				
					
					<%		
					
				}
					
				
				else
				{
				
				
			%>
  		<td>
  				<input type="hidden"  name="tipocapitolo_<%=cap%>_<%=(iddom)%>" id="tipocapitolo_<%=cap%>_<%=(iddom)%>" value="<%=risposta_succ.getTipoCapitolo()%>"/>
				<input type="hidden"  name="tipodomanda_<%=cap%>_<%=(iddom)%>" id="tipodomanda_<%=cap%>_<%=(iddom)%>" value="<%=risposta_succ.getTipoDomanda()%>"/>
  		<%=(iddom) %></td>
  		<td><%=risposta_succ.getDescDom() %></td>
  		<td>
  		
		
		<input <%= (ChecklistIstanza.isBozza()==false ) ? "disabled" : ""%> name="esito_<%=cap%>_<%=(iddom)%>" id="esito_si_<%=cap%>_<%=(iddom)%>" value="si" <%=(Boolean.TRUE.equals(risposta_succ.isEsito())) ? "checked=\"checked\"" : "" %> type="radio"/>
		
  		</td> 
		<td>
		<input <%= (ChecklistIstanza.isBozza()==false ) ? "disabled" : ""%> name="esito_<%=cap%>_<%=(iddom)%>" id="esito_no_<%=cap%>_<%=(iddom)%>"value="no" <%=(Boolean.FALSE.equals(risposta_succ.isEsito())) ? "checked=\"checked\"" : "" %> type="radio"/>
		
		</td> 
		
		<td>
		<input <%= (ChecklistIstanza.isBozza()==false ) ? "disabled" : ""%> name="esito_<%=cap%>_<%=(iddom)%>" id="esito_na_<%=cap%>_<%=(iddom)%>"value="na" <%=(risposta_succ.isEsito()==null) ? "checked=\"checked\"" : "" %> type="radio"/>
		</td>

		
	<%}} %>
			</tr>		
  		
  		
  		
<% }
  	  %>
<%-- 	<tr class="textDim"><td colspan="5"><b>NOTE:<br><textarea <%= (ChecklistIstanza.isBozza()==false ) ? "disabled" : ""%> name ="mod_b11_note" class="textDim" rows="6" cols="80" value = "<%=ChecklistIstanza.getMod_b11_note() %>" ><%=ChecklistIstanza.getMod_b11_note() %></textarea></b></td></tr> --%>
 <tr>
 <td colspan="5">
<table class = "noborder">
 <tr><td colspan="2"><b>Preavviso (max 48 ore):</b></td></tr>
  <td> NO [&nbsp;<%if (Ticket.getFlag_preavviso()==null || ( Ticket.getFlag_preavviso()!=null && Ticket.getFlag_preavviso().equalsIgnoreCase("n"))){%>X<%} %>&nbsp;] SI [&nbsp;<% if (Ticket.getFlag_preavviso()!=null && !Ticket.getFlag_preavviso().equalsIgnoreCase("n")){%>X<%} %>&nbsp;] </td>
 </tr>
 <tr>
 <td> Se SI in data <label class="layout"><%=toDateasString(Ticket.getData_preavviso_ba()) %></label> tramite: </td></tr>
 <tr>
 <td> [&nbsp;<% if (Ticket.getFlag_preavviso()!=null && Ticket.getFlag_preavviso().equals("P")){%>X<%} %>&nbsp;] Telefono</td></tr>
 <tr>
 <td>[&nbsp;<% if (Ticket.getFlag_preavviso()!=null && Ticket.getFlag_preavviso().equals("T")){%>X<%} %>&nbsp;] Telegramma/lettera/fax</td></tr>
 <tr>
 <td>[&nbsp;<% if (Ticket.getFlag_preavviso()!=null && Ticket.getFlag_preavviso().equals("A")){%>X<%} %>&nbsp;] Altra forma ............... </td></tr>
 </table>
 </td>
 </tr>
  
<!--   <tr class="textDim"><td colspan="5">L'esito del presente controllo sarà considerato anche per la verifica del rispetto degli impegni di -->
<!-- condizionalità</td></tr> -->
<%--  <tr class="textDim"><td colspan="5"><b>Provvedimenti adottati:<br><textarea class="textDim" rows="6" cols="80"  <%= (ChecklistIstanza.isBozza()==false ) ? "readonly" : ""%> name="mod_b11_provvedimenti" value="<%=ChecklistIstanza.getMod_b11_provvedimenti()!= null ? ChecklistIstanza.getMod_b11_provvedimenti() : "" %>" ><%=ChecklistIstanza.getMod_b11_provvedimenti()!= null ? ChecklistIstanza.getMod_b11_provvedimenti() : "" %></textarea></b></td></tr> --%>
<!-- <tr><td colspan="5"><b>È stata lasciata una copia della presente check-list all'allevatore?</b><br> -->
 
<%--  <input type="radio" <%= (ChecklistIstanza.isBozza()==false ) ? "disabled" : ""%> name = "mod_b11_flag_rilascio_copia" value = "No" <%=(!ChecklistIstanza.isMod_b11_flag_rilascio_copia() ) ? "checked=\"checked\"" : ""%>/>No<br> --%>
<%--  <input type="radio" <%= (ChecklistIstanza.isBozza()==false ) ? "disabled" : ""%> name = "mod_b11_flag_rilascio_copia" value = "Si" <%=(ChecklistIstanza.isMod_b11_flag_rilascio_copia() ) ? "checked=\"checked\"" : ""%>/>Si<br> --%>

<!-- </td></tr> -->

  
  </table >
 
 <% if (versioneChecklist == 3){ %>
<%@ include file="b11_footer_cgo.jsp" %>
<% } else if (versioneChecklist == 4){ %>
<%@ include file="b11_footer_cgo_2018.jsp" %>
<% } %>
  
  
  
 <%if (ChecklistIstanza.isBozza()==true ) {%>
  	<div id="idbtn" style="display:block;">
       	<input type="button" class="buttonClass" name="salva" value="Aggiorna Temporaneo" onclick="if (checkFormB11()==false){return false;}; javascript:if( confirm('La scheda sarà aggiornata come richiesto. Vuoi procedere con il salvataggio?')){document.myform.bozza.value = true; return document.myform.submit();}else return false;"/> &nbsp;
  		<input type="button"  class="buttonClass" name="salva" value="Aggiorna Definitivo" onclick="if (checkFormB11()==false){return false;}; javascript:if( confirm('La scheda sarà aggiornata come richiesto ma i dati non saranno più modificabili. Vuoi procedere con il salvataggio definitivo?')){document.myform.bozza.value = false; return document.myform.submit();}else return false;"/> &nbsp;
  	</div>
  	<%} %>
  	<br> 
  		<input type="hidden" name="bozza" value="<%=ChecklistIstanza.isBozza()%>" />
  		  <input type="hidden" name="idCU" id="idCU" value="<%=Allevamento.getIdControllo()%>" />
  		
  		<dhv:permission name="server_documentale-view">
  				<!--  BOX DOCUMENTALE -->
	  <jsp:include page="../../gestione_documenti/boxDocumentale.jsp">
    <jsp:param name="orgId" value="<%=request.getParameter("orgId") %>" />
        <jsp:param name="stabId" value="<%=request.getParameter("idStabilimento") %>" />
     <jsp:param name="ticketId" value="<%=request.getParameter("idControllo") %>" />
      <jsp:param name="tipo" value="allegato" />
       <jsp:param name="idCU" value="<%=request.getParameter("specie") %>" />
        <jsp:param name="url" value="<%=request.getParameter("url") %>" />
</jsp:include>
<!--  BOX DOCUMENTALE -->
    </dhv:permission>
    <br>
 
  <br>
  <br>
     <table class="noborder" width="100%">
     <tr><td style="text-align: left"><b> Data del controllo Ufficiale </b></td>  
     <td style="text-align: right;"><b>Sottoscrizione del Veterinario che ha compiuto l'ispezione </b></td>
     </tr>
</table>
 </form> 
 </body> 