<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,org.aspcfs.modules.troubletickets.base.*" %>
<%@ page import="java.text.DateFormat, org.aspcfs.modules.actionplans.base.*" %>
<%@page import="org.aspcfs.modules.programmazzionecu.base.AslCoinvolte"%>
<%@ include file="../initPage.jsp" %>


<%@page import="org.aspcfs.utils.web.LookupElement"%>
<%@page import="org.aspcfs.modules.oia.base.OiaNodo"%><jsp:useBean id="PianiMonitoraggio" class="java.util.HashMap" scope="request"/>
<jsp:useBean id="LookupDurata" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SiteIdList" class="org.aspcfs.utils.web.LookupList" scope="request"/>

<jsp:useBean id="TicketDetail" class="org.aspcfs.modules.programmazzionecu.base.ProgrammazioneCu" scope="request"/>
<jsp:useBean id="listaAsl" class="java.util.ArrayList" scope="request"/>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popCalendar.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/programmazioneControlli.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></script>


<body onload="">
 
<form name="addProgrammazione"  action="Cruscotto.do?command=Insert&auto-populate=true" method="post">
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Cruscotto.do?command=Search"><dhv:label name="sanzioniss">Programmazione Controlli Ufficiali</dhv:label></a> > 
<dhv:label name="allerte.aggiungi">Nuova Programmazione</dhv:label>
</td>
</tr>
</table>


<br>
<%-- End Trails --%>
<%if(listaAsl.size()>0){ %>
<input type="submit" value="<dhv:label name="button.insert">Insert</dhv:label>" name="Save" onClick="return checkForm(this.form)">
<%} %><input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.action='Cruscotto.do?command=Search'">
<br>
<br>
<%
if (request.getAttribute("Msg")!=null)
{
	%>
	<script>

alert('<%=request.getAttribute("Msg")%>');	

</script>
<%
	
out.print("<font color = 'red'>"+request.getAttribute("Msg")+"</font>");	
}
%>
 <%
			UserBean user = (UserBean) session.getAttribute("User");
			%>
<table cellpadding="4" cellspacing="0" width="100%" class="details">
	<tr>
    <th colspan="2">
      <strong><dhv:label name="">Aggiungi Nuova Pianificazione</dhv:label></strong>
    </th>
	</tr>
	 
 	<%
 	if (user.getSiteId()<0)
 	{
 	%>
 		<tr>
	<td class="formLabel">Periodo di Riferimento<br>(Durata)</td>
    <td>
       <table class = "noborder">
          	<tr>
          		
          		<td>
          			<%LookupDurata.setJsEvent("onchange=disabilitaPeriodo(document.addProgrammazione)");%>
          		 <%=LookupDurata.getHtmlSelect("durata",-1) %><font color="red">*</font>
          		</td>
          	
          	</tr>
          	<tr><td colspan="2">&nbsp;</td></tr>
          	<tr id = "validita">
          		<td>Validità dal  </td>
          		<td>
          		 <input type="text" name="data1"  id = "data1" size="10" value="" />&nbsp;<a href="javascript:popCalendar('addProgrammazione','data1','it','IT','Europe/Berlin');" id = "linkdata1"><img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
    			al <input type="text" name="data2"  id = "data2" size="10" value="" />&nbsp;<a href="javascript:popCalendar('addProgrammazione','data2','it','IT','Europe/Berlin');"  id = "linkdata2"><img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
          		<font color="red" style="display: none" id = "obbligatorio">*</font>
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
      <td ></td>
      <td>
     
       &nbsp;[<a href="javascript:popLookupSelectorCustomPianiMonitoraggio('description','short_description','lookup_piano_monitoraggio','',<%=user.getSiteId() %>);">Seleziona Piano di Monitoraggio</a>] 
      <input type = "hidden" name = "piano_monitoraggio" id = "piano_value" value = "-1">
      </td>
      
      </tr></table>
      </td>
    	
 	</tr>
 	<tr id ="row_piano" class="containerBody" style="display: none" >
		<td nowrap class="formLabel">Piano Di Monitoraggio</td>
		<td id = "piano"></td>
		</tr>
 	
 	
 	 
 	
 	     <tr>
      <td nowrap class="formLabel">
        <dhv:label name="">Num. Tot Controlli per Piano</dhv:label>
      </td>
    	<td>
    	<input type = "text" readonly="readonly" id = "totaleCu" name ="num_tot_cu" value="0">
    	</td>
    	
    	</tr>
    	
    	 <tr>
      <td nowrap class="formLabel">
        <dhv:label name="">Num. Tot Campioni per Piano</dhv:label>
      </td>
    	<td>
    	<input type = "text" readonly="readonly" id = "totaleCampioni" name ="num_tot_ca" value="0">
    	</td>
    	
    	</tr>
     
     
</table>
<br><br>
<table cellpadding="4" cellspacing="0" width="100%" class="details">
	<tr>
    <th colspan="8">
      <strong><dhv:label name="">Pianificazione Controlli</dhv:label></strong>
    </th>
	</tr>
	
	<tr>
      <td>
       &nbsp;
      </td>
    	<%
    	
    	//Iterator<Integer> itAsl1 = SiteIdList.keySet().iterator();
    	for(int i = 0 ; i < listaAsl.size(); i++)
    	{
    		OiaNodo el = (OiaNodo)listaAsl.get(i);
    		int code = el.getId_asl();
    		if(code!=16)
    		{
    		%>
    		<input type = "hidden" name = "asl_coinvolte" value="<%=el.getId() %>">
    		<td><%="<b>"+SiteIdList.getSelectedValue(el.getId_asl())+"</b>" %></td>
    		<%
    	}}
    	%>
    </tr>
    <tr	>
      <td>
       <b>C.U. Pianificati</b>	
      </td>
    	<%
    	for(int i = 0 ; i < listaAsl.size(); i++)
    	{
    		OiaNodo el = (OiaNodo)listaAsl.get(i);
    		int code = el.getId();
    		int idAsl = el.getId_asl();
    		%>
    		<input type = "hidden" id = "padre_<%=i %>" value = "<%=code %>">
    		<td width="4">
    		<input type = "hidden" name = "cu_non_rilevanti_<%=code %>" id = "cu_non_rilevanti_<%=code %>"  value = "false">
    		<center><input type="text" id = "cu_<%=code %>" size="16" width="20"  name = "cu_<%=code %>" value="Non Rilevante" size="6" maxlength="5" onchange="calcotaTotaleCu()" ></center></td>
    		<%
    	}
    	%>
    
    	
    	<tr>
      <td> 
       <b>Campioni Pianificati</b>
      </td>
    	<%
    	for(int i = 0 ; i < listaAsl.size(); i++)
    	{
    		OiaNodo el = (OiaNodo)listaAsl.get(i);
    		int code = el.getId();
    		int idAsl = el.getId_asl();
    		%>
    		<td width="4">
    		<input type = "hidden" name = "campioni_non_rilevanti_<%=code %>" id = "campioni_non_rilevanti_<%=code %>" value = "false">
    		<center><input type="text" id = "campioni_<%=code %>" size="16" width="20" name = "campioni_<%=code %>" value="Non Rilevante" size="6" maxlength="5" onchange="calcotaTotaleCampioni()"></center></td>
    		
    		<%
    	}
    	%>
    	
    </tr>
    <%}
 	else
 	{%>
 		
 		<tr id = "dettagli_programmazione" style="display: none">
	<td class="formLabel">Periodo di Riferimento<br>(Durata)</td>
    <td>
       <table class = "noborder">
          	<tr>
          		
          		<td>
          		<input type = "hidden" name = "idProgrammazione" id = "idProgrammazione">
          		<input type = "hidden" id = "durata" name = "durata">
          		<div id = "descdurata">
          		
          		</div>
          		</td>
          	
          	</tr>
          	<tr><td colspan="2">&nbsp;</td></tr>
          	<tr id = "validita">
          		<td>Validità dal  </td>
          		<td>
          		 <input  type = "text" readonly="readonly" name="data1"  id = "data1" size="10" value="" />
    			 <input  type = "text" readonly="readonly" name="data2"  id = "data2" size="10" value="" />
          		<font color="red" style="display: none" id = "obbligatorio">*</font>
          		</td> 
          	
          	</tr>
         </table>
     </td>

	</tr>	
 	
 		<tr>
      <td nowrap class="formLabel">
        <dhv:label name="">Programmazione</dhv:label>
      </td>
      
      <td>
      <table class = "noborder"><tr>
      <td ></td>
      <td>
     
       &nbsp;[<a href="javascript:popLookupSelectorCustomProgrammazioni('description','short_description','lookup_piano_monitoraggio','',<%=user.getSiteId() %>);">Seleziona Piano di Monitoraggio</a>] 
      <input type = "hidden" name = "piano_monitoraggio" id = "piano_value" value = "-1">
      </td>
      
      </tr></table>
      </td>
    	
 	</tr>
 		<tr id ="row_piano" class="containerBody" style="display: none" >
		<td nowrap class="formLabel">Piano Di Monitoraggio</td>
		<td>
		<table class = "noborder">
		<tr>
		<td>Piano : </td><td id = "piano"></td>
		</tr>
		<tr>
		<td>Totale CU da assegnare : </td><td id = "cuAss"></td>
		</tr>
		
		<tr>
		<td>Totale Campioni da assegnare : </td><td id = "campAss"></td>
		</tr>
		
		</table>
		</td>
		</tr>
 	
 	
 	  <tr style="display:none">
      <td nowrap class="formLabel" >
        <dhv:label name="">Descrizione Gruppo</dhv:label>
      </td>
    	<td>
    	<input type = "text" readonly="readonly" size="80" id = "gruppo_piano" name ="gruppo_piano" value="">
    	</td>
    	
    	</tr>
 	
 	     <tr>
      <td nowrap class="formLabel">
        <dhv:label name="">Num. Tot Controlli Assegnati</dhv:label>
      </td>
    	<td>
    	<input type = "text" readonly="readonly" id = "totaleCu" name ="num_tot_cu" value="0">
    	</td>
    	
    	</tr>
    	
    	<tr>
      <td nowrap class="formLabel">
        <dhv:label name="">Num. Tot Campioni Assegnati</dhv:label>
      </td>
    	<td>
    	<input type = "text" readonly="readonly" id = "totaleCampioni" name ="num_tot_ca" value="0">
    	</td>
    	
    	</tr>
     
     
</table>
<br><br>
<table cellpadding="4" cellspacing="0" width="100%" class="details">
	<tr>
    <th colspan="4">
      <strong><dhv:label name="">Pianificazione Controlli</dhv:label></strong>
    </th>
	</tr>
	<tr>
    <th colspan="2" >
      <strong><dhv:label name="">&nbsp;</dhv:label></strong>
    </th>
    <th >
      <strong><dhv:label name="">CU</dhv:label></strong>
    </th>
    <th >
      <strong><dhv:label name="">Campioni</dhv:label></strong>
    </th>
	</tr>
	
	
	<%
	
    	//Iterator<Integer> itAsl1 = SiteIdList.keySet().iterator();
    	for(int i = 0 ; i < listaAsl.size(); i++)
    	{
    		OiaNodo el = (OiaNodo)listaAsl.get(i);
    		

    		int code = el.getId() ;
    		if(code!=16)
    		{
    		%>
    		<tr>
    		
    		<td colspan="2"><input type = "hidden" name = "asl_coinvolte" value="<%=el.getId() %>"><%="<b>"+el.getDescrizione_lunga()+"</b>" %></td>
    		<td width="4">
    		<input type = "hidden" name = "cu_non_rilevanti_<%=code %>" id = "cu_non_rilevanti_<%=code %>"  value = "false">
    		<center><input type="text" readonly="readonly"  id = "cu_<%=code %>" size="16" width="20"  name = "cu_<%=code %>" value="Non Rilevante" size="6" maxlength="5" onchange="calcotaTotaleCuFigli()" ></center></td>
    		<input type = "hidden" id = "padre_<%=i %>" value = "<%=code %>">
    		    		<td width="4">
    		<input type = "hidden" name = "campioni_non_rilevanti_<%=code %>" id = "campioni_non_rilevanti_<%=code %>" value = "false">
    		<center><input type="text" readonly="readonly"  id = "campioni_<%=code %>" size="16" width="20" name = "campioni_<%=code %>" value="Non Rilevante" size="6" maxlength="5" onchange="calcotaTotaleCampioni()"></center></td>
    		</tr>
    		
    		<%
    			ArrayList<OiaNodo> lista_figli =  el.getLista_nodi() ;
    		for(int j = 0 ; j < lista_figli.size(); j++)
        	{
    			OiaNodo figlio = (OiaNodo)lista_figli.get(j);
    			int codeFiglio = figlio.getId() ;
        		%>
        		<tr>
    		<td>&nbsp;
    		<input type = "hidden" id = "figli_<%=j %>_<%=figlio.getId_padre() %>" value = "<%=figlio.getId() %>">
    		    		</td>
    		<td><input type = "hidden" name = "asl_coinvolte" value="<%=figlio.getId() %>"><%="<b>"+figlio.getDescrizione_lunga()+"</b>" %></td>
    		<td width="4">
    		<input type = "hidden" name = "cu_non_rilevanti_<%=codeFiglio %>" id = "cu_non_rilevanti_<%=codeFiglio %>"  value = "false">
    		<center><input type="text" id = "cu_<%=codeFiglio %>" size="16" width="20"  name = "cu_<%=codeFiglio %>" value="Non Rilevante" size="6" maxlength="5" onchange="calcotaTotaleCuFigli(document.getElementById('cu_<%=figlio.getId_padre() %>'),<%=figlio.getId_padre() %>)"  ></center></td>
    		
    		<td width="4">
    		<input type = "hidden" name = "campioni_non_rilevanti_<%=codeFiglio %>" id = "campioni_non_rilevanti_<%=codeFiglio %>" value = "false">
    		<center><input type="text" id = "campioni_<%=codeFiglio %>" size="16" width="20" name = "campioni_<%=codeFiglio %>" value="Non Rilevante" size="6" maxlength="5" onchange="calcotaTotaleCampioniFigli(document.getElementById('campioni_<%=figlio.getId_padre() %>'),<%=figlio.getId_padre() %>)"></center></td>
    		</tr>
        		
        		<%
    			
        	}
    		
    		
    	}}
    	if (listaAsl.size()==0)
    	{
    		%>
    		<tr><td colspan="3">Completare l'organigramma per la propria asl prima di inserire le programmazioni</td></tr>
    		<%
    		
    	}
    	%>
	
	
	
	
 		
 		
 	<%}
 	%>
 	
 	
    
</table>
<br>
<%if(listaAsl.size()>0){ %>
<input type="submit" value="<dhv:label name="button.insert">Insert</dhv:label>" name="Save" onClick="return checkForm(this.form)">
<%} %>

<input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.action='Cruscotto.do?command=Search'">
</form>


</body>