<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="dato" class="org.aspcfs.modules.gestionedatiautorizzativi.base.DatoAutorizzativo" scope="request"/>
<jsp:useBean id="riferimentoId" class="java.lang.String" scope="request"/>
<jsp:useBean id="riferimentoIdNomeTab" class="java.lang.String" scope="request"/>

<jsp:useBean id="statiList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="listaStorico" class="java.util.ArrayList" scope="request"/>

<jsp:useBean id="Messaggio" class="java.lang.String" scope="request"/>

<%@ page import="org.aspcfs.modules.gestionestatoanagrafica.base.*"%>
<%@ page import="org.aspcfs.utils.web.*"%>

<%@ include file="../initPage.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery-1.8.2.js"></script>
<script src="javascript/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<%! public static String fixData(Object objData)
  {
	  String toRet = "";
	  if (objData == null || objData.equals(""))
		  return toRet;
	  String data = objData.toString();
	  String anno = data.substring(0,4);
	  String mese = data.substring(5,7);
	  String giorno = data.substring(8,10);
	  toRet =giorno+"/"+mese+"/"+anno;
	  return toRet;
	  
  }%>


<% if (Messaggio!=null && !Messaggio.equals("")){ %>
<script>
alert('<%=Messaggio%>');

<% if (riferimentoIdNomeTab.equalsIgnoreCase("aia_stabilimento")){%>
window.opener.location.href="StabilimentoAIA.do?command=Details&stabId=<%=riferimentoId%>";
<% } %>

window.close();

</script>
<% } %>

<script>
function checkForm(form){
	
	if (form.dataCambioStato.value==''){
		alert('Indicare una data cambio stato.');
		return false;
	}
	
	if (confirm("Eseguire la modifica dello stato con i dati indicati?")) {	
		loadModalWindow();
		form.submit();
	}
}


</script>

<form name="modificaStatoAnagrafica" action="GestioneStatoAnagrafica.do?command=Insert&auto-populate=true" onSubmit="" method="post">

<table class="details" cellpadding="10" cellspacing="10" width="100%" style="border-collapse: collapse">
<col width="50%">
<tr><th colspan="2">STATO ANAGRAFICA</th></tr>
<tr><td CLASS="formLabel">NUOVO STATO</td> <td><%=statiList.getHtmlSelect("idStato", -1) %></td></tr>
<tr><td CLASS="formLabel">DATA CAMBIO STATO</td> <td><input type="date" id="dataCambioStato" name="dataCambioStato" value=""/></td></tr>
<tr><td CLASS="formLabel">NOTA</td> <td><input type="text" id="nota" name="nota" value=""/></td></tr>
</table>

<br/>

<!-- BOTTONI -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<tr>
<td colspan="2" align="center"><br/><br/>
<input type="button" style="font-size:40px" value="CONFERMA" onclick="checkForm(this.form)"/>
</td>
</tr>
</table>
<!-- BOTTONI -->

<br/>

<input type="hidden" id="riferimentoId" name="riferimentoId" value="<%=riferimentoId%>"/>
<input type="hidden" id="riferimentoIdNomeTab" name="riferimentoIdNomeTab" value="<%=riferimentoIdNomeTab%>"/>

</form>

<br/><br/>

<% if (listaStorico.size()>0) {%>

<table class="details" cellpadding="10" cellspacing="10" width="100%" style="border-collapse: collapse">

<tr> <th colspan="6">STORICO CAMBIO STATO</th></tr>

<tr>
<th>DATA OPERAZIONE</th>
<th>STATO PRE-MODIFICA</th>
<th>STATO POST-MODIFICA</th>
<th>DATA CAMBIO STATO</th>
<th>NOTA</th>
<th>UTENTE MODIFICA</th>
</tr>

<% for (int i = 0; i<listaStorico.size(); i++) {
StatoAnagrafica stato = (StatoAnagrafica) listaStorico.get(i); %>

<tr>
<td><%=toDateWithTimeasString(stato.getEntered()) %></td>
<td><%= statiList.getSelectedValue(stato.getIdVecchioStato()) %></td>
<td><%= statiList.getSelectedValue(stato.getIdNuovoStato()) %></td>
<td><%= fixData(stato.getDataCambioStato()) %></td>
<td><%= stato.getNota() %></td>
<td> <dhv:username id="<%= stato.getEnteredBy() %>" /></td> 
</tr>

<% } %>
</table>
	
<% } %>




