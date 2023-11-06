<%-- 
  - Copyright(c) 2005 Concursive Corporation (http://www.concursive.com/) All
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
  - Version: $Id: error_graphics.jsp 24351 2007-12-09 15:29:31Z srinivasar@cybage.com $
  - Description:
  --%>
<%@page import="java.io.*"%>
<img src="images/error.gif" border="0" align="absmiddle"/>
<font color='red'><dhv:label name="errors.anErrorHasOccured">An Error Has Occurred</dhv:label></font>
<hr color="#BFBFBB" noshade>
Please report the following error to your system administrator.
<p>Apache Tomcat has not been configured to render graphics on this system.
The following line needs to be added to Apache Tomcat's bin/catalina.sh:<br />
<pre>
CATALINA_OPTS=-Djava.awt.headless=true
</pre>