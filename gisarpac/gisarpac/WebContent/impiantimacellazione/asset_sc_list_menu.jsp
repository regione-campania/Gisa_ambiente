<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<script language="javascript">
  var thisAssetId = -1;
  var thisOrgId = -1;
  var thisContractId = -1;
  var menu_init = false;
  //Set the action parameters for clicked item
  function displayMenu(loc, id, assetId, orgId, contractId, trashed) {
    thisAssetId = assetId;
    thisOrgId = orgId;
    thisContractId = contractId;
    updateMenu(trashed);
    if (!menu_init) {
      menu_init = true;
      new ypSlideOutMenu("menuServiceContract", "down", 0, 0, 170, getHeight("menuServiceContractTable"));
    }

    return ypSlideOutMenu.displayDropMenu(id, loc);
  }

  function updateMenu(trashed){
    if (trashed == 'true'){
      hideSpan("menuModify");
      hideSpan("menuDelete");
    } else {
      showSpan("menuModify");
      showSpan("menuDelete");
    }
  }
  //Menu link functions
  function details() {
    window.location.href = 'AccountsAssetsServiceContracts.do?command=View&id=' + thisAssetId + '&contractId=' + thisContractId + '<%= addLinkParams(request, "popup|popupType|actionId") %>';
  }

  function modify() {
    window.location.href = 'AccountsAssetsServiceContracts.do?command=Modify&id=' + thisAssetId + '&contractId=' + thisContractId + '&return=list<%= addLinkParams(request, "popup|popupType|actionId") %>';
  }

  function deleteContract() {
    popURLReturn('AccountsAssetsServiceContracts.do?command=ConfirmDelete&id=' + thisAssetId + '&contractId=' + thisContractId + '&popup=true<%= isPopup(request)?"&popupType=inline":"" %>','AccountsAssetsServiceContracts.do?command=List&id=' + thisAssetId,'Delete_servicecontract','330','200','yes','no');
  }

</script>
<div id="menuServiceContractContainer" class="menu">
  <div id="menuServiceContractContent">
    <table id="menuServiceContractTable" class="pulldown" width="170" cellspacing="0">
      <dhv:permission name="impiantiMacellazione-service-contracts-view">
      <tr id="menuView" onmouseover="cmOver(this)" onmouseout="cmOut(this)" onclick="details()">
        <th>
          <img src="images/icons/stock_zoom-page-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </th>
        <td width="100%">
          <dhv:label name="accounts.accounts_calls_list_menu.ViewDetails">View Details</dhv:label>
        </td>
      </tr>
      </dhv:permission>
      <dhv:permission name="impiantiMacellazione-service-contracts-edit">
      <tr id="menuModify" onmouseover="cmOver(this)" onmouseout="cmOut(this)" onclick="modify()">
        <th>
          <img src="images/icons/stock_edit-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </th>
        <td width="100%">
          <dhv:label name="global.button.modify">Modify</dhv:label>
        </td>
      </tr>
      </dhv:permission>
      <dhv:permission name="impiantiMacellazione-service-contracts-delete">
      <tr id="menuDelete" onmouseover="cmOver(this)" onmouseout="cmOut(this)" onclick="deleteContract()">
        <th>
          <img src="images/icons/stock_delete-16.gif" border="0" align="absmiddle" height="16" width="16"/>
        </th>
        <td>
          <dhv:label name="global.button.delete">Delete</dhv:label>
        </td>
      </tr>
      </dhv:permission>
    </table>
  </div>
</div>
