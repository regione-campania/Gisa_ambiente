package org.aspcfs.utils;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.directwebremoting.extend.LoginRequiredException;

public class DWRnoscia {

	public String controlloEsistenzaImpresa(String partita_iva){
			
			String output = "[]";
			
			String sql = "select verifica_esistenza_impresa_noscia::text from verifica_esistenza_impresa_noscia(?)";
			Connection db = null;
			try{
				db = GestoreConnessioni.getConnection();
				PreparedStatement pst = db.prepareStatement(sql);
				pst.setString(1, partita_iva);
				ResultSet rs= pst.executeQuery();
				
				System.out.println("query esistenza " + pst);
				while(rs.next())
				{
					output = rs.getString("verifica_esistenza_impresa_noscia");
				}
			
			}catch(LoginRequiredException e)
			{
				throw e;
			}catch(Exception e)
			{
				e.printStackTrace();		
			}
			finally
			{
				GestoreConnessioni.freeConnection(db);
			}
			
			return output;
			
	}
	
	public String cercaStabilimentoPraticaSuap(String partita_iva, String comune, String cod_pratica_in){
		
		String output = "[]";
		String sql = "select cerca_stabilimento_pratica_suap::text from cerca_stabilimento_pratica_suap(?,?,?)";
		Connection db = null;
		try{
			db = GestoreConnessioni.getConnection();
			PreparedStatement pst = db.prepareStatement(sql);
			pst.setString(1, partita_iva);
			pst.setInt(2, Integer.parseInt(comune));
			pst.setInt(3, Integer.parseInt(cod_pratica_in));
			ResultSet rs= pst.executeQuery();
			
			System.out.println("query cerca stabilimento " + pst);
			while(rs.next())
			{
				output = rs.getString("cerca_stabilimento_pratica_suap");
			}
		
		}catch(LoginRequiredException e)
		{
			throw e;
		}catch(Exception e)
		{
			e.printStackTrace();		
		}
		finally
		{
			GestoreConnessioni.freeConnection(db);
		}
		
		return output;
		
}
	
	public String recuperoStabdaImpresa(String id_impresa){
		
			String output = "[]";
			
			String sql = "select recupera_stabilimenti_daimpresa_noscia::text from recupera_stabilimenti_daimpresa_noscia(?)";
			Connection db = null;
			try{
				db = GestoreConnessioni.getConnection();
				PreparedStatement pst = db.prepareStatement(sql);
				pst.setString(1, id_impresa);
				ResultSet rs= pst.executeQuery();
				
				System.out.println("query esistenza " + pst);
				while(rs.next())
				{
					output = rs.getString("recupera_stabilimenti_daimpresa_noscia");
				}
				//System.out.println(" output query esistenza" + output);
			
			}catch(LoginRequiredException e)
			{
				throw e;
			}catch(Exception e)
			{
				e.printStackTrace();		
			}
			finally
			{
				GestoreConnessioni.freeConnection(db);
			}
			
			return output;
		}
	
	public String controlloEsistenzaNumeroPratica(String numero_pratica, String comune_pratica, String id_causale){
		
			String output = "";
			
			String sql = "select verifica_esistenza_pratica_suap from verifica_esistenza_pratica_suap(?,?,?)";
			Connection db = null;
			try{
				db = GestoreConnessioni.getConnection();
				PreparedStatement pst = db.prepareStatement(sql);
				pst.setString(1, numero_pratica);
				pst.setInt(2, Integer.parseInt(comune_pratica));
				pst.setInt(3, Integer.parseInt(id_causale));
				ResultSet rs= pst.executeQuery();
				
				System.out.println("query esistenza " + pst);
				while(rs.next())
				{
					output = rs.getString("verifica_esistenza_pratica_suap");
				}
			
			}catch(LoginRequiredException e)
			{
				throw e;
			}catch(Exception e)
			{
				e.printStackTrace();		
			}
			finally
			{
				GestoreConnessioni.freeConnection(db);
			}
			
			return output;
		
		}
	
public String controlloEsistenzaAiaImpresa(String partita_iva){
		
		String output = "[]";
		
		String sql = "select * from verifica_esistenza_impresa(?)";
		Connection db = null;
		try{
			db = GestoreConnessioni.getConnection();
			PreparedStatement pst = db.prepareStatement(sql);
			pst.setString(1, partita_iva);
			ResultSet rs= pst.executeQuery();
			
			System.out.println("query esistenza " + pst);
			while(rs.next())
			{
				output = rs.getString("verifica_esistenza_impresa");
			}
		
		}catch(LoginRequiredException e)
		{
			throw e;
		}catch(Exception e)
		{
			e.printStackTrace();		
		}
		finally
		{
			GestoreConnessioni.freeConnection(db);
		}
		
		return output;
		
}


public String controlloEsistenzaAuaCiureg(String ciureg){
	
	String output = "";
	
	String sql = "select ciureg from aua_stabilimento where ciureg ilike ? and trashed_date is null";
	Connection db = null;
	try{
		db = GestoreConnessioni.getConnection();
		PreparedStatement pst = db.prepareStatement(sql);
		pst.setString(1, ciureg);
		ResultSet rs= pst.executeQuery();
		
		System.out.println("query esistenza " + pst);
		while(rs.next())
		{
			output = rs.getString("ciureg");
		}
	
	}catch(LoginRequiredException e)
	{
		throw e;
	}catch(Exception e)
	{
		e.printStackTrace();		
	}
	finally
	{
		GestoreConnessioni.freeConnection(db);
	}
	
	return output;
	
}


	public String cercaPraticaDaAssociare(String comune_pratica, String stab_id){
		
		String output = "";
		
		String sql = "select recupero_pratiche_suap from recupero_pratiche_suap(?,?)";
		Connection db = null;
		try{
			db = GestoreConnessioni.getConnection();
			PreparedStatement pst = db.prepareStatement(sql);
			pst.setInt(1, Integer.parseInt(comune_pratica));
			pst.setInt(2, Integer.parseInt(stab_id));
			ResultSet rs= pst.executeQuery();
			
			System.out.println("query esistenza " + pst);
			while(rs.next())
			{
				output = rs.getString("recupero_pratiche_suap");
			}
		
		}catch(LoginRequiredException e)
		{
			throw e;
		}catch(Exception e)
		{
			e.printStackTrace();		
		}
		finally
		{
			GestoreConnessioni.freeConnection(db);
		}
		
		return output;
	
	}
	
	public String associaPraticaSuap(String numero_pratica, String cod_comune, String stab_id, String id_utente){
		String output = "";
		
		String sql = "select associa_pratica_suap from associa_pratica_suap(?,?,?,?)";
		Connection db = null;
		try{
			db = GestoreConnessioni.getConnection();
			PreparedStatement pst = db.prepareStatement(sql);
			pst.setString(1, numero_pratica);
			pst.setInt(2, Integer.parseInt(cod_comune));
			pst.setInt(3, Integer.parseInt(stab_id));
			pst.setInt(4, Integer.parseInt(id_utente));
			ResultSet rs= pst.executeQuery();
			
			System.out.println("query associa pratica " + pst);
			while(rs.next())
			{
				output = rs.getString("associa_pratica_suap");
			}
		
		}catch(LoginRequiredException e)
		{
			throw e;
		}catch(Exception e)
		{
			e.printStackTrace();		
		}
		finally
		{
			GestoreConnessioni.freeConnection(db);
		}
		
		return output;
	}
}
