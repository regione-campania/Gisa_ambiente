package org.aspcfs.modules.dpat.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;

import com.darkhorseventures.framework.beans.GenericBean;

public class DpatAnagraficaNominativo extends GenericBean {
	
	private String cognome ;
	private String nome ;
	private int id ;
	private int idAsl ;
	
	private String mail ;
	private String tel ;
	private String cf ;
	
	
	public DpatAnagraficaNominativo (){}
	public String getMail() {
		return mail;
	}
	public void setMail(String mail) {
		this.mail = mail;
	}
	public String getTel() {
		return tel;
	}
	public void setTel(String tel) {
		this.tel = tel;
	}
	public String getCf() {
		return cf;
	}
	public void setCf(String cf) {
		this.cf = cf;
	}
	
	public String getNominativo() {
		return nome + " "+cognome;
	}

	
	
	public String getCognome() {
		return cognome;
	}



	public void setCognome(String cognome) {
		this.cognome = cognome;
	}



	public String getNome() {
		return nome;
	}



	public void setNome(String nome) {
		this.nome = nome;
	}



	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getIdAsl() {
		return idAsl;
	}
	public void setIdAsl(int idAsl) {
		this.idAsl = idAsl;
	}
		
	
	
	public DpatAnagraficaNominativo(Connection db , int id,int idStruttura )
	{
		this.queryRecordConStruttura(db, id,idStruttura);
	}
	
	
	
	public void queryRecordConStruttura(Connection db , int id,int idStruttura)
	{
		PreparedStatement pst = null;
		ResultSet rs = null ;
		try
		{
			
		
			String sql = "select v1.user_id as id,v1.namelast as cognome,v1.namefirst as nome || ' ('||regexp_replace(v4.pathdes , '[\\s\\n\\r]+'::text, ' '::text, 'g'::text) || ')' as nome,"
					+ "vv.site_id as id_asl,v1.codice_fiscale as cf, '' as mail,'' as tel  " +
					"from contact v1 "
					+ " join access vv on v1.user_id = vv.user_id " +
					"join dpat_strumento_calcolo_nominativi v2 on v1.user_id = v2.id_anagrafica_nominativo " +
					"join dpat_strumento_calcolo_strutture v3 on v3.id = v2.id_dpat_strumento_calcolo_strutture " +
					"join dpat_strutture_asl v4 on v4.id = v3.id_struttura " +
					"where v1.disabled = false and v1.id = ? and v3.id_struttura = "+ idStruttura;
			pst =db.prepareStatement(sql);
			pst.setInt(1, id);
			rs = pst.executeQuery();
			if(rs.next())
				this.buildRecord(rs);
			
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	private void buildRecord(ResultSet rs) throws SQLException
	{
		
		id = rs.getInt("id"); 
		nome = rs.getString("nome");
		cognome = rs.getString("cognome");
		idAsl = rs.getInt("id_asl");
		cf = rs.getString("cf");
		mail = rs.getString("mail");
		tel = rs.getString("tel");
		
		
	}  
	
	
	
	
	
	
	public String toString()
	{
		
		HashMap<String, Object> obj = new HashMap<>();
		String ret = "" ;
		ret += "{_id_:_"+id+"_," ;
		obj.put("_id_", id);
		
		ret += "_nome_:_"+nome+"_," ;
		obj.put("_nome_", nome);
		
		ret += "_cognome_:_"+cognome.replaceAll("'", " ")+"_," ;
		obj.put("_cognome_", cognome);
		
		ret += "_idasl_:_"+idAsl+"_," ;
		obj.put("_idasl_", idAsl);
		
		ret += "_cf_:_"+ cf+"_," ;
		obj.put("_cf_", cf);
		
		ret += "_tel_:_"+ tel+"_," ;
		obj.put("_tel_", tel);
		
		ret += "_mail_:_"+ mail+"_}" ;
		obj.put("_mail_", mail);
		
		return ret ;
		
	}
	
	

}
