
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></script>

<div align="left">
	<img src="images/tree0.gif" border="0" align="absmiddle" height="16" width="16" />
	<a href="javascript:popLookupSelectorCustomZone('15','<%=OrgDetails.getSiteId()%>');"><dhv:label name="">Seleziona Operatore</dhv:label></a>
</div>
<body onload="javascript:document.getElementById('dim').value=0;">

<table cellpadding="7" cellspacing="0" width="70%" class="details" id="tblClone_ps">
  <tr>
    <th colspan="6">
      <strong><dhv:label name="">Lista Zone controllate</dhv:label></strong>
    </th>
  </tr>
  <tr>
	<th >Denominazione</th>
    <th>Comune</th>
	<th>Note</th>
    <th>Azione</th>
	</tr>  
	<tr style="display: none">
	 	<td><p></p>
	 		<input type="hidden" name="org_id_op" id="org_id_op" value="" />
	 	</td>
	 	
	 	<td><p></p>
	 	</td>
	 	
	 	<td><p></p>
	 	</td>
	 
	 	<td>
	 	<p><a href="javascript:eliminaOperatore()" id="elimina">Elimina</a></p>
	 	</td>
	 	
	 </tr>
</table>	
<input type="hidden" name="dim" id="dim" value ="0">
</body>
  