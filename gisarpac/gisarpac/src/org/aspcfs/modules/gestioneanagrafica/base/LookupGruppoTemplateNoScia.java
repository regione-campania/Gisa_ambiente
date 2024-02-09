package org.aspcfs.modules.gestioneanagrafica.base;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;

import org.aspcfs.utils.Bean;

public class LookupGruppoTemplateNoScia {
    
    private Integer id;
    private String label;
    private String hash_name;
    private Integer id_lookup_template_no_scia;
    
    
    public LookupGruppoTemplateNoScia(ResultSet rs) throws SQLException
    {
        Bean.populate(this, rs);
    }
    
    public LookupGruppoTemplateNoScia() 
    {
    }
    
    public LookupGruppoTemplateNoScia(Integer code) 
    {
        this.id=code;
    }

    public LookupGruppoTemplateNoScia(Map<String, String[]> parameterMap) 
    {
        Bean.populate(this, parameterMap);
    }
    
 
    
    public String getLabel() {
        return label;
    }
    public void setLabel(String label) {
        this.label = label;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getHash_name() {
        return hash_name;
    }

    public void setHash_name(String hash_name) {
        this.hash_name = hash_name;
    }

    public Integer getId_lookup_template_no_scia() {
        return id_lookup_template_no_scia;
    }

    public void setId_lookup_template_no_scia(Integer id_lookup_template_no_scia) {
        this.id_lookup_template_no_scia = id_lookup_template_no_scia;
    }
    

}
