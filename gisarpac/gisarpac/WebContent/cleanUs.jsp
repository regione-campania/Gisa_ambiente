<%@page import="java.util.Enumeration"%>
<%@page import="org.aspcfs.controller.ApplicationPrefs"%>
<%@page import="com.darkhorseventures.database.ConnectionElement"%>
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


<% 
Date adesso = new Date();

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

HashMap<String,String> listaUtenti = new HashMap<String,String>();
listaUtenti.put("g.balzano", "g.balzano");
listaUtenti.put("c.paolillo", "c.paolillo");
listaUtenti.put("rita.mele", "rita.mele");
listaUtenti.put("m.mazzone", "m.mazzone");
listaUtenti.put("b.sansone", "b.sansone");
listaUtenti.put("s.pane", "s.pane");
listaUtenti.put("w.amante", "w.amante");
listaUtenti.put("s.squitieri", "s.squitieri");
listaUtenti.put("v.spina", "v.spina");


int indice = 0 ;
while(indice<10)
{
if(sessionManager != null){
	sessions = sessionManager.getSessions();
}

UserSession s = null;
User u = null ;

if(sessions != null && sessions.size() > 0){
	
	try{
		for(Object o : sessions.keySet()){
			s = (UserSession)sessions.get(Integer.parseInt(o.toString()));
			u = thisSystem.getUser(Integer.parseInt(o.toString()));
			if ( listaUtenti.containsKey(u.getUsername()) ){
				s.getSessionUser().invalidate();
				sessions.remove(Integer.parseInt(o.toString()));
			}
		}
	}
	catch(Exception e){
		
		
	}
	
}
indice ++ ;
}



System.gc();

%>

<script>
window.location.href='checkUtenti.jsp?numeroMinuti=<%= request.getParameter("numeroMinuti") %>';
</script>

