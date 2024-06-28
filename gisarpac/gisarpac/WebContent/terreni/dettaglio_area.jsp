<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<%@ include file="../../../initPage.jsp"%>

<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery/jquery-1.8.2.js"></script>
<script src="javascript/jquery/ui/1.9.1/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<%@ page import="org.aspcfs.modules.terreni.base.*" %>

<jsp:useBean id="area" class="org.aspcfs.modules.terreni.base.Area" scope="request"/>


<%! public static String fixData(String timestring)
  {
	  String toRet = "";
	  if (timestring == null)
		  return toRet;
	  String anno = timestring.substring(0,4);
	  String mese = timestring.substring(5,7);
	  String giorno = timestring.substring(8,10);
	 
	  //toRet =giorno+"/"+mese+"/"+anno+" "+ora+":"+minuto+":"+secondi;
	  toRet =giorno+"/"+mese+"/"+anno;
	  return toRet;
	  
  }%>


<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Terreni.do?command=toSearchArea">Terra dei fuochi</a> > 
Dettaglio Area
</td>
</tr>
</table>
<br/>

<dhv:container name="terreni_particella_container"  selected="details" object="area" param="<%= "id="+area.getId() %>" hideContainer="false">

<br>

<%@ include file="../gestioneispettive/campioni/verbali/elencoArea.jsp" %> 

<br>

<table class="details" width="100%" cellpadding="10" cellspacing="10">
<col width="10%">

<tr><th colspan="2">DATI AREA <input type="button" value="MODIFICA" onclick="window.location.href='Terreni.do?command=ModifyArea&id=<%= area.getId() %>'" /></th></tr>
<tr>
	<td class="formLabel">Codice Sito</td>
	<td><%= area.getCodiceSito() %></td>
</tr>
<tr>
	<td class="formLabel">ID Sito</td>
	<td><%= area.getIdSito() %></td>
</tr>
<tr>
	<td class="formLabel">PROVINCIA</td>
	<td><%= area.getDescrizioneProvincia() %></td>
</tr>
<tr>
	<td class="formLabel">COMUNE</td>
	<td><%=area.getDescrizioneComune()%></td>
</tr>
<tr>
	<td class="formLabel">DATI CATASTALI</td>
	<td><b>SEZIONE</b> <%= area.getSezione() != null ? area.getSezione() : "" %> - <b>FOGLIO</b> <%= area.getFoglioCatastale() %> - <b>PARTICELLA</b> <%= area.getParticellaCatastale() %></td> 
</tr>
<tr>
	<td class="formLabel">CLASSE DI RISCHIO</td>
	<td><%= area.getClasseRischio() %></td>
</tr>
<!-- <tr> -->
<!-- 	<td class="formLabel">COORDINATE</td> -->
<%-- 	<td> <b>X</b> <%= area.getCoordinateX() %> - <b>Y</b> <%= area.getCoordinateY() %></td> --%>
<!-- </tr> -->
<tr>
	<td class="formLabel">AREA (mq)</td>
	<td><%= area.getArea() %></td>
</tr>
<tr>
	<td class="formLabel">NOTE</td>
	<td><%= area.getNote() %></td>
</tr>
<tr>
	<td class="formLabel">AGGIUNTO IL</td>
	<td><%=  fixData(area.getEntered().toString()) %></td>
</tr>
</table>

<BR/><BR/>

<table class="details" width="100%" cellpadding="10" cellspacing="10">
<tr><th colspan="2">SUBPARTICELLE <input type="button" value="AGGIUNGI SUBPARTICELLA" onclick="window.location.href='Terreni.do?command=AddSubparticella&idArea=<%= area.getId() %>'" /></th></tr>

<% for (int i = 0; i< area.getListaSubparticelle().size(); i++) {
Subparticella sub = (Subparticella) area.getListaSubparticelle().get(i); %>

<tr>
	<td class="formLabel">Codice Sito</td>
	<td> <a href="Terreni.do?command=DetailsSubparticella&id=<%=sub.getId()%>"><%=sub.getCodiceSito() %></a></td>
</tr>

<tr>
	<td class="formLabel">AGGIUNTA IL</td>
	<td><%=  fixData(sub.getEntered().toString()) %></td>
</tr>
<tr>
	<td colspan="2"></td>
</tr>

<% } %>
</table>
</dhv:container>