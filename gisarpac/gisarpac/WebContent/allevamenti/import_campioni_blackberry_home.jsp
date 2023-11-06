<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ include file="../initPage.jsp" %>

<jsp:useBean id="TicketDetails" class="org.aspcfs.modules.vigilanza.base.Ticket" scope="request"/>
<script type="text/javascript">
function clearForm() {
    <%-- Account Filters --%>
    document.forms['searchCameraCommercio'].ragione_sociale.value="";
    document.forms['searchCameraCommercio'].partita_iva.value=""; 
    document.forms['searchCameraCommercio'].codice_fiscale.value="";
    document.forms['searchCameraCommercio'].duplicati.checked="";
    
  }


	function trim(stringa){
	    while (stringa.substring(0,1) == ' '){
	        stringa = stringa.substring(1, stringa.length);
	    }
	    while (stringa.substring(stringa.length-1, stringa.length) == ' '){
	        stringa = stringa.substring(0,stringa.length-1);
	    }
	    return stringa;
	};
	
	function checkForm()
	{
		cf = document.getElementById( 'codice_fiscale' ).value;
		pi = document.getElementById( 'partita_iva' ).value;
		rs = document.getElementById( 'ragione_sociale' ).value;
	
		all = ( "" + cf + pi + rs );
	
		if( trim( all ).length > 0 )
		{
			return true;
		}
		else
		{
			alert( "Selezionare almeno un filtro" );
			return false;
		}
	};
	
</script>

<form name="searchCameraCommercio" action="BlackBerryImportAllevamenti.do?command=CercaCampioni" method="post">
<%-- Trails --%>
<table class="trails" cellspacing="0">
	<tr>
		<td>
		<a href="Allevamenti.do"><dhv:label name="">Allevamenti</dhv:label></a> > 
  
			<dhv:label name="camera_commercio">Campioni inseriti da Black Berry</dhv:label>> 
			<dhv:label name="camera_commercio.cerca">Cerca</dhv:label>
		</td>
	</tr>
</table>
<input type = "hidden" name = "idControllo" value = "<%=request.getAttribute("idControllo") %>">
<input type = "hidden" name = "identificativo" value = "<%=request.getAttribute("identificativo") %>">

<%

%>
<input type = "hidden" name = "orgId" value = "<%=request.getAttribute("orgId") %>">




<table cellpadding="2" cellspacing="2" border="0" width="100%">
  <tr>
    <td width="50%" valign="top">

      <table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
        <tr>
          <th colspan="2">
            <strong><dhv:label name="">Filtri</dhv:label></strong>
          </th>
        </tr>
        <tr>
          <td class="formLabel">
            <dhv:label name="">Verbale</dhv:label>
          </td>
          <td>
            <input id="ragione_sociale" type="text" maxlength="70" size="50" name="ragione_sociale" />
          </td>
        </tr>
        <tr>
          <td class="formLabel">
            <dhv:label name="">Codice Accettazione</dhv:label>
          </td>
          <td>
            <input id="partita_iva" type="text" maxlength="50" size="50" name="partita_iva" />
          </td>
        </tr>
        <tr>
          <td class="formLabel">
            <dhv:label name="">Laboratorio Destinazione</dhv:label>
          </td>
          <td>
            <input id="codice_fiscale" type="text" maxlength="50" size="50" name="codice_fiscale" />
          </td>
        </tr>
      
        
      </table>
      
      
    </td>
    
  </tr>
  
</table>

<input onclick="return checkForm();" type="submit" value="<dhv:label name="button.search">Search</dhv:label>">
<input type="button" value="<dhv:label name="button.clear">Clear</dhv:label>" onClick="javascript:clearForm();">

</form>


