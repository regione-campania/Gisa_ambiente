package org.aspcfs.modules.gestioneDocumenti.base;

import java.util.Vector;

import org.json.JSONArray;
import org.json.JSONException;

public class DocumentaleAllegatoGinsList extends Vector  {
	
	
	
	public void creaElenco(JSONArray jo) throws JSONException{
		
		 for(int i = 0 ; i < jo.length(); i++){
			    String riga = jo.get(i).toString();{
			    DocumentaleAllegatoGins doc = new DocumentaleAllegatoGins(riga);
			    this.add(doc);
			    }
			}
		
	}
	
	public DocumentaleAllegatoGinsList dividiPagine(int iniz, int fine){
		DocumentaleAllegatoGinsList docList = new DocumentaleAllegatoGinsList(); 
		
		for (int i = iniz; i < fine; i++){
			docList.add(this.get(i));
		}
		
		return docList;
	}
	

}
