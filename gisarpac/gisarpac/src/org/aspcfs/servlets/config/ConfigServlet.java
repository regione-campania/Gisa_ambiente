package org.aspcfs.servlets.config;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.aspcfs.modules.util.imports.ApplicationProperties;

/**
 * Servlet implementation class ConfigServlet
 */
public class ConfigServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ConfigServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#service(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		Logger logger = Logger.getLogger("MainLogger");
		
		logger.info("Invocata la ConfigServlet");
		
		try{
		
			for(Object chiave : ApplicationProperties.getApplicationProperties().keySet()){
				ApplicationProperties.getApplicationProperties().setProperty(chiave.toString().trim(), request.getParameter(chiave.toString().trim()) );
			}
			
			logger.info("Riconfigurazione a caldo avvenuta con successo");
			
		}
		catch (Exception e) {
			logger.severe("Errore nella riconfigurazione a caldo");
		}
		
	}

}
