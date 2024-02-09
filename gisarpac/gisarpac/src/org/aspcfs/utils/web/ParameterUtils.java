package org.aspcfs.utils.web;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;

import org.aspcfs.modules.base.Parameter;

public class ParameterUtils
{
	public static ArrayList<Parameter> list( HttpServletRequest req, String prefisso )
	{
		ArrayList<Parameter> ret = new ArrayList<Parameter>();
		
		Enumeration e = (Enumeration)req.getParameterNames();
		
		while(e.hasMoreElements())
		{
			String nome_parametro = (String)e.nextElement();
			if( nome_parametro.startsWith( prefisso ) )
			{
				
				Parameter p = new Parameter();
				
				p.setPrefisso( prefisso );
				p.setNome( nome_parametro );
				for(String s : req.getParameterValues( nome_parametro )){
					p.getValori().add(s);
					p.setValore(s);
				}
				
				try
				{
					String id = p.getNome().replace( prefisso, "" );
					if(id != null && !id.equals("")){
						p.setId( Integer.parseInt( id ) );
					}
				}
				catch (Exception e1)
				{
					e1.printStackTrace();
				}
				//System.out.println("id type "+nome_parametro+" valore "+req.getParameter( nome_parametro ) );
				ret.add( p );
			}
		}
		Collections.sort( ret );
		return ret;
	}
	
	
	public static Parameter get( HttpServletRequest req, String nomeParametro )
	{
	
		
				Parameter p = new Parameter();
				p.setPrefisso( nomeParametro );
				p.setNome( nomeParametro );
				p.setValore(req.getParameter(nomeParametro));
			
				System.out.println("id type "+nomeParametro+" valore "+req.getParameter( nomeParametro ) );
				
		
		
		return p;
	}
}
