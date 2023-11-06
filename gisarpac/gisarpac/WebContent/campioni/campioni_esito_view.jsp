 <jsp:useBean id="motiviAcqueNcList" class="java.util.ArrayList" scope="request"/>
<%@page import="org.aspcfs.modules.acquedirete.base.AcqueReteMotiviNc"%>
 
<% if (!TicketDetails.isEsitoCampioneChiuso() && !TicketDetails.isInformazioniLaboratorioChiuso()) { %>
<!-- 1: tutto modificabile -->
<%@ include file="/campioni/campioni_esito_view_1.jsp" %>
<%} 
else if (TicketDetails.isEsitoCampioneChiuso() && !TicketDetails.isInformazioniLaboratorioChiuso()) { %>
<!-- 2: modificabile solo info laboratorio -->
<%@ include file="/campioni/campioni_esito_view_2.jsp" %>
<%} else { %>
 <!-- 3: solo lettura -->
 <%@ include file="/campioni/campioni_esito_view_3.jsp" %>
<%} %>

