package org.aspcfs.modules.dpatnew_templates.base;

import java.sql.Connection;

import org.aspcfs.modules.dpatnew_interfaces.DpatAttribuzioneCompetenzeNewBeanAbstract;

public class DpatAttribuzioneCompetenzeNewBeanPreCong extends DpatAttribuzioneCompetenzeNewBeanAbstract
{


	@Override
	public void buildlistSezioni(Connection db, int anno,boolean configli) {
		this.elencoSezioni = new DpatWrapperSezioniBeanPreCong(anno, db, true, configli);
		
	}

}



