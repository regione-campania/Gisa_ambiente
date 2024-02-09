package org.aspcfs.modules.dpat2019.base;

import java.sql.Connection;

public class DpatAttribuzioneCompetenzeNewBean extends DpatAttribuzioneCompetenzeNewBeanAbstract
{

	@Override
	public void buildlistSezioni(Connection db, int anno,boolean configli) {
		this.elencoSezioni = new DpatWrapperSezioniBean(anno, db, true, configli);		
	}
	
	

}
