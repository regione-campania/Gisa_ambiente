<%@ page import="java.util.ArrayList" %>
<jsp:useBean id="sub" class="org.aspcfs.modules.terreni.base.Subparticella" scope="request"/>

<script type="text/javascript" src="dwr/interface/PopolaCombo.js"> </script>

<script>

function validaNumeri(s) {
	 s.value = s.value.replace(/[^0-9]/g, '');
}

function verificaEsistenzaCodice(codice, id){
	document.getElementById("loadingCodice").style.display = "block";
	PopolaCombo.verificaEsistenzaCodiceSitoParticella(codice, id, {callback:verificaEsistenzaCodiceCallback,async:false });
}
function verificaEsistenzaCodiceCallback(value)
{
if (value)
	{
		 alert("Attenzione. Il codice ottenuto risulta gi� assegnato a un'altra area.");
		 document.getElementById("codiceSito").value = "<%=sub.getCodiceSito()%>";
		 document.getElementById("letteraSito").value = "<%=(sub.getCodiceSito().replace(sub.getArea().getCodiceSito(), "")).substring(0, 1)%>";
<%-- 		 document.getElementById("numeroSito").value = "<%=(sub.getCodiceSito().replace(sub.getArea().getCodiceSito(), "")).substring(1, (sub.getCodiceSito().replace(sub.getArea().getCodiceSito(), "")).length()-1)%>"; --%>
	}

	document.getElementById("loadingCodice").style.display = "none";

}

function gestisciCodiceSito(){
	
	var codiceSitoArea = document.getElementById("codiceSitoArea").value;
	var letteraSito = document.getElementById("letteraSito").value;
	//var numeroSito = document.getElementById("numeroSito").value;
	var codiceSito = codiceSitoArea + letteraSito;
	document.getElementById("codiceSito").value = codiceSito;
	verificaEsistenzaCodice(codiceSito, <%=sub.getId()%>);
	
}
</script>



<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Terreni.do?command=toSearchArea">Terra dei fuochi</a> > 
<a href="Terreni.do?command=DetailsArea&id=<%=sub.getIdPadre()%>">Dettaglio Area</a> > 
<a href="Terreni.do?command=DetailsSubparticella&id=<%=sub.getId()%>">Dettaglio Subparticella</a> > 
Modifica
</td>
</tr>
</table>
<br/>

<br>
<form action="Terreni.do?command=UpdateSubparticella" method="post">

<table class="details" width="100%" cellpadding="5">
<col width="10%">

<tr><th colspan="2">DATI SUBPARTICELLA </th></tr>
<tr> 
	<td class="formLabel">Codice Sito</td> 
	<td>
	<input type="text" readonly id="codiceSitoArea" name="codiceSitoArea" value="<%=sub.getArea().getCodiceSito()%>" style="background: lightgray" size="<%=sub.getArea().getCodiceSito().length()%>"/> 
	<%
	String alfabeto = "ABCDEFGHILMNOPQRSTUVZ";
	char letteraSito = sub.getCodiceSito().replace(sub.getArea().getCodiceSito(), "").charAt(0);
	%>  
	<select id="letteraSito" name="letteraSito" onChange="gestisciCodiceSito()">
	<%for (int i = 0; i<alfabeto.length(); i++){ %>
	<option value="<%=alfabeto.charAt(i)%>" <%=letteraSito == alfabeto.charAt(i) ? "selected" : ""%>><%=alfabeto.charAt(i)%></option>
	<%} %>
	</select>
	
<%-- 	<input type="text" id="numeroSito" name="numeroSito" onChange="gestisciCodiceSito()" onKeyUp="validaNumeri(this)" size="3" maxlength="3" value="<%=(sub.getCodiceSito().replace(sub.getArea().getCodiceSito(), "")).substring(1, (sub.getCodiceSito().replace(sub.getArea().getCodiceSito(), "")).length())%>"/>  --%>
	
	<input type="hidden" id="codiceSito" name="codiceSito" value="<%=sub.getCodiceSito()%>"/> <div id="loadingCodice" style="display:none"><img src="images/loadingmw.gif" width="50px"/></div></td>
</tr>

</table>
<input type="hidden" id="idArea" name="idArea" value="<%=sub.getArea().getId()%>"/>
<input type="hidden" id="id" name="id" value="<%=sub.getId()%>"/>
<br>

<input type="button" value="ANNULLA" onclick="loadModalWindow(); window.location.href='Terreni.do?command=DetailsSubparticella&id=<%=sub.getId()%>'" />

<input type="button" value="AGGIORNA" onclick="checkForm(this.form)" />
</form>

<script>

function checkForm(form){ 
	
		gestisciCodiceSito();
		
		var msg = "Attenzione! La form non puo' essere salvate per i seguenti motivi:\n\n";
		var esito = true;
		
		if (form.codiceSito.value==""){
			msg +="Indicare Codice Sito.\n";
			esito = false;	
		}
				
		if (!esito){
			alert(msg);
			return false;
		}
		
		loadModalWindow();
		form.submit();
}

</script>