package org.aspcfs.modules.controller.base;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import org.aspcfs.utils.web.LookupList;


public class TreeDAOImpl implements TreeDAO {




	/**
	 * CREA LA TABELLA CHE MAPPA L'ALBERO
	 * INSERISCE I NODI DI PRIMO LIVELLO DELL'ALBERO NELLA TABELLA CREATA 
	 * @param db
	 * @param nomeTabella 	--> nome della tabella che mappa l'albero
	 * @param tabella  		--> tabella di primo livello dalla quale partire
	 */

	public void createTree(Connection db,String nomeTabella,String tabella,String descrizione)throws SQLException  {

			String sqlCreateTable = "CREATE TABLE "+nomeTabella+
			"("+
			"id serial NOT NULL,"+
			"idNodo integer,"+
			"descrizione text,"+
			"livello integer,"+
			"idPadre integer , "+
			"tabella text ,"+
			"CONSTRAINT "+nomeTabella+"_pkey PRIMARY KEY (id ) "+
			")";

		try
		{
			db.setAutoCommit(false);
			
			db.prepareStatement("insert into tree_list (nome_tabella,descrizione) values ('"+nomeTabella+"','"+descrizione+"')").execute();
			/**
			 * CREAZIONE DELLA TABELLA DI MAPPATURA DELL'ALBERO
			 */
			db.prepareStatement(sqlCreateTable).execute();

			/**
			 * INFASAMENTO DELLA TABELLA CON I NODI DI PRIMO LIVELLO
			 */

			db.prepareStatement("INSERT INTO "+nomeTabella+"(idNodo,descrizione,livello,idPadre,tabella)  (select code,description,1,-1,'"+tabella+"' from "+tabella+" where enabled=true )").execute();

			db.commit() ;
			db.setAutoCommit(true);
		}
		catch(SQLException e)
		{
			try 
			{
				db.rollback();
			} 
			catch (SQLException e1) 
			{
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			throw e;
		}


	}


	/**
	 * LISTA DELLE COMBO LETTE DAL DATABASE
	 */
	public ArrayList<String> readLookup(Connection db) {
		ArrayList<String>  listaTabelle = new ArrayList<String>();
		try
		{
			ResultSet tableNames = db.getMetaData().getTables(null,null, null, null);
			while (tableNames.next()) {
				String nome_tab = tableNames.getString("TABLE_NAME");
				if(nome_tab.startsWith("lookup") && ! nome_tab.contains("key")&& ! nome_tab.contains("seq"))
				{
					listaTabelle.add(nome_tab);
				}

			}
		}
		catch(SQLException e){
			e.printStackTrace() ;
		}
		return listaTabelle;
		
	}
	
	public String aggiungiLivello(Connection db,String nomeTabella,int idPadre,int livello)
	{
		String tab = "" ;
		try 
		{
			ResultSet rs = db.prepareStatement("select distinct tabella from "+nomeTabella+" where livello = "+livello).executeQuery();
			if(rs.next())
			{
				tab = rs.getString(1) ; 
			}
		} catch (SQLException e) 
		{
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return tab ;
		
	}

	
	
	
	public Tree dettaglioTreePiani(int idPiano,String tabellaassociazionepiani,String colonnatabellaassociazionepiani,String nomeTabella ,String idColonna,String padreColonna,String descrzioneColonna,String livello ,String nodo,String campoEnabled,String colonnaSelezione, Connection db)
	{
		Tree tree = new Tree();
		ArrayList<Nodo> listaNodi = Nodo.loadNodiAssociazioni(idPiano,tabellaassociazionepiani,colonnatabellaassociazionepiani,nomeTabella,idColonna,padreColonna,descrzioneColonna,livello ,nodo,campoEnabled,colonnaSelezione ,db);
		tree.setListaNodi(listaNodi);
		tree.setNomeTabella(nomeTabella);
		return tree ;
	}
	public Tree dettaglioTree(String nomeTabella ,String idColonna,String padreColonna,String descrzioneColonna,String livello ,String nodo,String campoEnabled,String colonnaSelezione, Connection db)
	{
		Tree tree = new Tree();
		
		ArrayList<Nodo> listaNodi = Nodo.loadNodiPrimoLivello(nomeTabella,idColonna,padreColonna,descrzioneColonna,livello ,nodo,campoEnabled,colonnaSelezione ,db);
		tree.setListaNodi(listaNodi);
		tree.setNomeTabella(nomeTabella);
		return tree ;
	}
	
	
	
	
	
	public ArrayList<Nodo> listaNodi(String nomeTabella ,String campoEnabled, Connection db)
	{
		
		ArrayList<Nodo> listaNodi = Nodo.listaNodi(nomeTabella, campoEnabled, db);
		
		return listaNodi ;
	}
	
	
	public ArrayList<Tree> list(Connection db) throws SQLException
	{
		ArrayList<Tree> lista = new ArrayList<Tree>();
		String sel = "select * from tree_list" ;
		java.sql.PreparedStatement pst = db.prepareStatement(sel) ;
		ResultSet rs = pst.executeQuery() ;
		while (rs.next())
		{
			int id = rs.getInt(1);
			String nome = rs.getString("nome_tabella");
			String descrizione = rs.getString("descrizione");
			Tree tree = new Tree();
			tree.setNomeTabella(nome) ;
			tree.setDescrizione(descrizione);
			lista.add(tree) ;
			
		}
		return lista ;
	}

	public void salvaLivello(Connection db,String nomeAlbero,String combo , int idPadre,int livello,String[] valori) throws SQLException
	{
		
		java.sql.PreparedStatement pst = db.prepareStatement("INSERT INTO "+nomeAlbero+"(idNodo,descrizione,livello,idPadre,tabella) values (?,?,?,?,?)");
		LookupList comboList = new LookupList(db,combo);
		
		if(valori!=null && valori.length>0)
		for(String val : valori)
		{
			int value = Integer.parseInt(val);
			pst.setInt(1, value);
			pst.setString(2, comboList.getValueFromId(value));
			pst.setInt(3, livello);
			pst.setInt(4,idPadre) ;
			pst.setString(5, combo) ;
			pst.execute() ;
			
			
		}
		
		
	}





}
