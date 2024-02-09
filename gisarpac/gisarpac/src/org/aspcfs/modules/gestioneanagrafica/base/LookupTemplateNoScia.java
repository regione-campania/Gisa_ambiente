package org.aspcfs.modules.gestioneanagrafica.base;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;

import org.aspcfs.utils.Bean;

public class LookupTemplateNoScia {
    
    private Integer code;
    private String description;
    private Boolean enabled;

    
    public LookupTemplateNoScia(ResultSet rs) throws SQLException
    {
        Bean.populate(this, rs);
    }
    
    public LookupTemplateNoScia() 
    {
    }
    
    public LookupTemplateNoScia(Integer code) 
    {
        this.code=code;
    }

    public LookupTemplateNoScia(Map<String, String[]> parameterMap) 
    {
        Bean.populate(this, parameterMap);
    }
    
    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

  
    public Boolean getEnabled() {
        return enabled;
    }

    public void setEnabled(Boolean enabled) {
        this.enabled = enabled;
    }

}
