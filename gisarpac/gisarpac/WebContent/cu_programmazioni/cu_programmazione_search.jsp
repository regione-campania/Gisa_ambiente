

<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>

<%@page import="org.aspcfs.modules.login.beans.UserBean"%><jsp:useBean id="PianiMonitoraggio" class="java.util.HashMap" scope="request"/>
<jsp:useBean id="LookupDurata" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popCalendar.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/programmazioneControlli.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></script>

<script>
function popolaCampiValidita()
{

	 today = new Date();
	 anno = today.getFullYear();
		 anno_prec = parseInt(anno)-1
	document.getElementById("data1").value = '01/01/'+anno_prec;
	 document.getElementById("data2").value = '31/12/'+anno_prec;

	}
</script>
<body onload="disabilitaPeriodo('searchProgrammazione')">
<form name="searchProgrammazione" action="Cruscotto.do?command=SearchTickets" method="post">
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Cruscotto.do?command=Search">Programmazione Controlli</a> > Ricerca Programmazione 
</td>
</tr>
</table>
<%-- End Trails --%>
<p><font color="red">Attenzione! In questa sezione sono visibili e contrassegnati dal seguente simbolo "(X)" anche i piani di monitoraggio obsoleti (Si tratta dei piani di monitoraggio non più attivi per l'anno 2012.).</font></p>
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
<tr>
	<th colspan="2"><strong>Ricerca Programmazioni</strong></th>
</tr>
<tr>
	<td class="formLabel">Periodo di Riferimento</td>
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
          		 <input type="text" name="searchtimestampdata1" id = "data1" size="10" value="" />&nbsp;<a href="javascript:popCalendar('searchProgrammazione','searchtimestampdata1','it','IT','Europe/Berlin');" id = "linkdata1"><img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
    			al <input type="text" name="searchtimestampdata2"  id = "data2" size="10" value="" />&nbsp;<a href="javascript:popCalendar('searchProgrammazione','searchtimestampdata2','it','IT','Europe/Berlin');"  id = "linkdata2"><img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
          		&nbsp;&nbsp;
          		<a href="javascript:popolaCampiValidita();">Seleziona anno precedente</a>
          		
          		</td>
          	
          	</tr>
         </table>
     </td>
	</tr>
	
	<tr>
      <td nowrap class="formLabel">
        <dhv:label name="">Piano</dhv:label>
      </td>
      
      <td>
      <table class = "noborder"><tr>
      <td id = ""></td>
      <td>
      <%UserBean user = (UserBean) session.getAttribute("User");
       	int id_asl = user.getSiteId();	
      %>
       &nbsp;[<a href="javascript:popLookupSelectorCustomPianiMonitoraggio('description','short_description','lookup_piano_monitoraggio','',<%=id_asl %>);">Seleziona Piano Monitoraggio</a>] 
      <input type = "hidden" name = "searchcodepiano_monitoraggio" id = "piano_value" value = "-1">
      </td>
      
      </tr>
     
      </table>
      </td>
    	
 	</tr>
 	 <tr id ="row_piano" class="containerBody" style="display: none" >
		<td nowrap class="formLabel">Piano Di Monitoraggio</td>
		<td id = "piano"></td>
		</tr>
   	<tr>
      <td nowrap class="formLabel">
        <dhv:label name="">Descrizione Gruppo</dhv:label>
      </td>
    	<td>
    	<input type = "text" readonly="readonly" size="80" id = "gruppo_piano" name ="gruppo_piano" value="">
    	</td>
    	
    	</tr>


</table>


<br/>

<input type="submit" value="Ricerca" onclick='loadModalWindow();'>
<input type="button" value="Cancella" onClick="javascript:clearForm();">

</form>
</body>