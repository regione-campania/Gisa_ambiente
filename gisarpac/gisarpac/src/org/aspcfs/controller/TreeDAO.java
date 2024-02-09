package org.aspcfs.controller;

	import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;

	public interface TreeDAO {
		
		public void createTree(Connection db,String nomeTabella,String tabella,String descrizione) throws SQLException;
		public ArrayList<String> readLookup(Connection db) ;
		public Tree dettaglioTree(String nomeTabella ,String idColonna,String padreColonna,String descrzioneColonna,String livello ,String nodo,String campoEnabled,String colonnaSelezione, Connection db) ;
		public String aggiungiLivello(Connection db,String nomeTabella,int idPadre,int livello);
		public ArrayList<Tree> list(Connection db) throws SQLException ;
		public void salvaLivello(Connection db,String nomeAlbero,String combo , int idPadre,int livello,String[] valori) throws SQLException;

	}