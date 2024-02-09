package org.aspcfs.modules.dpat.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import org.aspcfs.controller.SystemStatus;
import org.aspcfs.modules.admin.base.User;
import org.aspcfs.modules.base.SyncableList;
import org.aspcfs.modules.oia.base.OiaNodo;
import org.aspcfs.utils.UserUtils;
 
public class DpatStrumentoCalcoloNominativiList extends Vector implements SyncableList {

	
	private int idQualifica ;
	
	private String filtroQualifiche ;
	
	
	
	
	public String getFiltroQualifiche() {
		return filtroQualifiche;
	}

	public void setFiltroQualifiche(String filtroQualifiche) {
		this.filtroQualifiche = filtroQualifiche;
	}

	public int getIdQualifica() {
		return idQualifica;
	}

	public void setIdQualifica(int idQualifica) {
		this.idQualifica = idQualifica;
	}

	@Override
	public String getTableName() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getUniqueField() {
		// TODO Auto-generated method stub
		return null;
	} 
 
	
	
	@Override
	public void setLastAnchor(Timestamp arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void setLastAnchor(String arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void setNextAnchor(Timestamp arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void setNextAnchor(String arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void setSyncType(int arg0) {
		// TODO Auto-generated method stub
		 
	}
	
	@Override
	public void setSyncType(String arg0) {
		// TODO Auto-generated method stub
		
	}
	
	public void buildListNonInDpat(Connection db,int idAsl, int idRuolo,HttpServletRequest request)
    {
            
            ArrayList<User> listaUtenti= UserUtils.getUserFromRoleAltreAutorita(request, idAsl, idRuolo);
            for (User u :listaUtenti)
            {
                    User uu = new User();
                    DpatStrumentoCalcoloNominativi strutturaNominativo = new DpatStrumentoCalcoloNominativi();
                    
                    strutturaNominativo.setId(u.getId());
                    
                    strutturaNominativo.setIdAnagraficaNominativo(u.getId());
//                    utenteOK.setContact(utente.getContact());
                    uu.setUsername(u.getUsername());
                    uu.setPassword(u.getPassword());
                    uu.setRoleId(u.getRoleId());
                    uu.setId(u.getId());
                    uu.setRole(u.getRole());
                    uu.setSiteId(u.getSiteId());
                    uu.setSiteIdName(u.getSiteIdName());
                    
                    
//                            utenteOK.getContact().setNameFirst(utente.getContact().getNameFirst()+ "("+rs.getString("descrizione")+")");
                            uu.getContact().setNameFirst(u.getContact().getNameFirst());
                            uu.setStrutturaAppartenenza("");
                            uu.setIdStrutturaAppartenenza(-1);

                            

                            uu.getContact().setNameLast(u.getContact().getNameLast());
                    strutturaNominativo.setNominativo(uu);
            this.add(strutturaNominativo);
                            
                    
            }        }
	
	
	public void buildList(Connection db,int idDpatStrumentoCalcoloStruttura,SystemStatus system)
	{
		PreparedStatement pst = null;
		ResultSet rs = null ;
		try
		{  
			
//			String sql =" select lq.level,n.id,n.id_anagrafica_nominativo,n.id_lookup_qualifica,carico_lavoro_annuale,n.percentuale_ui_da_sottrarre,n.carico_lavoro_effettivo_annuale,"
//					+ " n.id_dpat_strumento_calcolo_strutture, regexp_replace(n.fattori_incidenti_su_carico, E'[\\n\\r]', ' ', 'g' ) as fattori_incidenti_su_carico,"
//					+ "	(select sum(percentuale_ui_da_sottrarre) as somma"
//					+ "	from dpat_strumento_calcolo_nominativi scn join dpat_strutture_asl scs on scn.id_dpat_strumento_calcolo_strutture=scs.codice_interno_fk"
//					+ " join dpat_strumento_calcolo sdc on sdc.id = scs.id_strumento_calcolo "
//					+ " where scn.id_anagrafica_nominativo = n.id_anagrafica_nominativo and sdc.id=sc.id) "
//					+ " from dpat_strumento_calcolo_nominativi n join lookup_qualifiche lq on lq.code =id_lookup_qualifica"
//					+ "	join dpat_strumento_calcolo sc on sc.id = strutt.id_strumento_calcolo"
//					+ " where n.trashed_Date is null and n.id_dpat_strumento_calcolo_strutture = ? and disabilitato = false"
//					+ " order by lq.livello_qualifiche_dpat ";
			
			
			
			String sql ="select lq.level,n.id,n.id_anagrafica_nominativo,n.id_lookup_qualifica,"+
"n.id_dpat_strumento_calcolo_strutture "
+ " from dpat_strumento_calcolo_nominativi n join lookup_qualifiche lq on lq.code =id_lookup_qualifica "+
"where n.trashed_Date is null and n.id_dpat_strumento_calcolo_strutture = ? and disabilitato = false "+
"order by lq.livello_qualifiche_dpat ";


			pst=db.prepareStatement(sql);
			pst.setInt(1, idDpatStrumentoCalcoloStruttura);
			rs = pst.executeQuery();
			while (rs.next())
			{
				DpatStrumentoCalcoloNominativi strutturaNominativo = new DpatStrumentoCalcoloNominativi(rs);
				strutturaNominativo.setNominativo(system.getUser(strutturaNominativo.getIdAnagraficaNominativo()));
				if (system.getUser(strutturaNominativo.getIdAnagraficaNominativo())==null)
				{
					
					strutturaNominativo.setNominativo(new User(db, strutturaNominativo.getIdAnagraficaNominativo()));
				}
				this.add(strutturaNominativo);
			}
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
	}
	
	
	public void buildListConfig(Connection db,int idDpatStrumentoCalcoloStruttura,SystemStatus system)
	{
		PreparedStatement pst = null;
		ResultSet rs = null ;
		try
		{  
			
			String sql = "select lq.level,id,id_anagrafica_nominativo,id_lookup_qualifica,carico_lavoro_annuale" +
					",percentuale_ui_da_sottrarre,carico_lavoro_effettivo_annuale,id_dpat_strumento_calcolo_strutture," +
					"regexp_replace(fattori_incidenti_su_carico, E'[\\n\\r]+', ' ', 'g' ) as fattori_incidenti_su_carico " +
					"from dpat_strumento_calcolo_nominativi_temp join lookup_qualifiche lq on lq.code =id_lookup_qualifica where dpat_strumento_calcolo_nominativi_temp.trashed_Date is null and id_dpat_strumento_calcolo_strutture = ? order by lq.level ";
			pst=db.prepareStatement(sql);
			pst.setInt(1, idDpatStrumentoCalcoloStruttura);
			rs = pst.executeQuery();
			while (rs.next())
			{
				DpatStrumentoCalcoloNominativi strutturaNominativo = new DpatStrumentoCalcoloNominativi(rs);
				strutturaNominativo.setNominativo(system.getUser(strutturaNominativo.getIdAnagraficaNominativo()));
				this.add(strutturaNominativo);
			}
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
	}
	
	public void buildList2(Connection db,int idAsl,int anno ,SystemStatus system)
	{
		PreparedStatement pst = null;
		ResultSet rs = null ;
		try
		{  
			filtroQualifiche ="" ;
//			String sql = "select distinct * from ( select scstr.pathdes as descrizione,scstr.id as id_struttura,lq.level,dpat_strumento_calcolo_nominativi.id,id_anagrafica_nominativo,id_lookup_qualifica,carico_lavoro_annuale "+
//			",percentuale_ui_da_sottrarre,carico_lavoro_effettivo_annuale,id_dpat_strumento_calcolo_strutture,  "+
//			"regexp_replace(dpat_strumento_calcolo_nominativi.fattori_incidenti_su_carico, E'[\\n\\r]', ' ', 'g' ) as fattori_incidenti_su_carico "+  
//			"from dpat_strumento_calcolo_nominativi  " +
//			"join dpat_strutture_asl scstr on scstr.codice_interno_fk =dpat_strumento_calcolo_nominativi.id_dpat_strumento_calcolo_strutture " 
//
//			+ "join dpat_strumento_calcolo sc on sc.id = scstr.id_strumento_calcolo "+ 
//			"join lookup_qualifiche lq on lq.code =id_lookup_qualifica   "+
//			"where  dpat_strumento_calcolo_nominativi.trashed_Date is null and scstr.id_asl= ? and scstr.anno = ? and scstr.disabilitato=false " ;
			
			
			String sql = "select * from dpat_strumento_calcolo_nominativi a where id_asl= ? and a.anno = ? and a.disabilitato=false ";
			
			if (idQualifica>0)
				sql+= " and id_lookup_qualifica = "+idQualifica ;
			
			if (anno>2015)
				sql+= " and stato_struttura= "+OiaNodo.STATO_DEFINITIVO+" ";

			pst=db.prepareStatement(sql+" ");
			pst.setInt(1, idAsl);
			pst.setInt(2, anno);
			
			rs = pst.executeQuery();
			while (rs.next())
			{
				DpatStrumentoCalcoloNominativi strutturaNominativo = new DpatStrumentoCalcoloNominativi(rs);
				User utenteOK = new User ();
				User utente =null;
				if (system.getUser(strutturaNominativo.getIdAnagraficaNominativo())!=null)
				{
					 utente =system.getUser(strutturaNominativo.getIdAnagraficaNominativo());
				}
				else
				{
					utente=new User(db, strutturaNominativo.getIdAnagraficaNominativo());
				}
//					utenteOK.setContact(utente.getContact());
					utenteOK.setUsername(utente.getUsername());
					utenteOK.setPassword(utente.getPassword());
					utenteOK.setRoleId(utente.getRoleId());
					utenteOK.setId(utente.getId());
					utenteOK.setRole(utente.getRole());
					utenteOK.setSiteId(utente.getSiteId());
					utenteOK.setSiteIdName(utente.getSiteIdName());
					
					if (utente.isInNucleoIspettivo())
					{
//						utenteOK.getContact().setNameFirst(utente.getContact().getNameFirst()+ "("+rs.getString("descrizione")+")");
						utenteOK.getContact().setNameFirst(utente.getContact().getNameFirst());
						utenteOK.setStrutturaAppartenenza(rs.getString("descrizione"));
						utenteOK.setIdStrutturaAppartenenza(rs.getInt("id_struttura"));
						
						

						utenteOK.getContact().setNameLast(utente.getContact().getNameLast());
					strutturaNominativo.setNominativo(utenteOK);
				this.add(strutturaNominativo);
					}
				
			}
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
	}
	
	
	
	
	
	
	
	public void buildList(Connection db,SystemStatus system)
	{
		PreparedStatement pst = null;
		ResultSet rs = null ;
		try
		{  
			String sql = "select  lq.level,dpat_strumento_calcolo_nominativi.id,id_anagrafica_nominativo,id_lookup_qualifica,carico_lavoro_annuale "+
			",percentuale_ui_da_sottrarre,carico_lavoro_effettivo_annuale,id_dpat_strumento_calcolo_strutture,  "+
			"regexp_replace(dpat_strumento_calcolo_nominativi.fattori_incidenti_su_carico, E'[\\n\\r]', ' ', 'g' ) as fattori_incidenti_su_carico "+  
			"from dpat_strumento_calcolo_nominativi  " +
			"join dpat_strutture_asl scstr on scstr.codice_interno_fk =dpat_strumento_calcolo_nominativi.id_dpat_strumento_calcolo_strutture "+ 
			"join lookup_qualifiche lq on lq.code =id_lookup_qualifica   "+
			"where dpat_strumento_calcolo_nominativi.trashed_Date is null and" +filtroQualifiche;
			
			if (idQualifica>0)
				sql+= " and id_lookup_qualifica = "+idQualifica ;

			pst=db.prepareStatement(sql+"");
			
			rs = pst.executeQuery();
			while (rs.next())
			{
				DpatStrumentoCalcoloNominativi strutturaNominativo = new DpatStrumentoCalcoloNominativi(rs);
				strutturaNominativo.setNominativo(system.getUser(strutturaNominativo.getIdAnagraficaNominativo()));
				this.add(strutturaNominativo);
			}
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
	}
	public DpatStrumentoCalcoloNominativi[] getListaNominativiasArray()
	{
		DpatStrumentoCalcoloNominativi[] tmpToRet = new DpatStrumentoCalcoloNominativi[this.size()];
		
		for (int i=0;i<this.size();i++)
		{
			
			tmpToRet[i]=(DpatStrumentoCalcoloNominativi)this.get(i);
		}
		return tmpToRet ;
	}

	
}
