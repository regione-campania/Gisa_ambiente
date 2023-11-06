 <script type="text/javascript">
function openPopupChecklistPdf(idAudit){
	var res;
	var result;
	
	window.open('GestioneDocumenti.do?command=GeneraPDFChecklist&id='+idAudit+'&tipo=Checklist','popupSelect',
	'toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=no,resizable=no ,modal=yes');
} 


function openRichiestaPDF_Checklist(idAudit){
	var res;
	var result=
		window.open('GestioneDocumenti.do?command=GeneraPDFChecklist&id='+idAudit+'&tipo=Checklist','popupSelect',
		'height=200px,width=842px,left=200px, top=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		var text = document.createTextNode('GENERAZIONE PDF IN CORSO.');
		span = document.createElement('span');
		span.style.fontSize = "30px";
		span.style.fontWeight = "bold";
		span.style.color ="#ff0000";
		span.appendChild(text);
		var br = document.createElement("br");
		var text2 = document.createTextNode('Attendere la generazione del documento... (potrebbe richiedere qualche secondo)');
		span2 = document.createElement('span');
		span2.style.fontSize = "20px";
		span2.style.fontStyle = "italic";
		span2.style.color ="#000000";
		span2.appendChild(text2);
		result.document.body.appendChild(span);
		result.document.body.appendChild(br);
		result.document.body.appendChild(span2);
		result.focus();
	}
</script>

 <input type="button" value="Stampa Scheda Check List"	onClick='javascript:openRichiestaPDF_Checklist(<%=Audit.getId() %>)'>