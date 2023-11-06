<jsp:useBean id="AslList" class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="ListaStati" class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="ToponimiList" class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="newStabilimento" class="org.aspcfs.modules.opu.base.Stabilimento" scope="request"/>
<jsp:useBean id="oldStabilimento" class="org.aspcfs.modules.opu.base.Stabilimento" scope="request"/>
<jsp:useBean id="esitoCambio" class="java.lang.String" scope="request" />

<%@ page import="java.util.*,java.text.DateFormat,org.aspcfs.modules.accounts.base.*,org.aspcfs.modules.opu.base.*,org.aspcfs.modules.contacts.base.*,org.aspcfs.modules.base.Constants" %>

<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<link rel="stylesheet" type="text/css" href="opumodifica/css/styleModifica.css"></link>		


<script type="text/javascript" src="dwr/interface/PopolaCombo.js"> </script>
<script f src="dwr/interface/SuapDwr.js"> </script>

<script>
function vaiAnagrafica(id){
	var url = "OpuStab.do?command=Details&idFarmacia="+id+"&opId="+id+"&stabId="+id;
	loadModalWindow();
	window.location.href=url;
	}

</script>


<%
String nomeContainer = "suap";
String param = "";

	if (newStabilimento.getIdStabilimento()>0){
		param ="stabId="+newStabilimento.getIdStabilimento()+"&opId=" + newStabilimento.getIdOperatore()+"&altId="+newStabilimento.getAltId();
		request.setAttribute("Operatore",newStabilimento.getOperatore());
	}
	else {
		param ="stabId="+oldStabilimento.getIdStabilimento()+"&opId=" + oldStabilimento.getIdOperatore()+"&altId="+oldStabilimento.getAltId();
		request.setAttribute("Operatore",oldStabilimento.getOperatore());
	}

%>

<table class="trails" cellspacing="0">
<tr>
<td width="100%">
<a href=""><dhv:label name="">Anagrafica stabilimenti</dhv:label></a> >
<a href="OpuStab.do?command=SearchForm"><dhv:label name="">Ricerca</dhv:label></a> >
<a href="RicercaUnica.do?command=Search"><dhv:label name="">Risultato ricerca</dhv:label></a> >
Scheda Anagrafica Impresa
</td>
</tr>
</table>


<dhv:container name="<%=nomeContainer %>"  selected="details" object="Operatore" param="<%=param%>"  hideContainer="false">

<center>
<font size="3px">Operazione di cambio sede legale</font><br/>

<table class="indirizzo" cellpadding="10" cellspacing="10">

<tr>
<th colspan="3"><%=esitoCambio %></th>
</tr>

<tr>
<th></th>
<th>DATI PRECEDENTI</th>
<th>DATI AGGIORNATI</th>
</tr>

<tr>
<th>RAGIONE SOCIALE</th>
<td><%=oldStabilimento.getOperatore().getRagioneSociale()%></td>
<td><%=newStabilimento.getOperatore().getRagioneSociale()%></td>
</tr>

<tr>
<th>NUM REGISTRAZIONE</th>
<td><%=oldStabilimento.getNumero_registrazione()%></td>
<td><%=newStabilimento.getNumero_registrazione()%></td>
</tr>

<tr>
<th>STATO</th>
<td><%=ListaStati.getSelectedValue(oldStabilimento.getStato())%></td>
<td><%=ListaStati.getSelectedValue(newStabilimento.getStato())%></td>
</tr>

<tr>
<th>ASL</th>
<td><%=AslList.getSelectedValue(oldStabilimento.getIdAsl())%></td>
<td><%=AslList.getSelectedValue(newStabilimento.getIdAsl())%></td>
</tr>

<tr>
<th>COMUNE</th>
<td><%=oldStabilimento.getOperatore().getSedeLegale().getDescrizioneComune() %></td>
<td><%=newStabilimento.getOperatore().getSedeLegale().getDescrizioneComune() %></td>
</tr>

<tr><th>INDIRIZZO</th>
<td><%=ToponimiList.getSelectedValue(oldStabilimento.getOperatore().getSedeLegale().getToponimo()) %> <%=oldStabilimento.getOperatore().getSedeLegale().getVia() %> <%=oldStabilimento.getOperatore().getSedeLegale().getCivico() %> </td>
<td><%=ToponimiList.getSelectedValue(newStabilimento.getOperatore().getSedeLegale().getToponimo()) %> <%=newStabilimento.getOperatore().getSedeLegale().getVia() %> <%=newStabilimento.getOperatore().getSedeLegale().getCivico() %> </td>
</tr>

<tr><th>CAP</th>
<td><%=oldStabilimento.getOperatore().getSedeLegale().getCap() %> </td>
<td><%=newStabilimento.getOperatore().getSedeLegale().getCap() %> </td>
</tr>

<tr><th>COORDINATE</th>
<td><%=oldStabilimento.getOperatore().getSedeLegale().getLatitudine() %> <%=oldStabilimento.getOperatore().getSedeLegale().getLongitudine() %> </td>
<td><%=newStabilimento.getOperatore().getSedeLegale().getLatitudine() %> <%=newStabilimento.getOperatore().getSedeLegale().getLongitudine() %> </td>
</tr>

<tr><th>VAI ALL'ANAGRAFICA</th>
<td><input type="button" value="VAI" onClick="vaiAnagrafica('<%=oldStabilimento.getIdStabilimento()%>')"/> </td>
<td> <% if (newStabilimento.getIdStabilimento()>0){ %> <input type="button" value="VAI" onClick="vaiAnagrafica('<%=newStabilimento.getIdStabilimento()%>')"/><% } %> </td>
</tr>

</table>

</center></dhv:container>