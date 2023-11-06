<script type='text/javascript' src='dwr/engine.js'></script>
<script type='text/javascript' src='dwr/util.js'></script>


<%@page import="java.net.URLEncoder"%>
<%@page import="crypto.nuova.gestione.ClientSCAAesServlet"%>


<% 
String urlVaf = (String)request.getAttribute("urlVaf");
%>

<body>
<iframe id="frameA"  frameborder="0"  vspace="0"  
	hspace="0" marginwidth="0" marginheight="0"
	scrolling="auto"
	width="100%"  scrolling=yes  height="800"
	style="BORDER-RIGHT: black 1px solid; BORDER-TOP: black 1px solid; Z-INDEX: 999; BORDER-LEFT: black 1px solid; BORDER-BOTTOM: black 1px solid;"
	src="${urlVaf}">
</iframe>
</body>


