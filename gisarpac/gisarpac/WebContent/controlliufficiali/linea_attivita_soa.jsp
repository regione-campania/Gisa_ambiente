
<div style = "display:none">
	<tr id="rigaATECO" >
        <td nowrap class="formLabel">
            <dhv:label name="">Linea Attività Sottoposta a Controllo</dhv:label>
                     
          
          </td>
          <td>
          		
          		<input type = "hidden" name = "num_linee" id = "num_linee" value = "0"/>
          	   <input type = "hidden" name = "tipo_selezione" id = "tipo_selezione" value = "false"/>
		       <table class = "noborder">
		       <tr id = "la_stab_soa" style="display: none">
		       <td>
		       <input type = "text" readonly="readonly" id ="codici_selezionabili" size = "80"  name = "codici_selezionabili" title="Qualora siano state controllate più linee attività occorre inserire controlli ufficiali (uno per ogni linea attività).">
		       <br>
		         <input type = "text" name = "alertText" id = "alertText" value = "<%=toHtml(TicketDetails.getDescrizioneCodiceAteco())%>" readonly="readonly" size="80" title="Qualora siano state controllate più linee attività occorre inserire controlli ufficiali (uno per ogni linea attività).">
	
		       </td>
		       </tr>
		       </table>
		        
		      <a id = "link_seleziona" href = "javascript:popLookupSelectorCustomSOACU('codici_selezionabili','alertText','lookup_codistat','','<%=OrgDetails.getOrgId() %>',document.getElementById('tipo_selezione').value);"><label id = "lab_linea">Seleziona una voce </label></a>
         	<font color = "red">*</font>
          </td>
	</tr>
	
	</div>