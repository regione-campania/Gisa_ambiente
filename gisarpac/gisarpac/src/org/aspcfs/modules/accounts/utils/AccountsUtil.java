package org.aspcfs.modules.accounts.utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import org.aspcfs.modules.actions.CFSModule;

public final class AccountsUtil extends CFSModule {
	
	 public static String cessazioneAttivita(Connection db, int orgId, Timestamp dataFine, String note, int userId) throws SQLException
		{
		 
		    Timestamp timeNow = new Timestamp(System.currentTimeMillis());
	 		String noteHd = "[Cessazione d'ufficio inserita da utente "+userId+" in data "+timeNow+"]";
		 
				int tipologia = -1;
				
							
				PreparedStatement pst = db.prepareStatement("select tipologia from organization where org_id = ?");
				pst.setInt(1, orgId);
				ResultSet rs = pst.executeQuery();
				if (rs.next())
					tipologia = rs.getInt("tipologia");
				
				pst = null;
				
				if (tipologia == 1){ //852
					pst = db.prepareStatement("UPDATE organization set modified=current_timestamp,modifiedby=?, data_fine_carattere=? , date2 = ? ,cessato =1,data_cessazione_attivita=?,note_cessazione_attivita=?, note_hd = concat_ws(';', note_hd, ?) where org_id=?");
					int i = 0;
					pst.setInt(++i, userId);
					pst.setTimestamp(++i, dataFine);
					pst.setTimestamp(++i, dataFine);
					pst.setTimestamp(++i, dataFine);
					pst.setString(++i, note);
					pst.setString(++i, noteHd);
					pst.setInt(++i, orgId);
					pst.execute();
					}
				else if (tipologia == 10){ //CANILI
					pst = db.prepareStatement("UPDATE organization set modified=now() ,modifiedby=?, cessato = ?,  data_fine_carattere=? , date2 = ? , data_cessazione_attivita=?,note_cessazione_attivita=?,  note_hd = concat_ws(';', note_hd, ?) where org_id=?");
					int i = 0;
					pst.setInt(++i, userId);
					pst.setInt(++i, 1);
					pst.setTimestamp(++i, dataFine);
					pst.setTimestamp(++i, dataFine);
					pst.setTimestamp(++i, dataFine);
					pst.setString(++i, note);
					pst.setString(++i, noteHd);
					pst.setInt(++i, orgId);
					pst.executeUpdate();
				}
				else if (tipologia == 151){ //FARMACOSORVEGLIANZA
					pst = db.prepareStatement("UPDATE organization set modified=current_timestamp,modifiedby=?,date2 = ? ,stato_lab=4,data_cessazione_attivita=?,note_cessazione_attivita=? , cessato = 1, stato = 'Cessato', data_cambio_stato = CURRENT_TIMESTAMP,  note_hd = concat_ws(';', note_hd, ?) where org_id=?");
					int i = 0;
					pst.setInt(++i, userId);
					pst.setTimestamp(++i, dataFine);
					pst.setTimestamp(++i, dataFine);
					pst.setString(++i, note);
					pst.setString(++i, noteHd);
					pst.setInt(++i, orgId);
					pst.execute();
				}
				else if (tipologia == 152){ //HACCP
					pst = db.prepareStatement("UPDATE organization set modified=current_timestamp,modifiedby=?,date2 = ? ,stato_lab=4,data_cessazione_attivita=?,note_cessazione_attivita=? , cessato = 1, stato = 'Cessato',data_cambio_stato = CURRENT_TIMESTAMP,  note_hd = concat_ws(';', note_hd, ?) where org_id=?");
					int i = 0;
					pst.setInt(++i, userId);
					pst.setTimestamp(++i, dataFine);
					pst.setTimestamp(++i, dataFine);
					pst.setString(++i, note);
					pst.setString(++i, noteHd);
					pst.setInt(++i, orgId);
					pst.execute();
				}
				else if (tipologia == 20){ //OPERATORI COMMERCIALI
					pst = db.prepareStatement("UPDATE organization set modified=now() ,modifiedby=?, cessato = ?,  data_chiusura_canile=? , date2 = ? , data_cessazione_attivita=?,note_cessazione_attivita=?,  note_hd = concat_ws(';', note_hd, ?) where org_id=?");
					int i = 0;
					pst.setInt(++i, userId);
					pst.setInt(++i, 1);
					pst.setTimestamp(++i, dataFine);
					pst.setTimestamp(++i, dataFine);
					pst.setTimestamp(++i, dataFine);
					pst.setString(++i, note);
					pst.setString(++i, noteHd);
					pst.setInt(++i, orgId);
					pst.executeUpdate();
				}
				else if (tipologia == 12){ //OPERATORI NON ALTROVE
					pst = db.prepareStatement("UPDATE organization set modified=current_timestamp,modifiedby=?, stato_lab = ?, contract_end = ?, data_fine_carattere=? , date2 = ? ,cessato =1,data_cessazione_attivita=?,note_cessazione_attivita=?,  note_hd = concat_ws(';', note_hd, ?) where org_id=?");
					int i = 0;	
					pst.setInt(++i, userId);
					pst.setInt(++i, 4);
					pst.setTimestamp(++i, dataFine);
					pst.setTimestamp(++i, dataFine);
					pst.setTimestamp(++i, dataFine);
					pst.setTimestamp(++i, dataFine);
					pst.setString(++i, note);
					pst.setString(++i, noteHd);
					pst.setInt(++i, orgId);
					pst.execute();
				}
				else if (tipologia == 801){ //OSM REGISTRATI
					pst = db.prepareStatement("UPDATE organization set modified=current_timestamp,modifiedby=?,date2 = ? ,stato_lab=4,data_cessazione_attivita=?,note_cessazione_attivita=?, note_hd = concat_ws(';', note_hd, ?) where org_id=?");
					int i = 0;
					pst.setInt(++i, userId);
					pst.setTimestamp(++i, dataFine);
					pst.setTimestamp(++i, dataFine);
					pst.setString(++i, note);
					pst.setString(++i, noteHd);
					pst.setInt(++i, orgId);
					pst.execute();
				}
				else if (tipologia == 802){ //PARAFARMACIE
					pst = db.prepareStatement("UPDATE organization set modified=current_timestamp,modifiedby=?,date2 = ? ,stato_lab=4,data_cessazione_attivita=?,note_cessazione_attivita=? , cessato = 1, stato = 'Cessato', data_cambio_stato = CURRENT_TIMESTAMP,  note_hd = concat_ws(';', note_hd, ?) where org_id=?");
					int i = 0;
					pst.setInt(++i, userId);
					pst.setTimestamp(++i, dataFine);
					pst.setTimestamp(++i, dataFine);
					pst.setString(++i, note);
					pst.setString(++i, noteHd);
					pst.setInt(++i, orgId);
					pst.execute();
				}
				else if (tipologia == 8){ //RIPRODUZIONE ANIMALE
					pst = db.prepareStatement("UPDATE organization set modified=current_timestamp,modifiedby=?,date2 = ? ,stato_lab=4,data_cessazione_attivita=?,note_cessazione_attivita=? , cessato = 1, stato = 'Cessato'  , data_cambio_stato = CURRENT_TIMESTAMP,  note_hd = concat_ws(';', note_hd, ?) where org_id=?");
					int i = 0;	
					pst.setInt(++i, userId);
					pst.setTimestamp(++i, dataFine);
					pst.setTimestamp(++i, dataFine);
					pst.setString(++i, note);
					pst.setString(++i, noteHd);
					pst.setInt(++i, orgId);
					pst.execute();
				}
				else if (tipologia == 17){ //IMBARCAZIONI
					pst = db.prepareStatement("UPDATE organization set modified=current_timestamp,modifiedby=?, stato_lab = ?, contract_end = ? ,note_cessazione_attivita=?,  note_hd = concat_ws(';', note_hd, ?) where org_id=?");
					int i = 0;
					pst.setInt(++i, userId);
					pst.setInt(++i, 4);
					pst.setTimestamp(++i, dataFine);
					pst.setString(++i, note);
					pst.setString(++i, noteHd);
					pst.setInt(++i, orgId);
					pst.execute();
				}
				else if (tipologia == 5){ //PUNTI DI SBARCO
					pst = db.prepareStatement("UPDATE organization set modified=current_timestamp,modifiedby=?, stato_lab = ?,  contract_end = ? ,note_cessazione_attivita=?,  note_hd = concat_ws(';', note_hd, ?) where org_id=?");
					int i = 0;
					pst.setInt(++i, userId);
					pst.setInt(++i, 4);
					pst.setTimestamp(++i, dataFine);
					pst.setString(++i, note);
					pst.setString(++i, noteHd);
					pst.setInt(++i, orgId);
					pst.execute();
				}
				else if (tipologia == 4){ //ABUSIVI
					pst = db.prepareStatement("UPDATE organization set modified=current_timestamp,modifiedby=?, stato_lab = ?, contract_end = ? ,note_cessazione_attivita=?,  note_hd = concat_ws(';', note_hd, ?) where org_id=?");
					int i = 0;
					pst.setInt(++i, userId);
					pst.setInt(++i, 4);
					pst.setTimestamp(++i, dataFine);
					pst.setString(++i, note);
					pst.setString(++i, noteHd);
					pst.setInt(++i, orgId);
					pst.execute();
				}
				else if (tipologia == 13){ //PRIVATI
					pst = db.prepareStatement("UPDATE organization set modified=current_timestamp,modifiedby=?, stato_lab = ?, contract_end = ? ,note_cessazione_attivita=?,  note_hd = concat_ws(';', note_hd, ?) where org_id=?");
					int i = 0;
					pst.setInt(++i, userId);
					pst.setInt(++i, 4);
					pst.setTimestamp(++i, dataFine);
					pst.setString(++i, note);
					pst.setString(++i, noteHd);
					pst.setInt(++i, orgId);
					pst.execute();
				}
				else if (tipologia == 22){ //ATT FUORI AMBITO ASL
					pst = db.prepareStatement("UPDATE organization set modified=current_timestamp,modifiedby=?, stato_lab = ?, contract_end = ? ,note_cessazione_attivita=?,  note_hd = concat_ws(';', note_hd, ?) where org_id=?");
					int i = 0;
					pst.setInt(++i, userId);
					pst.setInt(++i, 4);
					pst.setTimestamp(++i, dataFine);
					pst.setString(++i, note);
					pst.setString(++i, noteHd);
					pst.setInt(++i, orgId);
					pst.execute();
				}
				else{
					pst = db.prepareStatement("UPDATE organization set modified=current_timestamp,modifiedby=?, data_fine_carattere=? , date2 = ? ,cessato =1,data_cessazione_attivita=?,note_cessazione_attivita=?,  note_hd = concat_ws(';', note_hd, ?) where org_id=?");
					int i = 0;
					pst.setInt(++i, userId);
					pst.setTimestamp(++i, dataFine);
					pst.setTimestamp(++i, dataFine);
					pst.setTimestamp(++i, dataFine);
					pst.setString(++i, note);
					pst.setString(++i, noteHd);
					pst.setInt(++i, orgId);
					pst.execute();
				}
					
			
			return "";
		}

	 public static String sospensioneAttivita(Connection db, int orgId, Timestamp dataFine, String note, int userId) throws SQLException
		{
		 
		    Timestamp timeNow = new Timestamp(System.currentTimeMillis());
	 		String noteHd = "[Sospensione d'ufficio inserita da utente "+userId+" in data "+timeNow+"]";
		 
				int tipologia = -1;
				
							
				PreparedStatement pst = db.prepareStatement("select tipologia from organization where org_id = ?");
				pst.setInt(1, orgId);
				ResultSet rs = pst.executeQuery();
				if (rs.next())
					tipologia = rs.getInt("tipologia");
				
				pst = null;
				
				if (tipologia == 1){ //852
						}
				else if (tipologia == 10){ //CANILI
					}
				else if (tipologia == 151){ //FARMACOSORVEGLIANZA
					pst = db.prepareStatement("UPDATE organization set modified=current_timestamp,modifiedby=?,data_sospensione = ? ,stato_lab=2, stato = 'Sospeso', data_cambio_stato = CURRENT_TIMESTAMP,  note_hd = concat_ws(';', note_hd, ?, 'Motivazione: ',  ?) where org_id=?");
					int i = 0;
					pst.setInt(++i, userId);
					pst.setTimestamp(++i, dataFine);
					pst.setString(++i, note);
					pst.setString(++i, noteHd);
					pst.setInt(++i, orgId);
					pst.execute();
				}
				else if (tipologia == 152){ //HACCP
				}
				else if (tipologia == 20){ //OPERATORI COMMERCIALI
					}
				else if (tipologia == 12){ //OPERATORI NON ALTROVE
				}
				else if (tipologia == 801){ //OSM REGISTRATI
					}
				else if (tipologia == 802){ //PARAFARMACIE
					pst = db.prepareStatement("UPDATE organization set modified=current_timestamp,modifiedby=?,data_sospensione = ? ,stato_lab=2, stato = 'Sospeso', data_cambio_stato = CURRENT_TIMESTAMP,  note_hd = concat_ws(';', note_hd, ?) where org_id=?");
					int i = 0;
					pst.setInt(++i, userId);
					pst.setTimestamp(++i, dataFine);
					pst.setTimestamp(++i, dataFine);
					pst.setString(++i, note);
					pst.setString(++i, noteHd);
					pst.setInt(++i, orgId);
					pst.execute();
				}
				else if (tipologia == 8){ //RIPRODUZIONE ANIMALE
					}
				else if (tipologia == 17){ //IMBARCAZIONI
					}
				else if (tipologia == 5){ //PUNTI DI SBARCO
				}
				else if (tipologia == 4){ //ABUSIVI
					}
				else if (tipologia == 13){ //PRIVATI
					}
				else if (tipologia == 22){ //ATT FUORI AMBITO ASL
					}
				else{
					}
					
			
			return "";
		}
	 
	 public static boolean isCancellabile(Connection db, int orgId) throws SQLException {
			boolean esito = false;
			PreparedStatement pst = db.prepareStatement("select * from is_org_cancellabile(?)");
			pst.setInt(1, orgId);
			ResultSet rs = pst.executeQuery();
			while (rs.next())
				esito = rs.getBoolean(1);
			return esito;
		}
		 
	public static boolean deleteCentralizzato(Connection db, int orgId, String note, int userId) throws SQLException {
		boolean esito = false;
		PreparedStatement pst = db.prepareStatement("select * from org_delete_centralizzato(?, ?, ?)");
		pst.setInt(1, orgId);
		pst.setString(2, note);
		pst.setInt(3, userId);
		ResultSet rs = pst.executeQuery();
		while (rs.next())
			esito = rs.getBoolean(1);
		return esito;
	}
	 
	 
}
