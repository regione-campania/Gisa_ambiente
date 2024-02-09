package org.aspcfs.modules.gestioneinviosicra.servlets;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.aspcfs.controller.ApplicationPrefs;
import org.aspcfs.modules.login.beans.UserBean;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.darkhorseventures.database.ConnectionElement;
import com.darkhorseventures.database.ConnectionPool;
 
/**
 * Servlet implementation class ServletComuni
 */
public class GetDocumentService extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	/** 
	 * @see HttpServlet#HttpServlet()
	 */
	public GetDocumentService() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @throws SQLException 
	 * @see HttpServlet#service(HttpServletRequest request, HttpServletResponse response)
	 */
	
	private void insertLog(Connection db, String request, String ip, String response) throws SQLException{
		
		PreparedStatement pst = null;
		
		pst = db.prepareStatement("insert into log_chiamate_get_documenti_sicra( data, ip_chiamante, request, response) values ( now(), ?, ?, ?)");
		pst.setString(1, ip);
		pst.setString(2, request);
		pst.setString(3, response);
		
		pst.execute();
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		JSONArray jo = new JSONArray();
		
		String username = "";
		String password = "";
		String codiceFiscale = "";
		
		StringBuffer jb = new StringBuffer();
		  String line = null;
		  try {
		    BufferedReader reader = request.getReader();
		    while ((line = reader.readLine()) != null)
		      jb.append(line);
		  } catch (Exception e) { }
		
		  JSONObject jBuffer = new JSONObject();
		try {
			jBuffer = new JSONObject(jb.toString());
		} catch (JSONException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
		  
		  try {
			username = jBuffer.getString("username");
			password = jBuffer.getString("password");
			codiceFiscale = jBuffer.getString("CodiceFiscale");
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		  
		
		//controllo cf vuoto
		
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
	
		
		PreparedStatement pst = null;
		ResultSet rs = null;

		pst = db.prepareStatement("select * from get_lista_documenti_sicra( ?, ?, ? )");
		pst.setString(1, username);
		pst.setString(2, password);
		pst.setString(3, codiceFiscale);
		
		rs = pst.executeQuery();
		while (rs.next())
			jo = new JSONArray(rs.getString(1));
		
		}
		 catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		finally
		{
			
			try {
				insertLog(db, jb.toString(), request.getRemoteAddr(), jo.toString());
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			
			cp.free(db,null);
			//response.setHeader("Content-disposition","application/json");
	        response.setContentType("application/json");
			response.getWriter().println(jo);

		}
} 
}