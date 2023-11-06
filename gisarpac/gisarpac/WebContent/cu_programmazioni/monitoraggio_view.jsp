
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.aspcfs.modules.login.beans.UserBean"%>
<%@page import="org.aspcfs.modules.admin.base.User"%>
<%@page import="org.aspcfs.utils.web.LookupList"%>
<%@page import="org.aspcfs.utils.web.LookupElement"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.aspcfs.modules.oia.base.OiaNodo"%>
<%@page import="org.aspcfs.modules.programmazzionecu.base.ProgrammazioniCuList"%>
<%@page import="org.aspcfs.modules.programmazzionecu.base.ProgrammazioneCu"%>
<%@page import="java.util.Hashtable"%><jsp:useBean id="SiteIdList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TicListInfoMonitoraggio" class="org.aspcfs.utils.web.PagedListInfo" scope="session"/>

<jsp:useBean id="ListaPiani" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="LookupDurata" class="java.lang.String" scope="request"/>
<jsp:useBean id="Data1" class="java.lang.String" scope="request"/>
<jsp:useBean id="Data2" class="java.lang.String" scope="request"/>
<jsp:useBean id="DescrizioneMonitoring" class="java.lang.String" scope="request"/>
<script type="text/javascript" src="charts/FusionCharts.js"></script>
<script type="text/javascript" src="highslide/highslide-full.js"></script>
<script type="text/javascript" src="highslide/highslide.config.js" charset="utf-8"></script>
<link rel="stylesheet" type="text/css" href="highslide/highslide.css" />
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
<script>

function viewGrafico()
{
 if (document.getElementById('grafico_cu').style.display=="none")
 {
	 document.getElementById('grafico_cu').style.display = "" ;
	 document.getElementById('grafico_campioni').style.display = "none" ;
	 document.getElementById('link').innerHTML = "<b>View Campioni Monitoring</b>" ;
 }
 else
 {
	 document.getElementById('grafico_cu').style.display = "none" ;
	 document.getElementById('grafico_campioni').style.display = "" ;
	 document.getElementById('link').innerHTML = "<b>View CU Monitoring</b>" ;
 }

}

</script>

<%UserBean user = (UserBean) session.getAttribute("User"); 
Boolean includiDisabilitatiBool = (Boolean) request.getAttribute("includiDisabilitatiBool");

%>


<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Monitoraggio.do?command=Monitoraggio">Report Controlli</a>  > <%=((request.getAttribute("DescrizioneMonitoring")!=null && ! "".equals(request.getAttribute("DescrizioneMonitoring")) )? request.getAttribute("DescrizioneMonitoring") : ("Monitoragio Controlli in Sorveglianza")) %>
</td>
</tr>
</table>

<br><br>

<table class = "details" width="100%">
<tr><th colspan="2"><%=request.getAttribute("DescrizioneMonitoring")%></th></tr>
<tr><td class = "formlabel">Nome Report</td><td><%=DescrizioneMonitoring %></td></tr>
<tr><td class = "formlabel">Periodo di Riferimento</td><td><%=(LookupDurata + (!Data1.equals("") ? " Dal " + Data1 : (" ")) + (!Data2.equals("") ? " AL " + Data2 : (" ")) ) %> </td></tr>
<tr><td class = "formlabel">Descrizione Report</td><td><textarea style="width: 100%" rows="6" cols="150" disabled="disabled">
<%if (!((String)request.getAttribute("TipoMonitoraggio")).equals("2")){%>IN QUESTO REPORT VENGONO MOSTRATI IL NUMERO DI CONTROLLI ESEGUITI , SCADUTI E DA ESEGUIRE PER OGNI ASL NEL PERIODO SELEZIONATO.
CU DA FARE 	: INDILCA IL NUMERO DI CONTROLLI LA CUI DATA DI PROSSIMO CONTROLLO RIENTRA NEL PERIODO SELEZIONATO.
CU SCADUTI 	: INDICA IL NUMERO DI CONTROLLI LA CUI DATA PROSSIMO CONTROLLO E' PRECEDENTE AL LIMITE INFERIORE DEL PERIODO SELEZIONATO.
CU ESEGUITI      : INDICA IL NUMERO DI CONTROLLI LA CUI DATA DI INIZIO ATTIVITA' E' COMPRESA NEL PERIODO SELEZIONATO<%}%>
</textarea> </td></tr>
</table>
<br><br>
<%if (((String)request.getAttribute("TipoMonitoraggio")).equals("2")) // monitoraggio per controlli di tipo ispezione piano di monitoraggio
{
%>
	
	
<br>
<br>


<CENTER>
<%
String tipo_raggruppamento = (String) request.getAttribute("TipoPiano");

String 	data_1 	= (String)request.getAttribute("Data1");
String 	data_2 	= (String)request.getAttribute("Data2");
String durata 	= (String)request.getAttribute("Durata");
%>
<br>

<!-- tabella riepilogativa dei controlli e cmapioni eseguiti da ogni asl -->

<%
if(!tipo_raggruppamento.equals("1"))
{
%>
<dhv:pagedListStatus title="Lista Piani" object="TicListInfoMonitoraggio"/>
<%} %>
<table class="details" width="100%">
<tr>


<th>
<th>&nbsp;</th>

<th colspan="3"><center>Numero CU</center></th>
<th colspan="3"><center>Numero Campioni</center></th>
</tr>

<tr>


<th>&nbsp;</th>
<th>
<%
if (tipo_raggruppamento.equals("1"))
{
	out.print("ASL");
}
else
{
	out.print("PIANO");
}
%>
</th>

<th ><center>Pianificati</center></th>
<th><center>Eseguiti</center> </th>
<th><center>(%Cu Svolti)</center> </th>
<th ><center>Pianificati</center> </th>
<th><center>Eseguiti </center> </th>
<th><center>(%Campioni Svolti)</center> </th>
</tr>

<%



LookupList ListaAsl =(LookupList)request.getAttribute("ListaAsl");

if (tipo_raggruppamento.equals("1"))
{
	ArrayList<OiaNodo> aslCoinvolte = (ArrayList<OiaNodo>)request.getAttribute("LavoroSvolto");
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
	<a  href="Monitoraggio.do?command=DettaglioAsl&searchenabled=<%=includiDisabilitatiBool %>&idNodo=<%=aslCoinvolta.getId() %>&data1=<%=data_1 %>&data2=<%=data_2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 600, height:700,creditsPosition: 'bottom left', headingText: 'REPORT ASL<%=aslCoinvolta.getDescrizione_lunga() %>',
					wrapperClassName: 'titlebar' } )">
					<%=(aslCoinvolta.getN_livello()==1) ? SiteIdList.getSelectedValue(aslCoinvolta.getId_asl()) : aslCoinvolta.getDescrizione_lunga() %>
					</a>
	
	
	</td>
		
		<td ><%= (aslCoinvolta.getCuPianificati()<0)? "Non Pianificati" : aslCoinvolta.getCuPianificati() + "" %></td>
		<td ><%=aslCoinvolta.getCuEseguiti() %></td>
		<td><%="<center>"+""+(((aslCoinvolta.getCuPianificati()<0)? "N.D" :(aslCoinvolta.getCampioniPianificati()!=0.0)? Math.round(((double)aslCoinvolta.getCuEseguiti()/(double)aslCoinvolta.getCuPianificati())*100):"0")) + "</center>" %></td>
		<td ><%= (aslCoinvolta.getCampioniPianificati()<0)? "Non Pianificati" : aslCoinvolta.getCampioniPianificati() + "" %></td>
		<td ><%=aslCoinvolta.getCampioniEseguiti()%>
	
		<td><%="<center>"+""+(((aslCoinvolta.getCampioniPianificati()<0)? "N.D" :(aslCoinvolta.getCampioniPianificati()!=0.0)? Math.round(((double)aslCoinvolta.getCampioniEseguiti()/(double)aslCoinvolta.getCampioniPianificati())*100):"0")) + "</center>" %></td>
		
		</tr>

	
	<tr align="center"  id ="sotto_riga_<%= aslCoinvolta.getId() %>" style="display: none">
							<td colspan="7">
								<table cellpadding="9" cellspacing="0" width="100%" style="padding-left: 50px" >
								
								<tr><th colspan="2">&nbsp;</th>
								<th colspan="3"><center>Numero CU</center> </th>
<th colspan="3"><center>Numero Campioni</center> </th></tr>
								<%-- Intestazione --%>
								<tr align="center"  style="background-color: #FFCB98;">
									
	<th>&nbsp;</th>
	<th>&nbsp;</th>
<th ><center>Pianificati</center></th>
<th><center>Eseguiti</center> </th>
<th><center>(%Cu Svolti)</center> </th>
<th ><center>Pianificati</center> </th>
<th><center>Eseguiti </center> </th>
<th><center>(%Campioni Svolti)</center> </th>
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
<a  href="Monitoraggio.do?command=DettaglioAsl&searchenabled=<%=includiDisabilitatiBool %>&idNodo=<%=aslFiglia.getId() %>&data1=<%=data_1 %>&data2=<%=data_2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 600, height:700,creditsPosition: 'bottom left', headingText: 'REPORT ASL<%=aslFiglia.getDescrizione_lunga() %>',
					wrapperClassName: 'titlebar' } )">
					<%=(aslFiglia.getN_livello()==1) ? SiteIdList.getSelectedValue(aslFiglia.getId_asl()) : aslFiglia.getDescrizione_lunga() %>
					</a>	</td>
		
		<td ><%= (aslFiglia.getCuPianificati()<0)? "Non Pianificati" : aslFiglia.getCuPianificati() + "" %></td>
		<td ><%=aslFiglia.getCuEseguiti() %></td>
		<td><%="<center>"+""+(((aslFiglia.getCuPianificati()<0)? "N.D" :(aslFiglia.getCampioniPianificati()!=0.0)? Math.round(((double)aslFiglia.getCuEseguiti()/(double)aslFiglia.getCuPianificati())*100):"0")) + "</center>" %></td>
		<td ><%= (aslFiglia.getCampioniPianificati()<0)? "Non Pianificati" : aslFiglia.getCampioniPianificati() + "" %></td>
		<td ><%=aslFiglia.getCampioniEseguiti()%>
	
		<td><%="<center>"+""+(((aslFiglia.getCampioniPianificati()<0)? "N.D" :(aslFiglia.getCampioniPianificati()!=0.0)? Math.round(((double)aslFiglia.getCampioniEseguiti()/(double)aslFiglia.getCampioniPianificati())*100):"0")) + "</center>" %></td>
		
		</tr>
				
				<tr align="center"  id ="sotto_riga_<%= aslCoinvolta.getId() %>_<%= aslFiglia.getId() %>" style="display: none">
											<td colspan="7">
												<table cellpadding="9" cellspacing="0" width="100%" style="padding-left: 100px" >
													
													<tr><th colspan="2">&nbsp;</th>
								<th colspan="3"><center>Numero CU</center> </th>
<th colspan="3"><center>Numero Campioni</center> </th></tr>
													<tr align="center"  style="background-color: #FFE5CC;">

	<th>&nbsp;</th><th>&nbsp;</th>
<th ><center>Pianificati</center></th>
<th><center>Eseguiti</center> </th>
<th><center>(%Cu Svolti)</center> </th>
<th ><center>Pianificati</center> </th>
<th><center>Eseguiti </center> </th>
<th><center>(%Campioni Svolti)</center> </th>
	</tr>
				
				<%
				
					for(OiaNodo aslNipote : aslFiglia.getLista_nodi() )
					{
						%>
						<tr align="center"  id ="riga_<%= aslCoinvolta.getId() %>_<%= aslFiglia.getId() %>_<%= aslNipote.getId() %>" style="background-color: #FFE5CC;">
															<td><img src="images/box.gif" border=0></td>
							<td >
<a  href="Monitoraggio.do?command=DettaglioAsl&searchenabled=<%=includiDisabilitatiBool %>&idNodo=<%=aslNipote.getId() %>&data1=<%=data_1 %>&data2=<%=data_2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 600, height:700,creditsPosition: 'bottom left', headingText: 'REPORT ASL<%=aslNipote.getDescrizione_lunga() %>',
					wrapperClassName: 'titlebar' } )">
					<%=(aslNipote.getN_livello()==1) ? SiteIdList.getSelectedValue(aslNipote.getId_asl()) : aslNipote.getDescrizione_lunga() %>
					</a>	</td>
		
		<td ><%= (aslNipote.getCuPianificati()<0)? "Non Pianificati" : aslNipote.getCuPianificati() + "" %></td>
		<td ><%=aslNipote.getCuEseguiti() %></td>
		<td><%="<center>"+""+(((aslNipote.getCuPianificati()<0)? "N.D" :(aslNipote.getCampioniPianificati()!=0.0)? Math.round(((double)aslNipote.getCuEseguiti()/(double)aslNipote.getCuPianificati())*100):"0")) + "</center>" %></td>
		<td ><%= (aslNipote.getCampioniPianificati()<0)? "Non Pianificati" : aslNipote.getCampioniPianificati() + "" %></td>
		<td ><%=aslNipote.getCampioniEseguiti()%>
	
		<td><%="<center>"+""+(((aslNipote.getCampioniPianificati()<0)? "N.D" :(aslNipote.getCampioniPianificati()!=0.0)? Math.round(((double)aslNipote.getCampioniEseguiti()/(double)aslNipote.getCampioniPianificati())*100):"0")) + "</center>" %></td>
		
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
		<a  href="Monitoraggio.do?command=DettaglioAsl&searchenabled=<%=includiDisabilitatiBool %>&idNodo=<%=aslFiglia.getId() %>&data1=<%=data_1 %>&data2=<%=data_2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 600, height:700,creditsPosition: 'bottom left', headingText: 'REPORT ASL<%=aslFiglia.getDescrizione_lunga() %>',
					wrapperClassName: 'titlebar' } )">
					<%=(aslFiglia.getN_livello()==1) ? SiteIdList.getSelectedValue(aslFiglia.getId_asl()) : aslFiglia.getDescrizione_lunga() %>
					</a>	</td>
		
		<td ><%= (aslFiglia.getCuPianificati()<0)? "Non Pianificati" : aslFiglia.getCuPianificati() + "" %></td>
		<td ><%=aslFiglia.getCuEseguiti() %></td>
		<td><%="<center>"+""+(((aslFiglia.getCuPianificati()<0)? "N.D" :(aslFiglia.getCampioniPianificati()!=0.0)? Math.round(((double)aslFiglia.getCuEseguiti()/(double)aslFiglia.getCuPianificati())*100):"0")) + "</center>" %></td>
		<td ><%= (aslFiglia.getCampioniPianificati()<0)? "Non Pianificati" : aslFiglia.getCampioniPianificati() + "" %></td>
		<td ><%=aslFiglia.getCampioniEseguiti()%>
	
		<td><%="<center>"+""+(((aslFiglia.getCampioniPianificati()<0)? "N.D" :(aslFiglia.getCampioniPianificati()!=0.0)? Math.round(((double)aslFiglia.getCampioniEseguiti()/(double)aslFiglia.getCampioniPianificati())*100):"0")) + "</center>" %></td>
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
<a  href="Monitoraggio.do?command=DettaglioAsl&searchenabled=<%=includiDisabilitatiBool %>&idNodo=<%=aslCoinvolta.getId() %>&data1=<%=data_1 %>&data2=<%=data_2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 600, height:700,creditsPosition: 'bottom left', headingText: 'REPORT ASL<%=aslCoinvolta.getDescrizione_lunga() %>',
					wrapperClassName: 'titlebar' } )">
					<%=SiteIdList.getSelectedValue(aslCoinvolta.getId_asl()) %>
					</a>	</td>
		
		<td ><%= (aslCoinvolta.getCuPianificati()<0)? "Non Pianificati" : aslCoinvolta.getCuPianificati() + "" %></td>
		<td >
		<a href="Monitoraggio.do?command=DettaglioProgrammazioni&asl=<%=aslCoinvolta.getId_asl() %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 950, height:800,creditsPosition: 'bottom left', headingText: 'Lista Controlli Eseguiti',
			wrapperClassName: 'titlebar' } )">
		<%=aslCoinvolta.getCuEseguiti() %>
			</a>
			<br>
<a href="Monitoraggio.do?command=StampaDettaglioProgrammazioni&asl=<%=aslCoinvolta.getId_asl() %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu" >Esporta	</a>
		
		</td>
		<td><%="<center>"+""+(((aslCoinvolta.getCuPianificati()<0)? "N.D" :(aslCoinvolta.getCampioniPianificati()!=0.0)? Math.round(((double)aslCoinvolta.getCuEseguiti()/(double)aslCoinvolta.getCuPianificati())*100):"0")) + "</center>" %></td>
		<td ><%= (aslCoinvolta.getCampioniPianificati()<0)? "Non Pianificati" : aslCoinvolta.getCampioniPianificati() + "" %></td>
		<td >
		<a href="Monitoraggio.do?command=DettaglioCampioniProgrammazioni&asl=<%=aslCoinvolta.getId_asl() %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 950, height:800,creditsPosition: 'bottom left', headingText: 'Lista Campioni Eseguiti',
			wrapperClassName: 'titlebar' } )">
		<%=aslCoinvolta.getCampioniEseguiti()%>
			</a>
			<br>
<a href="Monitoraggio.do?command=StampaDettaglioCampioniProgrammazioni&asl=<%=aslCoinvolta.getId_asl() %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu" >Esporta	</a>

		
		
		</td>
	
		<td><%="<center>"+""+(((aslCoinvolta.getCampioniPianificati()<0)? "N.D" :(aslCoinvolta.getCampioniPianificati()!=0.0)? Math.round(((double)aslCoinvolta.getCampioniEseguiti()/(double)aslCoinvolta.getCampioniPianificati())*100):"0")) + "</center>" %></td>
		
	
		</tr>
	
			<%
			
		}
		
	
	%>
	
	
	
	<%
	
	
	} 
}
else // raggruppamento per piano
{
	ProgrammazioniCuList pculist = (ProgrammazioniCuList)request.getAttribute("LavoroSvoltoPiano");
	
	Iterator<ProgrammazioneCu> itProg = pculist.iterator() ;
	while (itProg.hasNext())
	{
		ProgrammazioneCu prog = itProg.next();
		
	
	
	%>
<tr align="center" id='rigaprima_<%= prog.getId()  %>' onmouseover="inRow(this)" onmouseout="outRow(<%= prog.getId() %>,this)" > 
							
<td>&nbsp;</td>							
	<td>	<a  href="Monitoraggio.do?command=DettaglioPiano&searchenabled=<%=includiDisabilitatiBool %>&idProgrammazione=<%=prog.getId() %>&data1=<%=data_1 %>&data2=<%=data_2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 600, height:700,creditsPosition: 'bottom left', headingText: 'REPORT Piano',wrapperClassName: 'titlebar' } )">
					<%=(prog.getIdpadrepiano()<0) ? ListaPiani.getSelectedValue(prog.getPiano_monitoraggio()) : ListaPiani.getSelectedValue(prog.getIdpadrepiano()) + "<br>" + ListaPiani.getSelectedValue(prog.getPiano_monitoraggio()) %>
					</a>
	</td>
	<td><%=prog.getCu_pianificati() %></td>
	<td>
	<a href="Monitoraggio.do?command=DettaglioProgrammazioni&piano=<%=prog.getPiano_monitoraggio() %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 950, height:800,creditsPosition: 'bottom left', headingText: 'Lista Controlli Eseguiti',
				wrapperClassName: 'titlebar' } )">
	<%=prog.getCu_eseguiti() %>
		</a>&nbsp;&nbsp;<br><br>
				<a href="Monitoraggio.do?command=StampaDettaglioProgrammazioni&piano=<%=prog.getPiano_monitoraggio() %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu">Esporta	</a>
	
	</td>

	<td><%="<center>"+""+(((prog.getCu_pianificati()<0)? "N.D" :(prog.getCu_pianificati()!=0.0)? Math.round(((double)prog.getCu_eseguiti()/(double)prog.getCu_pianificati())*100):"0")) + "</center>" %></td>
	<td><%=prog.getCampioni_pianificati() %></td>
	<td>
	<a href="Monitoraggio.do?command=DettaglioCampioniProgrammazioni&piano=<%=prog.getPiano_monitoraggio() %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 950, height:800,creditsPosition: 'bottom left', headingText: 'Lista Campioni Eseguiti',
				wrapperClassName: 'titlebar' } )">
	<%=prog.getCampioni_eseguiti() %>
		</a> &nbsp;&nbsp;<br><br>
				<a href="Monitoraggio.do?command=StampaDettaglioCampioniProgrammazioni&piano=<%=prog.getPiano_monitoraggio() %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu" >Esporta	</a>
	</td>
	<td><%="<center>"+""+(((prog.getCampioni_pianificati()<0)? "N.D" :(prog.getCampioni_pianificati()!=0.0)? Math.round(((double)prog.getCampioni_eseguiti()/(double)prog.getCampioni_pianificati())*100):"0")) + "</center>" %></td>
	
	</tr>
			
		<%
	
	}
	
	
}

%>
</table>			
		<%
if(!tipo_raggruppamento.equals("1"))
{
%>
<dhv:pagedListControl object="TicListInfoMonitoraggio" tdClass="row1"/>
<%} %>	
</CENTER>

<%
}
else // visualizzazzione piano monitoraggio per controlli in sorveglianza
{
	String durata 		= (String)request.getAttribute("Durata");
	String operatori	= (String)request.getAttribute("operatori");
	%>
	<table class = "details" width="100%">
	<tr>
	<th><center>ASL</center></th>
	<th title="Indica il numero di controlli ufficiali in sorveglianza la cui data prossimo controllo è compresa nel periodo selezionato"><center>CU Da Fare</center></th>
	<th title="Indica il numero di controlli in sorveglianza la cui data prossimo controllo è precedente al limite inferiore del periodo selezionato"><center>CU Scaduti</center></th>
	<th title="Indica il numero di controlli in sorveglianza la cui data di esecuzione è compresa nel periodo selezionato"><center>CU Eseguiti</center></th>
	</tr>
	
	<%
	LookupList ListaAsl =(LookupList)request.getAttribute("ListaAsl");

	if (ListaAsl!=null)
	{
	HashMap<Integer,Integer[]> cruscotto_sorveglianza = (HashMap<Integer,Integer[]>)request.getAttribute("CruscottoSorveglianza");
	Iterator<Integer> itKey = cruscotto_sorveglianza.keySet().iterator();
	for(int i = 0 ; i <ListaAsl.size() ; i++ )
	{
		LookupElement el = (LookupElement)ListaAsl.get(i);
		int id_key = el.getCode();
		int id_asl = id_key;
		if (id_asl != 16 && cruscotto_sorveglianza.containsKey(id_asl))
		{
			Integer[] cu = cruscotto_sorveglianza.get(id_asl);
			%>
			
			<tr><td >
			
		
			<%=SiteIdList.getSelectedValue(id_asl) %>
			
			
			
			</td>
			<td>
			<center>
			
			<%if (cu[0]>0)
			{
			%>
			<%=cu[0] %> &nbsp; 
			<a href="Monitoraggio.do?command=DettaglioSorveglianza&tipo_richiesta=1&operatori=<%=operatori %>&asl=<%=id_asl %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 850, height:800,creditsPosition: 'bottom left', headingText: 'CU in Sorveglianza Da Fare per asl : <%=SiteIdList.getSelectedValue(id_asl) %> <br>Indica il numero di controlli ufficiali in sorveglianza la cui data prossimo controllo è compresa nel periodo selezionato',
			wrapperClassName: 'titlebar' } )"> Apri	</a>
			&nbsp;
			<a href="Monitoraggio.do?command=ExportDettaglioSorveglianza&tipo_richiesta=1&operatori=<%=operatori %>&asl=<%=id_asl %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu"> <img src="images/Excel_icon.gif">	</a>
			<%}
			else
			{
				%>
				<%=cu[0]%>
				<%
			}
			%>
			</center>
			</td><td><center>
			<%if (cu[2]>0)
			{
			%>
			<%=cu[2]%> &nbsp;
			<a href="Monitoraggio.do?command=DettaglioSorveglianza&tipo_richiesta=3&operatori=<%=operatori %>&asl=<%=id_asl %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 950, height:800,creditsPosition: 'bottom left', headingText: 'CU in Sorveglianza Scaduti per asl : <%=SiteIdList.getSelectedValue(id_asl) %>.<br>Indica il numero di controlli in sorveglianza la cui data prossimo controllo è precedente al limite inferiore del periodo selezionato',
			wrapperClassName: 'titlebar' } )">Apri	</a>
			&nbsp;
			<a href="Monitoraggio.do?command=ExportDettaglioSorveglianza&tipo_richiesta=3&operatori=<%=operatori %>&asl=<%=id_asl %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu"><img src="images/Excel_icon.gif">	</a>
			<%}
			else
			{
				%>
				<%=cu[2]%>
				<%
			}
			%>
			</center>
			</td><td><center>
			<%if (cu[1]>0)
			{
			%>
			<%=cu[1]%> &nbsp;
			<a href="Monitoraggio.do?command=DettaglioSorveglianza&tipo_richiesta=2&operatori=<%=operatori %>&asl=<%=id_asl %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 850, height:800,creditsPosition: 'bottom left', headingText: 'CU in Sorveglianza Eseguiti per asl : <%=SiteIdList.getSelectedValue(id_asl) %><br>Indica il numero di controlli in sorveglianza la cui data di esecuzione è compresa nel periodo selezionato',
			wrapperClassName: 'titlebar' } )">Apri	</a>
					<a href="Monitoraggio.do?command=ExportDettaglioSorveglianza&tipo_richiesta=2&operatori=<%=operatori %>&asl=<%=id_asl %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu"><img src="images/Excel_icon.gif">	</a>
			&nbsp;
			<%}
			else
			{
				%>
				<%=cu[1]%>
				<%
			}
			%>
			
			</center></td></tr>
			
			<%
			}
	}
	
%>
	
</table>

<%
	}
}

%>