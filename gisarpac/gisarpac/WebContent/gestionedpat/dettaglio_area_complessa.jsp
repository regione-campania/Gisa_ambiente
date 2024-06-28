<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="ListaDipartimenti" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="DettaglioAreaComplessa" class="org.aspcfs.modules.gestionedpat.base.AreaComplessa" scope="request"/>

<%@ page import="org.aspcfs.modules.gestionedpat.base.*" %>


<script>

function nuovaAreaSemplice(){
	document.getElementById("buttonAddAreaSemplice").style.display="none";
	document.getElementById("nomeAreaSemplice").style.display="table-row";
	document.getElementById("buttonAnnullaAreaSemplice").style.display="table-row";
	document.getElementById("buttonInsertAreaSemplice").style.display="table-row";
}
function annullaAreaSemplice(){
	document.getElementById("buttonAddAreaSemplice").style.display="table-row";
	document.getElementById("nomeAreaSemplice").value="";
	document.getElementById("nomeAreaSemplice").style.display="none";
	document.getElementById("buttonAnnullaAreaSemplice").style.display="none";
	document.getElementById("buttonInsertAreaSemplice").style.display="none";
}
function inserisciAreaSemplice(form){
	var esito = true;
	var msg = '';
	
	if (form.nomeAreaSemplice.value.trim() == ''){
		msg+= "Inserire nome AREA SEMPLICE. \n";
		esito = false;
	}
	
	if (!esito){
		alert(msg);
		return false;
		}
	
	loadModalWindow();
	
	form.action = "GestioneDPAT.do?command=InserisciAreaSemplice";
	form.submit();
}

function modificaAreaSemplice(id) {
	window.open('GestioneDPAT.do?command=ModificaAreaSemplice&idAreaSemplice='+id,'popupSelect',
'height=400px,width=800px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
}

function disabilitaAreaSemplice(id) {
	if (confirm("L'area semplice sara' disabilitata. Continuare?")){
		loadModalWindow();
		window.location.href="GestioneDPAT.do?command=DisableAreaSemplice&idAreaSemplice="+id;
	}	
}

function aggiungiNominativo(id) {
	window.open('GestioneDPAT.do?command=AggiungiNominativoAreaSemplice&idAreaSemplice='+id,'popupSelect',
	'height=600px,width=600px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
}

function eliminaNominativo(idNominativo, idArea) {
	if (confirm("Il nominativo selezionato sara' eliminato dall'area semplice. Continuare?")){
		loadModalWindow();
		window.location.href="GestioneDPAT.do?command=DeleteNominativoAreaSemplice&idAreaSemplice="+idArea+"&idNominativo="+idNominativo;
	}	
}


</script>

<table class="trails" cellspacing="0">
<tr>
<td width="100%">
<a href="GestioneDPAT.do">DPAT</a> > 
<a href="GestioneDPAT.do?command=ListaAreeComplesse&anno=<%=DettaglioAreaComplessa.getAnno() %>&idDipartimento=<%=DettaglioAreaComplessa.getIdDipartimento()%>"><%=DettaglioAreaComplessa.getAnno() %> / <%=ListaDipartimenti.getSelectedValue(DettaglioAreaComplessa.getIdDipartimento()) %></a> > 
<%= DettaglioAreaComplessa.getNome() %>
</td>
</tr>
</table>

<%-- <h2><%=DettaglioAreaComplessa.getAnno() %> / <%=ListaDipartimenti.getSelectedValue(DettaglioAreaComplessa.getIdDipartimento()) %> / <%= DettaglioAreaComplessa.getNome() %></h2> --%>

<center>
<% if (DettaglioAreaComplessa.getListaAreeSemplici().size()==0) { %>
<font color="red">Al momento non ci sono aree disponibili. Clicca su Aggiungi Area Semplice per inserirne una nuova.</font>
<%} %>

<form name="addAccount"	action="GestioneDPAT.do?command=InserisciAreaSemplice&auto-populate=true" method="post">
<input type="button" id="buttonAddAreaSemplice" style="font-size: 20px" value="Aggiungi area semplice" onClick="nuovaAreaSemplice()"/>
<input type="button" id="buttonAnnullaAreaSemplice" value="Annulla" onClick="annullaAreaSemplice()" style="display:none; font-size: 20px"/>
<input type="text" id="nomeAreaSemplice" name="nomeAreaSemplice" value="" placeholder="Nome area semplice" size="20" style="display:none; font-size: 20px; width: 600px"/>
<input type="button" id="buttonInsertAreaSemplice" value="Inserisci" onClick="inserisciAreaSemplice(this.form)" style="display:none; font-size: 20px"/>
<input type="hidden" id="idAreaComplessa" name="idAreaComplessa" value="<%=DettaglioAreaComplessa.getId()%>"/>
</form>
</center>

<% if (DettaglioAreaComplessa.getListaAreeSemplici().size()>0) { %>

<br/> 
<table class="details" width="100%" cellpadding="10" cellspacing="10">
<col width="10%">
<col width="40%">
<tr>
<th></th>
<th>Area semplice</th>
<th>Nominativi</th></tr>

<% for (int i = 0; i<DettaglioAreaComplessa.getListaAreeSemplici().size(); i++) {
AreaSemplice s = (AreaSemplice) DettaglioAreaComplessa.getListaAreeSemplici().get(i);%>

<tr>

<td align="center">
<input type="button" value="Modifica" onClick="modificaAreaSemplice('<%=s.getId()%>')" style="width:100px">
<br/><br/>
<input type="button" value="Disabilita" onClick="disabilitaAreaSemplice('<%=s.getId()%>')" style="width:100px"/>
</td>

<td align="center"><%=s.getNome()%></td>

<td>
<input type="button" value="Aggiungi" onClick="aggiungiNominativo('<%=s.getId()%>')" style="width:100px"/><br/>
<br/>
<% for (int j = 0; j<s.getListaNominativi().size(); j++) {
Nominativo n = (Nominativo) s.getListaNominativi().get(j);%>
<div style="border: 1px solid black; padding: 10px"><%= n.getNome() %> (<%=n.getQualifica() %>) <input type="button" value="Elimina" onClick="eliminaNominativo('<%=n.getId() %>', '<%=s.getId()%>')" style="width:100px"/>
</div>
<% } %>
</td></tr>
<% } %>
</table>

<%} %>

<script>
if (window.location.href.indexOf("DettaglioAreaComplessa")<=0)
	window.location.href = "GestioneDPAT.do?command=DettaglioAreaComplessa&idAreaComplessa=<%=DettaglioAreaComplessa.getId()%>";
</script>