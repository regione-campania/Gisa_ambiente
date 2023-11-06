<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,org.aspcfs.modules.troubletickets.base.*" %>
<%@ page import="java.text.DateFormat, org.aspcfs.modules.actionplans.base.*" %>
<%@page import="org.aspcfs.modules.programmazzionecu.base.AslCoinvolte"%>
<%@ include file="../initPage.jsp" %>


<%@page import="org.aspcfs.utils.web.LookupElement"%>
<%@page import="org.aspcfs.modules.oia.base.OiaNodo"%><jsp:useBean id="pianiList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ListaAslDesc" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="PianiMonitoraggio" class="java.util.HashMap" scope="request"/>
<jsp:useBean id="LookupDurata" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TicketDetails" class="org.aspcfs.modules.programmazzionecu.base.ProgrammazioneCu" scope="request"/>
<jsp:useBean id="SiteIdList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popCalendar.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/programmazioneControlli.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></script>


<body onload="disabilitaPeriodo(document.addProgrammazione);calcotaTotaleCu()">
 
<form name="addProgrammazione"  action="Cruscotto.do?command=Update&auto-populate=true" method="post">
<input type = "hidden" name = "id" value = "<%=TicketDetails.getId() %>">
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Cruscotto.do"><dhv:label name="sanzioniss">Programmazione Controlli Ufficiali</dhv:label></a> > 
<dhv:label name="allerte.aggiungi">Nuova Programmazione</dhv:label>
</td>
</tr>
</table>


<br>
<%-- End Trails --%>
<input type="submit" value="Aggiorna" onClick="return checkForm(this.form)">
<input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.action='Cruscotto.do?command=Details&id_programmazione=<%=TicketDetails.getId() %>'">
<br>
  <%
			UserBean user = (UserBean) session.getAttribute("User");
			%>
<table cellpadding="4" cellspacing="0" width="100%" class="details">
	<tr>
    <th colspan="2">
      <strong><dhv:label name="">Modifica Pianificazione</dhv:label></strong>
    </th>
	</tr>
	 <%if (user.getSiteId()<0)
		 {
		 %>
 		<tr>
	<td class="formLabel">Periodo di Riferimento<br>(Durata)</td>
    <td>
       <table class = "noborder">
          	<tr>
          		
          		<td>
          			<%LookupDurata.setJsEvent("onchange=disabilitaPeriodo(document.addProgrammazione)");%>
          		 <%=LookupDurata.getHtmlSelect("durata",TicketDetails.getDurata()) %><font color="red">*</font>
          		</td>
          	
          	</tr>
          	<tr><td colspan="2">&nbsp;</td></tr>
          	<tr id = "validita">
          		<td>Validità dal  </td>
          		<td>
          		 <input type="text" name="data1" id = "data1" size="10" value="<%=toHtml(TicketDetails.getData1asString()) %>" />&nbsp;<a href="javascript:popCalendar('addProgrammazione','data1','it','IT','Europe/Berlin');" id = "linkdata1"><img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
    			al <input type="text" name="data2"  id = "data2" size="10" value="<%=toHtml(TicketDetails.getData2asString()) %>" />&nbsp;<a href="javascript:popCalendar('addProgrammazione','data2','it','IT','Europe/Berlin');"  id = "linkdata2"><img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
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
      <td id = "piano"><%=pianiList.getSelectedValue(TicketDetails.getPiano_monitoraggio()) %></td>
      <td>
    
       &nbsp;[<a href="javascript:popLookupSelectorCustomPianiMonitoraggio('description','short_description','lookup_piano_monitoraggio','',<%=user.getSiteId() %>);">Seleziona Piano Monitoraggio</a>] 
      <input type = "hidden" name = "piano_monitoraggio" id = "piano_value" value = "<%=TicketDetails.getPiano_monitoraggio() %>">
      </td>
      
      </tr></table>
      </td>
    	
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
    	<input type = "text" readonly="readonly" id = "totaleCampioni" name ="num_tot_campioni" value="0">
    	</td>
    	
    	</tr>
     
     
</table>
<br><br>
<table cellpadding="4" cellspacing="0" width="100%" class="details">
	<tr>
    <th colspan="14">
      <strong><dhv:label name="">Pianificazione Controlli</dhv:label></strong>
    </th>
	</tr>
	
	<tr>
      <td>
       &nbsp;
      </td>
    	<%//Iterator<Integer> itAsl1 = SiteIdList.keySet().iterator();
    	
		Hashtable<String,ArrayList<OiaNodo>> asl_coinvolte= TicketDetails.getAsl_coinvolte();
		Iterator<String> itK = asl_coinvolte.keySet().iterator();
    	while(itK.hasNext())
    	{
    		String k = itK.next();
    		OiaNodo el =asl_coinvolte.get(k).get(0);
    		int code = el.getId();
    		
    		%>
    		<input type = "hidden" name = "asl_coinvolte" value="<%=code %>">
    		<td><%="<b>"+SiteIdList.getSelectedValue(el.getId_asl())+"</b>" %></td>
    		<%
    	}
    	%>
    </tr>
    <tr>
      <td>
       <b>C.U. Pianificati</b>	
      </td>
    	<%

		 asl_coinvolte= TicketDetails.getAsl_coinvolte();
		itK = asl_coinvolte.keySet().iterator();
		int i = 0 ;
    	while(itK.hasNext())
    	{
    		String k = itK.next();
    		OiaNodo el =asl_coinvolte.get(k).get(0);
    		
    		int code = el.getId();
    		
    		int cu_pianificati = 0 ;
    		
    		
    			
    				cu_pianificati = el.getCuPianificati();
    			
    		
    		%>
    		<input type = "hidden" id = "padre_<%=i %>" value = "<%=code %>">
    		<td width="4">
    		<center>
    		<input type="text" id = "cu_<%=code %>" name = "cu_<%=code %>" size="16" width="20" value="<%=((el.getCuPianificati()==-1) ? "Non Rilevante" : cu_pianificati)%>" size="6" maxlength="5" onchange="calcotaTotaleCu()" ></center></td>
    		<%
    		i++;
    	}
    	%>
    
    	
    	<tr>
      <td>
       <b>Campioni Pianificati</b>
      </td>
    	<%

		 asl_coinvolte= TicketDetails.getAsl_coinvolte();
		itK = asl_coinvolte.keySet().iterator();
    	while(itK.hasNext())
    	{
    		String k = itK.next();
    		OiaNodo el =asl_coinvolte.get(k).get(0);
    		
    		int code = el.getId();
    		
    		int campioni_pianificati = 0 ;
    		
    		
    			
    				campioni_pianificati = el.getCampioniPianificati();
    			
    		
    		%>
    		<td width="4">
    		<center>
    		<input type="text" id = "campioni_<%=code %>" name = "campioni_<%=code %>" size="16" width="20" value="<%=((el.getCampioniPianificati()==-1) ? "Non Rilevante" : campioni_pianificati)%>" size="6" maxlength="5" onchange="calcotaTotaleCampioni()" ></center></td>
    		<%
    	}
    	%>
    	
    </tr>
 	<%}
	 else
	 {
		 %>
		 
		 <tr>
	<td class="formLabel">Periodo di Riferimento<br>(Durata)</td>
    <td>
       <table class = "noborder">
          	<tr>
          		
          		<td>
          			<%LookupDurata.setJsEvent("onchange=disabilitaPeriodo(document.addProgrammazione)");%>
          		 <%=LookupDurata.getHtmlSelect("durata",TicketDetails.getDurata()) %><font color="red">*</font>
          		</td>
          	
          	</tr>
          	<tr><td colspan="2">&nbsp;</td></tr>
          	<tr id = "validita">
          		<td>Validità dal  </td>
          		<td>
          		 <input type="text" name="data1" id = "data1" size="10" value="<%=toHtml(TicketDetails.getData1asString()) %>" />&nbsp;<a href="javascript:popCalendar('addProgrammazione','data1','it','IT','Europe/Berlin');" id = "linkdata1"><img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
    			al <input type="text" name="data2"  id = "data2" size="10" value="<%=toHtml(TicketDetails.getData2asString()) %>" />&nbsp;<a href="javascript:popCalendar('addProgrammazione','data2','it','IT','Europe/Berlin');"  id = "linkdata2"><img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
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
      <td id = "piano"><%=pianiList.getSelectedValue(TicketDetails.getPiano_monitoraggio()) %></td>
      <td>
    
       &nbsp;[<a href="javascript:popLookupSelectorCustomProgrammazioni('description','short_description','lookup_piano_monitoraggio','',<%=user.getSiteId() %>);">Seleziona Piano di Monitoraggio</a>] 
      <input type = "hidden" name = "piano_monitoraggio" id = "piano_value" value = "<%=TicketDetails.getPiano_monitoraggio() %>">
      </td>
      
      </tr></table>
      </td>
    	
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
    	<input type = "text" readonly="readonly" id = "totaleCampioni" name ="num_tot_campioni" value="0">
    	</td>
    	
    	</tr>
     
     
</table>

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
    	
		Hashtable<String,ArrayList<OiaNodo>> asl_coinvolte= TicketDetails.getAsl_coinvolte();
		Iterator<String> itK = asl_coinvolte.keySet().iterator();
    	while(itK.hasNext())
    	{
    		String k = itK.next();
    		ArrayList<OiaNodo> lista = asl_coinvolte.get(k) ;
    		int i = 0 ;
    		for (OiaNodo el : lista)
    		{
    			%>
    			
    			<tr>
    		<input type = "hidden" name = "asl_coinvolte" value="<%=el.getId() %>">
    		<input type = "hidden" id = "padre_<%=i %>" value = "<%=el.getId() %>">
    		<td colspan="2"><%="<b>"+el.getDescrizione_lunga()+"</b>" %></td>
    		
    		<td width="4">
    		<center>
    		<input type="text" readonly="readonly" id = "cu_<%=el.getId() %>" name = "cu_<%=el.getId() %>" size="16" width="20" value="<%=((el.getCuPianificati()==-1) ? "Non Rilevante" : el.getCuPianificati())%>" size="6" maxlength="5" onchange="calcotaTotaleCu()" ></center></td>
    		
    		<td width="4">
    		<center>
    		<input type="text" readonly="readonly" id = "campioni_<%=el.getId() %>" name = "campioni_<%=el.getId() %>" size="16" width="20" value="<%=((el.getCampioniPianificati()==-1) ? "Non Rilevante" : el.getCampioniPianificati())%>" size="6" maxlength="5" " ></center></td>
    		</tr>
    			
    			
    			<%
    			
    			ArrayList<OiaNodo> figli = el.getLista_nodi() ;
    			int j = 0 ;
    			for(OiaNodo figlio : figli)
    			{
    		int code = figlio.getId();
    		int cu_pianificati = figlio.getCuPianificati();
    		int campioni_pianificati = figlio.getCampioniPianificati() ;
    		%>
    		<tr>
    		<td>&nbsp;</td>
    		<input type = "hidden" name = "asl_coinvolte" value="<%=code %>">
    		<td><%="<b>"+figlio.getDescrizione_lunga()+"</b>" %></td>
    		    		<input type = "hidden" id = "figli_<%=j %>_<%=figlio.getId_padre() %>" value = "<%=figlio.getId() %>">
    		
    		<td width="4">
    		<center>
    		<input type="text" id = "cu_<%=code %>" name = "cu_<%=code %>" size="16" width="20" onchange="calcotaTotaleCuFigli(document.getElementById('cu_<%=figlio.getId_padre() %>'),<%=figlio.getId_padre() %>)" value="<%=((figlio.getCuPianificati()==-1) ? "Non Rilevante" : cu_pianificati)%>" size="6" maxlength="5" onchange="calcotaTotaleCu()" ></center></td>
    		
    		<td width="4">
    		<center>
    		<input type="text" id = "campioni_<%=code %>" onchange="calcotaTotaleCampioniFigli(document.getElementById('campioni_<%=figlio.getId_padre() %>'),<%=figlio.getId_padre() %>)" name = "campioni_<%=code %>" size="16" width="20" value="<%=((figlio.getCampioniPianificati()==-1) ? "Non Rilevante" : campioni_pianificati)%>" size="6" maxlength="5" " ></center></td>
    		</tr>
    		<% j++ ;
    	}i++;}}
    	%>
    
		 <%
		 
		 
	 }
	 %>
 	
    
</table>
<br>
<input type="submit" value="Aggiorna" name="Save" onClick="return checkForm(this.form)">
<input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.action='Cruscotto.do?command=Details&id_programmazione=<%=TicketDetails.getId() %>'">
</form>
</body>