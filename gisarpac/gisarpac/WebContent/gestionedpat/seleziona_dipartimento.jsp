<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="ListaDipartimenti" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ListaAnni" class="java.util.ArrayList" scope="request"/>

<%@ page import="org.aspcfs.modules.gestionedpat.base.*" %>

<script>
function vai(form){
		
	if (form.anno.value != -1 && form.idDipartimento.value != -1 ) {
		loadModalWindow();
		form.submit();
	}
}
</script>

<table class="trails" cellspacing="0">
<tr>
<td width="100%">
<a href="GestioneDPAT.do">DPAT</a>
</td>
</tr>
</table>

<form name="addAccount"	action="GestioneDPAT.do?command=ListaAreeComplesse&auto-populate=true" method="post">

<table class="details" width="100%" cellpadding="10" cellspacing="10">
<tr>
<td class="formLabel">Anno</td>
<td>
<select id="anno" name="anno" style="font-size:20px" onChange="vai(this.form)">
<option value="-1">SELEZIONARE ANNO</option>
<%for (int i = 0; i<ListaAnni.size(); i++) { 
int anno = (int) ListaAnni.get(i); %>
<option value="<%=anno%>"><%=anno %></option>
<%} %>
</select>
</td>
</tr>
<tr>
<td class="formLabel">Dipartimento</td>
<td>
<% ListaDipartimenti.addItem(-1, "SELEZIONARE DIPARTIMENTO"); ListaDipartimenti.setJsEvent("style='font-size:20px';  onChange='vai(this.form)'>");%> 
<%=ListaDipartimenti.getHtmlSelect("idDipartimento", -1) %>
</td>
</tr>
<tr>
<td class="FormLabel">Area Complessa</td>
<td><select style="font-size: 20px"><option value="-1">SELEZIONARE PRIMA ANNO E DIPARTIMENTO</option></select></td>
</tr>

<!-- <tr> -->
<!-- <td colspan="2"> -->
<!-- <input type="button" value="VAI" style="font-size: 20px; width: 100px" onClick="vai(this.form)"/> -->
<!-- </td> -->
<!-- </tr> -->

</table>

</form>
