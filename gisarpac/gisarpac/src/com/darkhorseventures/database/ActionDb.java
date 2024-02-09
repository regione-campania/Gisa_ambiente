package com.darkhorseventures.database;

import java.sql.Connection;
import java.sql.Timestamp;

public class ActionDb {
	
	private String actionName;
	private String ipChiamante ;
	private Timestamp dataApertura ;
	private String actionppathname ;
	private String command ;
	private Connection db ;
	
	
	
	public Connection getDb() {
		return db;
	}
	public void setDb(Connection db) {
		this.db = db;
	}
	public String getCommand() {
		return command;
	}
	public void setCommand(String command) {
		this.command = command;
	}
	public String getActionppathname() {
		return actionppathname;
	}
	public void setActionppathname(String actionppathname) {
		this.actionppathname = actionppathname;
	}
	public String getActionName() {
		return actionName;
	}
	public void setActionName(String actionName) {
		this.actionName = actionName;
	}
	public String getIpChiamante() {
		return ipChiamante;
	}
	public void setIpChiamante(String ipChiamante) {
		this.ipChiamante = ipChiamante;
	}
	public Timestamp getDataApertura() {
		return dataApertura;
	}
	public void setDataApertura(Timestamp dataApertura) {
		this.dataApertura = dataApertura;
	}
	
	
	

}
