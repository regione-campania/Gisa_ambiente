package org.aspcfs.modules.login.utils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CheckLock {

	
	public static boolean checkLocked(Connection db, String ip, String username) throws SQLException{
		boolean locked = false;
		PreparedStatement pst = db.prepareStatement("select * from check_locked(?, ?)");
		pst.setString(1, ip);
		pst.setString(2, username);
		ResultSet rs = pst.executeQuery();
		while (rs.next())
			locked = rs.getBoolean(1);
		return locked;
	}
	
	public static int resetLock(Connection db, String ip, String username) throws SQLException{
		int badcount = -1;
		PreparedStatement pst = db.prepareStatement("select * from reset_lock(?, ?)");
		pst.setString(1, ip);
		pst.setString(2, username);
		ResultSet rs = pst.executeQuery();
		while (rs.next())
			badcount = rs.getInt(1);
		return badcount;
	}
	
	public static int incLock(Connection db, String ip, String username) throws SQLException{
		int badcount = -1;
		PreparedStatement pst = db.prepareStatement("select * from inc_lock(?, ?)");
		pst.setString(1, ip);
		pst.setString(2, username);
		ResultSet rs = pst.executeQuery();
		while (rs.next())
			badcount = rs.getInt(1);
		return badcount;
	}
	
}
