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
  - Version: $Id: configure_database.jsp 24333 2007-12-09 14:51:22Z srinivasar@cybage.com $
  - Description:
  --%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<jsp:useBean id="APP_VERSION" class="java.lang.String" scope="application"/>
<jsp:useBean id="database" class="org.aspcfs.modules.setup.beans.DatabaseBean" scope="request"/>
<%@ include file="../initPage.jsp" %>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/spanDisplay.js"></script>
<script language="JavaScript">
  function showProgress() {
    if (document.configure.type.value == "none") {
      alert("Please choose a database configuration");
      return false;
    } else {
      hideSpan("buttons");
      showSpan("progress");
      return true;
    }
  }
  function configureDB() {
    if (document.configure.type.value == "DaffodilDB" || document.configure.type.value == "Derby") {
      hideSpan("span-ip");
      showSpan("span-ip-no");
      hideSpan("span-port");
      showSpan("span-port-no");
      <dhv:evaluate if="<%= hasText(APP_VERSION) %>">
        hideSpan("span-name");
        showSpan("span-name-no");
        hideSpan("span-user");
        showSpan("span-user-no");
        hideSpan("span-password");
        showSpan("span-password-no");
      </dhv:evaluate>
      document.configure.port.value = "";
    } else {
      hideSpan("span-ip-no");
      showSpan("span-ip");
      hideSpan("span-port-no");
      showSpan("span-port");
      <dhv:evaluate if="<%= hasText(APP_VERSION) %>">
        hideSpan("span-name-no");
        showSpan("span-name");
        hideSpan("span-user-no");
        showSpan("span-user");
        hideSpan("span-password-no");
        showSpan("span-password");
      </dhv:evaluate>
      if (document.configure.type.value == "PostgreSQL") {
        document.configure.port.value = "5432";
      }
      if (document.configure.type.value == "MSSQL") {
        document.configure.port.value = "1433";
      }
      if (document.configure.type.value == "Oracle") {
        document.configure.port.value = "1521";
      }
      if (document.configure.type.value == "DB2") {
        document.configure.port.value = "50000";
      }
      if (document.configure.type.value == "Firebird") {
        document.configure.port.value = "3050";
      }
      if (document.configure.type.value == "InterBase") {
        document.configure.port.value = "3050";
      }
      if (document.configure.type.value == "MySQL") {
        document.configure.port.value = "3306";
      }
    }
  }
</script>
<body onLoad="configureDB();">
<dhv:formMessage showSpace="false" />
<form name="configure" action="SetupDatabase.do?command=ConfigureDatabase&auto-populate=true" method="post" onSubmit="return showProgress()">
<input type="hidden" name="configured" value="1"/>
<table border="0" width="100%">
  <tr class="sectionTitle">
    <th>
      <dhv:label name="setup.configuration.step3to4">Concourse Suite Community Edition Configuration (Step 3 of 4)<br />Database Settings &amp; Installation</dhv:label>
    </th>
  </tr>
  <tr>
    <td>
      <dhv:label name="setup.centricCRM.usesDatabase.text">Concourse Suite Community Edition stores and retrieves data using a database.</dhv:label><br>
      <br>
      <dhv:label name="setup.configureDatabase.url.text" param="postgres=<a href=\"http://www.postgresql.org\" target=\"_new\">|end=</a>|mssql=<a href=\"http://www.microsoft.com/sql\" target=\"_new\">">Concourse Suite Community Edition works best with the Open Source database server <a href="http://www.postgresql.org" target="_new">PostgreSQL</a>. You can also use <a href="http://www.microsoft.com/sql" target="_new">Microsoft SQL Server</a>.</dhv:label>
      <dhv:label name="setup.databaseServerInstallation.text"><ul><li>Before continuing, the database server must be installed and functional</li><li>The database administrator should create a user called "centric_crm"</li><li>The database administrator should create a new database, with UNICODE encoding, called "centric_crm"</li><li>The centric_crm user must have full permissions on the centric_crm database</li><li>Once configured, enter the database connection information below, then press continue to verify the settings</li></ul></dhv:label>
    </td>
  </tr>
  <tr class="sectionTitle">
    <th><dhv:label name="setup.databaseConnection">Database Connection</dhv:label></th>
  </tr>
  <tr>
    <td nowrap>
      <table border="0" class="empty">
        <tr>
          <td class="formLabel">
            <dhv:label name="setup.databaseType.colon">Database Type:</dhv:label>
          </td>
          <td>
            <select name="type" onChange="configureDB();">
              <option value="none">-- None -- </option>
              <option value="Derby"<%= "Derby".equals(database.getType()) ? " selected" : "" %>><dhv:label name="setup.derby">Apache Derby (Embedded)</dhv:label></option>
              <option value="DaffodilDB"<%= "DaffodilDB".equals(database.getType()) ? " selected" : "" %>><dhv:label name="setup.DaffodilDB">DaffodilDB/One$DB (Embedded)</dhv:label></option>
              <option value="Firebird"<%= "Firebird".equals(database.getType()) ? " selected" : "" %>><dhv:label name="setup.firebird">Firebird</dhv:label></option>
              <option value="InterBase"<%= "InterBase".equals(database.getType()) ? " selected" : "" %>><dhv:label name="setup.interbase">InterBase</dhv:label></option>
              <option value="DB2"<%= "DB2".equals(database.getType()) ? " selected" : "" %>><dhv:label name="setup.db2">IBM DB2</dhv:label></option>
              <option value="MSSQL"<%= "MSSQL".equals(database.getType()) ? " selected" : "" %>><dhv:label name="setup.sqlServer">Microsoft SQL Server</dhv:label></option>
              <option value="MySQL"<%= "MySQL".equals(database.getType()) ? " selected" : "" %>><dhv:label name="setup.mysql">MySQL</dhv:label></option>
              <option value="Oracle"<%= "Oracle".equals(database.getType()) ? " selected" : "" %>><dhv:label name="setup.oracle">Oracle</dhv:label></option>
              <option value="PostgreSQL"<%= "PostgreSQL".equals(database.getType()) ? " selected" : "" %>><dhv:label name="setup.postgreSQL">PostgreSQL</dhv:label></option>
            </select>
            <font color="red">*</font>
          </td>
        </tr>
        <tr>
          <td class="formLabel">
            <dhv:label name="campaign.ipAddress.colon">IP Address:</dhv:label>
          </td>
          <td>
            <span id="span-ip" name="span-ip">
              <input type="text" size="20" name="ip" value="<%= toHtmlValue(database.getIp()) %>"/>
              <font color="red">*</font>
              <%= showAttribute(request, "ipError") %>
            </span>
            <span id="span-ip-no" name="span-ip-no" style="display:none">
              not used
            </span>
          </td>
        </tr>
        <tr>
          <td class="formLabel">
            <dhv:label name="setup.databasePort.colon">Database Port:</dhv:label>
          </td>
          <td>
            <span id="span-port" name="span-port">
              <input type="text" size="20" name="port" value="<%= toHtmlValue(database.getPort()) %>"/>
              <font color="red">*</font>
              <%= showAttribute(request, "portError") %>
            </span>
            <span id="span-port-no" name="span-port-no" style="display:none">
              not used
            </span>
          </td>
        </tr>
        <tr>
          <td class="formLabel">
            <dhv:label name="setup.databaseName.colon">Database Name/Path:</dhv:label>
          </td>
          <td>
            <span id="span-name" name="span-name">
              <input type="text" size="20" name="name" value="<%= toHtmlValue(database.getName()) %>"/>
              <font color="red">*</font>
              <%= showAttribute(request, "nameError") %>
            </span>
            <span id="span-name-no" name="span-name-no" style="display:none">
              not used
            </span>
          </td>
        </tr>
        <tr>
          <td class="formLabel">
            <dhv:label name="setup.databaseUserName.colon">Database User Name:</dhv:label>
          </td>
          <td>
            <span id="span-user" name="span-user">
              <input type="text" size="20" maxlength="255" name="user" value="<%= toHtmlValue(database.getUser()) %>"/>
              <font color="red">*</font>
              <%= showAttribute(request, "userError") %>
            </span>
            <span id="span-user-no" name="span-user-no" style="display:none">
              not used
            </span>
          </td>
        </tr>
        <tr>
          <td class="formLabel">
            <dhv:label name="setup.userPassword.colon">Database User Password:</dhv:label>
          </td>
          <td>
            <span id="span-password" name="span-password">
              <input type="password" size="20" maxlength="255" name="password" value="<%= toHtmlValue(database.getPassword()) %>"/>
              <%= showAttribute(request, "passwordError") %>
            </span>
            <span id="span-password-no" name="span-password-no" style="display:none">
              not used
            </span>
          </td>
        </tr>
      </table>
      &nbsp;<br>
      <span id="buttons" name="buttons">
        <input type="submit" value="<dhv:label name="button.continueR">Continue ></dhv:label>"/>
      </span>
      <span id="progress" name="progress" style="display:none">
        <font color="blue"><b><dhv:label name="setup.pleaseWaitToConnectToDatabase.text">Please Wait... connecting to the database!</dhv:label></b></font>
      </span>
    </td>
  </tr>
</table>
</form>
</body>
