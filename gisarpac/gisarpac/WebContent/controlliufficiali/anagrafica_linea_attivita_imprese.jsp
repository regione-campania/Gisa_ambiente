<script language="JavaScript" TYPE="text/javascript" SRC="javascript/ControlliUfficialiCampiAggiuntiviAnagrafica.js"></script>

<%@page import="org.aspcfs.utils.web.LookupList"%><div style = "display:none">
	<tr id="rigaATECO" >

          <td nowrap class="formLabel">
            <dhv:label name="">Linea Attivit� Sottoposta a Controllo</dhv:label>
            
          </td>
          <td>
          <%
          LookupList lookup_vuota_linea_attivita = new LookupList();
      	lookup_vuota_linea_attivita.addItem(-1, "" );
      	lookup_vuota_linea_attivita.setTableName("");
      	lookup_vuota_linea_attivita.setTable("");
      //	lookup_vuota_linea_attivita.setJsEvent("onChange=\"controllaCampiAggiuntiviLineaMercatoIttico(this.value)\"");
          
          %>
				<%= lookup_vuota_linea_attivita.getHtmlSelect("id_linea_sottoposta_a_controllo" , TicketDetails.getId_imprese_linee_attivita() ) %>
    
    <label id = "lab_linea"></label>
         	<font color = "red">*</font>
          </td>
	</tr>
	
	
	
    
	</div>