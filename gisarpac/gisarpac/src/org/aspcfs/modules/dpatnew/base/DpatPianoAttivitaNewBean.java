package org.aspcfs.modules.dpatnew.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import org.aspcfs.modules.dpat.actions.Dpat;
import org.aspcfs.modules.dpatnew_interfaces.DpatIndicatoreNewBeanAbstract;
import org.aspcfs.modules.dpatnew_interfaces.DpatPianoAttivitaNewBeanInterface;

public class DpatPianoAttivitaNewBean extends DpatPianoAttivitaNewBeanInterface<DpatIndicatoreNewBean> {

	 
	private static final long serialVersionUID = 1L;
	
	 
	
	public ArrayList<DpatPianoAttivitaNewBean> buildList(Connection conn, ResultSet rs,boolean nonscaduti, boolean withChilds) throws Exception
	{
		ArrayList<DpatPianoAttivitaNewBean> toRet = new ArrayList<DpatPianoAttivitaNewBean>();
		
		while(rs.next())
		{
			toRet.add(build(conn,rs,nonscaduti,withChilds));
		}
		
		return toRet;
	}
	
	
	
	
	public ArrayList<DpatPianoAttivitaNewBean> searchVersioniPerCodiceRaggruppamento(Connection conn, Integer codRaggruppamento, boolean withChilds, int anno) throws Exception
	{
		PreparedStatement pst = null;
		ResultSet rs = null;
		ArrayList<DpatPianoAttivitaNewBean> toRet = null;
		try
		{
			/*prendo tutti quelli con stesso codice raggruppamento, ma siccome stanno in join con gli indicatori, se non metto la distinct sull'id fisico avrei un'entry
			 * per ciascuno degli indicatori agganciati allo stesso nodo
			 */
			
			
			pst = conn.prepareStatement("select * from (select distinct on (a.id) a.*, least(a.data_scadenza, b.data_scadenza) as min_scadenza from dpat_indicatore_new b join dpat_piano_attivita_new a on b.id_piano_attivita = a.id where a.stato != 1 and b.stato != 1 and a.cod_raggruppamento = ? ) c "
					+ " where anno = ?   order by c.min_scadenza");
			pst.setInt(1, codRaggruppamento);
			pst.setInt(2,anno);
			rs = pst.executeQuery();
			toRet =  buildList(conn, rs,false, withChilds);
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
	
	
	public DpatPianoAttivitaNewBean buildByOid(Connection conn, Integer oid, boolean nonscaduti, boolean withChilds)
	{
		PreparedStatement pst = null;
		ResultSet rs = null;
		DpatPianoAttivitaNewBean toRet = null;
		String query = "select * from dpat_piano_attivita_new where stato != 1 and id = ? "+(nonscaduti ? " and data_scadenza is null": "");
		
		try
		{
			pst = conn.prepareStatement(query);
			pst.setInt(1, oid.intValue());
			 
			rs = pst.executeQuery();
			if(rs.next())
			{
				toRet = build(conn,rs,nonscaduti,withChilds);
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
	
	
	public  DpatPianoAttivitaNewBean build(Connection conn, ResultSet rs,boolean nonscaduti, boolean withChilds) throws Exception 
	{
		DpatPianoAttivitaNewBean toRet = new DpatPianoAttivitaNewBean();
		PreparedStatement pst = null;
		ResultSet rs1 = null;
		try
		{
			toRet.setOid(rs.getLong("id"));
			toRet.setCodiceRaggruppamento(rs.getInt("cod_raggruppamento"));
			toRet.setOidSezione(rs.getLong("id_sezione"));
			toRet.setAnno(rs.getInt("anno"));
			toRet.setDescrizione(rs.getString("descrizione"));
			toRet.setOrdine(rs.getInt("ordinamento"));
			toRet.setScadenza(rs.getTimestamp("data_scadenza"));
			toRet.setCodiceEsame(rs.getString("codice_esame"));
//			toRet.setCodiceAlias(rs.getString("codice_alias"));
			toRet.setTipoAttivita(rs.getString("tipo_attivita"));
			toRet.setCodiceInternoPiano(rs.getInt("codice_interno_piano"));
			toRet.setCodiceInternoAttivita(rs.getInt("codice_interno_attivita"));
			toRet.setAliasPiano(rs.getString("alias_piano"));
			toRet.setAliasAttivita(rs.getString("alias_attivita"));
			toRet.setCodiceAliasAttivita(rs.getString("codice_alias_attivita"));
			toRet.setStato(rs.getInt("stato"));
			
			String query = null;
			
				query = "select * from dpat_indicatore_new where stato != 1 and id_piano_attivita = ? "+(nonscaduti ? " and data_scadenza is null": "")+" order by ordinamento ";
			
			
			pst = conn.prepareStatement(query);
			pst.setInt(1, toRet.getOid().intValue());
			
			rs1 = pst.executeQuery();
			
			if(withChilds)
				toRet.setIndicatoriFigli(new DpatIndicatoreNewBean().buildList(conn,rs1));
			
			/*per la descrizione del path dagli antenati ad esso */
			DpatSezioneNewBean sezioneMadre = new DpatSezioneNewBean().buildByOid(conn, rs.getInt("id_sezione"), false,false);
			String descrSezMadre = sezioneMadre.getDescrizione();
			toRet.setDescrSezMadre(descrSezMadre);
			
		}
		catch(Exception ex){
			ex.printStackTrace();
			throw ex;
		}
		finally
		{
			try{pst.close();}catch(Exception ex){}
			try{rs1.close();}catch(Exception ex){}
		}
		
		
		return toRet;
	}
	
	
	
	
	
	
	
	
	
	public  Integer insertBeforeOrAfter(Connection db, DpatPianoAttivitaNewBeanInterface<DpatIndicatoreNewBean> toInsert, DpatPianoAttivitaNewBeanInterface<DpatIndicatoreNewBean> pianoAttivitaRiferimento, String where) throws Exception
	{
		
		
		boolean autocommit = false;
		String queryInsert0 = null, queryInsert1 = null;
		Integer oidNuovoAggiunto = null;
		
			queryInsert0 = "insert into dpat_piano_attivita_new(id_sezione,anno,descrizione,ordinamento,data_scadenza,stato,codice_esame,alias_attivita,tipo_attivita,alias_piano,codice_interno_attivita,codice_interno_piano,codice_alias_attivita)"
			 		+ " values(?,?,?,?,NULL,?,?,?,?,?,?,?,?) returning id";
			
			/*insert usando codice raggruppamento dal vecchio bean (es inserimento per modifica / spostamento)*/
			queryInsert1 = "insert into dpat_piano_attivita_new(cod_raggruppamento,id_sezione,anno,descrizione,ordinamento,data_scadenza,stato,codice_esame,alias_attivita,tipo_attivita,alias_piano,codice_interno_attivita,codice_interno_piano,codice_alias_attivita)"
					+ " values(?,?,?,?,?,NULL,?,?,?,?,?,?,?,?) returning id";
		
		/*insert generando nuovo codice raggruppamento */
		 
		
		 /*alcuni campi vengono da maschera (o dal bean vecchio) e in entrambi i casi sono settati in toInsert
		  * altri dal bean di riferimento e stanno quindi in pianoAttivitaRiferimento
		  */
		
		/*quelli che vengono dal bean di riferimento ************************************************************************
		 * 
		 */
		 Integer idSezione = Integer.parseInt(pianoAttivitaRiferimento.getOidSezione()+"");
		 Integer anno = pianoAttivitaRiferimento.getAnno();
		 int ordinamento = 0;
		 int u = 0;
		 /*quelli che vengono dal bean vecchio/maschera **********************************************************************
		  * 
		  */
		 
		 String descrizione = toInsert.getDescrizione();
		 String codice_esame = toInsert.getCodiceEsame();
		 String tipoAttivita = toInsert.getTipoAttivita();
		 String aliasAttivita = toInsert.getAliasAttivita();
		 String aliasPiano = toInsert.getAliasPiano();
		 
		 Integer codiceInternoAttivita = toInsert.getCodiceInternoAttivita();
		 Integer codiceInternoPiano = toInsert.getCodiceInternoPiano();
		 String codiceAliasAttivita = toInsert.getCodiceAliasAttivita();
		
		 /*il codice di raggruppamento viene dal bean vecchio (se e' un inserimento per spostamento o modifica) mentre se e' un inserimento ex novo va generato 
		  * nel secondo caso non lo troviamo in toInsert
		  * */
		 Integer codRaggruppamento = toInsert.getCodiceRaggruppamento();
		 
		 PreparedStatement pst = null;
		 ResultSet rs = null;
		 
		 try
		 {
			 autocommit = db.getAutoCommit();
			 db.setAutoCommit(false);
			 
			 int stato = new DpatWrapperSezioniBean().getStatoDopoModifica(db,anno);
			 
			 /*per l'ordinamento*/
			 if(where.toLowerCase().equals("up"))
			 {
				 ordinamento = pianoAttivitaRiferimento.getOrdine();
				
				 
			 }
			 else /*down*/
			 {
				 ordinamento = pianoAttivitaRiferimento.getOrdine()+1;
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
			 new DpatPianoAttivitaNewBean().incrementaOrdiniPerSezione (db,"ordinamento >= "+ordinamento, idSezione,anno);
			 
			 Dpat.setNullableField(pst, idSezione, ++u, java.sql.Types.INTEGER);
			 Dpat.setNullableField(pst, anno, ++u, java.sql.Types.INTEGER);
			 Dpat.setNullableField(pst, descrizione, ++u, java.sql.Types.VARCHAR);
			 Dpat.setNullableField(pst, ordinamento, ++u, java.sql.Types.INTEGER);
			 Dpat.setNullableField(pst, stato, ++u, java.sql.Types.INTEGER);
			 Dpat.setNullableField(pst, codice_esame, ++u, java.sql.Types.VARCHAR);
			 Dpat.setNullableField(pst, aliasAttivita, ++u, java.sql.Types.VARCHAR);
			 Dpat.setNullableField(pst, tipoAttivita, ++u, java.sql.Types.VARCHAR);
			 Dpat.setNullableField(pst, aliasPiano, ++u, java.sql.Types.VARCHAR);
			 Dpat.setNullableField(pst, codiceInternoAttivita, ++u, java.sql.Types.INTEGER);
			 Dpat.setNullableField(pst, codiceInternoPiano, ++u, java.sql.Types.INTEGER);
			 Dpat.setNullableField(pst, codiceAliasAttivita, ++u, java.sql.Types.VARCHAR);
			 
			 
			 pst.execute();
			 rs = pst.getResultSet();
			 rs.next();
			 oidNuovoAggiunto = rs.getInt(1);
			 pst.close();
			 
			 /*
			  * NB: nel caso di operazione per piano attivita, 
			  * se si tratta di inserimento reale ex novo, allora devo inserire l'indicatore figlio di default
			  * nel caso in cui si tratti invece di inserimento dovuto alla duplicazione, poiche' c'e' stata modifica sul vecchio
			  * oppure di spostamento, va comunque inserito un indicatore fittizio nuovo nel nuovo nodo creato, in quanto questo verra' utilizzato per simulare
			  * gli inserimenti dei figli che il nodo vecchio si porta dietro verso il nuovo
			  */
			 Integer oidFisicoDummy = new DpatIndicatoreNewBean().insertDummyChildPerUltimoPianoAttivitaInserito(db, anno);
			 DpatIndicatoreNewBean dummyInserito = new DpatIndicatoreNewBean().buildByOid(db, oidFisicoDummy, true); /*ottengo il dummy inserito */
			 /*ora nel caso in cui sia inserimento non ex novo, ma dovuto a duplicazione (dovuta a modifica del vecchio / spostamento del vecchio) devo trasferire anche tutti
			  * i figli del nodo vecchio non gia' scaduti
			  */
			 if(toInsert.getCodiceRaggruppamento() != null
					 && toInsert.getIndicatoriFigli() != null && toInsert.getIndicatoriFigli().size() > 0) /*cioe' se non e' inserimento ex novo */
			 {
				 /*la logica e' : gli inserimenti sono verso un fratello. Di volta in volta il fratello e' l'ultimo figlio (non scaduto) che e' stato trasferito (la versione
				  * trasferita, quindi la nuova non la vecchia).
				  *  Continua fino a quando esistono figli da trasferire. Il primo riferimento e' il dummy.
				  */
				 DpatIndicatoreNewBean riferimento = dummyInserito;
				 int indiceSuFigli = 0;
				 do
				 {
					 DpatIndicatoreNewBean figlioDaTrasferire = (DpatIndicatoreNewBean) toInsert.getIndicatoriFigli().get(indiceSuFigli++);
					 if(figlioDaTrasferire.getScadenza() != null) /*gia' scaduto quindi non da trasferire */
						 continue;
					 
					 /*inserisco dopo*/
					 Integer idFisicoFiglioTrasferito = new DpatIndicatoreNewBean().insertBeforeOrAfter(db, figlioDaTrasferire, riferimento, "down");
					 
					 Integer competenzeSpostate = figlioDaTrasferire.spostaCompetenzeFromTo(figlioDaTrasferire.getOid(), idFisicoFiglioTrasferito.longValue(),db);
					 System.out.println(">>>>>>DPAT NUOVA GESTIONE: SONO STATE SPOSTATE "+competenzeSpostate+" COMPETENZE (MODELLO 5)");
						
					 
					 /*ora il nuovo figlio verso cui inserire sara' quello appena trasferito */
					 riferimento = new DpatIndicatoreNewBean().buildByOid(db, idFisicoFiglioTrasferito, true);
				 }
				 while(indiceSuFigli < toInsert.getIndicatoriFigli().size());
				 
				 /*ora cancello quello fittizio inserito, visto che siamo nel caso in cui si tratta di inserimento NON ex novo (nel caso di inserimento ex novo di piano attivita, quello fittizio
				  * viene cancellato solo quando viene inserito un reale indicatore figlio del piano attivita 
				  * 
				  */
				 new DpatIndicatoreNewBean().deleteDummyBrother(db, riferimento ); /*uso ultimo riferimento */
				 
			 }
			 
			 db.commit();
			 return oidNuovoAggiunto;
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
			 try{rs.close();} catch(Exception ex){}
			 try{
				 db.setAutoCommit(autocommit);
			 } catch(Exception ex){ex.printStackTrace();}
		 }
	}
	
	
	
	
	
	public void incrementaOrdiniPerSezione(Connection conn, String condition, Integer oidSezione, Integer anno)
	{
		PreparedStatement pst = null;
		String query = "update dpat_piano_attivita_new set ordinamento = ordinamento+1 where "+condition+" and id_sezione = ? and anno = ? and stato != 1";
		try
		{
			pst = conn.prepareStatement(query);
			pst.setInt(1, oidSezione);
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
	
	public  void disabilitaByOid(Connection conn, int id,int anno) throws Exception {
		PreparedStatement pst = null;
		ResultSet rs = null;
		try
		{
			
				pst = conn.prepareStatement("update dpat_piano_attivita_new set data_scadenza = CURRENT_TIMESTAMP , stato = ? where id = ? and stato != 1 returning data_scadenza ");
				pst.setInt(2, id);
				int newstato = new DpatWrapperSezioniBean().getStatoDopoModifica(conn, anno);
				pst.setInt(1, newstato);
				pst.execute();
				rs = pst.getResultSet();
				rs.next();
				
			
			
			
			
			/*disattivo tutti i figli non gia' disattivati*/
			DpatPianoAttivitaNewBean bean =new  DpatPianoAttivitaNewBean().buildByOid(conn, id,false,true);
			if(bean.getIndicatoriFigli() != null && bean.getIndicatoriFigli().size() > 0)
			{
				for(DpatIndicatoreNewBeanAbstract figlio : bean.getIndicatoriFigli())
				{
					if(figlio.getScadenza() == null)
					{
						 
							new DpatIndicatoreNewBean().disabilitaByOid(conn, figlio.getOid().intValue(),anno,rs.getTimestamp("data_scadenza"));
						 
						
					}
				}
			}
			
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
	/*dato oid piano attivita ritorna il dpatindicatore figlio con l'ordine massimo */
	public DpatPianoAttivitaNewBean searchLastChildOf(Connection db, Integer oidSezione,boolean nonscaduti) throws Exception {
		
		PreparedStatement pst = null;
		ResultSet rs = null;
		String query =  "select * from dpat_piano_attivita_new where stato != 1 and id_sezione = ? "+(nonscaduti ? " and data_scadenza is null ": " ")+" order by ordinamento desc";
		try
		{
			pst = db.prepareStatement(query);
			pst.setInt(1, oidSezione);
			
			rs = pst.executeQuery();
			rs.next();
			DpatPianoAttivitaNewBean toRet = new DpatPianoAttivitaNewBean().build(db, rs,nonscaduti,true);
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
	
	
	
	
public Integer update(DpatPianoAttivitaNewBeanInterface<DpatIndicatoreNewBean> newValue ,DpatPianoAttivitaNewBeanInterface<DpatIndicatoreNewBean> oldAttivita, Connection db) throws Exception {
		
		PreparedStatement pst = null;
		Integer oidInserito = null;
		 
		
		try
		{
			
			
		    int newstato = new DpatWrapperSezioniBean().getStatoDopoModifica(db, newValue.getAnno());
		    newValue.setStato(newstato);
			
			/*faccio inserimento di quello "nuovo" (cioe' la versione modificata) dopo quello vecchio (cioe' quello modificato)*/
			 oidInserito = insertBeforeOrAfter(db, newValue, oldAttivita, "down");
			
			/*disabilito quello che sto aggiornando, e questo fara' propagare la data disattivazione su tutti i figli non gia' scaduti */
			 disabilitaByOid(db, oldAttivita.getOid().intValue(), newValue.getAnno());
			 System.out.println(">>>>>>DPAT NUOVA GESTIONE: L'UPDATE HA FATTO SI CHE VENISSE CREATA UNA NUOVA VERSIONE E VENISSE DISABILITATA LA VECCHIA CON OID FISICO "+oldAttivita.getOid().intValue()); 
			
			 return oidInserito;
			
			 
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			throw ex;
		}
		 
		
	}




@Override
public int aggiornaCodiceAliasAttivitaPerTutteVersioni(Connection db, DpatPianoAttivitaNewBeanInterface bean)
		throws Exception {
	
	

	PreparedStatement pst = null;
	try
	{
		String nuovoCodiceAliasAttivita = bean.getCodiceAliasAttivita();
		Integer codRaggruppamento = bean.getCodiceRaggruppamento();
		pst = db.prepareStatement("update dpat_piano_attivita_new set codice_alias_attivita = ? where cod_raggruppamento = ? and stato != 1 ");
		pst.setInt(2, codRaggruppamento);
		pst.setString(1, nuovoCodiceAliasAttivita);
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
