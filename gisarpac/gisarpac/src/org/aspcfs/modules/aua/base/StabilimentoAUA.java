package org.aspcfs.modules.aua.base;



import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import org.aspcfs.modules.admin.base.User;
import org.aspcfs.modules.aia.base.ImpresaAIA;
import org.aspcfs.modules.aia.base.SoggettoFisico;
import org.aspcfs.modules.base.Constants;
import org.json.JSONObject;
import org.postgresql.util.PSQLException;

import com.darkhorseventures.framework.beans.GenericBean;

public class StabilimentoAUA extends GenericBean {
	private User utenteInserimento;
	private ImpresaAUA impresa;
	private String ragioneSociale;
	private Integer idImpresa;
	private String entered;
	private Timestamp modified;
	private int enteredBy;
	private int modifiedBy;
	private String ciureg;
	private String ciuprov;
	private Integer anno;
	private Integer numeroSchedeAut;
	private Integer mesiAttivita;
	public StabilimentoAUA() {

		
	}
	
	public StabilimentoAUA(Connection db, int idStab) throws SQLException {

		queryRecordStabilimentoAUA(db, idStab);
		impresa = new ImpresaAUA();
		impresa.queryRecordImpresaAUA(db, idImpresa);
		//sedeLegale = new Indirizzo(db,getIdIndirizzo());
		setUtenteInserimento(new User(db,this.enteredBy));
		this.setRagioneSociale(impresa.getRagioneSociale());
	}
	
	
	public void queryRecordStabilimentoAUA(Connection db, int idStab) throws SQLException {
		if (idStab == -1) {
			throw new SQLException("Invalid Account");
		}

		PreparedStatement pst = db.prepareStatement(
				"Select o.*,impresa.ragione_sociale,to_char(entered, 'dd/mm/yyyy') as entered1, ls.description as dipartimento"
				+ "  "
				+ " from aua_stabilimento o join aua_impresa impresa on impresa.id=o.id_impresa left join lookup_site_id ls on"
				+ " id_asl =ls.code  where o.id = ?");
		pst.setInt(1, idStab);
		ResultSet rs = pst.executeQuery();
		if (rs.next()) {
			buildRecordStabilimento(rs);
			//sedeOperativa = new Indirizzo(db, sedeOperativa.getIdIndirizzo());
		}

		if (this.getIdStabilimento() == -1) {
			throw new SQLException(Constants.NOT_FOUND_ERROR);
		}
		rs.close();
		pst.close();

	}
	
	protected void buildRecordStabilimento(ResultSet rs) throws SQLException {

		this.setCiureg(rs.getString("ciureg"));
		this.setCiuprov(rs.getString("ciuprov"));

		this.setAnno(rs.getInt("anno"));
		this.setNumeroSchedeAut(rs.getInt("num_schede_aut"));
		this.setMesiAttivita(rs.getInt("mesi_attivita"));


		try {
			this.setRagioneSociale(rs.getString("ragione_sociale"));
		} catch (PSQLException e) {

		}

		
		this.setIdStabilimento(rs.getInt("id"));
		// R.M: non so il motivo per cui era settato l'org_id con l'id dello
		// stabilimento...
		// this.setOrgId(this.getIdStabilimento());
		this.setEntered(rs.getString("entered1"));
		this.setModified(rs.getTimestamp("modified"));
		this.setModifiedBy(rs.getInt("modified_by"));
		this.setIdImpresa(rs.getInt("id_impresa"));
		this.setIdAsl(rs.getInt("id_asl"));
		

	
	}
	
	
	public String inserisci_stabilimento(Connection db, JSONObject jsonDati, int userId) throws Exception{

		String sql = "";
		PreparedStatement st = null;
		ResultSet rs = null;
		sql = "select * from public.insert_aua(to_json(?::json),?)";
		st = db.prepareStatement(sql);
		st.setString(1, jsonDati.toString());
		st.setInt(2, userId);
		

		System.out.println(st);

		rs = st.executeQuery();
		String id_stabilimento = "";

		while(rs.next())
		{
			id_stabilimento = rs.getString("insert_aua");
			
		}

		this.setIdStabilimento(id_stabilimento);
		System.out.println("stabilimento inserito: " + id_stabilimento);
		
		return id_stabilimento;
		}

	public User getUtenteInserimento() {
		return utenteInserimento;
	}

	public void setUtenteInserimento(User utenteInserimento) {
		this.utenteInserimento = utenteInserimento;
	}

	

	public String getRagioneSociale() {
		return ragioneSociale;
	}

	public void setRagioneSociale(String ragioneSociale) {
		this.ragioneSociale = ragioneSociale;
	}

	public String getEntered() {
		return entered;
	}

	public void setEntered(String entered) {
		this.entered = entered;
	}

	public Timestamp getModified() {
		return modified;
	}

	public void setModified(Timestamp modified) {
		this.modified = modified;
	}

	public int getModifiedBy() {
		return modifiedBy;
	}

	public void setModifiedBy(int modifiedBy) {
		this.modifiedBy = modifiedBy;
	}
	
	
	public Integer getIdImpresa() {
		return idImpresa;
	}

	public void setIdImpresa(Integer idImpresa) {
		this.idImpresa = idImpresa;
	}

	public String getCiureg() {
		return ciureg;
	}

	public void setCiureg(String ciureg) {
		this.ciureg = ciureg;
	}

	public String getCiuprov() {
		return ciuprov;
	}

	public void setCiuprov(String ciuprov) {
		this.ciuprov = ciuprov;
	}

	public Integer getAnno() {
		return anno;
	}

	public void setAnno(Integer anno) {
		this.anno = anno;
	}

	public Integer getNumeroSchedeAut() {
		return numeroSchedeAut;
	}

	public void setNumeroSchedeAut(Integer numeroSchedeAut) {
		this.numeroSchedeAut = numeroSchedeAut;
	}

	public Integer getMesiAttivita() {
		return mesiAttivita;
	}

	public void setMesiAttivita(Integer mesiAttivita) {
		this.mesiAttivita = mesiAttivita;
	}
	
	
}
