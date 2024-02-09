package org.aspcfs.modules.dpat2019.base;

import java.sql.Connection;

public class DpatAttribuzioneCompetenzeNewBeanPreCong extends DpatAttribuzioneCompetenzeNewBeanAbstract
{


	@Override
	public void buildlistSezioni(Connection db, int anno,boolean configli) {
		this.elencoSezioni = new DpatWrapperSezioniBeanPreCong(anno, db, true, configli);
		
	}

}



