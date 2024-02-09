package org.aspcfs.modules.gestioneispettive.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.darkhorseventures.framework.beans.GenericBean;

public class Anagrafica extends GenericBean {

	private String ragioneSociale;
	private String partitaIva;
	private String numRegistrazione;

	private int riferimentoId;
	private String riferimentoIdNomeTab;


	public Anagrafica() { 

	}

	public Anagrafica(Connection db, int riferimentoId, String riferimentoIdNomeTab) throws SQLException {
		PreparedStatement pst = db.prepareStatement("select * from public.get_anagrafica_by_id(?,?);");
		pst.setInt(1, riferimentoId);
		pst.setString(2, riferimentoIdNomeTab);
		ResultSet rs = pst.executeQuery();
		if (rs.next()){
			buildRecord(rs);
		}

	}

	private void buildRecord(ResultSet rs) throws SQLException{
		this.riferimentoId = rs.getInt("riferimento_id");
		this.riferimentoIdNomeTab = rs.getString("riferimento_id_nome_tab");
		this.ragioneSociale = rs.getString("ragione_sociale");
		this.partitaIva = rs.getString("partita_iva");
		this.numRegistrazione = rs.getString("n_reg");

	}

	public String getRagioneSociale() {
		return ragioneSociale;
	}
	public void setRagioneSociale(String ragioneSociale) {
		this.ragioneSociale = ragioneSociale;
	}
	public String getPartitaIva() {
		return partitaIva;
	}
	public void setPartitaIva(String partitaIva) {
		this.partitaIva = partitaIva;
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

	public String getNumRegistrazione() {
		return numRegistrazione;
	}

	public void setNumRegistrazione(String numRegistrazione) {
		this.numRegistrazione = numRegistrazione;
	}

}
