<%@ page import="org.json.*"%>
<jsp:useBean id="jsonNonCampionate" class="org.json.JSONArray" scope="request"/>

<script>
function blinker()
{
  if(document.getElementById("blink"))
  {
      var d = document.getElementById("blink") ;
      d.style.color= (d.style.color=='red'?'white':'red');
      setTimeout('blinker()', 500);
  }
}
</script>


<body onload="blinker();">


<font color="red" size="10px">
<div id="blink"><b>Di seguito la lista di subparticelle mai sottoposte a campionamento.</b></div>
</font>

<br/><br/>

<table class="details" cellpadding="10" cellspacing="10" width="50%">
<tr><th style="text-align: center !important">AREA</th><th style="text-align: center !important">SUBPARTICELLE</th></tr>

<% 
JSONArray jsonAree = jsonNonCampionate;
if (jsonAree.length()>0) {
	for (int i = 0; i<jsonAree.length(); i++) { 
		JSONObject jsonArea = (JSONObject) jsonAree.get(i);
		JSONArray jsonSubparticelle = (JSONArray) jsonArea.get("Subparticelle");%>
		<tr><td align="center"><a href="Terreni.do?command=DetailsArea&id=<%=jsonArea.get("riferimentoId") %>"><%=jsonArea.get("codiceSito") %></a></td><td align="center"><b>(<%=jsonSubparticelle.length() %>)</b><br/>
		<% for (int k = 0; k<jsonSubparticelle.length(); k++) {
			JSONObject jsonSubparticella = (JSONObject) jsonSubparticelle.get(k);%>
			<a href="Terreni.do?command=DetailsSubparticella&id=<%=jsonSubparticella.get("riferimentoId") %>"><%=jsonSubparticella.get("codiceSito") %></a><br/>
		<% } }%>
		</td></tr>
		<% } else {%>
				<tr><td align="center" colspan="2">Non sono presenti subparticelle.</td></tr>  
		<% } %>
</table>

</body>