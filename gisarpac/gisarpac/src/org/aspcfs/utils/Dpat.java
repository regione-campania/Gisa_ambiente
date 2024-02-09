package org.aspcfs.utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import org.aspcfs.modules.dpat2019.base.DpatSezioneNewBean;
import org.aspcfs.modules.dpat2019.base.DpatSezioneNewBeanPreCong;
import org.aspcfs.modules.dpat2019.base.oia.OiaNodo;
import org.directwebremoting.extend.LoginRequiredException;

public class Dpat {

	

	public static OiaNodo[] getAreeStruttureComplesse(int idAsl, int anno, int idStruttura) throws SQLException {

		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		ArrayList<OiaNodo> lista = new ArrayList<OiaNodo>();
		try {
			db = GestoreConnessioni.getConnection();

			String sql = "select dpat_strutture_asl.*,tipooia.description as descrizione_tipologia_struttura "
					+ "from "
					+ "dpat_strutture_asl "
					+ "LEFT JOIN lookup_tipologia_nodo_oia tipooia ON dpat_strutture_asl.tipologia_struttura = tipooia.code "

					+ " where tipologia_struttura in( 13,14) and id_asl = ? "
					+ " and id_strumento_calcolo in (select id from  "
					+ "  dpat_strumento_calcolo where id_asl = ? and anno=? ) and disabilitato=false";

			if (idStruttura > 0)
				sql += " and dpat_strutture_asl.id = " + idStruttura;
			pst = db.prepareStatement(sql);
			pst.setInt(1, idAsl);
			pst.setInt(2, idAsl);
			pst.setInt(3, anno);
			rs = pst.executeQuery();
			while (rs.next()) {
				OiaNodo n = new OiaNodo();
				n.loadResultSet(rs);
				n.setDescrizioneAreaStruttureComplesse(n.getDescrizione_lunga());
				lista.add(n);
			}

		} catch (LoginRequiredException e) {

			throw e;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}

		OiaNodo[] nodi = new OiaNodo[lista.size()];
		int ind = 0;
		for (OiaNodo n : lista) {
			nodi[ind] = n;
			ind++;
		}
		/* Metodo richiamato sul soggetto fisico proveniente dalla request */
		/**/

		return nodi;

	}
	
	public static OiaNodo[] getStruttureComplesse(int idAsl, int anno) throws SQLException {

		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		ArrayList<OiaNodo> lista = new ArrayList<OiaNodo>();
		try {
			db = GestoreConnessioni.getConnection();

			String sql = "select dpat_strutture_asl.*," /*o.org_id,o.tipologia,*/ + "tipooia.description as descrizione_tipologia_struttura from "
					+ "dpat_strutture_asl " //left join organization o on o.site_id =dpat_strutture_asl.id_asl and o.tipologia = 6"
					+ "LEFT JOIN lookup_tipologia_nodo_oia tipooia ON dpat_strutture_asl.tipologia_struttura = tipooia.code "

					+ " where tipologia_struttura in ( 13, 14) and id_asl = ? "
					+ " and id_strumento_calcolo in (select id from  "
					+ "  dpat_strumento_calcolo where id_asl = ? and anno=? ) and disabilitato=false";
			pst = db.prepareStatement(sql);
			pst.setInt(1, idAsl);
			pst.setInt(2, idAsl);
			pst.setInt(3, anno);
			rs = pst.executeQuery();
			while (rs.next()) {
				OiaNodo n = new OiaNodo();
				n.loadResultSet(rs);
				n.setDescrizioneAreaStruttureComplesse(n.getDescrizioneAreaStruttureComplesse() + " / "
						+ n.getDescrizione_lunga());
				lista.add(n);
			}

		} catch (LoginRequiredException e) {

			throw e;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}

		OiaNodo[] nodi = new OiaNodo[lista.size()];
		int ind = 0;
		for (OiaNodo n : lista) {
			nodi[ind] = n;
			ind++;
		}
		/* Metodo richiamato sul soggetto fisico proveniente dalla request */
		/**/

		return nodi;

	}
	
	
	public static ArrayList  getListaPianiAttivitaNewDpat(int idSezione, int anno,String congelato) throws Exception { /*solo i non scaduti */
		Connection db = null;
		
		ArrayList lista = new ArrayList();

		try {
			db = GestoreConnessioni.getConnection();
			org.aspcfs.modules.dpat2019.base.DpatSezioneNewBeanInterface sez = null; 
			
			boolean congelatoBool = false;
			try
			{
				congelatoBool = Boolean.parseBoolean(congelato);
			}
			catch(Exception ex)
			{
				
			}
			
			if(congelatoBool)
				sez = new DpatSezioneNewBean().buildByOid(db, idSezione,true,true);
			else
				sez = new DpatSezioneNewBeanPreCong().buildByOid(db, idSezione,true,true);
			
			lista = sez.getPianiAttivitaFigli();

		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}

		return lista;
	}

}
