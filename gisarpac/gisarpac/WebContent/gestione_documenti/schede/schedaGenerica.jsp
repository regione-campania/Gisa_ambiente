<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import=" org.aspcfs.modules.util.imports.ApplicationProperties"%>
 

<%@page import="java.net.InetAddress"%>
<%@page import="org.aspcfs.modules.lineeattivita.base.*"%>
<%@page import="java.util.ArrayList" %>
<jsp:useBean id="schedaDetails" class="org.aspcf.modules.report.util.SchedaImpresa" scope="request"/>
<jsp:useBean id="OrgSoa" class="org.aspcfs.modules.soa.base.Organization" scope="request" />
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ include file="../../initPage.jsp" %>
<%@ include file="barcode.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Scheda</title>
</head>
<link rel="stylesheet" type="text/css" media="all" documentale_url="" href="gestione_documenti/schede/schede_layout.css" />

<body>

<table width="100%">
<col width="33%"><col width="33%"><col width="33%">
<tr>
<td><div align="left"><img style="text-decoration: none;" width="80" height="80" documentale_url="" src="gestione_documenti/schede/images/regioneaosta.jpg" /></div>
<div class="boxIdDocumento"></div>
<div class="boxOrigineDocumento"><%@ include file="../../../hostName.jsp" %></div>

</td>
<td><center><b><label class="titolo">Scheda <%=(schedaDetails.getOperatore()!=null ) ? schedaDetails.getOperatore() : "Impresa" %></label></b></center>
</td>
<td><div align="right"><img style="text-decoration: none;" height="80" documentale_url="" src="gestione_documenti/schede/images/<%=schedaDetails.getAsl().toLowerCase() %>.jpg" /></div>
</td>
</tr>
</table>

<table cellpadding="5" style="border-collapse: collapse">
<col width="33%">
<tr><td colspan="4" class="grey"><b>Informazione primaria</b></td></tr>
<tr><td class="blue" >Ragione sociale</td>
<td class="layout"><%=schedaDetails.getRagioneSociale() %></td></tr>
<tr><td class="blue">Numero Registrazione</td>
<td class="layout">
<%String lotto = "";
if (OrgSoa!=null && OrgSoa.getTipo_stab()!=null && !OrgSoa.getTipo_stab().equals(""))
	lotto = OrgSoa.getTipo_stab();
String numeroRegistrazione = schedaDetails.getNumeroRegistrazione();
if (lotto!=null && !lotto.equals(""))
	numeroRegistrazione = numeroRegistrazione + "-" + lotto;
%>

<%if (schedaDetails.getNumeroRegistrazione()!=null && !schedaDetails.getNumeroRegistrazione().equals("")){ %>
<img src="<%=createBarcodeImage(numeroRegistrazione)%>" />
<%} else { %>
NON DEFINITO
<%} %>
</td></tr>
<tr><td class="blue">Partita IVA</td>
<td class="layout"><%=schedaDetails.getPartitaIva() %></td></tr>
<tr><td class="blue">Codice Fiscale</td>
<td class="layout"><%=(schedaDetails.getCodiceFiscale()!=null) ? schedaDetails.getCodiceFiscale() : "" %></td></tr>
<tr><td class="blue">Cod. ATECO attivit� principale</td>
<td class="layout"><%=(schedaDetails.getAtecoPrincCodice()!=null) ? schedaDetails.getAtecoPrincCodice() : "" %> <%=(schedaDetails.getAtecoPrincDescrizione()!=null) ? schedaDetails.getAtecoPrincDescrizione() : "" %></td></tr>
<tr><td class="blue">Codici attivit� secondarie</td>
<td class="layout">
<%
ArrayList<LineeAttivita> linee_attivita_secondarie = (ArrayList<LineeAttivita>) request.getAttribute("linee_attivita_secondarie");
int i=0;
if (linee_attivita_secondarie!=null)
for (LineeAttivita linea: linee_attivita_secondarie) {
i++;
if (!linea.getLinea_attivita().isEmpty()) { %>
			    			    <%= toHtml( linea.getCodice_istat() + " " + linea.getDescrizione_codice_istat()) %> <br/>
			    			    <%= toHtml( linea.getCategoria() + " - " + linea.getLinea_attivita() ) %>&nbsp;
							<% } else { %>
								<%= toHtml( linea.getCodice_istat() + " " + linea.getDescrizione_codice_istat()) %> <br/>
							<%= toHtml( linea.getCategoria() ) %>&nbsp;
			    			<% } %>
			    			<br/>
			    			<%
			    		 } 
			    	%>

</td></tr>

<%if (schedaDetails.getTarga()!= null) { %>
<tr><td class="blue">Targa</td>
<td class="layout"><%=schedaDetails.getTarga() %></td></tr>
<%}  %>
<tr><td class="blue">Tipo attivit�</td>
<td class="layout"><%=(schedaDetails.getTipoAttivita()!=null) ? schedaDetails.getTipoAttivita() : "" %></td></tr>
<tr><td class="blue">Carattere</td>
<td class="layout"> <%=(schedaDetails.getCarattere()!=null) ? schedaDetails.getCarattere() : "" %></td></tr>
<tr><td class="blue">Data presentazione D.I.A. / Data inizio attivit�</td>
<td class="layout"><%=(schedaDetails.getDataPresentazioneDIA()!= null) ? toDateasString(schedaDetails.getDataPresentazioneDIA()) :  toDateasString(schedaDetails.getDataInizioAttivita())%></td></tr>
<tr><td class="blue">Categoria di rischio</td>
<td class="layout"><%= schedaDetails.getCategoriaRischio()%></td></tr>
<tr><td class="blue">Prossimo controllo con la tecnica della sorveglianza</td>
<td class="layout"><%=toDateasString(schedaDetails.getProssimoControllo()) %></td></tr>
<tr><td class="blue">Stato Impresa</td>
<td class="layout"><%=schedaDetails.getStatoImpresa() %></td></tr>
<tr><td colspan="4" class="grey"><b>Titolare o Legale Rappresentante</b></td></tr>
<tr><td class="blue">Codice Fiscale</td>
<td class="layout"> 	<%= (schedaDetails.getCodiceFiscaleRappresentante()!=null) ? schedaDetails.getCodiceFiscaleRappresentante() : ""%>&nbsp; </td></tr>
<tr><td class="blue">Nome</td>
<td class="layout"><%= (schedaDetails.getNomeRappresentante()!=null) ? schedaDetails.getNomeRappresentante() : "" %>&nbsp; </td></tr>
<tr><td class="blue">Cognome</td>
<td class="layout">	<%=(schedaDetails.getCognomeRappresentante()!=null) ? schedaDetails.getCognomeRappresentante() : "" %>&nbsp; </td></tr>
<tr><td class="blue">Luogo e data di nascita</td>
<td class="layout">	<%= (schedaDetails.getComuneNascitaRappresentante()!=null) ? schedaDetails.getComuneNascitaRappresentante() : ""%>&nbsp;     <%= toDateasString(schedaDetails.getDataNascitaRappresentante())%></td></tr>
<tr><td class="blue">Email</td>
<td class="layout"><%= (schedaDetails.getMailRappresentante()!=null) ? schedaDetails.getMailRappresentante() : "" %>&nbsp; </td></tr>
<tr><td class="blue">Telefono</td>
<td class="layout">	<%= (schedaDetails.getTelefonoRappresentante()!=null) ? schedaDetails.getTelefonoRappresentante() : "" %>&nbsp; </td></tr>
<tr><td class="blue">Fax</td>
<td class="layout"><%= ( schedaDetails.getFaxRappresentante()!=null ) ? schedaDetails.getFaxRappresentante() : ""%>&nbsp; </td></tr>
<tr><td colspan="4" class="grey"><b>Indirizzi</b></td></tr>
<tr><td class="blue">Sede Legale</td>
<td class="layout"><%= (schedaDetails.getSedeLegale()!=null) ? schedaDetails.getSedeLegale() : "" %></td></tr>
<tr><td class="blue">Sede Operativa</td>
<td class="layout"><%= (schedaDetails.getSedeOperativa()!=null) ?  schedaDetails.getSedeOperativa()  : "" %></td></tr>

<tr><td class="blue">Locale Funzionalmente Collegato 1:</td>
<td class="layout"><%= (schedaDetails.getLocale1()!=null) ? schedaDetails.getLocale1() : "-" %> - <%= (schedaDetails.getIndViaLocale1()!=null) ? schedaDetails.getIndViaLocale1() : "--" %> </td></tr>
<tr><td class="blue">Locale Funzionalmente Collegato 2:</td>
<td class="layout"><%= (schedaDetails.getLocale2()!=null) ? schedaDetails.getLocale2() : "-" %> - <%= (schedaDetails.getIndViaLocale2()!=null) ? schedaDetails.getIndViaLocale2() : "--" %> </td></tr>
<tr><td class="blue">Locale Funzionalmente Collegato 3:</td>
<td class="layout"><%= (schedaDetails.getLocale3()!=null) ? schedaDetails.getLocale3() : "-" %> - <%= (schedaDetails.getIndViaLocale3()!=null) ? schedaDetails.getIndViaLocale3() : "--" %> </td></tr>
<tr><td colspan="4" class="grey"><b>Controllo della Notifica</b></td></tr>
<tr><td class="blue">Data Completamento D.I.A.</td>
<td class="layout"><%= toDateasString(schedaDetails.getDataCompletamentoDIA()) %></td></tr>
<tr><td class="blue">Esito</td>
<td class="layout"><%= ( schedaDetails.getEsito()!=null) ? schedaDetails.getEsito() : ""%></td></tr>
</table>

</body>
</html>