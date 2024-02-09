
<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.json.JSONObject"%>

<%response.setContentType("textl");


String msgSessioneAggiornato = (String) application.getAttribute("MessaggioHome");

if(msgSessioneAggiornato!=null)
{
	
	
String[] split = msgSessioneAggiornato.split("&&");
if ( split != null && split.length==1)
{
Timestamp timeMsg = Timestamp.valueOf(split[0]);
Timestamp now = new Timestamp(System.currentTimeMillis());

Calendar GC1 = GregorianCalendar.getInstance();
Calendar GC2 = GregorianCalendar.getInstance();

GC1.setTimeInMillis(now.getTime());
GC2.setTimeInMillis(timeMsg.getTime());
long minuti =(GC1.getTime().getTime() - GC2.getTime().getTime()) / 1000 / 60  ;
JSONObject json = new JSONObject();

Timestamp dataRefresh = (Timestamp)session.getAttribute("DataUltimoRefresh");
if ( minuti <60 && (dataRefresh==null || timeMsg.after(dataRefresh))) 
{
	if (split != null && split.length>1 && split[1]!=null && split[1]!="null")
	{
		json.put("msg",(String) split[1]);
		Timestamp now1 = new Timestamp(System.currentTimeMillis());
		session.setAttribute("DataUltimoRefresh",now1);
	}
	out.print(json);
    out.flush();	
}
else
{	
	//json.put("msg", "nd");
	out.print(json);
    out.flush();
}
}
}

%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="com.itextpdf.text.log.SysoLogger"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedReader"%>