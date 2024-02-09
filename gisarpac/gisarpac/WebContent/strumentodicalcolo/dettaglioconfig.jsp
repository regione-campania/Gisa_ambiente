<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>

<%@page import="org.aspcfs.modules.oia.base.OiaNodo"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.aspcfs.modules.dpat.base.DpatStrumentoCalcoloNominativi"%>
<%@page import="org.aspcfs.modules.dpat.base.DpatStrumentoCalcoloNominativiList"%>
<%@page import="org.aspcfs.modules.dpat.base.DpatStrumentoCalcoloStruttureList"%>
<%@page import="org.aspcfs.modules.dpat.base.DpatStrumentoCalcoloStruttura"%>
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
    <link rel="stylesheet" type="text/css" media="print" href="http://<%=InetAddress.getByName("APP_HOST_GISA_PUBBLICA").getHostAddress()%><%=ApplicationProperties.getProperty("APP_PORTA_GISA")%>/<%=ApplicationProperties.getProperty("APP_NAME_GISA")%>/css/dpat_print_timbro.css" />
<!--  SERVER DOCUMENTALE -->


<iframe src="empty.html" name="server_commands" id="server_commands" style="visibility:hidden" height="0"></iframe>

<body onload="resizeGlobalItemsPane('hide');">

<table class="trails" cellspacing="0" >
		<tr>	
			<td width="100%"><div align="left"><a href="Dpat.do">DPAT</a> &gt <a href="Dpat.do?command=Home&idAsl=<%=DpatSDC.getIdAsl()%>&anno=<%=DpatSDC.getAnno()%>">Allegati DPAT</a> &gt All. 5 Strumento di Calcolo <%=DpatSDC.getAnno() %></div></td>
		</tr>
	</table>
	 
<dhv:permission name="dpatSDCConfigPropaga-view">
<%if (DpatSDC.isPropagato()!=true){ %>
<input type="button" id="propaga" 
					name="propaga" value="Propaga" 
					style="background-color:#FF4D00; font-weight: bold;"  style="background-color:#FF4D00; font-weight: bold;"
					onclick="if (confirm('Propagare lo strumento di calcolo in ufficiale ?')==true){location.href='DpatSDCConfig.do?command=PropagaStrumentoDiCalcolo&idAsl=<%=DpatSDC.getIdAsl()%>&anno=<%=DpatSDC.getAnno()%>';}"/>
<%}else{
	%> 
	<font color ="red">Attenzione Lo strumento di calcolo è stato propagato in quello ufficiale</font>
	<%}%>
	

</dhv:permission>
<%--  
 <!-- SERVER DOCUMENTALE -->
<p align="left">
	 <script language="JavaScript" TYPE="text/javascript"
	SRC="gestione_documenti/generazioneDocumentale.js"></script>
		<% if (DpatSDC.isCompleto()==true){ %>
	  <img src="images/icons/stock_print-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        <input type="button" title="PDF" style="background-color:#FF4D00; font-weight: bold;" value="PDF Strumento di Calcolo"	
        onClick="openRichiestaPDF_DPAT('<%=DpatSDC.getIdAsl()%>', '<%=DpatSDC.getAnno()%>', 'DPAT_All5');"/>
      <%} %>
</p>
 <!-- SERVER DOCUMENTALE -->

 
<%if (DpatSDC.isCompleto()==true){ %>
<input type="button" id="CL" name="CL" value="Accedi al foglio Attivita'" style="background-color:#FF4D00; font-weight: bold;" onClick="" style="background-color:#FF4D00; font-weight: bold;"/>
<%
	if (dpat.isCompleto()==true){%>
		<dhv:permission name="dpat-view">
		<script>
			document.getElementById("CL").style.display="block";
			document.getElementById("CL").onclick=function(){window.location='Dpat.do?command=DpatDetailGenerale&idAsl=<%=DpatSDC.getIdAsl()%>&anno=<%=DpatSDC.getAnno()%>';}
		</script>
		</dhv:permission>
	<%} else {%>
		<dhv:permission name="dpat-view">
		<script>
			document.getElementById("CL").style.display="block";
			document.getElementById("CL").onclick=function(){window.location='Dpat.do?command=DpatDetailGenerale&idAsl=<%=DpatSDC.getIdAsl()%>&anno=<%=DpatSDC.getAnno()%>';}
		</script>
		</dhv:permission>
		<dhv:permission name="dpat-edit">
		<script>
			document.getElementById("CL").style.display="block";
			document.getElementById("CL").onclick=function(){window.location='Dpat.do?command=DpatModifyGenerale&idAsl=<%=DpatSDC.getIdAsl()%>&anno=<%=DpatSDC.getAnno()%>';}
		</script>
		</dhv:permission>
	<%} %>

<%}%>
<br><br>
 --%>

<table width="100%" border="1" id = "mytable_t1">
<thead>

<tr style="background-color: red;height: 40px;" >
	<th colspan="6">ORGANIGRAMMA E STRUMENTI DI CALCOLO</th>
	
</tr>

<tr style="background-color: rgb(204,193,218) ">

	<th>STRUTTURA DI APPARTENENZA</th>
	<th width="300px;" >NOMINATIVO</th>
	<th width="200px;">QUALIFICA</th>
<!-- 	<th>CARICO DI <br>LAVORO TEORICO <br>ANNUALE MINIMO<br> AD PERSONAM IN U.I.</th> -->
<!-- 	<th width="250px;">FATTORI CHE INCIDONO SUL CARICO DI LAVORO MINIMO AD PERSONAM</th> -->
<!-- 	<th>PERCENTUALE <br>DI U.I.<br> DA SOTTRARRE (%)</th> -->
<!-- 	<th>CARICO DI<br>LAVORO EFFETTIVO<br> ANNUALE MINIMO<br> AD PERSONAM IN U.I.</th> -->
	
<!-- 	<th width="150px;">&nbsp;</th> -->
<!-- 	<th>CARICO DI <br>LAVORO ANNUALE<br> MINIMO TEORICO<br> DI STRUTTURA IN U.I.<br>(SUBTOTALE DEI CARICHI AD PERSONAM)</th> -->
<!-- 	<td width="350px;"><b>FATTORI CHE INCIDONO NEGATIVAMENTE SUL CARICO DI LAVORO MINIMO DI STRUTTURA</b> -->
<!-- 		<font size="1.8" ><i> -->
<!-- 		<br>(1. caratteristiche geo-morfologiche del territorio -->
<!-- 		2. condizioni socio-economiche del territorio -->
<!-- 		3. problematiche particolari di natura sanitaria e/o ambientali -->
<!-- 		4. eventuale insufficienza del numero di amministrativi afferenti alla struttura) -->
<!-- 		</i></font> -->
<!-- 	</td> -->
<!-- 	<th>PERCENTUALE DI U.I.  DA SOTTRARRE (%)</th> -->
<!-- 	<th>CARICO DI <br>LAVORO EFFETTIVO<br> ANNUALE MINIMO <br>DI STRUTTURA IN U.I.</th> -->
</tr>

</thead>

<%
DpatStrumentoCalcoloStruttureList listStrutture =  DpatSDC.getListaStrutture();
int rowid = 0 ;
Qualifica.setSelectStyle("style=\"width: 100%;heigh:100%;\"");
if (listStrutture.size()>0)
{
for (int i = 0 ; i < listStrutture.size(); i++)
{
	rowid = (rowid != 1 ? 1 : 2);
	DpatStrumentoCalcoloStruttura struttura = (DpatStrumentoCalcoloStruttura)listStrutture.get(i);
	DpatStrumentoCalcoloNominativiList listaNominativiStruttura = struttura.getListaNominativi();
	String color = "";
	if (struttura.getNodoStruttura().getN_livello()==2){
		if (struttura.getNodoStruttura().getTipologia_struttura()==15){
			color="#A6FBB2";
		} else{
			color="#FFFF00";
		}
	}
	else{
		color="#FFFFFF";
	}
	%>
	<tbody id="div_struttura_<%=struttura.getId()%>"  class="row<%= rowid %>">
	<tr class = "rowclass_t1">
		<td  bgcolor="<%=color%>" align="center" style="width: 65px;height: 65px;" rowspan="<%=(listaNominativiStruttura.size()>0)?""+listaNominativiStruttura.size()+1 :"2"%>">
		<%="<b>" + struttura.getDescrizioneStruttura().toUpperCase()+"</b><BR><BR><BR><b>TIPOLOGIA</b> "+lookupTipologia2.getSelectedValue(struttura.getNodoStruttura().getTipologia_struttura())+"" %>
		</td>
		

	</tr>
		
		
		<% 
		if(listaNominativiStruttura.size()>0)
		{
			%>
			
			<%
			for (int j = 0 ; j < listaNominativiStruttura.size(); j++)
			{
				DpatStrumentoCalcoloNominativi nominativo = (DpatStrumentoCalcoloNominativi)listaNominativiStruttura.get(j);
		
		%>
				
				
					<tr id = "nominativo_<%=(j+1) %>_<%=struttura.getId()%>" style="margin-top: 0px;" >
					
					<td align="center" style="font-weight: bold">
					<%=nominativo.getNominativo().getContact().getNameLast() +" " +nominativo.getNominativo().getContact().getNameFirst() %>
					
					</td>
					<td align="center" style="font-weight: bold"><%=Qualifica.getSelectedValue(nominativo.getIdLookupQualifica()).toUpperCase() %></td>
					
					
				</tr>
				
		<%
			}
		}
		else{
			%>
			<tr style="margin-top: 0px;" >
			
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

