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
  - Version: $Id: projects_center_lists_menu.jsp 12404 2005-08-05 17:37:07Z mrajkowski $
  - Description: 
  --%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<script language="javascript">
  var thisListId = -1;
  var menu_init = false;
  //Set the action parameters for clicked item
  function displayMenu(loc, id, listId, trashed) {
    thisListId = listId;
    updateMenu(trashed);
    if (!menu_init) {
      menu_init = true;
      new ypSlideOutMenu("menuListItem", "down", 0, 0, 170, getHeight("menuListItemTable"));
    }
    return ypSlideOutMenu.displayDropMenu(id, loc);
  }
  function updateMenu(trashed){
    if (trashed == 'true'){
      hideSpan('menuMove');
      hideSpan('menuModify');
      hideSpan('menuDelete');
    } else {
      showSpan('menuMove');
      showSpan('menuModify');
      showSpan('menuDelete');
    }
  }

  //Menu link functions
  function viewItem() {
    popURL('ProjectManagementLists.do?command=Details&pid=<%= Project.getId() %>&cid=<%= category.getId() %>&id=' + thisListId + '&popup=true','List_Details','650','375','yes','yes');
  }
  function editItem() {
    document.location.href='ProjectManagementLists.do?command=Modify&pid=<%= Project.getId() %>&cid=<%= category.getId() %>&id=' + thisListId;
  }
  function moveItem() {
    popURL('ProjectManagementLists.do?command=Move&pid=<%= Project.getId() %>&id=' + thisListId + '&popup=true&return=ProjectLists&param=<%= Project.getId() %>','Lists','325','375','yes','yes');
  }
  function deleteItem() {
    confirmDelete('ProjectManagementLists.do?command=Delete&pid=<%= Project.getId() %>&cid=<%= category.getId() %>&id=' + thisListId);
  }
</script>
<%-- List Item Pop-up Menu --%>
<div id="menuListItemContainer" class="menu">
  <div id="menuListItemContent">
    <table id="menuListItemTable" class="pulldown" width="170" cellspacing="0">
      <tr id="menuView" onmouseover="cmOver(this)" onmouseout="cmOut(this)"
          onclick="viewItem()">
        <th valign="top">
          <img src="images/icons/stock_zoom-page-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </th>
        <td width="100%">
          <dhv:label name="project.viewItem">View Item</dhv:label>
        </td>
      </tr>
    <zeroio:permission name="project-lists-modify">
      <tr id="menuModify" onmouseover="cmOver(this)" onmouseout="cmOut(this)"
          onclick="editItem()">
        <th valign="top">
          <img src="images/icons/stock_edit-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </th>
        <td width="100%">
          <dhv:label name="project.editItem">Edit Item</dhv:label>
        </td>
      </tr>
    </zeroio:permission>
    <zeroio:permission name="project-lists-modify">
      <tr id="menuMove" onmouseover="cmOver(this)" onmouseout="cmOut(this)"
          onclick="moveItem()">
        <th valign="top">
          <img src="images/icons/stock_drag-mode-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </th>
        <td width="100%">
          <dhv:label name="project.moveItemDiffList">Move Item to Another List</dhv:label>
        </td>
      </tr>
    </zeroio:permission>
    <zeroio:permission name="project-lists-modify">
      <tr id="menuDelete" onmouseover="cmOver(this)" onmouseout="cmOut(this)"
          onclick="deleteItem()">
        <th valign="top">
          <img src="images/icons/stock_delete-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </th>
        <td width="100%">
          <dhv:label name="project.deleteItem">Delete Item</dhv:label>
        </td>
      </tr>
    </zeroio:permission>
    </table>
  </div>
</div>

