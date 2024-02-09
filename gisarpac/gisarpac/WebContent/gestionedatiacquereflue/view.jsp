<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="dato" class="org.aspcfs.modules.gestionedatiacquereflue.base.DatoAcqueReflue" scope="request"/>
<jsp:useBean id="riferimentoId" class="java.lang.String" scope="request"/>
<jsp:useBean id="riferimentoIdNomeTab" class="java.lang.String" scope="request"/>

<jsp:useBean id="statiImpiantiList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="processiDepurativiList" class="org.aspcfs.utils.web.LookupList" scope="request"/>

<jsp:useBean id="Messaggio" class="java.lang.String" scope="request"/>

<%@ page import="org.aspcfs.modules.gestionedatiacquereflue.base.*"%>
<%@ page import="org.aspcfs.utils.web.*"%>

<%@ include file="../initPage.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery-1.8.2.js"></script>
<script src="javascript/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>


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
	
	if (confirm("Confermare i dati indicati?")) {	
		loadModalWindow();
		form.submit();
	}
}
</script>

<form name="aggiungiDatoAcqueReflue" action="GestioneDatiAcqueReflue.do?command=Upsert&auto-populate=true" onSubmit="" method="post">

<table class="details" cellpadding="10" cellspacing="10" width="100%" style="border-collapse: collapse">
<col width="50%">
<tr><th colspan="2">DATI ACQUE REFLUE</th></tr>
<tr><td CLASS="formLabel">DEPURAZIONE REFLUI</td> <td><input type="radio" id="depurazioneRefluiS" name="depurazioneReflui" value="true" <%=Boolean.TRUE.equals(dato.isDepurazioneReflui()) ? "checked" : ""%>/> SI <input type="radio" id="depurazioneRefluiN" name="depurazioneReflui" value="false" <%=!Boolean.TRUE.equals(dato.isDepurazioneReflui()) ? "checked" : ""%>/> NO</td></tr>
<tr><td CLASS="formLabel">STATO IMPIANTO</td> <td><%=statiImpiantiList.getHtmlSelect("idStatoImpianto", dato.getIdStatoImpianto()) %></td></tr>
<tr><td CLASS="formLabel">GESTORE IMPIANTO</td> <td><input type="text" id="gestoreImpianto" name="gestoreImpianto" value="<%=toHtml(dato.getGestoreImpianto())%>"/></td></tr>
<tr><td CLASS="formLabel">PROCESSO DEPURATIVO</td> <td><%=processiDepurativiList.getHtmlSelect("idProcessoDepurativo", dato.getIdProcessoDepurativo()) %></td></tr>
<tr><td CLASS="formLabel">POTENZIALITA' IMPIANTO AE</td> <td><input type="text" id="potenzialitaImpiantoAE" name="potenzialitaImpiantoAE" value="<%= toHtml(dato.getPotenzialitaImpiantoAE())%>"/></td></tr>
<tr><td CLASS="formLabel">RECETTORE SCARICO</td> <td><input type="text" id="recettoreScarico" name="recettoreScarico" value="<%= toHtml(dato.getRecettoreScarico())%>"/></td></tr>
<tr><td CLASS="formLabel">RECETTORE FINALE</td> <td><input type="text" id="recettoreFinale" name="recettoreFinale" value="<%=toHtml(dato.getRecettoreFinale())%>"/></td></tr>
<tr><td CLASS="formLabel">CODICE ULIA</td> <td><input type="text" id="codiceUlia" name="codiceUlia" value="<%= toHtml(dato.getCodiceUlia())%>"/></td></tr>
</table>

<br/>

<center>


<!-- BOTTONI -->
<table class="details" cellpadding="10" cellspacing="10" width="100%">
<tr>
<td colspan="2" align="center"><br/><br/>
<input type="button" style="font-size:40px" value="CONFERMA" onclick="checkForm(this.form)"/>
</td>
</tr>
</table>
<!-- BOTTONI -->

</center>

<input type="hidden" id="riferimentoId" name="riferimentoId" value="<%=riferimentoId%>"/>
<input type="hidden" id="riferimentoIdNomeTab" name="riferimentoIdNomeTab" value="<%=riferimentoIdNomeTab%>"/>

</form>

