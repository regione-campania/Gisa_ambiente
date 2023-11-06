<%@page import="org.aspcfs.modules.util.imports.ApplicationProperties"%>
<%@page import="com.itextpdf.text.log.SysoLogger"%>
<%@page import="javax.mail.Transport"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.PasswordAuthentication"%>
<%@page import="javax.mail.Session"%>
<%@page import="java.util.Properties"%>
<%@page import="javax.mail.MessagingException"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.aspcfs.modules.suap.base.PecMailSender"%>
<%@page import="javax.mail.internet.AddressException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="org.aspcfs.utils.GestoreConnessioni"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>

<%!
public static  void sendMailPec(String testo,String object,String toDest)
{

	
	Properties props = new Properties();
	props.put("mail.smtp.starttls.enable",ApplicationProperties.getProperty("mail.smtp.starttls.enable"));
	props.put("mail.smtp.auth", ApplicationProperties.getProperty("mail.smtp.auth"));
	props.put("mail.smtp.host", ApplicationProperties.getProperty("mail.smtp.host"));
	props.put("mail.smtp.port", ApplicationProperties.getProperty("mail.smtp.port"));
	props.put("mail.smtp.ssl.enable",ApplicationProperties.getProperty("mail.smtp.ssl.enable"));
	
	
	
	
	Session sess = Session.getInstance(props, new javax.mail.Authenticator() {
		protected PasswordAuthentication getPasswordAuthentication() {
			return new PasswordAuthentication("M3023707", "US9560031");
		}
	 });
	
	sess.setDebug(false);
	
	try
	{
	MimeMessage mimeMsg = new MimeMessage(sess);
	mimeMsg.setFrom(new InternetAddress("gisasuap@cert.izsmportici.it"));
	mimeMsg.addRecipient(Message.RecipientType.TO, new InternetAddress(toDest));
	
	
	mimeMsg.setSubject(object);
	StringBuffer sb = new StringBuffer(testo);
	mimeMsg.setText(sb.toString(),"utf-8","html");
	Transport.send(mimeMsg);
	}
	catch(Exception e)
	{
		
	}
}
%>
<%
String codiceComune =request.getParameter("comune");
Connection db = null ;
try
{
	db=GestoreConnessioni.getConnection();
	String sql = "select * from suap_accreditati where istat_comune =?";
	PreparedStatement pst = db.prepareStatement(sql);
	pst.setString(1, codiceComune);
	ResultSet rs = pst.executeQuery();
	if(rs.next())
	{
		String pecSuap = rs.getString("pec_suap");
		String recapitoTel = rs.getString("telefono_suap");
		String comune = rs.getString("descrizione_comune");
		String referente =rs.getString("referente");
		
		
		String body = "Il comune di "+comune +" con referente : "+referente+" chiede di essere contattato per supporto al seguente recapito :"+recapitoTel;
		sendMailPec(body, "##SUAPASSISTENZA##", "infogisa@izsmportici.it");
		
		body = "Gentile Utente la sua richiesta è stata presa in carico dal nostro servizio Help-Desk. Verrà contattato entro breve tempo per ricevere il supporto tecnico di cui ha bisogno.";
		sendMailPec(body, "##SUAPASSISTENZA##", pecSuap);
	
		String insert = "insert into log_suap_richiamami (data,comune) values(current_timestamp,?)";
		pst=db.prepareStatement(insert);
		pst.setString(1, comune);
		pst.execute();
		out.print("1");
	}
	else
	{
		out.print("0");
	}
}
catch(SQLException e)
{
	out.print(e.getMessage());
}
finally
{
	GestoreConnessioni.freeConnection(db);
}
%>
