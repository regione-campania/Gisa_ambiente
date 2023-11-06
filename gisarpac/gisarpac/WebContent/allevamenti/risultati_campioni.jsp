<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ include file="../initPage.jsp" %>
<%-- Trails --%>
<%
	Vector<CampioniBlackBerry> risultati = (Vector<CampioniBlackBerry>)request.getAttribute( "risultati" );
%>

<%@page import="org.aspcfs.modules.blackberry.base.CampioniBlackBerry"%><table class="trails" cellspacing="0">
	<tr>
		<td>
			<dhv:label name="camera_commercio">Campioni da Black Berry</dhv:label> > 
			<dhv:label name="camera_commercio.risulati">Risultati Ricerca</dhv:label>
		</td>
	</tr>
</table>

<input type = "hidden" name = "idControllo" value = "<%=request.getAttribute("idControllo") %>">
<input type = "hidden" name = "idC" value = "<%=request.getAttribute("idC") %>">

<input type = "hidden" name = "orgId" value = "<%=request.getAttribute("orgId") %>">



<table cellpadding="2" cellspacing="2" border="0" width="100%">
  <tr>
    <td width="50%" valign="top">

      <table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
        <tr>
          <th colspan="10">
            <strong><dhv:label name="camera_commercio.risultati">Risultati</dhv:label></strong>
          </th>
        </tr>
        <%
        	if( risultati.size() < 1 )
        	{
        %>
        <tr>
          <td colspan="6" class="formLabel" align="left">
            Nessun Risultato
          </td>
        </tr>
        <%
        	}
        	else
        	{
        %>
        <tr>
          <th class="formLabel">
            <dhv:label name="">Verbale</dhv:label>
          </th>
          <th class="formLabel">
            <dhv:label name="">Data Prelievo</dhv:label>
          </th>
          <th class="formLabel">
            <dhv:label name="">Note Tipo Analisi</dhv:label>
          </th>
          <th class="formLabel">
            <dhv:label name="">data Accettazione</dhv:label>
          </th>
          
          <th class="formLabel">
            <dhv:label name="">Codice Accettazione </dhv:label>
          </th>
           <th class="formLabel">
            <dhv:label name="">Tipo Alimenti </dhv:label>
          </th>
           <th class="formLabel">
            <dhv:label name="">Note Tipo Alimenti </dhv:label>
          </th>
           <th class="formLabel">
            <dhv:label name="">Laboratorio Destinazione </dhv:label>
          </th>
          <th class="formLabel">
            <dhv:label name="">Data di Import</dhv:label>
          </th>
          <th class="formLabel" width="5">&nbsp;
          </th>
        </tr>
        <%
        		for( CampioniBlackBerry bc: risultati )
        		{
        %>
        
        <tr>
          <td class="formLabel">
       	  	<%=toHtml( bc.getNumeroVerbale() ) %>
          </td>
          <td class="formLabel">
          <%if(bc.getDataPrelievo()!=null){
          		
          		SimpleDateFormat sdf1 = new SimpleDateFormat("dd/MM/yyyy");
          		out.print(sdf1.format(bc.getDataPrelievo()));} %>&nbsp;
          </td>
          <td class="formLabel">
          	<%=toHtml( bc.getNoteTipoAnalisi() ) %>
          </td>
          <td class="formLabel">
         <%if(bc.getDataAccettazione()!=null){
          		
          		SimpleDateFormat sdf2 = new SimpleDateFormat("dd/MM/yyyy");
          		out.print(sdf2.format(bc.getDataAccettazione()));} %>&nbsp;
          </td>
          <td class="formLabel">
          	<%=toHtml( bc.getCodiceAccettazione()) %>
          </td>
          <td class="formLabel">
          	<%=toHtml( bc.getTipoAlimenti() ) %>
          </td>
          <td class="formLabel">
          	<%=toHtml( bc.getNoteTipoAlimenti() ) %>
          </td>
          <td class="formLabel">
          	<%=toHtml( bc.getLaboratorioDestinazione() ) %>
          </td>
        
          <td class="formLabel">
          	<%if(bc.getData_import()!=null){
          		
          		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
          		out.print(sdf.format(bc.getData_import()));} %>&nbsp;
          </td>
          
          <td class="formLabel">
          	<a href="BlackBerryImportAllevamenti.do?command=DettaglioCampione&id=<%=bc.getId() %>&idControllo=<%=request.getAttribute("idControllo")%>&orgId=<%=request.getAttribute("orgId") %>&identificativo=<%=request.getAttribute("identificativo") %>">Scheda</a>
          </td>
        </tr>
        <%
        		}
        	}
        %>
        
      </table>
      
      
    </td>
    
  </tr>
  
</table>