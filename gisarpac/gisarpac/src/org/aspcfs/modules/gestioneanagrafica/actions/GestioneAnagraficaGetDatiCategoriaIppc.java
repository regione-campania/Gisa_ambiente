package org.aspcfs.modules.gestioneanagrafica.actions;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.utils.GestoreConnessioni;
import org.directwebremoting.extend.LoginRequiredException;

import com.darkhorseventures.framework.actions.ActionContext;

public class GestioneAnagraficaGetDatiCategoriaIppc extends CFSModule{
	
	public String executeCommandSearch(ActionContext context) throws IOException{
		
		String output = "[]";
		String tipo_richiesta = context.getRequest().getParameter("tiporichiesta");
		System.out.println("query recupero richiesta " + tipo_richiesta);
		boolean attivita_fissa = true;
		
		try{
			if(context.getRequest().getParameter("tipoattivita").equalsIgnoreCase("1")){
				attivita_fissa = true;
			}else{
				attivita_fissa = false;
			}
		} catch (Exception e){};
		
		if (tipo_richiesta.equalsIgnoreCase("categoria")){
			output = getCategoria(attivita_fissa);
		} else if (tipo_richiesta.equalsIgnoreCase("ippc")){
			output = getCodiceIppc(context,attivita_fissa);
		} else if (tipo_richiesta.equalsIgnoreCase("descrizione")){
			output = getDescrizione(context,attivita_fissa);
		} else if (tipo_richiesta.equalsIgnoreCase("datidescrizione")){
			output = getDatiLinea(context);
		}
		
		PrintWriter writer = context.getResponse().getWriter();
		writer.print(output);
		writer.close();
		return "";		
	
	}
	
	public String getCategoria(boolean attivita_fissa) throws IOException{
		
		String output = "[]";
		String sql = "";
		if (attivita_fissa){
			sql = "select concat('[', string_agg(row_to_json(tab)::text, ','), ']')::json as lista_categoria from("
					+ "select distinct mlm.id::text as code, "
					//+ "concat(mlm.categoria, ' (', mlm.norma, ')')::text as description "
					+ "mlm.categoria::text as description "
					+ "from codici_categoria mlm "
					+ "join codici_ippc mla on mlm.id = mla.id_codici_categoria "
					+ "join codici_descrizione mlla on mla.id = mlla.id_codici_ippc "
					+ "order by description "
					+ ") tab";
		} else {
			sql = "select concat('[', string_agg(row_to_json(tab)::text, ','), ']')::json as lista_categoria from("
					+ "select distinct mlm.id::text as code, "
					//+ "concat(mlm.categoria, ' (', mlm.norma, ')')::text as description "
					+ "mlm.categoria::text as description "
					+ "from codici_categoria mlm "
					+ "join codici_ippc mla on mlm.id = mla.id_codici_categoria "
					+ "join codici_descrizione mlla on mla.id = mlla.id_codici_ippc "
					+ ") tab";
		}
		
		Connection db = null;
		try{
			db = GestoreConnessioni.getConnection();
			PreparedStatement pst = db.prepareStatement(sql);
			ResultSet rs= pst.executeQuery();
			
			System.out.println("query recupero categoria " + pst);
			while(rs.next())
			{
				output = rs.getString("lista_categoria");		 
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
	
	public String getCodiceIppc(ActionContext context, boolean attivita_fissa) throws IOException{
		
		String output = "[]";
		int id_categoria = Integer.parseInt(context.getRequest().getParameter("idcategoria"));
		System.out.println("query recupero agg " + id_categoria);
		
		String sql = "";
		if(attivita_fissa){
			sql = "select concat('[', string_agg(row_to_json(tab)::text, ','), ']')::json as lista_codici_ippc from("
					+ "select "
					+ "distinct mla.id::text as code,"
					+ "mla.codice::text as description "
					+ "from codici_ippc mla "
					+ "where mla.id_codici_categoria = ? order by description "
					+ ") tab";
		} else {
			sql = "select concat('[', string_agg(row_to_json(tab)::text, ','), ']')::json as lista_codici_ippc from("
					+ "select "
					+ "distinct mla.id::text as code,"
					+ "mla.codice::text as description "
					+ "from codici_ippc mla "
					+ "join codici_descrizione mlla on mla.id = mlla.id_codici_ippc "
					+ "where mla.id_codici_categoria = ? order by description "
					+ ") tab";
		}
		

		Connection db = null;
		try{
			db = GestoreConnessioni.getConnection();
			PreparedStatement pst = db.prepareStatement(sql);
			pst.setInt(1, id_categoria);
			ResultSet rs= pst.executeQuery();
			
			System.out.println("query recupero lista_codici_ippc " + pst);
			while(rs.next())
			{
				output = rs.getString("lista_codici_ippc");		 
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
	
	public String getDescrizione(ActionContext context, boolean attivita_fissa) throws IOException{
		
		String output = "[]";
		int id_ippc = Integer.parseInt(context.getRequest().getParameter("idippc"));
		System.out.println("query recupero agg " + id_ippc);
		
		String sql = "";
		if (attivita_fissa) {
			sql = "select concat('[', string_agg(row_to_json(tab)::text, ','), ']')::json as lista_attivita from( "
					+ "select "
					+ "distinct mlla.id::text as code, "
					+ "mlla.descrizione::text as description "
					+ "from codici_descrizione mlla "
					+ "where mlla.id_codici_ippc  = ? "
					+ "order by description "
					+ ") tab";
		} else {
			sql = "select concat('[', string_agg(row_to_json(tab)::text, ','), ']')::json as lista_attivita from( "
					+ "select "
					+ "distinct mlla.id::text as code, "
					+ "mlla.descrizione::text as description "
					+ "from codici_descrizione mlla "
					+ "where mlla.id_codici_ippc  = ? " 
					+ "order by description "
					+ ") tab";
		}
		
		Connection db = null;
		try{
			db = GestoreConnessioni.getConnection();
			PreparedStatement pst = db.prepareStatement(sql);
			pst.setInt(1, id_ippc);
			ResultSet rs= pst.executeQuery();
			
			System.out.println("query recupero attivita " + pst);
			while(rs.next())
			{
				output = rs.getString("lista_attivita");		 
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
	
public String getDatiLinea(ActionContext context) throws IOException{
		
		String output = "[]";
		int id_linea_attivita = Integer.parseInt(context.getRequest().getParameter("iddescrizione"));
		System.out.println("query recupero linea di attivita completa " + id_linea_attivita);
		String sql = "select (concat('[', string_agg(row_to_json(tab)::text, ','), ']')::json)::text as dati_descrizione from("
				+ "select id_codici_descrizione::text as id, "
				+ "id_codici_descrizione::text as codice, "
				+ "categoria::text as categoria, "
				+ "codice::text as ippc, "
				+ "descrizione::text as attivita "
				+ "from codici_categoria_ippc where id_codici_descrizione = ? ) tab";

		Connection db = null;
		try{
			db = GestoreConnessioni.getConnection();
			PreparedStatement pst = db.prepareStatement(sql);
			pst.setInt(1, id_linea_attivita);
			ResultSet rs= pst.executeQuery();
			
			System.out.println("query recupero dati linea di attivita completa " + pst);
			while(rs.next())
			{
				output = rs.getString("dati_descrizione");		 
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
		System.out.println("dati linea di attivita completa log " + output);
		return output;
	}
}
