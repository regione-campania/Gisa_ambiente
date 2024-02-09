package org.aspcfs.modules.logOperazioni;

import java.sql.Connection;
import java.sql.SQLException;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.admin.base.UserOperation;
import org.aspcfs.utils.GestoreConnessioni;
import org.aspcfs.utils.web.PagedListInfo;

import com.darkhorseventures.framework.actions.ActionContext;

public class LogOperazioni extends CFSModule {

	
	public String executeCommandHome(ActionContext context){
		return "HomeOK";
	}
	
	public String executeCommandSearch(ActionContext context){
		String username = (String)context.getRequest().getParameter("searchUsername");
		String dateStart = (String)context.getRequest().getParameter("searchtimestampDateStart");
		String dateEnd = (String)context.getRequest().getParameter("searchtimestampDateEnd");
		context.getRequest().setAttribute("searchUsername", username);
		context.getRequest().setAttribute("searchtimestampDateStart", dateStart);
		context.getRequest().setAttribute("searchtimestampDateEnd", dateEnd);
		
		Connection db = null;
		
		try {
			db = GestoreConnessioni.getConnectionStorico();
			LogOperazioniList op_list = new LogOperazioniList();
			op_list.setUsername(username);
			op_list.setDateStart(dateStart);
			op_list.setDateEnd(dateEnd);
			
			PagedListInfo searchListInfo = this.getPagedListInfo(context,"op_list");
			searchListInfo.setLink("LogOperazioni.do?command=Search&searchUsername="+username+"&searchtimestampDateStart="+dateStart+"&searchtimestampDateEnd="+dateEnd);
			searchListInfo.setListView("all");
			op_list.setPagedListInfo(searchListInfo);
			searchListInfo.setSearchCriteria(op_list, context);
			
			op_list.buildList(db,super.getSuffiso(context));
			context.getRequest().setAttribute("op_list", op_list);			
		} catch (SQLException e){
			e.printStackTrace();
		} finally {
			if (db!=null)
				GestoreConnessioni.freeConnectionStorico(db);
		}
		return "ListOK";
	}
	
	public String executeCommandDetails(ActionContext context){
		String idOp = context.getRequest().getParameter("idOp");
		UserOperation uo = new UserOperation();
		Connection db = null;
		try {
			db = GestoreConnessioni.getConnectionStorico();
			uo.buildRecord(idOp, db, super.getSuffiso(context));
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (db!=null)
				GestoreConnessioni.freeConnectionStorico(db);
		}
		context.getRequest().setAttribute("UODetails", uo);
		
		String username = (String)context.getRequest().getParameter("searchUsername");
		String dateStart = (String)context.getRequest().getParameter("searchtimestampDateStart");
		String dateEnd = (String)context.getRequest().getParameter("searchtimestampDateEnd");
		context.getRequest().setAttribute("searchUsername", username);
		context.getRequest().setAttribute("searchtimestampDateStart", dateStart);
		context.getRequest().setAttribute("searchtimestampDateEnd", dateEnd);
		
		return "DetailsOK";
	}
}
