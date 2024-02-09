package org.aspcfs.modules.gestioneDocumenti.base;

import java.util.Vector;

import org.json.JSONArray;
import org.json.JSONException;

public class DocumentaleAllegatoInviiList extends Vector  {
	
	
	
	public void creaElenco(JSONArray jo) throws JSONException{
		
		 for(int i = 0 ; i < jo.length(); i++){
			    String riga = jo.get(i).toString();{
			    DocumentaleAllegatoInvii doc = new DocumentaleAllegatoInvii(riga);
			    this.add(doc);
			    }
			}
		
	}
	
	public DocumentaleAllegatoInviiList dividiPagine(int iniz, int fine){
		DocumentaleAllegatoInviiList docList = new DocumentaleAllegatoInviiList(); 
		
		for (int i = iniz; i < fine; i++){
			docList.add(this.get(i));
		}
		
		return docList;
	}
	

}
