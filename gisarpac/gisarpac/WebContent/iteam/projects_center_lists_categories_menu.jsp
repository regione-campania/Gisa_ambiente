<%-- 
  - Copyright(c) 2004 Team Elements LLC (http://www.teamelements.com/) All
  - rights reserved. This material cannot be distributed without written
  - permission from Team Elements LLC. Permission to use, copy, and modify
  - this material for internal use is hereby granted, provided that the above
  - copyright notice and this permission notice appear in all copies. TEAM ELEMENTS
  - LLC MAKES NO REPRESENTATIONS AND EXTENDS NO WARRANTIES, EXPRESS OR
  - IMPLIED, WITH RESPECT TO THE SOFTWARE, INCLUDING, BUT NOT LIMITED TO, THE
  - IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY PARTICULAR
  - PURPOSE, AND THE WARRANTY AGAINST INFRINGEMENT OF PATENTS OR OTHER
  - INTELLECTUAL PROPERTY RIGHTS. THE SOFTWARE IS PROVIDED "AS IS", AND IN NO
  - EVENT SHALL TEAM ELEMENTS LLC OR ANY OF ITS AFFILIATES BE LIABLE FOR
  - ANY DAMAGES, INCLUDING ANY LOST PROFITS OR OTHER INCIDENTAL OR CONSEQUENTIAL
  - DAMAGES RELATING TO THE SOFTWARE.
  - 
  - Author(s): Matt Rajkowski
  - Version: $Id: projects_center_lists_categories_menu.jsp 12404 2005-08-05 17:37:07Z mrajkowski $
  - Description: 
  --%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<script language="javascript">
  var thisItemId = -1;
  var menu_init = false;
  //Set the action parameters for clicked item
  function displayMenu(loc, id, itemId, trashed) {
    thisItemId = itemId;
    updateMenu(trashed);
    if (!menu_init) {
      menu_init = true;
      new ypSlideOutMenu("menuItem", "down", 0, 0, 170, getHeight("menuItemTable"));
    }
    return ypSlideOutMenu.displayDropMenu(id, loc);
  }
  function updateMenu(trashed){
    if (trashed == 'true'){
      hideSpan('menuDelete');
      hideSpan('menuModify');
    } else {
      showSpan('menuDelete');
      showSpan('menuModify');
    }
  }
  //Menu link functions
  function viewItem() {
    document.location.href='ProjectManagement.do?command=ProjectCenter&section=Lists&pid=<%= Project.getId() %>&cid=' + thisItemId;
  }
  function editItem() {
    document.location.href='ProjectManagementListsCategory.do?command=AddCategory&pid=<%= Project.getId() %>&cid=' + thisItemId;
  }
  function deleteItem() {
    confirmDelete('ProjectManagementListsCategory.do?command=DeleteCategory&pid=<%= Project.getId() %>&cid=' + thisItemId);
  }
</script>
<%-- List Item Pop-up Menu --%>
<div id="menuItemContainer" class="menu">
  <div id="menuItemContent">
    <table id="menuItemTable" class="pulldown" width="170" cellspacing="0" cellspacing="0">
    <zeroio:permission name="project-discussion-forums-view">
      <tr onmouseover="cmOver(this)" onmouseout="cmOut(this)"
          onclick="viewItem()">
        <th valign="top">
          <img src="images/icons/stock_zoom-page-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </th>
        <td width="100%">
          <dhv:label name="project.viewList">View List</dhv:label>
        </td>
      </tr>
    </zeroio:permission>
    <zeroio:permission name="project-discussion-forums-edit">
      <tr id="menuModify" onmouseover="cmOver(this)" onmouseout="cmOut(this)"
          onclick="editItem()">
        <th valign="top">
          <img src="images/icons/stock_edit-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </th>
        <td width="100%">
          <dhv:label name="project.modifyList">Modify List</dhv:label>
        </td>
      </tr>
    </zeroio:permission>
    <zeroio:permission name="project-discussion-forums-delete">
      <tr id="menuDelete" onmouseover="cmOver(this)" onmouseout="cmOut(this)"
          onclick="deleteItem()">
        <th valign="top">
          <img src="images/icons/stock_delete-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </th>
        <td width="100%">
          <dhv:label name="project.deleteList">Delete List</dhv:label>
        </td>
      </tr>
    </zeroio:permission>
    </table>
  </div>
</div>

