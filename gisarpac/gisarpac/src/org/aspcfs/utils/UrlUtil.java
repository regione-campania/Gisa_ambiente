package org.aspcfs.utils;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.net.URLConnection;

public class UrlUtil
{
	public static String getUrlResponse( String urlString )
	{
		String ret = null;
		
		try
		{
			URL					url = new URL( urlString );
			URLConnection		uc = url.openConnection();
			uc.setConnectTimeout(3000);
//			uc.setConnectTimeout( 10000 );
			uc.setDoOutput( true );
			OutputStreamWriter	wr = new OutputStreamWriter( uc.getOutputStream() );
			wr.flush();
			wr.close();
			BufferedReader	br		= new BufferedReader( new InputStreamReader( uc.getInputStream() ) );
			StringBuffer	sb		= new StringBuffer();
			String			temp	= null;
			while( (temp = br.readLine()) != null )
			{
				sb.append( temp );
			}
			br.close();
			
			ret = sb.toString();
		}
		catch ( Exception e )
		{
			e.printStackTrace();
		}
		
		return ret;
	}
}
