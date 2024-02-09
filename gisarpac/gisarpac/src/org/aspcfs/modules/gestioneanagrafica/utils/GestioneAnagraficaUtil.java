package org.aspcfs.modules.gestioneanagrafica.utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.aspcfs.modules.actions.CFSModule;

public final class GestioneAnagraficaUtil extends CFSModule {
	
	 
	 public static boolean isCancellabile(Connection db, int altId) throws SQLException {
			boolean esito = false;
			PreparedStatement pst = db.prepareStatement("select * from is_anagrafica_cancellabile(?)");
			pst.setInt(1, altId);
			ResultSet rs = pst.executeQuery();
			while (rs.next())
				esito = rs.getBoolean(1);
			return esito;
		}
		 
	public static boolean deleteCentralizzato(Connection db, int altId, String note, int userId) throws SQLException {
		boolean esito = false;
		PreparedStatement pst = db.prepareStatement("select * from anagrafica_delete_centralizzato(?, ?, ?)");
		pst.setInt(1, altId);
		pst.setString(2, note);
		pst.setInt(3, userId);
		ResultSet rs = pst.executeQuery();
		while (rs.next())
			esito = rs.getBoolean(1);
		return esito;
	}
	 
	 
}
