package org.aspcfs.modules.aia.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import org.aspcfs.modules.aia.base.Indirizzo;

import org.aspcfs.modules.admin.base.User;
import org.aspcfs.modules.base.Constants;
import org.aspcfs.utils.GestoreConnessioni;
import org.directwebremoting.extend.LoginRequiredException;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.postgresql.util.PSQLException;

import com.darkhorseventures.framework.beans.GenericBean;

public class StabilimentoAIA extends GenericBean {
	
	public static final String OPERAZIONE_INSERIMENTO_OK = "1";
	public static final String OPERAZIONE_INSERIMENTO_KO_IMPRESA_ESISTENTE = "2";
	public static final String OPERAZIONE_INSERIMENTO_KO_STABILIMENTO_ESISTENTE = "4";
	public static final String OPERAZIONE_INSERIMENTO_KO_IMPRESA_ESISTENTE_ORGANIZATION = "organization";

	public static final int STATO_IN_DOMANDA = 3;
	public static final int STATO_AUTORIZZATO = 0;
	public static final int STATO_SOSPESO = 2;
	public static final int STATO_CESSATO = 4;

	public static final int STATO_RESPINTO = 6;
	public static final int STATO_REGISTRAZIONE_ND = 7;

	public static final int ATTIVITA_FISSA = 1;
	public static final int ATTIVITA_MOBILE = 2;
	
	
	private String entered;
	private Timestamp modified;
	private int enteredBy;
	private int modifiedBy;
	
	private String denominazione;
	private Integer idStabilimento;
	private Integer idImpresa;
	private Integer idAsl;
	private Integer TipoAttivita;
	private Integer idIndirizzo;
	private String numero_registrazione;
	private String ragioneSociale;

	private ImpresaAIA impresa;

	private JSONArray descrizioneIPPCJson;
	private String descrizioneIPPC;
	private String decreti;
	private JSONArray decretiJson;
	private String sedeStabilimento;
	private Integer idSoggettoFisico;
	private Boolean flagFuoriRegione;
	private Timestamp trashedDate;
	private Integer trashedBy;
	private String noteHd;
	private String numProtocollo;
	private String dipartimento;
	private SoggettoFisico responsabile;
	private Indirizzo sedeLegale;
	private User utenteInserimento;
	
	public StabilimentoAIA() {

		//rappLegale = new SoggettoFisico();
		//sedeOperativa = new Indirizzo();
		this.impresa = new ImpresaAIA();
		setRagioneSociale(impresa.getRagioneSociale());
		//this.setSedeOperativa(new Indirizzo());

	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	public String inserisci_stabilimento(Connection db, JSONObject jsonDati, int userId) throws Exception{

		String sql = "";
		PreparedStatement st = null;
		ResultSet rs = null;
		sql = "select * from public.insert_impianto(to_json(?::json),?)";
		st = db.prepareStatement(sql);
		st.setString(1, jsonDati.toString());
		st.setInt(2, userId);
		

		System.out.println(st);

		rs = st.executeQuery();
		String id_stabilimento = "";

		while(rs.next())
		{
			id_stabilimento = rs.getString("insert_impianto");
			
		}

		this.setIdStabilimento(id_stabilimento);
		System.out.println("stabilimento inserito: " + id_stabilimento);
		
		return id_stabilimento;
		}
		
	
	public String update_stabilimento(Connection db, JSONObject jsonDati, int userId) throws Exception{

		String sql = "";
		PreparedStatement st = null;
		ResultSet rs = null;
		sql = "select * from public.update_impianto(to_json(?::json),?)";
		st = db.prepareStatement(sql);
		st.setString(1, jsonDati.toString());
		st.setInt(2, userId);
		

		System.out.println(st);

		rs = st.executeQuery();
		String id_stabilimento = "";

		while(rs.next())
		{
			id_stabilimento = rs.getString("update_impianto");
			
		}

		this.setIdStabilimento(id_stabilimento);
		System.out.println("stabilimento inserito: " + id_stabilimento);
		
		return id_stabilimento;
		}
		

	
	public String update_ippc(Connection db, JSONObject jsonDati, int userId) throws Exception{

		String sql = "";
		PreparedStatement st = null;
		ResultSet rs = null;
		sql = "select * from public.update_ippc(to_json(?::json),?)";
		st = db.prepareStatement(sql);
		st.setString(1, jsonDati.toString());
		st.setInt(2, userId);
		

		System.out.println(st);

		rs = st.executeQuery();
		String id_stabilimento = "";

		while(rs.next())
		{
			id_stabilimento = rs.getString("update_ippc");
			
		}

		this.setIdStabilimento(id_stabilimento);
		System.out.println("ippc modificati: " + id_stabilimento);
		
		return id_stabilimento;
		}
		
	
	
	
	
	
	
	public String cambio_titolarita(Connection db, JSONObject jsonDati, int userId) throws Exception{

		String sql = "";
		PreparedStatement st = null;
		ResultSet rs = null;
		sql = "select * from public.cambio_titolarita_stabilimento_aia(to_json(?::json),?)";
		st = db.prepareStatement(sql);
		st.setString(1, jsonDati.toString());
		st.setInt(2, userId);
		

		System.out.println(st);

		rs = st.executeQuery();
		String id_stabilimento = "";

		while(rs.next())
		{
			id_stabilimento = rs.getString("cambio_titolarita_stabilimento_aia");
			
		}

		this.setIdStabilimento(id_stabilimento);
		System.out.println("stabilimento inserito: " + id_stabilimento);
		
		return id_stabilimento;
		}
	
	
	
	
	public StabilimentoAIA(Connection db, int idStab) throws SQLException {

		queryRecordStabilimentoAIA(db, idStab);
		impresa = new ImpresaAIA();
		impresa.queryRecordImpresaAIA(db, idImpresa);
		setResponsabile(new SoggettoFisico(db,idSoggettoFisico));
		//sedeLegale = new Indirizzo(db,getIdIndirizzo());
		utenteInserimento = new User(db,this.enteredBy);
		this.setRagioneSociale(impresa.getRagioneSociale());
	}
	
	
	public void queryRecordStabilimentoAIA(Connection db, int idStab) throws SQLException {
		if (idStab == -1) {
			throw new SQLException("Invalid Account");
		}

		PreparedStatement pst = db.prepareStatement(
				"Select o.*,impresa.ragione_sociale,to_char(entered, 'dd/mm/yyyy') as entered1, ls.description as dipartimento"
				+ "  "
				+ " from aia_stabilimento o join aia_impresa impresa on impresa.id=o.id_impresa left join lookup_site_id ls on"
				+ " id_asl =ls.code  where o.id = ?");
		pst.setInt(1, idStab);
		ResultSet rs = pst.executeQuery();
		if (rs.next()) {
			buildRecordStabilimento(rs);
			//sedeOperativa = new Indirizzo(db, sedeOperativa.getIdIndirizzo());
			setDescrizioneIPPCJson(buildDescrizioniIPPC(db,getIdStabilimento()));
			setDecretiJson(buildDecreti(db,getIdStabilimento()));
			queryIndirizzo(db,getIdStabilimento());
		}

		if (this.getIdStabilimento() == -1) {
			throw new SQLException(Constants.NOT_FOUND_ERROR);
		}
		rs.close();
		pst.close();

	}
	
	
	
	private JSONArray buildDescrizioniIPPC(Connection db,int idStabilimento2) throws SQLException {
		
		JSONArray json =null;
		
		PreparedStatement pst = db.prepareStatement(
				"select * from get_json_ippc(?);");
		pst.setInt(1, idStabilimento2);
		ResultSet rs = pst.executeQuery();
		if (rs.next()) {
			setDescrizioneIPPC(rs.getString("get_json_ippc"));
		}

		if (this.getIdStabilimento() == -1) {
			throw new SQLException(Constants.NOT_FOUND_ERROR);
		}
		rs.close();
		pst.close();
		
		
		try {
			json = new JSONArray(getDescrizioneIPPC());
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return json;
	}
	
	
public String controlloEsistenzaAiaImpresa(String partita_iva){
		
		String output = "[]";
		
		String sql = "select * from verifica_esistenza_impresa(?)";
		Connection db = null;
		try{
			db = GestoreConnessioni.getConnection();
			PreparedStatement pst = db.prepareStatement(sql);
			pst.setString(1, partita_iva);
			ResultSet rs= pst.executeQuery();
			
			System.out.println("query esistenza " + pst);
			while(rs.next())
			{
				output = rs.getString("verifica_esistenza_impresa");
			}
		
		}catch(LoginRequiredException e)
		{
			throw e;
		}catch(Exception e)
		{
			e.printStackTrace();		
		}
		finally
		{
			GestoreConnessioni.freeConnection(db);
		}
		
		return output;
		
}
	
	

	private JSONArray buildDecreti(Connection db,int idStabilimento2) throws SQLException {
		
		JSONArray json =null;
		
		PreparedStatement pst = db.prepareStatement(
				"select * from get_json_decreti(?);");
		pst.setInt(1, idStabilimento2);
		ResultSet rs = pst.executeQuery();
		if (rs.next()) {
			setDecreti(rs.getString("get_json_decreti"));
		}

		if (this.getIdStabilimento() == -1) {
			throw new SQLException(Constants.NOT_FOUND_ERROR);
		}
		rs.close();
		pst.close();
		
		
		try {
			json = new JSONArray(getDecreti());
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return json;
	}

	public void queryIndirizzo(Connection db, int idImpresa) throws SQLException {
		if (idImpresa == -1) {
			throw new SQLException("Invalid Account");
		}

		PreparedStatement pst = db.prepareStatement(
				"select distinct(case when via is not null then via || ',' || case when civico is not null then civico else '' end else '' end || ', ' || case when oi.cap is not null then oi.cap else '' end || "+ 
			" ' ' || case when c.nome is not null then c.nome else '' end || ', ' || case when lp.description is not null then lp.description else '' end ||', "+
			" Coordinate Geografiche X: ' || case when latitudine is not null then latitudine else 0 end ||', "+
			" Coordinate Geografiche Y: ' ||case when longitudine is not null then longitudine else 0 end  ) as indirizzo"+
			" from aia_stabilimento as2 "+
			" join indirizzi oi on as2.id_indirizzo = oi.id join comuni1 c on oi.comune=c.id join lookup_province lp on lp.code=oi.provincia::int4 "+
			" where as2.id=?;");

		pst.setInt(1, idImpresa);
		ResultSet rs = pst.executeQuery();
		if (rs.next()) {
			setSedeStabilimento(rs.getString("indirizzo"));
		}

		if (this.getIdImpresa() == -1) {
			throw new SQLException(Constants.NOT_FOUND_ERROR);
		}
		rs.close();
		pst.close();

	}



	



	protected void buildRecordStabilimento(ResultSet rs) throws SQLException {

		// this.setDataCessazione(rs.getTimestamp("data_cessazione"));
		
		try {
			this.setDenominazione(rs.getString("denominazione"));
		} catch (PSQLException e) {

		}

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
		this.setEnteredBy(rs.getInt("entered_by"));
		this.setModifiedBy(rs.getInt("modified_by"));
		this.setIdImpresa(rs.getInt("id_impresa"));
		this.setIdAsl(rs.getInt("id_asl"));
		this.setIdIndirizzo(rs.getInt("id_indirizzo"));
		setNumero_registrazione(rs.getString("numero_registrazione"));
		
		try {
			this.setIdSoggettoFisico(rs.getInt("id_soggetto_fisico"));
		} catch (PSQLException e) {

		}
		
		this.setFlagFuoriRegione(rs.getBoolean("flag_fuori_regione"));
		
		this.setTrashedDate(rs.getTimestamp("trashed_date"));
		this.setTrashedBy(rs.getInt("trashed_by"));

		this.setNumProtocollo(rs.getString("num_protocollo"));
		this.setDipartimento(rs.getString("dipartimento"));
	}


	public String getDenominazione() {
		return denominazione;
	}


	public void setDenominazione(String denominazione) {
		this.denominazione = denominazione;
	}


	


	public int getIdAsl() {
		return idAsl;
	}


	public void setIdAsl(Integer idAsl) {
		this.idAsl = idAsl;
	}


	public Integer getTipoAttivita() {
		return TipoAttivita;
	}


	public void setTipoAttivita(Integer tipoAttivita) {
		TipoAttivita = tipoAttivita;
	}


	public Integer getIdIndirizzo() {
		return idIndirizzo;
	}


	public void setIdIndirizzo(Integer idIndirizzo) {
		this.idIndirizzo = idIndirizzo;
	}


	

	public String getNumero_registrazione() {
		return numero_registrazione;
	}


	public void setNumero_registrazione(String numero_registrazione) {
		this.numero_registrazione = numero_registrazione;
	}


	public String getEntered() {
		return entered;
	}


	public void setEntered(String string) {
		this.entered = string;
	}


	public Timestamp getModified() {
		return modified;
	}


	public void setModified(Timestamp modified) {
		this.modified = modified;
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


	public Integer getIdImpresa() {
		return idImpresa;
	}


	public void setIdImpresa(Integer idImpresa) {
		this.idImpresa = idImpresa;
	}



	public String getRagioneSociale() {
		return ragioneSociale;
	}



	public void setRagioneSociale(String ragioneSociale) {
		this.ragioneSociale = ragioneSociale;
	}

	
	
	public ImpresaAIA getImpresa() {
		return impresa;
	}



	

	public JSONArray getDescrizioneIPPCJson() {
		return descrizioneIPPCJson;
	}




	public void setDescrizioneIPPCJson(JSONArray jsonArray) {
		this.descrizioneIPPCJson = jsonArray;
	}



	public String getDescrizioneIPPC() {
		return descrizioneIPPC;
	}



	public void setDescrizioneIPPC(String descrizioneIPPC) {
		this.descrizioneIPPC = descrizioneIPPC;
	}



	public String getDecreti() {
		return decreti;
	}




	public void setDecreti(String decreti) {
		this.decreti = decreti;
	}




	public JSONArray getDecretiJson() {
		return decretiJson;
	}



	public void setDecretiJson(JSONArray decretiJson) {
		this.decretiJson = decretiJson;
	}



	public String getSedeStabilimento() {
		return sedeStabilimento;
	}



	public void setSedeStabilimento(String sedeStabilimento) {
		this.sedeStabilimento = sedeStabilimento;
	}





	public Integer getIdSoggettoFisico() {
		return idSoggettoFisico;
	}



	public void setIdSoggettoFisico(Integer idSoggettoFisico) {
		this.idSoggettoFisico = idSoggettoFisico;
	}



	public Boolean getFlagFuoriRegione() {
		return flagFuoriRegione;
	}




	public void setFlagFuoriRegione(Boolean flagFuoriRegione) {
		this.flagFuoriRegione = flagFuoriRegione;
	}




	public Timestamp getTrashedDate() {
		return trashedDate;
	}




	public void setTrashedDate(Timestamp trashedDate) {
		this.trashedDate = trashedDate;
	}





	public Integer getTrashedBy() {
		return trashedBy;
	}



	public void setTrashedBy(Integer trashedBy) {
		this.trashedBy = trashedBy;
	}



	public String getNoteHd() {
		return noteHd;
	}





	public void setNoteHd(String noteHd) {
		this.noteHd = noteHd;
	}






	public String getNumProtocollo() {
		return numProtocollo;
	}






	public void setNumProtocollo(String numProtocollo) {
		this.numProtocollo = numProtocollo;
	}













	public String getDipartimento() {
		return dipartimento;
	}













	public void setDipartimento(String dipartimento) {
		this.dipartimento = dipartimento;
	}













	public SoggettoFisico getResponsabile() {
		return responsabile;
	}













	public void setResponsabile(SoggettoFisico responsabile) {
		this.responsabile = responsabile;
	}













	public Indirizzo getSedeLegale() {
		return sedeLegale;
	}













	public void setSedeLegale(Indirizzo sedeLegale) {
		this.sedeLegale = sedeLegale;
	}













	public User getUtenteInserimento() {
		return utenteInserimento;
	}













	public void setUtenteInserimento(User utenteInserimento) {
		this.utenteInserimento = utenteInserimento;
	}
	
	
}
