
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></script>

<div align="left">
	<img src="images/tree0.gif" border="0" align="absmiddle" height="16" width="16" />
	<a href="javascript:popLookupSelectorCustomZone('1','<%=OrgDetails.getSiteId()%>');"><dhv:label name="">Seleziona Operatore</dhv:label></a>
</div>
<body onload="javascript:document.getElementById('dim').value="<%=OrgDetails.getOpControllatiList().size()%>">

</body>
<!-- Modificare--- -->
<input type ="hidden" name = "dim" id = "dim" value = "<%=OrgDetails.getOpControllatiList().size() %>">

<table cellpadding="6" cellspacing="0" width="70%" class="details" id="tblClone_ps">
		<th colspan="6" style="background-color: rgb(204, 255, 153);" >
			<strong>
				<dhv:label name=""><center>Lista Zone di Controllo</center></dhv:label>
		    </strong>
		</th>
	    <tr>
   		   <th><b><dhv:label name="">Denominazione</dhv:label></b></th>
   		   <th><b><dhv:label name="">Citta</dhv:label></b></th>
   		   <th>Note</th>
     
   		   <th><b><dhv:label name="">Azione</dhv:label></b></th>  	   
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
       
   <%
   			
   int cont_ps=0;
   Iterator op_ps = OrgDetails.getOpControllatiList().iterator();
   if (op_ps.hasNext()) {
     while (op_ps.hasNext()) {
    	 ++cont_ps;
    	 org.aspcfs.modules.zonecontrollo.base.Organization thisOpPs = (org.aspcfs.modules.zonecontrollo.base.Organization)op_ps.next();
    %> 
   <tr id="riga_ps<%=(cont_ps)%>" >
    <td>
     <%= thisOpPs.getName() %>
    	<p>
    		<input type="hidden" name= "org_id_op_<%=(cont_ps) %>_<%=(cont_ps) %>" id="org_id_op_<%=(cont_ps) %>" value="<%=thisOpPs.getOrgId()%>" />
    	</p>
    
    </td>
    <td>
    <%= thisOpPs.getAddressList().getAddress(5).getCity() %>
    </td>
     <td>
    <%= thisOpPs.getAlert() %>
    </td>
   
	<td>
	 	<p><a href="javascript:eliminaOperatore('<%=(cont_ps) %>')" id="elimina_<%=(cont_ps) %>">Elimina</a></p>
	</td>
	
   </tr>
   <% } %>
       
  <% } %>
<%--    
  <% else { %>
   <tr class="containerBody">
      <td colspan="4">
        <dhv:label name="">Nessun Elenco Operatori Controllati.</dhv:label>
      </td>
   </tr>
   <%}%> 
  --%>
 </table>	  
	
  