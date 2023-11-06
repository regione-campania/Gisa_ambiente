<%
	
	System.out.println("CHIAMATA JSP PER RISULTATO TENTATIVO LOGIN CAT 4");
	String risultatoLogin = (String) request.getAttribute("risultato")+"/"+(String)request.getAttribute("session_id")+
							"/"+ (String) request.getAttribute("comune_suap") +"/"+ (String) request.getAttribute("id_comune_suap")
							+ "/" + (String) request.getAttribute("provincia") + "/"+ (String) request.getAttribute("id_provincia")
							+ "/"+ (String) request.getAttribute("id_user");
							
	System.out.println(risultatoLogin);
	response.getOutputStream().print(risultatoLogin);
%>