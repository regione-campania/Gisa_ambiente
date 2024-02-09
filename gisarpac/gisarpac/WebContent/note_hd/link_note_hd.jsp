<% 
int riferimentoId = Integer.parseInt(request.getParameter("riferimentoId"));
String riferimentoIdNomeTab = request.getParameter("riferimentoIdNomeTab");
String typeView = request.getParameter("typeView");
%>

<script>
function openPopupNote(url){
	var res;
	var result;
		window.open(url,'popupSelect',
		'height=400px,width=1300px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=no ,modal=yes');
		
}
</script>

<%
	if(typeView!=null && typeView.equals("button"))
	{
%>
		<input style="width:250px" value="Visualizza Note HD" type="button" onClick="openPopupNote('note_hd/note_hd.jsp?riferimentoId=<%=riferimentoId%>&riferimentoIdNomeTab=<%=riferimentoIdNomeTab%>');return false;"/>
<%
	}
	else
	{
%>
		<center><a href="#" onClick="openPopupNote('note_hd/note_hd.jsp?riferimentoId=<%=riferimentoId%>&riferimentoIdNomeTab=<%=riferimentoIdNomeTab%>');return false;">Visualizza Note HD</a></center>
<%
	}
%>