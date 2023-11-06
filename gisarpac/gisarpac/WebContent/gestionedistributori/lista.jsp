<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
 
<jsp:useBean id="listaDistributori" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="riferimentoId" class="java.lang.String" scope="request"/>
<jsp:useBean id="riferimentoIdNomeTab" class="java.lang.String" scope="request"/>
<jsp:useBean id="Messaggio" class="java.lang.String" scope="request"/>

<%@ page import="org.aspcfs.modules.gestionedistributori.base.*" %>

<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery-1.8.2.js"></script>
<script src="javascript/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>
<link rel="stylesheet" href="gestionedistributori/css/screen.css" type="text/css" media="screen" />

<DIV ID='modalWindow' CLASS='unlocked'><P CLASS='wait'>Attendere il completamento dell'operazione...</P></DIV>

<script>
function modifica(i){
	var matricola = document.getElementById("matricola_"+i);
	var dataI = document.getElementById("dataInstallazione_"+i);
	var ubicazione = document.getElementById("ubicazione_"+i);
	var indirizzo = document.getElementById("indirizzo_"+i);
	var comune = document.getElementById("comune_"+i);
	
	var detail = document.getElementById("detail_"+i);
	var insert = document.getElementById("insert_-1");
	var aggiorna = document.getElementById("divAggiorna_"+i);
	
	matricola.readOnly=false;
	dataI.readOnly=false;
	ubicazione.readOnly=false;
	indirizzo.readOnly=false;
	comune.readOnly=false;
	
	aggiorna.style.display="block";
	insert.style.display="none";
	detail.style.backgroundColor="yellow";

	var modifica = document.getElementsByClassName("divModifica")
	for (var j = 0; j < modifica.length; j++){
	        modifica[j].style.display = "none";
	}
	
	
}

function dismetti(i){
	var dataD = document.getElementById("dataDismissione_"+i);
	
	var detail = document.getElementById("detail_"+i);
	var insert = document.getElementById("insert_-1");
	var aggiorna = document.getElementById("divAggiorna_"+i);
	
	dataD.readOnly=false;
	
	aggiorna.style.display="block";
	insert.style.display="none";
	detail.style.backgroundColor="yellow";

	var modifica = document.getElementsByClassName("divModifica")
	for (var j = 0; j < modifica.length; j++){
	        modifica[j].style.display = "none";
	}
		
}

function annulla(i){
	var matricola = document.getElementById("matricola_"+i);
	var dataI = document.getElementById("dataInstallazione_"+i);
	var dataD = document.getElementById("dataDismissione_"+i);
	var ubicazione = document.getElementById("ubicazione_"+i);
	var indirizzo = document.getElementById("indirizzo_"+i);
	var comune = document.getElementById("comune_"+i);
	var modifica = document.getElementById("modifica_"+i);
	var dismetti = document.getElementById("dismetti_"+i);
	var detail = document.getElementById("detail_"+i);
	var insert = document.getElementById("insert_-1");
	var aggiorna = document.getElementById("divAggiorna_"+i);

	matricola.readOnly=true;
	dataI.readOnly=true;
	dataD.readOnly=true;
	ubicazione.readOnly=true;
	indirizzo.readOnly=true;
	comune.readOnly=true;
	
	insert.style.display="table-row";
	aggiorna.style.display="none";
	detail.style.backgroundColor="";

	var modifica = document.getElementsByClassName("divModifica")
	for (var j = 0; j < modifica.length; j++){
	        modifica[j].style.display = "block";
	}
	
}

function upsert(form, indice){
	
	var matricola = document.getElementById("matricola_"+indice);
	var dataI = document.getElementById("dataInstallazione_"+indice);
	var dataD = document.getElementById("dataDismissione_"+indice);
	var ubicazione = document.getElementById("ubicazione_"+indice);
	var indirizzo = document.getElementById("indirizzo_"+indice);
	var comune = document.getElementById("comune_"+indice);
	
	var msg = '';
	
	if (matricola!=null && matricola.readOnly!=true && matricola.value=='')
		msg+= "Inserire la matricola. \n";
	if (dataI!=null && dataI.readOnly!=true && dataI.value=='')
		msg+= "Inserire la data installazione. \n";
	if (dataD!=null && dataD.readOnly!=true && dataD.value=='')
		msg+= "Inserire la data dismissione. \n";
	if (ubicazione!=null && ubicazione.readOnly!=true && ubicazione.value=='')
		msg+= "Inserire l'ubicazione. \n";
	if (indirizzo!=null && indirizzo.readOnly!=true && indirizzo.value=='')
		msg+= "Inserire l'indirizzo. \n";
	if (comune!=null && comune.readOnly!=true && comune.value=='')
		msg+= "Inserire il comune. \n";
	
	if (msg!=''){
		alert(msg);
		return false;
	}
	
	loadModalWindow();
	form.indice.value=indice;
	form.submit();
}

function elimina(form, indice){
	if (confirm("Attenzione. Questo dato sara' ELIMINATO e non sara' piu' ricercabile nel sistema.")){
		form.action='GestioneDistributori.do?command=Delete';
		loadModalWindow();
		form.indice.value=indice;
		form.submit();
	}
}

function importDistributori(form){ 
		
	loadModalWindow();
	form.action="GestioneDistributori.do?command=ToImport";
	form.submit();
}


</script>

<%if (Messaggio!=null && !Messaggio.equals("")){ %>
<center><div class="intestazione" style="background:<%=Messaggio.startsWith("OK") ? "lime" : "red" %>"><%=Messaggio %></div><br/>
<%} %>

<form name="addDistributore" action="GestioneDistributori.do?command=Upsert&auto-populate=true" method="post">

<table cellpadding="8" cellspacing="0" border="0" style="width: 100%" class="pagedList">
	
<tr>
<th>Matricola</th>
<th>Data Installazione</th>
<th>Data Dismissione</th>
<th>Ubicazione</th>
<th>Indirizzo</th>
<th>Comune</th>
<th>Operazioni</th>
</tr>


<% for (int i=0;i<listaDistributori.size(); i++){
		Distributore dist = (Distributore) listaDistributori.get(i); %>
<tr id="detail_<%=i%>">
<input type="hidden" id="id_<%=i %>" name="id_<%=i %>" value="<%=dist.getId() %>"/>

<td><input type="text" id="matricola_<%=i %>" name="matricola_<%=i %>" value="<%=dist.getMatricola() %>" readOnly/></td>
<td><input type="date" id="dataInstallazione_<%=i%>" name="dataInstallazione_<%=i%>" value="<%=dist.getDataInstallazione() %>" readOnly/></td>
<td><input type="date" id="dataDismissione_<%=i%>" name="dataDismissione_<%=i%>" value="<%=dist.getDataDismissione() %>" readOnly/></td>
<td><input type="text" id="ubicazione_<%=i %>" name="ubicazione_<%=i %>" value="<%=dist.getUbicazione() %>" readOnly/></td>
<td><input type="text" id="indirizzo_<%=i %>" name="indirizzo_<%=i %>" value="<%=dist.getIndirizzo() %>" readOnly/></td>
<td><input type="text" id="comune_<%=i %>" name="comune_<%=i %>" value="<%=dist.getComune() %>" readOnly/></td>
<td>

<dhv:permission name="gestione-distributori-add">
 <center>
 <% if(dist.getDataDismissione()==null || dist.getDataDismissione().equals("")) { %>
<div class="divModifica">
<input type="button" id="modifica_<%=i %>" value="MODIFICA" onClick="modifica('<%=i%>')"/> 
<input type="button" id="dismetti_<%=i %>"value="DISMETTI" onClick="dismetti('<%=i%>')"/>
</div>
<%} %> 
<div id="divAggiorna_<%=i %>" style="display:none" >
<input type="button" id="annulla_<%=i %>" value="ANNULLA"onClick="annulla('<%=i%>')"/>
<input type="button" id="aggiorna_<%=i %>" value="AGGIORNA" onClick="upsert(this.form, '<%=i%>')"/> 
</div>
</center>
</dhv:permission>

<dhv:permission name="gestione-distributori-delete">
<center>
<input type="button" id="elimina_<%=i %>" value="ELIMINA" style="background-color:red" onClick="elimina(this.form, '<%=i%>')"/>
</center>
</dhv:permission>

</td>
</tr>
<% } %>


<tr id="insert_-1">
<input type="hidden" id="id_-1" name="id_-1" value="-1"/>
<td><input type="text" id="matricola_-1" name="matricola_-1" placeholder="MATRICOLA"</td>
<td><input type="date" id="dataInstallazione_-1" name="dataInstallazione_-1" placeholder="DATA INSTALLAZIONE"</td>
<td></td>
<td><input type="text" id="ubicazione_-1" name="ubicazione_-1" placeholder="UBICAZIONE"</td>
<td><input type="text" id="indirizzo_-1" name="indirizzo_-1" placeholder="INDIRIZZO"</td>
<td><input type="text" id="comune_-1" name="comune_-1" placeholder="COMUNE"</td>
<td>

<dhv:permission name="gestione-distributori-add">
<center><input type="button" value="INSERISCI" onClick="upsert(this.form, -1)"/></center>
</dhv:permission>

</td>
</tr>

</table>

<input type="hidden" id="riferimentoId" name="riferimentoId" value="<%=riferimentoId%>"/>
<input type="hidden" id="riferimentoIdNomeTab" name="riferimentoIdNomeTab" value="<%=riferimentoIdNomeTab%>"/>
<input type="hidden" id="indice" name="indice" value=""/>

<dhv:permission name="gestione-distributori-add">
<br/><br/>
<center><input type="button" value="CARICAMENTO MASSIVO" onClick="importDistributori(this.form, -1)"/></center>
</dhv:permission>

</form>

<br/><br/>

<center>
<input type="button" class="blueBigButton" value="CHIUDI" onClick="window.close()"/>
</center>
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
