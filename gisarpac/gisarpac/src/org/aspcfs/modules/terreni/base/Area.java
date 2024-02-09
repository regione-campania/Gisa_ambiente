package org.aspcfs.modules.terreni.base;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;

import com.darkhorseventures.framework.actions.ActionContext;

public class Area implements Serializable{

	private static final long serialVersionUID = 1L;
	
	private int id;
	private int idPadre;
	private String codiceSito;
	private String idSito;
	private int idProvincia;
	private int idComune;
	private String descrizioneProvincia;
	private String descrizioneComune;
	private String foglioCatastale;
	private String particellaCatastale;
	private String classeRischio;
	private String coordinateX;
	private String coordinateY;
	private String area;
	private String note;
	private Timestamp entered;
	private int enteredBy;
	
	private ArrayList<Subparticella> listaSubparticelle = new ArrayList<Subparticella>();
	
	public Area() {
		// TODO Auto-generated constructor stub
	}
	
	public Area(Connection db, int id) throws SQLException {
		PreparedStatement pst = db.prepareStatement("select * from get_dettaglio_particella(?)"); 
		pst.setInt(1, id);
		ResultSet rs = pst.executeQuery();
		if (rs.next()){
			buildRecord(rs);
			setListaSubparticelle(db);
		}
		
	}
	private void setListaSubparticelle(Connection db) throws SQLException {
		listaSubparticelle = Subparticella.buildListByIdAreaParticella(db, id);		
	}

	public Area(ResultSet rs) throws SQLException {
		buildRecord(rs);
		}

	public Area(ActionContext context) {
		codiceSito = context.getRequest().getParameter("codiceSito");
		idSito = context.getRequest().getParameter("idSito");
		idProvincia = Integer.parseInt((String) context.getRequest().getParameter("idProvincia"));
		idComune = Integer.parseInt((String) context.getRequest().getParameter("idComune"));
		foglioCatastale = context.getRequest().getParameter("foglioCatastale");
		particellaCatastale = context.getRequest().getParameter("particellaCatastale");
		classeRischio = context.getRequest().getParameter("classeRischio");
		coordinateX = context.getRequest().getParameter("coordinateX");
		coordinateY = context.getRequest().getParameter("coordinateY");
		area = context.getRequest().getParameter("area");
		note = context.getRequest().getParameter("note");
	}

	private void buildRecord(ResultSet rs) throws SQLException {
		id = rs.getInt("id");
		idPadre = rs.getInt("id_padre");
		codiceSito = rs.getString("codice_sito");
		idSito = rs.getString("id_sito");
		idProvincia = rs.getInt("id_provincia");
		idComune = rs.getInt("id_comune");
		descrizioneProvincia = rs.getString("descrizione_provincia");
		descrizioneComune = rs.getString("descrizione_comune");
		foglioCatastale = rs.getString("foglio_catastale");
		particellaCatastale = rs.getString("particella_catastale");
		classeRischio = rs.getString("classe_rischio");		
		coordinateX = rs.getString("coordinate_x");
		coordinateY = rs.getString("coordinate_y");
		area = rs.getString("area");
		note = rs.getString("note");
		entered = rs.getTimestamp("entered");
		enteredBy = rs.getInt("entered_by");		
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getCodiceSito() {
		return codiceSito;
	}

	public void setCodiceSito(String codiceSito) {
		this.codiceSito = codiceSito;
	}

	public String getIdSito() {
		return idSito;
	}

	public void setIdSito(String idSito) {
		this.idSito = idSito;
	}

	public int getIdProvincia() {
		return idProvincia;
	}

	public void setIdProvincia(int idProvincia) {
		this.idProvincia = idProvincia;
	}

	public int getIdComune() {
		return idComune;
	}

	public void setIdComune(int idComune) {
		this.idComune = idComune;
	}

	public String getFoglioCatastale() {
		return foglioCatastale;
	}

	public void setFoglioCatastale(String foglioCatastale) {
		this.foglioCatastale = foglioCatastale;
	}

	public String getParticellaCatastale() {
		return particellaCatastale;
	}

	public void setParticellaCatastale(String particellaCatastale) {
		this.particellaCatastale = particellaCatastale;
	}

	public String getClasseRischio() {
		return classeRischio;
	}

	public void setClasseRischio(String classeRischio) {
		this.classeRischio = classeRischio;
	}

	public String getCoordinateX() {
		return coordinateX;
	}

	public void setCoordinateX(String coordinateX) {
		this.coordinateX = coordinateX;
	}

	public String getCoordinateY() {
		return coordinateY;
	}

	public void setCoordinateY(String coordinateY) {
		this.coordinateY = coordinateY;
	}

	public String getArea() {
		return area;
	}

	public void setArea(String area) {
		this.area = area;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public Timestamp getEntered() {
		return entered;
	}

	public void setEntered(Timestamp entered) {
		this.entered = entered;
	}

	public int getEnteredBy() {
		return enteredBy;
	}

	public void setEnteredBy(int enteredBy) {
		this.enteredBy = enteredBy;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public ArrayList<Subparticella> getListaSubparticelle() {
		return listaSubparticelle;
	}

	public void setListaSubparticelle(ArrayList<Subparticella> listaSubparticelle) {
		this.listaSubparticelle = listaSubparticelle;
	}

	public int getIdPadre() {
		return idPadre;
	}

	public void setIdPadre(int idPadre) {
		this.idPadre = idPadre;
	}

	public String getDescrizioneProvincia() {
		return descrizioneProvincia;
	}

	public void setDescrizioneProvincia(String descrizioneProvincia) {
		this.descrizioneProvincia = descrizioneProvincia;
	}

	public String getDescrizioneComune() {
		return descrizioneComune;
	}

	public void setDescrizioneComune(String descrizioneComune) {
		this.descrizioneComune = descrizioneComune;
	}

	public void insert(Connection db, int userId) throws SQLException {
		PreparedStatement pst = null;
		String sql = "select * from insert_area(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
		pst = db.prepareStatement(sql);
		int i = 0;
		pst.setString(++i, codiceSito);
		pst.setString(++i, idSito);
		pst.setInt(++i, idProvincia);
		pst.setInt(++i, idComune);
		pst.setString(++i, foglioCatastale);
		pst.setString(++i, particellaCatastale);
		pst.setString(++i, classeRischio);
		pst.setString(++i, coordinateX);
		pst.setString(++i, coordinateY);
		pst.setString(++i, area);
		pst.setString(++i, note);
		pst.setInt(++i, userId);
		
		ResultSet rs = pst.executeQuery();
		
		if(rs.next()){
			id = rs.getInt(1);
		}		
	}

	public static ArrayList<Area> buildList(Connection db, String codiceSito, int idProvincia, int idComune) throws SQLException {
		ArrayList<Area> lista = new ArrayList<Area>();
		PreparedStatement pst = db.prepareStatement("select * from get_lista_aree(?, ?, ?)");
		pst.setString(1, codiceSito);
		pst.setInt(2, idProvincia);
		pst.setInt(3, idComune);
		ResultSet rs = pst.executeQuery();
		while (rs.next()){
			Area area = new Area(rs);
			lista.add(area);
		}
	return lista;
	}

	public void update(Connection db, int userId) throws SQLException {
		PreparedStatement pst = null;
		String sql = "select * from update_area(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
		pst = db.prepareStatement(sql);
		int i = 0;
		pst.setInt(++i, id);
		pst.setString(++i, codiceSito);
		pst.setString(++i, idSito);
		pst.setInt(++i, idProvincia);
		pst.setInt(++i, idComune);
		pst.setString(++i, foglioCatastale);
		pst.setString(++i, particellaCatastale);
		pst.setString(++i, classeRischio);
		pst.setString(++i, coordinateX);
		pst.setString(++i, coordinateY);
		pst.setString(++i, area);
		pst.setString(++i, note);
		pst.setInt(++i, userId);
		
		ResultSet rs = pst.executeQuery();
		
		if(rs.next()){
			id = rs.getInt(1);
		}		
	}

	
}