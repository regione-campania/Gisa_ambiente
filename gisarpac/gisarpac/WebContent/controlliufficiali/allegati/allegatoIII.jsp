<jsp:useBean id="Allevamento" class="org.aspcf.modules.controlliufficiali.base.Organization" scope="request"/>
<jsp:useBean id="AslList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<P style="text-align: right">
	<b>Allegato 3</b>	   
</P>
<P text-align="center" style="font-size:18pt; text-align: center">
	<b>PROTEZIONE DEGLI ANIMALI NEGLI ALLEVAMENTI <input style="font-size: 18pt;" type="text" class="layout" value="<%=Allevamento.getSpecie_allev()%>"><br></b>
	   RISULTATI DEI CONTROLLI EFFETTUATI PRESSO LE AZIENDE
</P>
<BR>
<p style="font-size: 15pt;">
 REGIONE <input type="text" class="layout" value="CAMPANIA"/>
 ASL <input type="text" class="layout" readonly value="<%= Allevamento.getAsl()%>"/>
<br> 
EXTRAPIANO: <span class="NocheckedItem">SI&nbsp;&nbsp;</span>
<span class="NocheckedItem">NO&nbsp;&nbsp;</span>
DATA DEL CONTROLLO:<input type="text" class="layout" readonly value="<%= Allevamento.getGiornoReferto()+ " " + Allevamento.getMeseReferto() + " "+ Allevamento.getAnnoReferto()%>" /> 
</p>
<div style="text-align:justify;border: 1px solid;">
<br>
Codice Azienda <input type="text" class="layout" readonly value="<%=Allevamento.getN_reg() %>">Denominazione <input size="110" type="text" class="layout" readonly value="<%=Allevamento.getName()%>"><br>
Indirizzo azienda <input size="150" type="text" class="layout" readonly value="<%=Allevamento.getIndirizzo()+ " " + Allevamento.getCap() + " " +Allevamento.getComune() +" ("+Allevamento.getProv()+")" %>"><br>
Indirizzo sede legale <input size="145" type="text" class="layout" readonly value=""><br>
Proprietario struttura <input size="100" type="text" class="layout" readonly value=""> codice fiscale <input size="20" type="text" class="layout" readonly value=""><br>
Proprietario degli animali <input size="140" type="text" class="layout" readonly value="<%= Allevamento.getProp()%>"><br>
Codice fiscale proprietario <input size="20" type="text" class="layout" readonly value="<%= Allevamento.getCf_prop() %>"> Tel. <input type="text" class="layout" readonly value=""><br>
Detentore <input size="160" type="text" class="layout" readonly value="<%=Allevamento.getDet()%>"><br>
Codice fiscale <input size="20" type="text" class="layout" readonly value="<%=Allevamento.getCf_det() %>"> Tel. <input type="text" class="layout" readonly value=""><br>
Data inizio attivit� <input type="text" class="layout" readonly value="<%=Allevamento.getGiornoNascita()+ " " +Allevamento.getMeseNascita()+" " +Allevamento.getAnnoNascita() %>"><br>
Orientamento produttivo <input size="140" type="text" class="layout" readonly value=""><br> 
N. totale dei vitelli presenti <input type="text" class="layout" readonly value=""> n. dei vitelli di et� &lt; a 8 settimane<br>
Capacit� massima vitelli <input type="text" class="layout" readonly value=""><br>
<br>
</div>
<br>
<br>
<br>
<B>LEGENDA</B>
<table border="1">
	<tr>
		<td style="text-align:center">
			<b>Categoria delle non conformit�</b>
		</td>
		<td>
			<b>AZIONI INTRAPRESE DALL'AUTORITA' COMPETENTE</b>
		</td>
	</tr>
	<tr>
		<td style="text-align:center">
			<b>A</b>
		</td>
		<td>
			Richiesta di rimediare alle non conformit� entro un termine inferiore a 3 mesi. <br>
			Nessuna sanzione amministrativa o penale immediata.
		</td>
	</tr>
	<tr>
		<td style="text-align:center">
			<b>B</b>
		</td>
		<td>
			Richiesta di rimediare alle non conformit� entro un termine superiore a 3 mesi.<br>
			 Nessuna sanzione amministrativa o penale immediata.
		</td>
	</tr>
	<tr>
		<td style="text-align:center">
			<b>C</b>
		</td>
		<td>
			Sanzione amministrativa o penale immediata.
		</td>
	</tr>
</table>

<div class="fine" style="height: 150px;">&nbsp;</div>

