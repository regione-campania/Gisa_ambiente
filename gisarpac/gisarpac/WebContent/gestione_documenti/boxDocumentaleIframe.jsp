<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
      	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<script type="text/javascript">

	
function catturaHtml(form){
	h=document.getElementById(form.iframeId.value).contentWindow.document.documentElement.outerHTML;
	form.htmlcode.value = h;
	
}

var popupStampa;
function openPopup(form){
	 popupStampa=
		window.open('','popupStampa2',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		
	var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
	span = document.createElement('span');
	span.style.fontSize = "30px";
	span.style.fontWeight = "bold";
	span.style.color ="#ff0000";
	span.appendChild(text);
	var br = document.createElement("br");
	var text2 = document.createTextNode('Attendere la generazione del documento entro qualche secondo...');
	span2 = document.createElement('span');
	span2.style.fontSize = "20px";
	span2.style.fontStyle = "italic";
	span2.style.color ="#000000";
	span2.appendChild(text2);
	popupStampa.document.body.appendChild(span);
	popupStampa.document.body.appendChild(br);
	popupStampa.document.body.appendChild(span2);
	popupStampa.focus();
}

function closePopup(){
	document.getElementById("generaPDF").disabled = true;
	setTimeout(function(){document.getElementById("generaPDF").disabled = false; popupStampa.close();},5000);
	}

</script>

 
</head>
<body>
<form>
</form>



<body>

<form name="gestionePdf" action="GestioneDocumenti.do?command=GeneraPDFdaHtml" method="POST">
<img src="images/icons/stock_print-16.gif" border="0" align="absmiddle" height="16" width="16"/>
<input type="button" id ="generaPDF" class="buttonClass"  value="Stampa scheda" 	
onClick="catturaHtml(this.form); openPopup(this.form); this.form.submit(); return closePopup();" />
<input type="hidden" name="orgId" id="orgId" value=""></input>
<input type="hidden" name="ticketId" id="ticketId" value=""></input>
<input type="hidden" name="tipo" id="tipo" value="<%=request.getParameter("tipo") %>"></input>
<input type="hidden" name="idCU" id="idCU" value=""></input>
<input type="hidden" name="url" id="url" value=""></input>
<input type="hidden" name="extra" id="extra" value=""></input>
<input type="hidden" name="altId" id="altId" value="<%=request.getParameter("altId") %>"></input>
<input type="hidden" name="stabId" id="stabId" value="<%=request.getParameter("stabId") %>"></input>
<input type="hidden" name="iframeId" id="iframeId" value="<%=request.getParameter("iframeId") %>"></input>
<input type="hidden" name="htmlcode" id="htmlcode" value=""></input>
</form>
</body>
</html>