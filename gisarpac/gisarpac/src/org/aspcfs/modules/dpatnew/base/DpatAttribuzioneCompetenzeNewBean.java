package org.aspcfs.modules.dpatnew.base;

import java.sql.Connection;

import org.aspcfs.modules.dpatnew_interfaces.DpatAttribuzioneCompetenzeNewBeanAbstract;

public class DpatAttribuzioneCompetenzeNewBean extends DpatAttribuzioneCompetenzeNewBeanAbstract
{

	@Override
	public void buildlistSezioni(Connection db, int anno,boolean configli) {
		this.elencoSezioni = new DpatWrapperSezioniBean(anno, db, true, configli);		
	}
	
	

}
