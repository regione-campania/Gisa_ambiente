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
  - Version: $Id: accounts_documents_list_menu.jsp 17025 2006-11-03 22:40:01Z matt $
  - Description: 
  --%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<script language="javascript">
  var thisFolderId = -1;
  var thisOrgId = -1;
  var thisFileId = -1;
  var menu_init = false;
  //Set the action parameters for clicked item
  function displayMenu(loc, id, folderId, fileId, orgId) {
    thisFolderId = folderId
    thisOrgId = orgId;
    thisFileId = fileId;
    if (!menu_init) {
      menu_init = true;
      new ypSlideOutMenu("menuFolder", "down", 0, 0, 170, getHeight("menuFolderTable"));
      new ypSlideOutMenu("menuFile", "down", 0, 0, 170, getHeight("menuFileTable"));
    }
    return ypSlideOutMenu.displayDropMenu(id, loc);
  }

  //Menu link functions

  //Folder operations
  function viewFolder() {
    window.location.href='AccountsDocumentsAbus.do?command=View&orgId=' + thisOrgId + '&folderId=' + thisFolderId+'<%= addLinkParams(request, "popup|popupType|actionId|actionplan") %>';
  }

  function editFolder() {
    window.location.href='AccountsDocumentsFoldersAbus.do?command=Modify&orgId=' + thisOrgId + '&folderId=' + thisFileId + '&id=' + thisFolderId + '&parentId='+thisFileId+'<%= addLinkParams(request, "popup|popupType|actionId|actionplan") %>';
  }
  function moveFolder() {
    popURL('AccountsDocumentsFoldersAbus.do?command=Move&orgId=' + thisOrgId + '&id=' + thisFolderId + '&popup=true&return=AccountsDocumentsAbus&param='+ thisOrgId+'&param2='+ thisFolderId ,'Files','400','375','yes','yes');
  }
  function deleteFolder() {
    confirmDelete('AccountsDocumentsFoldersAbus.do?command=Delete&orgId=' + thisOrgId + '&id=' + thisFolderId + '&folderId=' + thisFileId+'<%= addLinkParams(request, "popup|popupType|actionId|actionplan") %>' );
  }

  //File operations
  function viewFileHistory() {
    document.location.href='AccountsDocumentsAbus.do?command=Details&orgId='+ thisOrgId +'&fid=' + thisFileId + '&folderId='+thisFolderId+'<%= addLinkParams(request, "popup|popupType|actionId|actionplan") %>';
  }
  function details() {
    window.location.href='AccountsDocumentsAbus.do?command=Details&orgId=' + thisOrgId + '&fid=' + thisFileId+'&folderId='+ thisFolderId+'<%= addLinkParams(request, "popup|popupType|actionId|actionplan") %>';
  }
  function modify() {
    window.location.href='AccountsDocumentsAbus.do?command=Modify&orgId=' + thisOrgId + '&fid=' + thisFileId +'&folderId='+ thisFolderId+'<%= addLinkParams(request, "popup|popupType|actionId|actionplan") %>';
  }
  function download() {
    window.location.href='AccountsDocumentsAbus.do?command=Download&orgId=' + thisOrgId + '&fid=' + thisFileId+'&folderId='+ thisFolderId+'<%= addLinkParams(request, "popup|popupType|actionId|actionplan") %>';
  }
  function view() {
    popURL('AccountsDocumentsAbus.do?command=Download&orgId='+ thisOrgId +'&fid=' + thisFileId + '&view=true', 'Content', 640,480, 1, 1);
  }
  function addVersion() {
    document.location.href='AccountsDocumentsAbus.do?command=AddVersion&orgId='+ thisOrgId +'&fid=' + thisFileId + '&folderId='+ thisFolderId+'<%= addLinkParams(request, "popup|popupType|actionId|actionplan") %>';
  }
  function moveFile() {
    popURL('AccountsDocumentsAbus.do?command=Move&orgId='+ thisOrgId+'&fid=' + thisFileId + '&popup=true&return=AccountsDocumentsAbus&param='+thisOrgId+'&param2='+thisFolderId,'Files','400','375','yes','yes');
  }
  function deleteFile() {
    confirmDelete('AccountsDocumentsAbus.do?command=Delete&fid=' + thisFileId + '&orgId=' + thisOrgId+'&folderId='+ thisFolderId+'<%= addLinkParams(request, "popup|popupType|actionId|actionplan") %>');
  }
  
</script>
<div id="menuFileContainer" class="menu">
  <div id="menuFileContent">
    <table id="menuFileTable" class="pulldown" width="170" cellspacing="0">
      <dhv:permission name="abusivismi-abusivismi-documents-view">
      <tr onmouseover="cmOver(this)" onmouseout="cmOut(this)"
          onclick="viewFileHistory()">
        <th>
          <img src="images/icons/stock_zoom-page-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </th>
        <td width="100%">
          <dhv:label name="abusivismi.abusivismi_documents_list_menu.ViewFileHistory">View File History</dhv:label>
        </td>
      </tr>
      </dhv:permission>
      <dhv:permission name="abusivismi-abusivismi-documents-view">
      <tr onmouseover="cmOver(this)" onmouseout="cmOut(this)" onclick="download();">
        <th>
          <img src="images/icons/stock_data-save-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </th>
        <td width="100%">
          <dhv:label name="abusivismi.abusivismi_contacts_detailsimport.DownloadFile">Download File</dhv:label>
        </td>
      </tr>
      </dhv:permission>
      <dhv:permission name="abusivismi-abusivismi-documents-view">
      <tr onmouseover="cmOver(this)" onmouseout="cmOut(this)" onclick="view();">
        <th>
          <img src="images/icons/stock_zoom-page-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </th>
        <td width="100%">
          <dhv:label name="abusivismi.abusivismi_documents_list_menu.ViewFileContents">Visualizza contenuto file</dhv:label>
        </td>
      </tr>
      </dhv:permission>
      <dhv:permission name="abusivismi-abusivismi-documents-edit">
      <tr onmouseover="cmOver(this)" onmouseout="cmOut(this)" onclick="modify();">
        <th>
          <img src="images/icons/stock_edit-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </th>
        <td width="100%">
          <dhv:label name="abusivismi.abusivismi_documents_list_menu.RenameFile">Rinomina File</dhv:label>
        </td>
      </tr>
      </dhv:permission>
      <dhv:permission name="abusivismi-abusivismi-documents-edit">
      <tr onmouseover="cmOver(this)" onmouseout="cmOut(this)"
          onclick="addVersion()">
        <th>
          <img src="images/icons/stock_insert-file-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </th>
        <td>
          <dhv:label name="abusivismi.abusivismi_documents_list_menu.AddVersion">Aggiungi Versione</dhv:label>
        </td>
      </tr>
      </dhv:permission>
      <dhv:permission name="abusivismi-abusivismi-documents-edit">
      <tr onmouseover="cmOver(this)" onmouseout="cmOut(this)"
          onclick="moveFile()">
        <th>
          <img src="images/icons/stock_drag-mode-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </th>
        <td>
          <dhv:label name="abusivismi.abusivismi_documents_list_menu.MoveFile">Sposta</dhv:label>
        </td>
      </tr>
      </dhv:permission>
      <dhv:permission name="abusivismi-abusivismi-documents-delete">
      <tr onmouseover="cmOver(this)" onmouseout="cmOut(this)" onclick="deleteFile();">
        <th>
          <img src="images/icons/stock_delete-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </th>
        <td width="100%">
          <dhv:label name="global.button.delete">Cancella</dhv:label>
        </td>
      </tr>
      </dhv:permission>
    </table>
  </div>
</div>
<div id="menuFolderContainer" class="menu">
  <div id="menuFolderContent">
    <table id="menuFolderTable" class="pulldown" width="170" cellspacing="0">
      <dhv:permission name="abusivismi-abusivismi-documents-view">
      <tr onmouseover="cmOver(this)" onmouseout="cmOut(this)"
          onclick="viewFolder();">
        <th valign="top">
          <img src="images/icons/stock_zoom-folder-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </th>
        <td width="100%">
          <dhv:label name="abusivismi.abusivismi_documents_list_menu.ViewFolder">Visualizza</dhv:label>
        </td>
      </tr>
      </dhv:permission>
      <dhv:permission name="abusivismi-abusivismi-documents-edit">
      <tr onmouseover="cmOver(this)" onmouseout="cmOut(this)"
          onclick="editFolder();">
        <th>
          <img src="images/icons/stock_rename-page-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </th>
        <td width="100%">
          <dhv:label name="abusivismi.abusivismi_documents_list_menu.RenameFolder">Rinomina</dhv:label>
        </td>
      </tr>
    </dhv:permission>
    <dhv:permission name="abusivismi-abusivismi-documents-edit">
      <tr onmouseover="cmOver(this)" onmouseout="cmOut(this)"
          onclick="moveFolder();">
        <th>
          <img src="images/icons/stock_drag-mode-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </th>
        <td>
          <dhv:label name="abusivismi.abusivismi_documents_list_menu.MoveFolder">Sposta</dhv:label>
        </td>
      </tr>
    </dhv:permission>
    <dhv:permission name="abusivismi-abusivismi-documents-delete">
      <tr onmouseover="cmOver(this)" onmouseout="cmOut(this)"
          onclick="deleteFolder();">
        <th valign="top">
          <img src="images/icons/stock_left-with-subpoints-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </th>
        <td>
          <dhv:label name="abusivismi.abusivismi_documents_addlist_menu.DeleteFolderMoveContents">Cancella cartella e sposta file</dhv:label>
        </td>
      </tr>
    </dhv:permission> 
    </table>
  </div>
</div>

