
  
  <%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<jsp:useBean id="Dialog" class="org.aspcfs.utils.web.HtmlDialog" scope="session"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<%@ include file="initPage.jsp" %>


<%
if(!"".equals(Dialog.getDeleteUrl()) && Dialog.getDeleteUrl()!=null )
{
%>
<form method="post" action="<%=Dialog.getDeleteUrl()%>">
NOTE : <textarea rows="6" cols="30" name="note"></textarea>

<input type = "submit" value="ELIMINA">
<input type = "button" value="Chiudi" onclick="window.close()">
  
  
  </form>
  <%}
else
{
%>
  
<%if(Dialog.getShowAndConfirm()){
  if(Dialog.getText().equals("")){
%>
  <html>
   <title><%=Dialog.getTitle()%></title>
    <frameset rows="50,100%,50" frameborder="0">
        <% if ("true".equals((String)getServletConfig().getServletContext().getAttribute("ForceSSL"))) { %>
          <frame name="topframe" src="https://<%= getServerUrl(request) %>/loadframes.jsp">
          <frame marginheight="0" name="middleframe" src="https://<%= request.getServerName() %><%= request.getContextPath() %>/loadmiddleframe.jsp">
          <frame name="bottomframe" src="https://<%= getServerUrl(request) %>/loadbottomframe.jsp">
        <%} else {%>
          <frame name="topframe" src="loadframes.jsp">
          <frame marginheight="0" name="middleframe" src="loadmiddleframe.jsp">
          <frame name="bottomframe" src="loadbottomframe.jsp">
        <%}%>
    </frameset>
  </html>
<%}
else{%>
  <%=toHtml(Dialog.getText())%>
<%}
}else{%>
<html>
  <jsp:include page="templates/cssInclude.jsp" flush="true"/>
  <title><%= Dialog.getTitle() %></title>
  <body>
    <br>
    <table cellpadding="4" cellspacing="0" border="0" width="95%">
      <tr valign="center">
        <td>
          <center>
           <strong>
            <% if(Dialog.getHeader() != null && !"".equals(Dialog.getHeader())) {%>
              <%= toHtml(Dialog.getHeader()) %>
            <%} else {%>
              <dhv:label name="calendar.dialog.permanentlyDelete.question">Are you sure you wish to permanently delete this information?</dhv:label>
            <%}%>
          </strong>
         </center>
        </td>
      </tr>
      <tr><td>&nbsp;</td></tr>
      <tr><td>&nbsp;</td></tr>
      <tr><td>&nbsp;</td></tr>
      <tr><td>&nbsp;</td></tr>
      <tr align="center">
        <td>
          <input type="button" value="<dhv:label name="button.ok">OK</dhv:label>" onClick="<%=Dialog.getDeleteUrl()%>">
          <input type="button" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:window.close();">
        </td>
      </tr>
     </table>
   </body>
</html>
<%}
}%>
  