package org.servlet;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import org.aspcfs.utils.web.LookupList;

public class GestoreEventi {

	

	public static ArrayList getFieldsByPianoMonitoraggio(Connection db, int idPiano) throws SQLException{
		ArrayList fields = new ArrayList();
		StringBuffer sqlSelect = new StringBuffer();
		PreparedStatement pst = null;
		HashMap fields1 = new HashMap();
		String html = "";
		
		//String codice_interno = ControlliUfficialiUtil.getCodiceInternoPianoMonitoraggio(db, "lookup_piano_monitoraggio", idPiano).getCodiceInterno();
		//sqlSelect.append("SELECT * from cu_html_fields where codice_interno = ? order by ordine_campo");
		
	
		//pst = db.prepareStatement(
		 //       sqlSelect.toString());
		
		//pst.setString(1, codice_interno);
		
		System.out.println("[Query dati estesi]: "+pst.toString());
		ResultSet rs = pst.executeQuery();
		
	      while (rs.next()) {
	    	  
	    	  	//CONTROLLO SE E' UN CAMPO SOLO PER UNA PARTICOLARE SPECIE ANIMALE E SE TALE SPECIE COINCIDE CON QUELLA PER CUI HO CHIAMATO
				 fields1 = new HashMap();
				 html = "";
				 fields1.put("name", rs.getString("nome_campo"));
				 fields1.put("type", rs.getString("tipo_campo"));
				 fields1.put("label", rs.getString("label_campo"));
				 fields1.put("obbligatorio", rs.getBoolean("obbligatorio"));
				 fields1.put("controlli", rs.getString("tipo_controlli_date"));
				 fields1.put("label_data", rs.getString("label_campo_controlli_date"));
				 fields1.put("label_link", rs.getString("label_link"));
				 fields1.put("link_value", rs.getString("link_value"));
				 if (rs.getInt("maxlength") > 0){
					 fields1.put("size", rs.getInt("maxlength"));
				 }else{
					 fields1.put("size", 500);
				 }
				 
				 if (rs.getString("javascript_function") != null && rs.getString("javascript_function") != "" ){
					 fields1.put("javascript", rs.getString("javascript_function"));
				 }else{
					 fields1.put("javascript", "");
				 }
		    	  	if ("select".equals(rs.getString("tipo_campo"))){
		    	  		
		    				LookupList lookuplist = new LookupList(db, rs.getString("tabella_lookup"));
		    				lookuplist.addItem(-1, "--Seleziona--");
		    				if (rs.getString("javascript_function") != null && !("").equals(rs.getString("javascript_function")))
		    					lookuplist.setJsEvent(rs.getString("javascript_function"));
		    				lookuplist.setMultiple(rs.getBoolean("multiple"));
		    				if (lookuplist.getMultiple()==true)
		    						lookuplist.setSelectSize(9);
		    				html = 	lookuplist.getHtmlSelectDb(rs.getString("nome_campo"), -1,rs.getBoolean("obbligatorio"),(String)fields1.get("label"));
		    				
		    	  		
		    	  		
		    	  	}else if ("link".equals(rs.getString("tipo_campo"))){
		    	  		if (rs.getString("link_value") == null || "".equals(rs.getString("link_value")) ){
		    	  			html = "<a id=\""+rs.getString("nome_campo")+"\" href=\"javascript:"+rs.getString("javascript_function")+"\" >" +rs.getString("label_campo") + "</a>";
		    	  		}else{
		    	  			html = "<a id=\""+rs.getString("nome_campo")+"\" href=\""+rs.getString("link_value")+"\" >" +rs.getString("label_campo") + "</a>";
		    	  		}
		    	  		
		    	  	}
		    	 fields1.put("html", html);
		    	 fields1.put("value", rs.getString("valore_campo"));
				 fields.add(fields1);
	      
	      
	      }
	      
	      //il controllo sul piano padre lo disabilitiamo perche' come e' accaduto per il PNAA,
	      //non per tutti i sottopiani e' prevista la popup modale.
	     /* if (fields.isEmpty())
	      {
	    	  
	    	  pst = db.prepareStatement("select id_padre from lookup_piano_monitoraggio where code = ?");
	    	  pst.setInt(1, idPiano);
	    	  rs = pst.executeQuery() ;
	    	  if (rs.next())
	    	  {
	    		  int idPianoPadre = rs.getInt("id_padre");
	    		  if (idPianoPadre>0)
	    		  {
	    			  return getFieldsByEventoId(db,idPianoPadre);
	    		  }
	    	  }
	      }*/
	      rs.close();
	      pst.close();
		return fields;
	}
	
	//public static ArrayList getFieldsByPianoMonitoraggioAndIdControllo(Connection db, int idPiano, int idControllo) throws SQLException{
	public static ArrayList getFieldsByCodiceInternoAndIdControllo(Connection db, String codice_interno, int idControllo) throws SQLException{
		ArrayList fields = new ArrayList();
		StringBuffer sqlSelect = new StringBuffer();
		PreparedStatement pst = null;
		HashMap fields1 = new HashMap();
		String html = "";
	//	String codice_interno = ControlliUfficialiUtil.getCodiceInternoPianoMonitoraggio(db, "lookup_piano_monitoraggio", idPiano).getCodiceInterno();
		
		sqlSelect.append("select campi.*, mod.valore " + 
						" from cu_html_fields campi "+  
						" LEFT JOIN cu_fields_value mod on mod.id_cu_html_fields = campi.id and mod.id_controllo = ? "+ 
						" where codice_interno = ? "+   
						" and (enabled = true or enabled is null) "+  
						" order by ordine_campo asc ");
		
	
		pst = db.prepareStatement(
		        sqlSelect.toString());
		
		pst.setInt(1, idControllo);
		pst.setString(2, codice_interno);
		
		System.out.println("[Query dati estesi]: "+pst.toString());
		ResultSet rs = pst.executeQuery();
		
	      while (rs.next()) {
	    	  
	    	  	//CONTROLLO SE E' UN CAMPO SOLO PER UNA PARTICOLARE SPECIE ANIMALE E SE TALE SPECIE COINCIDE CON QUELLA PER CUI HO CHIAMATO
				 fields1 = new HashMap();
				 html = "";
				 fields1.put("name", rs.getString("nome_campo"));
				 fields1.put("type", rs.getString("tipo_campo"));
				 fields1.put("label", rs.getString("label_campo"));
				 fields1.put("obbligatorio", rs.getBoolean("obbligatorio"));
				 fields1.put("controlli", rs.getString("tipo_controlli_date"));
				 fields1.put("label_data", rs.getString("label_campo_controlli_date"));
				 fields1.put("label_link", rs.getString("label_link"));
				 fields1.put("link_value", rs.getString("link_value"));
				 if (rs.getInt("maxlength") > 0){
					 fields1.put("size", rs.getInt("maxlength"));
				 }else{
					 fields1.put("size", 500);
				 }
				 
				 if (rs.getString("javascript_function") != null && rs.getString("javascript_function") != "" ){
					 fields1.put("javascript", rs.getString("javascript_function"));
				 }else{
					 fields1.put("javascript", "");
				 }
		    	  	if ("select".equals(rs.getString("tipo_campo"))){
		    	  		
		    				LookupList lookuplist = new LookupList(db, rs.getString("tabella_lookup"));
		    				lookuplist.addItem(-1, "--Seleziona--");
		    				if (rs.getString("javascript_function") != null && !("").equals(rs.getString("javascript_function")))
		    					lookuplist.setJsEvent(rs.getString("javascript_function"));
		    				lookuplist.setMultiple(rs.getBoolean("multiple"));
		    				if (lookuplist.getMultiple()==true)
		    						lookuplist.setSelectSize(9);
		    			int value = -1 ;
		    			
//		    			if (rs.getString("valore")!=null)
//		    				value = lookuplist.getIdFromValue( rs.getString("valore"));
		    			
		    			try {value = Integer.parseInt(rs.getString("valore"));} 	catch (Exception e) {}
		    			
		    			html = 	lookuplist.getHtmlSelectDb(rs.getString("nome_campo"), value,rs.getBoolean("obbligatorio"),(String)fields1.get("label"));
		    				
		    	  		
		    	  		
		    	  	}else if ("link".equals(rs.getString("tipo_campo"))){
		    	  		if (rs.getString("link_value") == null || "".equals(rs.getString("link_value")) ){
		    	  			html = "<a id=\""+rs.getString("nome_campo")+"\" href=\"javascript:"+rs.getString("javascript_function")+"\" >" +rs.getString("label_campo") + "</a>";
		    	  		}else{
		    	  			html = "<a id=\""+rs.getString("nome_campo")+"\" href=\""+rs.getString("link_value")+"\" >" +rs.getString("label_campo") + "</a>";
		    	  		}
		    	  		
		    	  	}
		    	 fields1.put("html", html);
		    	 fields1.put("value", (rs.getString("valore")!=null) ? rs.getString("valore") : "");
				 fields.add(fields1);
	      
	      
	      }
	      
	      //il controllo sul piano padre lo disabilitiamo perche' come e' accaduto per il PNAA,
	      //non per tutti i sottopiani e' prevista la popup modale.
	     /* if (fields.isEmpty())
	      {
	    	  
	    	  pst = db.prepareStatement("select id_padre from lookup_piano_monitoraggio where code = ?");
	    	  pst.setInt(1, idPiano);
	    	  rs = pst.executeQuery() ;
	    	  if (rs.next())
	    	  {
	    		  int idPianoPadre = rs.getInt("id_padre");
	    		  if (idPianoPadre>0)
	    		  {
	    			  return getFieldsByEventoId(db,idPianoPadre);
	    		  }
	    	  }
	      }*/
	      rs.close();
	      pst.close();
		return fields;
	}
}
