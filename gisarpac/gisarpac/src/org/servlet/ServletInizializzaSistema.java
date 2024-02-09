package org.servlet;


import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.darkhorseventures.database.ConnectionPool;

public class ServletInizializzaSistema extends HttpServlet {


	public ServletInizializzaSistema() {
		super();
		// TODO Auto-generated constructor stub
	}
 

	Logger logger= Logger.getLogger(ServletInizializzaSistema.class);
	@Override
	public void init(ServletConfig config) throws ServletException {
		Connection db = null;
		ConnectionPool cp = null ;
		
		try
		{

			

			cp = (ConnectionPool)config.getServletContext().getAttribute("ConnectionPool");
			db = cp.getConnection(null,null);	

		
			//Verifica se il db collegato e' MASTER O SLAVE
			String mode = "";
			PreparedStatement pst = db.prepareStatement("show transaction_read_only");
			ResultSet rs = pst.executeQuery();
			while (rs.next()){
				mode = rs.getString(1);
			}
			if (mode.equals("on")){
				System.out.println("DB SLAVE");
				config.getServletContext().setAttribute("ambiente","SLAVE");
			}
			else{
				System.out.println("DB MASTER");
				config.getServletContext().setAttribute("ambiente","MASTER");
			}
			pst.close();
			rs.close();
			 
			
			
			BufferedReader br = new BufferedReader(new FileReader(new File(config.getServletContext().getRealPath("templates")+File.separator+ "avviso_messaggio_urgente.txt")));
			String mes = "" ;
			mes = br.readLine();
			while (mes != null && ! "".equals(mes))
			{
				mes +=mes ;
				mes = br.readLine();
			}
			br.close();
			
			Timestamp dataUltimaModifica = new Timestamp(System.currentTimeMillis());
			config.getServletContext().setAttribute("MessaggioHome", dataUltimaModifica+"&&"+mes);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally
		{
			cp.free(db,null);
		
	}
	}


	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}
}
