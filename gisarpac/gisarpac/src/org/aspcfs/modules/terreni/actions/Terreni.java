package org.aspcfs.modules.terreni.actions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.gestioneanagrafica.base.Comune;
import org.aspcfs.modules.gestioneanagrafica.base.Provincia;
import org.aspcfs.modules.terreni.base.Area;
import org.aspcfs.modules.terreni.base.Subparticella;
import org.json.JSONArray;
import org.json.JSONException;

import com.darkhorseventures.framework.actions.ActionContext;

public class Terreni extends CFSModule{
	
	
	public String executeCommandAddArea(ActionContext context) {
	
		Connection db = null;
		try {
			db = this.getConnection(context);
			
			PreparedStatement pst = null;
			String sql = "select * from lookup_province where id_regione = 15 order by description";
			pst = db.prepareStatement(sql);
			
			ResultSet rs = pst.executeQuery();
			ArrayList<Provincia> province = new ArrayList<Provincia>();
			while(rs.next()){
				Provincia p = new Provincia();
				p.setCode(rs.getInt("code"));
				p.setDescription(rs.getString("description"));
				province.add(p);
			}
			
			//query to get comuni

			sql = "select * from comuni1 where cod_regione = '15' order by cod_provincia, nome";
			pst = db.prepareStatement(sql);
			
			rs = pst.executeQuery();
			ArrayList<Comune> comuni = new ArrayList<Comune>();
			while(rs.next()){
				Comune c = new Comune();
				c.setCode(rs.getInt("id"));
				c.setNome(rs.getString("nome"));
				c.setCod_provincia(rs.getString("cod_provincia"));
				
				comuni.add(c);
				
			}
				
			context.getRequest().setAttribute("province", province);
			context.getRequest().setAttribute("comuni", comuni);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 finally {
				this.freeConnection(context, db);
			}
		return "AddAreaOK";
	}
	
	public String executeCommandInsertArea(ActionContext context) {
		
		Connection db = null;
		Area area = new Area(context);
	
		try {
			db = this.getConnection(context);
			area.insert(db, getUserId(context));
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 finally {
				this.freeConnection(context, db);
			}
		
		context.getRequest().setAttribute("id", area.getId());
		return executeCommandDetailsArea(context);
	}
	
	public String executeCommandDetailsArea(ActionContext context) {
		
		int id = -1;
		
		try { id = Integer.parseInt(context.getRequest().getParameter("id")); } catch(Exception e) { }
		if (id == -1)
			try { id = (int) context.getRequest().getAttribute("id"); } catch(Exception e) { }

		Connection db = null;
				
		try {
			db = this.getConnection(context);
			
			Area area = new Area(db, id);
			context.getRequest().setAttribute("area", area);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 finally {
				this.freeConnection(context, db);
			}
		return "DetailsAreaOK";
	}
	
	public String executeCommandDetailsSubparticella(ActionContext context) {
		
		int id = -1;
		
		try { id = Integer.parseInt(context.getRequest().getParameter("id")); } catch(Exception e) { }
		if (id == -1)
			try { id = (int) context.getRequest().getAttribute("id"); } catch(Exception e) { }

		Connection db = null;
				
		try {
			db = this.getConnection(context);
			
			Subparticella sub = new Subparticella(db, id);
			context.getRequest().setAttribute("sub", sub);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 finally {
				this.freeConnection(context, db);
			}
		return "DetailsSubparticellaOK";
	}

	
	public String executeCommandModifyArea(ActionContext context) {
		int id = Integer.parseInt(context.getRequest().getParameter("id"));

		Connection db = null;
		try {
			db = this.getConnection(context);
			
			PreparedStatement pst = null;
			String sql = "select * from lookup_province where id_regione = 15 order by description";
			pst = db.prepareStatement(sql);
			
			ResultSet rs = pst.executeQuery();
			ArrayList<Provincia> province = new ArrayList<Provincia>();
			while(rs.next()){
				Provincia p = new Provincia();
				p.setCode(rs.getInt("code"));
				p.setDescription(rs.getString("description"));
				
				province.add(p);
			}
			
			//query to get comuni

			sql = "select * from comuni1 where cod_regione = '15' order by cod_provincia, nome";
			pst = db.prepareStatement(sql);
			
			rs = pst.executeQuery();
			ArrayList<Comune> comuni = new ArrayList<Comune>();
			while(rs.next()){
				Comune c = new Comune();
				c.setCode(rs.getInt("id"));
				c.setNome(rs.getString("nome"));
				c.setCod_provincia(rs.getString("cod_provincia"));
				
				comuni.add(c);
				
			}
			
			Area area = new Area (db, id);
			
			context.getRequest().setAttribute("area", area);
			context.getRequest().setAttribute("province", province);
			context.getRequest().setAttribute("comuni", comuni);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 finally {
				this.freeConnection(context, db);
			}
		return "ModifyAreaOK";
	}
	
	public String executeCommandUpdateArea(ActionContext context) {
		
		
		int id = -1;
		if(context.getRequest().getParameter("id") != null)
			id = Integer.parseInt(context.getRequest().getParameter("id"));
		
		Connection db = null;
		
		Area area = new Area(context);
		area.setId(id);
	
		try {
			db = this.getConnection(context);
			area.update(db, getUserId(context));
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 finally {
				this.freeConnection(context, db);
			}
		
		context.getRequest().setAttribute("id", area.getId());
		return executeCommandDetailsArea(context);
	}
	
	public String executeCommandtoSearchArea(ActionContext context) {
		Connection db = null;
		try {
			db = this.getConnection(context);
			
			PreparedStatement pst = null;
			String sql = "select * from lookup_province where id_regione = 15 order by description";
			pst = db.prepareStatement(sql);
			
			ResultSet rs = pst.executeQuery();
			ArrayList<Provincia> province = new ArrayList<Provincia>();
			while(rs.next()){
				Provincia p = new Provincia();
				p.setCode(rs.getInt("code"));
				p.setDescription(rs.getString("description"));
				
				province.add(p);
			}
			
			//query to get comuni

			sql = "select * from comuni1 where cod_regione = '15' order by cod_provincia, nome";
			pst = db.prepareStatement(sql);
			
			rs = pst.executeQuery();
			ArrayList<Comune> comuni = new ArrayList<Comune>();
			while(rs.next()){
				Comune c = new Comune();
				c.setCode(rs.getInt("id"));
				c.setNome(rs.getString("nome"));
				c.setCod_provincia(rs.getString("cod_provincia"));
				
				comuni.add(c);
				
			}
			
			context.getRequest().setAttribute("province", province);
			context.getRequest().setAttribute("comuni", comuni);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}  finally {
			this.freeConnection(context, db);
		}
		
		return "toSearchAreaOK";
	}
	
	public String executeCommandSearchArea(ActionContext context) {
		
		Connection db = null;
		
		ArrayList<Area> listaAree = new ArrayList<Area>();
		
		String codiceSito = "";
		int idProvincia = -1;
		int idComune = -1;
		
		codiceSito = context.getRequest().getParameter("codiceSito");
		try {idProvincia = Integer.parseInt(context.getRequest().getParameter("idProvincia"));} catch (Exception e) {}
		try {idComune = Integer.parseInt(context.getRequest().getParameter("idComune"));} catch (Exception e) {}

		try {
			db = this.getConnection(context);
			
			listaAree = Area.buildList(db, codiceSito, idProvincia, idComune);
			context.getRequest().setAttribute("listaAree", listaAree);
			
		} catch (Exception errorMessage) {
			context.getRequest().setAttribute("Error", errorMessage);
			return ("SystemError");
		} finally {
			this.freeConnection(context, db);
		}
		
		return "ListAreeOK";
	}
	

public String executeCommandAddSubparticella(ActionContext context) { 
		
		int idArea = -1;
		if(context.getRequest().getParameter("idArea") != null)
			idArea = Integer.parseInt(context.getRequest().getParameter("idArea"));
		
		Connection db = null;
		try {
			db = this.getConnection(context);
			Area area = new Area(db, idArea);
			context.getRequest().setAttribute("area", area);
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 finally {
				this.freeConnection(context, db);
			}
		return "AddSubparticellaOK";
	}
	
	public String executeCommandInsertSubparticella(ActionContext context) {
		
		Connection db = null;
		Subparticella sub = new Subparticella(context);
	
		try {
			db = this.getConnection(context);
			sub.insert(db, getUserId(context));
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 finally {
				this.freeConnection(context, db);
			}
		
		context.getRequest().setAttribute("id", sub.getId());
		return executeCommandDetailsSubparticella(context);
	}

	public String executeCommandModifySubparticella(ActionContext context) {
		int id = Integer.parseInt(context.getRequest().getParameter("id"));

		Connection db = null;
		try {
			db = this.getConnection(context);
				
			Subparticella sub = new Subparticella (db, id);
			
			context.getRequest().setAttribute("sub", sub);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}  finally {
			this.freeConnection(context, db);
		}
		return "ModifySubparticellaOK";
	}
	
	public String executeCommandUpdateSubparticella(ActionContext context) { 
		
		
		int id = -1;
		if(context.getRequest().getParameter("id") != null)
			id = Integer.parseInt(context.getRequest().getParameter("id"));
		
		Connection db = null;
		
		Subparticella sub = new Subparticella(context);
		sub.setId(id);
	
		try {
			db = this.getConnection(context);
			sub.update(db, getUserId(context));
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 finally {
				this.freeConnection(context, db);
			}
		
		context.getRequest().setAttribute("id", sub.getId());
		return executeCommandDetailsSubparticella(context);
	}
	
	public String executeCommandEstrazioneSubparticelleNonCampionate(ActionContext context) throws JSONException {

		Connection db = null;
		try {
			db = this.getConnection(context);
			
			JSONArray jsonNonCampionate = new JSONArray();
			jsonNonCampionate = Subparticella.getJsonNonCampionate(db);
			
			context.getRequest().setAttribute("jsonNonCampionate", jsonNonCampionate);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}  finally {
			this.freeConnection(context, db);
		}
		return "ListSubparticelleNonCampionateOK";
	}
}
