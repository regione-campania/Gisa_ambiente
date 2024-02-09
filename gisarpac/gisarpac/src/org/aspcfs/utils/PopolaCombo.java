package org.aspcfs.utils;

import java.net.UnknownHostException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.logging.Logger;

import javax.servlet.http.HttpServletRequest;

import org.aspcfs.controller.ApplicationPrefs;
import org.aspcfs.controller.SystemStatus;
import org.aspcfs.modules.admin.base.User;
import org.aspcfs.modules.dpat.base.Dpat;
import org.aspcfs.modules.dpat.base.DpatAttivita;
import org.aspcfs.modules.dpat.base.DpatIndicatore;
import org.aspcfs.modules.dpat.base.DpatPiano;
import org.aspcfs.modules.dpat.base.DpatSezione;
import org.aspcfs.modules.dpat.base.DpatStrumentoCalcolo;
import org.aspcfs.modules.dpat.base.EsitoCall;
import org.aspcfs.modules.dpatnew.base.DpatPianoAttivitaNewBean;
import org.aspcfs.modules.dpatnew.base.DpatSezioneNewBean;
import org.aspcfs.modules.dpatnew_interfaces.DpatPianoAttivitaNewBeanInterface;
import org.aspcfs.modules.dpatnew_interfaces.DpatSezioneNewBeanInterface;
import org.aspcfs.modules.dpatnew_templates.base.DpatPianoAttivitaNewBeanPreCong;
import org.aspcfs.modules.dpatnew_templates.base.DpatSezioneNewBeanPreCong;
import org.aspcfs.modules.login.actions.Login;
import org.aspcfs.modules.oia.base.OiaNodo;
import org.aspcfs.utils.web.LookupElement;
import org.aspcfs.utils.web.LookupList;
import org.directwebremoting.WebContext;
import org.directwebremoting.WebContextFactory;
import org.directwebremoting.extend.LoginRequiredException;
import org.postgresql.util.PGobject;

import com.darkhorseventures.database.ConnectionElement;

public class PopolaCombo {

	

	static Logger logger = Logger.getLogger("MainLogger");
	
	
	public static ArrayList<String> getPartitaIva(String pIva) throws SQLException {

		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		ArrayList<String> listapartiteIva = new ArrayList<String>();

		try {
			db = GestoreConnessioni.getConnection();

			String sel = "select * from aia_impresa where trashed_Date is null and partita_iva ilike ?";
			pst = db.prepareStatement(sel);
			pst.setString(1, pIva + "%");
			rs = pst.executeQuery();
			while (rs.next()) {
				listapartiteIva.add(rs.getString(1));
			}

		} catch (LoginRequiredException e) {

			throw e;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}

		/* Metodo richiamato sul soggetto fisico proveniente dalla request */
		/**/

		return listapartiteIva;

	}

	public static boolean verificaComuneAsl(int comune,int idAsl)
	{

		String sql = "select codiceistatasl::int from comuni1 where id = ?";
		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		try {
			db = GestoreConnessioni.getConnection();
			pst=db.prepareStatement(sql);
			pst.setInt(1, comune);
			rs=pst.executeQuery();
			int idAslComune = -1 ;
			if(rs.next())
				idAslComune = rs.getInt(1);

			if(idAslComune==idAsl || comune<=0)
			{
				return true ;
			}

		}
		catch (SQLException e) {
			e.printStackTrace();
		} catch (LoginRequiredException e) {

			throw e;
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
		return false;



	}



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

			String sql = "select dpat_strutture_asl.*,o.org_id,o.tipologia,tipooia.description as descrizione_tipologia_struttura from "
					+ "dpat_strutture_asl left join organization o on o.site_id =dpat_strutture_asl.id_asl and o.tipologia = 6"
					+ "LEFT JOIN lookup_tipologia_nodo_oia tipooia ON dpat_strutture_asl.tipologia_struttura = tipooia.code "

					+ " where tipologia_struttura = 13 and id_asl = ? "
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

	public static Object[] getSchema(String tabella) {
		boolean esistente = false;
		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		ArrayList<String> nomi = new ArrayList<String>();
		ArrayList<String> tipi = new ArrayList<String>();
		Object[] toRet = new Object[2];
		try {
			db = GestoreConnessioni.getConnection();
			if (db != null) {
				String sel = " SELECT  a.attname as Column,"
						+ " pg_catalog.format_type(a.atttypid, a.atttypmod) as Datatype "
						+ "FROM   pg_catalog.pg_attribute a "
						+ "WHERE a.attnum > 0 AND NOT a.attisdropped AND a.attrelid = ( "
						+ "SELECT c.oid FROM pg_catalog.pg_class c LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace WHERE c.relname =? "
						+ " AND pg_catalog.pg_table_is_visible(c.oid) " + " ) ";
				pst = db.prepareStatement(sel);
				pst.setString(1, tabella);
				rs = pst.executeQuery();
				while (rs.next()) {
					nomi.add(rs.getString(1));
					tipi.add(rs.getString(2));

				}

				Object[] nomiObj = new Object[nomi.size()];
				int i = 0;
				for (String nome : nomi) {
					nomiObj[i] = nome;
					i++;

				}

				Object[] tipiObj = new Object[nomi.size()];
				i = 0;
				for (String nome : tipi) {
					tipiObj[i] = nome;
					i++;

				}
				toRet[0] = nomiObj;
				toRet[1] = tipiObj;
			}
		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {

		} finally {
			GestoreConnessioni.freeConnection(db);
		}

		return toRet;

	}

	public static boolean controlloEsuistenzaAsl(String idAsl) {
		boolean esistente = false;
		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		try {
			db = GestoreConnessioni.getConnection();
			if (db != null) {
				String sel = "select * from oia_nodo where id_asl = ? and id_padre = -1";
				pst = db.prepareStatement(sel);
				pst.setInt(1, Integer.parseInt(idAsl));
				rs = pst.executeQuery();
				if (rs.next())
					esistente = true;
			}

		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {

		} finally {
			GestoreConnessioni.freeConnection(db);
		}

		return esistente;

	}


	public static String controlloNodo(int idNodo, String nomeTabella, String colonnaPadre) {
		String esistente = "no";
		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		try {
			db = GestoreConnessioni.getConnection();
			if (db != null) {
				String sel = "select * from " + nomeTabella + " where " + colonnaPadre + " = ? ";
				pst = db.prepareStatement(sel);
				pst.setInt(1, idNodo);
				rs = pst.executeQuery();
				if (rs.next())
					esistente = "si";
			}

		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {

		} finally {
			GestoreConnessioni.freeConnection(db);
		}

		return esistente;

	}


	public static boolean controlloEsuistenzaAreaAsl(String idUtente) {
		boolean esistente = false;
		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		try {
			db = GestoreConnessioni.getConnection();
			if (db != null) {
				String sel = "select * from oia_nodo join oia_nodo_responsabili on oia_nodo.id =id_oia_nodo  where id_utente =?";
				pst = db.prepareStatement(sel);
				pst.setInt(1, Integer.parseInt(idUtente));
				rs = pst.executeQuery();
				if (rs.next())
					esistente = true;
			}

		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {

		} finally {
			GestoreConnessioni.freeConnection(db);
		}

		return esistente;

	}

	public static int getCaricoLavoroAnnuale(int idQualifica) {
		int caricoLavoroDefault = 0;
		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		try {
			db = GestoreConnessioni.getConnection();
			String sel = "select carico_default from lookup_qualifiche where code = " + idQualifica;
			pst = db.prepareStatement(sel);
			rs = pst.executeQuery();
			if (rs.next())
				caricoLavoroDefault = rs.getInt(1);

		} catch (SQLException e) {
			e.printStackTrace();
		} catch (LoginRequiredException e) {

			throw e;
		}

		finally {
			GestoreConnessioni.freeConnection(db);
		}
		return caricoLavoroDefault;

	}

	public static OiaNodo aggiornaDatiStruttura(int idStruttura, String fattori, int percentuale) {
		Connection db = null;
		OiaNodo struttura = null;

		try {
			db = GestoreConnessioni.getConnection();
			WebContext ctx = WebContextFactory.get();
			HttpServletRequest request = ctx.getHttpServletRequest();

			ApplicationPrefs prefs = (ApplicationPrefs) request.getSession().getServletContext()
					.getAttribute("applicationPrefs");
			String ceDriver = prefs.get("GATEKEEPER.DRIVER");
			String ceHost = prefs.get("GATEKEEPER.URL");
			String ceUser = prefs.get("GATEKEEPER.USER");
			String ceUserPw = prefs.get("GATEKEEPER.PASSWORD");

			ConnectionElement ce = new ConnectionElement(ceHost, ceUser, ceUserPw);
			SystemStatus thisSystem = null;
			HashMap sessions = null;
			thisSystem = (SystemStatus) ((Hashtable) request.getServletContext().getAttribute("SystemStatus")).get(ce
					.getUrl());

			struttura = new OiaNodo(db, idStruttura, thisSystem);
			struttura.setFattoriIncidentiSuCarico(fattori);
			struttura.setPercentualeDaSottrarre(percentuale);

			DpatStrumentoCalcolo sc = new DpatStrumentoCalcolo();
			sc.queryRecord(db, struttura.getIdStrumentoCalcolo());
			sc.setCoefficienteUbaFromdb(db);
			Dpat d = new Dpat();

			struttura
			.aggiornaDatiStruttura(db, d.isCongelato(db, sc.getIdAsl(), sc.getAnno()), sc.getCoefficienteUba());

			OiaNodo nodoPadre = new OiaNodo(db, struttura.getId_padre());
			struttura.setSommaUiArea(nodoPadre.getSommaUiArea());
			struttura.setSommaUiAreaInizialeBloccata(nodoPadre.getSommaUiAreaInizialeBloccata());

		} catch (SQLException e) {
			e.printStackTrace();
		} catch (LoginRequiredException e) {

			throw e;
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
		return struttura;

	}

	public static Object[] getListaNominaitvi(int idAsl) {

		Object[] ret = null;

		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		try {
			db = GestoreConnessioni.getConnection();
			int size = 0;
			String select = "select nominativo from anagrafica_nominativo where id_asl =?";
			String conta = "select count(*) as num from anagrafica_nominativo where id_asl =?";
			pst = db.prepareStatement(conta);
			pst.setInt(1, idAsl);
			rs = pst.executeQuery();
			if (rs.next())
				size = rs.getInt(1);
			ret = new Object[size];
			int i = 0;

			pst = db.prepareStatement(select);
			pst.setInt(1, idAsl);
			rs = pst.executeQuery();
			while (rs.next()) {
				ret[i] = rs.getString(1);
				i = i + 1;

			}

		} catch (SQLException e) {
			e.printStackTrace();
		} catch (LoginRequiredException e) {

			throw e;
		} finally {
			GestoreConnessioni.freeConnection(db);
		}

		return ret;

	}

	public static Object[] getValoriComboStruttureOia(int idNodo, int anno) {

		Object[] ret = new Object[2];

		HashMap<Integer, String> valori = new HashMap<Integer, String>();
		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;

		Calendar calCorrente = GregorianCalendar.getInstance();
		Date dataCorrente = new Date(System.currentTimeMillis());
		calCorrente.setTime(new Timestamp(dataCorrente.getTime()));

		if (anno == calCorrente.get(Calendar.YEAR)) {
			int tolleranzaGiorni = 0;
			dataCorrente.setDate(dataCorrente.getDate() - tolleranzaGiorni);
			calCorrente.setTime(new Timestamp(dataCorrente.getTime()));
			anno = calCorrente.get(Calendar.YEAR);

		}

		try {
			db = GestoreConnessioni.getConnection();
			if (db != null) {
				String filtro = "";
				if (idNodo == 1043661)
					filtro += " and oia_nodo.id_asl = -1";
				String t = "(select oia_nodo.id as code , descrizione_struttura  as description ,'' as short_description,false as default_item,1 as level,true as enabled "
						+ "from dpat_strutture_asl oia_nodo join organization o on o.site_id = oia_nodo.id_asl and o.tipologia=6 "
						+ " where n_livello !=3  and coalesce(oia_nodo.tipologia_struttura,0)!=39 and coalesce(oia_nodo.tipologia_struttura,0) !=14   and n_livello !=1 and (oia_nodo.disabilitato) = false and (anno ="
						+ anno + " or anno=-1) and o.org_id =" + idNodo + ")" + "";
				pst = db.prepareStatement(t);
				rs = pst.executeQuery();
				int i = 0;

				while (rs.next()) {
					int code = rs.getInt("code");
					String value = rs.getString("description");
					valori.put(code, value);

				}
				Object[] ind = new Object[valori.size()];
				Object[] val = new Object[valori.size()];

				for (Integer kiave : valori.keySet()) {
					ind[i] = kiave;
					val[i] = valori.get(kiave);
					i++;
				}
				ret[0] = ind;
				ret[1] = val;
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} catch (LoginRequiredException e) {

			throw e;
		} finally {
			GestoreConnessioni.freeConnection(db);
		}

		return ret;

	}


	public static Object[] getValoriComboComuni1Asl(int idAsl) {

		Object[] ret = new Object[2];

		HashMap<Integer, String> valori = new HashMap<Integer, String>();

		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		try {
			db = GestoreConnessioni.getConnection();
			if (db != null) {
				String select = "select id,nome from comuni1 c,lookup_site_id asl where c.notused is null and c.codiceistatasl=asl.codiceistat and asl.enabled=true ";

				if (idAsl != -1 && idAsl != -2) {
					select += " and asl.code = ? order by nome ";
				} else {
					select += " order by nome ";
				}

				pst = db.prepareStatement(select);
				if (idAsl != -1 && idAsl != -2) {
					pst.setInt(1, idAsl);
				}
				rs = pst.executeQuery();
				int i = 1;

				while (rs.next()) {
					String value = rs.getString("nome");
					int id = rs.getInt("id");
					valori.put(id, value);

				}
				Object[] ind = new Object[valori.size() + 1];
				Object[] val = new Object[valori.size() + 1];

				ind[0] = "";
				val[0] = "                ";

				for (Integer kiave : valori.keySet()) {
					ind[i] = kiave;
					val[i] = valori.get(kiave);
					i++;
				}
				ret[0] = ind;
				ret[1] = val;

			}
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (LoginRequiredException e) {

			throw e;
		} finally {
			GestoreConnessioni.freeConnection(db);
		}

		return ret;

	}

	public static Object[] getValoriComboComuni1Provincia(int idProvincia) {

		Object[] ret = new Object[2];

		HashMap<Integer, String> valori = new HashMap<Integer, String>();

		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		try {
			db = GestoreConnessioni.getConnection();
			if (db != null) {
				String select = "select id,nome from comuni1 c,lookup_province p where c.notused is null and c.cod_provincia::integer=p.code and p.enabled=true ";

				if (idProvincia != -1 && idProvincia != -2) {
					select += " and p.code = ? order by nome ";
				} else {
					select += " order by nome ";
				}

				pst = db.prepareStatement(select);
				if (idProvincia != -1 && idProvincia != -2) {
					pst.setInt(1, idProvincia);
				}
				rs = pst.executeQuery();
				int i = 1;

				while (rs.next()) {
					String value = rs.getString("nome");
					int id = rs.getInt("id");
					valori.put(id, value);

				}
				Object[] ind = new Object[valori.size() + 1];
				Object[] val = new Object[valori.size() + 1];

				ind[0] = "";
				val[0] = "                ";

				for (Integer kiave : valori.keySet()) {
					ind[i] = kiave;
					val[i] = valori.get(kiave);
					i++;
				}
				ret[0] = ind;
				ret[1] = val;

			}
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (LoginRequiredException e) {

			throw e;
		} finally {
			GestoreConnessioni.freeConnection(db);
		}

		return ret;

	}
	
	/**
	 * 
	 * Questa funzione seleziona i comuni dal DB per asl
	 * 
	 **/
	public static Object[] getValoriComboComuniAsl(int idAsl) {

		Object[] ret = new Object[2];

		// HashMap<String, String> valori =new HashMap<String,String>();
		ArrayList<String> valori = new ArrayList<String>();

		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		try {
			db = GestoreConnessioni.getConnection();
			if (db != null) {
				String select = "select comune from comuni c,lookup_site_id asl where notused is null and c.codiceistatasl=asl.codiceistat and asl.enabled=true ";

				if (idAsl != -1 && idAsl != -2) {
					select += " and asl.code = ? order by comune ";
				} else {
					select += " order by comune ";
				}
				pst = db.prepareStatement(select);
				if (idAsl != -1 && idAsl != -2) {
					pst.setInt(1, idAsl);
				}
				rs = pst.executeQuery();
				int i = 1;
				while (rs.next()) {
					String value = rs.getString("comune");
					valori.add(valori.size(), (value));

				}
				Object[] ind = new Object[valori.size() + 1];
				Object[] val = new Object[valori.size() + 1];

				ind[0] = "";
				val[0] = "                ";

				for (String kiave : valori) {
					ind[i] = kiave;
					val[i] = kiave;
					i++;
				}
				ret[0] = ind;
				ret[1] = val;

			}
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (LoginRequiredException e) {

			throw e;
		} finally {
			GestoreConnessioni.freeConnection(db);
		}

		return ret;

	}


	public static Object[] getValoriAsl(int idcomune) {
		Object[] ret = new Object[2];
		HashMap<Integer, String> valori = new HashMap<Integer, String>();
		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		try {
			db = GestoreConnessioni.getConnection();
			if (db != null) {
				String select = "select code, description from lookup_site_id where enabled = true ";

				if (idcomune > 0)
					select += " and codiceistat IN (select codiceistatasl from comuni1 where notused is null and id = ? ) ";

				pst = db.prepareStatement(select);
				if (idcomune > 0)
					pst.setInt(1, idcomune);
				rs = pst.executeQuery();
				int i = 0;

				while (rs.next()) {
					int code = rs.getInt("code");
					String value = rs.getString("description");
					valori.put(code, value);

				}
				Object[] ind = new Object[valori.size()];
				Object[] val = new Object[valori.size()];

				for (Integer kiave : valori.keySet()) {
					ind[i] = kiave;
					val[i] = valori.get(kiave);
					i++;
				}
				ret[0] = ind;
				ret[1] = val;

			}
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (LoginRequiredException e) {

			throw e;
		} finally {
			GestoreConnessioni.freeConnection(db);
		}

		return ret;

	}

	public static Object[] getValoriComuniASL(String comune) {
		Object[] ret = new Object[2];
		HashMap<Integer, String> valori = new HashMap<Integer, String>();
		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		try {
			db = GestoreConnessioni.getConnection();

			String select = "select code, description from lookup_site_id where enabled = true ";
			if (db != null) {
				if (comune != null && !comune.equals("")) {
					select += " and codiceistat IN (select codiceistatasl from comuni where comune = ? ) ";
				} else {
					select += " ; ";
				}

				pst = db.prepareStatement(select);
				if (comune != null && !comune.equals("")) {
					pst.setString(1, comune);
				}
				rs = pst.executeQuery();
				int i = 0;

				while (rs.next()) {
					int code = rs.getInt("code");
					String value = rs.getString("description");
					valori.put(code, value);

				}
				Object[] ind = new Object[valori.size()];
				Object[] val = new Object[valori.size()];

				for (Integer kiave : valori.keySet()) {
					ind[i] = kiave;
					val[i] = valori.get(kiave);
					i++;
				}
				ret[0] = ind;
				ret[1] = val;

			}
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (LoginRequiredException e) {

			throw e;
		} finally {
			GestoreConnessioni.freeConnection(db);
		}

		return ret;

	}

	// Metodo che a partire dalla provincia seleziona l'asl

	public static Object[] getValoriAslProvincia(String provincia) {

		Object[] ret = new Object[2];
		HashMap<Integer, String> valori = new HashMap<Integer, String>();
		// HashMap<String, String> valori =new HashMap<String,String>();
		ArrayList<Integer> asl_id = new ArrayList<Integer>();

		if (provincia != null) {
			if (provincia.equals("AV")) {
				asl_id.add(201);

			} else if (provincia.equals("BN")) {
				asl_id.add(202);
			} else if (provincia.equals("CE")) {
				asl_id.add(203);

			} else if (provincia.equals("NA")) {
				asl_id.add(204);
				asl_id.add(205);
				asl_id.add(206);

			} else if (provincia.equals("SA")) {
				asl_id.add(207);

			}
		}

		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		try {
			db = GestoreConnessioni.getConnection();
			String select = null;
			String array_valori = asl_id.toString();
			if (db != null) {
				int i = array_valori.length();
				String solo_valori_array = array_valori.substring(1, i - 1);
				select = "select code,description from lookup_site_id where code IN  (" + solo_valori_array
						+ ") and enabled = true ";
				pst = db.prepareStatement(select);

				rs = pst.executeQuery();

				int j = 1;

				while (rs.next()) {
					int code = rs.getInt("code");
					String value = rs.getString("description");
					valori.put(code, value);

				}

				Object[] ind = new Object[valori.size() + 1];
				Object[] val = new Object[valori.size() + 1];

				ind[0] = -1;
				val[0] = "--- SELEZIONA VOCE ---";

				for (Integer kiave : valori.keySet()) {
					ind[j] = kiave;
					val[j] = valori.get(kiave);
					j++;
				}
				ret[0] = ind;
				ret[1] = val;

			}
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (LoginRequiredException e) {

			throw e;
		} finally {
			GestoreConnessioni.freeConnection(db);
		}

		return ret;

	}


	public static Object[] getContenutoCombo(String table) {
		Connection db = null;
		Object[] descrizioni;
		Object[] valori;
		Object[] ret = new Object[2];

		try {
			db = GestoreConnessioni.getConnection();
			if (db != null) {
				LookupList combo = new LookupList(db, table);
				descrizioni = new Object[combo.size()];
				valori = new Object[combo.size()];

				for (int i = 0; i < combo.size(); i++) {
					LookupElement elm = (LookupElement) combo.get(i);
					descrizioni[i] = elm.getDescription();
					valori[i] = elm.getCode();
				}
				ret[0] = descrizioni;
				ret[1] = valori;
			}
		} catch (SQLException e) {
			e.printStackTrace();

		} catch (LoginRequiredException e) {

			throw e;
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
		return ret;
	}


	public static String[] getUltimaPosizioneFromIp(String ip) {
		String[] coordinate = null;
		Connection db = null;
		try {
			db = GestoreConnessioni.getConnection();
			org.aspcfs.modules.admin.base.User user = new User();
			user.setIp(ip);
			if (db != null) {
				ArrayList<String> s = user.getCoordinateUltimoAccesso(db);
				if (s.size() > 0)
					coordinate = new String[3];
				int i = 0;
				for (String c : s) {
					coordinate[i] = c;
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (LoginRequiredException e) {

			throw e;
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
		return coordinate;

	}

	public static ArrayList<String> getCoefficienti(String id, int idAttivita, int idStruttura) {
		ArrayList<String> c = new ArrayList<String>();
		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		try {
			db = GestoreConnessioni.getConnection();
			/*
			 * String sql =
			 * "select si.id_struttura,si.descr_sezione,si.descr_piano,si.descr_attivita,si.id_indicatore,c.coefficiente "
			 * +
			 * "from dpat_coefficiente c join dpat_struttura_indicatore si on c.id_indicatore=si.id_indicatore "
			 * +
			 * "where si.descr_attivita='"+idAttivita+"' and si.id_struttura="+
			 * idStruttura; pst = db.prepareStatement(sql); rs =
			 * pst.executeQuery(); while (rs.next()){
			 * c.add("struttura_"+rs.getInt
			 * (1)+"_s_"+rs.getString(2)+"_p_"+rs.getString
			 * (3)+"_a_"+rs.getString
			 * (4)+"_i_"+rs.getString(5)+";"+rs.getDouble(6)); }
			 */

			// if (c.size()==0){
			String[] s = id.split("_");
			String sql = "select c.id_indicatore, c.coefficiente from dpat_coefficiente c "
					+ "join dpat_indicatore i on c.id_indicatore=i.id "
					+ "join dpat_attivita a on i.id_attivita=a.id where a.id=" + idAttivita
					+ " and a.enabled=true and i.enabled=true";
			pst = db.prepareStatement(sql);
			rs = pst.executeQuery();
			while (rs.next()) {
				c.add(s[0] + "_" + s[1] + "_" + s[2] + "_" + s[3] + "_" + s[4] + "_" + s[5] + "_" + s[6] + "_" + s[7]
						+ "_" + s[8] + "_" + rs.getInt(1) + ";" + rs.getDouble(2));
			}
			// }
			pst.close();
			rs.close();
		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
		return c;
	}

	public static void updateSommaUi(String id, int ui, double somma, int idDpat, int idUtente) {
		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		String s[] = id.split("_");
		int idSI = -1;
		try {
			db = GestoreConnessioni.getConnection();
			String sql = "select id from dpat_struttura_indicatore where id_struttura=" + s[1] + " and id_indicatore="
					+ s[9] + " and enabled=true";
			pst = db.prepareStatement(sql);
			rs = pst.executeQuery();
			while (rs.next()) {
				idSI = rs.getInt("id");
			}

			if (idSI == -1) {
				pst = db.prepareStatement("insert into dpat_struttura_indicatore (id_struttura,id_indicatore,ui,somma_ui,descr_indicatore,descr_attivita,"
						+ "descr_piano,descr_sezione,entered,entered_by,modified,modified_by,enabled,id_dpat) values (?,?,?,?,?,?,?,?,now(),?,now(),?,?,?)");
				pst.setInt(1, Integer.parseInt(s[1]));
				pst.setInt(2, Integer.parseInt(s[9]));
				pst.setInt(3, ui);
				pst.setDouble(4, somma);
				pst.setString(5, s[9]);
				pst.setString(6, s[7]);
				pst.setString(7, s[5]);
				pst.setString(8, s[3]);
				pst.setInt(9, idUtente);
				pst.setInt(10, idUtente);
				pst.setBoolean(11, true);
				pst.setInt(12, idDpat);
				pst.executeUpdate();
			} else {
				pst = db.prepareStatement("update dpat_struttura_indicatore set ui=?,modified_by=?,modified=now() where id=?");
				pst.setInt(1, ui);
				pst.setInt(2, idUtente);
				pst.setInt(3, idSI);
				pst.executeUpdate();
			}
			pst = db.prepareStatement("update dpat_struttura_indicatore set somma_ui=?,modified_by=?,modified=now() where descr_attivita='"
					+ s[7] + "' and id_struttura=" + s[1]);
			pst.setDouble(1, somma);
			pst.setInt(2, idUtente);
			pst.executeUpdate();

			rs.close();
			pst.close();
		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
	}

	public static void updateCaricoStruttura(int idDpat, String id, int carico) {
		Connection db = null;
		PreparedStatement stat = null;
		ResultSet res = null;
		String s[] = id.split("_");
		try {
			db = GestoreConnessioni.getConnection();
			stat = db.prepareStatement("select id from dpat_ui_struttura where id_struttura=" + s[2] + " and id_dpat="
					+ idDpat);
			res = stat.executeQuery();
			int idSU = -1;
			while (res.next()) {
				idSU = res.getInt("id");
			}
			if (idSU == -1) {
				stat = db.prepareStatement("insert into dpat_ui_struttura (id_struttura,id_dpat,ui) values (?,?,?)");
				stat.setInt(1, Integer.parseInt(s[2]));
				stat.setInt(2, idDpat);
				stat.setInt(3, carico);
				stat.executeUpdate();
			} else {
				stat = db.prepareStatement("update dpat_ui_struttura set ui=? where id=?");
				stat.setInt(1, carico);
				stat.setInt(2, idSU);
				stat.executeUpdate();
			}
			res.close();
			stat.close();
		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
	}

	public static void updateObiettivoTot(int idDpat, int val) {
		Connection db = null;
		PreparedStatement stat = null;
		try {
			db = GestoreConnessioni.getConnection();
			stat = db.prepareStatement("update dpat set obiettivo_in_ui=" + val + " where id=" + idDpat);
			stat.executeUpdate();
			stat.close();
		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
	}

	public static void updateObiettivoParz(int idInd, int val) {
		Connection db = null;
		PreparedStatement stat = null;
		try {
			db = GestoreConnessioni.getConnection();
			stat = db.prepareStatement("update dpat_indicatore set obiettivo_in_cu=" + val + " where id=" + idInd);
			stat.executeUpdate();
			stat.close();
		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
	}

	private static String checkValueString(String valore) {
		if ("".equals(valore))
			valore = "0";
		return valore;
	}
	
	public static void aggiornaDpatCompetenzeStruttura(int idStruttura, int idIndicatore, int idDpat, boolean flag,
			int userid) throws SQLException {

		Connection db = null;
		WebContext ctx = WebContextFactory.get();
		HttpServletRequest req = ctx.getHttpServletRequest();
		try {
			db = GestoreConnessioni.getConnection();

			String sql = "UPDATE dpat_competenze_struttura_indicatore set modified_by=?,modified=?, competenza_attribuita = ? where id_struttura = ? and id_indicatore = ? and id_dpat =? ";
			PreparedStatement pst = db.prepareStatement(sql);

			pst.setInt(1, userid);
			pst.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
			pst.setBoolean(3, flag);
			pst.setInt(4, idStruttura);
			pst.setInt(5, idIndicatore);
			pst.setInt(6, idDpat);

			System.out.println("AGGIORNA COMPETENZE STRUTTURA " + pst.toString());
			pst.execute();

			int recordAggiornati = pst.getUpdateCount();
			if (recordAggiornati == 0) {
				String insert = "insert into dpat_competenze_struttura_indicatore (modified_by,modified,competenza_attribuita,id_struttura,id_indicatore,id_dpat) values(?,current_timestamp,?,?,?,?);";
				pst = db.prepareStatement(insert);

				pst.setInt(1, userid);
				pst.setBoolean(2, flag);
				pst.setInt(3, idStruttura);
				pst.setInt(4, idIndicatore);
				pst.setInt(5, idDpat);

				pst.execute();

			}

		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			throw e;
		} catch (NumberFormatException g) {
			throw g;
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
	}
	
	public static void aggiornaDpatCompetenzeStrutturaNEW(int idStruttura, int idIndicatore, int idDpat, boolean flag,
			int userid) throws SQLException {

		Connection db = null;
		WebContext ctx = WebContextFactory.get();
		HttpServletRequest req = ctx.getHttpServletRequest();
		try {
			db = GestoreConnessioni.getConnection();

			String sql = "UPDATE dpat_competenze_struttura_indicatore set modified_by=?,modified=?, competenza_attribuita = ? where id_struttura = ? and id_indicatore = ? and id_dpat =? ";
			PreparedStatement pst = db.prepareStatement(sql);

			pst.setInt(1, userid);
			pst.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
			pst.setBoolean(3, flag);
			pst.setInt(4, idStruttura);
			pst.setInt(5, idIndicatore);
			pst.setInt(6, idDpat);

			System.out.println("AGGIORNA COMPETENZE STRUTTURA " + pst.toString());
			pst.execute();

			int recordAggiornati = pst.getUpdateCount();
			if (recordAggiornati == 0) {
				String insert = "insert into dpat_competenze_struttura_indicatore (modified_by,modified,competenza_attribuita,id_struttura,id_indicatore,id_dpat) values(?,current_timestamp,?,?,?,?);";
				pst = db.prepareStatement(insert);

				pst.setInt(1, userid);
				pst.setBoolean(2, flag);
				pst.setInt(3, idStruttura);
				pst.setInt(4, idIndicatore);
				pst.setInt(5, idDpat);

				pst.execute();

			}

		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			throw e;
		} catch (NumberFormatException g) {
			throw g;
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
	}

	public static void aggiornaDatiRisorseStrumentali(int idStruttura, String nomeCampo, String valoreCampo,
			int idDpatRisorseStrumentali) throws SQLException, NumberFormatException {
		Connection db = null;
		WebContext ctx = WebContextFactory.get();
		HttpServletRequest req = ctx.getHttpServletRequest();
		try {
			db = GestoreConnessioni.getConnection();

			String sql = "UPDATE dpat_risorse_strumentali_strutture set " + nomeCampo
					+ " = ? where   id_struttura = ? and id_risorse_strumentali = ?  ";
			PreparedStatement pst = db.prepareStatement(sql);
			if (nomeCampo.equalsIgnoreCase("altro_descrizione")) {
				pst.setString(1, valoreCampo);
			} else {
				pst.setInt(1, Integer.parseInt(valoreCampo));
			}
			pst.setInt(2, idStruttura);
			pst.setInt(3, idDpatRisorseStrumentali);
			pst.execute();

			int rowAggiornate = pst.getUpdateCount();
			if (rowAggiornate == 0) {
				sql = "insert into dpat_risorse_strumentali_strutture ( " + nomeCampo
						+ ",id_risorse_strumentali,id_struttura) values (?,?,?)";
				pst = db.prepareStatement(sql);

				if (nomeCampo.equalsIgnoreCase("altro_descrizione")) {
					pst.setString(1, valoreCampo);
				} else {
					pst.setInt(1, Integer.parseInt(valoreCampo));
				}
				pst.setInt(2, idDpatRisorseStrumentali);

				pst.setInt(3, idStruttura);
				pst.execute();
			}

		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			throw e;
		} catch (NumberFormatException g) {
			throw g;
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
	}

	public static int getNumeroFigli(int idStruttura) {
		int c = 0;
		Connection db = null;
		WebContext ctx = WebContextFactory.get();
		HttpServletRequest req = ctx.getHttpServletRequest();
		try {
			db = GestoreConnessioni.getConnection();
			String sql = "select count(*) from oia_nodo where trashed_date is null and id_padre=? ";
			PreparedStatement pst = db.prepareStatement(sql);
			pst.setInt(1, idStruttura);
			ResultSet rs = pst.executeQuery();
			while (rs.next()) {
				c = rs.getInt(1);
			}

		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (NumberFormatException g) {
			g.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
		return c;
	}

	public static int getNumeroFigliTemp(int idStruttura) {
		int c = 0;
		Connection db = null;
		WebContext ctx = WebContextFactory.get();
		HttpServletRequest req = ctx.getHttpServletRequest();
		try {
			db = GestoreConnessioni.getConnection();
			String sql = "select count(*) from oia_nodo_temp where trashed_date is null and id_padre=? ";
			PreparedStatement pst = db.prepareStatement(sql);
			pst.setInt(1, idStruttura);
			ResultSet rs = pst.executeQuery();
			while (rs.next()) {
				c = rs.getInt(1);
			}

		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (NumberFormatException g) {
			g.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
		return c;
	}


	public Boolean checkStatoSDC(int id_sdc) {
		Boolean stato = false;
		Connection db = null;
		String sql = "select completo from dpat_strumento_calcolo where id=?";
		try {
			db = GestoreConnessioni.getConnection();
			if (db != null) {
				PreparedStatement pst = db.prepareStatement(sql);
				pst.setInt(1, id_sdc);
				ResultSet rs = pst.executeQuery();

				while (rs.next()) {
					stato = rs.getBoolean(1);
				}

				pst.close();
				rs.close();
			}
		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
		return stato;
	}


	public String getProvinciaDaComune(String comune) {
		String provincia = "";
		Connection db = null;
		String sql = "select prov.description from lookup_province prov left join comuni1 com on com.cod_provincia = prov.codistat where com.nome ilike ?";
		try {
			db = GestoreConnessioni.getConnection();
			if (db != null) {
				PreparedStatement pst = db.prepareStatement(sql);
				pst.setString(1, comune);
				ResultSet rs = pst.executeQuery();

				while (rs.next()) {
					provincia = rs.getString(1);
				}

				pst.close();
				rs.close();
			}
		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
		return provincia;
	}



	public String[] getProvinciaeAslDaComune(String comune) {
		String provincia = "";
		Connection db = null;
		String sql = "select prov.description as provincia,asl.description as asl from lookup_province prov  join comuni1 com on com.cod_provincia = prov.codistat join lookup_site_id asl on asl.code = com.codiceistatasl::int where com.nome ilike ?";

		String[] listaValori = new String[2];
		listaValori[0] = "" ;
		listaValori[1] = "" ;

		try {
			db = GestoreConnessioni.getConnection();
			if (db != null) {
				PreparedStatement pst = db.prepareStatement(sql);
				pst.setString(1, comune);
				ResultSet rs = pst.executeQuery();

				if (rs.next()) {
					listaValori[0]  = rs.getString(1);
					listaValori[1]  = rs.getString(2);
				}

				pst.close();
				rs.close();
			}
		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
		return listaValori;
	}




	public static Object[] writeBeanModification(String initial_form, String delta, int user_id, String username,
			String url) throws ParseException, SQLException {
		PGobject json = new PGobject();
		json.setType("json");
		json.setValue(initial_form);

		PGobject d = new PGobject();
		d.setType("json");
		d.setValue(delta);

		Object[] ret = new Object[2];
		Connection db = null;
		PreparedStatement pst = null;

		try {
			db = GestoreConnessioni.getConnectionStorico();
			pst = db.prepareStatement("insert into gisa_storico_bean (entered_by, entered,username,url,initial,delta) values (?,now(),?,?,?,?);");
			pst.setInt(1, user_id);
			pst.setString(2, username);
			pst.setString(3, url);
			pst.setObject(4, json);
			pst.setObject(5, d);
			pst.executeUpdate();
			pst.close();
		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (db != null)
				GestoreConnessioni.freeConnectionStorico(db);
			return ret;
		}
	}

	public static void Logout() {
		Login loginAction = new Login();

		WebContext ctx = WebContextFactory.get();
		loginAction.executeCommandLogout(ctx);

	}



	public static ArrayList<DpatPiano> getListaPiani(int idSezione, int anno) {
		Connection db = null;

		ArrayList<DpatPiano> lista = new ArrayList<DpatPiano>();

		try {
			db = GestoreConnessioni.getConnection();
			DpatSezione sez = new DpatSezione();
			sez.buildlistPianiConfiguratore(db, idSezione, anno);
			lista = sez.getElencoPiani();

		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}

		return lista;
	}
	
	
	public static ArrayList  getListaPianiAttivitaNewDpat(int idSezione, int anno,String congelato) throws Exception { /*solo i non scaduti */
		Connection db = null;
		
		ArrayList lista = new ArrayList();

		try {
			db = GestoreConnessioni.getConnection();
			DpatSezioneNewBeanInterface sez = null; 
			
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

	public static ArrayList<DpatAttivita> getListaAttivita(int idPiano, int anno) {
		Connection db = null;
		ArrayList<DpatAttivita> lista = new ArrayList<DpatAttivita>();
		try {
			db = GestoreConnessioni.getConnection();
			DpatPiano sez = new DpatPiano();
			sez.buildlistAttivitaConfiguratore(db, idPiano, anno);
			lista = sez.getElencoAttivita();

		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}

		return lista;
	}

	
	public static ArrayList getListaIndicatoriNewDpat(int idPianoAttivita, int anno, String congelato) { /*solo i non scaduti */
		ArrayList lista = new ArrayList ();
		Connection db = null;
		try {
			db = GestoreConnessioni.getConnection();
			DpatPianoAttivitaNewBeanInterface piano = null;
			boolean congelatoBool = false;
			try
			{
				congelatoBool = Boolean.parseBoolean(congelato);
			}
			catch(Exception ex)
			{
				
			}
			if(congelatoBool)
				piano = new DpatPianoAttivitaNewBean().buildByOid(db,idPianoAttivita,true,true);
			else
				piano = new DpatPianoAttivitaNewBeanPreCong().buildByOid(db,idPianoAttivita,true,true);
			 
			lista = piano.getIndicatoriFigli();

		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}

		return lista;
	}
	
	
	
	
	public static ArrayList<DpatIndicatore> getListaIndicatori(int idAttivita, int anno) {
		ArrayList<DpatIndicatore> lista = new ArrayList<DpatIndicatore>();
		Connection db = null;
		try {
			db = GestoreConnessioni.getConnection();
			DpatAttivita sez = new DpatAttivita();
			sez.buildlistIndicatoriConfiguratore(db, idAttivita, anno);
			lista = sez.getElencoIndicatori();

		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}

		return lista;
	}

	public static boolean controllaEsistenzaInStruttura(int idStruttua, int idUtente) {
		boolean ret = false;
		Connection db = null;
		try {

			db = GestoreConnessioni.getConnection();
			PreparedStatement pst = db
					.prepareStatement("select *  from dpat_Strumento_calcolo_nominativi where id_anagrafica_nominativo =? and id_struttura = ?");
			pst.setInt(1, idUtente);
			pst.setInt(2, idStruttua);
			ResultSet rs = pst.executeQuery();
			if (rs.next())
				ret = true;

		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
		return ret;
	}

	
	 
	
	public static String[] verificaEsistenzaCodiceIndicatoreNEW(String codice, String anno, String id_piano_attivita, String id_indicatore)
	{

		boolean ret = false;
		String codiceDisponibile = "" ;
		Connection db = null;
		//String query = "select * from dpat_indicatore_new where lower(codice_alias_indicatore) = lower(?) and id = ? ";
	
		/*
		String query = "select * from codici_piani_attivita_indicatori where lower(codice_alias_indicatore) = lower(?) and codice_alias_attivita = "+
				"(select codice_alias_attivita from codici_piani_attivita_indicatori where id_indicatore  = ? )"; 
		*/
		
		String query = "select * from codici_piani_attivita_indicatori where lower(codice_alias_indicatore) = lower(?) and id_piano_attivita = ? and id_indicatore <> ?";
		
		
		
		String[] toRest = new String[2];
		try {

			db = GestoreConnessioni.getConnection();
			PreparedStatement pst = db.prepareStatement(query);
			pst.setString(1, codice);
			pst.setInt(2,Integer.parseInt(id_piano_attivita));
			pst.setInt(3,Integer.parseInt(id_indicatore));
			
			logger.info(pst.toString());
			
			ResultSet rs = pst.executeQuery();
			if (rs.next())
			{
				 
				toRest[0]="true";
				
				int id_indicatore_duplicato = rs.getInt("id_indicatore");
				
				pst = db.prepareStatement("select * from  peekNextCodiceAlias('indicatore',?,?,?)");
				pst.setString(1, anno);
				pst.setString(2, codice);
				pst.setInt(3,id_indicatore_duplicato);
				
				logger.info(pst.toString());
				
				rs = pst.executeQuery();
				if (rs.next())
				{
					codiceDisponibile=rs.getString(1);
					toRest[1]=codiceDisponibile;
				}
				else
				{
					toRest[1]="";
				}
			}
			else
			{
				toRest[0]="false";
				toRest[1]="";
			}




		} catch (LoginRequiredException e) {

			logger.severe(e.getMessage());
			throw e;
		} catch (SQLException e) {
			
			logger.severe(e.getMessage());
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
				
		return toRest;
	}
	
	public static String[] verificaEsistenzaCodiceAttivitaNEW(String codice, String anno, String id_indicatore )
	{


		String codiceDisponibile = "" ;
		Connection db = null;
		//String query = "select * from dpat_piano_attivita_new where lower(codice_alias_attivita) = lower(?) and id = ? ";
		String query = "select * from codici_piani_attivita_indicatori where lower(codice_alias_attivita) = lower(?) and anno = ?";
		
		String[] toRest = new String[2];
		try {

			db = GestoreConnessioni.getConnection();
			PreparedStatement pst = db.prepareStatement(query);
			pst.setString(1, codice);
			pst.setInt(2,Integer.parseInt(anno));
			
			logger.info(pst.toString());
			
			ResultSet rs = pst.executeQuery();
			if (rs.next())
			{
				 
				toRest[0]="true";

				pst = db.prepareStatement("select * from  peekNextCodiceAlias('piano-attivita',?,?,?)");
				pst.setString(1, anno);
				pst.setString(2, codice);
				pst.setInt(3,Integer.parseInt(id_indicatore));
				
				logger.info(pst.toString());
				
				rs = pst.executeQuery();
				if (rs.next())
				{
					codiceDisponibile=rs.getString(1);
					toRest[1]=codiceDisponibile;
				}
				else
				{
					toRest[1]="";
				}
			}
			else
			{
				toRest[0]="false";
				toRest[1]="";
			}

		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
		return toRest;

	
	}
	
	public String getAslDaComune(String idComune) {
		String idAsl = "";
		Connection db = null;
		String sql = "select codiceistatasl from comuni1 where id = ?";
		try {
			db = GestoreConnessioni.getConnection();
			if (db != null) {
				PreparedStatement pst = db.prepareStatement(sql);
				pst.setInt(1, Integer.parseInt(idComune));
				ResultSet rs = pst.executeQuery();

				while (rs.next()) {
					idAsl = rs.getString(1);
				}

				pst.close();
				rs.close();
			}
		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
		return idAsl;
	}
		
	
	public static boolean isPrevistoVerbaleCampione(int idCampione, String codiceModello) throws SQLException 
	{
		boolean esito = false;
		String sql = "select * from is_previsto_verbale_campione(?, ?)";
		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		try {
			db = GestoreConnessioni.getConnection();
			pst=db.prepareStatement(sql);
			pst.setInt(1, idCampione);
			pst.setString(2, codiceModello);
			rs=pst.executeQuery();
			if(rs.next())
				esito = rs.getBoolean(1);

		}
		catch (SQLException e) {
			e.printStackTrace();
		} catch (LoginRequiredException e) {

			throw e;
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
		return esito;
	}
	
	public static boolean hasMatriceAnagrafica(int riferimentoId, String riferimentoIdNomeTab, String nomeMatrice) throws SQLException 
	{
		boolean esito = false;
		String sql = "select * from has_matrice_anagrafica(?, ?, ?)";
		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		try {
			db = GestoreConnessioni.getConnection();
			pst=db.prepareStatement(sql);
			pst.setInt(1, riferimentoId);
			pst.setString(2, riferimentoIdNomeTab);
			pst.setString(3, nomeMatrice);
			rs=pst.executeQuery();
			if(rs.next())
				esito = rs.getBoolean(1);

		}
		catch (SQLException e) {
			e.printStackTrace();
		} catch (LoginRequiredException e) {

			throw e;
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
		return esito;
	}

	public static String[] getDatiProtocollo(int idGiornataIspettiva, String tipoVerbale) {
		Connection db = null;
		String sql = "select * from get_giornate_ispettive_protocolli(?, ?)";

		String[] datiProtocollo = new String[2];
		datiProtocollo[0] = "-1" ;
		datiProtocollo[1] = "-1" ;

		try {
			db = GestoreConnessioni.getConnection();
			if (db != null) {
				PreparedStatement pst = db.prepareStatement(sql);
				pst.setInt(1, idGiornataIspettiva);
				pst.setString(2, tipoVerbale);
				ResultSet rs = pst.executeQuery();

				if (rs.next()) {
					datiProtocollo[0]  = rs.getString(1);
					datiProtocollo[1]  = rs.getString(2);
				}

				pst.close();
				rs.close();
			}
		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
		return datiProtocollo;
	}
	
	public static String[] getDatiProtocolloFascicolo(int idFascicoloIspettivo) {
		Connection db = null;
		String sql = "select * from get_fascicoli_ispettivi_protocolli(?)";

		String[] datiProtocollo = new String[2];
		datiProtocollo[0] = "-1" ;
		datiProtocollo[1] = "-1" ;

		try {
			db = GestoreConnessioni.getConnection();
			if (db != null) {
				PreparedStatement pst = db.prepareStatement(sql);
				pst.setInt(1, idFascicoloIspettivo);
				ResultSet rs = pst.executeQuery();

				if (rs.next()) {
					datiProtocollo[0]  = rs.getString(1);
					datiProtocollo[1]  = rs.getString(2);
				}

				pst.close();
				rs.close();
			}
		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
		return datiProtocollo;
	}
	
	public static String getDatiRapportoChiusuraFascicolo(int idFascicoloIspettivo) {
		Connection db = null;
		String sql = "select * from get_fascicoli_ispettivi_rapporto_chiusura(?)";

		String datiRapportoChiusura = "";
		

		try {
			db = GestoreConnessioni.getConnection();
			if (db != null) {
				PreparedStatement pst = db.prepareStatement(sql);
				pst.setInt(1, idFascicoloIspettivo);
				ResultSet rs = pst.executeQuery();

				if (rs.next()) {
					datiRapportoChiusura  = rs.getString(1);
				}

				pst.close();
				rs.close();
			}
		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
		return datiRapportoChiusura;
	}
	
	public static String[] getDatiProtocolloCampione(int idCampione, String tipoVerbale) {
		Connection db = null;
		String sql = "select * from get_campioni_protocolli(?, ?)";

		String[] datiProtocollo = new String[2];
		datiProtocollo[0] = "-1" ;
		datiProtocollo[1] = "-1" ;

		try {
			db = GestoreConnessioni.getConnection();
			if (db != null) {
				PreparedStatement pst = db.prepareStatement(sql);
				pst.setInt(1, idCampione);
				pst.setString(2, tipoVerbale);
				ResultSet rs = pst.executeQuery();

				if (rs.next()) {
					datiProtocollo[0]  = rs.getString(1);
					datiProtocollo[1]  = rs.getString(2);
				}

				pst.close();
				rs.close();
			}
		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
		return datiProtocollo;
	}
	
	public static ArrayList<String[]> getDatiProtocolloArea(int idArea, String tipoVerbale) { 
		Connection db = null;
		String sql = "select * from get_aree_protocolli(?, ?)";

		ArrayList<String[]> datiProtocolli = new ArrayList<String[]>();
		
		try {
			db = GestoreConnessioni.getConnection();
			if (db != null) {
				PreparedStatement pst = db.prepareStatement(sql);
				pst.setInt(1, idArea);
				pst.setString(2, tipoVerbale);
				ResultSet rs = pst.executeQuery(); 

				while (rs.next()) {
					String[] datiProtocollo = new String[2];
					datiProtocollo[0]  = rs.getString(1);
					datiProtocollo[1]  = rs.getString(2); 
					datiProtocolli.add(datiProtocollo);
				}

				pst.close();
				rs.close();
			}
		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
		return datiProtocolli;
	}
	
	public static ArrayList<String> getDatiAllegati(int idGiornataIspettiva) {
		Connection db = null;
		String sql = "select * from get_giornate_ispettive_allegati(?)";

		ArrayList<String> datiAllegati = new ArrayList<String>();
		
		try {
			db = GestoreConnessioni.getConnection();
			if (db != null) {
				PreparedStatement pst = db.prepareStatement(sql);
				pst.setInt(1, idGiornataIspettiva);
				ResultSet rs = pst.executeQuery();

				while (rs.next()) {
					String codice = rs.getString(1);
					String nome  = rs.getString(2);
					String oggetto  = rs.getString(3);
					String data = rs.getString(4);
					String utente = rs.getString(5);
					datiAllegati.add(codice+";;"+nome+";;"+oggetto+";;"+data+";;"+utente);
				}

				pst.close();
				rs.close();
			}
		} catch (LoginRequiredException e) {

			throw e;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
		return datiAllegati;
	}
	
	public static boolean verificaEsistenzaCodiceSitoParticella(String codice, int id) throws SQLException 
	{
		boolean esito = false;
		String sql = "select * from verifica_univocita_codice_sito_particella(?, ?)"; 
		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		try {
			db = GestoreConnessioni.getConnection();
			pst=db.prepareStatement(sql);
			pst.setString(1, codice);
			pst.setInt(2, id);
			rs=pst.executeQuery();
			if(rs.next())
				esito = rs.getBoolean(1);

		}
		catch (SQLException e) {
			e.printStackTrace();
		} catch (LoginRequiredException e) {

			throw e;
		} finally {
			GestoreConnessioni.freeConnection(db);
		}
		return esito;
	}
	
}
