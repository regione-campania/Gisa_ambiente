package org.aspcfs.utils;

import java.util.Hashtable;

public class CsvLunghezzaFissa
{

	public static class Colonna
	{
		private int		lunghezza		= -1;
		private int		indiceIniziale	= -1;
		private String	nome			= null;
		
		public Colonna(int lunghezza, String nome)
		{
			this.lunghezza	= lunghezza;
			this.nome		= nome;
		}
		
		public int getLunghezza() {
			return lunghezza;
		}
		public int getIndiceFinale() {
			return lunghezza + indiceIniziale - 1;
		}
		public void setLunghezza(int lunghezza) {
			this.lunghezza = lunghezza;
		}
		public String getNome() {
			return nome;
		}
		public int getIndiceIniziale() {
			return indiceIniziale;
		}

		public void setIndiceIniziale(int indiceIniziale) {
			this.indiceIniziale = indiceIniziale;
		}

		public void setNome(String nome) {
			this.nome = nome;
		}
	}
	
	
	private Hashtable<String, Colonna>	ht		= null;
	private String						riga	= null;
	
	public CsvLunghezzaFissa( Colonna[] colonne )
	{
		ht				= new Hashtable<String, Colonna>();
		
		int index = 0;
		for( Colonna c: colonne )
		{
			c.setIndiceIniziale( index );
			ht.put( c.getNome(), c );
			index += c.getLunghezza();
		}
	}
	
	public void setRiga( String riga )
	{
		this.riga = riga;
	}
	
	public String get( String colonna )
	{
		String ret = null;
		
		Colonna c = ht.get( colonna );
		
		if( (c != null) && (riga != null) && ( riga.length() > c.getIndiceFinale() ) )
		{
			ret = riga.substring( c.getIndiceIniziale(), c.getIndiceFinale() + 1 );
		}
		
		return ret;
	}

}
