<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="ListaAnni" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="ListaDipartimenti" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ListaAreeComplesse" class="java.util.ArrayList" scope="request"/>
<jsp:useBean id="idDipartimento" class="java.lang.String" scope="request"/>
<jsp:useBean id="anno" class="java.lang.String" scope="request"/>

<%@ page import="org.aspcfs.modules.gestionedpat.base.*" %>

<script>

function vaiListaAree(form){
	loadModalWindow();
	form.action = "GestioneDPAT.do?command=ListaAreeComplesse";
	form.submit();
}

function vai(form){
	var esito = true;
	var msg = '';
	
	if (form.idAreaComplessa.value == -1){
		msg+= "Selezionare AREA COMPLESSA. \n";
		esito = false;
	}
	
	if (!esito){
		alert(msg);
		return false;
		}
	
	loadModalWindow();
	form.action = "GestioneDPAT.do?command=DettaglioAreaComplessa";
	form.submit();
}

function nuovaAreaComplessa(){
	document.getElementById("buttonAddAreaComplessa").style.display="none";
	document.getElementById("nomeAreaComplessa").style.display="table-row";
	document.getElementById("buttonAnnullaAreaComplessa").style.display="table-row";
	document.getElementById("buttonInsertAreaComplessa").style.display="table-row";
}
function annullaAreaComplessa(){
	document.getElementById("buttonAddAreaComplessa").style.display="table-row";
	document.getElementById("nomeAreaComplessa").value="";
	document.getElementById("nomeAreaComplessa").style.display="none";
	document.getElementById("buttonAnnullaAreaComplessa").style.display="none";
	document.getElementById("buttonInsertAreaComplessa").style.display="none";
}
function inserisciAreaComplessa(form){
	var esito = true;
	var msg = '';
	
	if (form.nomeAreaComplessa.value.trim() == ''){
		msg+= "Inserire nome AREA COMPLESSA. \n";
		esito = false;
	}
	
	if (!esito){
		alert(msg);
		return false;
		}
	
	loadModalWindow();
	form.idAreaComplessa.value = -1;
	form.action = "GestioneDPAT.do?command=InserisciAreaComplessa";
	form.submit();
}

</script>

<table class="trails" cellspacing="0">
<tr>
<td width="100%">
<a href="GestioneDPAT.do">DPAT</a>
</td>
</tr>
</table>


<%-- <h2><%=anno %> / <%=ListaDipartimenti.getSelectedValue(idDipartimento) %></h2> --%>

<form name="addAccount"	action="GestioneDPAT.do?command=DettaglioAreaComplessa&auto-populate=true" method="post">

<table class="details" width="100%" cellpadding="10" cellspacing="10">
<tr>
<td class="formLabel">Anno</td>
<td>
<select id="anno" name="anno" style="font-size:20px" onChange="vaiListaAree(this.form)">
<%for (int i = 0; i<ListaAnni.size(); i++) { 
int anno2 = (int) ListaAnni.get(i); %>
<option value="<%=anno2%>" <%=anno2==Integer.parseInt(anno) ? "selected" : "" %>><%=anno2 %></option>
<%} %>
</select>
</td>
</tr>
<tr>
<td class="formLabel">Dipartimento</td>
<td>
<% ListaDipartimenti.setJsEvent("style='font-size:20px';  onChange='vaiListaAree(this.form)'>");%> 
<%=ListaDipartimenti.getHtmlSelect("idDipartimento", idDipartimento) %>
</td>
</tr>
<tr>
<td class="formLabel">Area Complessa</td>
<td>
<select id="idAreaComplessa" name="idAreaComplessa" style="font-size: 20px">
<option value="-1">Selezionare area complessa</option>
<%for (int i = 0; i<ListaAreeComplesse.size(); i++) { 
AreaComplessa s = (AreaComplessa) ListaAreeComplesse.get(i); %>
<option value="<%=s.getId()%>"><%=s.getNome() %></option>
<%} %>
</select>
<input type="button" style="font-size: 20px; width: 100px" value="VAI" onClick="vai(this.form)"/>
</td>
</tr>

<tr><td class="formLabel"></td>
<td>
<input type="button" id="buttonAddAreaComplessa" style="font-size: 20px" value="Inserisci nuova area complessa" onClick="nuovaAreaComplessa()"/>
<input type="button" id="buttonAnnullaAreaComplessa" value="Annulla" onClick="annullaAreaComplessa()" style="display:none; font-size: 20px"/>
<input type="text" id="nomeAreaComplessa" name="nomeAreaComplessa" value="" placeholder="Nome area complessa" style="display:none; font-size: 20px; width: 600px"/>
<input type="button" id="buttonInsertAreaComplessa" value="Inserisci" onClick="inserisciAreaComplessa(this.form)" style="display:none; font-size: 20px"/>
</td></tr>

</form>


<script>
if (window.location.href.indexOf("ListaAreeComplesse")<=0)
	window.location.href = "GestioneDPAT.do?command=ListaAreeComplesse&anno<%=anno%>&idDipartimento=<%=idDipartimento%>";
</script>