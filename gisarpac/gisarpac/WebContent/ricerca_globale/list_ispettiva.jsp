<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="risultato" class="java.lang.String" scope="request"/>

<%@ include file="../initPage.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery-1.8.2.js"></script>
<script src="javascript/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>


<% if (risultato!="") { 

String ris[] = risultato.split(";;");
int idGiornataIspettiva = -1;
try {idGiornataIspettiva = Integer.parseInt(ris[0]);} catch (Exception e) {}
int idFascicoloIspettivo = -1;
try {idFascicoloIspettivo = Integer.parseInt(ris[1]);} catch (Exception e) {}
String numFascicolo = ris[2];
String dataInizio = ris[3];
String dipartimento = ris[4];
String ragioneSociale = ris[5];
 
%>

<table class="details" cellpadding="20" cellspacing="20" width="100%" style="border-collapse: collapse">
<col width="20%">
<tr><th colspan="2">RISULTATO RICERCA</th></tr>

<tr><td CLASS="formLabel">ID FASCICOLO ISPETTIVO</td> <td><a href="GestioneFascicoliIspettivi.do?command=View&idFascicoloIspettivo=<%=idFascicoloIspettivo%>"><b><%=idFascicoloIspettivo%></b></a></td></tr>

<%if (idGiornataIspettiva>0){ %>
<tr><td CLASS="formLabel">ID GIORNATA ISPETTIVA</td> <td><a href="GestioneGiornateIspettive.do?command=View&idGiornataIspettiva=<%=idGiornataIspettiva%>"><b><%=idGiornataIspettiva%></b></a></td></tr>
<% } %>
<tr><td CLASS="formLabel">DATA INIZIO</td> <td><%=dataInizio%></td></tr>
<tr><td CLASS="formLabel">NUMERO FASCICOLO</td> <td><%=numFascicolo %></td></tr>
<%if (dipartimento!=null && !dipartimento.equals("")){ %>
<tr><td CLASS="formLabel">DIPARTIMENTO</td> <td><%=dipartimento%></td></tr>
<% } %>
<tr><td CLASS="formLabel">RAGIONE SOCIALE</td> <td><%=ragioneSociale%></td></tr>
</table>

<% } else { %>
La ricerca non ha prodotto risultati.
<% } %>

<br/><br/>

<input type="button" value="ESEGUI UNA NUOVA RICERCA" onClick="window.location.href='RicercaGlobale.do?command=SearchFormIspettiva'"/>