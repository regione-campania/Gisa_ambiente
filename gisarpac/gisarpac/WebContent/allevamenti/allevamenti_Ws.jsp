<%--
	



	--%>

<jsp:useBean id="AllevamentoBDN" class="org.aspcfs.modules.allevamenti.base.AllevamentoAjax" scope="request"/>

<%@ include file="../initPage.jsp" %>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popURL.js"></script>
<script language="JavaScript" type="text/javascript" src="javascript/popLookupSelect.js"></script>
		
<html>
<head>
<title>INTERROGAZIONE BDN</title>

</head>

<body>
		<script>
			function rosso(){					
					$('div.lampeggio').each(function(d){
					    this.style.color = 'red';
					});	
					setTimeout("bianco()",500);
				
			
			}
			function bianco(){
				$('div.lampeggio').each(function(d){
					    this.style.color = 'white';
				});      
					
				setTimeout("rosso()",500);		
			}
		</script>
		
		
		
		
		<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
		<tr><th colspan="2"><strong>Dati Allevamento in BDN</strong></th></tr>
		<tr class="containerBody">
		<td nowrap class="formLabel">
		
		<div>
			<dhv:label name="">Denominazione</dhv:label></div>		
		</td>
		<td><%= AllevamentoBDN.getDenominazione() %></td></tr>
		<tr class="containerBody"><td nowrap class="formLabel"><dhv:label  name="organization.accountNumbera">Codice Azienda</dhv:label></td>
		<td><%= AllevamentoBDN.getCodice_azienda() %></td></tr>
		<tr class="containerBody"><td nowrap class="formLabel">
		<div >
			<dhv:label  name="organization.accountNumbera">Codice Fiscale Proprietario</dhv:label>
		</div></td>
		<td><%= AllevamentoBDN.getCodice_fiscale() %></td></tr>
		<tr class="containerBody">
		<td nowrap class="formLabel">
		<div >Indirizzo</div>
		
		</td>
		<td>
		
		<%= AllevamentoBDN.getIndirizzo()%> <%= AllevamentoBDN.getComune()%>
		</td></tr>
		<tr class="containerBody"><td nowrap class="formLabel">
		<div >
			<dhv:label name="allevamenti.allevamenti_add.date1a">Data Inizio Attività</dhv:label>
		</div>	
		</td>
		<td><%= AllevamentoBDN.getData_inizio_attivita() %></td></tr>
		<%if (AllevamentoBDN.getData_fine_attivita()!= null){ %>
			<tr class="containerBody"><td nowrap class=formLabel>
				<div <>
					<dhv:label name="allevamenti.allevamenti_add.date1a">Stato Allevamento:</dhv:label>
				</div>
			</td>
			<td><font color="red">CESSATO</font> in data <%= AllevamentoBDN.getData_fine_attivita() %></td></tr>
		<% } %>
		<tr class="containerBody">
		<td nowrap class="formLabel">
		<div >
			<dhv:label name="organization.specieAlleva">Specie Allevata</dhv:label>
		</div>	
		</td>
		<td>
		<strong><%= AllevamentoBDN.getDescrizione_specie() %></strong>
		</td>
		</tr>
		<tr class="containerBody">
		<td nowrap class="formLabel">
			<div >Numero di Capi Totali</div>
		</td>
		<td><strong><%= AllevamentoBDN.getNumero_capi() %></strong></td></tr>
		
		<tr class="containerBody">
		<td nowrap class="formLabel">
			<div >Note:</div>
		</td>
		<td>
		
		</td></tr>	
		
		<tr class="containerBody">
		<td nowrap class="formLabel">
			<div >Note:</div>
		</td>
		<td>
		<%if (AllevamentoBDN.getNote() != null){ %>
			 <%= AllevamentoBDN.getNote() %>
		<% } %>
		</td></tr>		

		</table>
		
	</body>
	
</html>
		