
<jsp:useBean id="Specie" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Allevamenti.do"><dhv:label name="allevamenti.allevamenti">Allevamenti</dhv:label></a> > 
<dhv:label name="allevamenti.search">Ricerca In BDN</dhv:label>
</td>
</tr>
</table>
<%-- End Trails --%>
<form method="post" action = "Allevamenti.do?command=CompareWS">
  <table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
        <tr>
          <th colspan="2">
            <strong>Ricerca in BDN</strong>
          </th>
        </tr>
        <tr>
          <td class="formLabel">
            Codice Azienda
          </td>
          <td>
            <input type="text" size="23" name="codiceAzienda" value="">
          </td>
        </tr>
        
        <tr>
          <td class="formLabel">
            Partita Iva
          </td>
          <td>
            <input type="text" size="23" name="pIva" value="">
          </td>
        </tr>
        
        <tr>
          <td class="formLabel">
            Specie
          </td>
          <td>
          <input type = "text" name = "codSpecie" >
           <%--=Specie.getHtmlSelect("codSpecie",-1) --%>
          </td>
        </tr>
        
        </table>
        <input type = "submit" value = "Invia Richiesta">
 
        </form>
        
       