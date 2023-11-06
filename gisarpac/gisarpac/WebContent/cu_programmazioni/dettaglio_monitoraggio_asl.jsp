<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@page import="java.util.ArrayList"%>
<%@page import="org.aspcfs.modules.programmazzionecu.base.PianoAsl"%>
<%@page import="org.aspcfs.utils.web.LookupList"%>
<%@page import="org.aspcfs.utils.web.LookupElement"%>
<%@page import="org.aspcfs.modules.programmazzionecu.base.ProgrammazioniCuList"%>
<%@page import="org.aspcfs.modules.programmazzionecu.base.ProgrammazioneCu"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.aspcfs.modules.oia.base.OiaNodo"%><br>
<jsp:useBean id="MonitoraggioDettaglioAsl" class="org.aspcfs.utils.web.PagedListInfo" scope="session"/>

<jsp:useBean id="ListaPianiLookup" class="org.aspcfs.utils.web.LookupList" scope="request"/>

<br><br>

<dhv:pagedListStatus title="Lista " object="MonitoraggioDettaglioAsl"/>

<table class="details" width="100%">
<tr>
<th>PIANO</th>
<th colspan="2"> CU </th>
<th colspan="2"> CAMPIONI </th>		
</tr>

<th>&nbsp;</th>
<th>PIANIFICATI</th>
<th>ESEGUITI</th>		
<th>PIANIFICATI</th>
<th>ESEGUITI</th>	
</tr>

<%
ProgrammazioniCuList lista = (ProgrammazioniCuList) request.getAttribute("ListaPiani");
LookupList l = null ;

for (int i = 0 ; i < lista.size();i++ )
{
	ProgrammazioneCu piano = (ProgrammazioneCu)lista.get(i);
	
	
	
%>
<tr>

<td> <%=ListaPianiLookup.getSelectedValue( piano.getPiano_monitoraggio()) 	  %></td>

<td><%=((piano.getCu_pianificati()<=0) ? "Non Pianificato" :piano.getCu_pianificati()+"") %></td>
<td><%=piano.getCu_eseguiti()    %></td>

<td><%=((piano.getCampioni_pianificati()<=0) ? "Non Pianificato" :piano.getCampioni_pianificati()) %></td>
<td><%=piano.getCampioni_eseguiti()     %></td>

</tr>
<%	
}

%>


</table>