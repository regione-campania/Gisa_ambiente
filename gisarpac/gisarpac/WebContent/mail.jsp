<%@page import="org.aspcfs.modules.mycfs.base.Mail"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.aspcfs.modules.util.imports.ApplicationProperties"%>
<%@page import="javax.mail.MessagingException"%>
<%@page import="javax.mail.internet.AddressException"%>
<%@page import="org.aspcfs.modules.suap.base.PecMailSender"%>
<%

Mail mail = new Mail();


mail.setHost("127.0.0.1");
mail.setFrom("segnalazioni@gisasegn.it");
mail.setUser("segnalazioni@gisasegn.it");
mail.setPass("");
mail.setPort(25);
mail.setRispondiA("s.squitieri@u-s.it");

//mail.setType("text/html");

mail.setTo("gisadev@u-s.it");
mail.setSogg(" [GISA] ");
String asl_rif = "";


HashMap<String, String> map = new HashMap<String, String>();

mail.setTesto("Prova");

mail.sendMail();

%>