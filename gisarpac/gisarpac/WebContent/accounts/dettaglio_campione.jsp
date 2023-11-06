<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ include file="../initPage.jsp" %>

<%@page import="org.aspcfs.modules.blackberry.base.CampioniBlackBerry"%>

<form action="BlackBerryImport.do?command=TrasformaCampione" method="post">
<%-- Trails --%>
<%
CampioniBlackBerry cc = (CampioniBlackBerry)request.getAttribute( "dettaglio" );
%>

<input type = "hidden" name = identificativo value = "<%=request.getAttribute("identificativo") %>">
<input type = "hidden" name = "idS" value = "<%=cc.getId()%>">
<input type = "hidden" name = "idC" value = "<%=request.getAttribute("idC") %>">
<input type = "hidden" name = "idControllo" value = "<%=request.getAttribute("idControllo") %>">
<%

%>
<input type = "hidden" name = "orgId" value = "<%=request.getAttribute("orgId") %>">
<table class="trails" cellspacing="0">
	<tr>
		<td>
			
			<dhv:label name="camera_commercio">
			
				Scheda Campione Inserito da Black Berry
				
								
			</dhv:label>> 
			<dhv:label name="camera_commercio.cerca">Scheda Attivit&agrave;</dhv:label>
		</td>
	</tr>
</table>

<table cellpadding="2" cellspacing="2" border="0" width="100%">
  <tr>
    <td width="50%" valign="top">

      <table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
        
        <tr>
          <th colspan="2">
            <strong>Scheda Campione Inserito da Black Berry
             </strong>
          </th>
        </tr>
        
        <tr>
          <td class="formLabel">
            <dhv:label name="camera_commercio.partita_iva">Verbale</dhv:label>
          </td>
          <td>
            <%=cc.getNumeroVerbale() %>&nbsp;
          </td>
        </tr>
        <tr>
          <td class="formLabel">
            <dhv:label name="camera_commercio.partita_iva">Data Prelievo</dhv:label>
          </td>
          <td>
            <%=cc.getDataPrelievo() %>&nbsp;
          </td>
        </tr>
        <tr>
          <td class="formLabel">
            <dhv:label name="camera_commercio.partita_iva">Note Tipo Analisi</dhv:label>
          </td>
          <td>
            <%=toHtml( cc.getNoteTipoAnalisi()) %>&nbsp;
          </td>
        </tr>
        
        <tr>
          <td class="formLabel">
            <dhv:label name="">Data Accettazione</dhv:label>
          </td>
          <td>
            <%=cc.getDataAccettazione()%>
          </td>
        </tr>
        
        <tr>
          <td class="formLabel">
            <dhv:label name="">Codice Accettazione</dhv:label>
          </td>
          <td>
            <%=toHtml( cc.getCodiceAccettazione()) %>
          </td>
        </tr> 
        
       <tr>
          <td class="formLabel">
            <dhv:label name="">Tipo Alimenti</dhv:label>
          </td>
          <td>
            <%=toHtml( cc.getTipoAlimenti()) %>
          </td>
        </tr> 
        
        <tr>
          <td class="formLabel">
            <dhv:label name="">Note Tipo Alimenti</dhv:label>
          </td>
          <td>
            <%=toHtml( cc.getNoteTipoAlimenti()) %>
          </td>
        </tr> 
        
        <tr>
          <td class="formLabel">
            <dhv:label name="">Laboratorio Destinazione</dhv:label>
          </td>
          <td>
            <%=toHtml( cc.getLaboratorioDestinazione()) %>
          </td>
        </tr> 
            
       
        
       
        
        
        
        
      </table>
      
      
    </td>
    
  </tr>
  
</table>

	<input type="hidden" name="id" value="<%=cc.getId() %>" />
	
	
		<dhv:permission name="accounts-accounts-campioni-add">
			<input type="submit" value="<dhv:label name="button.importa">Importa</dhv:label>" />
		</dhv:permission>
	

</form>

