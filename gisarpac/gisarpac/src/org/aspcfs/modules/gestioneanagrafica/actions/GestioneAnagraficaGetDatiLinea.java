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

public class GestioneAnagraficaGetDatiLinea extends CFSModule{
	
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
		
		if (tipo_richiesta.equalsIgnoreCase("macroarea")){
			output = getMacroarea(attivita_fissa);
		} else if (tipo_richiesta.equalsIgnoreCase("aggregazione")){
			output = getAggregazione(context,attivita_fissa);
		} else if (tipo_richiesta.equalsIgnoreCase("lineaattivita")){
			output = getLineaAttivita(context,attivita_fissa);
		} else if (tipo_richiesta.equalsIgnoreCase("datilineaattivita")){
			output = getDatiLinea(context);
		}
		
		PrintWriter writer = context.getResponse().getWriter();
		writer.print(output);
		writer.close();
		return "";		
	
	}
	
	public String getMacroarea(boolean attivita_fissa) throws IOException{
		
		String output = "[]";
		String sql = "";
		if (attivita_fissa){
			sql = "select concat('[', string_agg(row_to_json(tab)::text, ','), ']')::json as lista_macroarea from("
					+ "select distinct mlm.id::text as code, "
					//+ "concat(mlm.macroarea, ' (', mlm.norma, ')')::text as description "
					+ "mlm.macroarea::text as description "
					+ "from master_list_macroarea mlm "
					+ "join master_list_aggregazione mla on mlm.id = mla.id_macroarea "
					+ "join master_list_linea_attivita mlla on mla.id = mlla.id_aggregazione "
					+ "join master_list_flag_linee_attivita fl on mlla.codice_univoco = fl.codice_univoco "
					+ "where fl.no_scia is false and fl.sintesis = false and fl.fisso = true "
					+ "order by description "
					+ ") tab";
		} else {
			sql = "select concat('[', string_agg(row_to_json(tab)::text, ','), ']')::json as lista_macroarea from("
					+ "select distinct mlm.id::text as code, "
					//+ "concat(mlm.macroarea, ' (', mlm.norma, ')')::text as description "
					+ "mlm.macroarea::text as description "
					+ "from master_list_macroarea mlm "
					+ "join master_list_aggregazione mla on mlm.id = mla.id_macroarea "
					+ "join master_list_linea_attivita mlla on mla.id = mlla.id_aggregazione "
					+ "join master_list_flag_linee_attivita fl on mlla.codice_univoco = fl.codice_univoco "
					+ "where fl.no_scia is false and fl.sintesis = false and fl.fisso = false "
					+ "order by description "
					+ ") tab";
		}
		
		Connection db = null;
		try{
			db = GestoreConnessioni.getConnection();
			PreparedStatement pst = db.prepareStatement(sql);
			ResultSet rs= pst.executeQuery();
			
			System.out.println("query recupero macroarea " + pst);
			while(rs.next())
			{
				output = rs.getString("lista_macroarea");		 
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
	
	public String getAggregazione(ActionContext context, boolean attivita_fissa) throws IOException{
		
		String output = "[]";
		int id_macroarea = Integer.parseInt(context.getRequest().getParameter("idmacroarea"));
		System.out.println("query recupero agg " + id_macroarea);
		
		String sql = "";
		if(attivita_fissa){
			sql = "select concat('[', string_agg(row_to_json(tab)::text, ','), ']')::json as lista_aggreagazione from("
					+ "select "
					+ "distinct mla.id::text as code,"
					+ "mla.aggregazione::text as description "
					+ "from master_list_aggregazione mla "
					+ "join master_list_linea_attivita mlla on mla.id = mlla.id_aggregazione "
					+ "join master_list_flag_linee_attivita fl on mlla.codice_univoco = fl.codice_univoco "
					+ "where mla.id_macroarea = ? and fl.no_scia is false and fl.sintesis = false and fl.fisso = true "
					+ "order by description "
					+ ") tab";
		} else {
			sql = "select concat('[', string_agg(row_to_json(tab)::text, ','), ']')::json as lista_aggreagazione from("
					+ "select "
					+ "distinct mla.id::text as code,"
					+ "mla.aggregazione::text as description "
					+ "from master_list_aggregazione mla "
					+ "join master_list_linea_attivita mlla on mla.id = mlla.id_aggregazione "
					+ "join master_list_flag_linee_attivita fl on mlla.codice_univoco = fl.codice_univoco "
					+ "where mla.id_macroarea = ? and fl.no_scia is false and fl.sintesis = false and fl.fisso = false "
					+ "order by description "
					+ ") tab";
		}
		

		Connection db = null;
		try{
			db = GestoreConnessioni.getConnection();
			PreparedStatement pst = db.prepareStatement(sql);
			pst.setInt(1, id_macroarea);
			ResultSet rs= pst.executeQuery();
			
			System.out.println("query recupero aggreagazione " + pst);
			while(rs.next())
			{
				output = rs.getString("lista_aggreagazione");		 
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
	
	public String getLineaAttivita(ActionContext context, boolean attivita_fissa) throws IOException{
		
		String output = "[]";
		int id_aggregazione = Integer.parseInt(context.getRequest().getParameter("idaggregazione"));
		System.out.println("query recupero agg " + id_aggregazione);
		
		String sql = "";
		if (attivita_fissa) {
			sql = "select concat('[', string_agg(row_to_json(tab)::text, ','), ']')::json as lista_attivita from( "
					+ "select "
					+ "distinct mlla.id::text as code, "
					+ "mlla.linea_attivita::text as description "
					+ "from master_list_linea_attivita mlla "
					+ "join master_list_flag_linee_attivita fl on mlla.codice_univoco = fl.codice_univoco "
					+ "where mlla.id_aggregazione  = ? and fl.no_scia is false and fl.sintesis = false and fl.fisso = true "
					+ "order by description "
					+ ") tab";
		} else {
			sql = "select concat('[', string_agg(row_to_json(tab)::text, ','), ']')::json as lista_attivita from( "
					+ "select "
					+ "distinct mlla.id::text as code, "
					+ "mlla.linea_attivita::text as description "
					+ "from master_list_linea_attivita mlla "
					+ "join master_list_flag_linee_attivita fl on mlla.codice_univoco = fl.codice_univoco "
					+ "where mlla.id_aggregazione  = ? and fl.no_scia is false and fl.sintesis = false and fl.fisso = false "
					+ "order by description "
					+ ") tab";
		}
		
		Connection db = null;
		try{
			db = GestoreConnessioni.getConnection();
			PreparedStatement pst = db.prepareStatement(sql);
			pst.setInt(1, id_aggregazione);
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
		int id_linea_attivita = Integer.parseInt(context.getRequest().getParameter("idlineaattivita"));
		System.out.println("query recupero linea di attivita completa " + id_linea_attivita);
		String sql = "select (concat('[', string_agg(row_to_json(tab)::text, ','), ']')::json)::text as dati_linea_attivita from("
				+ "select id_nuova_linea_attivita::text as id, "
				+ "codice::text as codice, "
				+ "macroarea::text as macroarea, "
				+ "aggregazione::text as aggregazione, "
				+ "attivita::text as attivita "
				+ "from ml8_linee_attivita_nuove_materializzata where id_nuova_linea_attivita = ? and enabled) tab";

		Connection db = null;
		try{
			db = GestoreConnessioni.getConnection();
			PreparedStatement pst = db.prepareStatement(sql);
			pst.setInt(1, id_linea_attivita);
			ResultSet rs= pst.executeQuery();
			
			System.out.println("query recupero dati linea di attivita completa " + pst);
			while(rs.next())
			{
				output = rs.getString("dati_linea_attivita");		 
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
