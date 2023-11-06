<%--
	



	--%>

<jsp:useBean id="OrgDetails" class="org.aspcfs.modules.allevamenti.base.Organization" scope="request"/>
<jsp:useBean id="AllevamentoBDN" class="org.aspcfs.modules.allevamenti.base.AllevamentoAjax" scope="request"/>
<jsp:useBean id="AziendaBDN" class="it.izs.bdn.bean.InfoAziendaBean" scope="request"/>
<jsp:useBean id="DiffenzeBDN" class="java.util.ArrayList" scope="request"/>

<%@ include file="../initPage.jsp" %>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popURL.js"></script>
<script language="JavaScript" type="text/javascript" src="javascript/popLookupSelect.js"></script>
		
<html>
<head>
<title>INTERROGAZIONE BDN</title>

</head>

<body>
	

		
		
		<dhv:evaluate if="<%= !(DiffenzeBDN.isEmpty()) %>">
		<h3 style="color:red;text-align:center">RISCONTRATO DISALLINEAMENTO CON BDN</h3>
		</dhv:evaluate>
		
		<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
		<tr><th colspan="2"><strong>Dati Allevamento in BDN</strong></th></tr>
		
		<tr class="containerBody">
		<td nowrap class="formLabel">Denominazione</td>
		<td><%= AllevamentoBDN.getDenominazione() %></td>
		</tr>
		
		<tr class="containerBody">
		<td nowrap class="formLabel">Codice Azienda</td>
		<td><%= AllevamentoBDN.getCodice_azienda() %></td>
		</tr>
		
		<tr class="containerBody">
		<td nowrap class="formLabel">Codice Fiscale Proprietario</td>
		<td><%= AllevamentoBDN.getCodice_fiscale() %></td>
		</tr>
		
		<tr class="containerBody">
		<td nowrap class="formLabel">Indirizzo</td>
		<td>
		<font color="<%=(DiffenzeBDN.contains("indirizzo") || DiffenzeBDN.contains("comune")) ? "red" : ""%>">
			<%= AllevamentoBDN.getIndirizzo()%> <%= AllevamentoBDN.getComune()%>
		</font>
		</td>
		</tr>
		
		<tr class="containerBody">
		<td nowrap class="formLabel">Data Inizio Attività</td>
		<td> 
		<font color="<%=(DiffenzeBDN.contains("data_inizio_attivita")) ? "red" : ""%>">
		<%= AllevamentoBDN.getData_inizio_attivita() %>
		</font>
		</td>
		</tr>
		
		<tr class="containerBody">
		<td nowrap class="formLabel">Data Fine Attività</td>
		<td>
		<font color="<%=(DiffenzeBDN.contains("data_fine_attivita")) ? "red" : ""%>">
		<%=(AllevamentoBDN.getData_fine_attivita()!=null)?(AllevamentoBDN.getData_fine_attivita()):("Non presente")%>
		</font>
		</td>
		</tr>
		
		<tr class="containerBody">
		<td nowrap class="formLabel">Specie Allevata</td>
		<td><%= AllevamentoBDN.getDescrizione_specie() %></td>
		</tr>
		
		<tr class="containerBody">
		<td nowrap class="formLabel">Numero di Capi Totali</td>
		<td>
		<font color="<%=(DiffenzeBDN.contains("numero_capi")) ? "red" : ""%>">
		<%= AllevamentoBDN.getNumero_capi() %>
		</font>
		</td>
		</tr>
		
		<tr class="containerBody">
		<td nowrap class="formLabel">Note:</td>
		<td><%if (AllevamentoBDN.getNote() != null){ %><%= AllevamentoBDN.getNote() %><% } %></td>
		</tr>	
		
		
		<tr class="containerBody">
		<td nowrap class="formLabel">Cf Proprietario</td>
		<td><%if (AllevamentoBDN.getCfProprietario() != null){ %><%= AllevamentoBDN.getCfProprietario() %><% } %></td>
		</tr>	
		
		<tr class="containerBody">
		<td nowrap class="formLabel">Cf Detentore</td>
		<td><%if (AllevamentoBDN.getCfDetentore() != null){ %><%= AllevamentoBDN.getCfDetentore() %><% } %></td>
		</tr>	
		
		</table>
		
		<form method="post" action = "Allevamenti.do?command=SincronizzaConBDN">
	<input type = "hidden" name = "denominazione" value = "<%=OrgDetails.getName()%>">
		
		<input type = "hidden" name = "codAzienda" value = "<%=OrgDetails.getAccountNumber().trim() %>">
		<input type = "hidden" name = "idFiscale" value = "<%=(OrgDetails.getPartitaIva()!=null)?(OrgDetails.getPartitaIva().trim()):("") %>">
		<input type = "hidden" name = "specie" value = "<%="0"+OrgDetails.getSpecieA() %>">
		<input type = "hidden" name = "orgId" value = "<%=OrgDetails.getOrgId() %>">
		
		<input type = "hidden" name = "indirizzo" value = "<%= AllevamentoBDN.getIndirizzo()%>">
		<input type = "hidden" name = "comune" value = "<%= AllevamentoBDN.getComune()%>">
		<input type = "hidden" name = "cap" value = "<%= AziendaBDN.getCap_azienda()%>">
		<input type = "hidden" name = "latitudine" value = "<%=(AziendaBDN.getLatitudine()!=null)?(AziendaBDN.getLatitudine()):("")%>">
		<input type = "hidden" name = "longitudine" value = "<%=(AziendaBDN.getLongidutine()!=null)?(AziendaBDN.getLongidutine()):("")%>">

		<input type="hidden"  id="dataInizioAttivita" name="dataInizioAttivita" value="<%= AllevamentoBDN.getData_inizio_attivita()%>"/>
		<input type="hidden"  id="dataFineAttivita" name="dataFineAttivita" value="<%= AllevamentoBDN.getData_fine_attivita() %>"/>
		<input type="hidden"  id="specieAllevata" name="specieAllevata" value="0<%= AllevamentoBDN.getSpecie_allevata() %>"/>
		<input type="hidden"  id="numeroCapi" name="numeroCapi" value="<%= AllevamentoBDN.getNumero_capi() %>"/>
		
		
		
		
		
		<input type = "submit" value = "Sincronizza">
		</form>
		
	</body>
	
</html>
		