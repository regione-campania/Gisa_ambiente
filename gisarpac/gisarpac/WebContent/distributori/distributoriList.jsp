

<table class="trails" cellspacing="0">
<tr>
<td>
<!-- <a href="AltriOperatori.do?command=DashboardScelta">Operatori</a> > -->
<a href="Distributori.do?command=ScegliD"> Scelta Operatore </a> >

Gestione Distributori Automatici

</td>
</tr>
</table>
	<head>
		<link rel="stylesheet" type="text/css" href="css/jmesa.css"></link>
		
		<script type="text/javascript" src="javascript/jquery.bgiframe.pack.js"></script>
		<script type="text/javascript" src="javascript/jquery.jmesa.js"></script>
		<script type="text/javascript" src="javascript/jmesa.js"></script>
	</head>

<center>
		<p>
			Utilizzare le caselle vuote sopra l'intestazione per filtrare per anno, richiedente, ragione sociale, capo e/o rapporto
		</p>
		<form name="aiequidiForm" action="DistributoriList.do">
	       <%=request.getAttribute( "tabella" )%>
	    </form>

</center>
	<script type="text/javascript">
            function onInvokeAction(id) {
                $.jmesa.setExportToLimit(id, '');
                $.jmesa.createHiddenInputFieldsForLimitAndSubmit(id);
            }
            function onInvokeExportAction(id) {
                var parameterString = $.jmesa.createParameterStringForLimit(id);
                location.href = 'DistributoriList.do?&' + parameterString;
            }
    </script>
