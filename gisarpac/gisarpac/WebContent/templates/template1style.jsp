<%-- 
  - Copyright(c) 2004 Concursive Corporation (http://www.concursive.com/) All
  - rights reserved. This material cannot be distributed without written
  - permission from Concursive Corporation. Permission to use, copy, and modify
  - this material for internal use is hereby granted, provided that the above
  - copyright notice and this permission notice appear in all copies. CONCURSIVE
  - CORPORATION MAKES NO REPRESENTATIONS AND EXTENDS NO WARRANTIES, EXPRESS OR
  - IMPLIED, WITH RESPECT TO THE SOFTWARE, INCLUDING, BUT NOT LIMITED TO, THE
  - IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY PARTICULAR
  - PURPOSE, AND THE WARRANTY AGAINST INFRINGEMENT OF PATENTS OR OTHER
  - INTELLECTUAL PROPERTY RIGHTS. THE SOFTWARE IS PROVIDED "AS IS", AND IN NO
  - EVENT SHALL CONCURSIVE CORPORATION OR ANY OF ITS AFFILIATES BE LIABLE FOR
  - ANY DAMAGES, INCLUDING ANY LOST PROFITS OR OTHER INCIDENTAL OR CONSEQUENTIAL
  - DAMAGES RELATING TO THE SOFTWARE.
  - 
  - Version: $Id: template1style.jsp 24329 2007-12-09 14:44:10Z srinivasar@cybage.com $
  - Description:
  --%>
<%@ page pageEncoding="UTF-8" %>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="ModuleBean" class="org.aspcfs.modules.beans.ModuleBean" scope="request"/>
<%
  response.setHeader("Pragma", "no-cache"); // HTTP 1.0
  response.setHeader("Cache-Control", "no-cache"); // HTTP 1.1
  response.setHeader("Expires", "-1");
%>
<!-- (C) 2000-2006 Concursive Corporation -->
<html>
<head>
 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" type="text/css" href="css/custom.css"></link>	
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>
<link rel="stylesheet" type="text/css" href="css/capitalize.css"></link>	
<script language="JavaScript" type="text/javascript" src="javascript/globalItemsPane.js"></script>
<script language="JavaScript" type="text/javascript" src="javascript/popURL.js"></script>
<script language="JavaScript" type="text/javascript" src="javascript/spanDisplay.js"></script>
 <script src='javascript/modalWindow.js'></script>
<script language="JavaScript" TYPE="text/javascript" SRC="dwr/interface/PopolaCombo.js"> </script>
<!-- <script type="text/javascript" src="javascript/jquery.miny_1.7.2.js"></script> -->
<script language="JavaScript" TYPE="text/javascript" SRC="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>



<script>


function getCodiceInternoTipoIspezioneCallback1(codInterno)
{
	codiceInternoTipoIspezione = codInterno.codiceInterno;
		flagCondizionalitaReturn = codInterno.flagCondizionalita;
	
	}

	
	
function getCodiceInternoTipoPiano(value)
{
	PopolaCombo.getCodiceInternoTipoPiano(value, {callback:getCodiceInternoTipoIspezioneCallback1,async:false } );

	
	
	}


</script><title><dhv:label name="templates.CentricCRM">Concourse Suite Community Edition</dhv:label><%= ((!ModuleBean.hasName())?"":": " + ModuleBean.getName()) %></title>
<jsp:include page="cssInclude.jsp" flush="true"/>
</head>
<body leftmargin="0" rightmargin="0" margin="0" marginwidth="0" topmargin="0" marginheight="0" onblur="if(window.opener!=null ){window.opener.loadModalWindowUnlock(); }">
<table border="0" width="100%">
  <tr>
    <td valign="top">
    
<jsp:include page='<%= (String) request.getAttribute("IncludeModule") %>' flush="true"/>
    </td>
  </tr>
</table>


	
</body>

</html>

