<%@ page import="java.util.*,org.aspcfs.utils.*"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio"%>
<%@ include file="../initPage.jsp"%>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean"
	scope="session" />


<script type="text/javascript" src="dwr/interface/PopolaCombo.js"> </script>
        <script type="text/javascript" src="dwr/engine.js"> </script>
        <script type="text/javascript" src="dwr/util.js"></script>
        <script type="text/javascript">

			function importaSin()
			{
				alert('Attenzione le schede verranno spedite alla BDN.l\'operazione impiegher� qualche minuto')
				PopolaCombo.insertSchedeSin(importaSinCallback) ;
			}

			function importaSinCallback(returnValue)
			{
				alert('Schede Importate Controllare i file di LOG');
			}
			

      
</script>
<%-- Trails --%>
<table class="trails" cellspacing="0">


	<tr>
		<td width="100%"><a href="Stabilimenti.do"><dhv:label
			name="">Sin</dhv:label></a> > <dhv:label
			name="">Importa Schede Sin</dhv:label>
		</td>
	</tr>
</table>
<%-- End Trails --%>

<br>
<form method="post" action = "Allevamenti.do?command=SendSin"><

	
	<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
        <tr>
          <th colspan="2">
            <strong>Filtra</strong>
          </th>
        </tr>
	
	<tr>
          <td nowrap class="formLabel">
           	Tuipo Produzione
          </td>
          <td>
           	Latte<input type = "radio" checked="checked">
          </td>
        </tr>
        
        	<tr>
          <td nowrap class="formLabel">
           	Anno
          </td>
          <td>
           	<select name = "anno">
           	<option value = "2011">2011</option>
           	<option value = "2012">2012</option>
           	<option value = "2013">2013</option>
           	</select>
          </td>
        </tr>
        
        
</table>
<input type = "submit" value = "INVIA" onclick="">
</form>



	