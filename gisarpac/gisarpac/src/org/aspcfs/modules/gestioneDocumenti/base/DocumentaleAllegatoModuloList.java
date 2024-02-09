package org.aspcfs.modules.gestioneDocumenti.base;

import java.util.Vector;

import org.json.JSONArray;
import org.json.JSONException;

public class DocumentaleAllegatoModuloList extends Vector  {
	
	
	
	public void creaElenco(JSONArray jo) throws JSONException{
		
		 for(int i = 0 ; i < jo.length(); i++){
			    String riga = jo.get(i).toString();{
			    DocumentaleAllegatoModulo doc = new DocumentaleAllegatoModulo(riga);
			    this.add(doc);
			    }
			}
		
	}
	
	public DocumentaleAllegatoModuloList dividiPagine(int iniz, int fine){
		DocumentaleAllegatoModuloList docList = new DocumentaleAllegatoModuloList(); 
		
		for (int i = iniz; i < fine; i++){
			docList.add(this.get(i));
		}
		
		return docList;
	}
	

}
