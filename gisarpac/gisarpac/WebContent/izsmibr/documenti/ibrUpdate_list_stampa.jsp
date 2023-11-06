<%@page import="org.aspcfs.modules.izsmibr.base.GisaDsEsitoIBRA"%>
<%@page import="org.aspcfs.modules.izsmibr.base.DsESITOIBRIUS"%>
<%@ page import="java.util.*,org.aspcfs.utils.*"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio"%>
<%@ include file="../../initPage.jsp"%>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean"
	scope="session" />
<jsp:useBean id="InvioMassivo" class="org.aspcfs.modules.izsmibr.base.InvioMassivoIbr"
	scope="request" />
<link rel="stylesheet" type="text/css" media="print" documentale_url="" href="allevamenti/documenti/print.css" />

<div class="boxIdDocumento"></div>
<div class="boxOrigineDocumento"><%@ include file="../../../hostName.jsp" %></div>

<br/><br/>

<% int totaleKO = 0;
	int totaleOK = 0;%>

<table cellpadding="4" cellspacing="0" border="0" width="100%"
	class="details">
	<tr>
	<th nowrap class="formLabel"><strong>#</strong></th>
	    <th nowrap class="formLabel"><strong>P_ANNO_ACCETTAZIONE</strong></th>
		<th nowrap class="formLabel"><strong>P_CODICE_AZIENDA</strong></th>
		<th nowrap class="formLabel"><strong>P_CODICE_CAPO</strong></th>
		<th nowrap class="formLabel"><strong>P_CODICE_ISTITUTO</strong></th>
		<th nowrap class="formLabel"><strong>P_CODICE_PRELIEVO</strong></th>
		<th nowrap class="formLabel"><strong>P_CODICE_SEDE_DIAGNOSTICA</strong></th>
		<th nowrap class="formLabel"><strong>P_DATA_ESITO</strong></th>
		<th nowrap class="formLabel"><strong>P_DTA_PRELIEVO</strong></th>
		<th nowrap class="formLabel"><strong>P_ESITO_QUALITATIVO</strong></th>
		<th nowrap class="formLabel"><strong>P_ID_FISCALE_PROPRIETARIO</strong></th>
		<th nowrap class="formLabel"><strong>P_NUMERO_ACCETTAZIONE</strong></th>
		<th nowrap class="formLabel"><strong>P_SPECIE_ALLEVATA</strong></th>
		<th nowrap class="formLabel"><strong>P_EIBR_ID</strong></th>
		<th nowrap class="formLabel"><strong>DATA INVIO</strong></th>
		<th nowrap class="formLabel"><strong>ESITO INVIO</strong></th>
		<th nowrap class="formLabel"><strong>NOTE</strong></th>
		
	</tr>
	
	
	<% 
	
		ArrayList<GisaDsEsitoIBRA> rImport = ( ArrayList<GisaDsEsitoIBRA> ) request.getAttribute("allRecords");
		if ( rImport.size() > 0 ) {
			
				for ( int i=0; i< rImport.size(); i++ ) {
					if(rImport.get(i).getEsito_invio().equalsIgnoreCase("ko"))
						totaleKO++;
						else
							totaleOK++;
					
	%>
	
			<tr>
			<td align="right"><%= (i+1)+""%></td>
				<td align="right"><%= rImport.get(i).getRecord().getPARAMETERSLIST().get(0).getPANNOACCETTAZIONE() %></td>
				<td align="right"><%= rImport.get(i).getRecord().getPARAMETERSLIST().get(0).getPCODICEAZIENDA()%></td>
				<td align="right"><%= rImport.get(i).getRecord().getPARAMETERSLIST().get(0).getPCODICECAPO() %></td>
				<td align="right"><%= rImport.get(i).getRecord().getPARAMETERSLIST().get(0).getPCODICEISTITUTO() %></td>
				<td align="right"><%= rImport.get(i).getRecord().getPARAMETERSLIST().get(0).getPCODICEPRELIEVO() %></td>
				<td align="right"><%=rImport.get(i).getRecord().getPARAMETERSLIST().get(0).getPCODICESEDEDIAGNOSTICA()%></td>	
				<td align="right"><%= rImport.get(i).getRecord().getPARAMETERSLIST().get(0).getPDATAESITO().toString() %></td>
				<td align="right"><%= rImport.get(i).getRecord().getPARAMETERSLIST().get(0).getPDATAPRELIEVO().toString() %></td>
				<td align="right"><%= rImport.get(i).getRecord().getPARAMETERSLIST().get(0).getPESITOQUALITATIVO() %></td>
				<td align="right"><%= rImport.get(i).getRecord().getPARAMETERSLIST().get(0).getPIDFISCALEPROPRIETARIO() %></td>
				<td align="right"><%= rImport.get(i).getRecord().getPARAMETERSLIST().get(0).getPNUMEROACCETTAZIONE() %></td>
				<td align="right"><%= rImport.get(i).getRecord().getPARAMETERSLIST().get(0).getPSPECIEALLEVATA()%></td>
				<td align="right"><%= rImport.get(i).getRecord().getPARAMETERSLIST().get(0).getPEIBRID()%></td>
				<td align="right"><%= toDateasString(rImport.get(i).getData_invio_bdn())%></td>
				<td align="right"><%= rImport.get(i).getEsito_invio()%></td>
				<td align="right"><%= toHtml2(rImport.get(i).getErrore())%></td>
				
			</tr>
			<% } %>
		<% 
			
		} else { %>
		  <tr class="containerBody">
      			<td colspan="17">
        			<dhv:label name="">Nessun import eseguito.</dhv:label>
      			</td>
    	  </tr>
		<% } %> 
		
		
		<tr><td colspan="2" style="background-color:#7FFF00"> Totale OK (singola estrazione): </td> <td style="background-color:#7FFF00"> <%=totaleOK %> </td>
		<td colspan="2" style="background-color:#ff9999"> Totale KO (singola estrazione) : </td> <td style="background-color:#ff9999"> <%=totaleKO %> </td></tr>
	
</table>




	