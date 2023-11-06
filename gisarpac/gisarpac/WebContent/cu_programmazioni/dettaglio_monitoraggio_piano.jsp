
<%@page import="java.util.ArrayList"%>
<%@page import="org.aspcfs.modules.programmazzionecu.base.PianoAsl"%>
<%@page import="org.aspcfs.utils.web.LookupElement"%>
<%@page import="org.aspcfs.modules.programmazzionecu.base.ProgrammazioneCu"%>
<%@page import="org.aspcfs.modules.oia.base.OiaNodo"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Hashtable"%><br>
<jsp:useBean id="ListaPianiLookup" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="SiteIdList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
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
<br><br>
<table class="details" width="100%">
<tr>
<th>&nbsp;</th>
<th>ASL</th>
<th colspan="2"> CU </th>
<th colspan="2"> CAMPIONI </th>		
</tr>
<tr>
<th>&nbsp;</th>
<th>&nbsp;</th>
<th>PIANIFICATI</th>
<th>ESEGUITI</th>		
<th>PIANIFICATI</th>
<th>ESEGUITI</th>	
</tr> 

<%
ProgrammazioneCu lista = (ProgrammazioneCu) request.getAttribute("ListaPiani");
Hashtable<String,ArrayList<OiaNodo>> listaAsl = lista.getAsl_coinvolte() ;
Iterator<String> itKe = lista.getAsl_coinvolte().keySet().iterator();

int rowid = 0;
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
		
		<td ><%= (aslCoinvolta.getCuPianificati()<0)? "Non Pianificati" : aslCoinvolta.getCuPianificati() + "" %></td>
		<td ><%=aslCoinvolta.getCuEseguiti() %></td>
		<td ><%= (aslCoinvolta.getCampioniPianificati()<0)? "Non Pianificati" : aslCoinvolta.getCampioniPianificati() + "" %></td>
		
		<td ><%=aslCoinvolta.getCampioniEseguiti()%>
		</tr>

	
	<tr align="center"  id ="sotto_riga_<%= aslCoinvolta.getId() %>" style="display: none">
							<td colspan="7">
								<table cellpadding="9" cellspacing="0" width="100%" style="padding-left: 50px" >
								
								<%-- Intestazione --%>
								<tr align="center"  style="background-color: #FFE4C4;">
									
	<tr>
<th>&nbsp;</th>
<th>ASL</th>
<th colspan="2"> CU </th>
<th colspan="2"> CAMPIONI </th>		
</tr>
<tr>
<th>&nbsp;</th>
<th>&nbsp;</th>
<th>PIANIFICATI</th>
<th>ESEGUITI</th>		
<th>PIANIFICATI</th>
<th>ESEGUITI</th>	
</tr> 

	<%
		
			for(OiaNodo aslFiglia : aslCoinvolta.getLista_nodi() )
			{
				if(aslFiglia.getLista_nodi().size()>0)
				{
				%>
				<tr align="center"  id ="riga_<%= aslFiglia.getId() %>_<%= aslFiglia.getId() %>" style="background-color: #FFE4C4;" >
											
											
											 <td onclick="switch_elemento_albero('img_riga_<%= aslFiglia.getId() %>_<%= aslFiglia.getId() %>','sotto_riga_<%= aslCoinvolta.getId() %>_<%= aslFiglia.getId() %>')" >
												<img id="img_riga_<%= aslFiglia.getId() %>_<%= aslFiglia.getId() %>" src="images/tree0.gif" border=0>
											</td>
				<td >
				<%=aslFiglia.getDescrizione_lunga() %>
				</td>
				<td ><%= (aslFiglia.getCuPianificati()<0)? "Non Pianificati" : aslFiglia.getCuPianificati() + "" %></td>
					<td ><%=aslFiglia.getCuEseguiti() %></td>
		<td ><%= (aslFiglia.getCampioniPianificati()<0)? "Non Pianificati" : aslFiglia.getCampioniPianificati() + "" %></td>
	
		<td ><%=aslFiglia.getCampioniEseguiti()%>
			</tr>
				
				<tr align="center"  id ="sotto_riga_<%= aslCoinvolta.getId() %>_<%= aslFiglia.getId() %>" style="display: none">
											<td colspan="7">
												<table cellpadding="9" cellspacing="0" width="100%" style="padding-left: 100px" >
													<tr align="center"  style="background-color: #99FF00;">


<th>&nbsp;</th>
<th>ASL</th>
<th colspan="2"> CU </th>
<th colspan="2"> CAMPIONI </th>		
</tr>
<tr>
<th>&nbsp;</th>
<th>&nbsp;</th>
<th>PIANIFICATI</th>
<th>ESEGUITI</th>		
<th>PIANIFICATI</th>
<th>ESEGUITI</th>	
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
		<td ><%= (aslNipote.getCuPianificati()<0)? "Non Pianificati" : aslNipote.getCuPianificati() + "" %></td>
		<td ><%=aslNipote.getCuEseguiti() %></td>
				<td ><%= (aslNipote.getCampioniPianificati()<0)? "Non Pianificati" : aslNipote.getCampioniPianificati() + "" %></td>
		
		<td ><%=aslNipote.getCampioniEseguiti()%>
		</tr>	<%
					
				
				
				}%></table>
											</td>
										</tr>
				<%
			}
				else
				{
					%>
					<tr align="center"  id ="riga_<%= aslCoinvolta.getId() %>_<%= aslFiglia.getId() %>" style="background-color: #FFE4C4;">
											<td><img src="images/box.gif" border=0></td>
					<td >
						<%=aslFiglia.getDescrizione_lunga() %>
						</td>						
				<td ><%= (aslFiglia.getCuPianificati()<0)? "Non Pianificati" : aslFiglia.getCuPianificati() + "" %></td>
		<td ><%=aslFiglia.getCuEseguiti() %></td>
				<td ><%= (aslFiglia.getCampioniPianificati()<0)? "Non Pianificati" : aslFiglia.getCampioniPianificati() + "" %></td>
		
		<td ><%=aslFiglia.getCampioniEseguiti()%>
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
		<td ><%= (aslCoinvolta.getCuPianificati()<0)? "Non Pianificati" : aslCoinvolta.getCuPianificati() + "" %></td>
		<td ><%=aslCoinvolta.getCuEseguiti() %></td>
				<td ><%= (aslCoinvolta.getCampioniPianificati()<0)? "Non Pianificati" : aslCoinvolta.getCampioniPianificati() + "" %></td>
		
		<td ><%=aslCoinvolta.getCampioniEseguiti()%></td>
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