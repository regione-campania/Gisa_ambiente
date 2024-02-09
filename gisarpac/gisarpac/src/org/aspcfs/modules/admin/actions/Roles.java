/*
 *  Copyright(c) 2004 Concursive Corporation (http://www.concursive.com/) All
 *  rights reserved. This material cannot be distributed without written
 *  permission from Concursive Corporation. Permission to use, copy, and modify
 *  this material for internal use is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies. CONCURSIVE
 *  CORPORATION MAKES NO REPRESENTATIONS AND EXTENDS NO WARRANTIES, EXPRESS OR
 *  IMPLIED, WITH RESPECT TO THE SOFTWARE, INCLUDING, BUT NOT LIMITED TO, THE
 *  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY PARTICULAR
 *  PURPOSE, AND THE WARRANTY AGAINST INFRINGEMENT OF PATENTS OR OTHER
 *  INTELLECTUAL PROPERTY RIGHTS. THE SOFTWARE IS PROVIDED "AS IS", AND IN NO
 *  EVENT SHALL CONCURSIVE CORPORATION OR ANY OF ITS AFFILIATES BE LIABLE FOR
 *  ANY DAMAGES, INCLUDING ANY LOST PROFITS OR OTHER INCIDENTAL OR CONSEQUENTIAL
 *  DAMAGES RELATING TO THE SOFTWARE.
 */
package org.aspcfs.modules.admin.actions;

import java.sql.Connection;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.admin.base.PermissionList;
import org.aspcfs.modules.admin.base.Role;
import org.aspcfs.modules.admin.base.RoleList;
import org.aspcfs.modules.base.Constants;
import org.aspcfs.utils.web.PagedListInfo;

import com.darkhorseventures.framework.actions.ActionContext;

/**
 * Action class for managing Roles
 *
 * @author mrajkowski
 * @version $Id: Roles.java 24287 2007-12-09 11:28:24Z srinivasar@cybage.com $
 * @created September 19, 2001
 */
public final class Roles extends CFSModule {

  /**
   * Default action, calls list roles
   *
   * @param context Description of the Parameter
   * @return Description of the Return Value
   */
  public String executeCommandDefault(ActionContext context) {
    return executeCommandListRoles(context);
  }


  /**
   * Action to list roles
   *
   * @param context Description of the Parameter
   * @return Description of the Return Value
   */
  public String executeCommandListRoles(ActionContext context) {
    if (!hasPermission(context, "admin-roles-view")) {
      return ("PermissionError");
    }
    Exception errorMessage = null;
    Connection db = null;
    //Setup the pagedList
    PagedListInfo roleInfo = this.getPagedListInfo(context, "RoleListInfo");
    roleInfo.setLink("Roles.do?command=ListRoles");
    RoleList roleList = new RoleList();
    try {
      db = this.getConnection(context);
      //Prepare the list of roles
      roleList.setPagedListInfo(roleInfo);
      roleList.setBuildUsers(false);
      roleList.setBuildUserCount(true);
      roleList.setRoleType(Constants.ROLETYPE_REGULAR);
      roleList.setEnabledState(Constants.TRUE);
      roleList.buildList(db,super.getSuffiso(context));
    } catch (Exception e) {
      errorMessage = e;
    } finally {
      this.freeConnection(context, db);
    }

    addModuleBean(context, "Roles", "Role List");
    if (errorMessage == null) {
      context.getRequest().setAttribute("RoleList", roleList);
      return ("ListRolesOK");
    } else {
      context.getRequest().setAttribute("Error", errorMessage);
      return ("SystemError");
    }
  }


  /**
   * Action to view role details
   *
   * @param context Description of the Parameter
   * @return Description of the Return Value
   */
  public String executeCommandRoleDetails(ActionContext context) {

    if (!(hasPermission(context, "admin-roles-view"))) {
      return ("PermissionError");
    }

    Exception errorMessage = null;

    String roleId = context.getRequest().getParameter("id");
    String action = context.getRequest().getParameter("action");

    Connection db = null;

    try {
      db = this.getConnection(context);

      PermissionList permissionList = new PermissionList(db,(String)context.getServletContext().getAttribute("SUFFISSO_TAB_ACCESSI"));
      context.getRequest().setAttribute("PermissionList", permissionList);

      Role thisRole = new Role(db, Integer.parseInt(roleId),super.getSuffiso(context));
      context.getRequest().setAttribute("Role", thisRole);

    } catch (Exception e) {
      errorMessage = e;
    } finally {
      this.freeConnection(context, db);
    }

    if (errorMessage == null) {
      if (action != null && action.equals("modify")) {
        addModuleBean(context, "Roles", "Modify Role Details");
        return ("RoleDetailsModifyOK");
      } else {
        addModuleBean(context, "Roles", "View Role Details");
        return ("RoleDetailsOK");
      }
    } else {
      context.getRequest().setAttribute("Error", errorMessage);
      return ("SystemError");
    }
  }


  /**
   * Action to process updating a role based on html form
   *
   * @param context Description of the Parameter
   * @return Description of the Return Value
   */
 



}

