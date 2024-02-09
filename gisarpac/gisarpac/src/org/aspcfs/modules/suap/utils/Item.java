package org.aspcfs.modules.suap.utils;

public class Item
{
	private int id ;
	private String descizione ;
	private boolean previstoCodiceNazionale;
	private boolean flagBdu ;
	public Item(){}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getDescizione() {
		return descizione;
	}
	public void setDescizione(String descizione) {
		this.descizione = descizione;
	}
	public boolean isPrevistoCodiceNazionale() {
		return previstoCodiceNazionale;
	}
	public void setPrevistoCodiceNazionale(boolean previstoCodiceNazionale) {
		this.previstoCodiceNazionale = previstoCodiceNazionale;
	}
	public boolean isFlagBdu() {
		return flagBdu;
	}
	public void setFlagBdu(boolean flagBdu) {
		this.flagBdu = flagBdu;
	}
	
}