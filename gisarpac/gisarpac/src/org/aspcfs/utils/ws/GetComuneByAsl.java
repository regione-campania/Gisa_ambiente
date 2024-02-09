package org.aspcfs.utils.ws;

import java.io.PrintWriter;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.gestioneanagrafica.base.Comune;
import org.aspcfs.modules.noscia.dao.ComuneDAO;

import com.darkhorseventures.framework.actions.ActionContext;
import com.google.gson.Gson;



public class GetComuneByAsl extends CFSModule{


    public String executeCommandSearch(ActionContext context) throws Exception {
        
        Gson gson = new Gson();
        Connection db = null;
        String json = "";

        
        Map<String, Object> map = new HashMap<String, Object>();
        Map<String, String[]>  parameterMap = context.getRequest().getParameterMap();
        
        Comune comune = new Comune(parameterMap);
        ArrayList<Comune> comuni  = new ArrayList<>();
        
        
        try{
             ComuneDAO comuneDAO = new ComuneDAO(comune);
             comuni = comuneDAO.getItems(db);
          } catch (Exception errorMessage) {
              context.getRequest().setAttribute("Error", errorMessage);
              return ("SystemError");
            } finally {
              this.freeConnection(context, db);
            }
        
        if(comuni.size()>0)
        {
            map.put("status", "OK");
            map.put("comuni", comuni);
            
            json = gson.toJson(map);        
        }
        else
        {
            map.put("status", "KO");
             json = gson.toJson(map);
            
        }
        
        PrintWriter writer = context.getResponse().getWriter();
        writer.print(json);
        writer.close();

        return "";
        
    }

}
