package org.aspcfs.servlets.utenti;

import java.io.IOException;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Map.Entry;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.aspcfs.controller.ApplicationPrefs;
import org.aspcfs.controller.SystemStatus;
import org.aspcfs.controller.UserSession;

import com.darkhorseventures.database.ConnectionElement;

/**
 * Servlet implementation class ReloadUtenti
 */
public class InvalidaAllSessioni extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private Logger logger = Logger.getLogger("MainLogger");
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public InvalidaAllSessioni() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#service(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		ConnectionElement ce = null;
		SystemStatus systemStatus = null;
		boolean esito = false ;
		try {
			ApplicationPrefs prefs = (ApplicationPrefs) request.getSession().getServletContext().getAttribute("applicationPrefs");
			String ceHost = prefs.get("GATEKEEPER.URL");
			String ceUser = prefs.get("GATEKEEPER.USER");
			String ceUserPw = prefs.get("GATEKEEPER.PASSWORD");
			
			ce = new ConnectionElement(ceHost, ceUser, ceUserPw);		
			Object o = ((Hashtable) request.getSession().getServletContext().getAttribute("SystemStatus")).get(ce.getUrl());
			if(o != null){
				systemStatus = (SystemStatus) o;
				esito = closeAllSession(systemStatus);
				
				if (esito==true)
					response.getWriter().write("OK");
				else
					response.getWriter().write("KO");
			} else {
				response.getWriter().write("OK");
			}
		} 
		catch (Exception e) {
			e.printStackTrace();
			response.getWriter().write("Eccezione catturata :"+e.getMessage());
		}
	}
	
	
	public boolean closeAllSession(SystemStatus systemStatus){
		Boolean esito = false; 
		HashMap sessions = systemStatus.getSessionManager().getSessions();
		Iterator it = sessions.entrySet().iterator();
		if(sessions != null && sessions.size() > 0){	    	
			try{
				while (it.hasNext()){
					Entry entry = (Entry) it.next();
					UserSession s = (UserSession)entry.getValue();
					it.remove();
					s.getSessionUser().invalidate();
				}
			}
			catch(Exception e){
				e.printStackTrace();
			}
			
			if (sessions.size()==0) {
				systemStatus.getSessionManager().getSessions().clear();
				esito=true;
			}
		}

		return esito;
	}
}
