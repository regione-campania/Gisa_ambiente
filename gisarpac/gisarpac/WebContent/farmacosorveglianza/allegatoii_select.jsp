
<%@page import="org.aspcfs.utils.web.LookupList"%>
<%@page import="org.aspcfs.modules.login.beans.UserBean"%><form method="post" action="Farmacosorveglianza.do?command=AllegatoII">

<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Farmacosorveglianza.do?command=SearchFormFcie"><dhv:label name="">Farmacie</dhv:label></a> > 
<dhv:label name="">AllegatoII</dhv:label>

</td>
</tr>
</table>
<br>
<%

LookupList asl = (LookupList) request.getAttribute("Asl");
LookupList anno = (LookupList) request.getAttribute("Anno");
%>
<table align= "center">
<%
UserBean user = (UserBean) session.getAttribute("User");
if (user.getSiteId()!=-1)
{%>
<tr>
<td>Asl</td>
<td>
<%=asl.getSelectedValue(user.getSiteId()) %>
<input type = "hidden" name = "asl" value = "<%=user.getSiteId() %>">



</td>
</tr><%} %>
<tr>

<td>Anno</td>
<td>
<select name="anno" id="anno">
<option value="2018">2018</option>
<option value="2017">2017</option>
<option value="2016">2016</option>
<option value="2015">2015</option>
<option value="2014">2014</option>
<option value="2013">2013</option>
<option value="2012">2012</option>
<option value="2011">2011</option>
<option value="2010">2010</option>
<option value="2009">2009</option>
<option value="2008">2008</option>
</select></td>
</tr>

<tr><td><input type = "submit" value = "invia"> </td></tr>

</table>



</form>