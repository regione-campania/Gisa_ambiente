package org.aspcfs.modules.util.actions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Logger;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.util.base.GURUAsl;
import org.aspcfs.modules.util.base.GURURuolo;
import org.aspcfs.modules.util.base.GURUUtente;

import com.darkhorseventures.framework.actions.ActionContext;


public final class Utility extends CFSModule {
	Logger logger = Logger.getLogger("MainLogger");

	public String executeCommandGURUHome(ActionContext context) {

		return "GURUHomeOK";
	}

	public String executeCommandGURUAdd(ActionContext context) {

		if (!hasPermission(context, "guru-view")) { 
			return ("PermissionError");
		}

		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;

		try {
			db = this.getConnection(context);
			ArrayList<GURUAsl> listaAsl = new ArrayList<GURUAsl>();
			ArrayList<GURURuolo> listaRuoli = new ArrayList<GURURuolo>();

			pst = db.prepareStatement("select * from dbi_lista_asl_guru()");
			rs = pst.executeQuery();
			while (rs.next()){
				GURUAsl asl = new GURUAsl();
				asl.setAslId(rs.getInt("asl_id"));
				asl.setAsl(rs.getString("asl"));
				listaAsl.add(asl);
			}

			pst = db.prepareStatement("select * from dbi_lista_ruoli_guru()");
			rs = pst.executeQuery();
			while (rs.next()){
				GURURuolo role = new GURURuolo();
				role.setRoleId(rs.getInt("role_id"));
				role.setRole(rs.getString("role"));
				listaRuoli.add(role);
			}

			context.getRequest().setAttribute("listaRuoli", listaRuoli);
			context.getRequest().setAttribute("listaAsl", listaAsl);

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} finally{
			freeConnection(context, db);
		}

		return "GURUAddOK";

	}

	public String executeCommandGURUInsert(ActionContext context) {

		if (!hasPermission(context, "guru-view")) {
			return ("PermissionError");
		}

		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;

		String username = context.getRequest().getParameter("username");
		String alias_utente = context.getRequest().getParameter("username");
		String password = context.getRequest().getParameter("password");
		String nome = context.getRequest().getParameter("nome");
		String cognome = context.getRequest().getParameter("cognome");
		String cf = context.getRequest().getParameter("cf");
		String role = context.getRequest().getParameter("role");
		String asl = context.getRequest().getParameter("asl");

		String output = "";

		try {
			db = this.getConnection(context);

			pst = db.prepareStatement("select * from dbi_insert_utente_guru(?,?,md5(?),?,1,1,'1',?,?,?,?,'Inserito da GURU','-1','null','',NULL,-1,'true','true','true')");

			int i = 0;
			pst.setString(++i, username);
			pst.setString(++i, alias_utente);
			pst.setString(++i, password);
			pst.setInt(++i, Integer.parseInt(role));
			pst.setInt(++i, Integer.parseInt(asl));
			pst.setString(++i, nome);
			pst.setString(++i, cognome);
			pst.setString(++i, cf);
			logger.info("[GURU] Insert Utente: "+pst.toString()); 
			rs = pst.executeQuery();
			while (rs.next()){
				output = rs.getString(1);
			}
			logger.info("[GURU] Insert Utente Output: "+output);

			context.getRequest().setAttribute("output", output);
			context.getRequest().setAttribute("username", username);
			
			salvaLog(db, getUserId(context), context.getIpAddress(), "INSERIMENTO UTENTE", output, -1, username);

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} finally{
			freeConnection(context, db);
		}

		return "GURUInsertOK";

	}

	public String executeCommandGURUList(ActionContext context) {

		if (!hasPermission(context, "guru-view")) {
			return ("PermissionError");
		}

		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;

		try {
			db = this.getConnection(context);
			ArrayList<GURUUtente> listaUtenti = new ArrayList<GURUUtente>();

			pst = db.prepareStatement("select * from dbi_lista_utenti_guru()"); 
			rs = pst.executeQuery();
			while (rs.next()){
				GURUUtente utente = new GURUUtente();
				utente.setId(rs.getInt("id"));
				utente.setUsername(rs.getString("username"));
				utente.setAlias(rs.getString("alias_utente"));
				utente.setAsl(rs.getString("asl"));
				utente.setRuolo(rs.getString("ruolo"));
				utente.setNome(rs.getString("nome"));
				utente.setCognome(rs.getString("cognome"));
				utente.setCf(rs.getString("codice_fiscale"));  
				utente.setIdRuolo(rs.getInt("id_ruolo"));
				listaUtenti.add(utente);
			}

			context.getRequest().setAttribute("listaUtenti", listaUtenti);

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} finally{
			freeConnection(context, db);
		}

		return "GURUListOK";

	}
	
	public String executeCommandGURUValida(ActionContext context) {

		if (!hasPermission(context, "guru-view")) {
			return ("PermissionError");
		}

		Connection db = null;
		PreparedStatement pst = null;
		String userId = context.getRequest().getParameter("userId");

		try {
			db = this.getConnection(context);
			ArrayList<GURUUtente> listaUtenti = new ArrayList<GURUUtente>();

			pst = db.prepareStatement("select * from valida_utente(?)"); 
			pst.setInt(1, Integer.parseInt(userId));
			pst.executeUpdate();
			
			context.getRequest().setAttribute("listaUtenti", listaUtenti);

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} finally{
			freeConnection(context, db);
		}

		return "GURUListProcOK";

	}
	
	public String executeCommandGURUListProc(ActionContext context) {

		if (!hasPermission(context, "guru-view")) {
			return ("PermissionError");
		}

		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;

		try {
			db = this.getConnection(context);
			ArrayList<GURUUtente> listaUtenti = new ArrayList<GURUUtente>();

			pst = db.prepareStatement("select * from utenti_modulospid where processato is false"); 
			rs = pst.executeQuery();
			while (rs.next()){
				GURUUtente utente = new GURUUtente();
				utente.setId(rs.getInt("user_id"));
				utente.setNome(rs.getString("namefirst"));
				utente.setCognome(rs.getString("namelast"));
				utente.setCf(rs.getString("cf"));  
				utente.setIvaStab(rs.getString("stab_iva_cf"));
				utente.setStabId(rs.getInt("stab_id"));

				listaUtenti.add(utente);
			}

			context.getRequest().setAttribute("listaUtenti", listaUtenti);

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} finally{
			freeConnection(context, db);
		}

		return "GURUListProcOK";

	}
	
	

	public String executeCommandGURUModify(ActionContext context) {

		if (!hasPermission(context, "guru-view")) {
			return ("PermissionError");
		}

		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;

		String userId = context.getRequest().getParameter("userId");

		try {
			db = this.getConnection(context);
			ArrayList<GURUAsl> listaAsl = new ArrayList<GURUAsl>();
			ArrayList<GURURuolo> listaRuoli = new ArrayList<GURURuolo>();

			pst = db.prepareStatement("select * from dbi_lista_asl_guru()");
			rs = pst.executeQuery();
			while (rs.next()){
				GURUAsl asl = new GURUAsl();
				asl.setAslId(rs.getInt("asl_id"));
				asl.setAsl(rs.getString("asl"));
				listaAsl.add(asl);
			}

			pst = db.prepareStatement("select * from dbi_lista_ruoli_guru()");
			rs = pst.executeQuery();
			while (rs.next()){
				GURURuolo role = new GURURuolo();
				role.setRoleId(rs.getInt("role_id"));
				role.setRole(rs.getString("role"));
				listaRuoli.add(role);
			}

			GURUUtente utente = new GURUUtente();
			pst = db.prepareStatement("select * from dbi_dettaglio_utente_guru(?)");
			int i = 0;
			pst.setInt(++i, Integer.parseInt(userId));
			rs = pst.executeQuery();
			while (rs.next()){
				utente.setId(rs.getInt("id"));
				utente.setNome(rs.getString("nome"));
				utente.setCognome(rs.getString("cognome"));
				utente.setCf(rs.getString("cf"));
				utente.setUsername(rs.getString("username"));
				utente.setAlias(rs.getString("alias_utente"));
				utente.setIdAsl(rs.getInt("id_asl"));
				utente.setIdRuolo(rs.getInt("id_ruolo"));
			}

			context.getRequest().setAttribute("listaRuoli", listaRuoli);
			context.getRequest().setAttribute("listaAsl", listaAsl);
			context.getRequest().setAttribute("utente", utente);


		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} finally{
			freeConnection(context, db);
		}

		return "GURUModifyOK";

	}

	public String executeCommandGURUUpdate(ActionContext context) {

		if (!hasPermission(context, "guru-view")) {
			return ("PermissionError");
		}

		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;

		String userId = context.getRequest().getParameter("userId");
		String username = context.getRequest().getParameter("username");
		String alias_utente = context.getRequest().getParameter("alias");
		String nome = context.getRequest().getParameter("nome");
		String cognome = context.getRequest().getParameter("cognome");
		String cf = context.getRequest().getParameter("cf");
		String roleId = context.getRequest().getParameter("roleId");
		String aslId = context.getRequest().getParameter("aslId");

		String output = "";

		try {
			db = this.getConnection(context);

			pst = db.prepareStatement("select * from dbi_update_utente_guru(?, ?, ?, ?, ?, ?)");

			int i = 0;
			pst.setInt(++i, Integer.parseInt(userId));
			pst.setInt(++i, Integer.parseInt(roleId));
			pst.setInt(++i, Integer.parseInt(aslId));
			pst.setString(++i, nome);
			pst.setString(++i, cognome);
			pst.setString(++i, cf);
			logger.info("[GURU] Update Utente: "+pst.toString());
			rs = pst.executeQuery();

			while (rs.next()){
				output = rs.getString(1);
			}
			logger.info("[GURU] Update Utente Output: "+output);
			context.getRequest().setAttribute("output", output);
			context.getRequest().setAttribute("username", username);
			
			salvaLog(db, getUserId(context), context.getIpAddress(), "MODIFICA UTENTE", output, Integer.parseInt(userId), username);


		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} finally{
			freeConnection(context, db);
		}

		return "GURUUpdateOK";

	}

	public String executeCommandGURUModifyDisable(ActionContext context) {

		if (!hasPermission(context, "guru-view")) {
			return ("PermissionError");
		}

		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;

		String userId = context.getRequest().getParameter("userId");

		try {
			db = this.getConnection(context);

			GURUUtente utente = new GURUUtente();
			pst = db.prepareStatement("select * from dbi_dettaglio_utente_guru(?)");
			int i = 0;
			pst.setInt(++i, Integer.parseInt(userId));
			rs = pst.executeQuery();
			while (rs.next()){
				utente.setId(rs.getInt("id"));
				utente.setNome(rs.getString("nome"));
				utente.setCognome(rs.getString("cognome"));
				utente.setCf(rs.getString("cf"));
				utente.setUsername(rs.getString("username"));
				utente.setAlias(rs.getString("alias_utente"));
				utente.setIdAsl(rs.getInt("id_asl"));
				utente.setIdRuolo(rs.getInt("id_ruolo"));
			}

			context.getRequest().setAttribute("utente", utente);


		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} finally{
			freeConnection(context, db);
		}

		return "GURUModifyDisableOK";

	}

	public String executeCommandGURUUpdateDisable(ActionContext context) {

		if (!hasPermission(context, "guru-view")) {
			return ("PermissionError");
		}

		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;

		String userId = context.getRequest().getParameter("userId");
		String username = context.getRequest().getParameter("username");

		String output = "";

		try {
			db = this.getConnection(context);

			pst = db.prepareStatement("select * from dbi_update_disable_utente_guru(?)");

			int i = 0;
			pst.setInt(++i, Integer.parseInt(userId));
			rs = pst.executeQuery();
			while (rs.next()){
				output = rs.getString(1);
			}

			context.getRequest().setAttribute("output", output);
			context.getRequest().setAttribute("username", username);
			
			salvaLog(db, getUserId(context), context.getIpAddress(), "ABILITA/DISABILITA UTENTE", output, Integer.parseInt(userId), username);


		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} finally{
			freeConnection(context, db);
		}

		return "GURUUpdateDisableOK";

	}

	public String executeCommandGURUModifyPassword(ActionContext context) {

		String userId = context.getRequest().getParameter("userId");

		if (!hasPermission(context, "guru-view") && getUserId(context) != Integer.parseInt(userId)) {
			return ("PermissionError");
		}

		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;

		try {
			db = this.getConnection(context);

			GURUUtente utente = new GURUUtente();
			pst = db.prepareStatement("select * from dbi_dettaglio_utente_guru(?)");
			int i = 0;
			pst.setInt(++i, Integer.parseInt(userId));
			rs = pst.executeQuery();
			while (rs.next()){
				utente.setId(rs.getInt("id"));
				utente.setNome(rs.getString("nome"));
				utente.setCognome(rs.getString("cognome"));
				utente.setCf(rs.getString("cf"));
				utente.setUsername(rs.getString("username"));
				utente.setAlias(rs.getString("alias_utente"));
				utente.setIdAsl(rs.getInt("id_asl"));
				utente.setIdRuolo(rs.getInt("id_ruolo"));
			}

			context.getRequest().setAttribute("utente", utente);


		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} finally{
			freeConnection(context, db);
		}

		return "GURUModifyPasswordOK";

	}

	public String executeCommandGURUUpdatePassword(ActionContext context) {

		String userId = context.getRequest().getParameter("userId");

		if (!hasPermission(context, "guru-view") && getUserId(context) != Integer.parseInt(userId)) {
			return ("PermissionError");
		}

		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;

		String username = context.getRequest().getParameter("username");
		String password = context.getRequest().getParameter("password");

		String output = "";

		try {
			db = this.getConnection(context);

			pst = db.prepareStatement("select * from dbi_update_password_utente_guru(?,?)");

			int i = 0;
			pst.setInt(++i, Integer.parseInt(userId));
			pst.setString(++i, password);
			rs = pst.executeQuery();
			while (rs.next()){
				output = rs.getString(1);
			}

			context.getRequest().setAttribute("output", output);
			context.getRequest().setAttribute("username", username);
			
			salvaLog(db, getUserId(context), context.getIpAddress(), "MODIFICA PASSWORD", output, Integer.parseInt(userId), username);


		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} finally{
			freeConnection(context, db);
		}

		return "GURUUpdatePasswordOK";

	}
	
	public String executeCommandGURUModifyAlias(ActionContext context) {

		String userId = context.getRequest().getParameter("userId");

		if (!hasPermission(context, "guru-view") && getUserId(context) != Integer.parseInt(userId)) {
			return ("PermissionError");
		}

		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;

		try {
			db = this.getConnection(context);

			GURUUtente utente = new GURUUtente();
			pst = db.prepareStatement("select * from dbi_dettaglio_utente_guru(?)");
			int i = 0;
			pst.setInt(++i, Integer.parseInt(userId));
			rs = pst.executeQuery();
			while (rs.next()){
				utente.setId(rs.getInt("id"));
				utente.setNome(rs.getString("nome"));
				utente.setCognome(rs.getString("cognome"));
				utente.setCf(rs.getString("cf"));
				utente.setUsername(rs.getString("username"));
				utente.setAlias(rs.getString("alias_utente"));
				utente.setIdAsl(rs.getInt("id_asl"));
				utente.setIdRuolo(rs.getInt("id_ruolo"));
			}

			context.getRequest().setAttribute("utente", utente);


		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} finally{
			freeConnection(context, db);
		}

		return "GURUModifyAliasOK";

	}

	public String executeCommandGURUUpdateAlias(ActionContext context) {

		String userId = context.getRequest().getParameter("userId");

		if (!hasPermission(context, "guru-view") && getUserId(context) != Integer.parseInt(userId)) {
			return ("PermissionError");
		}

		Connection db = null;
		PreparedStatement pst = null;
		ResultSet rs = null;

		String username = context.getRequest().getParameter("username");
		String alias_utente= context.getRequest().getParameter("alias");

		String output = "";

		try {
			db = this.getConnection(context);

			pst = db.prepareStatement("select * from dbi_update_alias_utente_guru(?,?)");

			int i = 0;
			pst.setInt(++i, Integer.parseInt(userId));
			pst.setString(++i, alias_utente);
			rs = pst.executeQuery();
			while (rs.next()){
				output = rs.getString(1);
			}

			context.getRequest().setAttribute("output", output);
			context.getRequest().setAttribute("username", username);
			
			salvaLog(db, getUserId(context), context.getIpAddress(), "MODIFICA ALIAS", output, Integer.parseInt(userId), username);


		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} finally{
			freeConnection(context, db);
		}

		return "GURUUpdateAliasOK";

	}
	
	public void salvaLog(Connection db, int enteredBy, String ip, String operazione, String output, int userId, String userName) throws SQLException {

		PreparedStatement pst = null;

			pst = db.prepareStatement("select * from dbi_insert_guru_log(?, ?, ?, ?, ?, ?)");

			int i = 0;
			pst.setInt(++i, enteredBy);
			pst.setString(++i, ip);
			pst.setString(++i, operazione);
			pst.setString(++i, output);
			pst.setInt(++i, userId);
			pst.setString(++i, userName);
			logger.info("[GURU] Insert Log: "+pst.toString()); 
			pst.executeQuery();
			
		


	}
}
