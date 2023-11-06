<%@page import="com.darkhorseventures.database.ConnectionElement"%>
<%@page import="com.darkhorseventures.database.ActionDb"%>
<%@page import="com.darkhorseventures.database.ConnectionPool"%>
<%@page import="org.aspcfs.modules.login.beans.UserBean"%>
<%@page import="org.aspcfs.controller.SubmenuItem"%>
<%@page import="java.net.URL"%>
<%@page import="org.aspcfs.controller.MainMenuItem"%>
<%@page import="com.zeroio.controller.Tracker"%>
<%@page import="java.util.Enumeration"%>
<%@page import="org.aspcfs.controller.ApplicationPrefs"%>
<%@page import="org.aspcfs.controller.SystemStatus"%>
<%@page import="java.util.Hashtable"%>
<%@page import="org.aspcfs.controller.SessionManager"%>
<%@page import="java.util.HashMap"%> 
<%@page import="org.aspcfs.controller.UserSession"%>
<%@page import="org.aspcfs.modules.admin.base.User"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.concurrent.TimeUnit"%>
<%@page import="java.util.TimeZone"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.TreeMap"%>
<%@page import="java.util.Dictionary"%>
<%@page import="java.util.Map"%>
<%@page import="org.w3c.dom.Node"%>
<%@page import="org.w3c.dom.Element"%>
<%@page import="org.aspcfs.utils.XMLUtils"%>
<%@page import="org.w3c.dom.NodeList"%>









<% 
Date adesso = new Date();


int  numTotaleConnessioniAttive = 0 ;



ApplicationPrefs prefs = (ApplicationPrefs) request.getSession().getServletContext().getAttribute("applicationPrefs");
String ceDriver = prefs.get("GATEKEEPER.DRIVER");
String ceHost = prefs.get("GATEKEEPER.URL");
String ceUser = prefs.get("GATEKEEPER.USER");
String ceUserPw = prefs.get("GATEKEEPER.PASSWORD");

ConnectionElement ce = new ConnectionElement(ceHost, ceUser, ceUserPw);
SystemStatus thisSystem = null; 
SessionManager sessionManager = null;
HashMap sessions = null;
thisSystem = (SystemStatus) ((Hashtable) application.getAttribute("SystemStatus")).get(ce.getUrl());
if(thisSystem != null){
	sessionManager = thisSystem.getSessionManager();
	
}
if(sessionManager != null){
	sessions = sessionManager.getDbconnection();
}




User u = null;
UserSession s = null;

if(sessions != null && sessions.size() > 0){

%>





<% 
int aslUtente = 0;
int prog = 0 ;
for(Object o : sessions.keySet()){
	HashMap listaConnectionForUser = (HashMap) sessions.get(o);
	
	numTotaleConnessioniAttive += listaConnectionForUser.size();
	
	
	
	
		

%>


	<%
} %>




<%
}
%>

<%=numTotaleConnessioniAttive %>



