<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.IOException"%>
<%@page import="java.net.MalformedURLException"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.OutputStreamWriter"%>
<%@page import="java.net.URLConnection"%>
<%@page import="java.net.URL"%>
<%@page import="java.net.URLEncoder"%>
<%
String title = "test";
String content ="sdf" ;
String price = "wdf";
String tags = "" ;
String data = "product[title]=" + URLEncoder.encode(title) +
"&product[content]=" + URLEncoder.encode(content) + 
"&product[price]=" + URLEncoder.encode(price.toString()) +
"&tags=" + tags;
try {
URL url = new URL("");
URLConnection conn;
conn = url.openConnection();
conn.setRequestProperty ("Authorization", "Basic " + "");
conn.setDoOutput(true);
conn.setDoInput(true);
OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
wr.write(data);
wr.flush(); 
// Get the response 
BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream())); 
String line; 
while ((line = rd.readLine()) != null) { 
// Process line... 
} 
wr.close(); 
rd.close(); 
} catch (MalformedURLException e) {

e.printStackTrace();
}
catch (IOException e) {

e.printStackTrace();

} 

%>