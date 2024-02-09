package org.aspcfs.modules.gestioneDocumenti.base;

import java.util.Vector;

import org.json.JSONArray;
import org.json.JSONException;

public class DocumentaleAllegatoSintesisList extends Vector  {
	
	
	
	public void creaElenco(JSONArray jo) throws JSONException{
		
		 for(int i = 0 ; i < jo.length(); i++){
			    String riga = jo.get(i).toString();{
			    DocumentaleAllegatoSintesis doc = new DocumentaleAllegatoSintesis(riga);
			    this.add(doc);
			    }
			}
		
	}
	
	public DocumentaleAllegatoSintesisList dividiPagine(int iniz, int fine){
		DocumentaleAllegatoSintesisList docList = new DocumentaleAllegatoSintesisList(); 
		
		for (int i = iniz; i < fine; i++){
			docList.add(this.get(i));
		}
		
		return docList;
	}
	

}
