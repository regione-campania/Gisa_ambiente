<jsp:useBean id="idAllerta" class="java.lang.String" scope="request"/>
<jsp:useBean id="SiteIdListF" class="org.aspcfs.utils.web.LookupList" scope="request"/>

 <script language="JavaScript" TYPE="text/javascript" SRC="gestione_documenti/generazioneDocumentale.js"></script>

<%
HashMap<Integer, String> NoteAllegatoF = (HashMap<Integer, String>)request.getAttribute("NoteAllegatoF");
HashMap<Integer, Boolean> AllegatoFGenerabile = (HashMap<Integer, Boolean>)request.getAttribute("AllegatoFGenerabile");
%>


<script>

function controlloAsl(){
	var esito = true;

	var idAsl = document.getElementById("idAsl").value;
	var esito101=null; 

	<%
	for (Map.Entry<Integer, Boolean> entry : AllegatoFGenerabile.entrySet()) {
	    int key = entry.getKey();
	    Boolean value = entry.getValue();
	    if (key==101){ %>
	    esito101 = <%=value%>;
	   
	
	if (idAsl == 101)
		esito = esito101;
	
	if (esito==null){
		alert('Impossibile generare Allegato F ASL. Non ci sono controlli su questa ASL.');
		return false;
	}
	
	if (!esito)
		alert('Impossibile generare Allegato F ASL. Alcune liste di distribuzione per questa ASL risultano nello stato APERTO.');
	
	return esito;
	
}
function controlloRegione() {
	var esito = true;
	
	<% if (TicketDetails.getResolutionDate()==null ) { %>
	esito = false;
	alert('Impossibile generare Allegato F. Questa Allerta risulta nello stato APERTO.');
	<%} %>
	return esito;
}

function modificaNote(idAllerta, id)
{
	  if (id=='0'){
		  document.getElementById("newNote").style.display="none";
		  document.getElementById("oldNote").style.display="";
	  }
	  else {
		  document.getElementById("oldNote").style.display="none";
		  document.getElementById("newNote").style.display="";
	  }
	
}

function checkFormNote(form){
	 
	var note = document.getElementById("note").value;
	
	if (note== null || trim(note) == ''){
		alert('Attenzione. Compilare il campo note.');
		return false;
	}
		
	if (confirm("La modifica alle note sar� salvata per questa ASL. Proseguire?")){
		loadModalWindow();
	
		form.action = 'TroubleTicketsAllerteNew.do?command=UpdateNote';
		form.submit();
	}
	
}

</script>



<script>
function aggiornaNotePerAsl(){
var idAsl = document.getElementById("idAsl").value;
var note201=""; var note202=""; var note203=""; var note204=""; var note205=""; var note206=""; var note207="";

<%
	for (Map.Entry<Integer, String> entry : NoteAllegatoF.entrySet()) {
	    int key = entry.getKey();
	    String value = entry.getValue();
	    if (value==null || value=="null")
	    	value="";
	    else
	    	value = toHtmlValue(value.replaceAll("'", "\'"));
	    
	    if (key==201){%> note201 = "<%=value%>";
	    <%} else if (key==202){%> note202 =  "<%=value%>";
   		<%} else if (key==203){%> note203 =  "<%=value%>";
    	<%} else if (key==204){%> note204 =  "<%=value%>";
    	<%} else if (key==205){%> note205 =  "<%=value%>";
    	<%} else if (key==206){%> note206 =  "<%=value%>";
    	<%} else if (key==207){%> note207 =  "<%=value%>";
    	<%} }	%>
	
    	if (idAsl=='201'){
    		document.getElementById("vecchieNote").innerHTML = note201;
    		document.getElementById("note").value = note201;
    	}
    	else if (idAsl=='202'){
        	document.getElementById("vecchieNote").innerHTML = note202;
    		document.getElementById("note").value = note202;
   		}
    	else if (idAsl=='203'){
        	document.getElementById("vecchieNote").innerHTML = note203;
    		document.getElementById("note").value = note203;
		}
    	else if (idAsl=='204'){
    		document.getElementById("vecchieNote").innerHTML = note204;
    		document.getElementById("note").value = note204;
        }
    	else if (idAsl=='205'){
        	document.getElementById("vecchieNote").innerHTML = note205;
    		document.getElementById("note").value = note205;
        }
    	else if (idAsl=='206'){
        	document.getElementById("vecchieNote").innerHTML = note206;
    		document.getElementById("note").value = note206;
        }
    	else if (idAsl=='207'){
        	document.getElementById("vecchieNote").innerHTML = note207;
    		document.getElementById("note").value = note207;
        }
	
}


function openPopupAllegatoF(idAllerta, idAsl, tipoAllegato){
	if (idAsl==null || idAsl=='')
		idAsl = '-1';
	  window.open('TroubleTicketsAllerteNew.do?command=GeneraAllegatoF&tipo=AllegatoF&idAllerta='+idAllerta +'&idAsl='+idAsl+'&tipoAllegato='+tipoAllegato,'popupSelect',
      'height=800px,width=1280px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
}

function openPopupAllegatoFModificabile(idAllerta, idAsl, tipoAllegato){
	if (idAsl==null || idAsl=='')
		idAsl = '-1';
	  window.open('TroubleTicketsAllerteNew.do?command=GeneraAllegatoFModificabile&tipo=AllegatoF&idAllerta='+idAllerta +'&idAsl='+idAsl+'&tipoAllegato='+tipoAllegato,'popupSelect',
      'height=800px,width=1280px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
}

</script>



<% boolean permessoAsl = false;
boolean permessoRegione = false; %>

<dhv:permission name="allerte-allegatof-asl-view">
<%permessoAsl = true;%>
</dhv:permission>
<dhv:permission name="allerte-allegatof-regione-view">
<%permessoRegione = true;%>
</dhv:permission>


<%if (permessoAsl || permessoRegione){ %>

<table cellpadding="4" cellspacing="0" class="details">
	<tr>
	<th colspan="2">
    <strong>Allegato F</strong>
    </th>
    </tr>
 
 <% if (permessoAsl){ %>
 <tr>
 <td  nowrap class="formLabel"> ASL</td>
 <td>
 <%SiteIdListF.setJsEvent("onChange=\"aggiornaNotePerAsl()\""); %>
 <%= SiteIdListF.getHtmlSelect("idAsl", -1) %>
 <img src="images/icons/stock_print-16.gif" border="0" align="absmiddle" height="16" width="16"/>
 <input type="button" title="GENERA ALLEGATO F ASL" value="GENERA ALLEGATO F ASL" onClick="if (controlloAsl()) { openRichiestaPDFAllegatoF('<%=idAllerta %>', document.getElementById('idAsl').value,'Asl'); }">
  <img src="images/icons/stock_zoom-page-16.gif" border="0" align="absmiddle" height="16" width="16"/>
   <a href="#" onClick="openPopupAllegatoF('<%=idAllerta %>', document.getElementById('idAsl').value,'Asl');"><u>Visualizza</u></a>
   <a href="#" onClick="openPopupAllegatoFModificabile('<%=idAllerta %>', document.getElementById('idAsl').value,'Asl');"><u>Versione Modificabile</u></a>
   </td>
 </tr>
 
  <tr>
  <td  nowrap class="formLabel"> NOTE</td>
  <td id="oldNote">
  <label id="vecchieNote"></label>
  
  <dhv:permission name="allerte-allegatof-asl-edit">
  <a href="#" onClick="modificaNote('<%=idAllerta %>', 1); return false;">
  <u>Modifica Note</u></a>
  </dhv:permission>
  
  </td>
  <td id="newNote" style="display:none"> 
  <textarea id="note" name="note" rows="3" cols="30"></textarea>
  <input type="button" value="SALVA" onClick="checkFormNote(this.form)"/> 
  <a href="#" onClick="modificaNote('<%=idAllerta %>', 0); return false;"><u>Annulla</u></a>
  </td>
</tr>

<script>
document.getElementById("idAsl").onchange();
</script>
 <%} 
 
	if (permessoRegione){ %>
 <tr>
  <td  nowrap class="formLabel"> REGIONE</td>
 <td>
<img src="images/icons/stock_print-16.gif" border="0" align="absmiddle" height="16" width="16"/>
 <input type="button" title="GENERA ALLEGATO F REGIONE" value="GENERA ALLEGATO F REGIONE" onClick="if (controlloRegione()) { openRichiestaPDFAllegatoF('<%=idAllerta %>', document.getElementById('idAsl').value,'Regione');} ">
 <img src="images/icons/stock_zoom-page-16.gif" border="0" align="absmiddle" height="16" width="16"/>
 <a href="#" onClick="openPopupAllegatoF('<%=idAllerta %>', document.getElementById('idAsl').value,'Regione');"><u>Visualizza</u></a>
 <a href="#" onClick="openPopupAllegatoFModificabile('<%=idAllerta %>', -1, 'Regione')"><u>Versione Modificabile</u></a>
  </td>
</tr>
<%} %>


</table>

<input type="hidden" name="idAllerta" id="idALlerta" value="<%=idAllerta%>"/>

<%} %>


