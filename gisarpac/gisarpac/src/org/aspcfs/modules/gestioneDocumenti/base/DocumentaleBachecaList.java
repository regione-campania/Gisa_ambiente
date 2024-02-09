package org.aspcfs.modules.gestioneDocumenti.base;

import java.util.Vector;

import org.json.JSONArray;
import org.json.JSONException;

public class DocumentaleBachecaList extends Vector  {
	
	
	
	public void creaElenco(JSONArray jo, int tipo) throws JSONException{
		
		 for(int i = 3 ; i < jo.length(); i++){
			    String riga = jo.get(i).toString();{
			    DocumentaleBacheca doc = new DocumentaleBacheca(riga, tipo);
			    this.add(doc);
			    }
			}
		
	}
	
	public void creaElencoGlobale(JSONArray jo, String scelta, int inizio) throws JSONException{
		
		 for(int i = inizio ; i < jo.length(); i++){
			    String riga = jo.get(i).toString();{
			    DocumentaleBacheca doc = new DocumentaleBacheca(riga, scelta);
			    this.add(doc);
			    }
			}
		
	}
	
	public DocumentaleBachecaList dividiPagine(int iniz, int fine){
		DocumentaleBachecaList docList = new DocumentaleBachecaList(); 
		
		for (int i = iniz; i < fine; i++){
			docList.add(this.get(i));
		}
		
		return docList;
	}
	

}
