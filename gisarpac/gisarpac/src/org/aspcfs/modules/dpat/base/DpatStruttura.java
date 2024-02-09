package org.aspcfs.modules.dpat.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import org.aspcfs.modules.oia.base.OiaNodo;

public class DpatStruttura extends OiaNodo{

	private static final long serialVersionUID = 4863684932367322549L;
	
	private int caricoInUi;
	private double saldo;
	private int ubaUi ;
	private ArrayList<DpatStruttura> lista_nodiDpat = new ArrayList<DpatStruttura>();
	private ArrayList<DpatStrutturaIndicatore> elenco = new ArrayList<DpatStrutturaIndicatore>();
	
	public ArrayList<DpatStruttura> getLista_nodiDpat() {
		return lista_nodiDpat;
	}

	public void setLista_nodiDpat(ArrayList<DpatStruttura> lista_nodi) {
		this.lista_nodiDpat = lista_nodi;
	}
	
	
	/*
	public static ArrayList<DpatStruttura> loadbyidRegioneDpat(int idregione, Connection db)
	{

		ArrayList<DpatStruttura>				ret		=  new ArrayList<DpatStruttura>();
		PreparedStatement	stat	= null;
		ResultSet			res		= null;

		
			try
			{

				String sql ="SELECT distinct  oia_n.*, asl.short_description as asl_stringa" +
				",o.org_id,tipooia.code as tipologia_struttura,tipooia.description as descrizione_tipologia_struttura,cmni.comune as descrizione_comune " +
				"FROM oia_nodo oia_n " +
				"LEFT JOIN comuni cmni on cmni.codiceistatcomune = oia_n.comune::text " +
				"LEFT JOIN organization o on (oia_n.id_asl = o.site_id and o.tipologia =6) " +
				"LEFT JOIN lookup_tipologia_nodo_oia tipooia ON oia_n.tipologia_struttura = tipooia.code " +
				"LEFT JOIN lookup_site_id asl ON oia_n.id_asl = asl.code " +
				"left join oia_nodo_responsabili responsabili on oia_n.id = responsabili.id_oia_nodo " +
				"WHERE oia_n.trashed_date IS NULL  and oia_n.n_livello =0 " 
				;

				
					sql+=" AND  oia_n.id = "+idregione+" and id_asl <=0 " ;
				sql+= " order by descrizione_lunga ";

				stat	= db.prepareStatement( sql );

				res		= stat.executeQuery();
				while( res.next() )
				{
					DpatStruttura n = (DpatStruttura) loadResultSetDpat( res ) ;
					n.buildlistResponsabili(db);
					if(n.getN_livello()<=3)
						load_figliDpat(n,db);
					ret.add(n);

				}

				// Recupero stringa relativa alla tipologia di competenza.
				//				OiaTipologiaCompetenzaNodo tcn = OiaTipologiaCompetenzaNodo.load_by_id_nodo_oia(id, db);

			}
			catch (Exception e)
			{
				e.printStackTrace();
			}
			finally
			{
				try
				{
					if( res != null )
					{
						res.close();
						res = null;
					}

					if( stat != null )
					{
						stat.close();
						stat = null;
					}
				}
				catch (Exception e)
				{
					e.printStackTrace();
				}
			
		}

		return ret;

	}
	
	public static ArrayList<DpatStruttura> loadbyidAslDpat(String id, Connection db)
	{

		ArrayList<DpatStruttura>				ret		=  new ArrayList<DpatStruttura>();
		PreparedStatement	stat	= null;
		ResultSet			res		= null;

		if( (id != null) && ! id.equals("") )
		{
			try
			{
				int iid = Integer.parseInt( id );

				String sql ="SELECT distinct  oia_n.*, asl.short_description as asl_stringa" +
				",o.org_id,tipooia.code as tipologia_struttura,tipooia.description as descrizione_tipologia_struttura,cmni.comune as descrizione_comune " +
				"FROM oia_nodo oia_n " +
				"LEFT JOIN comuni cmni on cmni.codiceistatcomune = oia_n.comune::text " +
				"LEFT JOIN organization o on (oia_n.id_asl = o.site_id and o.tipologia =6) " +
				"LEFT JOIN lookup_tipologia_nodo_oia tipooia ON oia_n.tipologia_struttura = tipooia.code " +
				"LEFT JOIN lookup_site_id asl ON oia_n.id_asl = asl.code " +
				"left join oia_nodo_responsabili responsabili on oia_n.id = responsabili.id_oia_nodo " +
				"WHERE oia_n.trashed_date IS NULL  and oia_n.n_livello =1 " +
				" AND  asl.enabled=true ";

				if (Integer.parseInt(id)>0)
					sql+=" AND  asl.code = " +id;
				sql+= " order by descrizione_lunga ";

				stat	= db.prepareStatement( sql );

				res		= stat.executeQuery();
				while( res.next() )
				{
					DpatStruttura n = (DpatStruttura) loadResultSetDpat( res ) ;
					n.buildlistResponsabili(db);
					if(n.getN_livello()<=3)
						load_figliDpat(n,db);
					ret.add(n);

				}

				// Recupero stringa relativa alla tipologia di competenza.
				//				OiaTipologiaCompetenzaNodo tcn = OiaTipologiaCompetenzaNodo.load_by_id_nodo_oia(id, db);

			}
			catch (Exception e)
			{
				e.printStackTrace();
			}
			finally
			{
				try
				{
					if( res != null )
					{
						res.close();
						res = null;
					}

					if( stat != null )
					{
						stat.close();
						stat = null;
					}
				}
				catch (Exception e)
				{
					e.printStackTrace();
				}
			}
		}

		return ret;
	}
	
	public static OiaNodo load_figliDpat( DpatStruttura oia_n, Connection db )
	{
		ArrayList<DpatStruttura>	ret	= new ArrayList<DpatStruttura>();
		PreparedStatement	stat= null;
		ResultSet			res	= null;

		String sql ="SELECT distinct oia_n.oia_nodo_fk, "+ 
"oia_n.id,oia_n.id_padre,oia_n.id_Asl,oia_n.mail,oia_n.nome,oia_n.descrizione_lunga,oia_n.n_livello,oia_n.id_utente,oia_n.entered,oia_n.entered_by,oia_n.modified,oia_n.modified_by,"+
"oia_n.trashed_Date,oia_n.tipologia_struttura,oia_n.comune,oia_n.indirizzo,oia_n.delegato, asl.short_description as asl_stringa," +
		"o.org_id,tipooia.code as tipologia_struttura,tipooia.description as descrizione_tipologia_struttura,cmni.comune as descrizione_comune " +
		"FROM oia_nodo oia_n " +
		"LEFT JOIN comuni cmni on cmni.codiceistatcomune = oia_n.comune::text " +
		"LEFT JOIN organization o on (oia_n.id_asl = o.site_id and o.tipologia =6) " +
		"LEFT JOIN lookup_site_id asl ON oia_n.id_asl = asl.code AND asl.enabled=true " +
		"LEFT JOIN lookup_tipologia_nodo_oia tipooia ON oia_n.tipologia_struttura = tipooia.code " +
		"WHERE oia_n.trashed_date IS NULL AND oia_n.id_padre= ? " ;
		
		if (oia_n.getId_asl()<=0)
		{ 
			sql += " and oia_n.id_asl <0";
		}
		sql += " order by descrizione_lunga ";



		try
		{
			stat = db.prepareStatement( sql );
			stat.setInt( 1,oia_n.getId()  );

			res		= stat.executeQuery();
			while( res.next() )
			{
				DpatStruttura oia_n_f = (DpatStruttura) loadResultSetDpat( res) ;
				oia_n_f.buildlistResponsabili(db);


				load_figliDpat( oia_n_f,  db );
				ret.add( oia_n_f )	;
				oia_n.setLista_nodiDpat(ret);

			}
		}
		catch (Exception e)
		{ 
			e.printStackTrace();
		}
		finally
		{
			try
			{
				if( res != null )
				{
					res.close();
					res = null;
				}

				if( stat != null )
				{
					stat.close();
					stat = null;
				}
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}
		}

		return oia_n;
	}
	
	public static DpatStruttura loadResultSetDpat( ResultSet res ) throws SQLException, IllegalArgumentException, IllegalAccessException, InvocationTargetException
	{

		DpatStruttura ret = new DpatStruttura();

		ret.setId(res.getInt("id"));
		ret.setOrg_id(res.getInt("org_id"));
		ret.setDescrizione_lunga(res.getString("descrizione_lunga"));
		ret.setN_livello(res.getInt("n_livello"));
		ret.setId_padre(res.getInt("id_padre"));
		ret .setNome(res.getString("nome"));
		ret.setId_asl(res.getInt("id_asl"));
		ret.setDescrizione_tipologia_struttura(res.getString("descrizione_tipologia_struttura"));
		ret.setTipologia_struttura(res.getInt("tipologia_struttura"));
		ret.setAsl_stringa(res.getString("asl_stringa"));
		ret.setComune(res.getInt("comune"));
		ret.setIndirizzo(res.getString("indirizzo"));
		ret.setMail(res.getString("mail"));
		ret.setName(ret.getDescrizione_lunga());
		ret.setDescrizione_comune(res.getString("descrizione_comune"));
		ret.setOrgId(ret.getOrg_id());
		ret.setSiteId(ret.getId_asl());
		ret.setDelegato(res.getInt("delegato"));
//		ret.setOiaNodoFk(res.getInt("oia_nodo_fk"));
		return ret ;
	} */

	public int getUbaUi() {
		return ubaUi;
	}

	public void setUbaUi(int ubaUi) {
		this.ubaUi = ubaUi;
	}

	public ArrayList<DpatStrutturaIndicatore> getElenco() {
		return elenco;
	}

	public void setElenco(ArrayList<DpatStrutturaIndicatore> elenco) {
		this.elenco = elenco;
	}
	
	public void buildElenco(Connection db, int id, int idDpat,int idAreaSelezionata){
		try
		{			
			String sql = "select * from dpat_struttura_indicatore where enabled=true and id_struttura="+id+" and id_dpat="+idDpat+" ";
			
			if (idAreaSelezionata>0)
				sql+= " and id_struttura=? ";
					sql+="order by descr_sezione,descr_piano,descr_attivita,descr_indicatore";
			PreparedStatement pst = db.prepareStatement(sql);
			if (idAreaSelezionata>0)
				pst.setInt(1, idAreaSelezionata);
			ResultSet rs = pst.executeQuery() ;
			while (rs.next())
			{
				DpatStrutturaIndicatore dsi = new DpatStrutturaIndicatore();
				dsi.builRecord(rs.getInt("id"), db);
				this.elenco.add(dsi);
			}
			rs.close();
			pst.close();
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
	}
	
	public void builRecord(int id,Connection db){ 
		try 
		{
			String sql = "select * from oia_nodo where id="+id ;
			PreparedStatement pst = db.prepareStatement(sql);
			ResultSet rs = pst.executeQuery() ;
			while (rs.next()){	
				this.setId(id);
				this.setId_padre(rs.getInt("id_padre"));
				this.setIdAsl(rs.getInt("id_asl"));
				this.setDescrizione_lunga(rs.getString("descrizione_lunga"));
				this.setN_livello(rs.getInt("n_livello"));
				this.setEntered(rs.getTimestamp("entered"));
				this.setModified(rs.getTimestamp("modified"));
				this.setEntered_by(rs.getInt("entered_by"));
				this.setModified_by(rs.getInt("modified_by"));
				this.setTrashed_date(rs.getTimestamp("trashed_date"));
				this.setTipologia_struttura(rs.getInt("tipologia_struttura"));
			
				
			}
			rs.close();
			pst.close();
		}
		catch(SQLException e){
			e.printStackTrace();
		}
	}

	public int calcolaCaricoInUi(int idStrutt, int anno, Connection db) {
	//	String sql ="select ui from dpat_ui_struttura where id_struttura="+idStrutt+" and id_dpat="+idDpat;
		String sql ="select case when a.anno=2016 then a.ui_struttura_foglio_att_iniziale else a.carico_lavoro_effettivo  end as carico_lavoro_effettivo " +
				"from oia_nodo a " +
				"join dpat_strumento_calcolo b on a.id_strumento_calcolo = b.id " +
				"where a.trashed_Date is null and a.id="+idStrutt+" and b.anno="+anno;
		PreparedStatement pst = null;
		ResultSet rs = null;
		try {
			pst =db.prepareStatement(sql);
			rs = pst.executeQuery();
			while(rs.next()){
				this.setCaricoInUi(rs.getInt(1));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return caricoInUi;
	}
	
	public int getCaricoInUi() {
		return caricoInUi;
	} 
	
	public void setCaricoInUi(int caricoInUi) {
		this.caricoInUi = caricoInUi;
	}

	public double getSaldo() {
		return saldo;
	}

	public void setSaldo(double saldo) { 
		this.saldo = saldo;
	}

}
