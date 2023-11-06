
<%@page import="org.aspcfs.utils.web.LookupList"%>
<%@page import="org.aspcfs.modules.login.beans.UserBean"%>
<form method="post" action="Farmacosorveglianza.do?command=AllegatoI">

<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Farmacosorveglianza.do?command=SearchFormFcie"><dhv:label name="">Farmacie</dhv:label></a> > 
<dhv:label name="">AllegatoI</dhv:label>

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
<%=anno.getHtmlSelect("anno",11)%>
</td>
</tr>

<tr><td><input type = "submit" value = "invia"> </td></tr>

</table>



</form>


<script>
$("#anno").html($("#anno option").sort(function (a, b) {
    return a.text == b.text ? 0 : a.text > b.text ? -1 : 1
}))
</script>