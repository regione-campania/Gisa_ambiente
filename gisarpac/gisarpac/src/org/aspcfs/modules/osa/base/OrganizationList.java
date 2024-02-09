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
package org.aspcfs.modules.osa.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.util.HashMap;
import java.util.Iterator;
import java.util.TimeZone;
import java.util.Vector;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.aspcfs.controller.SystemStatus;
import org.aspcfs.modules.base.Constants;
import org.aspcfs.modules.base.SyncableList;
import org.aspcfs.utils.DatabaseUtils;
import org.aspcfs.utils.DateUtils;
import org.aspcfs.utils.web.HtmlSelect;
import org.aspcfs.utils.web.PagedListInfo;

/**
 *  Contains a list of organizations... currently used to build the list from
 *  the database with any of the parameters to limit the results.
 *
 * @author     mrajkowski
 * @created    August 30, 2001
 * @version    $Id: OrganizationList.java,v 1.2 2001/08/31 17:33:32 mrajkowski
 *      Exp $
 */
public class OrganizationList extends Vector implements SyncableList {

	Logger logger = Logger.getLogger("MainLogger");
	
  private static Logger log = Logger.getLogger(org.aspcfs.modules.accounts.base.OrganizationList.class);
  static {
    if (System.getProperty("DEBUG") != null) {
      log.setLevel(Level.DEBUG);
    }
  }
 
  private static final long serialVersionUID = 2268314721560915731L;
  public final static int TRUE = 1;
  public final static int FALSE = 0;
  protected int includeEnabled = TRUE;


  private int codiceSezione = -1;
  private int categoria = -1;
  private int sottoAttivita = -1;
  private int categoriaRischio=-1;
  public Integer getCategoriaRischio() {
		return categoriaRischio;
	}

	public void setCategoriaRischio(String categoriaRischio) {
	    this.categoriaRischio = Integer.parseInt(categoriaRischio);
	  }
	public void setCategoriaRischio(Integer categoriaRischio) {
		this.categoriaRischio = categoriaRischio;
	}
  private int statoLab = -1;
  public final static String tableName = "organization";
  public final static String uniqueField = "org_id";
  protected java.sql.Timestamp lastAnchor = null;
  protected java.sql.Timestamp nextAnchor = null;
  protected int syncType = Constants.NO_SYNC;
  protected PagedListInfo pagedListInfo = null;
  private String numAut = null;
  protected Boolean minerOnly = null;
  protected int enteredBy = -1;
  protected String name = null;
  protected int ownerId = -1;
  protected int orgId = -1;
  protected String HtmlJsEvent = "";
  protected boolean showMyCompany = false;
  protected String ownerIdRange = null;
  protected String excludeIds = null;
  protected boolean hasAlertDate = false;
  protected boolean hasExpireDate = false;
  protected String accountNumber = null;
  protected int orgSiteId = -1;
  protected boolean includeOrganizationWithoutSite = false;
  protected int projectId = -1;
  private String city = null;
  protected String specie_allev = null;
  protected String tipo_stab = null;
  private String state = null;
  private String country = null;
  private String accountOtherState = null;
  private String accountOtherState3 = null;
  protected String postalCode = null;
  protected String assetSerialNumber = null;
  
  private String responsabileAnimale;
  private String medicoVeterinario ; 
  private String autUtilizzo;
  private String autAllevamento;
  private String autFornitore ;
  private String autDeroga8 ;
  private String autDeroga9 ;
  private int tipoStabulatorio ;
  private int specieAnimali ;
  private int mediaAnimaliOspitabili ;
  private int capacitaMax ;
  private String nomeRappresentante = null;
  
  protected int revenueType = 0;
  protected int revenueYear = -1;
  protected int revenueOwnerId = -1;
  protected boolean buildRevenueYTD = false;
  protected java.sql.Timestamp alertRangeStart = null;
  protected java.sql.Timestamp alertRangeEnd = null;

  protected java.sql.Timestamp enteredSince = null;
  protected java.sql.Timestamp enteredTo = null;

  protected int typeId = 0;
  protected String types = null;
  protected String accountSegment = null;
  
  protected int stageId = -1;

  //import filters
  private int importId = -1;
  private int statusId = -1;
  private boolean excludeUnapprovedAccounts = true;
  private java.sql.Timestamp trashedDate = null;
  private boolean includeOnlyTrashed = false;

  //Contact filters
  private String firstName = null;
  private String lastName = null;
  private String contactPhoneNumber = null;
  private String contactCity = null;
  private String contactState = null;
  private int tipologia = 850;
//  private String contactOtherState = null;
  private String contactCountry = null;
  private int impianto = -1;
  
  
  public String getNomeRappresentante() {
	return nomeRappresentante;
}

public void setNomeRappresentante(String nomeRappresentante) {
	this.nomeRappresentante = nomeRappresentante;
}

public String getResponsabileAnimale() {
	return responsabileAnimale;
}

public void setResponsabileAnimale(String responsabileAnimale) {
	this.responsabileAnimale = responsabileAnimale;
}

public String getMedicoVeterinario() {
	return medicoVeterinario;
}

public void setMedicoVeterinario(String medicoVeterinario) {
	this.medicoVeterinario = medicoVeterinario;
}

public String getAutUtilizzo() {
	return autUtilizzo;
}

public void setAutUtilizzo(String autUtilizzo) {
	this.autUtilizzo = autUtilizzo;
}

public String getAutAllevamento() {
	return autAllevamento;
}

public void setAutAllevamento(String autAllevamento) {
	this.autAllevamento = autAllevamento;
}

public String getAutFornitore() {
	return autFornitore;
}

public void setAutFornitore(String autFornitore) {
	this.autFornitore = autFornitore;
}

public String getAutDeroga8() {
	return autDeroga8;
}

public void setAutDeroga8(String autDeroga8) {
	this.autDeroga8 = autDeroga8;
}

public String getAutDeroga9() {
	return autDeroga9;
}

public void setAutDeroga9(String autDeroga9) {
	this.autDeroga9 = autDeroga9;
}

public int getMediaAnimaliOspitabili() {
	return mediaAnimaliOspitabili;
}

public void setMediaAnimaliOspitabili(int mediaAnimaliOspitabili) {
	this.mediaAnimaliOspitabili = mediaAnimaliOspitabili;
}

public int getCapacitaMax() {
	return capacitaMax;
}

public void setCapacitaMax(int capacitaMax) {
	this.capacitaMax = capacitaMax;
}

public void setCategoriaRischio(int categoriaRischio) {
	this.categoriaRischio = categoriaRischio;
}

public int getImpianto() {
		return impianto;
	}

	public void setImpianto(int impianto) {
		this.impianto = impianto;
	}
	 public void setImpianto(String tmp) {
		    this.impianto = Integer.parseInt(tmp);
		  }
  private boolean includeAllSites = false;
  
  
  	public int getCodiceSezione() {
		return codiceSezione;
	}
	
	public void setCodiceSezione(int codiceSezione) {
		this.codiceSezione = codiceSezione;
	}
	
	public void setCodiceSezione(String codiceSezione) {
		this.codiceSezione = Integer.parseInt( codiceSezione );
	}
	
	public int getCategoria() {
		return categoria;
	}
	
	public void setCategoria(int categoria) {
		this.categoria = categoria;
	}
	
	public void setCategoria(String categoria) {
		if(categoria!=null)
		this.categoria = Integer.parseInt( categoria );
	}
	
	public int getSottoAttivita() {
		return sottoAttivita;
	}
	
	public void setSottoAttivita(int sottoAttivita) {
		this.sottoAttivita = sottoAttivita;
	}

  /**
   * Gets the includeAllSites attribute of the OrganizationList object
   *
   * @return includeAllSites The includeAllSites value
   */
  public boolean isIncludeAllSites() {
    return this.includeAllSites;
  }


  /**
   * Sets the includeAllSites attribute of the OrganizationList object
   *
   * @param includeAllSites The new includeAllSites value
   */
  public void setIncludeAllSites(boolean includeAllSites) {
    this.includeAllSites = includeAllSites;
  }


  /**
   *  Constructor for the OrganizationList object, creates an empty list. After
   *  setting parameters, call the build method.
   *
   * @since    1.1
   */
  public OrganizationList() { }


  /**
   *  Gets the enteredSince attribute of the OrganizationList object
   *
   * @return    The enteredSince value
   */
  public java.sql.Timestamp getEnteredSince() {
    return enteredSince;
  }

  public void setStatoLab(int tmp) {
	    this.statoLab = tmp;
	  }

public void setStatoLab(String tmp) {
	    this.statoLab = Integer.parseInt(tmp);
	  }
public int getStatoLab() {
  return statoLab;
}

  
  /**
   *  Sets the enteredSince attribute of the OrganizationList object
   *
   * @param  tmp  The new enteredSince value
   */
  public void setEnteredSince(java.sql.Timestamp tmp) {
    this.enteredSince = tmp;
  }


  /**
   *  Sets the enteredSince attribute of the OrganizationList object
   *
   * @param  tmp  The new enteredSince value
   */
  public void setEnteredSince(String tmp) {
    this.enteredSince = DateUtils.parseTimestampString(tmp);
  }


  /**
   *  Gets the enteredTo attribute of the OrganizationList object
   *
   * @return    The enteredTo value
   */
  public java.sql.Timestamp getEnteredTo() {
    return enteredTo;
  }

  public String getNumAut() {
		return numAut;
	}
  
  public void setNumAut(String numAut) {
		this.numAut = numAut;
	}

  /**
   *  Sets the enteredTo attribute of the OrganizationList object
   *
   * @param  tmp  The new enteredTo value
   */
  public void setEnteredTo(java.sql.Timestamp tmp) {
    this.enteredTo = tmp;
  }


  /**
   *  Sets the enteredTo attribute of the OrganizationList object
   *
   * @param  tmp  The new enteredTo value
   */
  public void setEnteredTo(String tmp) {
    this.enteredTo = DateUtils.parseTimestampString(tmp);
  }


  /**
   *  Gets the excludeIds attribute of the OrganizationList object
   *
   * @return    The excludeIds value
   */
  public String getExcludeIds() {
    return excludeIds;
  }

  private String codiceAllerta = "";

  public String getCodiceAllerta() {
	return codiceAllerta;
}

public void setCodiceAllerta(String codiceAllerta) {
	this.codiceAllerta = codiceAllerta;
}

/**
   *  Sets the excludeIds attribute of the OrganizationList object
   *
   * @param  tmp  The new excludeIds value
   */
  public void setExcludeIds(String tmp) {
    this.excludeIds = tmp;
  }


  /**
   *  Gets the types attribute of the OrganizationList object
   *
   * @return    The types value
   */
  public String getTypes() {
    return types;
  }


  /**
   *  Sets the types attribute of the OrganizationList object
   *
   * @param  tmp  The new types value
   */
  public void setTypes(String tmp) {
    this.types = tmp;
  }


  /**
   *  Sets the lastAnchor attribute of the OrganizationList object
   *
   * @param  tmp  The new lastAnchor value
   */
  public void setLastAnchor(java.sql.Timestamp tmp) {
    this.lastAnchor = tmp;
  }


  /**
   *  Sets the lastAnchor attribute of the OrganizationList object
   *
   * @param  tmp  The new lastAnchor value
   */
  public void setLastAnchor(String tmp) {
    this.lastAnchor = java.sql.Timestamp.valueOf(tmp);
  }


  /**
   *  Sets the nextAnchor attribute of the OrganizationList object
   *
   * @param  tmp  The new nextAnchor value
   */
  public void setNextAnchor(java.sql.Timestamp tmp) {
    this.nextAnchor = tmp;
  }


  /**
   *  Sets the nextAnchor attribute of the OrganizationList object
   *
   * @param  tmp  The new nextAnchor value
   */
  public void setNextAnchor(String tmp) {
    this.nextAnchor = java.sql.Timestamp.valueOf(tmp);
  }


  /**
   *  Sets the syncType attribute of the OrganizationList object
   *
   * @param  tmp  The new syncType value
   */
  public void setSyncType(int tmp) {
    this.syncType = tmp;
  }


  /**
   *  Gets the typeId attribute of the OrganizationList object
   *
   * @return    The typeId value
   */
  public int getTypeId() {
    return typeId;
  }


  /**
   *  Sets the typeId attribute of the OrganizationList object
   *
   * @param  typeId  The new typeId value
   */
  public void setTypeId(int typeId) {
    this.typeId = typeId;
  }


  /**
   *  Sets the typeId attribute of the OrganizationList object
   *
   * @param  typeId  The new typeId value
   */
  public void setTypeId(String typeId) {
    this.typeId = Integer.parseInt(typeId);
  }


  /**
   *  Sets the accountSegment attribute of the OrganizationList object
   *
   * @param  tmp  The new accountSegment value
   */
  public void setAccountSegment(String tmp) {
    this.accountSegment = tmp;
  }


  /**
   *  Sets the accountSegment attribute of the OrganizationList object
   *
   * @return    The accountSegment value
   */
  public String getAccountSegment() {
    return accountSegment;
  }
  /**
   *  Sets the stageId attribute of the OrganizationList object
   *
   * @param  tmp  The new stageId  value
   */
  public void setStageId(int tmp) {
    this.stageId = tmp;
  }
  
  /**
   *  Sets the stageId attribute of the OrganizationList object
   *
   * @param  tmp  The new stageId  value
   */
  public void setStageId(String tmp) {
	  if (tmp!=null){
    this.stageId = Integer.parseInt(tmp);
	  }else{this.stageId = -1;}
  }


  /**
   *  Sets the stageId  attribute of the OrganizationList object
   *
   * @return    The stageId  value
   */
  public int getStageId () {
    return stageId;
  }


  /**
   *  Sets the syncType attribute of the OrganizationList object
   *
   * @param  tmp  The new syncType value
   */
  public void setSyncType(String tmp) {
    this.syncType = Integer.parseInt(tmp);
  }


  /**
   *  Sets the PagedListInfo attribute of the OrganizationList object. <p>
   *
   *  <p/>
   *
   *  The query results will be constrained to the PagedListInfo parameters.
   *
   * @param  tmp  The new PagedListInfo value
   * @since       1.1
   */
  public void setPagedListInfo(PagedListInfo tmp) {
    this.pagedListInfo = tmp;
  }


  /**
   *  Sets the MinerOnly attribute of the OrganizationList object to limit the
   *  results to miner only, or non-miner only.
   *
   * @param  tmp  The new MinerOnly value
   * @since       1.1
   */
  public void setMinerOnly(boolean tmp) {
    this.minerOnly = new Boolean(tmp);
  }


  /**
   *  Sets the revenueType attribute of the OrganizationList object
   *
   * @param  tmp  The new revenueType value
   */
  public void setRevenueType(int tmp) {
    this.revenueType = tmp;
  }


  /**
   *  Sets the revenueYear attribute of the OrganizationList object
   *
   * @param  tmp  The new revenueYear value
   */
  public void setRevenueYear(int tmp) {
    this.revenueYear = tmp;
  }


  /**
   *  Sets the alertRangeStart attribute of the OrganizationList object
   *
   * @param  alertRangeStart  The new alertRangeStart value
   */
  public void setAlertRangeStart(java.sql.Timestamp alertRangeStart) {
    this.alertRangeStart = alertRangeStart;
  }


  /**
   *  Sets the alertRangeEnd attribute of the OrganizationList object
   *
   * @param  alertRangeEnd  The new alertRangeEnd value
   */
  public void setAlertRangeEnd(java.sql.Timestamp alertRangeEnd) {
    this.alertRangeEnd = alertRangeEnd;
  }


  /**
   *  Sets the importId attribute of the OrganizationList object
   *
   * @param  tmp  The new importId value
   */
  public void setImportId(int tmp) {
    this.importId = tmp;
  }


  /**
   *  Sets the excludeUnapprovedAccounts attribute of the OrganizationList
   *  object
   *
   * @param  tmp  The new excludeUnapprovedAccounts value
   */
  public void setExcludeUnapprovedAccounts(boolean tmp) {
    this.excludeUnapprovedAccounts = tmp;
  }


  /**
   *  Sets the excludeUnapprovedAccounts attribute of the OrganizationList
   *  object
   *
   * @param  tmp  The new excludeUnapprovedAccounts value
   */
  public void setExcludeUnapprovedAccounts(String tmp) {
    this.excludeUnapprovedAccounts = DatabaseUtils.parseBoolean(tmp);
  }


  /**
   *  Gets the excludeUnapprovedAccounts attribute of the OrganizationList
   *  object
   *
   * @return    The excludeUnapprovedAccounts value
   */
  public boolean getExcludeUnapprovedAccounts() {
    return excludeUnapprovedAccounts;
  }


  /**
   *  Sets the trashedDate attribute of the OrganizationList object
   *
   * @param  tmp  The new trashedDate value
   */
  public void setTrashedDate(java.sql.Timestamp tmp) {
    this.trashedDate = tmp;
  }


  /**
   *  Sets the trashedDate attribute of the OrganizationList object
   *
   * @param  tmp  The new trashedDate value
   */
  public void setTrashedDate(String tmp) {
    this.trashedDate = DatabaseUtils.parseTimestamp(tmp);
  }


  /**
   *  Sets the includeOnlyTrashed attribute of the OrganizationList object
   *
   * @param  tmp  The new includeOnlyTrashed value
   */
  public void setIncludeOnlyTrashed(boolean tmp) {
    this.includeOnlyTrashed = tmp;
  }


  /**
   *  Sets the includeOnlyTrashed attribute of the OrganizationList object
   *
   * @param  tmp  The new includeOnlyTrashed value
   */
  public void setIncludeOnlyTrashed(String tmp) {
    this.includeOnlyTrashed = DatabaseUtils.parseBoolean(tmp);
  }


  /**
   *  Gets the trashedDate attribute of the OrganizationList object
   *
   * @return    The trashedDate value
   */
  public java.sql.Timestamp getTrashedDate() {
    return trashedDate;
  }


  /**
   *  Gets the includeOnlyTrashed attribute of the OrganizationList object
   *
   * @return    The includeOnlyTrashed value
   */
  public boolean getIncludeOnlyTrashed() {
    return includeOnlyTrashed;
  }


  /**
   *  Sets the importId attribute of the OrganizationList object
   *
   * @param  tmp  The new importId value
   */
  public void setImportId(String tmp) {
    this.importId = Integer.parseInt(tmp);
  }


  /**
   *  Sets the statusId attribute of the OrganizationList object
   *
   * @param  tmp  The new statusId value
   */
  public void setStatusId(int tmp) {
    this.statusId = tmp;
  }


  /**
   *  Sets the statusId attribute of the OrganizationList object
   *
   * @param  tmp  The new statusId value
   */
  public void setStatusId(String tmp) {
    this.statusId = Integer.parseInt(tmp);
  }


  /**
   *  Sets the firstName attribute of the OrganizationList object
   *
   * @param  tmp  The new firstName value
   */
  public void setFirstName(String tmp) {
    this.firstName = tmp;
  }


  /**
   *  Sets the lastName attribute of the OrganizationList object
   *
   * @param  tmp  The new lastName value
   */
  public void setLastName(String tmp) {
    this.lastName = tmp;
  }


  /**
   *  Sets the contactPhoneNumber attribute of the OrganizationList object
   *
   * @param  tmp  The new contactPhoneNumber value
   */
  public void setContactPhoneNumber(String tmp) {
    this.contactPhoneNumber = tmp;
  }


  /**
   *  Sets the contactCity attribute of the OrganizationList object
   *
   * @param  tmp  The new contactCity value
   */
  public void setContactCity(String tmp) {
    this.contactCity = tmp;
  }


  /**
   *  Sets the contactState attribute of the OrganizationList object
   *
   * @param  tmp  The new contactState value
   */
  public void setContactState(String tmp) {
    this.contactState = tmp;
  }


  /**
   *  Gets the contactCountry attribute of the OrganizationList object
   *
   * @return    The contactCountry value
   */
  public String getContactCountry() {
    return contactCountry;
  }


  /**
   *  Sets the contactCountry attribute of the OrganizationList object
   *
   * @param  tmp  The new contactCountry value
   */
  public void setContactCountry(String tmp) {
    this.contactCountry = tmp;
  }


  /**
   *  Gets the contactOtherState attribute of the OrganizationList object
   *
   * @return    The contactOtherState value
   */
  public String getContactOtherState() {
    return contactState;
  }


  /**
   *  Sets the contactOtherState attribute of the OrganizationList object
   *
   * @param  tmp  The new contactOtherState value
   */
  public void setContactOtherState(String tmp) {
    this.contactState = tmp;
  }


  /**
   *  Gets the importId attribute of the OrganizationList object
   *
   * @return    The importId value
   */
  public int getImportId() {
    return importId;
  }


  /**
   *  Gets the statusId attribute of the OrganizationList object
   *
   * @return    The statusId value
   */
  public int getStatusId() {
    return statusId;
  }


  /**
   *  Gets the firstName attribute of the OrganizationList object
   *
   * @return    The firstName value
   */
  public String getFirstName() {
    return firstName;
  }


  /**
   *  Gets the lastName attribute of the OrganizationList object
   *
   * @return    The lastName value
   */
  public String getLastName() {
    return lastName;
  }


  /**
   *  Gets the contactPhoneNumber attribute of the OrganizationList object
   *
   * @return    The contactPhoneNumber value
   */
  public String getContactPhoneNumber() {
    return contactPhoneNumber;
  }


  /**
   *  Gets the contactCity attribute of the OrganizationList object
   *
   * @return    The contactCity value
   */
  public String getContactCity() {
    return contactCity;
  }


  /**
   *  Gets the contactState attribute of the OrganizationList object
   *
   * @return    The contactState value
   */
  public String getContactState() {
    return contactState;
  }


  /**
   *  Gets the revenueType attribute of the OrganizationList object
   *
   * @return    The revenueType value
   */
  public int getRevenueType() {
    return revenueType;
  }


  /**
   *  Gets the revenueYear attribute of the OrganizationList object
   *
   * @return    The revenueYear value
   */
  public int getRevenueYear() {
    return revenueYear;
  }


  /**
   *  Gets the includeEnabled attribute of the OrganizationList object
   *
   * @return    The includeEnabled value
   */
  public int getIncludeEnabled() {
    return includeEnabled;
  }


  /**
   *  Sets the includeEnabled attribute of the OrganizationList object
   *
   * @param  includeEnabled  The new includeEnabled value
   */
  public void setIncludeEnabled(int includeEnabled) {
    this.includeEnabled = includeEnabled;
  }


  /**
   *  Sets the ShowMyCompany attribute of the OrganizationList object
   *
   * @param  showMyCompany  The new ShowMyCompany value
   */
  public void setShowMyCompany(boolean showMyCompany) {
    this.showMyCompany = showMyCompany;
  }


  /**
   *  Sets the hasAlertDate attribute of the OrganizationList object
   *
   * @param  hasAlertDate  The new hasAlertDate value
   */
  public void setHasAlertDate(boolean hasAlertDate) {
    this.hasAlertDate = hasAlertDate;
  }


  /**
   *  Sets the HtmlJsEvent attribute of the OrganizationList object
   *
   * @param  HtmlJsEvent  The new HtmlJsEvent value
   */
  public void setHtmlJsEvent(String HtmlJsEvent) {
    this.HtmlJsEvent = HtmlJsEvent;
  }


  /**
   *  Gets the accountNumber attribute of the OrganizationList object
   *
   * @return    The accountNumber value
   */
  public String getAccountNumber() {
    return accountNumber;
  }


  /**
   *  Sets the accountNumber attribute of the OrganizationList object
   *
   * @param  accountNumber  The new accountNumber value
   */
  public void setAccountNumber(String accountNumber) {
    this.accountNumber = accountNumber;
  }
  
  /**
   *  Gets the accountNumber attribute of the OrganizationList object
   *
   * @return    The accountNumber value
   */
  public String getSpecieAllev() {
    return specie_allev;
  }


  /**
   *  Sets the accountNumber attribute of the OrganizationList object
   *
   * @param  accountNumber  The new accountNumber value
   */
  public void setSpecieAllev(String specie_allev) {
    this.specie_allev = specie_allev;
  }

  /**
   *  Gets the accountNumber attribute of the OrganizationList object
   *
   * @return    The accountNumber value
   */
  public String getTipoStab() {
    return tipo_stab;
  }


  /**
   *  Sets the accountNumber attribute of the OrganizationList object
   *
   * @param  accountNumber  The new accountNumber value
   */
  public void setTipoStab(String tipo_stab) {
    this.tipo_stab = tipo_stab;
  }

  /**
   *  Gets the projectId attribute of the OrganizationList object
   *
   * @return    The projectId value
   */
  public int getProjectId() {
    return projectId;
  }


  /**
   *  Sets the projectId attribute of the OrganizationList object
   *
   * @param  projectId  The new projectId value
   */
  public void setProjectId(int projectId) {
    this.projectId = projectId;
  }


  /**
   *  Sets the projectId attribute of the OrganizationList object
   *
   * @param  projectId  The new projectId value
   */
  public void setProjectId(String projectId) {
    this.projectId = Integer.parseInt(projectId);
  }


  /**
   *  Sets the EnteredBy attribute of the OrganizationList object to limit
   *  results to those records entered by that user.
   *
   * @param  tmp  The new EnteredBy value
   * @since       1.1
   */
  public void setEnteredBy(int tmp) {
    this.enteredBy = tmp;
  }


  /**
   *  Sets the orgSiteId attribute of the OrganizationList object
   *
   * @param  orgSiteId  The new orgSiteId value
   */
  public void setOrgSiteId(int orgSiteId) {
    this.orgSiteId = orgSiteId;
  }


  /**
   *  Sets the orgSiteId attribute of the OrganizationList object
   *
   * @param  orgSiteId  The new orgSiteId value
   */
  public void setOrgSiteId(String orgSiteId) {
    this.orgSiteId = Integer.parseInt(orgSiteId);
  }


  /**
   *  
   *
   * @return    The orgSiteId value
   */
  public int getOrgSiteId() {
    return orgSiteId;
  }


  /**
   *  Sets the includeOrganizationWithoutSite attribute of the OrganizationList
   *  object
   *
   * @param  tmp  The new includeOrganizationWithoutSite value
   */
  public void setIncludeOrganizationWithoutSite(boolean tmp) {
    this.includeOrganizationWithoutSite = tmp;
  }


  /**
   *  Sets the includeOrganizationWithoutSite attribute of the OrganizationList
   *  object
   *
   * @param  tmp  The new includeOrganizationWithoutSite value
   */
  public void setIncludeOrganizationWithoutSite(String tmp) {
    this.includeOrganizationWithoutSite = DatabaseUtils.parseBoolean(tmp);
  }


  /**
   *  Gets the includeOrganizationWithoutSite attribute of the OrganizationList
   *  object
   *
   * @return    The includeOrganizationWithoutSite value
   */
  public boolean getIncludeOrganizationWithoutSite() {
    return includeOrganizationWithoutSite;
  }


  /**
   *  Gets the buildRevenueYTD attribute of the OrganizationList object
   *
   * @return    The buildRevenueYTD value
   */
  public boolean getBuildRevenueYTD() {
    return buildRevenueYTD;
  }


  /**
   *  Sets the buildRevenueYTD attribute of the OrganizationList object
   *
   * @param  buildRevenueYTD  The new buildRevenueYTD value
   */
  public void setBuildRevenueYTD(boolean buildRevenueYTD) {
    this.buildRevenueYTD = buildRevenueYTD;
  }


  /**
   *  Sets the ownerIdRange attribute of the OrganizationList object
   *
   * @param  tmp  The new ownerIdRange value
   */
  public void setOwnerIdRange(String tmp) {
    this.ownerIdRange = tmp;
  }


  /**
   *  Sets the Name attribute of the OrganizationList object to limit results to
   *  those records matching the name. Use a % in the name for wildcard
   *  matching.
   *
   * @param  tmp  The new Name value
   * @since       1.1
   */
  public void setName(String tmp) {
    this.name = tmp;
  }


  /**
   *  Sets the accountName attribute of the OrganizationList object to limit
   *  results to those records matching the name. Use a % in the name for
   *  wildcard matching.
   *
   * @param  tmp  The new accountName value
   * @since       1.1
   */
  public void setAccountName(String tmp) {
    this.name = tmp;
  }


  /**
   *  Gets the revenueOwnerId attribute of the OrganizationList object
   *
   * @return    The revenueOwnerId value
   */
  public int getRevenueOwnerId() {
    return revenueOwnerId;
  }


  /**
   *  Building Alert Counts Sets the revenueOwnerId attribute of the
   *  OrganizationList object
   *
   * @param  revenueOwnerId  The new revenueOwnerId value
   */
  public void setRevenueOwnerId(int revenueOwnerId) {
    this.revenueOwnerId = revenueOwnerId;
  }


  /**
   *  Sets the hasExpireDate attribute of the OrganizationList object
   *
   * @param  hasExpireDate  The new hasExpireDate value
   */
  public void setHasExpireDate(boolean hasExpireDate) {
    this.hasExpireDate = hasExpireDate;
  }


  /**
   *  Sets the OwnerId attribute of the OrganizationList object
   *
   * @param  ownerId  The new OwnerId value
   */
  public void setOwnerId(int ownerId) {
    this.ownerId = ownerId;
  }


  /**
   *  Sets the ownerId attribute of the OrganizationList object
   *
   * @param  tmp  The new ownerId value
   */
  public void setOwnerId(String tmp) {
    this.ownerId = Integer.parseInt(tmp);
  }


  /**
   *  Sets the orgId attribute of the OrganizationList object
   *
   * @param  tmp  The new orgId value
   */
  public void setOrgId(int tmp) {
    this.orgId = tmp;
  }


  /**
   *  Sets the orgId attribute of the OrganizationList object
   *
   * @param  tmp  The new orgId value
   */
  public void setOrgId(String tmp) {
    this.orgId = Integer.parseInt(tmp);
  }


  /**
   *  Gets the tableName attribute of the OrganizationList object
   *
   * @return    The tableName value
   */
  public String getTableName() {
    return tableName;
  }


  /**
   *  Gets the uniqueField attribute of the OrganizationList object
   *
   * @return    The uniqueField value
   */
  public String getUniqueField() {
    return uniqueField;
  }


  /**
   *  Gets the hasAlertDate attribute of the OrganizationList object
   *
   * @return    The hasAlertDate value
   */
  public boolean getHasAlertDate() {
    return hasAlertDate;
  }


  /**
   *  Gets the ownerIdRange attribute of the OrganizationList object
   *
   * @return    The ownerIdRange value
   */
  public String getOwnerIdRange() {
    return ownerIdRange;
  }


  /**
   *  Gets the hasExpireDate attribute of the OrganizationList object
   *
   * @return    The hasExpireDate value
   */
  public boolean getHasExpireDate() {
    return hasExpireDate;
  }


  /**
   *  Gets the ShowMyCompany attribute of the OrganizationList object
   *
   * @return    The ShowMyCompany value
   */
  public boolean getShowMyCompany() {
    return showMyCompany;
  }


  /**
   *  Gets the HtmlJsEvent attribute of the OrganizationList object
   *
   * @return    The HtmlJsEvent value
   */
  public String getHtmlJsEvent() {
    return HtmlJsEvent;
  }


  /**
   *  Gets the OwnerId attribute of the OrganizationList object
   *
   * @return    The OwnerId value
   */
  public int getOwnerId() {
    return ownerId;
  }


  /**
   *  Gets the orgId attribute of the OrganizationList object
   *
   * @return    The orgId value
   */
  public int getOrgId() {
    return orgId;
  }


  /**
   *  Gets the postalCode attribute of the OrganizationList object
   *
   * @return    The postalCode value
   */
  public String getPostalCode() {
    return postalCode;
  }


  /**
   *  Sets the postalCode attribute of the OrganizationList object
   *
   * @param  tmp  The new postalCode value
   */
  public void setPostalCode(String tmp) {
    this.postalCode = tmp;
  }


  /**
   *  Gets the accountPostalCode attribute of the OrganizationList object
   *
   * @return    The accountPostalCode value
   */
  public String getAccountPostalCode() {
    return postalCode;
  }


  /**
   *  Sets the accountPostalCode attribute of the OrganizationList object
   *
   * @param  tmp  The new accountPostalCode value
   */
  public void setAccountPostalCode(String tmp) {
    this.postalCode = tmp;
  }

  /**
   *  Gets the accountCity attribute of the OrganizationList object
   *
   * @return    The accountCity value
   */
  public String getCity() {
    return city;
  }

  /**
   *  Sets the accountCity attribute of the OrganizationList object
   *
   * @param  tmp  The new accountCity value
   */
  public void setCity(String tmp) {
    this.city = tmp;
  }

  /**
   *  Gets the accountCity attribute of the OrganizationList object
   *
   * @return    The accountCity value
   */
  public String getAccountCity() {
    return city;
  }

  /**
   *  Sets the contactCity attribute of the OrganizationList object
   *
   * @param  tmp  The new accountCity value
   */
  public void setAccountCity(String tmp) {
    this.city = tmp;
  }
 
  
  /**
   *  Gets the accountCity attribute of the OrganizationList object
   *
   * @return    The accountCity value
   */
  public int getTipologia() {
    return tipologia;
  }

  /**
   *  Sets the contactCity attribute of the OrganizationList object
   *
   * @param  tmp  The new accountCity value
   */
  public void setTipologia(int tmp) {
    this.tipologia = tmp;
  }

  /**
   *  Gets the accountState attribute of the OrganizationList object
   *
   * @return    The accountState value
   */
  public String getState() {
    return state;
  }

  /**
   *  Sets the accountState attribute of the OrganizationList object
   *
   * @param  tmp  The new accountState value
   */
  public void setState(String tmp) {
    this.state = tmp;
  }

  /**
   *  Gets the accountState attribute of the OrganizationList object
   *
   * @return    The accountState value
   */
  public String getAccountState() {
    return state;
  }

  /**
   *  Sets the contactState attribute of the OrganizationList object
   *
   * @param  tmp  The new accountState value
   */
  public void setAccountOtherState(String tmp) {
    this.accountOtherState = tmp;
  }
  
  public void setAccountOtherState3(String tmp) {
	    this.accountOtherState3 = tmp;
	  }
  
  public String getAccountOtherState() {
	    return accountOtherState;
	  }
  
  public String getAccountOtherState3() {
	    return accountOtherState3;
	  }

  /**
   *  Gets the accountCountry attribute of the OrganizationList object
   *
   * @return    The accountCountry value
   */
  public String getCountry() {
    return country;
  }

  /**
   *  Sets the accountCountry attribute of the OrganizationList object
   *
   * @param  tmp  The new accountCountry value
   */
  public void setCountry(String tmp) {
    this.country = tmp;
  }

  /**
   *  Gets the accountCountry attribute of the OrganizationList object
   *
   * @return    The accountCountry value
   */
  public String getAccountCountry() {
    return country;
  }

  /**
   *  Sets the accountCountry attribute of the OrganizationList object
   *
   * @param  tmp  The new accountCountry value
   */
  public void setAccountCountry(String tmp) {
    this.country = tmp;
  }

  /**
   *  Gets the assetSerialNumber attribute of the OrganizationList object
   *
   * @return    The assetSerialNumber value
   */
  public String getAssetSerialNumber() {
    return assetSerialNumber;
  }


  /**
   *  Sets the assetSerialNumber attribute of the OrganizationList object
   *
   * @param  tmp  The new assetSerialNumber value
   */
  public void setAssetSerialNumber(String tmp) {
    this.assetSerialNumber = tmp;
  }


  /**
   *  Sets the searchText(name) attribute of the OrganizationList object
   *
   * @param  tmp  The new searchText (name) value
   */
  public void setSearchText(String tmp) {
    this.name = tmp;
  }


  /**
   *  Gets the searchText(name) attribute of the OrganizationList object
   *
   * @return    The searchText(name) value
   */
  public String getSearchText() {
    return name;
  }


  /**
   *  
   *
   * @param  selectName  Description of Parameter
   * @return             The HtmlSelect value
   * @since              1.8
   */
  public String getHtmlSelect(String selectName) {
    return getHtmlSelect(selectName, -1);
  }


  /**
   *  
   *
   * @param  selectName  Description of Parameter
   * @param  defaultKey  Description of Parameter
   * @return             The HtmlSelect value
   * @since              1.8
   */
  public String getHtmlSelect(String selectName, int defaultKey) {
    HtmlSelect orgListSelect = new HtmlSelect();

    Iterator i = this.iterator();
    while (i.hasNext()) {
      Organization thisOrg = (Organization) i.next();
      orgListSelect.addItem(
          thisOrg.getOrgId(),
          thisOrg.getName());
    }

    if (!(this.getHtmlJsEvent().equals(""))) {
      orgListSelect.setJsEvent(this.getHtmlJsEvent());
    }

    return orgListSelect.getHtml(selectName, defaultKey);
  }


  /**
   *  Gets the HtmlSelectDefaultNone attribute of the OrganizationList object
   *
   * @param  selectName  Description of Parameter
   * @param  thisSystem  Description of the Parameter
   * @return             The HtmlSelectDefaultNone value
   */
  public String getHtmlSelectDefaultNone(SystemStatus thisSystem, String selectName) {
    return getHtmlSelectDefaultNone(thisSystem, selectName, -1);
  }


  /**
   *  Gets the htmlSelectDefaultNone attribute of the OrganizationList object
   *
   * @param  selectName  Description of the Parameter
   * @param  defaultKey  Description of the Parameter
   * @param  thisSystem  Description of the Parameter
   * @return             The htmlSelectDefaultNone value
   */
  public String getHtmlSelectDefaultNone(SystemStatus thisSystem, String selectName, int defaultKey) {
    HtmlSelect orgListSelect = new HtmlSelect();
    orgListSelect.addItem(-1, thisSystem.getLabel("calendar.none.4dashes"));

    Iterator i = this.iterator();
    while (i.hasNext()) {
      Organization thisOrg = (Organization) i.next();
      orgListSelect.addItem(
          thisOrg.getOrgId(),
          thisOrg.getName());
    }

    if (!(this.getHtmlJsEvent().equals(""))) {
      orgListSelect.setJsEvent(this.getHtmlJsEvent());
    }

    return orgListSelect.getHtml(selectName, defaultKey);
  }


  /**
   *  Description of the Method
   *
   * @param  db             Description of the Parameter
   * @throws  SQLException  Description of the Exception
   */
  public void select(Connection db) throws SQLException {
    buildList(db);
  }


  /**
   *  Description of the Method
   *
   * @param  db             Description of the Parameter
   * @param  timeZone       Description of the Parameter
   * @param  events         Description of the Parameter
   * @return                Description of the Return Value
   * @throws  SQLException  Description of the Exception
   */
  public HashMap queryRecordCount(Connection db, TimeZone timeZone, HashMap events) throws SQLException {

    PreparedStatement pst = null;
    ResultSet rs = null;

    StringBuffer sqlSelect = new StringBuffer();
    StringBuffer sqlFilter = new StringBuffer();
    StringBuffer sqlTail = new StringBuffer();

    String sqlDate = ((hasAlertDate ? "alertdate" : "") + (hasExpireDate ? "contract_end" : ""));

    createFilter(db, sqlFilter);

    sqlSelect.append(
        "SELECT " + sqlDate + " AS " + DatabaseUtils.addQuotes(db, "date")+ ", count(*) AS nocols " +
        "FROM organization o " +
        "WHERE o.org_id >= 0 ");
    sqlTail.append("GROUP BY " + sqlDate);
    pst = db.prepareStatement(
        sqlSelect.toString() + sqlFilter.toString() + sqlTail.toString());
    prepareFilter(pst);
    rs = pst.executeQuery();
    while (rs.next()) {
      String alertDate = DateUtils.getServerToUserDateString(
          timeZone, DateFormat.SHORT, rs.getTimestamp("date"));
      int thisCount = rs.getInt("nocols");
      if (events.containsKey(alertDate)) {
        int tmpCount = ((Integer) events.get(alertDate)).intValue();
        thisCount += tmpCount;
      }
      events.put(alertDate, new Integer(thisCount));
    }
   
    rs.close();
    pst.close();
    return events;
  }


  /**
   *  Description of the Method
   *
   * @param  db             Description of the Parameter
   * @throws  SQLException  Description of the Exception
   */
  public void buildShortList(Connection db) throws SQLException {

    PreparedStatement pst = null;
    ResultSet rs = null;

    StringBuffer sqlSelect = new StringBuffer();
    StringBuffer sqlFilter = new StringBuffer();

    createFilter(db, sqlFilter);

    sqlSelect.append(
        "SELECT o.org_id, o.name, " +
        (hasAlertDate ? "o.alertdate, " : "") +
        (hasExpireDate ? "o.contract_end, " : "") +
        "o.alert, o.entered, o.enteredby, o.owner " +
        "FROM organization o " +
        "WHERE o.org_id >= 0 ");
    pst = db.prepareStatement(sqlSelect.toString() + sqlFilter.toString());
    prepareFilter(pst);
    rs = pst.executeQuery();
    while (rs.next()) {
      Organization thisOrg = new Organization();
      thisOrg.setOrgId(rs.getInt("org_id"));
      thisOrg.setName(rs.getString("name"));
      
      
     
      thisOrg.setEntered(rs.getTimestamp("entered"));
      thisOrg.setEnteredBy(rs.getInt("enteredby"));
      this.add(thisOrg);
    }
    rs.close();
    pst.close();
  }


  /**
   *  Queries the database, using any of the filters, to retrieve a list of
   *  organizations. The organizations are appended, so build can be run any
   *  number of times to generate a larger list for a report.
   *
   * @param  db             Description of Parameter
   * @throws  SQLException  Description of Exception
   * @since                 1.1
   */
  public void buildList(Connection db) throws SQLException {
    PreparedStatement pst = null;
   
    ResultSet rs = queryList(db, pst);
    while (rs.next()) {
      Organization thisOrganization = this.getObject(rs);
      
          this.add(thisOrganization);
        
       
    }
    rs.close();
    if (pst != null) {
      pst.close();
    }
    buildResources(db);
  }


  /**
   *  Gets the object attribute of the OrganizationList object
   *
   * @param  rs             Description of the Parameter
   * @return                The object value
   * @throws  SQLException  Description of the Exception
   */
  public Organization getObject(ResultSet rs) throws SQLException {
    Organization thisOrganization = new Organization(rs);
    return thisOrganization;
  }


  /**
   *  This method is required for synchronization, it allows for the resultset
   *  to be streamed with lower overhead
   *
   * @param  db             Description of the Parameter
   * @param  pst            Description of the Parameter
   * @return                Description of the Return Value
   * @throws  SQLException  Description of the Exception
   */
  public ResultSet queryList(Connection db, PreparedStatement pst) throws SQLException {
	  
	  
    ResultSet rs = null;
    int items = -1;

    StringBuffer sqlSelect = new StringBuffer();
    StringBuffer sqlCount = new StringBuffer();
    StringBuffer sqlFilter = new StringBuffer();
    StringBuffer sqlOrder = new StringBuffer();

    //Need to build a base SQL statement for counting records
    sqlCount.append(
        " SELECT COUNT( distinct o.org_id ) AS recordcount " +
        " FROM organization o "+
        " left join organization_address oa ON (o.org_id = oa.org_id)  ");
    sqlCount.append(" WHERE o.org_id >= 0 and tipologia = 850 and o.enabled = true and o.trashed_date is null ");
        createFilter(db, sqlFilter);

    if (pagedListInfo != null) {
  	 
      //Get the total number of records matching filter
      pst = db.prepareStatement(
          sqlCount.toString() +
          sqlFilter.toString());
      items = prepareFilter(pst);
      rs = pst.executeQuery();
      if (rs.next()) {
        int maxRecords = rs.getInt("recordcount");
        pagedListInfo.setMaxRecords(maxRecords);
      }
      rs.close();
      pst.close();

      //Determine the offset, based on the filter, for the first record to show
      if (!pagedListInfo.getCurrentLetter().equals("")) {
        pst = db.prepareStatement(
            sqlCount.toString() +
            sqlFilter.toString() +
            " AND  " + DatabaseUtils.toLowerCase(db) + "(o.name) < ? ");
        items = prepareFilter(pst);
        pst.setString(++items, pagedListInfo.getCurrentLetter().toLowerCase());
        rs = pst.executeQuery();
        if (rs.next()) {
          int offsetCount = rs.getInt("recordcount");
          pagedListInfo.setCurrentOffset(offsetCount);
        }
        rs.close();
        pst.close();
      }

      //Determine column to sort by
      pagedListInfo.setDefaultSort("o.name", null);
      pagedListInfo.appendSqlTail(db, sqlOrder);

      //Optimize SQL Server Paging
      //sqlFilter.append(" AND  o.org_id NOT IN (SELECT TOP 10 org_id FROM organization " + sqlOrder.toString());
    } else {
      sqlOrder.append("ORDER BY o.name ");
    }

    //Need to build a base SQL statement for returning records
    if (pagedListInfo != null) {
      pagedListInfo.appendSqlSelectHead(db, sqlSelect);
    } else {
      sqlSelect.append("SELECT ");
    }
    
    sqlSelect.append( " " );
  
    	sqlSelect.append(
    	        "o.*, " +
    	        "ct_owner.namelast as o_namelast, ct_owner.namefirst as o_namefirst, " +
    	        "ct_eb.namelast as eb_namelast, ct_eb.namefirst as eb_namefirst, " +
    	        "ct_mb.namelast as mb_namelast, ct_mb.namefirst as mb_namefirst, " +
    	        "'' AS industry_name, '' AS account_size_name, " +
				"oa.city as o_city, oa.state as o_state, oa.postalcode as o_postalcode, oa.county as o_county, " +
				"'' as stage_name "+
    	        "FROM organization o "+ //+ join() + joinAudit() +
    	        " LEFT JOIN contact ct_owner ON (o.owner = ct_owner.user_id) " +
    	        "LEFT JOIN contact ct_eb ON (o.enteredby = ct_eb.user_id) " +
    	        "LEFT JOIN contact ct_mb ON (o.modifiedby = ct_mb.user_id) " +
    	        "LEFT JOIN organization_address oa ON (o.org_id = oa.org_id and oa.address_type = 5) " +
    	        "WHERE o.org_id > 0 and tipologia = 850 and o.enabled = true and o.trashed_date is null " );
    
	  
    pst = db.prepareStatement(
        sqlSelect.toString() + sqlFilter.toString() + sqlOrder.toString() + " ");
    items = prepareFilter(pst);
    
   // pst.setBoolean(++items, true);
   // pst.setBoolean(++items, true);
    if (pagedListInfo != null) {
      pagedListInfo.doManualOffset(db, pst);
    }
    
    
    rs = DatabaseUtils.executeQuery(db, pst, log);
    if (pagedListInfo != null) {
      pagedListInfo.doManualOffset(db, rs);
    }
    return rs;
  }


	

	

/**
   *  Builds a base SQL where statement for filtering records to be used by
   *  sqlSelect and sqlCount
   *
   * @param  sqlFilter  Description of Parameter
   * @param  db         Description of the Parameter
   * @since             1.2
   */
  protected void createFilter(Connection db, StringBuffer sqlFilter) {
    if (sqlFilter == null) {
      sqlFilter = new StringBuffer();
    }
    
   if(orgSiteId >0)
   {
	   sqlFilter.append(" and o.site_id = ? ");
   }
   if(name!= null && !"".equalsIgnoreCase(name))
   {
	   sqlFilter.append(" and o.name ilike ? ");
   }
   if(accountNumber!= null && !"".equalsIgnoreCase(accountNumber))
   {
	   sqlFilter.append(" and o.account_number ilike ? ");
   }
   if(nomeRappresentante!= null && !"".equalsIgnoreCase(nomeRappresentante))
   {
	   sqlFilter.append(" and o.nome_rappresentante ilike ? ");
   }
   if(responsabileAnimale!= null && !"".equalsIgnoreCase(responsabileAnimale))
   {
	   sqlFilter.append(" and o.responsabile_animale ilike ? ");
   }
   if(medicoVeterinario!= null && !"".equalsIgnoreCase(medicoVeterinario))
   {
	   sqlFilter.append(" and o.medico_veterinario ilike ? ");
   }
    
    
    
   // sqlFilter.append(")");
    
  }


  /**
   *  Convenience method to get a list of phone numbers for each contact
   *
   * @param  db             Description of Parameter
   * @throws  SQLException  Description of Exception
   * @since                 1.5
   */
  protected void buildResources(Connection db) throws SQLException {
    Iterator i = this.iterator();
    while (i.hasNext()) {
      Organization thisOrganization = (Organization) i.next();
      thisOrganization.getAddressList().buildList(db);
      //if this is an individual account, populate the primary contact record
      }
  }


  


  

  /**
   *  Sets the parameters for the preparedStatement - these items must
   *  correspond with the createFilter statement
   *
   * @param  pst            Description of Parameter
   * @return                Description of the Returned Value
   * @throws  SQLException  Description of Exception
   * @since                 1.2
   */
  protected int prepareFilter(PreparedStatement pst) throws SQLException {
    int i = 0;
    
   
    
    if(orgSiteId >0)
    {
 	  pst.setInt(++i, orgSiteId);
    }
    if(name!= null && !"".equalsIgnoreCase(name))
    {
 	   pst.setString(++i,"%"+name+"%");
    }
    if(accountNumber!= null && !"".equalsIgnoreCase(accountNumber))
    {
    	 pst.setString(++i,"%"+accountNumber+"%");
    }
    if(nomeRappresentante!= null && !"".equalsIgnoreCase(nomeRappresentante))
    {
    	 pst.setString(++i,"%"+nomeRappresentante+"%");
    }
    if(responsabileAnimale!= null && !"".equalsIgnoreCase(responsabileAnimale))
    {
    	 pst.setString(++i,"%"+responsabileAnimale+"%");
    }
    if(medicoVeterinario!= null && !"".equalsIgnoreCase(medicoVeterinario))
    {
    	 pst.setString(++i,"%"+medicoVeterinario+"%");
    }
    
    return i;
  }


  public Organization getOrgById(int id) {
    Organization result = null;
    Iterator iter = (Iterator) this.iterator();
    while (iter.hasNext()) {
      Organization org = (Organization) iter.next();
      if (org.getOrgId() == id) {
        result = org;
        break;
      }
    }
    return result;
  }
}

