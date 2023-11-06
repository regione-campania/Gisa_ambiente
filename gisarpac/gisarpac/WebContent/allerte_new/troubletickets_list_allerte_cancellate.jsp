<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,org.aspcfs.modules.allerte_new.base.*,org.aspcfs.modules.allerte_new.base.Ticket,com.zeroio.iteam.base.*,java.text.DateFormat" %>
<jsp:useBean id="ListaAllerte" class="org.aspcfs.modules.allerte_new.base.TicketList" scope="request"/>
<jsp:useBean id="SearchOrgListInfo" class="org.aspcfs.utils.web.PagedListInfo" scope="request"/>





<%@ include file="../initPage.jsp" %>
<%-- Initialize the drop-down menus --%>


<dhv:pagedListStatus tdClass="pagedListTab"  title="Allerte dell'anno corrente"  object="SearchOrgListInfo"/>
<table cellpadding="4" cellspacing="0" width="100%" class="pagedList">
  <tr>
		
    <th width="10%">
      <strong><dhv:label name="">Codice Allerta</dhv:label></strong>
    </th>
    <th width="30%">
      <strong><dhv:label name="">Descrizione Breve </dhv:label></strong>
    </th>
     <th width="5%">
      <strong><dhv:label name="">Stato </dhv:label></strong>
    </th>
    <th width="5%" >
      <strong><dhv:label name="">Data Inserimento</dhv:label></strong>
    </th>
     <th width="5%">
      <strong><dhv:label name="">Inserita Da</dhv:label></strong>
    </th>
     <th width="5%" >
      <strong><dhv:label name="">Data Cancellazione</dhv:label></strong>
    </th>
     <th width="5%">
      <strong><dhv:label name="">Modificata Da</dhv:label></strong>
    </th>
     <th width="25%" >
      <strong><dhv:label name="">Motivo Cancellazione</dhv:label></strong>
    </th>
           
  </tr>
  
<%
	Iterator j = ListaAllerte.iterator();
	if ( j.hasNext() ) {
		int i = 0;
		int rowid = 0;
		while (j.hasNext()) {
			i++;
      		
		    rowid = (rowid != 1?1:2); 
		    Ticket thisTic = (Ticket)j.next();
%>   

	<tr>
 		<td  valign="top" nowrap class="row<%= rowid %>">
  			<%= thisTic.getIdAllerta() %>
		</td>
		<td  valign="top" nowrap class="row<%= rowid %>">
  			 <%=toHtml(thisTic.getDescrizioneBreve())%>
		</td>
		<td  valign="top" nowrap class="row<%= rowid %>">
  			 <%=thisTic.getNoteAlimenti()%>
		</td>
		<td  valign="top" nowrap class="row<%= rowid %>">
  			<%= thisTic.getEntered() %>
		</td>
		
		<td  valign="top" class="row<%= rowid %>">
	     <%=thisTic.getInserita_da() %>
		</td>
		<td  valign="top" class="row<%= rowid %>">
	      <%=toHtml(""+thisTic.getTrashedDate()) %>
		</td>
		<td  valign="top" class="row<%= rowid %>">
  		<%=thisTic.getModificata_da() %>	
  		
  			</td>
  			<td  valign="top" class="row<%= rowid %>">
  		<%=toHtml(thisTic.getMotivo_cancellazione_allerta()) %>	
  		
  			</td>
		
	</tr>


	<%}%>
</table>
  <% if (!ListaAllerte.isEmpty()) {%>
<br>
<dhv:pagedListControl object="SearchOrgListInfo" tdClass="row1"/>
  <%}%>
	<%} else {%>
		<tr class="containerBody">
      <td colspan="<%= 8 %>">
        <dhv:label name="sanzioniaa.nessun_risultato">Nessuna Allerta Trovata</dhv:label>
      </td>
    </tr>
  </table>
	<%}%>



