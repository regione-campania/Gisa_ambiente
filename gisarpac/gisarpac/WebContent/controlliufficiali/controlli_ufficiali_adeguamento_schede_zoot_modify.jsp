<jsp:useBean id="AzDetails" class="org.aspcf.modules.controlliufficiali.base.AziendeZootFields" scope="request"/>

<script type="text/javascript">
function checkIntValue(value,name){

	if (isNaN(value)) { 
		alert ('Errore il campo '+name+' pu� contenere solo valori numerici!');
		return false;
	}

}
</script>
 
 
<!--  Allegato 1 -->	
<% if(OrgDetails.getCodice_specie() == 131 ) { %>
<table cellpadding="4" cellspacing="0" width="100%" class="details">
	<tr>
		<th colspan="2"><strong><dhv:label name="">Adeguamento Schede zootecniche: Galline Ovaiole</dhv:label></strong>
		</th>
	</tr>
	<tr class="containerBody">
		<td nowrap class="formLabel">N. ovaiole: capacit� massima</td>
		<td>
		<table class="noborder">
			<tr>
				<td><input type="text" value="<%=AzDetails.getCap_max_animali() %>" size="4" name="cap_max_animali" onblur="javascript: return checkIntValue(value,'N.ovaiole: capacit� massima');"></td>
			</tr>
		</table>
		</td>
	</tr>
	
	<tr class="containerBody">
		<td nowrap class="formLabel">N. ovaiole presenti all'atto dell'ispezione</td>
		<td>
		<table class="noborder">
			<tr>
				<td><input type="text" value="<%=AzDetails.getNum_animali_isp()%>"  size="4" name="num_animali_isp" onblur="javascript:checkIntValue(value,name);"></td>
			</tr>
		</table>
		</td>
	</tr>

	<tr class="containerBody">
		<td nowrap class="formLabel">N. totale capannoni</td>
		<td>
		<table class="noborder">
			<tr>
				<td><input type="text" value="<%=AzDetails.getNum_tot_capannoni() %>"  size="4" name="num_tot_capannoni" onblur="javascript:checkIntValue(value,name);" ></td>
			</tr>
		</table>
		</td>
	</tr>

	<tr class="containerBody">
		<td nowrap class="formLabel">N. totale capannoni attivi</br>
		all'atto dell'ispezione</td>
		<td>
		<table class="noborder">
			<tr>
				<td><input type="text" value="<%=AzDetails.getNum_tot_capannoni_isp()%>"  size="4"name="num_tot_capannoni_isp" onblur="javascript:checkIntValue(value,name);"></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr class="containerBody">
		<td nowrap class="formLabel">Metodo di allevamento
		<td>
		<table class="noborder">
			<tr>
				<td>all'aperto <input type="radio" value="0" name="metodo_allevamento" <% if(AzDetails.getMetodo_allevamento()!=null &&  !AzDetails.getMetodo_allevamento().equals("") && !AzDetails.getMetodo_allevamento().equalsIgnoreCase("null") && AzDetails.getMetodo_allevamento().contains("aperto")) { %> checked="checked" <% } %> /></td>
				<td>a terra <input type="radio" value="1" name="metodo_allevamento" <% if ( AzDetails.getMetodo_allevamento()!=null &&  !AzDetails.getMetodo_allevamento().equals("") && !AzDetails.getMetodo_allevamento().equalsIgnoreCase("null") && AzDetails.getMetodo_allevamento().contains("terra")) {  %> checked= "checked" <% } %> /></td>
				<td>biologico <input type="radio" value="2" name="metodo_allevamento" <% if ( AzDetails.getMetodo_allevamento()!=null &&  !AzDetails.getMetodo_allevamento().equals("") && !AzDetails.getMetodo_allevamento().equalsIgnoreCase("null") && AzDetails.getMetodo_allevamento().contains("biologico")) { %> checked= "checked" <% } %> /></td>
				<td>in gabbia <input type="radio" value="3" name="metodo_allevamento" <% if (AzDetails.getMetodo_allevamento()!=null &&  !AzDetails.getMetodo_allevamento().equals("") && !AzDetails.getMetodo_allevamento().equalsIgnoreCase("null") && AzDetails.getMetodo_allevamento().contains("Gabbia")) { %> checked ="checked" <% } %> /></td> 
				<td> N.capannoni con gabbie modificate <input type="text" value="<%=AzDetails.getNum_capannoni_con_gabbie()%>"  size="4"name="num_capannoni_con_gabbie" onblur="javascript:checkIntValue(value,name);">
				<br>N.capannoni con gabbie NON modificate <input type="text" value="<%=AzDetails.getNum_capannoni_non_gabbie()%>"  size="4"name="num_capannoni_non_gabbie" onblur="javascript:checkIntValue(value,name);"></td>
			</tr>
		</table>
		</td>
	</tr>
	
	</table>
<br>
<br>	
<% } else if(OrgDetails.getCodice_specie() == 122) { %>	

<!--  Allegato 2 -->
<table cellpadding="4" cellspacing="0" width="100%" class="details">
	<tr>
		<th colspan="2"><strong><dhv:label name="">Adeguamento Schede zootecniche: Suini</dhv:label></strong>
		</th>
	</tr>
	
	<tr class="containerBody">
		<td nowrap class="formLabel">N. totale capannoni</td>
		<td>
		<table class="noborder">
			<tr>
				<td><input type="text" value="<%=AzDetails.getNum_tot_capannoni() %>"  size="4"name="num_tot_capannoni" onblur="javascript:checkIntValue(value,name);"></td>
			</tr>
		</table>
		</td>
	</tr>

	<tr class="containerBody">
		<td nowrap class="formLabel">N. totale capannoni attivi</br>
		all'atto dell'ispezione</td>
		<td>
		<table class="noborder">
			<tr>
				<td><input type="text" value="<%=AzDetails.getNum_tot_capannoni_isp() %>"  size="4"name="num_tot_capannoni_isp" onblur="javascript:checkIntValue(value,name);"></td>
			</tr>
		</table>
		</td>
	</tr>

	<tr class="containerBody">
		<td nowrap class="formLabel">N. totale box
		<td>
		<table class="noborder">
			<tr>
				<td><input type="text" value="<%=AzDetails.getNum_tot_box() %>"  size="4"name="num_tot_box"></td>
			</tr>
		</table>
		</td>
	</tr>
	
	<tr class="containerBody">
		<td nowrap class="formLabel">N. totale box attivi<br> all'atto dell'ispezione
		<td>
		<table class="noborder">
			<tr>
				<td><input type="text" value="<%=AzDetails.getNum_tot_box_isp() %>"  size="4"name="num_tot_box_isp" onblur="javascript:checkIntValue(value,name);"></td>
			</tr>
		</table>
		</td>
	</tr>
	
	<tr class="containerBody">
		<td nowrap class="formLabel">Specie
		<td>
		<table class="noborder">
			<tr>
				<td>Verri:</td> <td>capacit� massima <input type="text" value="<%=AzDetails.getCap_max_verri()%>"  size="4"name="cap_max_verri" onblur="javascript:checkIntValue(value,name);"></td> <td>presenti all'atto dell'ispezione <input type="text" value="<%=AzDetails.getNum_verri_isp()%>"  size="4"name="num_verri_isp" onblur="javascript:checkIntValue(value,name);"></td>
			</tr>
			<tr>
				<td>Scrofe e scrofette:</td> <td>capacit� massima <input type="text" value="<%=AzDetails.getCap_max_scrofe_scrofette()%>"  size="4"name="cap_max_scrofe_scrofette" onblur="javascript:checkIntValue(value,name);"> </td> <td>presenti all'atto dell'ispezione <input type="text" value="<%=AzDetails.getNum_scrofe_scrofette_isp()%>"  size="4"name="num_scrofe_scrofette_isp" onblur="javascript:checkIntValue(value,name);"></td>
			</tr>
			<tr>
				<td>Lattonzoli:</td> <td>capacit� massima <input type="text" value="<%=AzDetails.getCap_max_lattonzoli()%>"  size="4"name="cap_max_lattonzoli" onblur="javascript:checkIntValue(value,name);"></td> <td>presenti all'atto dell'ispezione <input type="text" value="<%=AzDetails.getNum_lattonzoli_isp()%>"  size="4"name="num_lattonzoli_isp" onblur="javascript:checkIntValue(value,name);"></td>
			</tr>
			<tr>
				<td>Suinetti:</td> <td>capacit� massima <input type="text" value="<%=AzDetails.getCap_max_suinetti()%>"  size="4"name="cap_max_suinetti" onblur="javascript:checkIntValue(value,name);"> </td> <td>presenti all'atto dell'ispezione <input type="text" value="<%=AzDetails.getNum_suinetti_isp()%>"  size="4"name="num_suinetti_isp" onblur="javascript:checkIntValue(value,name);"> </td>
			</tr>
			<tr>
				<td>Suini al grasso:</td> <td>capacit� massima <input type="text" value="<%=AzDetails.getCap_max_suini_al_grasso()%>"  size="4"name="cap_max_suini_al_grasso" onblur="javascript:checkIntValue(value,name);"> </td> <td>presenti all'atto dell'ispezione <input type="text" value="<%=AzDetails.getNum_suini_al_grasso_isp()%>"  size="4"name="num_suini_al_grasso_isp" onblur="javascript:checkIntValue(value,name);"></td>
			</tr>
		</table>
		</td>
	</tr>
</table>
<% } else if(OrgDetails.getCodice_specie() == 1211 || OrgDetails.getCodice_specie() == 121) { %>
<br>
<br>
<!--  Allegato 3 -->
<table cellpadding="4" cellspacing="0" width="100%" class="details">
	<tr>
		<th colspan="2"><strong><dhv:label name="">Adeguamento Schede zootecniche: Vitelli</dhv:label></strong>
		</th>
	</tr>
	
	<tr class="containerBody">
		<td nowrap class="formLabel">N. totale dei vitelli presenti</td>
		<td>
		<table class="noborder">
			<tr>
				<td><input type="text" value="<%=AzDetails.getNum_tot_animali_presenti()%>"  size="4"name="num_tot_animali_presenti" onblur="javascript:checkIntValue(value,name);"> &nbsp; N. dei vitelli di et� inf. a 8 settimane <input type="text" value="<%=AzDetails.getNum_tot_vitelli_inf_8_settimane()%>"  size="4"name="num_tot_vitelli_inf_8_settimane" onblur="javascript:checkIntValue(value,name);"> </td>
			</tr>
		</table>
		</td>
	</tr>

	<tr class="containerBody">
		<td nowrap class="formLabel">Capacit� massima vitelli</td>
		<td>
		<table class="noborder">
			<tr>
				<td><input type="text" value="<%=AzDetails.getCap_max_animali()%>"  size="4"name="cap_max_animali" onblur="javascript:checkIntValue(value,name);"></td>
			</tr>
		</table>
		</td>
	</tr>
</table>
<br>
<br>
<% } else if(OrgDetails.getCodice_specie() == 1461 || OrgDetails.getCodice_specie() == 146) {%>
<!--  Allegato 5 -->
<table cellpadding="4" cellspacing="0" width="100%" class="details">
	<tr>
		<th colspan="2"><strong><dhv:label name="">Adeguamento Schede zootecniche: Polli da carne</dhv:label></strong>
		</th>
	</tr>

	<tr class="containerBody">
		<td nowrap class="formLabel">N. totale capannoni</td>
		<td>
		<table class="noborder">
			<tr>
				<td><input type="text" value="<%=AzDetails.getNum_tot_capannoni()%>"  size="4"name="num_tot_capannoni" onblur="javascript:checkIntValue(value,name);"></td>
			</tr>
		</table>
		</td>
	</tr>

	<tr class="containerBody">
		<td nowrap class="formLabel">N. totale capannoni attivi</br>
		all'atto dell'ispezione</td>
		<td>
		<table class="noborder">
			<tr>
				<td><input type="text" value="<%=AzDetails.getNum_tot_capannoni_isp()%>"  size="4"name="num_tot_capannoni_isp" onblur="javascript:checkIntValue(value,name);"></td>
			</tr>
		</table>
		</td>
	</tr>

	<tr class="containerBody">
		<td nowrap class="formLabel">N. totale animali presenti</td>
		<td>
		<table class="noborder">
			<tr>
				<td><input type="text" value="<%=AzDetails.getNum_tot_animali_presenti()%>"  size="4"name="num_tot_animali_presenti" onblur="javascript:checkIntValue(value,name);"></td>
			</tr>
		</table>
		</td>
	</tr>

	<tr class="containerBody">
		<td nowrap class="formLabel">Capacit� massima di allevamento autorizzata<br>
		dalla ASL competente per il territorio</td>
		<td>
		<table class="noborder">
			<tr>
				<td>33 kg/mq <input type="radio" value="33" name="cap_max_animali" <% if(AzDetails.getCap_max_animali() == 33) { %> checked="checked"  <% } %> onblur="javascript:checkIntValue(value,name);"/></td>
				<td>39 kg/mq <input type="radio" value="39" name="cap_max_animali" <% if(AzDetails.getCap_max_animali() == 39) { %> checked="checked" <% }  %> onblur="javascript:checkIntValue(value,name);"/></td>
				<td>42 kg/mq <input type="radio" value="42" name="cap_max_animali" <% if(AzDetails.getCap_max_animali() == 42) { %> checked="checked" <% } %> onblur="javascript:checkIntValue(value,name);"/></td>
			</tr>
		</table>
		</td>
	</tr>
	
</table>
<% } %>