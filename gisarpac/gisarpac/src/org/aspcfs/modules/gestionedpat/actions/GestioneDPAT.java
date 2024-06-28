package org.aspcfs.modules.gestionedpat.actions;

import java.sql.Connection;
import java.time.Year;
import java.util.ArrayList;
import java.util.logging.Logger;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.gestionedpat.base.AreaComplessa;
import org.aspcfs.modules.gestionedpat.base.AreaSemplice;
import org.aspcfs.modules.gestionedpat.base.Nominativo;
import org.aspcfs.utils.web.LookupList;

import com.darkhorseventures.framework.actions.ActionContext;


public final class GestioneDPAT extends CFSModule {
	

	Logger logger = Logger.getLogger("MainLogger");

	public String executeCommandDefault(ActionContext context){
		return executeCommandSelezionaDipartimento(context);
	}

	public String executeCommandSelezionaDipartimento(ActionContext context) {
			
		Connection db = null;
		try {
			db = this.getConnection(context);
			
			// lista dipartimenti
			LookupList listaDipartimenti = new LookupList(db, "lookup_site_id");
			context.getRequest().setAttribute("ListaDipartimenti", listaDipartimenti);
			
			// lista anni
			int annoCorrente = Year.now().getValue();
			ArrayList<Integer> listaAnni = new ArrayList<Integer>();
			listaAnni.add(annoCorrente);
			listaAnni.add(annoCorrente-1);
			context.getRequest().setAttribute("ListaAnni", listaAnni);
		
		}catch (Exception e) {
			e.printStackTrace();
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} 
		finally
		{
			this.freeConnection(context, db);
		}
		
		return "SelezionaDipartimentoOK";
	}
	
	public String executeCommandListaAreeComplesse(ActionContext context) {
		
		int idDipartimento = -1;
		try {idDipartimento = Integer.parseInt(context.getRequest().getParameter("idDipartimento"));} catch(Exception e) {}
		int anno = -1;
		try {anno = Integer.parseInt(context.getRequest().getParameter("anno"));} catch(Exception e) {}
		
		Connection db = null;
		try {
			db = this.getConnection(context);
			
			// lista anni
			int annoCorrente = Year.now().getValue();
			ArrayList<Integer> listaAnni = new ArrayList<Integer>();
			listaAnni.add(annoCorrente);
			listaAnni.add(annoCorrente-1);
			context.getRequest().setAttribute("ListaAnni", listaAnni);
						
			// lista dipartimenti
			LookupList listaDipartimenti = new LookupList(db, "lookup_site_id");
			context.getRequest().setAttribute("ListaDipartimenti", listaDipartimenti);
			
			ArrayList <AreaComplessa> listaAreeComplesse = new ArrayList <AreaComplessa>();
			listaAreeComplesse = AreaComplessa.buildByAnnoDipartimento(db, anno, idDipartimento);
			context.getRequest().setAttribute("ListaAreeComplesse", listaAreeComplesse);
					
		}catch (Exception e) {
			e.printStackTrace();
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} 
		finally
		{
			this.freeConnection(context, db);
		}
		
		context.getRequest().setAttribute("anno", String.valueOf(anno)); 
		context.getRequest().setAttribute("idDipartimento", String.valueOf(idDipartimento));

		return "ListaAreeComplesseOK";
	}
	
	public String executeCommandDettaglioAreaComplessa(ActionContext context) {
		
		int idAreaComplessa = -1;
		try {idAreaComplessa = Integer.parseInt(context.getRequest().getParameter("idAreaComplessa"));} catch(Exception e) {}
		
		if (idAreaComplessa == -1)
			try {idAreaComplessa = (int) context.getRequest().getAttribute("idAreaComplessa");} catch(Exception e) {}
		
		Connection db = null;
		try {
			db = this.getConnection(context); 
			
			// lista dipartimenti
			LookupList listaDipartimenti = new LookupList(db, "lookup_site_id");
			context.getRequest().setAttribute("ListaDipartimenti", listaDipartimenti);
			
			AreaComplessa dettaglioAreaComplessa = new AreaComplessa(db, idAreaComplessa);
			context.getRequest().setAttribute("DettaglioAreaComplessa", dettaglioAreaComplessa);
					
		}catch (Exception e) {
			e.printStackTrace();
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} 
		finally
		{
			this.freeConnection(context, db);
		}
		
		return "DettaglioAreaComplessaOK";
	}
	
	public String executeCommandInserisciAreaComplessa(ActionContext context) {
		
		int idDipartimento = -1;
		try {idDipartimento = Integer.parseInt(context.getRequest().getParameter("idDipartimento"));} catch(Exception e) {}
		int anno = -1;
		try {anno = Integer.parseInt(context.getRequest().getParameter("anno"));} catch(Exception e) {}
		String nome = context.getRequest().getParameter("nomeAreaComplessa");
		
		
		Connection db = null;
		try {
			db = this.getConnection(context);
			
			AreaComplessa nuovaArea = new AreaComplessa();
			nuovaArea.setIdDipartimento(idDipartimento);
			nuovaArea.setAnno(anno);
			nuovaArea.setNome(nome);
			nuovaArea.insert(db, getUserId(context));
			context.getRequest().setAttribute("idAreaComplessa", nuovaArea.getId());
			
		}catch (Exception e) {
			e.printStackTrace();
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} 
		finally
		{
			this.freeConnection(context, db);
		}
		
		return executeCommandDettaglioAreaComplessa(context);
	}
	
	public String executeCommandInserisciAreaSemplice(ActionContext context) {
		
		int idAreaComplessa = -1;
		try {idAreaComplessa = Integer.parseInt(context.getRequest().getParameter("idAreaComplessa"));} catch(Exception e) {}
		String nome = context.getRequest().getParameter("nomeAreaSemplice");
			
		Connection db = null;
		try {
			db = this.getConnection(context);
			
			AreaSemplice nuovaArea = new AreaSemplice();
			nuovaArea.setIdAreaComplessa(idAreaComplessa);
			nuovaArea.setNome(nome);
			nuovaArea.insert(db, getUserId(context));
			context.getRequest().setAttribute("idAreaSemplice", nuovaArea.getId());
			context.getRequest().setAttribute("idAreaComplessa", nuovaArea.getIdAreaComplessa());

		}catch (Exception e) {
			e.printStackTrace();
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} 
		finally
		{
			this.freeConnection(context, db);
		}
		
		return executeCommandDettaglioAreaComplessa(context);
	}

	public String executeCommandModificaAreaSemplice(ActionContext context) {
		
		int idAreaSemplice = -1;
		try {idAreaSemplice = Integer.parseInt(context.getRequest().getParameter("idAreaSemplice"));} catch(Exception e) {}
		
		Connection db = null;
		try {
			db = this.getConnection(context);
			
			// lista dipartimenti
			LookupList listaDipartimenti = new LookupList(db, "lookup_site_id");
			context.getRequest().setAttribute("ListaDipartimenti", listaDipartimenti);
			
			AreaSemplice dettaglioAreaSemplice = new AreaSemplice(db, idAreaSemplice); 
			context.getRequest().setAttribute("DettaglioAreaSemplice", dettaglioAreaSemplice);
			
			AreaComplessa dettaglioAreaComplessa = new AreaComplessa(db, dettaglioAreaSemplice.getIdAreaComplessa());
			context.getRequest().setAttribute("DettaglioAreaComplessa", dettaglioAreaComplessa);
			
		}catch (Exception e) {
			e.printStackTrace();
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} 
		finally
		{
			this.freeConnection(context, db);
		}
		
		return "ModificaAreaSempliceOK";
	}
	
	public String executeCommandUpdateAreaSemplice(ActionContext context) {
		
		int idAreaSemplice = -1;
		try {idAreaSemplice = Integer.parseInt(context.getRequest().getParameter("idAreaSemplice"));} catch(Exception e) {}
		String nome = "";
		try {nome = context.getRequest().getParameter("nome");} catch(Exception e) {}

		Connection db = null;
		try {
			db = this.getConnection(context);
			
			AreaSemplice dettaglioAreaSemplice = new AreaSemplice(db, idAreaSemplice);
			dettaglioAreaSemplice.update(db, nome, getUserId(context));
			dettaglioAreaSemplice = new AreaSemplice(db, idAreaSemplice);
			context.getRequest().setAttribute("DettaglioAreaSemplice", dettaglioAreaSemplice);
			
		}catch (Exception e) {
			e.printStackTrace();
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} 
		finally
		{
			this.freeConnection(context, db);
		}
		
		return "UpdateAreaSempliceOK";
	}
	
	
	public String executeCommandDisableAreaSemplice(ActionContext context) {
		
		int idAreaSemplice = -1;
		try {idAreaSemplice = Integer.parseInt(context.getRequest().getParameter("idAreaSemplice"));} catch(Exception e) {}
		
		Connection db = null;
		try {
			db = this.getConnection(context);
			
			AreaSemplice dettaglioAreaSemplice = new AreaSemplice(db, idAreaSemplice);
			context.getRequest().setAttribute("idAreaComplessa", dettaglioAreaSemplice.getIdAreaComplessa());
			dettaglioAreaSemplice.disable(db, getUserId(context));
			
		}catch (Exception e) {
			e.printStackTrace();
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} 
		finally
		{
			this.freeConnection(context, db);
		}
		
		return executeCommandDettaglioAreaComplessa(context); 
	}
	
	public String executeCommandAggiungiNominativoAreaSemplice(ActionContext context) {
		
		int idAreaSemplice = -1;
		try {idAreaSemplice = Integer.parseInt(context.getRequest().getParameter("idAreaSemplice"));} catch(Exception e) {}
		
		Connection db = null;
		try {
			db = this.getConnection(context);
			
			// lista dipartimenti
			LookupList listaDipartimenti = new LookupList(db, "lookup_site_id");
			context.getRequest().setAttribute("ListaDipartimenti", listaDipartimenti);
			
			AreaSemplice dettaglioAreaSemplice = new AreaSemplice(db, idAreaSemplice);
			context.getRequest().setAttribute("DettaglioAreaSemplice", dettaglioAreaSemplice);
			
			AreaComplessa dettaglioAreaComplessa = new AreaComplessa(db, dettaglioAreaSemplice.getIdAreaComplessa());
			context.getRequest().setAttribute("DettaglioAreaComplessa", dettaglioAreaComplessa);
			
			ArrayList<Nominativo> listaNominativi = new ArrayList<Nominativo>();
			listaNominativi = Nominativo.buildSelezionabiliByAreaSemplice(db, dettaglioAreaSemplice.getId());
			context.getRequest().setAttribute("ListaNominativi", listaNominativi); 

		}catch (Exception e) {
			e.printStackTrace();
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} 
		finally
		{
			this.freeConnection(context, db);
		}
		
		return "AggiungiNominativoAreaSempliceOK";
	}
	
	public String executeCommandInserisciNominativoAreaSemplice(ActionContext context) {
		
		int idAreaSemplice = -1;
		try {idAreaSemplice = Integer.parseInt(context.getRequest().getParameter("idAreaSemplice"));} catch(Exception e) {}
		String[] idNominativo = new String[100];
		try {idNominativo = context.getRequest().getParameterValues("idNominativo");} catch(Exception e) {}
		
		Connection db = null;
		try {
			db = this.getConnection(context);
			
			AreaSemplice dettaglioAreaSemplice = new AreaSemplice(db, idAreaSemplice);
			
			for (int i = 0; i<idNominativo.length; i++){
				dettaglioAreaSemplice.insertNominativo(db, Integer.parseInt(idNominativo[i]), getUserId(context));
			}
			
			dettaglioAreaSemplice = new AreaSemplice(db, idAreaSemplice);
			context.getRequest().setAttribute("DettaglioAreaSemplice", dettaglioAreaSemplice);
			
		}catch (Exception e) {
			e.printStackTrace();
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} 
		finally
		{
			this.freeConnection(context, db);
		}
		
		return "InserisciNominativoAreaSempliceOK";
	}
	
	public String executeCommandDeleteNominativoAreaSemplice(ActionContext context) {
		
		int idAreaSemplice = -1;
		try {idAreaSemplice = Integer.parseInt(context.getRequest().getParameter("idAreaSemplice"));} catch(Exception e) {}
		int idNominativo = -1;
		try {idNominativo = Integer.parseInt(context.getRequest().getParameter("idNominativo"));} catch(Exception e) {}
		
		Connection db = null;
		try {
			db = this.getConnection(context);
			
			AreaSemplice dettaglioAreaSemplice = new AreaSemplice(db, idAreaSemplice);
			context.getRequest().setAttribute("idAreaComplessa", dettaglioAreaSemplice.getIdAreaComplessa()); 
			dettaglioAreaSemplice.deleteNominativo(db, idNominativo, getUserId(context));
			
		}catch (Exception e) {
			e.printStackTrace();
			context.getRequest().setAttribute("Error", e);
			return ("SystemError");
		} 
		finally
		{
			this.freeConnection(context, db);
		}
		
		return executeCommandDettaglioAreaComplessa(context);
	}


}
