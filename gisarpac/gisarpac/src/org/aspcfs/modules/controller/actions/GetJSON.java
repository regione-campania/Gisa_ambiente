package org.aspcfs.modules.controller.actions;
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.aspcfs.modules.controller.base.DataClass;
import org.json.JSONArray;
import org.json.JSONObject;

/**
 *
 * @author TaherT
 */

public class GetJSON extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            DataClass dataClass = new DataClass();
            List<DataClass.Technology> listCPV = dataClass.getTechList();
            JSONArray jSONArray = new JSONArray();
            for(int i=0; i<listCPV.size();){
                JSONObject jSONObject = new JSONObject();                
                jSONObject.put("state","open");
                jSONObject.put("data",listCPV.get(i).getTechName());

                JSONObject jsonAttr = new JSONObject();                
                jsonAttr.put("techname", listCPV.get(i).getTechName());
                jSONObject.put("attr", jsonAttr);
                jsonAttr = null;

                if(listCPV.get(i+1).getId()==0){
                    JSONArray jsonChildarray = new JSONArray();

                    while(listCPV.get(i+1).getId()==0){
                        i++;
                        JSONObject child = new JSONObject();
                        child.put("data",listCPV.get(i).getTechName());

                        JSONObject jsonChildAttr = new JSONObject();                        
                        jsonChildAttr.put("techname", listCPV.get(i).getTechName());
                        child.put("attr", jsonChildAttr);
                        jsonChildAttr = null;

                        jsonChildarray.put(child);
                        child=null;

                        if(listCPV.size()==(i+1)){
                            break;
                        }
                    }
                    jSONObject.put("children", jsonChildarray);
                    jSONArray.put(jSONObject);
                    jSONObject=null;
                }
                i++;
            }
            out.print(jSONArray);
            jSONArray=null;
        }catch(Exception e){
            System.out.println(e);
        }
        finally {
            out.close();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
