package org.aspcfs.modules.dpat.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.HashMap;

import org.aspcfs.controller.SystemStatus;
import org.aspcfs.modules.admin.base.User;
import org.aspcfs.utils.DatabaseUtils;
import org.json.JSONArray;

import com.darkhorseventures.framework.beans.GenericBean;

public class DpatStrumentoCalcoloNominativi extends GenericBean {
	private int id ;
	private int idStrumentoCalcoloStruttura ;
	private int idAnagraficaNominativo ;
	private User nominativo=new User() ;
	
	private int idLookupQualifica ;
	private int caricoLavoroAnnuale ;
	private String fattoriIncidentiSuCarico ;
	private int percentualeDaSottrarre ;
	private int caricoEffettivoAnnuale ;
	private int somma_parziale ; 
	
	private int uba_ui ;
	
	private Timestamp dataScadenza ;
	
	private int codiceInternoFK ;
	
	private int stato = -1;
	
	public User getNominativo() {
		return nominativo;
	}
	public void setNominativo(User nominativo) {
		if (nominativo!=null)
		this.nominativo = nominativo;
	}
	
	
	public int getUba_ui() {
		return uba_ui;
	}
	public void setUba_ui(int uba_ui) {
		this.uba_ui = uba_ui;
	}
	public int getStato() {
		return stato;
	}
	public void setStato(int stato) {
		this.stato = stato;
	}
	public int getCodiceInternoFK() {
		return codiceInternoFK;
	}
	public void setCodiceInternoFK(int codiceInternoFK) {
		this.codiceInternoFK = codiceInternoFK;
	}
	public Timestamp getDataScadenza() {
		return dataScadenza;
	}
	public void setDataScadenza(Timestamp dataScadenza) {
		this.dataScadenza = dataScadenza;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getIdStrumentoCalcoloStruttura() {
		return idStrumentoCalcoloStruttura;
	}
	public void setIdStrumentoCalcoloStruttura(int idStrumentoCalcoloStruttura) {
		this.idStrumentoCalcoloStruttura = idStrumentoCalcoloStruttura;
	}
	public int getIdAnagraficaNominativo() {
		return idAnagraficaNominativo;
	}
	public void setIdAnagraficaNominativo(int idAnagraficaNominativo) {
		this.idAnagraficaNominativo = idAnagraficaNominativo;
	}
	public int getIdLookupQualifica() {
		return idLookupQualifica;
	}
	public void setIdLookupQualifica(int idLookupQualifica) {
		this.idLookupQualifica = idLookupQualifica;
	}
	public int getCaricoLavoroAnnuale() {
		return caricoLavoroAnnuale;
	}
	public void setCaricoLavoroAnnuale(int caricoLavoroAnnuale) {
		this.caricoLavoroAnnuale = caricoLavoroAnnuale;
	}
	public String getFattoriIncidentiSuCarico() {
		return fattoriIncidentiSuCarico;
	}
	public void setFattoriIncidentiSuCarico(String fattoriIncidentiSuCarico) {
		this.fattoriIncidentiSuCarico = fattoriIncidentiSuCarico;
	}
	public int getPercentualeDaSottrarre() {
		return percentualeDaSottrarre;
	}
	public void setPercentualeDaSottrarre(int percentualeDaSottrarre) {
		this.percentualeDaSottrarre = percentualeDaSottrarre;
	}
	public int getCaricoEffettivoAnnuale() {
		return caricoEffettivoAnnuale;
	}
	public void setCaricoEffettivoAnnuale(int caricoEffettivoAnnuale) {
		this.caricoEffettivoAnnuale = caricoEffettivoAnnuale;
	}
	
	private int modifiedBy ;
	private int enteredBy ;
	
	
	public int getModifiedBy() {
		return modifiedBy;
	}
	public void setModifiedBy(int modifiedBy) {
		this.modifiedBy = modifiedBy;
	}
	public int getEnteredBy() {
		return enteredBy;
	}
	public void setEnteredBy(int enteredBy) {
		this.enteredBy = enteredBy;
	}
	public void builRecord(ResultSet rs) throws SQLException
	{
		id = rs.getInt("id");
		idAnagraficaNominativo = rs.getInt("id_anagrafica_nominativo");
		idLookupQualifica = rs.getInt("id_lookup_qualifica");
		idStrumentoCalcoloStruttura = rs.getInt("id_dpat_strumento_calcolo_strutture");
		try
		{
			uba_ui = rs.getInt("uba_ui");
			caricoLavoroAnnuale = rs.getInt("carico_lavoro_annuale");
			fattoriIncidentiSuCarico = rs.getString("fattori_incidenti_su_carico");
			percentualeDaSottrarre = rs.getInt("percentuale_ui_da_sottrarre");
			caricoEffettivoAnnuale = rs.getInt("carico_lavoro_effettivo_annuale");
		}
		catch(Exception e)
		{
			System.out.println("Eccezione catturata: " + e.getMessage());
		}
		ResultSetMetaData rsmd = rs.getMetaData();
	    int columns = rsmd.getColumnCount();
	    for (int x = 1; x <= columns; x++) {
	        if ("somma".equals(rsmd.getColumnName(x))) {
	            somma_parziale = rs.getInt("somma");
	        }
	    }

	}
	public DpatStrumentoCalcoloNominativi ()
	{
		
	}
	
	
	public DpatStrumentoCalcoloNominativi (ResultSet rs) throws SQLException
	{
		this.builRecord(rs);
		
	}
//	public String toString()
//	{
//		
//		JSONObject obj = new JSONObject();
//		JSONArray array = new JSONArray(); 
//		JSONObject o = new JSONObject(st.getHashmapStabilimento());
//		array.put(o);
//		
//		String txt = "";
//		if (fattoriIncidentiSuCarico!= null )
//		{
//			txt = fattoriIncidentiSuCarico.replaceAll("'", "").replaceAll("\"", "").replaceAll("\n", "");
//			
//		}
//		String ret = "" ;
//		ret += "{_id_:_"+id+"_," ;
//		obj.put("_id_", id);
//		ret += "_idStrumentoCalcoloStruttura_:_"+idStrumentoCalcoloStruttura +"_," ;
//		obj.put("_idStrumentoCalcoloStruttura_", idStrumentoCalcoloStruttura);
//		ret += "_idAnagraficaNominativo_:_"+ idAnagraficaNominativo+"_," ;
//		obj.put("_idAnagraficaNominativo_", idAnagraficaNominativo);
//		ret += "_idLookupQualifica_:_"+idLookupQualifica +"_," ;
//		obj.put("_idLookupQualifica_", idLookupQualifica);
//		ret += "_caricoLavoroAnnuale_:_"+caricoLavoroAnnuale +"_," ;
//		obj.put("_caricoLavoroAnnuale_", caricoLavoroAnnuale);
//		ret += "_fattoriIncidentiSuCarico_:_"+txt+"_," ;
//		obj.put("_fattoriIncidentiSuCarico_", txt);
//		ret += "_percentualeDaSottrarre_:_"+percentualeDaSottrarre +"_," ;
//		obj.put("_percentualeDaSottrarre_", percentualeDaSottrarre);
//		ret += "_caricoEffettivoAnnuale_:_"+caricoEffettivoAnnuale +"_," ;
//		obj.put("_caricoEffettivoAnnuale_", caricoEffettivoAnnuale);
//		ret+="_anagrafica_:"+nominativo.toString()+"}";
//		obj.put("_anagrafica_", nominativo.toJson());
//		JSONArray array = new JSONArray(); 
//		array.put(obj);
//		return array.toString().replace(",}", "}") ;
//		
//	}
	
	public String toString()
	{
		
		JSONArray array = new JSONArray(); 
		HashMap<String, Object> obj = new HashMap<String, Object>();
		
		String txt = "";
		if (fattoriIncidentiSuCarico!= null )
		{
			txt = fattoriIncidentiSuCarico.replaceAll("'", "").replaceAll("\"", "").replaceAll("\n", "");
			
		}
		String ret = "" ;
		ret += "{_id_:_"+id+"_," ;
		obj.put("_id_", id);
		ret += "_idStrumentoCalcoloStruttura_:_"+idStrumentoCalcoloStruttura +"_," ;
		obj.put("_idStrumentoCalcoloStruttura_", idStrumentoCalcoloStruttura);
		ret += "_idAnagraficaNominativo_:_"+ idAnagraficaNominativo+"_," ;
		obj.put("_idAnagraficaNominativo_", idAnagraficaNominativo);
		ret += "_idLookupQualifica_:_"+idLookupQualifica +"_," ;
		obj.put("_idLookupQualifica_", idLookupQualifica);
		ret += "_caricoLavoroAnnuale_:_"+caricoLavoroAnnuale +"_," ;
		obj.put("_caricoLavoroAnnuale_", caricoLavoroAnnuale);
		ret += "_fattoriIncidentiSuCarico_:_"+txt+"_," ;
		obj.put("_fattoriIncidentiSuCarico_", txt);
		ret += "_percentualeDaSottrarre_:_"+percentualeDaSottrarre +"_," ;
		obj.put("_percentualeDaSottrarre_", percentualeDaSottrarre);
		ret += "_caricoEffettivoAnnuale_:_"+caricoEffettivoAnnuale +"_," ;
		obj.put("_caricoEffettivoAnnuale_", caricoEffettivoAnnuale);
		ret+="_anagrafica_:"+nominativo.toString2()+"}";
		
		
		
		return ret ;
		
	}
	public void insert(Connection db)
	{
		PreparedStatement pst = null;
		
		try
		{
			
			int id = DatabaseUtils.getNextInt(db, "dpat_strumento_calcolo_nominativi_", "id", 1);
			int statoCalcolato =1 ;
			if (stato>=0)
				 statoCalcolato = stato%2 ;
			String sql = "INSERT INTO dpat_strumento_calcolo_nominativi(id,id_anagrafica_nominativo, id_lookup_qualifica, carico_lavoro_annuale, fattori_incidenti_su_carico, percentuale_ui_da_sottrarre, carico_lavoro_effettivo_annuale,id_dpat_strumento_calcolo_strutture,entered_by,entered , stato , codice_interno_fk,uba_ui)VALUES (?,?, ?, ?, regexp_replace(?, E'[\\n\\r]+', ' ', 'g' ), ?, ?, ?,?,current_timestamp,?,?,?);" ;
			pst =db.prepareStatement(sql);
			pst.setInt(1, id);

			pst.setInt(2, idAnagraficaNominativo);
			pst.setInt(3, idLookupQualifica);
			pst.setInt(4, caricoLavoroAnnuale);
			pst.setString(5, fattoriIncidentiSuCarico);
			pst.setInt(6, percentualeDaSottrarre);
			pst.setInt(7, caricoEffettivoAnnuale);
			pst.setInt(8, idStrumentoCalcoloStruttura);
			pst.setInt(9, enteredBy);
			pst.setInt(10,statoCalcolato);
			if (codiceInternoFK>0)
				pst.setInt(11, codiceInternoFK);
			else
				pst.setInt(11, id);
			
			pst.setInt(12, uba_ui);
			
			pst.execute();
			
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		
	}
	
	public void insertConfig(Connection db)
	{
		PreparedStatement pst = null;
		
		try
		{
			
			String verifica = " select * from dpat_strumento_calcolo_nominativi_temp where id_anagrafica_nominativo ="+idAnagraficaNominativo;
			pst =db.prepareStatement(verifica);
			ResultSet rs = pst.executeQuery();
			if (!rs.next())
			{
			String sql = "INSERT INTO dpat_strumento_calcolo_nominativi_temp (id_anagrafica_nominativo, id_lookup_qualifica, carico_lavoro_annuale, fattori_incidenti_su_carico, percentuale_ui_da_sottrarre, carico_lavoro_effettivo_annuale,id_dpat_strumento_calcolo_strutture)VALUES (?, ?, ?, ?, ?, ?, ?);" ;
			pst =db.prepareStatement(sql);
			pst.setInt(1, idAnagraficaNominativo);
			pst.setInt(2, idLookupQualifica);
			pst.setInt(3, caricoLavoroAnnuale);
			pst.setString(4, fattoriIncidentiSuCarico);
			pst.setInt(5, percentualeDaSottrarre);
			pst.setInt(6, caricoEffettivoAnnuale);
			pst.setInt(7, idStrumentoCalcoloStruttura);
			
			
			pst.execute();
			}
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		
	}
	
	
	public void queryRecord(Connection db,int id)
	{
		PreparedStatement pst = null;
		ResultSet rs = null;
		try
		{
			
			String sql = "select id,id_anagrafica_nominativo,id_lookup_qualifica, id_dpat_strumento_calcolo_strutture" +
					" " +
					" from  dpat_strumento_calcolo_nominativi where id = ? and trashed_date is null" ;
			pst =db.prepareStatement(sql);
			pst.setInt(1, id);
			rs =  pst.executeQuery();
			if (rs.next())
				this.builRecord(rs);
			
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		
	}
	
	
	public void queryRecordConfig(Connection db,int id,SystemStatus system)
	{
		PreparedStatement pst = null;
		ResultSet rs = null;
		try
		{
			
			String sql = "select id,id_anagrafica_nominativo,id_lookup_qualifica,carico_lavoro_annuale" +
					",percentuale_ui_da_sottrarre,carico_lavoro_effettivo_annuale,id_dpat_strumento_calcolo_strutture," +
					"regexp_replace(fattori_incidenti_su_carico, E'[\\n\\r]+', ' ', 'g' ) as fattori_incidenti_su_carico " +
					" from  dpat_strumento_calcolo_nominativi_temp where id = ? and trashed_date is null" ;
			pst =db.prepareStatement(sql);
			pst.setInt(1, id);
			rs =  pst.executeQuery();
			if (rs.next())
			{
				this.builRecord(rs);
				nominativo =  system.getUser(idAnagraficaNominativo);
			}
			
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		
	}
	
	
	public void delete(Connection db)
	{
		PreparedStatement pst = null;
		
		try
		{
			String sql = "update dpat_strumento_calcolo_nominativi set trashed_Date =current_date where id = ?" ;
			pst =db.prepareStatement(sql);
			pst.setInt(1, id);
			pst.execute();
			
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		
	}
	
	public void deleteConfig(Connection db)
	{
		PreparedStatement pst = null;
		
		try
		{
			String sql = "update dpat_strumento_calcolo_nominativi_temp set trashed_Date =current_date where id = ?" ;
			pst =db.prepareStatement(sql);
			pst.setInt(1, id);
			pst.execute();
			
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		
	}
	
	
	public void congelaRisorsa(Connection db) throws SQLException
	{
		String update = "update dpat_strumento_calcolo_nominativi set stato = 2 where id = ?" ;
		PreparedStatement pst = null ;
		pst=  db.prepareStatement(update);
		pst.setInt(1, this.getId());
		pst.execute();
		
	
	}
	
	
	public void update(Connection db)
	{
		PreparedStatement pst = null;
		
		try
		{
			
			
			String sql = "UPDATE dpat_strumento_calcolo_nominativi SET data_scadenza=?,modified=current_timestamp,modified_by = ? WHERE id =?" ;
			pst =db.prepareStatement(sql);
			pst.setTimestamp(1, dataScadenza);
			pst.setInt(2, modifiedBy);
			
			pst.setInt(3, id);
			pst.execute();
			
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		
	}
	
	
	public DpatStrumentoCalcoloNominativi (Connection db,int id,SystemStatus system)
	{
		this.queryRecord(db, id);
		nominativo = system.getUser(idAnagraficaNominativo);
		
	}
	
	public void updateConfig(Connection db)
	{
		PreparedStatement pst = null;
		
		try
		{
			String sql = "UPDATE dpat_strumento_calcolo_nominativi_temp SET id_anagrafica_nominativo=?,id_lookup_qualifica=?, carico_lavoro_annuale=?, fattori_incidenti_su_carico=regexp_replace(?, E'[\\n\\r]+', ' ', 'g' ), percentuale_ui_da_sottrarre=?, carico_lavoro_effettivo_annuale=?,id_dpat_strumento_calcolo_strutture=? WHERE id =?" ;
			pst =db.prepareStatement(sql);
			pst.setInt(1, idAnagraficaNominativo);
			pst.setInt(2, idLookupQualifica);
			pst.setInt(3, caricoLavoroAnnuale);
			pst.setString(4, fattoriIncidentiSuCarico);
			pst.setInt(5, percentualeDaSottrarre);
			pst.setInt(6, caricoEffettivoAnnuale);
			pst.setInt(7, idStrumentoCalcoloStruttura);
			
			pst.setInt(8, id);
			pst.execute();
			
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		
	}
	public int getSomma_parziale() {
		return somma_parziale;
	}
	public void setSomma_parziale(int somma_parziale) {
		this.somma_parziale = somma_parziale;
	}
	
	
}
