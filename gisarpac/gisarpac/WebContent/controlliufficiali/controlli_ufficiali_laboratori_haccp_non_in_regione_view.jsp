<%@page import="java.util.Iterator"%>


<%if (View==null){ %>

<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></script>
<table cellpadding="4" cellspacing="0" width="100%" class="details">
		<th colspan="4" style="background-color: rgb(204, 255, 153);" >
			<strong>
				<dhv:label name=""><center>Lista Laboratori Haccp Non In Regione Controllati</center></dhv:label>
		    </strong>
		</th>
	    <tr>
   		   <th><b><dhv:label name="">Descrizione</dhv:label></b></th>
       </tr>
   <%
   Iterator op_noreg = TicketDetails.getLabNonInRegioneControllatiList().iterator();
   if (op_noreg.hasNext()) {
     while (op_noreg.hasNext()) {
    	 //org.aspcfs.modules.vigilanza.base.Organization thisOp = (org.aspcfs.modules.vigilanza.base.Organization)op.next();
    	 org.aspcfs.modules.laboratorihaccp.base.Organization thisOpNoReg = (org.aspcfs.modules.laboratorihaccp.base.Organization)op_noreg.next();
    %> 
   <tr>
    <td>
	  <%= thisOpNoReg.getName() %>
	</td>
   </tr>
   <% } %>
       
  <% } else { %>
   <tr class="containerBody">
      <td colspan="3">
        <dhv:label name="">Nessun elenco di laboratori non in regione sottoposti a controllo.</dhv:label>
      </td>
   </tr>
   <%}%>    
 </table>	  <%}%>