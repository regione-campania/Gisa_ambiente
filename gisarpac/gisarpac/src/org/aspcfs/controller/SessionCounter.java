package org.aspcfs.controller;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

public class SessionCounter implements HttpSessionListener
{
	private static int activeSessions = 0;

  
	public void sessionCreated(HttpSessionEvent arg0)
	{
		activeSessions++;
	} 

	public void sessionDestroyed(HttpSessionEvent arg0)
	{
		if( activeSessions > 0 )
		{
			activeSessions--;
		}
	}

	public static int getActiveSessions()
	{
		return activeSessions;
	}

}
