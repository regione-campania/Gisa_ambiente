
<%@page import="java.util.ArrayList"%>
<%@page import="org.aspcfs.modules.programmazzionecu.base.SorveglianzaDettaglio"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<jsp:useBean id="MonitoraggioSorveglianzaInfo" class="org.aspcfs.utils.web.PagedListInfo" scope="session"/>
<jsp:useBean id="ListaCU" class="org.aspcfs.modules.programmazzionecu.base.SorveglianzaDettaglioList" scope="request"/>
<br><br>
<%@ include file="../initPage.jsp" %>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/spanDisplay.js"></SCRIPT>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/confirmDelete.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popURL.js"></script>
<script type="text/javascript" src="highslide/highslide-full.js"></script>
<script type="text/javascript" src="highslide/highslide.config.js" charset="utf-8"></script>
<link rel="stylesheet" type="text/css" href="highslide/highslide.css" />


<dhv:pagedListStatus title='<%= showError(request, "actionError") %>' object="MonitoraggioSorveglianzaInfo"/>

<table class="pagedList" cellpadding="4" cellspacing="0" border="0" width="100%" >

<thead>
<tr>

<th>Tipo Operatore</th>		
<th>Ragione Socialeee</th>
<th>Linea Attivita</th>
<th>Codice Operatore</th>
<th>Comune S.O.</th>
<th>Indirizzo S.O.</th>
<%if((Integer)request.getAttribute("TipoReport") ==2)
	{
	%>
<th>Id Controllo</th>	
<th>Data Controllo</th>
<th>Prima della Scadenza</th>
	<%
	}
else
{
	%>
	<th>Prima Volta</th>	
		<%
}
	%>
<th>Prossimo CU</th>
<th>Categoria</th>

</tr>
</thead>
<tbody>
<%



Iterator it = ListaCU.iterator();
while (it.hasNext())
{
SorveglianzaDettaglio det = (SorveglianzaDettaglio) it.next();
%>


<tr>
<td > <%=toHtml(det.getTipo_operatore()) %></td>
<td> 
<%
if (det.getTipo_operatore().equalsIgnoreCase("allevamento"))
{
	%>
	<a  href="Allevamenti.do?command=Details&id=<%=det.getId_controllo()%>&orgId=<%=det.getOrgId()%>" onclick="return hs.htmlExpand(this, { objectType: 'iframe',  width: 850, height:800,creditsPosition: 'bottom left', headingText:'',wrapperClassName: 'titlebar' } )" >
	<%=  toHtml(det.getRagione_sociale()) %>
	</a> 
	<%
}
else
{

%>

<%=  toHtml(det.getRagione_sociale()) %>
<%} %>
</td>
<td> <%=((det.getLinea_attivita()!=null && ! det.getLinea_attivita().equals("")) ? ((det.getLinea_attivita().length()>20) ? toHtml(det.getLinea_attivita().substring(0,20)) : toHtml(det.getLinea_attivita())) : "N.D") %></td>
<td> <%=toHtml(det.getCodice_osa()) %></td>
<td> <%=toHtml(det.getCitta()) %></td>
<td> <%=toHtml(det.getIndirizzo()) %></td>


<%if((Integer)request.getAttribute("TipoReport") ==2)
	{
	%>
<td><%=det.getId_controllo()%></td>
<td><%=det.getDatacontrollo()   %></td>
<td><%=(det.getStato().equals("1")) ? "NO" : "SI"   %></td>
	<%
	}
else
{
	%>
	<td><%=((det.getId_controllo().equals("") || det.getId_controllo().equals("0"))? "SI" : "NO")   %></td>
	
		
		<%
}
	%>

<td><%=det.getData_prossimo_controllo()  %></td>
<td><%=det.getCategoria_rischio()   %></td>


</tr>
<%	
}

%>
</tbody>

</table>
  <dhv:pagedListControl object="MonitoraggioSorveglianzaInfo"/>