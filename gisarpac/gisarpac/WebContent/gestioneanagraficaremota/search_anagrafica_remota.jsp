<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>

<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="ComuniList" class="java.util.ArrayList" scope="request"/>

<%@page import="org.aspcfs.modules.accounts.base.Comuni"%>

<%@ include file="../initPage.jsp" %>


<script>
function checkForm(form){
	var ragioneSociale = form.ragioneSociale.value.trim();
	var partitaIva = form.partitaIva.value.trim();
	var cfImpresa = form.cfImpresa.value.trim();
	
	if (ragioneSociale.length < 3 && partitaIva.length < 3 && cfImpresa.length < 3 ) {
		alert('Inserire almeno tre caratteri di ricerca tra ragione sociale, partita iva e codice fiscale impresa.');
		return false;
	}
	
	loadModalWindow();
	form.submit();
}

</script>


<form name="searchAccount" action="GestioneAnagraficaRemotaAction.do?command=SearchAnagraficaRemota" method="post">



<table cellpadding="2" cellspacing="2" border="0" width="100%">
  <tr>
    <td width="50%" valign="top">

      <table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
        <tr>
          <th colspan="2">
            <strong>Ricerca Anagrafica Remota</strong>
          </th>
        </tr>
        <tr>
          <td class="formLabel">Ragione Sociale </td>
          <td><input type="text" size="23" name="ragioneSociale" id="ragioneSociale" value=""></td>
        </tr>
          <tr>
          <td class="formLabel">Partita IVA </td>
          <td><input type="text" size="11" maxlength="11" name="partitaIva" id="partitaIva" value=""></td>
        </tr>
  <tr>
          <td class="formLabel">Codice fiscale impresa </td>
          <td><input type="text" size="16" maxlength="16" name="cfImpresa" id="cfImpresa" value=""></td>
        </tr>
          <tr>
          <td class="formLabel">Dipartimento</td>
          <td>
          <select id="asl" name="asl">
          <option value="" selected>TUTTI</option>
          <option value="AVELLINO">AVELLINO</option>
          <option value="BENEVENTO">BENEVENTO</option>
          <option value="CASERTA">CASERTA</option>
          <option value="NAPOLI">NAPOLI</option>
          <option value="SALERNO">SALERNO</option>
          </select>
          
          </td>
        </tr>
          <tr>
          <td class="formLabel">Comune</td>
          <td>
          <select id="comune" name="comune">
           <option value="" selected>TUTTI</option> 
          
          <%for (int i = 0; i<ComuniList.size(); i++){
        	  Comuni c = (Comuni) ComuniList.get(i);%>
        	 <option value="<%=c.getComune()%>"><%=c.getComune() %></option>
          <%} %>
          </select>
          
          
          </td>
        </tr>
        
</table>

<input type="button" onClick="checkForm(this.form)" value="Cerca"/>

</form>
</body>


