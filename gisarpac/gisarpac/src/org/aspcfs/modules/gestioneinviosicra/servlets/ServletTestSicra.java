package org.aspcfs.modules.gestioneinviosicra.servlets;

import it.izs.ws.WsPost;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.aspcfs.controller.ApplicationPrefs;
import org.aspcfs.modules.login.beans.UserBean;
import org.aspcfs.modules.util.imports.ApplicationProperties;

import com.darkhorseventures.database.ConnectionElement;
import com.darkhorseventures.database.ConnectionPool;
 
/**
 * Servlet implementation class ServletComuni
 */
public class ServletTestSicra extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	/** 
	 * @see HttpServlet#HttpServlet()
	 */
	public ServletTestSicra() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#service(HttpServletRequest request, HttpServletResponse response)
	 */
	
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String esito="";
		
		int annoProtocollo = 2022;
		int numeroProtocollo =  9;
		
		if (request.getParameter("annoProtocollo")!=null && !request.getParameter("annoProtocollo").equals(""))
			annoProtocollo = Integer.parseInt(request.getParameter("annoProtocollo"));
		if (request.getParameter("numeroProtocollo")!=null && !request.getParameter("numeroProtocollo").equals(""))
			numeroProtocollo = Integer.parseInt(request.getParameter("numeroProtocollo"));
		
		Connection db = null;
		ConnectionPool cp = null ;
		try
		{
		ApplicationPrefs applicationPrefs = (ApplicationPrefs) getServletContext().getAttribute(
		"applicationPrefs");
		
		UserBean user = (UserBean) request.getSession().getAttribute("User");
		ApplicationPrefs prefs = (ApplicationPrefs) getServletContext().getAttribute("applicationPrefs");
		String ceDriver = prefs.get("GATEKEEPER.DRIVER");
		String ceHost = prefs.get("GATEKEEPER.URL");
		String ceUser = prefs.get("GATEKEEPER.USER");
		String ceUserPw = prefs.get("GATEKEEPER.PASSWORD");

		ConnectionElement ce = new ConnectionElement(ceHost, ceUser, ceUserPw);
		ce.setDriver(ceDriver);

		cp = (ConnectionPool)getServletContext().getAttribute("ConnectionPool");
		db = cp.getConnection(ce,null);
	
		WsPost ws = new WsPost();
		String wsEnvelope = null;
		String wsResponse = null;
		PreparedStatement pst = null;
		ResultSet rs = null;

		ws.setWsUrl(ApplicationProperties.getProperty("END_POINT_SICRA"));

		pst = db.prepareStatement("select * from get_chiamata_ws_sicra_leggi_protocollo(?, ?)");
		int i = 0;
		pst.setInt(++i, annoProtocollo);
		pst.setInt(++i, numeroProtocollo);
		
		rs = pst.executeQuery();
		while (rs.next())
			wsEnvelope = rs.getString(1);

		ws.setWsRequest(wsEnvelope); 
		wsResponse= ws.postWithHeader(db, -1, "SOAPAction", "http://tempuri.org/LeggiProtocollo");
		
		
		esito += wsResponse ;
		
		}
		 catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		finally
		{
			
			cp.free(db,null);
			response.setContentType("text/xml");
			response.getWriter().println(esito);

		}
} 
}