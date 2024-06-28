package org.aspcfs.modules.aua.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.aspcfs.modules.base.Constants;
import org.postgresql.util.PSQLException;

public class ImpresaAUA {
	
	private String codiceFiscaleImpresa;
	
	private String partitaIva;
	private String ragioneSociale;
	private int enteredBy;
	private int modifiedBy;
	private Integer idImpresa;


	public void queryRecordImpresaAUA(Connection db, int idImpresa) throws SQLException {
		if (idImpresa == -1) {
			throw new SQLException("Invalid Account");
		}

		PreparedStatement pst = db.prepareStatement(
				"Select a.* from aua_impresa a   where id = ?");
		pst.setInt(1, idImpresa);
		ResultSet rs = pst.executeQuery();
		if (rs.next()) {
			buildRecordImpresa(rs);
					}

		if (this.getIdImpresa() == -1) {
			throw new SQLException(Constants.NOT_FOUND_ERROR);
		}
		rs.close();
		pst.close();

	}
	
	
	
	
	
	protected void buildRecordImpresa(ResultSet rs) throws SQLException {

		// this.setDataCessazione(rs.getTimestamp("data_cessazione"));
		
		try {
			this.setCodiceFiscaleImpresa(rs.getString("codice_fiscale_impresa"));
		} catch (PSQLException e) {

		}

		try {
			this.setPartitaIva(rs.getString("partita_iva"));
		} catch (PSQLException e) {

		}

		try {
			this.setRagioneSociale(rs.getString("ragione_sociale"));
		} catch (PSQLException e) {

		}

		
		//this.setEnteredBy(rs.getInt("entered_by"));
		//this.setModifiedBy(rs.getInt("modified_by"));
		this.setIdImpresa(rs.getInt("id"));
	
		
	}

	
	public Integer getIdImpresa() {
		return idImpresa;
	}


	public void setIdImpresa(Integer idImpresa) {
		this.idImpresa = idImpresa;
	}
	
	public String getCodiceFiscaleImpresa() {
		return codiceFiscaleImpresa;
	}


	public void setCodiceFiscaleImpresa(String codiceFiscaleImpresa) {
		this.codiceFiscaleImpresa = codiceFiscaleImpresa;
	}
	
	public String getPartitaIva() {
		return partitaIva;
	}


	public void setPartitaIva(String partitaIva) {
		this.partitaIva = partitaIva;
	}
	
	
	public String getRagioneSociale() {
		return ragioneSociale;
	}


	public void setRagioneSociale(String ragioneSociale) {
		this.ragioneSociale = ragioneSociale;
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
	
	
	
	
}
