package org.aspcfs.utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.logging.Logger;

	
/**
 * @author Gennaro
 */

public class AjaxCalls
{
	Logger logger = Logger.getLogger("MainLogger");
	//
	
	/*
	public CapoAjax getCapoOLD( String matricola )
	{
		CapoAjax ret = new CapoAjax();
		ret.setMatricola( matricola.trim().toUpperCase() );
		
		//ApplicationPrefs prefs = ApplicationPrefs.application_prefs;
		
		String		sql = "SELECT * FROM m_capi_bdn WHERE upper( matricola ) = upper( ? )";
		
		Connection conn = null;
		
		
//		String driver	= prefs.get("GATEKEEPER.DRIVER");
//		String url		= prefs.get("GATEKEEPER.URL");
//		String user		= prefs.get("GATEKEEPER.USER");
//		String password	= prefs.get("GATEKEEPER.PASSWORD");
		
		try
		{
			
			//Class.forName(driver).newInstance();
			//conn = DriverManager.getConnection( url + "?user=" + user + "&password=" + password);
			
			
			conn = GestoreConnessioni.getConnection();
			
			PreparedStatement stat = conn.prepareStatement( sql );
			stat.setString( 1, matricola.trim() );
			
			ResultSet res = stat.executeQuery();
			
			if( res.next() )
			{
				ret.setCodice_azienda( res.getString( "codice_azienda" ) );
				ret.setData_nascita( DateUtils.getDateAsString(  res.getTimestamp( "data_nascita" ), Locale.ITALY ) );
				ret.setRazza( res.getString( "razza" ) );
				ret.setSesso( res.getBoolean( "maschio" ) );
				ret.setSpecie( res.getString( "specie" ) );
				ret.setInBDN( true );
			}
			else
			{
				ret.setInBDN( false );
			}
			
			stat = conn.prepareStatement( "SELECT * FROM m_capi WHERE upper( cd_matricola ) = upper( ? ) AND trashed_date IS NULL" );
			stat.setString( 1, matricola.trim() );
			
			res = stat.executeQuery();
			
			if( res.next() )
			{
				ret.setMacellato( true );
			}
			else
			{
				ret.setMacellato( false );
			}
			
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			if( conn != null )
			{
				GestoreConnessioni.freeConnection(conn);
				conn = null;
			}
		}
		
		return ret;
	}
	*/
	

//	public BeanAjax isCapoEsistente( String identificativo, String codiceAzienda, Integer numOvini, Integer numCaprini, ConfigTipo configTipo ) throws ClassNotFoundException, InstantiationException, IllegalAccessException, IllegalArgumentException, InvocationTargetException, NoSuchMethodException, SecurityException{
//		
//		BeanAjax ret = (BeanAjax)ReflectionUtil.nuovaIstanza(configTipo.getPackageBean()+configTipo.getNomeBeanAjax());
//		ReflectionUtil.invocaMetodo(ret, configTipo.getMetodoSetIdentificativo(), new Class[]{String.class}, new Object[]{identificativo});
//		
//		Connection conn = null;
//		PreparedStatement stat = null;
//		ResultSet res = null;
//		
//		try{
//			conn = GestoreConnessioni.getConnection();
//
//			if (conn!=null)
//			{
//				Object o = ReflectionUtil.nuovaIstanza(configTipo.getPackageBean()+configTipo.getNomeBean());
//				String query = (String)ReflectionUtil.invocaMetodo(o, configTipo.getMetodoCostruisciQueryEsistenzaCapo(), new Class[]{ConfigTipo.class, Integer.class,Integer.class}, new Object[]{configTipo,numOvini,numCaprini});
//				stat = conn.prepareStatement( query );
//				stat = (PreparedStatement)ReflectionUtil.invocaMetodo(o, configTipo.getMetodoCostruisciStatementEsistenzaCapo(), new Class[]{PreparedStatement.class, String.class,String.class}, new Object[]{stat,identificativo,codiceAzienda});
//			
//				res = stat.executeQuery();
//			
//				if( res.next() )
//				{
//					ret.setEsistente(true);
//				}
//			}
//			
//		}
//		catch (SQLException sqle){
//			logger.severe("Eccezione nel metodo per determinare se " + configTipo.getDescrizioneCampoIdentificativoTabella() + " " + identificativo + " e stata gia inserita o meno in banca dati");
//			sqle.printStackTrace();
//		}
//		finally{
//			if( conn != null ){
//				GestoreConnessioni.freeConnection(conn);
//				conn = null;
//			}
//		}
//		
//		return ret;
//		
//	}

	
	public String[] getCoordinate
		( String indirizzo, String citta, String provincia, String cap,
		  String campo_lat, String campo_lon, String campo_flag )
	{
		String[] ret = new String[6];
		
		if( 	((indirizzo == null) || (indirizzo.trim().length() == 0)) &&
				((citta == null) || (citta.trim().length() == 0)) &&
				((provincia == null) || (provincia.trim().length() == 0)) &&
				((cap == null) || (cap.trim().length() == 0)) )
		{
			ret[0] = "";
			ret[1] = "";
			ret[2] = "";
		}
		else
		{
			GeoCoder geo = new GeoCoder();
			String[] temp = geo.getCoords( indirizzo, citta, provincia );
			if( temp[2].equalsIgnoreCase("e") )
			{
				ret[0] = "errore";
				ret[1] = "ricerca";
				ret[2] = temp[2];
			}
			else
			{
				//String[] c = convert2GaussBoaga( temp );
				//String[] c = convert2Wgs84UTM33N(temp);
				
				/*ret[0] = c[0];
				ret[1] = c[1];
				ret[2] = temp[2];*/
				
				if (temp[0].equals("0.0") && temp[1].equals("0.0") ){
				temp = GetCoordinateFromDb(temp, indirizzo, citta, provincia);
				}
					
				
				ret[0] = temp[0];
				ret[1] = temp[1];
				ret[2] = temp[2];
				
				
			}
		}
		
		ret[3] = campo_lat;
		ret[4] = campo_lon;
		ret[5] = campo_flag;
		
		
		return ret;
	}
	
	
	private String[] GetCoordinateFromDb(String[] temp, String indirizzo, String citta, String provincia) {

		String[] res = temp;
		
		Connection conn = null;
		try
		{
			conn = GestoreConnessioni.getConnection(); 
			if (conn != null)
			{
				
				String sql = "select count(latitudine||';'||longitudine), latitudine, longitudine from indirizzi where 1=1 ";
						
						if (!citta.equals(""))
							sql+=" and comune in (select id from comuni1 where nome ilike ?) ";
						
						sql+=" and latitudine > 0 and longitudine > 0 group by latitudine, longitudine order by count(latitudine||';'||longitudine) desc limit 1";

				PreparedStatement pst = conn.prepareStatement(sql);
				int i = 0;
				if (!citta.equals(""))
					pst.setString(++i, "%"+citta+"%");
				System.out.println("GET COORDS ULTIMA SPIAGGIA: Cerco sul db "+pst.toString());
				ResultSet rs = pst.executeQuery();
				if (rs.next()){
					res[1] = rs.getString("latitudine");
					res[0] = rs.getString("longitudine");
				}
				
			}
			
		}catch(Exception e)
		{ 			
			e.printStackTrace();
		}
		finally
		{
			if( conn != null )
			{
				GestoreConnessioni.freeConnection(conn);
				conn = null;
			}
		}
		
		
		return res;
		
	}
}






	
