<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="operatorinonaltrove/opnonaltrove.js"></SCRIPT>


<script>

function showHide(name,namefs){
	  var elem = document.getElementById(name);
			if (elem.style.display=='none')
				{
			    	elem.style.display='inline-block';
			    	if(namefs != undefined)
						document.getElementById(namefs).style.display = 'inline-block';
				}
			    else
			    {
			    	elem.style.display='none';
			    	if(namefs != undefined)
			    		document.getElementById(namefs).style.display = 'none';
			    }
return false;
}

function hide(name,namefs){
	  var elem = document.getElementById(name);
		elem.style.display='none';
	
	 document.getElementById(namefs).style.display = 'none';
return false;
}

function goTo(link){
	
	if (link=='')
		alert('da implementare');
	else{
		loadModalWindow();
		window.location.href=link;
	}
	
	return false;
}

function scrollPage() {
	window.scrollBy(0,400); // horizontal and vertical scroll increments

}

 




</script>
 <center>
 <input type="button" class="lightGreyBigButton" style="height:50px !important; width:175px !important;" value="Aggiungi" onClick="showHide('stabilimenti_nonscia_add','fs_add'); hide('stabilimenti_nonscia_search','fs_ric'); scrollPage();"/>
 <input type="button" class="lightGreyBigButton" style="height:50px !important; width:175px !important;" value="Ricerca" onClick="showHide('stabilimenti_nonscia_search','fs_ric'); hide('stabilimenti_nonscia_add','fs_add'); scrollPage();"/>
 <dhv:permission name = "gestione_noscia-view">
 	<input type="button" class="lightGreyBigButton" style="height:50px !important; width:190px !important; text-align: left;" value="Gestione no-scia" onClick="location.href='GisaNoScia.do?command=Default'"/>
 </dhv:permission> 
 </center>
 
 </hr>
 
  
 <center>
 <fieldset id="fs_add" style="display : none">
 <legend><b>AGGIUNGI</b></legend>
<table id="stabilimenti_nonscia_add" style="display:none">
	
	
	<tr>
		<dhv:permission name="molluschi-molluschi-add">
		<td colspan="4">
		<input type="button" class="lightGreyBigButton" value="Molluschi bivalvi" style="height:50px !important; width:350px !important;" onClick="goTo('MolluschiBivalvi.do?command=Add')">
		</td>
		</dhv:permission>
		
			<dhv:permission name="concessionari-concessionari-add">
		<td colspan="4">
		<input type="button" class="lightGreyBigButton" value="Concessionari" style="height:50px !important; width:350px !important;" onClick="goTo('Concessionari.do?command=Add')">
		</td>
		</dhv:permission>

		
	</tr>
	
	<tr>
		<dhv:permission name="trasportoanimali-trasportoanimali-add">
		<td colspan="4">
		<input type="button" class="lightGreyBigButton" value="Trasporto Animali" style="height:50px !important; width:350px !important;" onClick="goTo('TrasportoAnimali.do?command=ScegliRichiesta')">
		</td>
		</dhv:permission>
		<dhv:permission name="operatoriprivati-operatoriprivati-add">
		<td colspan="4">
		<input type="button" class="lightGreyBigButton" value="Privati" style="height:50px !important; width:350px !important;" onClick="goTo('Operatoriprivati.do?command=Add')">
		</td>
		</dhv:permission>
	</tr>


	<tr>
		<dhv:permission name="abusivismi-abusivismi-add">
		<td colspan="4">
		<input type="button" class="lightGreyBigButton" value="Operatori abusivi" style="height:50px !important; width:350px !important;" onClick="goTo('Abusivismi.do?command=Add')">
		</td>
		</dhv:permission>
		<dhv:permission name="operatoriregione-operatoriregione-add">
		<td colspan="4">
		<input type="button" class="lightGreyBigButton" value="Att. e distributori fuori ambito asl" style="height:50px !important; width:350px !important;" onClick="goTo('OperatoriFuoriRegione.do?command=Add&tipoD=Autoveicolo')">
		</td>
		</dhv:permission>
	</tr>

	<tr>
		<dhv:permission name="punti_di_sbarco-add">
		<td colspan="4">
		<input type="button" class="lightGreyBigButton" value="Punti di sbarco" style="height:50px !important; width:350px !important;" onClick="goTo('PuntiSbarco.do?command=Add')">
		</td>
		</dhv:permission>
		<% boolean hasPermissionAdd = false; %>
    	<dhv:permission name="operatorinonaltrove-operatorinonaltrove-add">
  		<% hasPermissionAdd = true;%>
		</dhv:permission>
		<td colspan="4">
		<% if (hasPermissionAdd){ %>
			<input type="button" class="lightGreyBigButton" value="Altri oper. non presenti altrove" style="height:50px !important; width:350px !important;" onClick="goTo('OpnonAltrove.do?command=Add')">
		<% }else{ %>
			<input type="button" class="lightGreyBigButton" value="Altri oper. non presenti altrove" style="height:50px !important; width:350px !important;" onClick="popupAggiunta(); return false;">
		<% } %>
		</td>
	</tr>
	
	<tr>
	    <dhv:permission name="imbarcazioni-imbarcazioni-add">
		<td colspan="4">
		<input type="button" class="lightGreyBigButton" value="Imbarcazioni" style="height:50px !important; width:350px !important;" onClick="goTo('Imbarcazioni.do?command=Add')">
		</td>
		</dhv:permission>
		
	</tr>
</table>
</fieldset>
<fieldset id="fs_ric" style="display : none">
<legend><b>RICERCA</b></legend>
<table id="stabilimenti_nonscia_search" style="display:none"> 
	 
	<%-- <tr>
		<td colspan="4">
		<input type="button" class="lightGreyBigButton" value="Molluschi bivalvi" style="height:50px !important; width:350px !important;" onClick="goTo('MolluschiBivalvi.do')">
		</td>
		<td colspan="4">
				<input type="button" class="lightGreyBigButton" value="Concessionari" style="height:50px !important; width:350px !important;" onClick="goTo('Concessionari.do?command=SearchForm')">
		
		</td>
	</tr>
	--%>
	

	<tr>
		<td colspan="4">
		<input type="button" class="lightGreyBigButton" value="Trasporto Animali" style="height:50px !important; width:350px !important;" onClick="goTo('TrasportoAnimali.do')">
		</td>
		<td colspan="4">
		<input type="button" class="lightGreyBigButton" value="Privati" style="height:50px !important; width:350px !important;" onClick="goTo('Operatoriprivati.do?command=SearchForm')">
		</td>
	</tr>

	<tr>
		<!--td colspan="4">
		<input type="button" class="lightGreyBigButton" value="Imbarcazioni" style="height:50px !important; width:350px !important;" onClick="goTo('Imbarcazioni.do')">
		</td-->
		<td colspan="4">
		<input type="button" class="lightGreyBigButton" value="Operatori abusivi" style="height:50px !important; width:350px !important;" onClick="goTo('Abusivismi.do')">
		</td>
		<td colspan="4">
		<input type="button" class="lightGreyBigButton" value="Att. e distributori fuori ambito asl" style="height:50px !important; width:350px !important;" onClick="goTo('OperatoriFuoriRegione.do?command=SearchForm')">
		</td>
	</tr>

	<tr>
		<%-- <td colspan="4">
		<input type="button" class="lightGreyBigButton" value="Punti di sbarco" style="height:50px !important; width:350px !important;" onClick="goTo('PuntiSbarco.do?command=SearchForm')">
		</td>
		--%>
		<td colspan="4">
		<input type="button" class="lightGreyBigButton" value="Altri oper. non presenti altrove" style="height:50px !important; width:350px !important;" onClick="goTo('OpnonAltrove.do')">
		</td>
	</tr>
	<!-- tr>
		<td colspan="4">
		<input type="button" class="lightGreyBigButton" value="Operatori abusivi" style="height:50px !important; width:350px !important;" onClick="goTo('Abusivismi.do')">
		</td>
		<td colspan="4">
		&nbsp;
		</td>
	</tr-->
</table>
</fieldset>
 </center>
