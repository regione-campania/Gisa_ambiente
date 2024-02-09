package org.aspcfs.modules.accounts.base;




import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class Regione {
	
  private String value = null; 	
  private String label = null;
  private int idRegione = -1;

  public int getIdRegione() {
	return idRegione;
}








public void setIdRegione(int idRegione) {
	this.idRegione = idRegione;
}


public void setIdRegione(String idRegione) {
	this.idRegione = new Integer(idRegione);
}







public Regione() {
  }

  
  
 




public Regione(Connection db, String regione) throws SQLException {
    queryRecord(db, regione);
  }



  public String getValue() {
	return value;
}








public void setValue(String value) {
	this.value = value;
}








public String getLabel() {
	return label;
}








public void setLabel(String label) {
	this.label = label;
}








public void queryRecord(Connection db, String regione) throws SQLException {
    PreparedStatement st = null;
    ResultSet rs = null;
    StringBuffer sql = new StringBuffer();
    sql.append("SELECT codice FROM lookup_regione c WHERE c.description = ? ");
    st = db.prepareStatement(sql.toString());
    st.setString( 1, regione );
    rs = st.executeQuery();
    
    if (rs.next()) {
      value = rs.getString(1);
    }
    rs.close();
    st.close();
  }
  
  public ArrayList<Regione> buildList(Connection db, String regione) throws SQLException {
	    PreparedStatement st = null;
	    ResultSet rs = null;
	    StringBuffer sql = new StringBuffer();
	    ArrayList<Regione>  lista = new ArrayList<Regione> ();
	  
	    		sql.append("SELECT code, description FROM lookup_regione c where c.description ilike ? order by c.description");
	    	
	    
	    
	    st = db.prepareStatement(sql.toString());
	    
	    st.setString(1, "%"+regione+"%");

	    rs = st.executeQuery();
	    
	   while (rs.next()) {
	      value = rs.getString(2);
	      label = rs.getString(2); //Si puo modificare
	      idRegione = rs.getInt(1);
	      Regione c = new Regione();
	      c.setValue(value);
	      c.setLabel(label);
	      c.setIdRegione(idRegione);
	      lista.add(c);
	    }
	    rs.close();
	    st.close();
	    return lista;
	  }
  
  
  
  public ArrayList<Regione> buildList_all(Connection db, int asl) throws SQLException {
	  
	    PreparedStatement st = null;
	    ResultSet rs = null;
	    StringBuffer sql = new StringBuffer();
	    ArrayList<Regione>  lista = new ArrayList<Regione> ();
	  
	    		sql.append("SELECT code, description FROM regione c order by description");
	    	
	    
	    
	    st = db.prepareStatement(sql.toString());

	    rs = st.executeQuery();
	    
	   while (rs.next()) {
	      value = rs.getString(2);
	      label = rs.getString(2);
	      idRegione = rs.getInt(1);
	      Regione c = new Regione();
	      c.setValue(value);
	      c.setLabel(label);
	      lista.add(c);
	    }
	    rs.close();
	    st.close();
	    return lista;
	    
	  }
  



 

public HashMap<String, Object> getHashmap() throws IllegalArgumentException, IllegalAccessException, InvocationTargetException
{

	HashMap<String, Object> map = new HashMap<String, Object>();
	Field[] campi = this.getClass().getDeclaredFields();
	Method[] metodi = this.getClass().getMethods();
	for (int i = 0 ; i <campi.length; i++)
	{
		String nomeCampo = campi[i].getName();
		
		for (int j=0; j<metodi.length; j++ )
		{
			if(metodi[j].getName().equalsIgnoreCase("GET"+nomeCampo))
			{
				
				map.put(nomeCampo, metodi[j].invoke(this));
			}
			
		}
		
	}
	
	return map ;
	
}











}



