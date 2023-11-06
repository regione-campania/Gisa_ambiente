

<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>

<%@page import="org.aspcfs.modules.login.beans.UserBean"%><jsp:useBean id="LookupOperatori" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="LookupDurata" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popCalendar.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/programmazioneControlli.js"></script>
<script>
function popolaCampiValidita()
{

	 today = new Date();
	 anno = today.getFullYear();
	
	 anno_prec = parseInt(anno)-1
	document.getElementById("data1").value = '01/01/'+anno_prec;
	 document.getElementById("data2").value = '31/12/'+anno_prec;
	
	}
function checkfiltro()
{
	if(document.getElementById('searchcodedurata').value == '20')
	{
		if (document.getElementById('data1').value=='' || document.getElementById('data2').value=='')
		{
			alert('Inserire data dal e data al') ;
			return false ;
		}
	}
	return true ;
}
function abilitaTipoPiano()
{

if ( document.searchMonitoraggio.tipo_monitoraggio[0].checked == true)
{
	document.getElementById("tipo_piano").style.display="none";
	document.getElementById("tipo_operatori").style.display="";
	
}
else
{
	document.getElementById("tipo_piano").style.display="";
	document.getElementById("tipo_operatori").style.display="none";
}

}
</script>
<body onload="disabilitaPeriodo(document.searchMonitoraggio);abilitaTipoPiano()">
<%

UserBean user = (UserBean)session.getAttribute("User");
%>

<form name="searchMonitoraggio" id="searchMonitoraggio" action="Monitoraggio.do?command=ViewCruscottoDbi" method="post" onsubmit="return checkfiltro()">
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Monitoraggio.do?command=Monitoraggio">Report Controlli</a> >  
</td>
</tr>
</table>
<%-- End Trails --%>

<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
<tr>
	<th colspan="2"><strongc>Report</strong></th>
</tr>
<tr>
	<td class="formLabel">Periodo di Riferimento della Programmazione</td>
    <td>
       <table class = "noborder">
          	<tr>
          		<td>Durata</td>
          		<td>
          			<%LookupDurata.setJsEvent("onchange=disabilitaPeriodo('searchProgrammazione')");%>
          		 <%=LookupDurata.getHtmlSelect("searchcodedurata",-1) %>
          		</td>
          	
          	</tr>
          	<tr><td colspan="2">&nbsp;</td></tr>
          	<tr id = "validita">
          		<td>Validità dal  </td>
          		<td>
          		 <input type="text" name="searchtimestampdata1" id = "data1" size="10" value="" />&nbsp;<a href="javascript:popCalendar('searchMonitoraggio','searchtimestampdata1','it','IT','Europe/Berlin');" id = "linkdata1"><img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
    			al <input type="text" name="searchtimestampdata2"  id = "data2" size="10" value="" />&nbsp;<a href="javascript:popCalendar('searchMonitoraggio','searchtimestampdata2','it','IT','Europe/Berlin');"  id = "linkdata2"><img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
          			&nbsp;&nbsp;
          		<a href="javascript:popolaCampiValidita();">Seleziona anno precedente</a>
          	
          		</td>
          	
          	</tr>
          	<tr id = "validita">
          		<td>Includi piani Disabilitati  </td>
          		<td>
          			<input type ="checkbox" name = "searchenabled" value = "true" checked="checked">
          	
          		</td>
          	
          	</tr>
          	
         </table>
     </td>
	</tr>
	<tr >
	<td class="formLabel">Tipo Report</td>
    <td>
       CU in Sorveglianza <input name = "tipo_monitoraggio" type="radio" value="1" onclick="abilitaTipoPiano()"> 
       CU in Piano di Monitoraggio<input  name = "tipo_monitoraggio" type="radio" value="2" checked="checked" onclick="abilitaTipoPiano()"> 
     </td>
	</tr>
	<tr id = "tipo_piano">
	<td class="formLabel">Tipo Raggruppamento</td>
    <td>
 
      <select name="tipo_piano">
      <%
      if (user.getSiteId()<=0)
      {
      %>
      <option value="1">Raggruppamento Per Asl</option>
      <%} %>
       <option value="2">Raggruppamento Per Piano</option>
      </select>
 
      
     </td>
	</tr>
	<tr id = "tipo_operatori">
	<td class="formLabel">Tipo Operatori</td>
    <td>
      <%
      LookupOperatori.setSelectSize(6);
      LookupOperatori.setMultiple(true);
      %>
     <%=LookupOperatori.getHtmlSelect("operatori",1) %>
     </td>
	</tr>
	
</table>


<br/>

<input type="submit" value="Visualizza" >
<input type="button" value="Cancella" onClick="javascript:clearForm();">
<script>

jQuery('#searchMonitoraggio').submit(function(){loadModalWindow();});

</script>

</form>
</body>