/*
 *  Copyright(c) 2004 Dark Horse Ventures LLC (http://www.centriccrm.com/) All
 *  rights reserved. This material cannot be distributed without written
 *  permission from Dark Horse Ventures LLC. Permission to use, copy, and modify
 *  this material for internal use is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies. DARK HORSE
 *  VENTURES LLC MAKES NO REPRESENTATIONS AND EXTENDS NO WARRANTIES, EXPRESS OR
 *  IMPLIED, WITH RESPECT TO THE SOFTWARE, INCLUDING, BUT NOT LIMITED TO, THE
 *  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY PARTICULAR
 *  PURPOSE, AND THE WARRANTY AGAINST INFRINGEMENT OF PATENTS OR OTHER
 *  INTELLECTUAL PROPERTY RIGHTS. THE SOFTWARE IS PROVIDED "AS IS", AND IN NO
 *  EVENT SHALL DARK HORSE VENTURES LLC OR ANY OF ITS AFFILIATES BE LIABLE FOR
 *  ANY DAMAGES, INCLUDING ANY LOST PROFITS OR OTHER INCIDENTAL OR CONSEQUENTIAL
 *  DAMAGES RELATING TO THE SOFTWARE.
 */
package org.aspcfs.modules.gestioneanagrafica.base;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.darkhorseventures.framework.beans.GenericBean;

public class Anagrafica extends GenericBean implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -2580181645261889750L;


 
  private int altId = -1;
  private String name = "";
  private int siteId = -1;
  private int tipologia = -1;
  private String accountNumber = "";
	
  public Anagrafica() { }


public String getName() {
	return name;
}

public void setName(String name) {
	this.name = name;
}

public int getSiteId() {
	return siteId;
}

public void setSiteId(int siteId) {
	this.siteId = siteId;
}

public int getTipologia() {
	return tipologia;
}

public void setTipologia(int tipologia) {
	this.tipologia = tipologia;
}

public String getAccountNumber() {
	return accountNumber;
}

public void setAccountNumber(String accountNumber) {
	this.accountNumber = accountNumber;
}

public int getAltId() {
	return altId;
}


public void setAltId(int altId) {
	this.altId = altId;
}

public Anagrafica(Connection db, int altId) throws SQLException {
		// TODO Auto-generated constructor stub
		try 
		{
			PreparedStatement pst = db.prepareStatement("select * from anagrafica.anagrafica_cerca_anagrafica_per_cu(?)");
			pst.setInt(1, altId);
			ResultSet rs = pst.executeQuery() ;
			if (rs.next())
			{
				this.altId = rs.getInt("riferimento_id");
				this.siteId = rs.getInt("id_asl");
				this.name = rs.getString("ragione_sociale");
				this.tipologia = rs.getInt("tipologia");
				this.accountNumber = rs.getString("n_reg");
			}
			
		}
		catch(SQLException e)
		{
			e.printStackTrace();
		}
		
		
	}

}  