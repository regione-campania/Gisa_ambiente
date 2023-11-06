<jsp:useBean id="AslList" class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="listaStorico" class="java.util.ArrayList" scope="request" />

<jsp:useBean id="esitoTrasferimento" class="java.lang.String" scope="request" />

<%@ page import="java.util.*,java.text.DateFormat,org.aspcfs.modules.accounts.base.*,org.aspcfs.modules.opu.base.*,org.aspcfs.modules.contacts.base.*,org.aspcfs.modules.base.Constants" %>

<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<link rel="stylesheet" type="text/css" href="opumodifica/css/styleModifica.css"></link>		



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

<script>
function filtra(val){
	
	var table = document.getElementById("storico");
	var rows = table.rows;
	
	for (var i = 1; i < rows.length; i++) {
	    var rowClass = rows[i].className;
	    if (rowClass==val || val =='tutti') 
	    	rows[i].style.display="table-row";
	    else
	    	rows[i].style.display="none";
	    }
	
}



</script>


<table class="trails" cellspacing="0">
<tr>
<td width="100%">
<a href=""><dhv:label name="">Anagrafica stabilimenti</dhv:label></a> >
<a href=""><dhv:label name="">Gestione Cambi Sede Legale</dhv:label></a>
</td>
</tr>
</table>



<center>
<font size="3px">Storico cambi</font><br/>
<input type="radio" name="asl" id="tutti" value="tutti" checked onClick="filtra('tutti')"> TUTTI
<input type="radio" name="asl" id="stessa" value="stessa" onClick="filtra('stessa')"> STESSA ASL 
<input type="radio" name="asl" id="diversa" value="diversa" onClick="filtra('diversa')"> ASL DIVERSA  
<br/><br/>

<table width="100%" class="storico" id="storico" cellpadding="10" cellspacing="10">

<tr><th>RAGIONE SOCIALE</th><th>PARTITA IVA</th><th>DATA CAMBIO</th><th>UTENTE</th><th>INDIRIZZO PRE MODIF.</th><th>INDIRIZZO POST MODIF.</th> <th>ASL PRE MODIF.</th><th>ASL POST MODIF.</th></tr>


<% for (int i = 0; i<listaStorico.size(); i++){ 

	String ris = (String)listaStorico.get(i);
	String res[] = ris.split(";;");
	
	
	String ragioneSociale = res[0];
	String partitaIva = res[1];
	String data = res[2];
	String idStab = res[3];
	String idAslVecchia = res[4];
	String idAslNuova = res[5];
	String indirizzoVecchio = res[6];
	String indirizzoNuovo = res[7];
	String idUtente = res[8];
	

%>

<tr class="<%=(idAslVecchia.equals(idAslNuova)) ? "stessa" : "diversa" %>">
<td><%=ragioneSociale %></td>
<td><%=partitaIva %></td>
<td><%=fixData(data) %></td>
<td> <dhv:username id="<%=idUtente %>"></dhv:username></td>
<td><%=indirizzoVecchio %></td>
<td><%=indirizzoNuovo %></td>
<td <%=(idAslVecchia.equals(idAslNuova)) ? "colspan=\"2\"" : "" %>><%=AslList.getSelectedValue(idAslVecchia) %></td>
<td <%=(idAslVecchia.equals(idAslNuova)) ? "style=\"display:none\"" : "" %>><%=AslList.getSelectedValue(idAslNuova) %></td>

</tr>

<%} %>

</table>

</center>