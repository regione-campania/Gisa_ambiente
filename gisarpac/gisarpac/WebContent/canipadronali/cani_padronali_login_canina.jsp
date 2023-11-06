
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.InputStream"%>
<%@page import="org.apache.commons.httpclient.methods.GetMethod"%>
<%@page import="org.aspcfs.modules.login.beans.UserBean"%>
<%@page import="org.apache.commons.httpclient.HttpClient"%> <%--
 
 HttpClient  client = new HttpClient();
		  try {	
			  
			  	UserBean user = (UserBean)session.getAttribute("User");
				//String requestLogin = ApplicationProperties.getProperty("COLLEGAMENTOCANINA");
			  	String requestLogin = "http://151.12.13.135/canina2/Login.do?command=LoginNoPassword&username=sysadmna1";	
		        GetMethod methodOperazione = new GetMethod(requestLogin);
		    	int statusCodeLogin = -1;
		    	try 
		    	{
					statusCodeLogin = client.executeMethod(methodOperazione);
					InputStream risposta = methodOperazione.getResponseBodyAsStream();
					BufferedReader br = new BufferedReader(new InputStreamReader(risposta));
					PrintWriter pw = response.getWriter();
					String line;
					while ((line = br.readLine()) != null) {
						if(!line.equals("")){
							pw.println(line);
						}
					}
					
					//context.getResponse().sendRedirect("http://151.12.13.135/canina2/Assets.do?command=Add");
					
				} 
				catch (Exception e) {
					e.printStackTrace();
					throw new Exception("Errore durante la fase di Login");
				} 
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		--%>
		
		<script>
		//alert('')
		window.content.location='http://151.12.13.135/canina2/Login.do?command=LoginNoPassword&username=sysadmna1';
		</script>