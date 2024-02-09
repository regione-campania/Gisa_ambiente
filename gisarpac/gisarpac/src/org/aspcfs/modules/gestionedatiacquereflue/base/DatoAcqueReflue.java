package org.aspcfs.modules.gestionedatiacquereflue.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class DatoAcqueReflue {

	private int id;
	
	private boolean depurazioneReflui;
	private int idStatoImpianto = -1;
	private String gestoreImpianto;
	private int idProcessoDepurativo = -1;
	private String potenzialitaImpiantoAE;
	private String recettoreScarico;
	private String recettoreFinale;
	private String codiceUlia;
		
	private int enteredBy;
	private int modifiedBy;

	private Timestamp entered = null;
	private Timestamp modified = null;
	private Timestamp trashedDate = null;
	
	private int riferimentoId;
	private String riferimentoIdNomeTab;

	
	
	public DatoAcqueReflue() {
	}

	public DatoAcqueReflue(Connection db, int id) throws SQLException {}

	public DatoAcqueReflue(ResultSet rs) throws SQLException {
		buildRecord(rs);
	}

	private void buildRecord(ResultSet rs) throws SQLException {
		this.id = rs.getInt("id");
		
		this.riferimentoId = rs.getInt("riferimento_id");
		this.riferimentoIdNomeTab = rs.getString("riferimento_id_nome_tab");
		
		this.depurazioneReflui = rs.getBoolean("depurazione_reflui");
		this.idStatoImpianto = rs.getInt("id_stato_impianto");
		this.gestoreImpianto = rs.getString("gestore_impianto");
		this.idProcessoDepurativo = rs.getInt("id_processo_depurativo");
		this.potenzialitaImpiantoAE = rs.getString("potenzialita_impianto_ae");
		this.recettoreScarico = rs.getString("recettore_scarico");
		this.recettoreFinale = rs.getString("recettore_finale");
		this.codiceUlia = rs.getString("codice_ulia");

		this.enteredBy = rs.getInt("enteredby");
		this.modifiedBy = rs.getInt("modifiedby");
		this.entered = rs.getTimestamp("entered");
		this.modified = rs.getTimestamp("modified");
		this.trashedDate = rs.getTimestamp("trashed_date");

	}


	public DatoAcqueReflue (Connection db, int riferimentoId, String riferimentoIdNomeTab) throws SQLException{
		PreparedStatement pst = db.prepareStatement("select * from get_dati_acque_reflue(?, ?)");
		pst.setInt(1,  riferimentoId);
		pst.setString(2, riferimentoIdNomeTab);
		ResultSet rs = pst.executeQuery();
		while (rs.next()){
			buildRecord(rs);
		}
	}

	public static String upsert(Connection db, int riferimentoId, String riferimentoIdNomeTab, int userId, boolean depurazioneReflui, int idStatoImpianto, String gestoreImpianto, int idProcessoDepurativo, String potenzialitaImpiantoAE, String recettoreScarico, String recettoreFinale, String codiceUlia) throws SQLException {
		String messaggio = null;
		
		PreparedStatement pst = db.prepareStatement("select * from upsert_dati_acque_reflue(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
		int i = 0;
		pst.setInt(++i, riferimentoId);
		pst.setString(++i, riferimentoIdNomeTab);
		pst.setInt(++i, userId);
		pst.setBoolean(++i, depurazioneReflui);
		pst.setInt(++i, idStatoImpianto);
		pst.setString(++i, gestoreImpianto);
		pst.setInt(++i, idProcessoDepurativo);
		pst.setString(++i, potenzialitaImpiantoAE);
		pst.setString(++i, recettoreScarico);
		pst.setString(++i, recettoreFinale);
		pst.setString(++i, codiceUlia);


		ResultSet rs = pst.executeQuery();
		if (rs.next())
			messaggio = rs.getString(1);
		return messaggio;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public boolean isDepurazioneReflui() {
		return depurazioneReflui;
	}

	public void setDepurazioneReflui(boolean depurazioneReflui) {
		this.depurazioneReflui = depurazioneReflui;
	}

	public int getIdStatoImpianto() {
		return idStatoImpianto;
	}

	public void setIdStatoImpianto(int idStatoImpianto) {
		this.idStatoImpianto = idStatoImpianto;
	}

	public String getGestoreImpianto() {
		return gestoreImpianto;
	}

	public void setGestoreImpianto(String gestoreImpianto) {
		this.gestoreImpianto = gestoreImpianto;
	}

	public int getIdProcessoDepurativo() {
		return idProcessoDepurativo;
	}

	public void setIdProcessoDepurativo(int idProcessoDepurativo) {
		this.idProcessoDepurativo = idProcessoDepurativo;
	}

	public String getPotenzialitaImpiantoAE() {
		return potenzialitaImpiantoAE;
	}

	public void setPotenzialitaImpiantoAE(String potenzialitaImpiantoAE) {
		this.potenzialitaImpiantoAE = potenzialitaImpiantoAE;
	}

	public String getRecettoreScarico() {
		return recettoreScarico;
	}

	public void setRecettoreScarico(String recettoreScarico) {
		this.recettoreScarico = recettoreScarico;
	}

	public String getRecettoreFinale() {
		return recettoreFinale;
	}

	public void setRecettoreFinale(String recettoreFinale) {
		this.recettoreFinale = recettoreFinale;
	}

	public String getCodiceUlia() {
		return codiceUlia;
	}

	public void setCodiceUlia(String codiceUlia) {
		this.codiceUlia = codiceUlia;
	}

	public int getEnteredBy() {
		return enteredBy;
	}

	public void setEnteredBy(int enteredBy) {
		this.enteredBy = enteredBy;
	}

	public int getModifiedBy() {
		return modifiedBy;
	}

	public void setModifiedBy(int modifiedBy) {
		this.modifiedBy = modifiedBy;
	}

	public Timestamp getEntered() {
		return entered;
	}

	public void setEntered(Timestamp entered) {
		this.entered = entered;
	}

	public Timestamp getModified() {
		return modified;
	}

	public void setModified(Timestamp modified) {
		this.modified = modified;
	}

	public Timestamp getTrashedDate() {
		return trashedDate;
	}

	public void setTrashedDate(Timestamp trashedDate) {
		this.trashedDate = trashedDate;
	}

	public int getRiferimentoId() {
		return riferimentoId;
	}

	public void setRiferimentoId(int riferimentoId) {
		this.riferimentoId = riferimentoId;
	}

	public String getRiferimentoIdNomeTab() {
		return riferimentoIdNomeTab;
	}

	public void setRiferimentoIdNomeTab(String riferimentoIdNomeTab) {
		this.riferimentoIdNomeTab = riferimentoIdNomeTab;
	}

}
