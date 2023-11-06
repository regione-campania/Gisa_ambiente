<%-- 
  - Copyright(c) 2004 Dark Horse Ventures LLC (http://www.centriccrm.com/) All
  - rights reserved. This material cannot be distributed without written
  - permission from Dark Horse Ventures LLC. Permission to use, copy, and modify
  - this material for internal use is hereby granted, provided that the above
  - copyright notice and this permission notice appear in all copies. DARK HORSE
  - VENTURES LLC MAKES NO REPRESENTATIONS AND EXTENDS NO WARRANTIES, EXPRESS OR
  - IMPLIED, WITH RESPECT TO THE SOFTWARE, INCLUDING, BUT NOT LIMITED TO, THE
  - IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY PARTICULAR
  - PURPOSE, AND THE WARRANTY AGAINST INFRINGEMENT OF PATENTS OR OTHER
  - INTELLECTUAL PROPERTY RIGHTS. THE SOFTWARE IS PROVIDED "AS IS", AND IN NO
  - EVENT SHALL DARK HORSE VENTURES LLC OR ANY OF ITS AFFILIATES BE LIABLE FOR
  - ANY DAMAGES, INCLUDING ANY LOST PROFITS OR OTHER INCIDENTAL OR CONSEQUENTIAL
  - DAMAGES RELATING TO THE SOFTWARE.
  - 
  - Version: $Id: ticket_header_include.jsp 21501 2007-05-21 20:36:25Z matt $
  - Description:
  --%>
  
<%--

<%@ page import="org.aspcfs.modules.base.Constants, org.aspcfs.modules.allerte.base.Ticket" %>
<%
  Ticket thisTicket = (Ticket)request.getAttribute("TicketDetails");
  if (thisTicket == null) {
    thisTicket = (Ticket)request.getAttribute("ticketDetails");
  }
  if (thisTicket == null) {
    thisTicket = (Ticket) request.getAttribute("ticket");
  }
%>
<table width="100%" border="0">
  <tr>
    <td nowrap width="100%"><table width="100%" class="empty">
        <dhv:evaluate if='<%= thisTicket.getCompanyNameHierarchy() != null && !"".equals(thisTicket.getCompanyNameHierarchy().trim()) %>'>
        <tr><td nowrap width="100%" align="left"><strong><dhv:label name="tickets.parentAccounts.colon">Parent Accounts:</dhv:label></strong> <%= toHtml(thisTicket.getCompanyNameHierarchy()) %></td></tr>
        </dhv:evaluate>
        <tr><td nowrap colspan="2" align="left">
          <strong><dhv:label name="">Ente: </dhv:label></strong>
          <dhv:permission name="accounts-accounts-view">
            <a href="javascript:popURL('Accounts.do?command=Details&orgId=<%= thisTicket.getOrgId() %>&popup=true&viewOnly=true','AccountDetails','650','500','yes','yes');"><%= toHtml(thisTicket.getCompanyName()) %></a>
          </dhv:permission>
          <dhv:permission name="accounts-accounts-view" none="true">
            <%= toHtml(thisTicket.getCompanyName()) %>
          </dhv:permission>
        </td></tr>
      </table>
    </td>
  </tr>
  <tr>
    <dhv:evaluate if="<%= thisTicket.getContractId() > -1 %>">
      <td align="right" nowrap>
        <strong><dhv:label name="account.ticket.hoursRemaining.colon">Hours Remaining:</dhv:label></strong>
        <%= thisTicket.getTotalHoursRemaining() %>
        <input type="hidden" name="totalHoursRemaining" value="<%= thisTicket.getTotalHoursRemaining() %>" />
      </td>
    </dhv:evaluate>
  </tr>
</table>
<br />
--%>
