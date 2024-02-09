package org.aspcfs.modules.suap.utils;

public class CodiciRisultatiRichiesta {
	
	public static final int INSERIMENTO_NUOVO_OPERATORE_OK_NON_ESISTEVA_INSERITONUOVO =1;
	public static final int INSERIMENTO_NUOVO_OPERATORE_OK_ESISTEVA_CONVERSO =2;
	public static final int INSERIMENTO_NUOVO_OPERATORE_OK_ESISTEVA_INSERITONUOVO =3;
	public static final int INSERIMENTO_NUOVO_OPERATORE_KO_STABILIMENTO_PREESISTENTE_FATTO_NULLA = 4;
	public static final int TENTATO_INSERIMENTO_CON_REFRESH =99;
	public static final int TIPO_DI_OPERAZIONE_NONSUPPORTATA = 100;
	public static final int TIPO_ERRORE_GENERICO = -1;
	//RISERVARE IL 7 POICHE' E' UTILIZZATO DA UN ALTRA ENUM
	
	public static final int VALIDATA_LINEA_PARZIALE = 7;

	
}
