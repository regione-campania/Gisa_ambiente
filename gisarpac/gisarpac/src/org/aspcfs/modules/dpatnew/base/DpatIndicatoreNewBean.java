package org.aspcfs.modules.dpatnew.base;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;

import org.aspcfs.modules.dpat.actions.Dpat;
import org.aspcfs.modules.dpatnew_interfaces.DpatIndicatoreNewBeanAbstract;
 


public class DpatIndicatoreNewBean extends DpatIndicatoreNewBeanAbstract implements Cloneable {

	 
	
	public  ArrayList<DpatIndicatoreNewBean> buildList(Connection conn, ResultSet rs ) throws Exception 
	{
		ArrayList<DpatIndicatoreNewBean> toRet = new ArrayList<DpatIndicatoreNewBean>();
		
		while(rs.next())
		{
			toRet.add(build(conn,rs ));
		}
		
		return toRet;
	}
	
	public  DpatIndicatoreNewBean build(Connection conn, ResultSet rs ) throws Exception 
	{
		DpatIndicatoreNewBean toRet = new DpatIndicatoreNewBean();
		toRet.setOid(rs.getLong("id"));
		toRet.setCodiceRaggruppamento(rs.getInt("cod_raggruppamento"));
		toRet.setOidPianoAttivita(rs.getLong("id_piano_attivita"));
		toRet.setAnno(rs.getInt("anno"));
		toRet.setDescrizione(rs.getString("descrizione"));
		toRet.setStato(rs.getInt("stato"));
		toRet.setOrdine(rs.getInt("ordinamento"));
		toRet.setCodiceEsame(rs.getString("codice_esame"));
		toRet.setScadenza(rs.getTimestamp("data_scadenza"));
//		toRet.setCodiceAlias(rs.getString("codice_alias"));
		try
		{
			toRet.setTipoAttivita(rs.getString("tipo_attivita"));
		}
		catch(Exception e)
		{
			
		}
		
		
		toRet.setCodiceInternoIndicatore(rs.getInt("codice_interno_indicatore"));
		toRet.setAliasIndicatore(rs.getString("alias_indicatore"));
		toRet.setCodiceInternoPianiGestioneCu(rs.getInt("codice_interno_piani_gestione_cu"));
		toRet.setCodiceInternoAttivitaGestioneCu(rs.getString("codice_interno_attivita_gestione_cu"));
		toRet.setCodiceInternoUnivocoTipoAttivitaGestioneCu(rs.getString("codice_interno_univoco_tipo_attivita_gestione_cu"));
		toRet.setCodiceAliasIndicatore(rs.getString("codice_alias_indicatore"));
		
		
		/*per costruire la stringa del path completo per comodita' */
		DpatPianoAttivitaNewBean pianoAttivitaPadre = new DpatPianoAttivitaNewBean().buildByOid(conn, rs.getInt("id_piano_attivita"), false,false);
		String descrSezMadre = pianoAttivitaPadre.getDescrSezMadre();
		String descrPianoAttivitaPadre = pianoAttivitaPadre.getDescrizione();
		toRet.setDescrSezMadre(descrSezMadre);
		toRet.setDescrPianoAttivitaPadre(descrPianoAttivitaPadre);
		
		return toRet;
	}
	
	 
	public  ArrayList<DpatIndicatoreNewBean> searchVersioniPerCodiceRaggruppamento(Connection conn, Integer codRaggruppamento, int anno) throws SQLException
	{
		PreparedStatement pst = null;
		ResultSet rs = null;
		ArrayList<DpatIndicatoreNewBean> toRet = null;
		
		
		try
		{
			pst = conn.prepareStatement("select b.*, least(a.data_scadenza, b.data_scadenza) as min_scadenza from dpat_indicatore_new b join dpat_piano_attivita_new a on b.id_piano_attivita = a.id where a.stato != 1 and b.stato != 1 and b.cod_raggruppamento = ? and b.anno  = ?order by min_scadenza ");
			pst.setInt(1, codRaggruppamento);
			pst.setInt(2,anno);
			rs = pst.executeQuery();
			toRet =  buildList(conn, rs);
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		finally
		{
			try { pst.close(); } catch(Exception ex){}
			try { rs.close(); } catch(Exception ex){}
		}
		return toRet;
	}
	
	public  DpatIndicatoreNewBean buildByOid(Connection conn, Integer oid,boolean nonscaduti)
	{
		PreparedStatement pst = null;
		ResultSet rs = null;
		DpatIndicatoreNewBean toRet = null;
		String query = "select * from dpat_indicatore_new where id = ?  "+(nonscaduti ? " and data_scadenza is null": "") ;
			
		
		try
		{
			pst = conn.prepareStatement(query);
			pst.setInt(1, oid.intValue());
			rs = pst.executeQuery();
			if(rs.next())
			{
				toRet = build(conn,rs );
			}
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		finally
		{
			try{pst.close();}catch(Exception ex){}
			try{rs.close();}catch(Exception ex){}
		}
		return toRet;
	}
	
	 
	
	
	/*inserisco dummy child per piano attivita specificato soltanto se effettivamente questo non ha figli */
	public Integer insertDummyChildPerPianoAttivitaScelto(Connection db, Integer anno, Long pianoAttivitaPadre) throws Exception
	{
		 
		 String query1 = null; 
		 String query2 = null; 
		 PreparedStatement pst = null;
		 ResultSet rs = null;
		 
		try
		{
			
			/*CORREZIONE AL 29/09/17 -> L'INDICATORE DEVE EREDITARE IL TIPO ATTIVITA DEL PADRE : PIANO SE E' PIANO, ATTIVITA-AUDIT SE ATTIVITA-AUDIT ETC..."
			/*la max sullo stato e' usato solo come escamotage per portarsi anche il count(*) poiche' se la search e' per id c'e' solo un record con unico stato, lo stesso
			 * per il tipo_attivita */
			pst = db.prepareStatement("select tipo_attivita from dpat_piano_attivita_new where id = ?");
			pst.setInt(1, pianoAttivitaPadre.intValue());
			rs = pst.executeQuery();
			rs.next();
			String tipoAttivitaPadre = rs.getString(1);
			rs.close();
			pst.close();
			
			query1 = "select count(*), max(stato) from dpat_indicatore_new where id_piano_attivita = ? and data_scadenza is NULL";
			query2 = "insert into dpat_indicatore_new(id_piano_attivita,anno,descrizione,ordinamento,data_scadenza,stato,codice_esame,alias_indicatore,tipo_attivita)"
				 		+ " values(?, ?, ?, ?, NULL, ?,'','DEFAULT',?) returning id";
 
			
			 
			
			pst = db.prepareStatement(query1);
			pst.setInt(1,pianoAttivitaPadre.intValue() );
			 
			rs = pst.executeQuery();
			rs.next();
			int totFigli = rs.getInt(1);
			int statoPadre = rs.getInt(2);
			pst.close();
			rs.close();
			
			 
			 if(totFigli > 0) /*ha gia' figli attivi */
			{
				return -1;
			}
			
			/*se lo stato del padre e' 1, allora e' uno anche il figlio, altrimenti...*/
			int stato = statoPadre == 1 ? 1 : new DpatWrapperSezioniBean().getStatoDopoModifica(db, anno);
			 
			 
			 pst = db.prepareStatement(query2);
			 pst.setInt(1, pianoAttivitaPadre.intValue());
			 pst.setInt(2, anno);
			 pst.setString(3, "INDICATORE DI DEFAULT DA SOSTITUIRE");
			 pst.setInt(4, 0);
			 pst.setInt(5, stato);
			 pst.setString(6, tipoAttivitaPadre);
			 
			 pst.execute();
			 
			 /*ottengo id fisico del dummy inserito e lo ritorno */
			  
			 rs = pst.getResultSet();
			 rs.next();
			 Integer idFisicoDummy = rs.getInt("id");
			 System.out.println("IL PIANO ATTIVITA SPECIFICATO ("+pianoAttivitaPadre+") AVEVA 0 FIGLI ATTIVI >> AGGIUNTO DUMMY CHILD" );
			 return idFisicoDummy;
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			throw ex;
		}
		finally
		{
			try{ pst.close(); }catch(Exception ex){}
			try{ rs.close(); }catch(Exception ex){}
		}
	}

	
	/*inserisce dummy child per l'ultimo piano attivita inserito, solo se questo effettivamente non ha figli */
	public  Integer insertDummyChildPerUltimoPianoAttivitaInserito(Connection db,Integer anno) throws Exception 
	
	{
		
		 String query0= null,query1 = null,query= null;
		 Integer idFisicoDummy = null;
		  
		 PreparedStatement pst = null;
		 ResultSet rs = null;
		 
		 
		 
		 
		 
		 	/*Modifica del 29/09/2017 : l'INDICATORE DEVE PORTARSI IL TIPO_ATTIVITA DLE PADRE : SE E' PIANO IL PADRE SARA' PIANo, SE E' ATTIVITA' SARA' ATTIVITA */
			 query0 = "select  id, tipo_attivita  from dpat_piano_attivita_new where id = (select max(id) from dpat_piano_attivita_new where anno = ? and stato != 1 )  ";
			  query1 =  "select count(*) from dpat_indicatore_new where id_piano_attivita = ? and stato != 1"; /*tutti i figli devono avere stesso tipo attivita quindi la max ha senso p*/
			   query =   "insert into dpat_indicatore_new(id_piano_attivita,anno,descrizione,ordinamento,data_scadenza,stato,codice_esame,alias_indicatore,tipo_attivita)"
			 		+ " values(?, ?, ?, ?, NULL, ?,'','DEFAULT',?) returning id";
		 
		 
		 
		 try
		 {
			 
			 pst = db.prepareStatement(query0);
			 pst.setInt(1, anno);
			 
			 rs = pst.executeQuery();
			 /*riottengo oid ultimo piano_attivita inserito*/
			 rs.next();
			 int idPianoAttivitaNuovo = rs.getInt(1);
			 String tipoAttivitaPadre = rs.getString(2);
			 pst.close();
			 rs.close();
			 pst = db.prepareStatement(query1);
			 pst.setInt(1, idPianoAttivitaNuovo);
			 
			 rs = pst.executeQuery();
			 rs.next();
			 int numeroFigli = rs.getInt(1);
			 if(numeroFigli > 0) /*ha gia' figli quindi non devo aggiungere il dummy */
				 return -1;
			 
			 /*altrimenti devo aggiunger efiglio dummy del piano attivita */
			 
			pst.close();
			rs.close();
			int stato =  new DpatWrapperSezioniBean().getStatoDopoModifica(db, anno);
			 
			 
			 
			 pst = db.prepareStatement(query);
			 pst.setInt(1, idPianoAttivitaNuovo);
			 pst.setInt(2, anno);
			 pst.setString(3, "INDICATORE DI DEFAULT DA SOSTITUIRE");
			 pst.setInt(4, 0);
			 pst.setInt(5, stato);
			 pst.setString(6, tipoAttivitaPadre);
			 pst.execute();
			 
			 /*ottengo id fisico del dummy inserito e lo ritorno */
			  
			 rs = pst.getResultSet();rs.next();
			 idFisicoDummy = rs.getInt("id");
			 System.out.println("IL PIANO ATTIVITA SPECIFICATO ("+idPianoAttivitaNuovo+") AVEVA 0 FIGLI >> AGGIUNTO DUMMY CHILD" );
			 return idFisicoDummy;
			 
		 }
		 catch(Exception ex)
		 {
			 ex.printStackTrace();
			 throw ex;
		 }
		 finally
		 {
			 try{pst.close();} catch(Exception ex){}
			 
			 try{rs.close();} catch(Exception ex){}
		 }
		 
				 
	}
	
	
	
	public void insert(Connection db) throws Exception 
	{
		PreparedStatement pst = null;
		String insertQuery = null;
		 
			insertQuery = "insert into dpat_indicatore_new(cod_raggruppamento,id_piano_attivita,anno,descrizione,ordinamento,data_scadenza,stato,codice_esame,tipo_attivita,codice_interno_indicatore,alias_indicatore,codice_interno_piani_gestione_cu, codice_interno_attivita_gestione_cu,codice_interno_univoco_tipo_attivita_gestione_cu,codice_alias_indicatore) "
					+ " values(?,?,?,?,?,NULL,?,?,?,?,?,?,?,?,?)";
		 
				
		
		try
		{
			pst = db.prepareStatement(insertQuery);
			pst.setInt(1,getCodiceRaggruppamento());
			pst.setInt(2, getOidPianoAttivita().intValue());
			pst.setInt(3, getAnno());
			pst.setString(4, getDescrizione());
			pst.setInt(5, getOrdine());
			pst.setInt(6,getStato());
			pst.setString(7,getCodiceEsame());
			pst.setString(8, getTipoAttivita());
			pst.setInt(9, getCodiceInternoIndicatore());
			pst.setString(10, getAliasIndicatore());
			pst.setInt(11, getCodiceInternoPianiGestioneCu());
			pst.setString(12, getCodiceInternoAttivitaGestioneCu());
			pst.setString(13, getCodiceInternoUnivocoTipoAttivitaGestioneCu());
			pst.setString(14, getCodiceAliasIndicatore());
			
			
			pst.executeUpdate();
			
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			throw ex;
			
		}
		finally
		{
			try{pst.close();} catch(Exception ex){}
		}
	}
	
	
	
	
	
	
	
	public Integer insertBeforeOrAfter(Connection db, DpatIndicatoreNewBeanAbstract toInsert, DpatIndicatoreNewBeanAbstract indicatoreRiferimento, String where) throws Exception 
	{
		boolean autocommit = db.getAutoCommit();
		/*insert generando nuovo codice raggruppamento */
		String queryInsert0 = null,queryInsert1 = null;
		
		
		 /*alcuni campi vengono da maschera (o dal bean vecchio) e in entrambi i casi sono settati in toInsert
		  * altri dal bean di riferimento e stanno quindi in indicatoreRiferimento
		  */
		
		/*quelli che vengono dal bean di riferimento ************************************************************************
		 * 
		 */
		 Integer idPianoAttivita = Integer.parseInt(indicatoreRiferimento.getOidPianoAttivita()+"");
		 Integer anno = indicatoreRiferimento.getAnno();
		 int ordinamento = 0;
		 int u = 0;
		 /*quelli che vengono dal bean vecchio/maschera **********************************************************************
		  * 
		  */
		 String descrizione = toInsert.getDescrizione();
		 String codice_esame = toInsert.getCodiceEsame();
		 String alias = toInsert.getAliasIndicatore();
		 String tipoAttivita = toInsert.getTipoAttivita();
		 Integer codiceInternoIndicatore = toInsert.getCodiceInternoIndicatore();
		 Integer codiceInternoPianiGestioneCu = toInsert.getCodiceInternoPianiGestioneCu();
		 String codiceInternoAttivitaGestioneCu = toInsert.getCodiceInternoAttivitaGestioneCu();
		 String codiceInternoUnivocoTipoAttivitaGestioneCu = toInsert.getCodiceInternoUnivocoTipoAttivitaGestioneCu();
		 String codiceAliasIndicatore = toInsert.getCodiceAliasIndicatore();
		 
		 /*il codice di raggruppamento viene dal bean vecchio (se e' un inserimento per spostamento o modifica) mentre se e' un inserimento ex novo va generato 
		  * nel secondo caso non lo troviamo in toInsert
		  * */
		 Integer codRaggruppamento = toInsert.getCodiceRaggruppamento();
		 
		 PreparedStatement pst = null;
		  
		 ResultSet rs = null;
		 
		 
		
			  queryInsert0 = "insert into dpat_indicatore_new(id_piano_attivita,anno,descrizione,ordinamento,data_scadenza,stato,codice_esame,alias_indicatore,tipo_attivita,codice_interno_indicatore,codice_interno_piani_gestione_cu,codice_interno_attivita_gestione_cu,codice_interno_univoco_tipo_attivita_gestione_cu,codice_alias_indicatore)"
				 		+ " values(?,?,?,?,NULL,?,?,?,?,?,?,?,?,?) returning id";
				
				/*insert usando codice raggruppamento dal vecchio bean (es inserimento per modifica / spostamento)*/
				 queryInsert1 = "insert into dpat_indicatore_new(cod_raggruppamento,id_piano_attivita,anno,descrizione,ordinamento,data_scadenza,stato,codice_esame,alias_indicatore,tipo_attivita,codice_interno_indicatore,codice_interno_piani_gestione_cu,codice_interno_attivita_gestione_cu,codice_interno_univoco_tipo_attivita_gestione_cu,codice_alias_indicatore)"
				 		+ " values(?,?,?,?,?,NULL,?,?,?,?,?,?,?,?,?) returning id";
		
		 
		 try
		 {
			 db.setAutoCommit(false);
			 
			 int stato =  new DpatWrapperSezioniBean().getStatoDopoModifica(db,anno);
			 
			 /*per l'ordinamento*/
			 if(where.toLowerCase().equals("up"))
			 {
				 ordinamento = indicatoreRiferimento.getOrdine();
				
				 
			 }
			 else /*down*/
			 {
				 ordinamento = indicatoreRiferimento.getOrdine()+1;
			 }
			 
			 
			 
			 if(codRaggruppamento != null)
			 {
				 
				 pst = db.prepareStatement(queryInsert1);
				 pst.setInt(++u, codRaggruppamento);
				 
			 }
			 else
			 {
				 pst = db.prepareStatement(queryInsert0);
			 }
			
			 
			 /*shifto tutti i successivi*/
			 new DpatIndicatoreNewBean().incrementaOrdiniPerPianoAttivita(db,"ordinamento >= "+ordinamento, idPianoAttivita,anno);
			 
			 Dpat.setNullableField(pst, idPianoAttivita, ++u, java.sql.Types.INTEGER);
			 Dpat.setNullableField(pst, anno, ++u, java.sql.Types.INTEGER);
			 Dpat.setNullableField(pst, descrizione, ++u, java.sql.Types.VARCHAR);
			 Dpat.setNullableField(pst, ordinamento, ++u, java.sql.Types.INTEGER);
			 Dpat.setNullableField(pst, stato, ++u, java.sql.Types.INTEGER);
			 Dpat.setNullableField(pst, codice_esame, ++u, java.sql.Types.VARCHAR);
			 Dpat.setNullableField(pst, alias, ++u, java.sql.Types.VARCHAR);
			 Dpat.setNullableField(pst, tipoAttivita, ++u, java.sql.Types.VARCHAR);
			 Dpat.setNullableField(pst, codiceInternoIndicatore, ++u, java.sql.Types.INTEGER);
			 Dpat.setNullableField(pst, codiceInternoPianiGestioneCu, ++u, java.sql.Types.INTEGER);
			 Dpat.setNullableField(pst, codiceInternoAttivitaGestioneCu, ++u, java.sql.Types.VARCHAR);
			 Dpat.setNullableField(pst, codiceInternoUnivocoTipoAttivitaGestioneCu, ++u, java.sql.Types.VARCHAR);
			 Dpat.setNullableField(pst, codiceAliasIndicatore, ++u, java.sql.Types.VARCHAR);
			 
			 pst.execute();
			  
			 db.commit();
			 
			 
			 /*ottengo id inserito*/
			 rs = pst.getResultSet();
			 rs.next();
			 Integer idInserito = rs.getInt("id");
			 
			 return idInserito;
		 }
		 catch(Exception ex)
		 {
			 ex.printStackTrace();
			 db.rollback();
			 throw ex;
		 }
		 finally
		 {
			 try{pst.close();} catch(Exception ex){}
			 
			 
			 try{
				 db.setAutoCommit(autocommit);
			 } catch(Exception ex){ex.printStackTrace();}
		 }
	}
	
	
	
	
	public  void insert(Connection db, DpatIndicatoreNewBeanAbstract indicatoreRiferimento, String descrizione,
			String codice_esame, String asl, String tipoAttivita, String alias, String codiceAlias) throws Exception 
	
	{
		 String query =null;
		
		 
			 query = "insert into dpat_indicatore_new(id_piano_attivita,anno,descrizione,ordinamento,data_scadenza,stato,codice_esame,alias_indicatore,tipo_attivita,codice_alias_indicatore)"
				 		+ " values(?,?,?,?,NULL,?,?,?,?,?)";
		  
		 /*alcuni campi vengono dal piano di riferimento, altri vengono dalla maschera di inserimento */
//		 Integer codRaggrupp = indicatoreRiferimento.getCodiceRaggruppamento();
		 Integer idPianoAttivita = Integer.parseInt(indicatoreRiferimento.getOidPianoAttivita()+"");
		 Integer anno = indicatoreRiferimento.getAnno();
		 PreparedStatement pst = null;
		  
		 ResultSet rs = null;
		 
		 try
		 {
			 
			 int stato = new DpatWrapperSezioniBean().getStatoDopoModifica(db,anno);
			 
			 
			 pst = db.prepareStatement(query);
			 /*per l'ordinamento*/
			 String tipoInserimento = indicatoreRiferimento.getTipoInserimento() != null ? indicatoreRiferimento.getTipoInserimento().toLowerCase() : "down";
			 int ordinamento = 0;
			 if(tipoInserimento.equals("up"))
			 {
				 ordinamento = indicatoreRiferimento.getOrdine();
				
				
				 
			 }
			 else /*down*/
			 {
				 ordinamento = indicatoreRiferimento.getOrdine()+1;
			 }
			 
			 /*shifto tutti i successivi*/
			 new DpatIndicatoreNewBean().incrementaOrdiniPerPianoAttivita(db,"ordinamento >= "+ordinamento, idPianoAttivita,anno);
			 
			 int u = 0;
//			 pst.setInt(++u,codRaggrupp);
			 pst.setInt(++u,idPianoAttivita);
			 pst.setInt(++u,anno);
			 pst.setString(++u,descrizione);
			 pst.setInt(++u,ordinamento);
			 
			 pst.setInt(++u,stato);
			 pst.setString(++u,codice_esame);
			 pst.setString(++u,alias);
			 pst.setString(++u,tipoAttivita);
			 pst.setString(++u,codiceAlias);
			 
			 pst.executeUpdate();
			  
			 
		 }
		 catch(Exception ex)
		 {
			 ex.printStackTrace();
			 throw ex;
		 }
		 finally
		 {
			 try{pst.close();} catch(Exception ex){}
			 
			 try{rs.close();} catch(Exception ex){}
		 }
		 
				 
	}
	
	 
	public void incrementaOrdiniPerPianoAttivita(Connection conn, String condition, Integer oidPianoAttivita, Integer anno)
	{
		PreparedStatement pst = null;
		String query = null;
		
		
			query = "update dpat_indicatore_new set ordinamento = ordinamento+1 where "+condition+" and id_piano_attivita = ? and anno = ? and stato != 1";
		
		try
		{
			pst = conn.prepareStatement(query);
			pst.setInt(1, oidPianoAttivita);
			pst.setInt(2, anno);
			 
			pst.executeUpdate();
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		finally
		{
			try{pst.close();}catch(Exception ex){}
		}
	}
	
	
	public  void disabilitaByOid(Connection conn, int id,int anno ) throws Exception {
		PreparedStatement pst = null;
		String query = null;
		 
		 
			query = "update dpat_indicatore_new set data_scadenza = CURRENT_TIMESTAMP, stato = ? where id = ? and stato != 1 ";
		 
		
		try
		{
			pst = conn.prepareStatement(query);
			 
				int newstato = new DpatWrapperSezioniBean().getStatoDopoModifica(conn, anno);
				pst.setInt(1, newstato);
				pst.setInt(2, id);
			 
			
			pst.executeUpdate();
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			throw ex;
		}
		finally
		{
			try{pst.close();}catch(Exception ex){}
		}
		
	}
	
	public   void disabilitaByOid(Connection conn, int id,int anno, Timestamp dataToSet) throws Exception 
	{
		PreparedStatement pst = null;
		
		try
		{
			 
			
			pst = conn.prepareStatement("update dpat_indicatore_new set data_scadenza = ?, stato = ? where id = ? and stato != 1");
			int newstato = new DpatWrapperSezioniBean().getStatoDopoModifica(conn, anno);
			pst.setTimestamp(1, dataToSet);
			pst.setInt(2, newstato);
			pst.setInt(3, id);
			pst.executeUpdate();
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			throw ex;
		}
		finally
		{
			try{pst.close();}catch(Exception ex){}
		}
		
	}
	
	
	public Integer update(DpatIndicatoreNewBeanAbstract newValue, DpatIndicatoreNewBeanAbstract indicatoreRiferimento, Connection db) throws Exception {
		
		PreparedStatement pst = null;
		Integer newIdFisicoInserito = null;
		 
		
		try
		{
			
		    int newstato = new DpatWrapperSezioniBean().getStatoDopoModifica(db, newValue.getAnno());
		    newValue.setStato(newstato);
		   
		    /*disabilito quello che sto aggiornando */
			 new DpatIndicatoreNewBean().disabilitaByOid(db, indicatoreRiferimento.getOid().intValue(), newValue.getAnno());
		    
			/*faccio inserimento di quello "nuovo" (cioe' la versione modificata) dopo quello vecchio (cioe' quello modificato)*/
		     newIdFisicoInserito = new DpatIndicatoreNewBean().insertBeforeOrAfter(db, newValue, indicatoreRiferimento, "down");
			
			 return newIdFisicoInserito;
			 
			
			 
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			throw ex;
		}
		finally
		{
			try{pst.close();}catch(Exception ex){}
		}
		 
		
	}
	
	
	public  int deleteDummyBrother(Connection db, DpatIndicatoreNewBeanAbstract indicatoreRiferimento) throws Exception 
	{
		 String query = null; 
		
			query = "delete from dpat_indicatore_new where descrizione ilike 'INDICATORE DI DEFAULT DA SOSTITUIRE' and anno = ? and id_piano_attivita = ? and stato != 1 "; 
		
			  
			 PreparedStatement pst = null;
			 
			 try
			 {
				  
				 
				 pst = db.prepareStatement(query);
				 pst.setInt(1, indicatoreRiferimento.getAnno());
				 pst.setInt(2, indicatoreRiferimento.getOidPianoAttivita().intValue());
				  
				 int deleted = pst.executeUpdate();
				 return deleted;
				 
			 }
			 catch(Exception ex)
			 {
				 ex.printStackTrace();
				 throw ex;
			 }
			 finally
			 {
				 try{pst.close();} catch(Exception ex){}
				 
			 }
		
	}

	
	/*dato oid piano attivita ritorna il dpatindicatore figlio con l'ordine massimo */
	public  DpatIndicatoreNewBean searchLastChildOf(Connection db, Integer oidPianoAttivita,boolean nonscaduti) throws Exception {
		
		PreparedStatement pst = null;
		ResultSet rs = null;
		String query = "select * from dpat_indicatore_new where stato != 1 and id_piano_attivita = ? "+(nonscaduti ? " and data_scadenza is null ": " ")+" order by ordinamento desc";
		
		try
		{
			pst = db.prepareStatement(query);
			pst.setInt(1, oidPianoAttivita);
			 
			rs = pst.executeQuery();
			rs.next();
			DpatIndicatoreNewBean toRet = new DpatIndicatoreNewBean().build(db, rs);
			return toRet;
			
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			throw ex;
		}
		finally
		{
			try{pst.close();}catch(Exception ex){}
			try{rs.close();}catch(Exception ex){}
		}
	}
	
	
	public Integer spostaCompetenzeFromTo(Long oidFrom, Long oidTo,Connection conn) throws Exception
	{
		 
		
		PreparedStatement pst = null;
		try
		{
			pst = conn.prepareStatement("insert into dpat_competenze_struttura_indicatore(id_struttura,id_indicatore, "
					+ "competenza_attribuita,entered,entered_by,modified,modified_by,enabled,id_dpat,note) "
					+ " select id_struttura,?,competenza_attribuita,entered,entered_by,modified,modified_by,enabled,id_dpat,note "
					+ " from dpat_competenze_struttura_indicatore where id_indicatore = ? ");
			pst.setLong(1,oidTo );
			pst.setLong(2, oidFrom );
			Integer nInseriti = pst.executeUpdate();
			return nInseriti;
		}
		catch(Exception ex)
		{
			throw ex;
		}
		finally
		{
			try{pst.close();}catch(Exception ex){}
		}
	}

	@Override
	public int aggiornaCodiceAliasIndicatorePerTutteVersioni(Connection db, DpatIndicatoreNewBeanAbstract bean)
			throws Exception {
		
		

		PreparedStatement pst = null;
		try
		{
			String nuovoCodIndicatore = bean.getCodiceAliasIndicatore();
			Integer codRaggruppamento = bean.getCodiceRaggruppamento();
			pst = db.prepareStatement("update dpat_indicatore_new set codice_alias_indicatore = ? where cod_raggruppamento = ? and stato = 2 ");
			pst.setInt(2, codRaggruppamento);
			pst.setString(1, nuovoCodIndicatore);
			return pst.executeUpdate();
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			throw ex;
		}
		finally
		{
			try { pst.close(); } catch(Exception ex) {}
		}
	
	
		
	}

	 
	 
 
	
	
}
