<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>

<%@page import="org.aspcfs.modules.oia.base.OiaNodo"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.aspcfs.modules.dpat.base.DpatStrumentoCalcoloNominativi"%>
<%@page import="org.aspcfs.modules.dpat.base.DpatStrumentoCalcoloNominativiList"%>
<%@page import="org.aspcfs.modules.dpat.base.DpatStrumentoCalcoloStruttureList"%>
<%@page import="org.aspcfs.modules.dpat.base.DpatStruttura"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>

<script type='text/javascript' src='TableLock.js'></script>
<%@ include file="../initPage.jsp" %>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session" />
<jsp:useBean id="DpatSDC" class="org.aspcfs.modules.dpat.base.DpatStrumentoCalcolo" scope="request"/>
<jsp:useBean id="Qualifica" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="lookupTipologia" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="dpat" class="org.aspcfs.modules.dpat.base.Dpat" scope="request"/>
<jsp:useBean id="lookupTipologia2" class="org.aspcfs.utils.web.LookupList" scope="request"/>


<script src="javascript/jquery-1.8.2.js"></script>
<script src="javascript/jquery-ui.js"></script>

<link rel="stylesheet" href="css/jquery-ui.css" />
	

<!--  SERVER DOCUMENTALE -->
 <%@ page import=" org.aspcfs.modules.util.imports.ApplicationProperties"%>
    <%@page import="java.net.InetAddress"%>
    <link rel="stylesheet" type="text/css" media="print" documentale_url="" href="css/dpat_print.css" />
<!--  SERVER DOCUMENTALE -->

<!-- INIT DOCUMENTALE -->
	<%@ include file="/gestione_documenti/initEncodingDocumentale.jsp" %>
<!-- FINE INIT DOCUMENTALE -->


<body onload="resizeGlobalItemsPane('hide');">

<div class="boxIdDocumento"></div> <div class="boxOrigineDocumento"><%@ include file="../../hostName.jsp" %></div>

<table width="100%" border="1" id = "mytable_t1"  style="border-collapse: collapse;table-layout:fixed;" >
<thead>
<tr style="background-color: red;height: 40px;" >
	<th colspan="12">ORGANIGRAMMA E STRUMENTI DI CALCOLO</th>

</tr>

<tr style="background-color: rgb(204,193,218) ">
<th class = "rowclass_t1">AMBITO</th>
	<th class = "rowclass_t1">STRUTTURA DI APPARTENENZA</th>
	<th class='colclass_t1' >NOMINATIVO</th>
	<th class='colclass_t1'>QUALIFICA</th>
	<th class='colclass_t1' >CARICO DI <br>LAVORO TEORICO <br>ANNUALE MINIMO<br> AD PERSONAM IN U.I.</th>
	<th class='colclass_t1'>FATTORI CHE INCIDONO SUL CARICO DI LAVORO MINIMO AD PERSONAM</th>
	<th class='colclass_t1'>PERCENTUALE <br>DI U.I.<br> DA SOTTRARRE (%)</th>
	<th class='colclass_t1'>CARICO DI<br>LAVORO EFFETTIVO<br> ANNUALE MINIMO<br> AD PERSONAM IN U.I.</th>
	
	<th class='colclass_t1'>CARICO DI <br>LAVORO ANNUALE<br> MINIMO TEORICO<br> DI STRUTTURA IN U.I.<br>(SUBTOTALE DEI CARICHI AD PERSONAM)</th>
	<th class='colclass_t1' width="350px;"><b>FATTORI CHE INCIDONO NEGATIVAMENTE SUL CARICO DI LAVORO MINIMO DI STRUTTURA</b>
		<font size="1.8" ><i>
		
		</i></font>
	</th>
	<th class='colclass_t1'>PERCENTUALE DI U.I.  DA SOTTRARRE (%)</th>
	<th class='colclass_t1'>CARICO DI <br>LAVORO EFFETTIVO<br> ANNUALE MINIMO <br>DI STRUTTURA IN U.I.</th>
</tr>

</thead>

<%
DpatStrumentoCalcoloStruttureList listStrutture =  DpatSDC.getListaStrutture();


OiaNodo strutturaAmbito = null ;
int rowspan = listStrutture.size()-1;
for (int k = 0 ; k <listStrutture.size();k++)
{
	OiaNodo strutturaTmp = (OiaNodo)listStrutture.get(k);
	if (strutturaTmp.getTipologia_struttura()!=13)
	{
		rowspan+=strutturaTmp.getListaNominativi().size();
	}
	else
	{
		strutturaAmbito = strutturaTmp;
	}
}



int rowid = 0 ;
Qualifica.setSelectStyle("style=\"width: 100%;heigh:100%;\"");
if (listStrutture.size()>0)
{
for (int i = 0 ; i < listStrutture.size(); i++)
{
	rowid = (rowid != 1 ? 1 : 2);
	OiaNodo struttura = (OiaNodo)listStrutture.get(i);
	DpatStrumentoCalcoloNominativiList listaNominativiStruttura = struttura.getListaNominativi();
	
	%>
	<tbody id="div_struttura_<%=struttura.getId()%>"  class="row<%= rowid %>">
	
		<% 
		if(listaNominativiStruttura.size()>0)
		{
			%>
			
			<%
			for (int j = 0 ; j < listaNominativiStruttura.size(); j++)
			{
				DpatStrumentoCalcoloNominativi nominativo = (DpatStrumentoCalcoloNominativi)listaNominativiStruttura.get(j);
				String color = "";
				if (struttura.getN_livello()==2){
					if (struttura.getTipologia_struttura()==15){
						color="#A6FBB2";
					} else{
						color="#FFFF00";
					}
				}
				else{
					color="#FFFFFF";
				}
		
		%>
		
		
		<tr class = "rowclass_t1">
		<td><%=DpatSDC.getStrutturaAmbito().getDescrizioneAreaStruttureComplesse() %></td>
		<td bgcolor="<%=color%>" align="center">
		<%="<b>" + struttura.getDescrizione_lunga().toUpperCase()+"</b><BR><BR><BR><b>TIPOLOGIA</b> "+lookupTipologia2.getSelectedValue(struttura.getTipologia_struttura())+"" %>
		</td>
						
				<td align="center" style="font-weight: bold">
					<%=(nominativo.getNominativo().getContact().getNameLast() + nominativo.getNominativo().getContact().getNameFirst()).toUpperCase() %>
						</td>
					
					<td align="center" style="font-weight: bold"><%=Qualifica.getSelectedValue(nominativo.getIdLookupQualifica()).toUpperCase() %></td>
					<td align="center" style="font-weight: bold"><%=nominativo.getCaricoLavoroAnnuale() %></td>
					<td align="center" style="font-weight: bold"><%=fixEncoding(nominativo.getFattoriIncidentiSuCarico()) %></td>
					<td align="center" style="font-weight: bold"><%=(nominativo.getPercentualeDaSottrarre()>70 || nominativo.getSomma_parziale()>70) ?"<font color='black'>"+nominativo.getPercentualeDaSottrarre()+"</font>" :nominativo.getPercentualeDaSottrarre()+""%></td>
					<td align="center" style="font-weight: bold"><%=nominativo.getCaricoEffettivoAnnuale() %></td>
					<td style="font-weight: bold" align="center"><%=struttura.getCaricoLavoroAnnuo() %></td>
					<td style="font-weight: bold" align="center"><%=fixEncoding(struttura.getFattoriIncidentiSuCarico()) %></td>
					<td style="font-weight: bold" align="center"><%=struttura.getPercentualeDaSottrarre()%></td>
					<td style="font-weight: bold" align="center"><%=struttura.getCaricoLavoroEffettivo() %></td>
	
		
				</tr>
				
		<%
			}
		}
		else{
			%>
		<tr>
		
		<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			</tr>
		
		<%
		}
}
		
		%>
		
		</tbody>
		

	
	<%
}

%>

</tbody>

</table>
 

</body>

