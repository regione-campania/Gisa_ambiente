<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>



<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>

<jsp:useBean id="Anagrafica" class="org.aspcfs.modules.gestionexml.base.AnagraficaXML" scope="request"/>
<jsp:useBean id="indice" class="java.lang.String" scope="request"/>

<%@ include file="../initPage.jsp" %>

 
  <script> function checkForm(form){
	  var idLinea = form.idLineaProduttiva.value;
	  
	  if (idLinea != parseInt(idLinea, 10))
	  	  alert('Selezionare una linea!');
	  else{
		 form.idLinea.value = idLinea;
		 loadModalWindow();
		 form.submit();
	  }
	  
  }
  
  function annulla(form){
		if (confirm('ATTENZIONE! Annullare le modifiche?')){
			loadModalWindow();
			 window.history.back();
			 }
		
	}
  </script>
  		
<form id = "addAccount" name="addAccount" action="GestioneXML.do?command=SelezionaLinea&auto-populate=true" method="post">
<input type="hidden" id="idAnagraficaXML" name="idAnagraficaXML" value="<%=Anagrafica.getId()%>"/>	
<input type="hidden" id="indice" name="indice" value="<%=indice%>"/>	
<input type="hidden" id="idLinea" name="idLinea" value=""/>	


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

<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">

<tr><th colspan="2">Riepilogo</th></tr>


<tr>
<td class="formLabel">Ragione Sociale Impresa</td>
<td><%=Anagrafica.getImpresaRagioneSociale() %></td>
</tr>

	
<tr>
<td class="formLabel">Nuova linea</td>
<td>

<jsp:include page="../gestioneml/navigaml.jsp">
<jsp:param name="flagSintesis" value="false" />
<jsp:param name="flagNoScia" value="false" />
</jsp:include>

</td>
</tr>

<tr><td align="center"><input type="button" value="ANNULLA" onClick="window.location.href='GestioneXML.do?command=Dettaglio&idAnagraficaXML=<%=Anagrafica.getId()%>'"/></td>
<td align="center"><input type="button" value="CONFERMA" onClick="checkForm(this.form)"/></td></tr>

	
</table>
</form>



</body>
</html>