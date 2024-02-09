package org.aspcfs.servlets.utenti;

import java.io.IOException;
import java.sql.Connection;
import java.util.Hashtable;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.aspcfs.controller.ApplicationPrefs;
import org.aspcfs.controller.SystemStatus;

import com.darkhorseventures.database.ConnectionElement;
import com.darkhorseventures.database.ConnectionPool;

/**
 * Servlet implementation class ReloadUtenti
 */
public class ReloadUtenti extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private Logger logger = Logger.getLogger("MainLogger");
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ReloadUtenti() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#service(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		ConnectionElement ce = null;
		ConnectionPool cp = null;
		SystemStatus systemStatus = null;
		Connection db = null;  
		boolean esito = false ;
		try {
			String username = request.getParameter("username");	
			ApplicationPrefs prefs = (ApplicationPrefs) request.getSession().getServletContext().getAttribute("applicationPrefs");
			String ceHost = prefs.get("GATEKEEPER.URL");
			String ceUser = prefs.get("GATEKEEPER.USER");
			String ceUserPw = prefs.get("GATEKEEPER.PASSWORD");
			
			ce = new ConnectionElement(ceHost, ceUser, ceUserPw);
			cp = (ConnectionPool)request.getServletContext().getAttribute("ConnectionPool");
			db = cp.getConnection(ce,null);	
			
			Object o = ((Hashtable) request.getSession().getServletContext().getAttribute("SystemStatus")).get(ce.getUrl());	

			if(o != null){
				systemStatus = (SystemStatus) o;
				if (db!=null){
					if (username != null) {
					  	String suff = (String )request.getServletContext().getAttribute("SUFFISSO_TAB_ACCESSI");
						esito = systemStatus.buildHierarchyListbyUserId(db,username,suff);
					} else {
						 systemStatus.buildHierarchyList(db,request.getServletContext());					
						 systemStatus.buildRolePermissions(db,(String) request.getServletContext().getAttribute("SUFFISSO_TAB_ACCESSI"));
						 esito = true ; 	 
					}
				}
				if (esito==true)
					response.getWriter().write("OK");
				else
					response.getWriter().write("KO : USERNAME NON PRESENTE");
			} else { //QUANDO NESSUN UTENTE E' LOGGATO NON SERVE FARE IL RELOAD
				response.getWriter().write("OK");
			}
		} 
		catch (Exception e) {
			logger.severe("Si e' verificata un'eccezione nel reload degli utenti.");
			e.printStackTrace();
			response.getWriter().write("KO "+e.getMessage());
		}
		finally{
			if (cp!=null){
				if (db!=null){
					cp.free(db,null); 
				}
			}
		}	
	}
}
