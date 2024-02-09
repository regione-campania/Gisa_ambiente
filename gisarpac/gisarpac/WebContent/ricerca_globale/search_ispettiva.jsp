<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio"%>

<jsp:useBean id="SiteList" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean"
	scope="session" />

<%@ include file="../initPage.jsp"%>


<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>

<script>
function checkRicerca(form){
	if (form.tipoRicerca.value=='GiornataIspettiva'){
		form.idGiornataIspettiva.style.display="table-row";
		form.idFascicoloIspettivo.style.display="none";
		form.idFascicoloIspettivo.value="";
	} else if (form.tipoRicerca.value=='FascicoloIspettivo'){
		form.idFascicoloIspettivo.style.display="table-row";
		form.idGiornataIspettiva.style.display="none";
		form.idGiornataIspettiva.value="";
	}
}

function checkForm(form){

	if (form.tipoRicerca.value == 'GiornataIspettiva' && isNaN(form.idGiornataIspettiva.value)) {
		alert('Indicare un Id Giornata Ispettiva valido.');
		return false;
	}
	
	if (form.tipoRicerca.value == 'GiornataIspettiva' && form.idGiornataIspettiva.value.trim()=='')
	{
		alert('Indicare Id Giornata Ispettiva.');
		return false;
	}
	
	if (form.tipoRicerca.value == 'FascicoloIspettivo' && isNaN(form.idFascicoloIspettivo.value)) {
		alert('Indicare un Id Fascicolo Ispettivo valido.');
		return false;
	}
	
	if (form.tipoRicerca.value == 'FascicoloIspettivo' && form.idFascicoloIspettivo.value.trim()=='')
	{
		alert('Indicare Id Fascicolo Ispettivo.');
		return false;
	}
	
	loadModalWindow();
	form.submit();
}
</script>

<table class="trails" cellspacing="0">
<tr><td>Ricerca</td></tr>
</table>

<form name="searchAccount"action="RicercaGlobale.do?command=SearchIspettiva" method="post">
	
<table class="details" cellspacing="20" cellpadding="20">
	
<tr>
<td class="formLabel">
<select id="tipoRicerca" name="tipoRicerca" onChange="checkRicerca(this.form)">
<option value="GiornataIspettiva" selected>Giornata Ispettiva</option>
<option value="FascicoloIspettivo">Fascicolo Ispettivo</option>
</select></td>
<td>
<input type="text" id="idGiornataIspettiva" name="idGiornataIspettiva" value=""/>
<input type="text" id="idFascicoloIspettivo" name="idFascicoloIspettivo" value="" style="display:none"/>

</td>
</tr>

<tr><td colspan="2"><input type="button" value="ricerca" onClick="checkForm(this.form)"/></td></tr>
	
</table>

</form>





