<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ include file="../initPage.jsp" %>
<%-- Trails --%>
<%
	Vector<BCameraCommercio> risultati = (Vector<BCameraCommercio>)request.getAttribute( "risultati" );
%>

<%@page import="org.aspcfs.modules.camera_commercio.base.BCameraCommercio"%><table class="trails" cellspacing="0">
	<tr>
		<td>
			<a href="CameraCommercio.do"><dhv:label name="camera_commercio">Camera di Commercio</dhv:label></a> > 
			<dhv:label name="camera_commercio.risulati">Risultati Ricerca</dhv:label>
		</td>
	</tr>
</table>

<table cellpadding="2" cellspacing="2" border="0" width="100%">
  <tr>
    <td width="50%" valign="top">

      <table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
        <tr>
          <th colspan="6">
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
            <dhv:label name="">Impresa</dhv:label>
          </th>
          <th class="formLabel">
            <dhv:label name="camera_commercio.partita_iva">Partita IVA</dhv:label>
          </th>
          <th class="formLabel">
            <dhv:label name="camera_commercio.codice_fiscale">Codice Fiscale</dhv:label>
          </th>
          <th class="formLabel">
            <dhv:label name="camera_commercio.provincia_sede_legale">Provincia Sede Legale</dhv:label>
          </th>
          <th class="formLabel">
            <dhv:label name="camera_commercio.data_importazione">Data Importazione</dhv:label>
          </th>
          <th class="formLabel" width="5">&nbsp;
          </th>
        </tr>
        <%
        		for( BCameraCommercio bc: risultati )
        		{
        %>
        
        <tr>
          <td class="formLabel">
       	  	<%=toHtml( bc.getRagione_sociale() ) %>
          </td>
          <td class="formLabel">
          	<%=toHtml( bc.getPartita_iva() ) %>
          </td>
          <td class="formLabel">
          	<%=toHtml( bc.getCf_impresa() ) %>
          </td>
          <td class="formLabel">
          	<%=toHtml( bc.getProvincia_sede_legale() ) %>&nbsp;
          </td>
          <td class="formLabel">
          		&nbsp;<zeroio:tz timestamp="<%=bc.getData_importazione_osa() %>" />
          </td>
          <td class="formLabel">
          	<a href="CameraCommercio.do?command=Dettaglio&id=<%=bc.getId() %>">Scheda</a>
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
