package org.aspcfs.modules.gestioneanagrafica.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Map;

import org.aspcfs.utils.Bean;



public class LineaAttivita {
    
    private Integer id;
    private String linea_attivita;
    private String codice_univoco;
    private Aggregazione aggregazione = new Aggregazione();
    private String codice_attivita;

    
    
    public LineaAttivita()
    {
        
    }
    
    
    public LineaAttivita(ResultSet rs) throws SQLException 
    {
        Bean.populate(this, rs);
    }
    
    public LineaAttivita(Map<String, String[]> properties) throws SQLException
    {
        Bean.populate(this, properties);
    }
    
    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }
    
    public String getLinea_attivita() {
        return linea_attivita;
    }
    public void setLinea_attivita(String linea_attivita) {
        this.linea_attivita = linea_attivita;
    }
    
    
    public String getCodice_univoco() {
        return codice_univoco;
    }
    public void setCodice_univoco(String codice_univoco) {
        this.codice_univoco = codice_univoco;
    }

    
    
    public ArrayList<LineaAttivita> getLinee(Connection db) throws SQLException
    {
       
        
        String sql = "select * from public.get_linea_attivita_noscia()";
        
        
        PreparedStatement st  = db.prepareStatement(sql);
      
        ResultSet rs = st.executeQuery();

        ArrayList<LineaAttivita> listLinee = new ArrayList<LineaAttivita>();
        
        while(rs.next())
        {
            LineaAttivita la = new LineaAttivita();
            la.setCodice_univoco(rs.getString("codice_attivita"));
            la.setLinea_attivita(rs.getString("path_descrizione"));
            
            listLinee.add(la);
        }
        
        return listLinee;
        
        
        
    }


    public Aggregazione getAggregazione() {
        return aggregazione;
    }


    public void setAggregazione(Aggregazione aggregazione) {
        this.aggregazione = aggregazione;
    }


    public String getCodice_attivita() {
        return codice_attivita;
    }


    public void setCodice_attivita(String codice_attivita) {
        this.codice_attivita = codice_attivita;
    }
    
}
