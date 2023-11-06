<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@page import="java.util.Date"%>
<%@page import="org.aspcfs.modules.programmazzionecu.base.ProgrammazioneCu"%>
<%@page import="org.aspcfs.modules.programmazzionecu.base.AslCoinvolte"%>

<%@page import="org.aspcfs.modules.oia.base.OiaNodo"%>
<%@page import="org.aspcfs.modules.oia.base.ResponsabileNodo"%><jsp:useBean id="PianoMonitoraggio" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TicketDetails" class="org.aspcfs.modules.programmazzionecu.base.ProgrammazioneCu" scope="request"/>
<jsp:useBean id="SiteIdList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="LookupDurata" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/confirmDelete.js"></script>
<script>
function switch_elemento(id)
{
	if (document.getElementById(id).style.display=='')
		document.getElementById(id).style.display='none';
	else
		document.getElementById(id).style.display='';
}
function switch_elemento_albero(id_immagine_elemento, id_sotto_elemento) {
	if (document.getElementById(id_sotto_elemento).style.display=='') {
		document.getElementById(id_immagine_elemento).src = "images/tree0.gif";
		document.getElementById(id_sotto_elemento).style.display='none';
	} else {
		document.getElementById(id_immagine_elemento).src = "images/tree1.gif";
		document.getElementById(id_sotto_elemento).style.display='';
	}
}

function inRow(riga)
{
	riga.style.background='#FFF5EE';
}

function outRow(i,riga)
{
	if (i==1)
	{
		riga.style.background='#EDEDED';
	}
	else
	{
		riga.style.background='#FFFFFF';
	}
}
</script>

<%@ include file="../initPage.jsp" %>

<%

UserBean user = (UserBean)session.getAttribute("User");
int cupianificati = 0;
boolean sottoProgrammazioni = false ;
if (User.getSiteId()>0)
{

String asl = SiteIdList.getValueFromId(User.getSiteId());
	ArrayList<OiaNodo> aslCoinvolte = TicketDetails.getAsl_coinvolte().get(asl);
	
	int cuEseguiti = 0;
	for (OiaNodo ac3 : aslCoinvolte)
	if (ac3 !=null )
	{
		if (ac3.getN_livello()==2)
		{
			sottoProgrammazioni = true ;
		}
		cupianificati += ac3.getCuPianificati();
	}
}
%>
<form name="details" action="Cruscotto.do?command=Modify" method="post">

<input type = "hidden" name = "id_programmazione" value="<%=TicketDetails.getId() %>">
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Cruscotto.do?command=Search">Programmazione Controlli Ufficiali</a> > Scheda di Programmazione
</td>
</tr>
</table>
<br><br><br>

<dhv:evaluate if="<%=!TicketDetails.isTrashed()%>">
    <dhv:permission name="programmazione-programmazione-delete">
      <input type="button" value="Cancella"	onClick="javascript: if(confirm('Sei sicuro di voler eliminare questa programmazione ?')==true) {window.location.href='Cruscotto.do?command=Delete&id_programmazione=<%= TicketDetails.getId() %>'};">
    </dhv:permission>
</dhv:evaluate>

<dhv:evaluate if="<%=!TicketDetails.isTrashed() && (User.getSiteId()<=0 || sottoProgrammazioni==true ) %>">
    <dhv:permission name="programmazione-programmazione-edit">
      <input type="button" value="Modifica"	onClick="javascript:window.location.href='Cruscotto.do?command=Modify&id_programmazione=<%=TicketDetails.getId() %>';">

    </dhv:permission>
</dhv:evaluate>
<%
 
	int size = ( (User.getSiteId() > 0) ? (1) : (SiteIdList.size()) );
%>
	<table cellpadding="4" cellspacing="0" width="100%" class="details" >
	<tr>
	<th colspan="2"><center>Scheda Pianificazione <%= ((User.getSiteId()>-1) ? "ASL : "+ (SiteIdList.getSelectedValue(User.getSiteId())) : "" )+"" %></center></th></tr>
		
		<tr>
	<th class="formLabel">Periodo di Riferimento<br>(Durata)</th>
    <td>
       <table class = "noborder">
          	<tr>
          		
          		<td>
          		
          			<%=LookupDurata.getSelectedValue(TicketDetails.getDurata())	%>
          		
          		</td>
          	
          	</tr>
          	<tr><td colspan="2">&nbsp;</td></tr>
          	<tr>
          		<td><%if(!TicketDetails.getData1asString().equals("")){ %>
          			Valida dal <%=TicketDetails.getData1asString() %>
          			<%
          		}%>  </td>
          		<td>
          		
          		<%if(!TicketDetails.getData2asString().equals("")){ %>
          			al <%=TicketDetails.getData2asString() %>
          			<%
          		}%>
    			
          		</td>
          	
          	</tr>
         </table>
     </td>
	</tr>
		<tr>
			<th class="formLabel">Piano di Monitoraggio</th>
			<td><%=PianoMonitoraggio.getSelectedValue(TicketDetails.getPiano_monitoraggio()).toUpperCase() %></td>
		</tr>
		
		<tr>
			<th class="formLabel">Num. Tot. Controlli per piano</th>
			<td><%= (User.getSiteId()>0) ? ""+cupianificati : "" +TicketDetails.getNum_tot_cu() %></td>
		</tr>
	
	    							
</table>
<br><br>
<%if (User.getSiteId()<0)
	{
%>
<table cellpadding="4" cellspacing="0" width="100%" class="details">
	
	<tr>
		<th>&nbsp;</th>
		<th colspan="9"><center>Pianificazione </center></th>
	</tr>
	<tr>
	<th>&nbsp;</th>
	
		<th>&nbsp;</th>
		<th colspan="2"><center>Pianificati</center></th>
		<th colspan="2"><center>Eseguiti</center></th>
		<th colspan="2"><center>Residui </center></th>
	</tr>
	<tr>
	<th>&nbsp;</th>
	<th>&nbsp;</th>
		
		<th ><center>CU</center></th>
		<th ><center>CAMPIONI</center></th>
		<th ><center>CU</center></th>
		<th ><center>CAMPIONI</center></th>
		<th ><center>CU</center></th>
		<th ><center>CAMPIONI</center></th>
	</tr>

<%

Hashtable<String,ArrayList<OiaNodo>> listaAsl = TicketDetails.getAsl_coinvolte(); 

int rowid = 0;
Iterator it = SiteIdList.iterator();

//for(int i =201; i <=207; i++)
Iterator<String> itKe = listaAsl.keySet().iterator();

while (itKe.hasNext())
{
	String asl = itKe.next() ;
	OiaNodo aslCoinvolta = listaAsl.get(asl).get(0);
	
	rowid = (rowid != 1?1:2);
	//OiaNodo aslCoinvolta = listaAsl.get(SiteIdList.getSelectedValue(i));
	
	if(aslCoinvolta!=null)
	{
		
		if(!aslCoinvolta.getLista_nodi().isEmpty())
		{
			
	%>
	<tr align="center" id='riga_<%= aslCoinvolta.getId()  %>' onmouseover="inRow(this)" onmouseout="outRow(<%= aslCoinvolta.getId() %>,this)" > 
							
							<td onclick="switch_elemento_albero('img_riga_<%= aslCoinvolta.getId()  %>','sotto_riga_<%= aslCoinvolta.getId() %>')" >
								<img id="img_riga_<%= aslCoinvolta.getId()  %>" src="images/tree0.gif" border=0>
							</td>
							
	<td >
	<%=SiteIdList.getSelectedValue(aslCoinvolta.getId_asl()) %>
	</td>
		
		<td ><%= (aslCoinvolta.getCuPianificati()==0)? "Non Pianificati" : aslCoinvolta.getCuPianificati() + "" %></td>
		<td ><%= (aslCoinvolta.getCampioniPianificati()==0)? "Non Pianificati" : aslCoinvolta.getCampioniPianificati() + "" %></td>
		<td ><%=aslCoinvolta.getCuEseguiti() %></td>
		<td ><%=aslCoinvolta.getCampioniEseguiti()%>
		<td ><%=((aslCoinvolta.getCuPianificati()-aslCoinvolta.getCuEseguiti())>0 ? ((aslCoinvolta.getCuPianificati()-aslCoinvolta.getCuEseguiti())) : "0")+""%></td>
		<td ><%=((aslCoinvolta.getCampioniPianificati()-aslCoinvolta.getCampioniEseguiti())>0 ? (aslCoinvolta.getCampioniPianificati()-aslCoinvolta.getCampioniEseguiti()) : "0") +""%></td>
		</tr>

	
	<tr align="center"  id ="sotto_riga_<%= aslCoinvolta.getId() %>" style="display: none">
							<td colspan="7">
								<table cellpadding="9" cellspacing="0" width="100%" style="padding-left: 50px" >
								
								<%-- Intestazione --%>
								<tr align="center"  style="background-color: #FFE4C4;">
									
	<tr>
	<th>&nbsp;</th>
	
		<th>&nbsp;</th>
		<th colspan="2"><center>Pianificati</center></th>
		<th colspan="2"><center>Eseguiti</center></th>
		<th colspan="2"><center>Residui </center></th>
	</tr>
	<tr>
	<th>&nbsp;</th>
	<th>&nbsp;</th>
		
		<th ><center>CU</center></th>
		<th ><center>CAMPIONI</center></th>
		<th ><center>CU</center></th>
		<th ><center>CAMPIONI</center></th>
		<th ><center>CU</center></th>
		<th ><center>CAMPIONI</center></th>
	</tr>
	<%
		
			for(OiaNodo aslFiglia : aslCoinvolta.getLista_nodi() )
			{
				if(aslFiglia.getLista_nodi().size()>0)
				{
				%>
				<tr align="center"  id ="riga_<%= aslFiglia.getId() %>_<%= aslFiglia.getId() %>" style="background-color: #FFCB98;" >
											
											
											 <td onclick="switch_elemento_albero('img_riga_<%= aslFiglia.getId() %>_<%= aslFiglia.getId() %>','sotto_riga_<%= aslCoinvolta.getId() %>_<%= aslFiglia.getId() %>')" >
												<img id="img_riga_<%= aslFiglia.getId() %>_<%= aslFiglia.getId() %>" src="images/tree0.gif" border=0>
											</td>
				<td >
				<%=aslFiglia.getDescrizione_lunga() %>
				</td>
				<td ><%= (aslFiglia.getCuPianificati()==0)? "Non Pianificati" : aslFiglia.getCuPianificati() + "" %></td>
		<td ><%= (aslFiglia.getCampioniPianificati()==0)? "Non Pianificati" : aslFiglia.getCampioniPianificati() + "" %></td>
		<td ><%=aslFiglia.getCuEseguiti() %></td>
		<td ><%=aslFiglia.getCampioniEseguiti()%>
		<td ><%=((aslFiglia.getCuPianificati()-aslFiglia.getCuEseguiti())>0 ? ((aslFiglia.getCuPianificati()-aslFiglia.getCuEseguiti())) : "0")+""%></td>
		<td ><%=((aslFiglia.getCampioniPianificati()-aslFiglia.getCampioniEseguiti())>0 ? (aslFiglia.getCampioniPianificati()-aslFiglia.getCampioniEseguiti()) : "0") +""%></td>
		</tr>
				
				<tr align="center"  id ="sotto_riga_<%= aslCoinvolta.getId() %>_<%= aslFiglia.getId() %>" style="display: none">
											<td colspan="7">
												<table cellpadding="9" cellspacing="0" width="100%" style="padding-left: 100px" >
													<tr align="center"  style="background-color: #99FF00;">

	<th>&nbsp;</th>
	
		<th>&nbsp;</th>
		<th colspan="2"><center>Pianificati</center></th>
		<th colspan="2"><center>Eseguiti</center></th>
		<th colspan="2"><center>Residui </center></th>
	</tr>
	<tr>
	<th>&nbsp;</th>
	<th>&nbsp;</th>
		
		<th ><center>CU</center></th>
		<th ><center>CAMPIONI</center></th>
		<th ><center>CU</center></th>
		<th ><center>CAMPIONI</center></th>
		<th ><center>CU</center></th>
		<th ><center>CAMPIONI</center></th>
	</tr>
				
				<%
				
					for(OiaNodo aslNipote : aslFiglia.getLista_nodi() )
					{
						%>
						<tr align="center"  id ="riga_<%= aslCoinvolta.getId() %>_<%= aslFiglia.getId() %>_<%= aslNipote.getId() %>" style="background-color: #FFE5CC;">
															<td><img src="images/box.gif" border=0></td>
						<td >
						<%=aslNipote.getDescrizione_lunga() %>
						</td>
		<td ><%= (aslNipote.getCuPianificati()==0)? "Non Pianificati" : aslNipote.getCuPianificati() + "" %></td>
		<td ><%= (aslNipote.getCampioniPianificati()==0)? "Non Pianificati" : aslNipote.getCampioniPianificati() + "" %></td>
		<td ><%=aslNipote.getCuEseguiti() %></td>
		<td ><%=aslNipote.getCampioniEseguiti()%>
		<td ><%=((aslNipote.getCuPianificati()-aslNipote.getCuEseguiti())>0 ? ((aslNipote.getCuPianificati()-aslNipote.getCuEseguiti())) : "0")+""%></td>
		<td ><%=((aslNipote.getCampioniPianificati()-aslNipote.getCampioniEseguiti())>0 ? (aslNipote.getCampioniPianificati()-aslNipote.getCampioniEseguiti()) : "0") +""%></td>
		</tr>	<%
					
				
				
				}%></table>
											</td>
										</tr>
				<%
			}
				else
				{
					%>
					<tr align="center"  id ="riga_<%= aslCoinvolta.getId() %>_<%= aslFiglia.getId() %>" style="background-color: #FFCB98;">
											<td><img src="images/box.gif" border=0></td>
					<td >
						<%=aslFiglia.getDescrizione_lunga() %>
						</td>						
				<td ><%= (aslFiglia.getCuPianificati()==0)? "Non Pianificati" : aslFiglia.getCuPianificati() + "" %></td>
		<td ><%= (aslFiglia.getCampioniPianificati()==0)? "Non Pianificati" : aslFiglia.getCampioniPianificati() + "" %></td>
		<td ><%=aslFiglia.getCuEseguiti() %></td>
		<td ><%=aslFiglia.getCampioniEseguiti()%>
		<td ><%=((aslFiglia.getCuPianificati()-aslFiglia.getCuEseguiti())>0 ? ((aslFiglia.getCuPianificati()-aslFiglia.getCuEseguiti())) : "0")+""%></td>
		<td ><%=((aslFiglia.getCampioniPianificati()-aslFiglia.getCampioniEseguiti())>0 ? (aslFiglia.getCampioniPianificati()-aslFiglia.getCampioniEseguiti()) : "0") +""%></td>
		</tr>
					<%
					
				}
			}
	%>
	</table>
							</td>
						</tr>
					
					
	<%
			
			
		}
		else
		{
			%>
			
			<tr align="center" id='riga_<%= aslCoinvolta.getId()  %>' onmouseover="inRow(this)" onmouseout="outRow(<%= aslCoinvolta.getId() %>,this)" > 
							<td><img src="images/box.gif" border=0></td>
							<td >
	<%=SiteIdList.getSelectedValue(aslCoinvolta.getId_asl()) %>
	</td>
		<td ><%= (aslCoinvolta.getCuPianificati()==0)? "Non Pianificati" : aslCoinvolta.getCuPianificati() + "" %></td>
		<td ><%= (aslCoinvolta.getCampioniPianificati()==0)? "Non Pianificati" : aslCoinvolta.getCampioniPianificati() + "" %></td>
		<td ><%=aslCoinvolta.getCuEseguiti() %></td>
		<td ><%=aslCoinvolta.getCampioniEseguiti()%>
		<td ><%=((aslCoinvolta.getCuPianificati()-aslCoinvolta.getCuEseguiti())>0 ? ((aslCoinvolta.getCuPianificati()-aslCoinvolta.getCuEseguiti())) : "0")+""%></td>
		<td ><%=((aslCoinvolta.getCampioniPianificati()-aslCoinvolta.getCampioniEseguiti())>0 ? (aslCoinvolta.getCampioniPianificati()-aslCoinvolta.getCampioniEseguiti()) : "0") +""%></td>
		</tr>
	
			<%
			
		}
		
	
	
	}
	else
	{
		%>
		<tr>
		<td width="20%" rowspan="2" class="row<%= rowid %>"><%=(aslCoinvolta.getN_livello()==1) ? asl : aslCoinvolta.getDescrizione_lunga() %></td>
		<th>C.U.</th>
		<td class="row<%= rowid %>" > Non Rilevante </td>
		<td class="row<%= rowid %>">  Non Rilevante </td>
		<td class="row<%= rowid %>">  Non Rilevante </td></tr>
		<tr class="row<%= rowid %>">
		<th>Campioni</th>
		<td class="row<%= rowid %>">  Non Rilevante </td>
		<td class="row<%= rowid %>">  Non Rilevante </td>
		<td class="row<%= rowid %>">  Non Rilevante </td></tr>
			
		<% 
	}

}
%>
</table>
	<br><br>
<%
	}
else
{
	
	Hashtable<String,ArrayList<OiaNodo>> listaAsl = TicketDetails.getAsl_coinvolte();
	String asl = SiteIdList.getValueFromId(User.getSiteId());
	
	
	
	ArrayList<OiaNodo> aslCoinvolte = listaAsl.get(asl);
	
%>
<table cellpadding="4" cellspacing="0" width="100%" class="details">
	
	<tr>
		<th>&nbsp;</th>
		<th colspan="9"><center>Pianificazione </center></th>
	</tr>
	<tr>
	<th>&nbsp;</th>
	
		<th>&nbsp;</th>
		<th colspan="2"><center>Pianificati</center></th>
		<th colspan="2"><center>Eseguiti</center></th>
		<th colspan="2"><center>Residui </center></th>
	</tr>
	<tr>
	<th>&nbsp;</th>
	<th>&nbsp;</th>
		
		<th ><center>CU</center></th>
		<th ><center>CAMPIONI</center></th>
		<th ><center>CU</center></th>
		<th ><center>CAMPIONI</center></th>
		<th ><center>CU</center></th>
		<th ><center>CAMPIONI</center></th>
	</tr>
	<%
	for (OiaNodo aslCoinvolta : aslCoinvolte)
	{
	
		if(!aslCoinvolta.getLista_nodi().isEmpty())
		{
	%>
	<tr align="center" id='riga_<%= aslCoinvolta.getId()  %>' onmouseover="inRow(this)" onmouseout="outRow(<%= aslCoinvolta.getId() %>,this)" > 
							
							<td onclick="switch_elemento_albero('img_riga_<%= aslCoinvolta.getId()  %>','sotto_riga_<%= aslCoinvolta.getId() %>')" >
								<img id="img_riga_<%= aslCoinvolta.getId()  %>" src="images/tree0.gif" border=0>
							</td>
							
	<td >
	<%=aslCoinvolta.getDescrizione_lunga() %>
	</td>
		
		<td ><%= (aslCoinvolta.getCuPianificati()==0)? "Non Pianificati" : aslCoinvolta.getCuPianificati() + "" %></td>
		<td ><%= (aslCoinvolta.getCampioniPianificati()==0)? "Non Pianificati" : aslCoinvolta.getCampioniPianificati() + "" %></td>
		<td ><%=aslCoinvolta.getCuEseguiti() %></td>
		<td ><%=aslCoinvolta.getCampioniEseguiti()%>
		<td ><%=((aslCoinvolta.getCuPianificati()-aslCoinvolta.getCuEseguiti())>0 ? ((aslCoinvolta.getCuPianificati()-aslCoinvolta.getCuEseguiti())) : "0")+""%></td>
		<td ><%=((aslCoinvolta.getCampioniPianificati()-aslCoinvolta.getCampioniEseguiti())>0 ? (aslCoinvolta.getCampioniPianificati()-aslCoinvolta.getCampioniEseguiti()) : "0") +""%></td>
		</tr>

	
	<tr align="center"  id ="sotto_riga_<%= aslCoinvolta.getId() %>" style="display: none">
							<td colspan="7">
								<table cellpadding="9" cellspacing="0" width="100%" style="padding-left: 50px" >
								
								<%-- Intestazione --%>
								<tr align="center"  style="background-color: #FFCB98;">
									
	<tr>
	<th>&nbsp;</th>
	
		<th>&nbsp;</th>
		<th colspan="2"><center>Pianificati</center></th>
		<th colspan="2"><center>Eseguiti</center></th>
		<th colspan="2"><center>Residui </center></th>
	</tr>
	<tr>
	<th>&nbsp;</th>
	<th>&nbsp;</th>
		
		<th ><center>CU</center></th>
		<th ><center>CAMPIONI</center></th>
		<th ><center>CU</center></th>
		<th ><center>CAMPIONI</center></th>
		<th ><center>CU</center></th>
		<th ><center>CAMPIONI</center></th>
	</tr>
	<%
		
			for(OiaNodo aslFiglia : aslCoinvolta.getLista_nodi() )
			{
				if(aslFiglia.getLista_nodi().size()>0)
				{
				%>
				<tr align="center"  id ="riga_<%= aslFiglia.getId() %>_<%= aslFiglia.getId() %>" style="background-color: #FFCB98;" >
											
											
											 <td onclick="switch_elemento_albero('img_riga_<%= aslFiglia.getId() %>_<%= aslFiglia.getId() %>','sotto_riga_<%= aslCoinvolta.getId() %>_<%= aslFiglia.getId() %>')" >
												<img id="img_riga_<%= aslFiglia.getId() %>_<%= aslFiglia.getId() %>" src="images/tree0.gif" border=0>
											</td>
				<td >
				<%=aslFiglia.getDescrizione_lunga() %>
				</td>
					<td ><%= (aslFiglia.getCuPianificati()==0)? "Non Pianificati" : aslFiglia.getCuPianificati() + "" %></td>
		<td ><%= (aslFiglia.getCampioniPianificati()==0)? "Non Pianificati" : aslFiglia.getCampioniPianificati() + "" %></td>
		<td ><%=aslFiglia.getCuEseguiti() %></td>
		<td ><%=aslFiglia.getCampioniEseguiti()%>
		<td ><%=((aslFiglia.getCuPianificati()-aslFiglia.getCuEseguiti())>0 ? ((aslFiglia.getCuPianificati()-aslFiglia.getCuEseguiti())) : "0")+""%></td>
		<td ><%=((aslFiglia.getCampioniPianificati()-aslFiglia.getCampioniEseguiti())>0 ? (aslFiglia.getCampioniPianificati()-aslFiglia.getCampioniEseguiti()) : "0") +""%></td>
		</tr>
				
				<tr align="center"  id ="sotto_riga_<%= aslCoinvolta.getId() %>_<%= aslFiglia.getId() %>" style="display: none">
											<td colspan="7">
												<table cellpadding="9" cellspacing="0" width="100%" style="padding-left: 100px" >
													<tr align="center"  style="background-color: #99FF00;">

	<th>&nbsp;</th>
	
		<th>&nbsp;</th>
		<th colspan="2"><center>Pianificati</center></th>
		<th colspan="2"><center>Eseguiti</center></th>
		<th colspan="2"><center>Residui </center></th>
	</tr>
	<tr>
	<th>&nbsp;</th>
	<th>&nbsp;</th>
		
		<th ><center>CU</center></th>
		<th ><center>CAMPIONI</center></th>
		<th ><center>CU</center></th>
		<th ><center>CAMPIONI</center></th>
		<th ><center>CU</center></th>
		<th ><center>CAMPIONI</center></th>
	</tr>
				
				<%
				
					for(OiaNodo aslNipote : aslFiglia.getLista_nodi() )
					{
						%>
						<tr align="center"  id ="riga_<%= aslCoinvolta.getId() %>_<%= aslFiglia.getId() %>_<%= aslNipote.getId() %>" style="background-color: #99FF00;">
															<td><img src="images/box.gif" border=0></td>
						<td >
						<%=aslNipote.getDescrizione_lunga() %>
						</td>
			<td ><%= (aslNipote.getCuPianificati()==0)? "Non Pianificati" : aslNipote.getCuPianificati() + "" %></td>
		<td ><%= (aslNipote.getCampioniPianificati()==0)? "Non Pianificati" : aslNipote.getCampioniPianificati() + "" %></td>
		<td ><%=aslNipote.getCuEseguiti() %></td>
		<td ><%=aslNipote.getCampioniEseguiti()%>
		<td ><%=((aslNipote.getCuPianificati()-aslNipote.getCuEseguiti())>0 ? ((aslNipote.getCuPianificati()-aslNipote.getCuEseguiti())) : "0")+""%></td>
		<td ><%=((aslNipote.getCampioniPianificati()-aslNipote.getCampioniEseguiti())>0 ? (aslNipote.getCampioniPianificati()-aslNipote.getCampioniEseguiti()) : "0") +""%></td>
		</tr>	<%
					
				
				
				}%></table>
											</td>
										</tr>
				<%
			}
				else
				{ 
					%>
					<tr align="center"  id ="riga_<%= aslCoinvolta.getId() %>_<%= aslFiglia.getId() %>" style="background-color: #FFCB98;">
											<td><img src="images/box.gif" border=0></td>
					<td >
						<%=aslFiglia.getDescrizione_lunga() %>
						</td>						
				<td ><%= (aslFiglia.getCuPianificati()==0)? "Non Pianificati" : aslFiglia.getCuPianificati() + "" %></td>
		<td ><%= (aslFiglia.getCampioniPianificati()==0)? "Non Pianificati" : aslFiglia.getCampioniPianificati() + "" %></td>
		<td ><%=aslFiglia.getCuEseguiti() %></td>
		<td ><%=aslFiglia.getCampioniEseguiti()%>
		<td ><%=((aslFiglia.getCuPianificati()-aslFiglia.getCuEseguiti())>0 ? ((aslFiglia.getCuPianificati()-aslFiglia.getCuEseguiti())) : "0")+""%></td>
		<td ><%=((aslFiglia.getCampioniPianificati()-aslFiglia.getCampioniEseguiti())>0 ? (aslFiglia.getCampioniPianificati()-aslFiglia.getCampioniEseguiti()) : "0") +""%></td>
		</tr>
					<%
					
				}
			}
	%>
	</table>
							</td>
						</tr>
					
					
	<%
			
			
		}
		else
		{
			%>
			
			<tr align="center" id='riga_<%= aslCoinvolta.getId()  %>' onmouseover="inRow(this)" onmouseout="outRow(<%= aslCoinvolta.getId() %>,this)" > 
							<td><img src="images/box.gif" border=0></td>
							<td >
	<%=aslCoinvolta.getDescrizione_lunga() %>
	</td>
	<td ><%= (aslCoinvolta.getCuPianificati()==0)? "Non Pianificati" : aslCoinvolta.getCuPianificati() + "" %></td>
		<td ><%= (aslCoinvolta.getCampioniPianificati()==0)? "Non Pianificati" : aslCoinvolta.getCampioniPianificati() + "" %></td>
		<td ><%=aslCoinvolta.getCuEseguiti() %></td>
		<td ><%=aslCoinvolta.getCampioniEseguiti()%>
		<td ><%=((aslCoinvolta.getCuPianificati()-aslCoinvolta.getCuEseguiti())>0 ? ((aslCoinvolta.getCuPianificati()-aslCoinvolta.getCuEseguiti())) : "0")+""%></td>
		<td ><%=((aslCoinvolta.getCampioniPianificati()-aslCoinvolta.getCampioniEseguiti())>0 ? (aslCoinvolta.getCampioniPianificati()-aslCoinvolta.getCampioniEseguiti()) : "0") +""%></td>
		</tr>
	
			<%
			
		}
		
	
	%>
	
	
	
	<%
	
	
	} %>
	</table>
	<br><br>
<%	
} 
%>

<dhv:evaluate if="<%=!TicketDetails.isTrashed()%>">
    <dhv:permission name="programmazione-programmazione-delete">
      <input type="button" value="Cancella"	onClick="javascript: if(confirm('Sei sicuro di voler eliminare questa programmazione ?')==true) {window.location.href='Cruscotto.do?command=Delete&id_programmazione=<%= TicketDetails.getId() %>'};">
    </dhv:permission>
</dhv:evaluate>

<dhv:evaluate if="<%=!TicketDetails.isTrashed() && (User.getSiteId()<=0 || sottoProgrammazioni==true ) %>">
    <dhv:permission name="programmazione-programmazione-edit">
      <input type="button" value="Modifica"	onClick="javascript:window.location.href='Cruscotto.do?command=Modify&id_programmazione=<%=TicketDetails.getId() %>';">

    </dhv:permission>
</dhv:evaluate>
</form>
	
		
		

