package org.aspcfs.modules.aua.actions;






import org.aspcfs.controller.SystemStatus;
import org.aspcfs.modules.actions.CFSModule;

import com.darkhorseventures.framework.actions.ActionContext;


public class StabilimentoAUAAction extends CFSModule {
	
	
	
	public String executeCommandSearchForm(ActionContext context) {
		if (!(hasPermission(context, "opu-view"))) {
			return ("PermissionError");
		}

		
		SystemStatus systemStatus = this.getSystemStatus(context);
		
		return ("SearchOK");
	}

	
	
	



	
}