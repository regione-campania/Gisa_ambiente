package org.aspcfs.modules.programmazzionecu.base;

import java.sql.Connection;

public class PianoMonitoraggioList extends org.aspcfs.modules.troubletickets.base.TicketList
{
	private int tipo;
	private String descrizione ;
	
	public int getTipo() {
		return tipo;
	}


	public void setTipo(int tipo) {
		this.tipo = tipo;
	} 


	public String getDescrizione() {
		return descrizione;
	}


	public void setDescrizione(String descrizione) {
		this.descrizione = descrizione;
	}

	
	private boolean includeAttivita = true;
	
	
	
	public boolean isIncludeAttivita() {
		return includeAttivita;
	}


	public void setIncludeAttivita(boolean includeAttivita) {
		this.includeAttivita = includeAttivita;
	}


	
	
	
	
	
	 protected void createFilter(StringBuffer sqlFilter, Connection db) {
		    if (tipo != -1 && tipo!=0 ) {
		      sqlFilter.append(" AND lspm.code = "+tipo);
		    }
		    if (descrizione != null && !descrizione.equals("")  ) {
			      sqlFilter.append(" AND t.description ilike '%"+descrizione.replaceAll("'", "''")+"%' ");
			    }
		    
		 
		   
		    
	 }

}
