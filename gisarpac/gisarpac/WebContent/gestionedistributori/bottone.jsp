<% 
int riferimentoId = Integer.parseInt(request.getParameter("riferimentoId"));
String riferimentoIdNomeTab = request.getParameter("riferimentoIdNomeTab");
%>

<script>
function openPopupDistributori(url){
	var res;
	var result;
		window.open(url,'popupSelectDistributori',
		'height=400px,width=1300px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=no ,modal=yes');
		
}
</script>

<input style="width:250px" value="Gestione Distributori" type="button" onClick="openPopupDistributori('GestioneDistributori.do?command=View&riferimentoId=<%=riferimentoId%>&riferimentoIdNomeTab=<%=riferimentoIdNomeTab%>');return false;"/>
