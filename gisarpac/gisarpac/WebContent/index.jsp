<jsp:useBean id="applicationPrefs" class="org.aspcfs.controller.ApplicationPrefs" scope="application"/>
<%
  // During Servlet initialization, the setup parameter is set if the application
  // is completely configured
  if ((Object) getServletConfig().getServletContext().getAttribute("cfs.setup") == null) {
    RequestDispatcher setup = getServletConfig().getServletContext().getRequestDispatcher("/Setup.do?command=Default");
    setup.forward(request, response);
  } else
  // If the site is setup, then check to see if this is an upgraded version of the app
  if (applicationPrefs.isUpgradeable()) {
    RequestDispatcher upgrade = getServletConfig().getServletContext().getRequestDispatcher("/Upgrade.do?command=Default");
    upgrade.forward(request, response);
  } else {
	  if (getServletConfig().getServletContext().getAttribute("CONTEXT_NAME").equals("suap")) {
		  
		  RequestDispatcher login = getServletConfig().getServletContext().getRequestDispatcher("/Login.do?command=LoginSuap&auto-populate=true&urlProvenienza=g.balzano");
		    login.forward(request, response);
	  }
	  else
	  {
    //During login, check the application locale if needed
    RequestDispatcher login = getServletConfig().getServletContext().getRequestDispatcher("/Login.do?command=Default");
    login.forward(request, response);
	  }
  }
%>