<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="org.aspcfs.modules.terreni.base.*" %>

<jsp:useBean id="sub" class="org.aspcfs.modules.terreni.base.Subparticella" scope="request"/>


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
<a href="Terreni.do?command=DetailsArea&id=<%=sub.getIdPadre()%>">Dettaglio Area</a> > 
Dettaglio Subparticella
</td>
</tr>
</table>
<br/>

<dhv:container name="terreni_subparticella_container"  selected="details" object="sub" param="<%= "id="+sub.getId() %>" hideContainer="false">


<table class="details" width="100%" cellpadding="10" cellspacing="10">
<tr><th colspan="2">DATI AREA</th></tr>
<tr>
	<td class="formLabel">Codice Sito</td>
	<td><a href="Terreni.do?command=DetailsArea&id=<%=sub.getIdPadre()%>"><%= sub.getArea().getCodiceSito() %></a></td>
</tr>
<tr>
	<td class="formLabel">DATI CATASTALI</td>
	<td><b>SEZIONE</b> <%= sub.getArea().getSezione() != null ? sub.getArea().getSezione() : "" %> - <b>FOGLIO</b> <%= sub.getArea().getFoglioCatastale() %> - <b>PARTICELLA</b> <%= sub.getArea().getParticellaCatastale() %></td>
</tr>
<tr>
	<td class="formLabel">AREA (mq)</td>
	<td><%= sub.getArea().getArea() %></td>
</tr>
<!-- <tr> -->
<!-- 	<td class="formLabel">COORDINATE</td> -->
<%-- 	<td> <b>X</b> <%= sub.getArea().getCoordinateX() %> - <b>Y</b> <%= sub.getArea().getCoordinateY() %></td> --%>
<!-- </tr> -->
<tr>
	<td class="formLabel">NOTE</td>
	<td><%= sub.getArea().getNote() %></td>
</tr>

</table>

<table class="details" width="100%" cellpadding="10" cellspacing="10">
<tr><th colspan="2">DATI SUBPARTICELLA <input type="button" value="MODIFICA" onclick="window.location.href='Terreni.do?command=ModifySubparticella&id=<%= sub.getId() %>'" /></th></tr>
<tr>
	<td class="formLabel">Codice Sito</td>
	<td><%= sub.getCodiceSito() %></td>
</tr>

<tr>
	<td class="formLabel">AGGIUNTO IL</td>
	<td><%=  fixData(sub.getEntered().toString()) %></td>
</tr>
</table>

</dhv:container>