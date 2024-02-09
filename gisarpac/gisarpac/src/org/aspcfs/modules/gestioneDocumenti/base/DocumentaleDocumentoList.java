package org.aspcfs.modules.gestioneDocumenti.base;

import java.util.Vector;

import org.json.JSONArray;
import org.json.JSONException;

public class DocumentaleDocumentoList extends Vector  {
	
	
	
	public void creaElenco(JSONArray jo) throws JSONException{
		
		 for(int i = 0 ; i < jo.length(); i++){
			    String riga = jo.get(i).toString();{
			    DocumentaleDocumento doc = new DocumentaleDocumento(riga);
			    this.add(doc);
			    }
			}
		
	}
	

}
