<script type='text/javascript' src='dwr/engine.js'></script>
<script type='text/javascript' src='dwr/util.js'></script>
<%@page import="java.net.URLEncoder"%>
<%@page import="crypto.nuova.gestione.ClientSCAAesServlet"%>


<!-- Action   <input id="action"               type="text"   value="Index"><br/>
Token    <input id="token"                type="text"   value="" style="width: 50%;"> <br/>
Username <input id="username"             type="text"   value="admin"> <br/>
         <input id="rigeneraTokenButton"  type="button" value="Rigenera Token" onclick="rigeneraToken(document.getElementById('username').value)"/> <br/>
<input type="button" onclick="chiamaVamEmbedded()" value="Chiama VAF">
-->


<% 
String urlVaf = (String)request.getAttribute("urlVaf");
%>



<%-- Trails intelligente--%>
<%
try {
		String altId = "";
		String titoloPagina = "";
		String urlSpecifica = urlVaf.substring(urlVaf.indexOf("action="), urlVaf.length());
		
		 if (urlSpecifica.contains("noscia.stabilimento.ToEdit")) { 
		
		 	titoloPagina = urlSpecifica.substring(urlSpecifica.indexOf("ToEdit")+6, urlSpecifica.indexOf(".us?"));
		 	altId = urlSpecifica.substring(urlSpecifica.indexOf("alt_id=")+7, urlSpecifica.length());
		 	
		 	if (altId.contains("&"))
		 		altId = altId.substring(0, altId.indexOf("&"));
		
		%>
		
		<table class="trails" cellspacing="0">
			<tr>
			<td>
			<a href="#">Gestione Anagrafica</a> >
			<a href="GestioneAnagraficaAction.do?command=Details&altId=<%=altId%>">Scheda Anagrafica</a> > <%=titoloPagina.replaceAll("(.)([A-Z])", "$1 $2") %>
			</td>
			</tr>
			</table>
		
		<% } } catch (Exception e) {}%>
<%-- Trails intelligente--%>

<body>
<iframe id="frameA" name="frameA" frameborder="0"  vspace="0"  
	hspace="0" marginwidth="0" marginheight="0"
	scrolling="no" onload="resizeIframe(this)"
	width="100%"  
	style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; Z-INDEX: 999; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid;"
	src="${urlVaf}"
	 style="-webkit-transform:scale(0.5);-moz-transform-scale(0.5);">
</iframe>
</body>


<script>
  function resizeIframe(obj) {
    obj.style.height = obj.contentWindow.document.body.scrollHeight + 'px';
  }
</script>
