<%@page import="java.sql.Connection"%>
<%@page import="com.darkhorseventures.database.ConnectionElement"%>
<%@page import="com.darkhorseventures.database.ConnectionPool"%>
<%@page import="org.aspcfs.modules.macellazioninewsintesis.utils.ConfigTipo"%>
<jsp:useBean id="Partita"				class="org.aspcfs.modules.macellazioninewsintesis.base.Partita"			scope="request" />


<%
	ConnectionElement ce = (ConnectionElement) request.getSession().getAttribute("ConnectionElement");
	ConnectionPool sqlDriver = (ConnectionPool) request.getServletContext().getAttribute("ConnectionPool");
	Connection db = sqlDriver.getConnection(ce,null);

	ConfigTipo configTipo = (ConfigTipo)request.getSession().getAttribute("configTipo");
	if (Partita.getStato_macellazione().equals("Incompleto: Presenti campioni senza esito.") && (Partita.getStampatoArt17(db, configTipo).equals("SI") || Partita.isModello10())) 
	{
%>
		<jsp:include page="include_capo_add_modify_esito.jsp" />
<%	}
	else
	{
		String fileToInclude = "include_capo_add_modify" + configTipo.getIdTipo() + ".jsp";
%>

<jsp:include page="<%=fileToInclude%>"/>

<%	
}

   if (db != null) 
	   sqlDriver.free(db);
   db = null;
%>  
