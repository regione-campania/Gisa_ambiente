package org.aspcfs.modules.aia.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.aspcfs.modules.base.Constants;
import org.postgresql.util.PSQLException;

public class ImpresaAIA {
	
	private String codiceFiscaleImpresa;
	
	private String partitaIva;
	private String ragioneSociale;
	private int enteredBy;
	private int modifiedBy;
	private Integer idIndirizzo;
	private Integer idImpresa;
	private String sedeLegale;
	private String domicilioDigitale;
	private Integer idSoggetto;
	private SoggettoFisico soggettoFisico;
	private String nominativoCf;
	private Integer idTipoImpresa;
	private Integer idTipoSocieta;
	
	private String tipoImpresa;
	private String tipoSocieta;
	private String codiceInternoImpresa;
	private Indirizzo sedeLegaleObj;

	public void queryRecordImpresaAIA(Connection db, int idImpresa) throws SQLException {
		if (idImpresa == -1) {
			throw new SQLException("Invalid Account");
		}

		PreparedStatement pst = db.prepareStatement(
				"Select a.*,l.description as tipo_impresa_testo from aia_impresa a   left join lookup_tipo_impresa_societa l on a.tipo_impresa=l.code where id = ?");
		pst.setInt(1, idImpresa);
		ResultSet rs = pst.executeQuery();
		if (rs.next()) {
			buildRecordImpresa(rs);
			queryIndirizzo(db,this.getIdImpresa());
			
			setSedeLegaleObj(new Indirizzo(db,getIdIndirizzo()));

			this.soggettoFisico = new SoggettoFisico(db,this.getIdSoggetto());
		}

		if (this.getIdImpresa() == -1) {
			throw new SQLException(Constants.NOT_FOUND_ERROR);
		}
		rs.close();
		pst.close();

	}
	
	
	public void queryIndirizzo(Connection db, int idImpresa) throws SQLException {
		if (idImpresa == -1) {
			throw new SQLException("Invalid Account");
		}

		PreparedStatement pst = db.prepareStatement(
				"select distinct("+
		 	"concat_ws(' ',nazione, ' - INDIRIZZO: ',"+
		 	"via,oi.cap, c.nome ,"+
		 	"lp.description) ) from aia_impresa ai join indirizzi oi on ai.id_indirizzo = oi.id left join comuni1 c on oi.comune=c.id left join lookup_province lp on lp.code=oi.provincia::int4  where ai.id=?;");
		pst.setInt(1, idImpresa);
		ResultSet rs = pst.executeQuery();
		if (rs.next()) {
			setSedeLegale(rs.getString("concat_ws"));
			
			//sedeOperativa = new Indirizzo(db, sedeOperativa.getIdIndirizzo());
			//listaLineeProduttive.setIdStabilimento(idStabilimento);
			//listaLineeProduttive.buildList(db);
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
		this.setIdIndirizzo(rs.getInt("id_indirizzo"));
		this.setDomicilioDigitale(rs.getString("domicilio_digitale"));
		this.setIdSoggetto(rs.getInt("id_soggetto_fisico"));
		this.setIdTipoImpresa(rs.getInt("tipo_impresa"));
		this.setTipoImpresa(rs.getString("tipo_impresa_testo"));

		this.setIdTipoSocieta(rs.getInt("tipo_societa"));
		this.setCodiceInternoImpresa(rs.getString("codice_interno_impresa"));
		
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
	
	
	public Integer getIdIndirizzo() {
		return idIndirizzo;
	}


	public void setIdIndirizzo(Integer idIndirizzo) {
		this.idIndirizzo = idIndirizzo;
	}
	
	public void setSedeLegale(String queryIndirizzo) {
		this.sedeLegale=queryIndirizzo;
		
	}
	
	public String getSedeLegale() {
		return this.sedeLegale;
		
	}


	public String getDomicilioDigitale() {
		return domicilioDigitale;
	}


	public void setDomicilioDigitale(String domicilioDigitale) {
		this.domicilioDigitale = domicilioDigitale;
	}


	public Integer getIdSoggetto() {
		return idSoggetto;
	}


	public void setIdSoggetto(Integer idSoggetto) {
		this.idSoggetto = idSoggetto;
	}


	public String getNominativoCf() {
		return nominativoCf;
	}


	public void setNominativoCf(String nominativoCf) {
		this.nominativoCf = nominativoCf;
	}


	public SoggettoFisico getSoggettoFisico() {
		return soggettoFisico;
	}


	public void setSoggettoFisico(SoggettoFisico soggettoFisico) {
		this.soggettoFisico = soggettoFisico;
	}


	public String getTipoImpresa() {
		return tipoImpresa;
	}


	public void setTipoImpresa(String tipoImpresa) {
		this.tipoImpresa = tipoImpresa;
	}


	public String getTipoSocieta() {
		return tipoSocieta;
	}


	public void setTipoSocieta(String tipoSocieta) {
		this.tipoSocieta = tipoSocieta;
	}


	public String getCodiceInternoImpresa() {
		return codiceInternoImpresa;
	}


	public void setCodiceInternoImpresa(String codiceInternoImpresa) {
		this.codiceInternoImpresa = codiceInternoImpresa;
	}


	public Integer getIdTipoImpresa() {
		return idTipoImpresa;
	}


	public void setIdTipoImpresa(Integer idTipoImpresa) {
		this.idTipoImpresa = idTipoImpresa;
	}


	public Integer getIdTipoSocieta() {
		return idTipoSocieta;
	}


	public void setIdTipoSocieta(Integer idtipoSocieta) {
		this.idTipoSocieta = idtipoSocieta;
	}


	public Indirizzo getSedeLegaleObj() {
		return sedeLegaleObj;
	}


	public void setSedeLegaleObj(Indirizzo sedeLegaleObj) {
		this.sedeLegaleObj = sedeLegaleObj;
	}

	
}
