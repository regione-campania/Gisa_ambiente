<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ include file="../initPage.jsp" %>
<%-- Trails --%>
<%
	Vector<SanzioneBlackBerry> risultati = (Vector<SanzioneBlackBerry>)request.getAttribute( "risultati" );
%>

<%@page import="org.aspcfs.modules.camera_commercio.base.BCameraCommercio"%>
<%@page import="org.aspcfs.modules.blackberry.base.SanzioneBlackBerry"%><table class="trails" cellspacing="0">
	<tr>
		<td>
			<dhv:label name="camera_commercio">Sanzioni da Black Berry</dhv:label> > 
			<dhv:label name="camera_commercio.risulati">Risultati Ricerca</dhv:label>
		</td>
	</tr>
</table>

<input type = "hidden" name = "idControllo" value = "<%=request.getAttribute("idControllo") %>">
<input type = "hidden" name = "idNonConformita" value = "<%=request.getAttribute("idNonConformita") %>">
<input type = "hidden" name = "orgId" value = "<%=request.getAttribute("orgId") %>">
<input type = "hidden" name = "dataC" value = "<%=request.getAttribute("dataC") %>">
<input type = "hidden" name = identificativo value = "<%=request.getAttribute("identificativo") %>">

<table cellpadding="2" cellspacing="2" border="0" width="100%">
  <tr>
    <td width="50%" valign="top">

      <table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
        <tr>
          <th colspan="7">
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
            <dhv:label name="">Pagamento</dhv:label>
          </th>
          <th class="formLabel">
            <dhv:label name="">Trasgressore</dhv:label>
          </th>
          <th class="formLabel">
            <dhv:label name="">Norma Violata</dhv:label>
          </th>
          
          <th class="formLabel">
            <dhv:label name="">Data </dhv:label>
          </th>
          <th class="formLabel">
            <dhv:label name="">Data di Import</dhv:label>
          </th>
          <th class="formLabel" width="5">&nbsp;
          </th>
        </tr>
        <%
        		for( SanzioneBlackBerry bc: risultati )
        		{
        %>
        
        <tr>
          <td class="formLabel">
       	  	<%=toHtml( bc.getVerbale() ) %>
          </td>
          <td class="formLabel">
          	<%if( ((Double)bc.getPagamento())!= null) {out.print(bc.getPagamento());} %>
          </td>
          <td class="formLabel">
          	<%=toHtml( bc.getTrasgressore() ) %>
          </td>
          <td class="formLabel">
          	<%=toHtml( bc.getnorma_violata() ) %>&nbsp;
          </td>
          <td class="formLabel">
          		&nbsp;<zeroio:tz timestamp="<%=bc.getData() %>" />
          </td>
          <td class="formLabel">
          	<%if(bc.getData_import()!=null){
          		
          		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
          		out.print(sdf.format(bc.getData_import()));} %>&nbsp;
          </td>
          
          <td class="formLabel">
          	<a href="BlackBerryImport.do?command=Dettaglio&id=<%=bc.getId() %>&idControllo=<%=request.getAttribute("idControllo")%>&idNonConformita=<%=request.getAttribute("idNonConformita") %>&orgId=<%=request.getAttribute("orgId") %>&identificativo=<%=request.getAttribute("identificativo") %>">Scheda</a>
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