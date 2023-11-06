<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
  <%@page import="java.net.InetAddress"%>
  <%@ page import="java.util.*"%>
    <%@page import="org.aspcfs.modules.accounts.base.OrganizationAddress"%>
 <jsp:useBean id="OrgDetails" class="org.aspcfs.modules.stabilimenti.base.Organization" scope="request"/>
   <jsp:useBean id="esercente" class="org.aspcfs.modules.stabilimenti.base.Organization" scope="request"/>
 <jsp:useBean id="Capo" class="org.aspcfs.modules.macellazioni.base.Capo" scope="request"/>
 <jsp:useBean id="aslList" class="org.aspcfs.utils.web.LookupList"	scope="request" />
 <jsp:useBean id="specieList" class="org.aspcfs.utils.web.LookupList" scope="request" />
  <jsp:useBean id="userIp" class="java.lang.String" scope="request"/>
   <jsp:useBean id="userName" class="java.lang.String" scope="request"/>
    <jsp:useBean id="timeNow" class="java.lang.String" scope="request"/>
    <jsp:useBean id="definitivoDocumentale" class="java.lang.String" scope="request"/>
  <jsp:useBean id="ErrataCorrige" class="org.aspcfs.modules.macellazioni.base.Art17ErrataCorrige" scope="request"/>
  <jsp:useBean id="art17" class="org.aspcfs.modules.macellazioni.base.Art17" scope="request"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="../../initPage.jsp" %>
<link rel="stylesheet" documentale_url="" href="css/moduli_print.css" type="text/css" media="print" />
<link rel="stylesheet" type="text/css" media="screen" documentale_url="" href="css/moduli_screen.css">

<style>
.boxIdDocumento {
	position: relative;
	left: 5px;
	top: 1px;
	border: 0.5px solid black;
	width: 60px;
	height: 20px;
	margin-top: 0px;
	text-align: center;
	padding-top: 10px;
	font-size: 8px;
}
.boxOrigineDocumento {
	text-align: left;
	font-size: 9px;
}
</style>

<%int z = 0; %>
<!-- INIT DOCUMENTALE -->
	<%@ include file="/gestione_documenti/initDocumentale.jsp" %>
<!-- FINE INIT DOCUMENTALE -->

<html>
<body>
<table width="100%"">
<col width="33%"> <col width="33%">
<tr>
<td>
<div class="boxIdDocumento"></div><br/>
<div class="boxOrigineDocumento"><%@ include file="../../../hostName.jsp" %></div>
<i><%=ErrataCorrige.getIpUtente() %> - <%=ErrataCorrige.getNomeUtente() %></i>
</td>
<td></td>
<td><div align="right"><img style="text-decoration: none;" height="80" documentale_url="" src="gestione_documenti/schede/images/<%=aslList.getSelectedValue(OrgDetails.getSiteId()).toLowerCase() %>.jpg" /></div></td>
</tr>

</table>
<br/>

<center><b>REGIONE VALLE D'AOSTA<br/>
Azienda Sanitaria Locale <%=aslList.getSelectedValue(OrgDetails.getSiteId())%><br/>
Servizio Veterinario<br/><br/>
ISPEZIONE DELLE CARNI<br/><br/>
<font size="5px"><U>ERRATA CORRIGE PER ART.17 (R.D. 20/12/1928, N. 3298) *</U></font></b></center>
<br/><br/>

<%String indirizzo="";
 Iterator iaddress = esercente.getAddressList().iterator();
  while (iaddress.hasNext()) {
	   OrganizationAddress thisAddress = (OrganizationAddress)iaddress.next();
	   if (thisAddress.getType()==5)
		indirizzo = " - "+ thisAddress.toString();
    }
  
%>

<center>
<% String numArt17 ="";
numArt17 = art17.getProgressivo() + "/" + art17.getAnno() + "/" + OrgDetails.getApprovalNumber();
%>
Il sottoscritto <%=ErrataCorrige.getSottoscritto() %>, relativamente all'art.17 n� <%=numArt17 %>, elaborato e rilasciato presso il macello <%=OrgDetails.getName() %> del comune di <%=OrgDetails.getCity().toUpperCase() %> (<%=OrgDetails.getState().toUpperCase()%>), per la data di macellazione <%=toDateasString(Capo.getDataSessioneMacellazione()) %> 
ed esercente <%=Capo.getDestinatario_1_nome() %> <%=indirizzo%><br/><br/>
<b>DICHIARA CHE</b></center><br/><br/>
� stata erroneamente digitata l'informazione riguardante i campi del capo con matricola <b><u><%=Capo.getCd_matricola() %></u></b>:<br/><br/>

<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
<col width="33%"><col width="33%">
<tr><th style="border:1px solid black;">Dati</th>
<th style="border:1px solid black;">Dati errati</th>
<th style="border:1px solid black;">Dati corretti</th></tr>

<tr>
<td style="border:1px solid black;"><%--input type="checkbox" id="cb_matricola" name="cb_matricola" <% if (ErrataCorrige.isMatricolaModificata()) {%>checked="checked"<%} %>> La matricola del capo</td--%>
<% if (ErrataCorrige.isMatricolaModificata()) {%>[X]<%} %> La matricola del capo</td>
<td style="border:1px solid black;"><%= (ErrataCorrige.isMatricolaModificata()) ? ErrataCorrige.getMatricolaErrata() : ""  %>&nbsp;</td>
<td style="border:1px solid black;"><%= (ErrataCorrige.isMatricolaModificata()) ? ErrataCorrige.getMatricolaCorretta() : ""  %>&nbsp;</td>
</tr>
<tr>
<%--td style="border:1px solid black;"><input type="checkbox" id="cb_datanascita" name="cb_datanascita" <% if (ErrataCorrige.isDataNascitaModificata()) {%>checked="checked"<%} %>> La data di nascita del capo</td--%>
<td style="border:1px solid black;"><% if (ErrataCorrige.isDataNascitaModificata()) {%>[X]<%} %> La data di nascita del capo</td>
<td style="border:1px solid black;"><%= (ErrataCorrige.isDataNascitaModificata()) ? toDateasString(ErrataCorrige.getDataNascitaErrata()) : ""  %>&nbsp;</td>
<td style="border:1px solid black;"><%= (ErrataCorrige.isDataNascitaModificata()) ? toDateasString(ErrataCorrige.getDataNascitaCorretta()) : ""  %>&nbsp;</td>
</tr>
<tr>
<%--td style="border:1px solid black;"><input type="checkbox" id="cb_specie" name="cb_specie" <% if (ErrataCorrige.isSpecieModificata()) {%>checked="checked"<%} %>> La specie del capo</td--%>
<td style="border:1px solid black;"> <% if (ErrataCorrige.isSpecieModificata()) {%>[X]<%} %> La specie del capo</td>
<td style="border:1px solid black;"><%= (ErrataCorrige.isSpecieModificata()) ? specieList.getSelectedValue( ErrataCorrige.getSpecieErrata() ) : ""  %>&nbsp;</td>
<td style="border:1px solid black;"><%= (ErrataCorrige.isSpecieModificata()) ? specieList.getSelectedValue( ErrataCorrige.getSpecieCorretta() ) : ""  %>&nbsp;</td>
</tr>
<tr>
<%--td style="border:1px solid black;"><input type="checkbox" id="cb_sesso" name="cb_sesso" <% if (ErrataCorrige.isSessoModificato()) {%>checked="checked"<%} %>> Il sesso del capo</td--%>
<td style="border:1px solid black;"> <% if (ErrataCorrige.isSessoModificato()) {%>[X]<%} %> Il sesso del capo</td>
<td style="border:1px solid black;"><%= (ErrataCorrige.isSessoModificato()) ? ErrataCorrige.getSessoErrato() : ""  %>&nbsp;</td>
<td style="border:1px solid black;"><%= (ErrataCorrige.isSessoModificato()) ? ErrataCorrige.getSessoCorretto() : ""  %>&nbsp;</td>
</tr>
<tr>
<%--td style="border:1px solid black;"><input type="checkbox" id="cb_mod4" name="cb_mod4" <% if (ErrataCorrige.isMod4Modificato()) {%>checked="checked"<%} %>> Il riferimento al Mod. 4 �</td--%>
<td style="border:1px solid black;"><% if (ErrataCorrige.isMod4Modificato()) {%>[X]<%} %> Il riferimento al Mod. 4 �</td>
<td style="border:1px solid black;"><%= (ErrataCorrige.isMod4Modificato()) ? ErrataCorrige.getMod4Errato() : ""  %>&nbsp;</td>
<td style="border:1px solid black;"><%= (ErrataCorrige.isMod4Modificato()) ? ErrataCorrige.getMod4Corretto() : ""  %>&nbsp;</td>
</tr>
<tr>
<%--td style="border:1px solid black;"><input type="checkbox" id="cb_altro" name="cb_altro" <% if (ErrataCorrige.isAltroModificato()) {%>checked="checked"<%} %>> Altro</td--%>
<td style="border:1px solid black;"><% if (ErrataCorrige.isAltroModificato()) {%>[X]<%} %> Altro</td>
<td style="border:1px solid black;"><%= (ErrataCorrige.isAltroModificato()) ? ErrataCorrige.getAltroErrato() : ""  %>&nbsp;</td>
<td style="border:1px solid black;"><%= (ErrataCorrige.isAltroModificato()) ? ErrataCorrige.getAltroCorretto() : ""  %>&nbsp;</td>
</tr>
</table>
<br/>
<b>Motivo della correzione:</b> <%=ErrataCorrige.getMotivo() %> <br/><br/>

<table width="100%">
<col width="50%">
<tr>
<td><b>Data</b> <br/>
<%=toDateWithTimeasString(ErrataCorrige.getEntered()) %>
<td><div align="right">Il veterinario ufficiale dell'ASL <%=aslList.getSelectedValue(OrgDetails.getSiteId())%></div></td>
</table>
<br/><br/><br/><br/>
     * <i>Il presente modulo rappresenta una notifica documentale. Eventuali correzioni sui dati dovranno essere effettuate separatamente.</i>
   
</body>
</html>