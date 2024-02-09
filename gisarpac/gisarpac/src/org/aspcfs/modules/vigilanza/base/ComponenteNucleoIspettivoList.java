package org.aspcfs.modules.vigilanza.base;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;

import org.aspcfs.modules.base.SyncableList;

public class ComponenteNucleoIspettivoList extends ArrayList implements SyncableList {

	private int id_tipo_controllo_uff_imprese ;
	
	
		
	public int getId_tipo_controllo_uff_imprese() {
		return id_tipo_controllo_uff_imprese;
	}
	public void setId_tipo_controllo_uff_imprese(int id_tipo_controllo_uff_imprese) {
		this.id_tipo_controllo_uff_imprese = id_tipo_controllo_uff_imprese;
	}
	@Override
	public String getTableName() {
		// TODO Auto-generated method stub
		return null;
	}
	@Override
	public String getUniqueField() {
		// TODO Auto-generated method stub
		return null;
	}
	@Override
	public void setLastAnchor(Timestamp arg0) {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void setLastAnchor(String arg0) {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void setNextAnchor(Timestamp arg0) {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void setNextAnchor(String arg0) {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void setSyncType(int arg0) {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void setSyncType(String arg0) {
		// TODO Auto-generated method stub
		
	}
	
	public void creaFiltro (StringBuffer filtro)
	{
		if (id_tipo_controllo_uff_imprese >0)
		{
			filtro.append(" and id_tipo_controllo_uff_imprese = ? ");
		}
	}
	
	public void preparaFiltro (PreparedStatement pst) throws SQLException
	{
		int i =0 ;
		if (id_tipo_controllo_uff_imprese >0)
		{
			pst.setInt(++i, id_tipo_controllo_uff_imprese);
		}
	}
	public void buildList (Connection db) throws SQLException
	{
		/*StringBuffer sql =  new StringBuffer();
		StringBuffer sqlFiltro =  new StringBuffer();
		creaFiltro(sqlFiltro);
		
		sql.append("select * from nucleo_ispettivo_controlli_ufficiali where 1=1 ");
		PreparedStatement pst = db.prepareStatement(sql.toString()+sqlFiltro.toString());
		preparaFiltro(pst);
		
		ResultSet rs = pst.executeQuery();
		while (rs.next())
		{
			ComponenteNucleoIspettivo comp = new ComponenteNucleoIspettivo();
			comp.buildRecord(rs);
			this.add(comp);
			
		}*/
		
		
		 
	}
	




}
