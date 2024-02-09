package org.aspcfs.utils;

import java.lang.reflect.Method;

import javax.servlet.http.HttpSession;

import org.aspcfs.modules.login.beans.UserBean;
import org.directwebremoting.AjaxFilter;
import org.directwebremoting.AjaxFilterChain;
import org.directwebremoting.WebContextFactory;
import org.directwebremoting.extend.LoginRequiredException;
  
public class DwrSessionFilter implements AjaxFilter {
    public Object doFilter(Object obj, Method method, Object[] params, AjaxFilterChain chain) throws Exception {
 
    	
    	HttpSession sessione  = WebContextFactory.get().getSession();
    	UserBean user = (UserBean) sessione.getAttribute("User");
    	
  
    	
    	
    	//Check if session has timedout/invalidated
	    if( WebContextFactory.get().getSession( false ) == null || user==null) {
	        //Throw an exception
	        LoginRequiredException f = new LoginRequiredException("Sessione di Lavoro Scaduta.");
	        StackTraceElement[] stack = new StackTraceElement[1];
	        stack[0] = new StackTraceElement("DwrSessionFilter", "doFilter", "DwrSessionFilter.java", 21);
	        f.setStackTrace(stack);
	        throw f;
	    } 
	    
	    return chain.doFilter( obj, method, params );
//	    else {
//	    	String browser = null;
//	    	if (browser==null){
//	    		browser = user.getBrowserId();
//	    		if (browser.equalsIgnoreCase("moz"))
//	    			browser = "Firefox";
//	    	}
//	    	
//	    	if (browser.contains("Firefox")){   
//	    		return chain.doFilter( obj, method, params );
//	    	} else {
//	    		try {
//	    			return chain.doFilter( obj, method, params );
//	    		} catch (Exception e){
//	    			LoginRequiredException f = new LoginRequiredException("[BROWSER] Operazione non consentita con il browser utilizzato. I dati inseriti non saranno salvati.");
//		            StackTraceElement[] stack = new StackTraceElement[1];
//			        stack[0] = new StackTraceElement("DwrSessionFilter", "doFilter", "DwrSessionFilter.java", 21);
//			        f.setStackTrace(stack);
//		            throw f;
//	    		}        
//	    	}
//	    }
 
    	
     	
    }
}
  