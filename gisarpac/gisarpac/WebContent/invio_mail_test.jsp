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
	props.put("mail.smtp.starttls.enable","true");
	props.put("mail.smtp.auth","true");
	props.put("mail.smtp.host", "sendm.cert.legalmail.it");
	props.put("mail.smtp.port", "465");
	props.put("mail.smtp.ssl.enable","true");
	props.put("mail.smtp.ssl.protocols", "tlsv1.2");
	props.put("mail.smtp.socketFactory.class","javax.net.ssl.SSLSocketFactory");
	props.put("mail.smtp.socketFactory.fallback", "false");

	
	Session sess = Session.getInstance(props, new javax.mail.Authenticator() {
		protected PasswordAuthentication getPasswordAuthentication() {
			return new PasswordAuthentication("M3023707", "US9560031");
		}
	 });
	
	sess.setDebug(true);
	
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
	e.printStackTrace();		
}
}
%>
<%
		
		String body;

		
		

		//sendMailPec("nella jsp c'è la"  , "##CONFIGURAZIONE CHE FUNZIONA##", "gisadev@u-s.it");

%>
