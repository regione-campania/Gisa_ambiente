package org.aspcfs.modules.gestioneDocumenti.base;

import java.util.Vector;

import org.json.JSONArray;
import org.json.JSONException;

public class DocumentaleAllegatoRiunioneList extends Vector  {
	
	
	
	public void creaElenco(JSONArray jo) throws JSONException{
		
		 for(int i = 0 ; i < jo.length(); i++){
			    String riga = jo.get(i).toString();{
			    DocumentaleAllegatoRiunione doc = new DocumentaleAllegatoRiunione(riga);
			    this.add(doc);
			    }
			}
		
	}
	
	public DocumentaleAllegatoRiunioneList dividiPagine(int iniz, int fine){
		DocumentaleAllegatoRiunioneList docList = new DocumentaleAllegatoRiunioneList(); 
		
		for (int i = iniz; i < fine; i++){
			docList.add(this.get(i));
		}
		
		return docList;
	}
	

}
