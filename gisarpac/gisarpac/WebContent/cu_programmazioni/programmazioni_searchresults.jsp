<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<%@page import="org.aspcfs.modules.programmazzionecu.base.ProgrammazioneCu"%>
<%@page import="org.aspcfs.modules.programmazzionecu.base.AslCoinvolte"%>

<%@page import="org.aspcfs.utils.web.LookupElement"%>
<%@page import="org.aspcfs.modules.oia.base.OiaNodo"%><jsp:useBean id="PianoMonitoraggio" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="LookupDurata" class="org.aspcfs.utils.web.LookupList" scope="request"/>

<jsp:useBean id="TicList" class="org.aspcfs.modules.programmazzionecu.base.ProgrammazioniCuList" scope="request"/>
<jsp:useBean id="TicListInfo" class="org.aspcfs.utils.web.PagedListInfo" scope="session"/>
<jsp:useBean id="SiteIdList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>

<%@ include file="../initPage.jsp" %>
<%@ include file="../initPopupMenu.jsp" %>

<%@ include file="troubletickets_searchresults_menu.jsp" %>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/spanDisplay.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/confirmDelete.js"></SCRIPT>
<script language="JavaScript" type="text/javascript">
  <%-- Preload image rollovers for drop-down menu --%>
  
</script>
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
Programmazioni > 
<a href="Cruscotto.do?command=Search"><dhv:label name="">Ricerca</dhv:label></a> >
<dhv:label name="">Risultati</dhv:label>
</td>
</tr>
</table>

<%
	int size = ( (User.getSiteId() > 0) ? (1) : (SiteIdList.size()-1) );
	int row_span = ( (User.getSiteId() > 0) ? (2) : (2) );
%>

<%-- End Trails --%>

<dhv:pagedListStatus title="Lista Programmazioni" object="TicListInfo"/>
<table cellpadding="4" cellspacing="0" width="100%" class="details">
  	<tr>
  
   	<th rowspan="2"><b>Periodo Riferimento</b></th>
    <th rowspan="2"><b>Piano</b></th>
   
    
    
    <%
	    if( User.getSiteId() <= 0 )
	    {
   	%>
   			<th rowspan="2">&nbsp;</th>
   	<%
   	for(int i = 0 ; i < SiteIdList.size(); i++)
	{
		LookupElement el = (LookupElement)SiteIdList.get(i);
		int code = el.getCode();
		if(code!=16)
		{
		%>
	
		<th colspan="3"><%="<center>"+el.getDescription()+"</center>" %></th>
		<%
	}}

	    }
	    else
	    {	
	    	
    %>
    	<th>&nbsp;</th>
    	<th colspan="3"><%="<center>"+SiteIdList.getSelectedValue(User.getSiteId())+"</center>" %></th>
    	
    <%
	    }
    %>
    
  </tr>
  <tr>
  <%if (User.getSiteId() >= 0) 
  {%>
  <th>&nbsp;</th>
  <th >Pianificati</th>
		<th >Eseguiti</th>
		<th >Resudui</th>
  <%
  }
  else
  {
  for(int i = 0 ; i < SiteIdList.size(); i++)
	{
		LookupElement el = (LookupElement)SiteIdList.get(i);
		int code = el.getCode();
		if(code!=16)
		{
		%>
	
		<th >Pianificati</th>
		<th >Eseguiti</th>
		<th >Resudui</th>
		<%
	}}}%>
  
  </tr>
  
<%
	Iterator j = TicList.iterator();
	if ( j.hasNext() ) {
		int i = 0;
   		int rowid = 0;
	 	while (j.hasNext()) 
	 	{
     		i++;
      		rowid = (rowid != 1?1:2);
      		ProgrammazioneCu thisTic = (ProgrammazioneCu)j.next();
%>   
	<tr>
	
	
   		<td rowspan="<%=row_span %>" valign="top" class="row<%= rowid %>">
	     <%= "Durata : "+LookupDurata.getSelectedValue(thisTic.getDurata())+"<br>" %>
	     <%
	     if (!"".equals(thisTic.getData1asString()))
	     {
	    	 out.print("Dal "+thisTic.getData1asString());
	     }
	     if (!"".equals(thisTic.getData2asString()))
	     {
	    	 out.print("Al "+thisTic.getData2asString());
	     }
	     
	     
	     %>
		</td>
		<td rowspan="<%=row_span %>" valign="top" class="row<%= rowid %>">
	   <a href="Cruscotto.do?command=Details&id_programmazione=<%=thisTic.getId() %>">  <%=PianoMonitoraggio.getSelectedValue(thisTic.getPiano_monitoraggio()) %></a>
		</td>
		
		<%
			if( User.getSiteId() <= 0 )
			{
		%>
			
			<th>C.U.</th>
			
		<%
		for( i = 0 ; i < SiteIdList.size(); i++)
    	{
    		LookupElement el = (LookupElement)SiteIdList.get(i);
    		int code = el.getCode();
    		if(code!=16)
    		{
			OiaNodo temp = thisTic.getAslCoinvolta( code );
			String cu_p = ( (temp == null) ? ( thisTic.ASL_NON_COINVOLTA ) : ( (temp.getCuPianificati() > 0) ? (temp.getCuPianificati()) : (thisTic.CU_NON_PIANIFICATI) ) ) + "";
			String cu_e = ( (temp == null) ? ( thisTic.ASL_NON_COINVOLTA ) : ( (temp.getCuEseguiti() > -1) ? (temp.getCuEseguiti()) : (0) ) ) + "";
			
			String cu_r = ( (temp == null) ? ( thisTic.ASL_NON_COINVOLTA ) : ( (((temp.getCuPianificati()>0) && (temp.getCuPianificati() - temp.getCuEseguiti())> 0) ) ? ((temp.getCuPianificati() - temp.getCuEseguiti())) : ("0") ) ) + "";

			
			//String cu_r = ( (temp == null) ? ( thisTic.ASL_NON_COINVOLTA ) :  ((temp.getCu_pianificati() - temp.getCu_eseguiti())) )+ "" ;

		%>
	
		<td class="row<%= rowid %>">
					<%=toHtmlValue( cu_p ) %>
		</td>
		<td class="row<%= rowid %>">
					<%=toHtmlValue( cu_e ) %>
		</td>
		<td class="row<%= rowid %>">
					<%=toHtmlValue( cu_r ) %>
		</td>
		
		<%
    		}}%>
	</tr>
	<tr>
	<th>Campioni.</th>
			
		<%
		for( i = 0 ; i < SiteIdList.size(); i++)
    	{
    		LookupElement el = (LookupElement)SiteIdList.get(i);
    		int code = el.getCode();
    		if(code!=16)
    		{
    			
			OiaNodo temp = thisTic.getAslCoinvolta( code );
			String campioni_p = ( (temp == null) ? ( thisTic.ASL_NON_COINVOLTA ) : ( (temp.getCampioniPianificati() > 0) ? (temp.getCampioniPianificati()) : (thisTic.CAMPIONI_NON_PIANIFICATI) ) ) + "";
			String campioni_e = ( (temp == null) ? ( thisTic.ASL_NON_COINVOLTA ) : ( (temp.getCampioniEseguiti() > -1) ? (temp.getCampioniEseguiti()) : (0) ) ) + "";
			String campioni_r = ( (temp == null) ? ( thisTic.ASL_NON_COINVOLTA ) : ((temp.getCampioniPianificati() - temp.getCampioniEseguiti()>0) ? temp.getCampioniPianificati() - temp.getCampioniEseguiti()+ "" : "0"));

		%>
	
		<td class="row<%= rowid %>">
					<%=toHtmlValue( campioni_p ) %>
		</td>
		<td class="row<%= rowid %>">
					<%=toHtmlValue( campioni_e ) %>
		</td>
		<td class="row<%= rowid %>">
					<%=toHtmlValue( campioni_r ) %>
		</td>
			
		<%
	}}
	
	%>
	</tr>
		<tr>		
	<%}
	else
	{%>
		<th>C.U.</th>
		
		<%
		int cu_p = 0 ;
		int cu_e = 0 ;
		int cu_r = 0 ;
		int campioni_p = 0 ;
		int campioni_e = 0 ;
		int campioni_r = 0 ;
				ArrayList<OiaNodo> listatemp = thisTic.getAsl_coinvolte().get(SiteIdList.getSelectedValue( User.getSiteId() ));
				for(OiaNodo temp :listatemp )
				{
					
					
				 cu_p += ( (temp == null) ? ( 0) : ( (temp.getCuPianificati() > 0) ? (temp.getCuPianificati()) : (0) ) ) ;
				 cu_e += ( (temp == null) ? ( 0 ) : ( (temp.getCuEseguiti() > -1) ? (temp.getCuEseguiti()) : (0) ) ) + 0;
				 cu_r += ( (temp == null) ? ( 0 ) :  ((temp.getCuPianificati() - temp.getCuEseguiti()>-1) ? (temp.getCuPianificati() - temp.getCuEseguiti()) : 0 )) ;
				
				  campioni_p += ( (temp == null) ? ( 0 ) : ( (temp.getCampioniPianificati() > 0) ? (temp.getCampioniPianificati()) : (0) ) ) ;
					 campioni_e += ( (temp == null) ? ( 0 ) : ( (temp.getCampioniEseguiti() > -1) ? (temp.getCampioniEseguiti()) : (0) ) ) ;
					 campioni_r += ( (temp == null) ? ( 0 ) :  ((temp.getCampioniPianificati() - temp.getCampioniEseguiti())>-1) ? (temp.getCampioniPianificati() - temp.getCampioniEseguiti()) : 0 ) ;
					
				}
			%>
		
			<td class="row<%= rowid %>">
						<%=toHtmlValue( cu_p ) %>
			</td>
			<td class="row<%= rowid %>">
						<%=toHtmlValue( cu_e ) %>
			</td>
			<td class="row<%= rowid %>">
						<%=toHtmlValue( cu_r ) %>
			</td>

		</tr>
		<tr>
		<th>Campioni.</th>
				
		<%
		
				
				

			%>
		
			<td class="row<%= rowid %>">
						<%=toHtmlValue( campioni_p ) %>
			</td>
			<td class="row<%= rowid %>">
						<%=toHtmlValue( campioni_e ) %>
			</td>
			<td class="row<%= rowid %>">
						<%=toHtmlValue( campioni_r ) %>
			</td>		
				</tr>		
		
				

	<%}%>
			

<%}%>
</table>
<br>
<input type="hidden" id="listFilter1" name="listFilter1" value='<%=request.getParameter("listFilter1")%>' />
<dhv:pagedListControl object="TicListInfo" tdClass="row1"/>
	<%} else {%>
		<tr class="containerBody">
      <td colspan="<%=6 + size %>">
        Nessuna Programmazione Trovata
      </td>
    </tr>
  </table>
<%}%>

