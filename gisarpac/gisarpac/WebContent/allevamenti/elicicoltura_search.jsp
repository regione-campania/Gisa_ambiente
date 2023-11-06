  
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<%@ include file="../initPage.jsp" %>


<table class="trails" cellspacing="0">
<tr>
<td width="100%">
<a href="Allevamenti.do">Allevamenti</a> >
Ricerca Elicicoltura in BDN
</td>
</tr>
</table>

<font color="red"> Schermata SOLO PER HELP DESK per tentativo di interrogazione ai nuovi WS Elicicoltura.</font><br/><br/>

<form method="post" action = "Allevamenti.do?command=SearchElicicoltura" onsubmit="javascript:if(this.cod_azienda.value==''){alert('Inserire il codice Azienda');return false;} return true ;">

<table>

<tr>
<td>Codice Azienda</td>
<td><input type = "text" name = "aziendaCodice"></td>
</tr>

</table>
<input type = "submit" value = "Ricerca in Bdn">

</form>
