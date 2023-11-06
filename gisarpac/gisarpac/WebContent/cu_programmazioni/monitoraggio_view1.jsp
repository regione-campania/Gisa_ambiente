<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.aspcfs.modules.login.beans.UserBean"%>
<%@page import="org.aspcfs.modules.admin.base.User"%>
<%@page import="org.aspcfs.utils.web.LookupList"%>
<%@page import="org.aspcfs.utils.web.LookupElement"%>

<jsp:useBean id="SiteIdList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
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
<a href = "javascript:viewGrafico()" id = "link"><b>View Campioni Monitoring</b></a>

<!-- grafico relativo ai cu -->
<div id = "grafico_cu">
<br><br>
<img src="images/report_cu_asl.png" width="1100" height="450" />
<br><br>
<br><br>
</div>

<!-- grafico relativo ai campioni -->
<div id = "grafico_campioni" style="display: none">
<br><br>
<img src="images/report_campioni_asl.png" width="1100" height="450" />
<br><br>
<br><br>
</div>

<CENTER>
<%
String tipo_raggruppamento = (String) request.getAttribute("TipoPiano");
HashMap<Integer,HashMap<Integer,Double[]>> lavoro_svolto = (HashMap<Integer,HashMap<Integer,Double[]>>)request.getAttribute("LavoroSvolto");

String 	data_1 	= (String)request.getAttribute("Data1");
String 	data_2 	= (String)request.getAttribute("Data2");
String durata 	= (String)request.getAttribute("Durata");
if (tipo_raggruppamento.equals("1")) // raggruppamento per asl
{
%>
<div class="us"style="">
	<%
	
	
		if (user.getSiteId()<=0) // visualizzazzione per utente regionale
		{
			LookupList ListaAsl =(LookupList)request.getAttribute("ListaAsl");
			for(int i = 0 ; i<ListaAsl.size();i++)
			{
				LookupElement el = (LookupElement) ListaAsl.get(i) ;
				if (el.getCode()!=16)
				{
%>
					<a class="us" href="Monitoraggio.do?command=DettaglioAsl&searchenabled=<%=includiDisabilitatiBool %>&asl=<%=el.getCode() %>&data1=<%=data_1 %>&data2=<%=data_2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 600, height:700,creditsPosition: 'bottom left', headingText: 'REPORT ASL<%=el.getDescription() %>',
					wrapperClassName: 'titlebar' } )">&nbsp;<%=el.getShort_description() %>&nbsp;</a>
					
<%	
				}
			}
			%>
			<br><br>
			<%
	for(int i = 0 ; i<ListaAsl.size();i++)
	{
		LookupElement el = (LookupElement) ListaAsl.get(i) ;
		if (el.getCode()!=16)
		{
%>
			
			<a  href="Monitoraggio.do?command=StampaDettaglioAsl&searchenabled=<%=includiDisabilitatiBool %>&asl=<%=el.getCode() %>&data1=<%=data_1 %>&data2=<%=data_2 %>&durata=<%=durata %>&tipo=eu">Esporta<%=el.getShort_description() %>&nbsp;</a>
<%	
		}
	}
		}
		else  // visualizzazzione per utente asl
		{
%>
			<a class="us" href="Monitoraggio.do?command=DettaglioAsl&searchenabled=<%=includiDisabilitatiBool %>&asl=<%=user.getSiteId() %>&data1=<%=data_1 %>&data2=<%=data_2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 600, height:700,creditsPosition: 'bottom left', headingText: 'REPORT ASL <%=SiteIdList.getSelectedValue(user.getSiteId()) %>',
			wrapperClassName: 'titlebar' } )"> <%="&nbsp;"+SiteIdList.getSelectedValue(user.getSiteId()) + "&nbsp;" %> </a>
			<br><br>
						<a  href="Monitoraggio.do?command=StampaDettaglioAsl&searchenabled=<%=includiDisabilitatiBool %>&asl=<%=user.getSiteId()  %>&data1=<%=data_1 %>&data2=<%=data_2 %>&durata=<%=durata %>&tipo=eu">Esporta &nbsp;</a>
			
			
<%
		}
		%>
			
<br><br>
</div>
<%} %>
<br>

<!-- tabella riepilogativa dei controlli e cmapioni eseguiti da ogni asl -->

<table class="details" width="100%">
<tr>
<%
if (!tipo_raggruppamento.equals("1"))
{
	%>
	<th>
	<%out.print("CODICE PIANO");%>
	
	</th>
<%}%>
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





<th colspan="3"><center>Numero CU</center> </th>
<th colspan="3"><center>Numero Campioni</center> </th>
</tr>

<tr>
<%
if (!tipo_raggruppamento.equals("1"))
{
%>
<th>&nbsp;</th>
<%	
}%>

<th>&nbsp;</th>
<th ><center>Pianificati</center></th>
<th><center>Eseguiti</center> </th>
<th><center>(%Cu Svolti)</center> </th>
<th ><center>Pianificati</center> </th>
<th><center>Eseguiti </center> </th>
<th><center>(%Campioni Svolti)</center> </th>
</tr>

<%
HashMap<Integer,Double[]> lavoro_cu = lavoro_svolto.get(1);
HashMap<Integer,Double[]> lavoro_cam = lavoro_svolto.get(2);
if (tipo_raggruppamento.equals("1") ) // nel caso di raggruppamento per asl elimino
									 //dalla lista del lavoro eseguito il record con chiave asl fuori regione
{
	if(lavoro_cu.containsKey(16))
	{
		lavoro_cu.remove(16);
	}
	if(lavoro_cam.containsKey(16))
	{
	lavoro_cam.remove(16);
	}
}

Iterator<Integer> itKey =lavoro_cu.keySet().iterator();
if (user.getSiteId()<=0) //visualizzazzione riepilogo per utente regionale
{
LookupList ListaAsl =(LookupList)request.getAttribute("ListaAsl");

if (tipo_raggruppamento.equals("1"))
{
for(int i = 0 ; i <ListaAsl.size() ; i++ )
{
	LookupElement el = (LookupElement)ListaAsl.get(i);
	int id_key = el.getCode();
	if(id_key!=16)
	{
	
%>
<tr>
<td >
<%
String parametro = "" ;
	parametro = "&asl="+id_key;
	out.print("<center>"+((String)SiteIdList.getSelectedValue(id_key)).toUpperCase()+"</center>");

%>
</td>

<td><%="<center>"+""+(( lavoro_cu.containsKey(id_key) && lavoro_cu.get(id_key)[0]==0 )? "Non Pianificato" : ((lavoro_cu.containsKey(id_key))?(int)Math.round(lavoro_cu.get(id_key)[0]) : "") ) + "</center>" %></td>
<td><%="<center>"+""+ ((lavoro_cu.containsKey(id_key)) ? Math.round(lavoro_cu.get(id_key)[1]) : "")+ "</center>" %> &nbsp;
<a href="Monitoraggio.do?command=DettaglioProgrammazioni<%=parametro %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 950, height:800,creditsPosition: 'bottom left', headingText: 'Lista Controlli Eseguiti',
			wrapperClassName: 'titlebar' } )">Apri	</a>
			<br>
<a href="Monitoraggio.do?command=StampaDettaglioProgrammazioni<%=parametro %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu" >Esporta	</a>

</td>
<td><%="<center>"+""+(((lavoro_cu.containsKey(id_key) && lavoro_cu.get(id_key)[0]<=0)? "N.D" :(lavoro_cu.containsKey(id_key) && lavoro_cu.get(id_key)[0]!=0.0)? Math.round((lavoro_cu.get(id_key)[1]/lavoro_cu.get(id_key)[0])*100):"0")) + "</center>" %></td>

<td><%="<center>"+""+((lavoro_cam.containsKey(id_key) && lavoro_cam.get(id_key)[0]<=0)? "Non Pianificato" : ((lavoro_cam.containsKey(id_key)) ? Math.round(lavoro_cam.get(id_key)[0]): "") ) + "</center>" %></td>
<td><%="<center>"+""+((lavoro_cam.containsKey(id_key)) ? Math.round(lavoro_cam.get(id_key)[1]) : "" ) + "</center>" %> &nbsp;
<a href="Monitoraggio.do?command=DettaglioCampioniProgrammazioni<%=parametro %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 950, height:800,creditsPosition: 'bottom left', headingText: 'Lista Campioni Eseguiti',
			wrapperClassName: 'titlebar' } )">Apri	</a>
			<br>
<a href="Monitoraggio.do?command=StampaDettaglioCampioniProgrammazioni<%=parametro %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu" >Esporta	</a>


</td>
<td><%="<center>"+""+(((lavoro_cam.containsKey(id_key) && lavoro_cam.get(id_key)[0]<=0)? "N.D" :(lavoro_cam.containsKey(id_key) && lavoro_cam.get(id_key)[0]!=0.0) ? Math.round(( lavoro_cam.get(id_key)[1]/lavoro_cam.get(id_key)[0])*100)+"" : "0")) + "</center>" %></td>
</tr>
<%}}
}
else
{ // raggruppamento per piano
	for(int i = 0 ; i <ListaPiani.size() ; i++ )
	{
		LookupElement el = (LookupElement)ListaPiani.get(i);
		int id_key = el.getCode();
		if(lavoro_cu.containsKey(id_key))
		{
	%>
	<tr>
	
	<%
if (!tipo_raggruppamento.equals("1"))
{
	%>
	<td>
	<%out.print(""+id_key);%>
	
	</td>
<%}%>
	<td>
	<%
		String parametro = "" ;
		parametro = "&piano="+id_key;
		
		%>
		<a  href="Monitoraggio.do?command=DettaglioPiano&piano=<%=id_key %>&data1=<%=data_1 %>&searchenabled=<%=includiDisabilitatiBool %>&data2=<%=data_2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 600, height:700,creditsPosition: 'bottom left', headingText: 'REPORT PIANO : <%=(String)ListaPiani.getSelectedValue(id_key).replace("'","") %>',
			wrapperClassName: 'titlebar' } )"> <%=(String)ListaPiani.getSelectedValue(id_key).toUpperCase() %></a><br><br>
			<a   href="Monitoraggio.do?command=StampaDettaglioPiano&piano=<%=id_key %>&data1=<%=data_1 %>&searchenabled=<%=includiDisabilitatiBool %>&data2=<%=data_2 %>&durata=<%=durata %>&tipo=eu" >Esporta</a>
	</td>
	
	<td><%="<center>"+""+((lavoro_cu.get(id_key)[0]<=0)? "Non Pianificato" :(int)Math.round(lavoro_cu.get(id_key)[0])) + "</center>" %></td>
	<td><%="<center>"+""+Math.round(lavoro_cu.get(id_key)[1]) + "</center>" %> &nbsp;
	<a href="Monitoraggio.do?command=DettaglioProgrammazioni<%=parametro %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 950, height:800,creditsPosition: 'bottom left', headingText: 'Lista Controlli Eseguiti',
				wrapperClassName: 'titlebar' } )">Apri	</a>&nbsp;&nbsp;<br><br>
				<a href="Monitoraggio.do?command=StampaDettaglioProgrammazioni<%=parametro %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu">Esporta	</a>

	</td>
	<td><%="<center>"+""+((lavoro_cu.get(id_key)[0]!=0.0)? Math.round((lavoro_cu.get(id_key)[1]/lavoro_cu.get(id_key)[0])*100):"0") + "</center>" %></td>

	<td><%="<center>"+""+((lavoro_cam.get(id_key)[0]<=0) ? "Non Pianificato" :Math.round(lavoro_cam.get(id_key)[0])) + "</center>" %></td>
	<td><%="<center>"+""+Math.round(lavoro_cam.get(id_key)[1]) + "</center>" %> &nbsp;
	<a href="Monitoraggio.do?command=DettaglioCampioniProgrammazioni<%=parametro %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 950, height:800,creditsPosition: 'bottom left', headingText: 'Lista Campioni Eseguiti',
				wrapperClassName: 'titlebar' } )">Apri	</a> &nbsp;&nbsp;<br><br>
				<a href="Monitoraggio.do?command=StampaDettaglioCampioniProgrammazioni<%=parametro %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu" >Esporta	</a>


	</td>
	<td><%="<center>"+""+((lavoro_cam.get(id_key)[0]!=0.0) ? Math.round(( lavoro_cam.get(id_key)[1]/lavoro_cam.get(id_key)[0])*100)+"" : "N.D") + "</center>" %></td>
	</tr>
	<%}}
	
}
}
else //visualizzazzione riepilogo per utente asl
{
%>
<tr>

<%
String parametro = "" ;
if (tipo_raggruppamento.equals("1") ) // se si tratta di raggruppamento per asl
{
	parametro = "&asl="+user.getSiteId();
	out.print("<td ><center>"+((String)SiteIdList.getSelectedValue(user.getSiteId())).toUpperCase()+"</center></td>");
	%>
	
		<td><%="<center>"+""+Math.round(lavoro_cu.get(user.getSiteId())[0]) + "</center>" %></td>
		<td><%="<center>"+""+Math.round(lavoro_cu.get(user.getSiteId())[1]) + "</center>" %> &nbsp;
		
		<a href="Monitoraggio.do?command=DettaglioProgrammazioni<%=parametro %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 950, height:800,creditsPosition: 'bottom left', headingText: 'Lista Controlli Eseguiti',
			wrapperClassName: 'titlebar' } )">Apri	</a>
			<br><br>
			<a href="Monitoraggio.do?command=StampaDettaglioProgrammazioni<%=parametro %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu" >Esporta	</a>
		
		</td>
		
		<td><%="<center>"+""+((lavoro_cu.get(user.getSiteId())[0]!=0.0)? Math.round((lavoro_cu.get(user.getSiteId())[1]/lavoro_cu.get(user.getSiteId())[0])*100):"0") + "</center>" %></td>
		
		<td><%="<center>"+""+Math.round(lavoro_cam.get(user.getSiteId())[0]) + "</center>" %> &nbsp;</td>
		
		<td><%="<center>"+""+Math.round(lavoro_cam.get(user.getSiteId())[1]) + "</center>" %>
		<a href="Monitoraggio.do?command=DettaglioCampioniProgrammazioni<%=parametro %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 950, height:800,creditsPosition: 'bottom left', headingText: 'Lista Campioni Eseguiti',
			wrapperClassName: 'titlebar' } )">Apri	</a>
			<br><br>
			<a href="Monitoraggio.do?command=StampaDettaglioCampioniProgrammazioni<%=parametro %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu" >Esporta	</a>
			
			
		</td>
		
		<td><%="<center>"+""+((lavoro_cam.get(user.getSiteId())[0]!=0.0) ? Math.round(( lavoro_cam.get(user.getSiteId())[1]/lavoro_cam.get(user.getSiteId())[0])*100)+"" : "0") + "</center>" %></td>

	<%
}
else // raggruppamento per piano
{
	//out.print("<td><center>"+(String)ListaPiani.getSelectedValue(user.getSiteId())+"</center></td>");
	while(itKey.hasNext())
	{
		int id_key = itKey.next();
		
	%>
	<tr>
	<td><%=id_key %></td>
	<td >
		<a  href="Monitoraggio.do?command=DettaglioPiano&piano=<%=id_key %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=data_1 %>&data2=<%=data_2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 600, height:700,creditsPosition: 'bottom left', headingText: 'REPORT PIANO : <%=(String)ListaPiani.getSelectedValue(id_key).replace("'","") %>',
			wrapperClassName: 'titlebar' } )"> <%=(String)ListaPiani.getSelectedValue(id_key).toUpperCase() %></a><br><br>
			
			<a  href="Monitoraggio.do?command=StampaDettaglioPiano&piano=<%=id_key %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=data_1 %>&data2=<%=data_2 %>&durata=<%=durata %>&tipo=eu" > Esporta</a>
	
	</td>
	<td><%="<center>"+""+Math.round(lavoro_cu.get(id_key)[0]) + "</center>" %></td>
	<td><%="<center>"+""+Math.round(lavoro_cu.get(id_key)[1]) + "</center>" %> &nbsp;
		<a href="Monitoraggio.do?command=DettaglioProgrammazioni&piano=<%=id_key %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 950, height:800,creditsPosition: 'bottom left', headingText: 'Lista Controlli Eseguiti',
			wrapperClassName: 'titlebar' } )">Apri	</a>
			<br><br>
			<a href="Monitoraggio.do?command=StampaDettaglioProgrammazioni&piano=<%=id_key %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu" >Esporta	</a>
	
	</td>
	<td><%="<center>"+""+((lavoro_cu.get(id_key)[0]!=0.0)? Math.round((lavoro_cu.get(id_key)[1]/lavoro_cu.get(id_key)[0])*100):"0") + "</center>" %></td>
		
	<td><%="<center>"+""+Math.round(lavoro_cam.get(id_key)[0]) + "</center>" %></td>
	<td><%="<center>"+""+Math.round(lavoro_cam.get(id_key)[1]) + "</center>" %> &nbsp;
	<a href="Monitoraggio.do?command=DettaglioCampioniProgrammazioni&piano=<%=id_key %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 950, height:800,creditsPosition: 'bottom left', headingText: 'Lista Campioni Eseguiti',
			wrapperClassName: 'titlebar' } )">Apri	</a>
			<br><br>
			<a href="Monitoraggio.do?command=StampaDettaglioCampioniProgrammazioni&piano=<%=id_key %>&searchenabled=<%=includiDisabilitatiBool %>&data1=<%=Data1 %>&data2=<%=Data2 %>&durata=<%=durata %>&tipo=eu">Esporta	</a>
	</td>
	<td><%="<center>"+""+((lavoro_cam.get(id_key)[0]!=0.0) ? Math.round(( lavoro_cam.get(id_key)[1]/lavoro_cam.get(id_key)[0])*100)+"" : "0") + "</center>" %></td>
	
	
	</tr>
	<%}%>
	<%
}
%>
<%
}
%>

</table>			
			
</CENTER>

<%}
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

%>