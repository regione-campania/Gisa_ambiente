/*
 *  Copyright(c) 2004 Concursive Corporation (http://www.concursive.com/) All
 *  rights reserved. This material cannot be distributed without written
 *  permission from Concursive Corporation. Permission to use, copy, and modify
 *  this material for internal use is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies. CONCURSIVE
 *  CORPORATION MAKES NO REPRESENTATIONS AND EXTENDS NO WARRANTIES, EXPRESS OR
 *  IMPLIED, WITH RESPECT TO THE SOFTWARE, INCLUDING, BUT NOT LIMITED TO, THE
 *  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY PARTICULAR
 *  PURPOSE, AND THE WARRANTY AGAINST INFRINGEMENT OF PATENTS OR OTHER
 *  INTELLECTUAL PROPERTY RIGHTS. THE SOFTWARE IS PROVIDED "AS IS", AND IN NO
 *  EVENT SHALL CONCURSIVE CORPORATION OR ANY OF ITS AFFILIATES BE LIABLE FOR
 *  ANY DAMAGES, INCLUDING ANY LOST PROFITS OR OTHER INCIDENTAL OR CONSEQUENTIAL
 *  DAMAGES RELATING TO THE SOFTWARE.
 */
package com.darkhorseventures.framework.servlets;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.net.URL;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;
import java.util.StringTokenizer;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.Servlet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Templates;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.aspcfs.controller.ApplicationPrefs;
import org.aspcfs.modules.login.beans.UserBean;
import org.aspcfs.utils.ApplicationPropertiesStart;

import com.darkhorseventures.framework.actions.Action;
import com.darkhorseventures.framework.actions.ActionContext;
import com.darkhorseventures.framework.actions.Beans;
import com.darkhorseventures.framework.actions.Resource;
import com.darkhorseventures.framework.beans.Populate;

/**
 * This servlet is the core of a web application. All requests go through it
 * and various Hooks are called to operate on the request, if configured in the
 * application XML to do so. <p>
 * <p/>
 * ControllerInitHook: When the servlet is first initialized <p>
 * <p/>
 * ControllerHook: A security check on every request <p>
 * <p/>
 * ControllerMainMenuHook: When an action is going to result in a JSP with a
 * layout, the MainMenuHook configures aspects of the page <p>
 * <p/>
 * ControllerGobalItemsHook: For items that a user may or may not be able to
 * access, usually based on Permissions and Preferences <p>
 * <p/>
 * Ideas: TransactionLogHook
 *
 *@author     kevin duffey
 * @author matt rajkowski
 * @version $Id: ControllerServlet.java,v 1.8 2001/08/02 15:45:49 mrajkowski
 *          Exp $
 * @created July 1, 2001
 */
public class ControllerServlet
     extends HttpServlet implements ControllerInitHook, ControllerHook, ControllerMainMenuHook,
    ControllerGlobalItemsHook, ControllerDestroyHook {
  private Map actions = new HashMap();
  private Map classes = new HashMap();
  private Map xslCache = new HashMap();
  private boolean useXSLCache = false;
  private String populateAttribute = null;
  private Populate populateClassInstance = null;
  private ControllerInitHook initHook = null;
  private ControllerHook hook = null;
  private ControllerMainMenuHook mainMenuHook = null;
  private ControllerGlobalItemsHook globalItemsHook = null;
  private ControllerDestroyHook destroyHook = null;
  private String nestedAttribute = "_";
  // this is the character used in auto-population separation..used as the string to figure out nested objects in the form elements
  private String indexAttribute = "-";
  // used to determine if an index value is used during auto-population
  private TransformerFactory tFactory = TransformerFactory.newInstance();
  private XMLConfigLoader xmlConfig = new XMLConfigLoader(actions);
  private boolean cacheModules = true;
  final static long serialVersionUID = 772485669527451267L;


  /**
   *  Returns the response output mode by using the Templates XSL attribute
   *  <xsl:output method=""/> tag otherwise it uses HTML output
   *
   *@param  templates  Description of Parameter
   * @return The ResponseOutput value
   * @since 1.0
   */
  public String getResponseOutput(Templates templates) {
    if ((templates == null) || (templates.getOutputProperties() == null)) {
      return "text/html";
    }
    // default to text/html output

    Properties p = templates.getOutputProperties();
    String encoding = p.getProperty(OutputKeys.ENCODING);
    String media = p.getProperty(OutputKeys.MEDIA_TYPE);
    if (media != null) {
      if (encoding != null) {
        return media + "; charset=" + encoding;
      }
      return media;
    } else {
      String method = p.getProperty(OutputKeys.METHOD);
      if (method != null) {
        if (method.equals("html")) {
          return "text/html";
        } else
            if (method.equals("text")) {
          return "text/plain";
        } else {
          return "text/xml";
        }
      } else {
        return "text/html";
      }
    }
  }


  /**
   * Gets the XSLDocument attribute of the ControllerServlet object
   *
   *@param  xsl  Description of Parameter
   * @return The XSLDocument value
   * @since 1.0
   */
  public StreamSource getXSLDocument(String xsl) {
    InputStream inputStream = getServletContext().getResourceAsStream(xsl);
    return new StreamSource(inputStream);
  }

  private static ServletConfig configProxy ;

  /**
     * Called when this servlet is first called upon.
     *
     * @param config Description of Parameter
     * @throws ServletException Description of Exception
     * @since 1.0
     */
    public void init(ServletConfig config) throws ServletException {
    	
    	
    	
    	configProxy =  (ServletConfig) Proxy.newProxyInstance(getClass().getClassLoader(),new Class[]{ServletConfig.class},
    			
    			new InvocationHandler() {
					
					@Override
					 public Object invoke(final Object proxy, final Method method, final Object[] args) throws Throwable {  
		                if ("getInitParameter".equals(method.getName())) {  
		                	
		                    return ControllerServlet.getInitParametersFromProperties((String) method.invoke(config, args));  
		                }  
		                else {  
		                    return method.invoke(config, args);  
		                }  
		            }  
				} 
           
          );  
      super.init(configProxy);
      // lets get the possible configuration parameters if they exist.
      // See if there is an init parameter designating a class to use as a ControllerInitHook.
      // If so, execute the hook.  This could be used for storing a Connection Pool in
      // the application scope, for example.
      if (configProxy.getInitParameter("InitHook") != null) {
        // the parameter exists, so try to instantiate the class by the name of the
        // parameter value.
        try {
          initHook = (ControllerInitHook) Class.forName(
        		  configProxy.getInitParameter("InitHook")).newInstance();
          initHook.executeControllerInit(configProxy);
        } catch (Exception e) {
          System.out.println(e.toString());
          initHook = null;
        }
      }
      // if a ControllerInitHook class could not be loaded or the init parameter
      // was not specified, use this class which implements ControllerInitHook
      // for the hook interface implementation
      if (initHook == null) {
        initHook = this;
      }

      // See if there is an init parameter designating a class to use as a ControllerHook.
    // If so, right before the action class method is called a securityCheck() method
    // is called, giving the ability for any application to make sure something is in place
    // before calling the method. This could be used for example to make sure a user is logged
    // in before accessing specific pages in a certain path.
    if (configProxy.getInitParameter("Hook") != null) {
      // the parameter exists, so try to instantiate the class by the name of the
      // parameter value.
      try {
        hook = (ControllerHook) Class.forName(configProxy.getInitParameter("Hook")).newInstance();
      } catch (Exception e) {
        System.out.println(e.toString());
        hook = null;
      }
    }
    if (hook == null) {
      hook = this;
    }

    // See if there is an init parameter designating a class to use as a MainMenuHook.
    // If so, right after the LayoutManager hook class method is called a generateMenu() method
    // is called, giving the ability for any application to base the JSP output on a template.
    if (configProxy.getInitParameter("MainMenuHook") != null) {
      // the parameter exists, so try to instantiate the class by the name of the
      // parameter value.
      try {
        mainMenuHook = (ControllerMainMenuHook) Class.forName(
        		configProxy.getInitParameter("MainMenuHook")).newInstance();
        mainMenuHook.executeControllerMainMenu(configProxy);
      } catch (Exception e) {
        System.out.println(e.toString());
        mainMenuHook = null;
      }
    }
    if (mainMenuHook == null) {
      mainMenuHook = this;
    }

    // See if there is an init parameter designating a class to use as a GlobalItemsHook.
    // If so, right after the MainMenu hook class method is called a generateItem() method
    // is called, giving the ability for any application to base the JSP output on a template.
    if (configProxy.getInitParameter("GlobalItemsHook") != null) {
      // the parameter exists, so try to instantiate the class by the name of the
      // parameter value.
      try {
        globalItemsHook = (ControllerGlobalItemsHook) Class.forName(
        		configProxy.getInitParameter("GlobalItemsHook")).newInstance();
      } catch (Exception e) {
        System.out.println(e.toString());
        globalItemsHook = null;
      }
    }
    if (globalItemsHook == null) {
      globalItemsHook = this;
    }

    // See if there is an init parameter designating a class to use as a ControllerDestroyHook.
    // If so, execute the hook.  This could be used for closing a Connection Pool or
    // notifications, for example.
    if (configProxy.getInitParameter("DestroyHook") != null) {
      try {
        destroyHook = (ControllerDestroyHook) Class.forName(
        		configProxy.getInitParameter("DestroyHook")).newInstance();
        destroyHook.executeControllerDestroyInit(configProxy);
      } catch (Exception e) {
        System.out.println(e.toString());
        destroyHook = null;
      }
    }
    if (destroyHook == null) {
      destroyHook = this;
    }
    if (configProxy.getInitParameter("ActionConfig") != null) {
      StringTokenizer strtkn = new StringTokenizer(configProxy.getInitParameter("ActionConfig"), ",");
      while (strtkn.hasMoreTokens()) {
        xmlConfig.addFile(strtkn.nextToken().trim());
      }
    } else {
      xmlConfig.addFile("theseus.xml");
    }

    // load the configuration file
    xmlConfig.load(configProxy.getServletContext());

    // if an init parameter exists to specify the character or string to use
    // during autopopulation of a form/bean, grab the string which is used
    // to figure out the separation of objects in the form element. Default
    // is _.
    if (configProxy.getInitParameter("PopulateNestedAttribute") != null) {
      nestedAttribute = configProxy.getInitParameter("PopulateNestedAttribute");
    }

    // check to see what the CacheModule parameter is set to (for development)
    if (configProxy.getInitParameter("CacheModules") != null) {
      String cacheModulesInit = configProxy.getInitParameter("CacheModules");
      if (cacheModulesInit.equals("false")) {
        cacheModules = false;
        System.out.println("Modules are NOT being cached.");
      }
    }

    // if an init parameter exists to specify the charater or string to use
    // during autopopulation of a form/bean for indexing, grab the string which
    // is used to figure out the separation of objects in the form element. The
    // default is -.
    if (configProxy.getInitParameter("PopulateIndexAttribute") != null) {
      indexAttribute = configProxy.getInitParameter("PopulateIndexAttribute");
    }

    String populateClassName = configProxy.getInitParameter("PopulateClassName");
    populateAttribute = configProxy.getInitParameter("PopulateAttributeName");

    // if a bean utils class is not specified, use the default one packages in this
    // framework. If this parameter exists, the class must implement the Populate interface
    // otherwise the default will be used.

    if (populateClassName == null) {
      populateClassName = "org.theseus.beans.BeanUtils";
    }

    // try loading the populate class now. First see if it exists in the
    // servlet context. If not, load it then put it there.
    try {
      // only do this if the instance is null. If the instance is not null,
      // then for what ever reason the init() mehtod is being called again, and it
      // should not be.
      if (populateClassInstance == null) {
        populateClassInstance = (Populate) Class.forName(populateClassName).newInstance();
      }
    } catch (Exception e) {
    }

    // now get the populate command parameter attribute name
    if (populateAttribute == null) {
      populateAttribute = "auto-populate";
    }

    // find out if the user wants to pre-load all xsl pages. If so,
    // we use the xslCache Hashmap. If not, each XSL is loaded upon each
    // request. The use of cache should provide a much faster transformation
    // process, at the expense of memory to store the xsl pages at all times.
    if (configProxy.getInitParameter("UseXSLCache") != null) {
      if (configProxy.getInitParameter("UseXSLCache").equalsIgnoreCase("true")) {
        useXSLCache = true;
      }
    }

    if (configProxy.getInitParameter("PreloadXSL") != null) {
      if (configProxy.getInitParameter("PreloadXSL").equalsIgnoreCase("true") && useXSLCache) {
        // the application is requesting to pre-load ALL xsl pages into the cache
        // before they are used. At this point the resource Actions have been loaded
        // so we need to get them from the Actions table.
        Iterator i = actions.values().iterator();
        while (i.hasNext()) {
          Action action = (Action) i.next();

          Iterator i2 = action.getResources().values().iterator();
          while (i2.hasNext()) {
            Resource resource = (Resource) i2.next();
            if (resource.getXSL() != null && resource.getXSL().length() > 0) {
              // there is an XSL page associated with this Resource, so
              // load it into cache and store it under its resource name.

              // first make sure its not already in the table.
              if (xslCache.get(resource.getXSL()) == null) {
                InputStream inputStream = getServletContext().getResourceAsStream(resource.getXSL());
                StreamSource xslStream = new StreamSource(inputStream);
                try {
                  Templates templates = tFactory.newTemplates(xslStream);
                  xslCache.put(resource.getXSL(), templates);
                  // store the pre-compiled XSL
                  inputStream.close();
                } catch (TransformerConfigurationException tce) {
                } catch (Exception e2) {
                }
              }
            }
          }
        }
      }
    }
  }


  /**
   *  Called when the servlet container closes down.
   *
   * @since 1.0
   */
  public void destroy() {
    destroyHook.executeControllerDestroy();
  }


  /**
   *  This method handles all incoming actions (both post and get). It will
   *  remove the extension being passed in as well as the last / in the request
   *  URI, then deduct from that the proper action to call. The action is looked
   *  up via a hashtable of already loaded classes (single instances of action
   *  classes), and if the action exists, the instance is called, passing to it
   *  the servlet, request, response and one or more beans mapped to the
   *  particular action. Finally, it gets a result string back from the method
   *  in the action it calls, and forwards (or redirects) to a JSP page that is
   *  mapped to the result string returned. This method will trap all
   *  exceptions, and forward them via the MESSAGE request attribute to what
   *  ever JSP page is forwarded to.
   *
   *@param  request   Description of Parameter
   *@param  response  Description of Parameter
 * @throws IOException 
   */
  public void service(HttpServletRequest request, HttpServletResponse response) throws IOException {
	  long before = System.currentTimeMillis();
  	String actionPath = getActionPath(request);
    Object beanRef = null;
    if (System.getProperty("DEBUG") != null) {
      System.out.println("");
      System.out.println("** Requested action: " + actionPath);
      System.out.println("** " + new java.util.Date());
    }
		
    String command = "" ;
    String commandOld = request.getParameter("commandOld");

    UserBean user = null ;
    if (request.getSession().getAttribute	("User")!=null)
    	user =(UserBean)request.getSession().getAttribute	("User");
    
    
    try {
      request.setCharacterEncoding("UTF-8");
    } catch (Exception e) {
      if (System.getProperty("DEBUG") != null) {
        System.out.println("ControllerServlet-> Unsupported encoding");
      }
    }
    // we have the action name derived from the action path passed in, so now we need to
    // look it up in our list of Actions to see if there is a Action for this action.
    // If so, we get the Action class name, and see if there is a class already
    // loaded (only a single instance of each class is allowed for performance reasons).
    // If the class is loaded, we get its instance reference and call the
    // executeCommandXXX() method. If the class is not loaded, we try to load the
    // class, store it in the classes Hashtable, then call the executeCommandXXX() method.

    if (actions.containsKey(actionPath)) {
      Action action = (Action) actions.get(actionPath);
     
      // now we will perform the security check, in case an application wants a specific
      // object to exist in the HttpSe 	ssion, for example.
      // This method returns null (or an empty string), where as if there is a problem
      // the method flags, it returns a string that is used to indicate the resource
      // lookup when forwarding (or transforming xsl) to.
      String res = hook.securityCheck(this, request);
      if (res != null && res.length() > 0) {
        if (System.getProperty("DEBUG") != null) {
          System.out.println("> Security redirect: " + res);
        }
       
			forward(res, action, request, response,command);
		
        return;
      }

      // now we will get each Beans reference from this actions
      // list of beans.
      Iterator i = action.getBeans().values().iterator();
      ActionContext context = null;

      while (i.hasNext()) {
        Beans beans = (Beans) i.next();
        // next, we get the bean reference from the scope the
        // bean is stored in.
        switch (beans.getBeanScope()) {
            case 1:
              // request scope
              beanRef = request.getAttribute(beans.getBeanName());
              break;
            case 2:
              // session scope
              beanRef = request.getSession(true).getAttribute(beans.getBeanName());
              break;
            case 3:
              // application/global scope (not thread safe)
              beanRef = getServletContext().getAttribute(beans.getBeanName());
              break;
        }

        // if its not found, create it.
        if (beanRef == null) {
          try {
            beanRef = Class.forName(beans.getClassName()).newInstance();
          } catch (ClassNotFoundException cnfe) {
            System.out.println("Class not found exception. MESSAGE = " + cnfe.getMessage());
          } catch (InstantiationException ie) {
            System.out.println("Instantiation Exception. MESSAGE = " + ie.getMessage());
          } catch (IllegalAccessException iae) {
            System.out.println("Illegal Access Exception. MESSAGE = " + iae.getMessage());
          }

          // store it in the scope it is assigned to,
          switch (beans.getBeanScope()) {
              case 1:
                // request scope
            	  request.setAttribute(beans.getBeanName(), beanRef);
                break;
              case 2:
                // session scope
                request.getSession(true).setAttribute(beans.getBeanName(), beanRef);
                break;
              case 3:
                // application/global scope (not thread safe)
                getServletContext().setAttribute(beans.getBeanName(), beanRef);
                break;
          }
        }

        // we now check to see if a request parameter with a name that matches
        // the populateAttribute name exists. If so, we call upon the
        // populateClassInstance.populateObject() method, but only if the
        // populateClassInstance is not null AND it implements the Populate
        // interface.
        if (request.getParameter(populateAttribute) != null) {
          if (populateClassInstance != null) {
            if (System.getProperty("DEBUG") != null) {
              System.out.println(
                  "> Auto populating a bean: " + beans.getClassName());
            }
            populateClassInstance.populateObject(beanRef, request, nestedAttribute, indexAttribute);
          }
        }
      }

      context = new ActionContext(this, beanRef, action, request, response);

      // at this point, we have a newly created ActionContext and an auto-populated
      // javabean (if the request attribute was passed in to indicate so). We are now ready to
      // attempt to get the class instance if it exists (already loaded), or if not, we
      // will dynamically load it (one time only) and store it in our lists of classes.
      Object classRef = null;
      if (classes.containsKey(actionPath) && cacheModules) {
        classRef = classes.get(actionPath);
      } else {
        try {
          classRef = Class.forName(action.getActionClassName()).newInstance();
          classes.put(actionPath, classRef);
        } catch (ClassNotFoundException cnfe) {
          System.out.println("Class Not Found Exception. MESSAGE = " + cnfe.getMessage());
        } catch (InstantiationException ie) {
          System.out.println("Instantiation Exception. MESSAGE = " + ie.getMessage());
        } catch (IllegalAccessException iae) {
          System.out.println("Illegal Argument Exception. MESSAGE = " + iae.getMessage());
        }
      }

      String result = null;

      try {
        // now we are ready for the next to last step..to call upon the method in the
        // action class instance we have.
        if (context == null) {
          System.out.println("Context is null");
        }
        if (classRef == null) {
          System.out.println("Class ref is null");
        }
        //Debug performance
        if ("2".equals(System.getProperty("DEBUG"))) {
          long actionStartTime = System.currentTimeMillis();
          if (request.getAttribute("debug.action.startTime") != null) {
            actionStartTime = Long.parseLong(
                (String) request.getAttribute("debug.action.startTime"));
          } else {
            request.setAttribute(
                "debug.action.startTime", String.valueOf(actionStartTime));
          }
          Method method = classRef.getClass().getMethod(
              "executeCommand" + context.getCommand(), new Class[]{context.getClass()});
          result = (String) method.invoke(classRef, new Object[]{context});
          long actionExecuteTime = System.currentTimeMillis() - actionStartTime;
          request.setAttribute(
              "debug.action.time", String.valueOf(actionExecuteTime));
          System.out.println(
              "ControllerServlet-> Action Took: " + actionExecuteTime + " ms");
        } else {
        	
        	if(  request.getSession().getAttribute("User")!=null && ! action.getActionClassName().contains("GestioneDocumenti") && ! action.getActionClassName().contains("Login"))
        	{
        		
        		if(user.isPerformAction()==true )
        		{
        			
        			user.setPerformAction(false);
        			result = "ActionPerforming";
        			
        			
        		}
        		else
        		{
        			
        			  
        			command=context.getCommand();
        			
        	          
        		  Method method = classRef.getClass().getMethod(
        	              "executeCommand" + context.getCommand(), new Class[]{context.getClass()});
        	          result = (String) method.invoke(classRef, new Object[]{context});
        	          
        	          
        	          /*Era Commentato*/
        	          if (!result.contains("Json"))
        	          {
        	          user.setPerformAction(true);
        	          request.getSession().setAttribute("User",user);
        	          }
        	          
        	          UserBean user2 = null ;
        	          try
        	          {
        	          if (request.getSession().getAttribute	("User")!=null)
        	          	user2 =(UserBean)request.getSession().getAttribute	("User");
        	          
        	          if (user2!=null)
        	    	  {
        	          	user2.setPerformAction(false);
        	  	          request.getSession().setAttribute("User",user2);
        	    	  }
        	          }catch(Exception e)
        	          {
        	        	  
        	          }
        	       
        		}
        		
        	}
        	else
        	{
          Method method = classRef.getClass().getMethod(
              "executeCommand" + context.getCommand(), new Class[]{context.getClass()});
          result = (String) method.invoke(classRef, new Object[]{context});
        	}
        }
      } catch (NoSuchMethodException nm) {
        System.out.println(
            "No Such Method Exception for method executeCommand" + context.getCommand() + ". MESSAGE = " + nm.getMessage());
        UserBean user2 = null ;
        if (request.getSession().getAttribute	("User")!=null)
        	user2 =(UserBean)request.getSession().getAttribute	("User");
        
        if (user2!=null)
  	  {
        	user2.setPerformAction(false);
	          request.getSession().setAttribute("User",user2);
  	  }
      } catch (IllegalAccessException ia) {
        System.out.println("Illegal Access Exception. MESSAGE = " + ia.getMessage());
        
        
        UserBean user2 = null ;
        if (request.getSession().getAttribute	("User")!=null)
        	user2 =(UserBean)request.getSession().getAttribute	("User");
        
        if (user2!=null)
  	  {
        	user2.setPerformAction(false);
	          request.getSession().setAttribute("User",user2);
  	  }
      } catch (Exception e) {
        e.printStackTrace(System.out);
       
        UserBean user2 = null ;
        
        try
        {
        if (request.getSession().getAttribute	("User")!=null)
        	user2 =(UserBean)request.getSession().getAttribute	("User");
        
        if (user2!=null)
  	  {
        	user2.setPerformAction(false);
	          request.getSession().setAttribute("User",user2);
  	  }
        }
        catch(IllegalStateException  ee)
        {
        	System.out.println("Sessione non Valida -> Eseguito un Cambio utente");
        }
        
        System.out.println("Exception. MESSAGE = " + e.getMessage());
      }
    
      // finally we will attempt to forward (or transform) to the resource
      if (!"-none-".equals(result)) {
       
			forward(result, action, request, response,command);
		
      }
    } else {
      System.out.println("** It appears there is no mapping in the config file");
      try {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("The requested page could not be found.");
      } catch (IOException e) {
      }
    }  
    
    long after = System.currentTimeMillis();
    
    long diifference =after-before;
    long minutes = TimeUnit.MILLISECONDS.toSeconds(diifference);    
  } 


  /**
   *  Handles the process of forwarding to a resource.
   *
   *@param  lookup    Description of Parameter
   *@param  action    Description of Parameter
   *@param  request   Description of Parameter
   *@param  response  Description of Parameter
 * @throws IOException 
 * @throws Exception 
   */
  public void forward(String lookup, Action action, HttpServletRequest request, HttpServletResponse response,String command) throws IOException  {
    // last but not least..we now try to forward or redirect to the
    // Action associated with the return value. If the return value is not
    // found in this Action, we forward back to the calling page. If that is
    // not specified, we return a response that contains some simple HTML
    // that lets the user know a resource could not be found. This last step
    // should never occur in a working application.

    // get the JSP page that will be dynamically created via the
    // javabean populated by the action class
	  
	  
	  System.out.println("> Looking up resource: " + lookup);
    if (System.getProperty("DEBUG") != null) {
      System.out.println("> Looking up resource: " + lookup);
    }
    // Get a handle to the application prefs
    ApplicationPrefs applicationPrefs = (ApplicationPrefs) getServletContext().getAttribute(
        "applicationPrefs");
    // An action source returns the flow back to the originating action
    if (request.getParameter("actionSource") != null) {
      String actualActionPath = (String) request.getParameter("actionSource");
      action = (Action) actions.get(actualActionPath);
      if (System.getProperty("DEBUG") != null) {
        System.out.println(
            "> Action source found, forward to action: " + actualActionPath + " result: " + lookup);
      }
    }
    
   
    
    Resource resource = action.getResource(lookup);
    if (resource == null) {
      if (System.getProperty("DEBUG") != null) {
        System.out.println(
            "> Action not found, looking up under GlobalActions ");
      }
      resource = ((Action) actions.get("GlobalActions")).getResource(lookup);
    }
    if (resource != null) {
      if ((resource.getXSL() != null) && (resource.getXSL().length() > 0)) {
        // the response forward Action has an XSL page associated with it,
        // so apply the transform
        StreamSource xmlStream = null;
        Templates templates = null;
        if (!useXSLCache) {
          try {
            templates = tFactory.newTemplates(getXSLDocument(resource.getXSL()));
          } catch (Exception e) {
          }
        } else {
          // get it from cache
          if (xslCache.get(resource.getXSL()) != null) {
            templates = (Templates) xslCache.get(resource.getXSL());
          } else {
            // didn't find it in cache, but we want to use cache, so try to read
            // the XSL page off the hd, then store it in cache.
            try {
              templates = tFactory.newTemplates(getXSLDocument(resource.getXSL()));
              // syncronize this section to make sure that multiple threads don't
              // add the same XSL file to the HashMap, which is not
              // thread safe
              synchronized (this) {
                xslCache.put(resource.getXSL(), templates);
                // store the pre-compiled XSL
              }
            } catch (TransformerConfigurationException tce) {
            } catch (Exception e2) {
            }
          }
        }

        // Transform the xml output using the xsl stylesheet and the XALAN XSLT
        // engine, placing the output stream of the transformation in the
        // HttpServletResponse output stream.
//        response.setBufferSize(8192);
        response.setContentType(getResponseOutput(templates));
        // always assume HTML output from this controller
        try {
          StringBuffer link = new StringBuffer();
          link.append(request.getScheme());
          link.append("://");
          link.append(request.getServerName());
          link.append(":");
          link.append(request.getServerPort());
          link.append(request.getContextPath());
          link.append(resource.getName());
          link.append(";jsessionid=");
          link.append(request.getSession(true).getId());

          xmlStream = new StreamSource(new URL(link.toString()).openStream());
          Transformer transformer = templates.newTransformer();
          transformer.transform(xmlStream, new StreamResult(response.getOutputStream()));
        } catch (Exception e) {
          System.out.println("Exception trying to read in JSP or transform. MESSAGE: " + e.getMessage());
          e.printStackTrace(System.out);
        }
      } else {
        // no XSL attribute, so just forward to the JSP page
        try {
          if (System.getProperty("DEBUG") != null) {
            System.out.println("Resource-> " + lookup);
          }
          String forwardPath = resource.getName();
          //If there is a layout, then forward to the template instead
          //the template will include the resource
          if (resource.getLayout() != null && resource.getLayout().length() > 0) {
            String templateForwardPath = resource.getName();
            request.setAttribute("IncludeModule", templateForwardPath);
            forwardPath = "/templates/" + applicationPrefs.get(
                "LAYOUT.TEMPLATE") + resource.getLayout() + ".jsp";

            //Process extra layout options
          
              //Build the main menu (navigation)
              mainMenuHook.generateMenu(request, action.getActionName());

              //Build the Global Items
              String globalItems = globalItemsHook.generateItems(
                  this, request);
              if (globalItems != null) {
                request.setAttribute("GlobalItems", globalItems);
              }
            
          }

          ServletContext sc = null;
          if (resource.getContext() != null && resource.getContext().length() > 0) {
            sc = getServletContext().getContext(resource.getContext());
          } else {
            sc = getServletContext();
          }

          if ((forwardPath != null) && (forwardPath.length() > 0)) {
        	  String param = request.getParameter("customerSatisfaction");
  			String commandOld = request.getParameter("commandOld");
  			if (request.getParameter("TimeIni")!=null && !"null".equals(request.getParameter("TimeIni")   ) && !"".equals(request.getParameter("TimeIni")))
  			{
  				Long timeIniMills = Long.parseLong(request.getParameter("TimeIni"));
  				Timestamp timeIni = new Timestamp(timeIniMills);
  				request.setAttribute("TimeIni", timeIni);
  				request.setAttribute("commandOld", command);
  				request.setAttribute("ActionTime", action.getActionName());
  			}
  			else
  			{
  				Long timeIniMills = System.currentTimeMillis();
  				Timestamp timeIni = new Timestamp(timeIniMills);
  				request.setAttribute("TimeIni", timeIni);
  				request.setAttribute("commandOld", command);
  				request.setAttribute("ActionTime", action.getActionName());
  			}
  			if (param!=null)
  				request.setAttribute("customerSatisfaction", param);
  			if (commandOld!=null)
  				request.setAttribute("commandOld", commandOld);
            try {
              if (!resource.getRedirect()) {
                if (System.getProperty("DEBUG") != null) {
                  System.out.println(
                      "ControllerServlet-> Resource: " + resource.getName());
                }
                sc.getRequestDispatcher(forwardPath).forward(request, response);
              } else {
                response.sendRedirect(forwardPath);
              }
            } catch (Throwable t) {
              System.out.println("Throwable exception trying to forward to " + forwardPath + " MESSAGE: " + t.getMessage());
              t.printStackTrace(System.out);
              PrintWriter out = response.getWriter();
              out.println(
                  "<font color='red'>Attenzione si e' verificato un Errore.Contattare Il servizio di HD di primo livello.</font>");
            }
          }
        } catch (Exception e) {
          System.out.println("Exception while trying to handle JSP forwarding. MESSAGE: " + e.getMessage());
          e.printStackTrace();
        }
      }
    } else {
      // no Action, so forward back to the original page
      System.out.println("> No Action found, so doing nothing.");
      try {
    	 
               response.setContentType("text/html");
               PrintWriter out = response.getWriter();
               out.println(
                   "<font color=\"red\">The requested page was not found.</font>");
             } catch (IOException e) {
             }
    }
    
  }


  /**
   * Implements a default "stub" handler for the controllerInit()
   * ControllerInitHook method
   *
   * @param config Description of Parameter
   * @return Description of the Returned Value
   * @since 1.1
   */
  public String executeControllerInit(ServletConfig config) {
    return null;
  }


  /**
   * Initialize the DestroyHook with servletconfig
   *
   * @param config Description of Parameter
   * @return Description of the Returned Value
   * @since 1.8
   */
  public String executeControllerDestroyInit(ServletConfig config) {
    return null;
  }


  /**
   * Implements a default "stub" handler for the controllerDestroy()
   * ControllerDestroyHook method
   *
   * @return Description of the Returned Value
   * @since 1.8
   */
  public String executeControllerDestroy() {
    return null;
  }


  /**
   * Implements a default "stub" handler for the securityCheck() ControllerHook
   * method
   *
   * @param request Description of Parameter
   * @param servlet Description of the Parameter
   * @return Description of the Returned Value
   * @since 1.0
   */
  public String securityCheck(Servlet servlet, HttpServletRequest request) {
    return null;
  }


  /**
   * Implements a default "stub" handler for the generateMenu()
   * ControllerMainMenuHook method
   *
   * @param request    Description of Parameter
   * @param actionPath Description of Parameter
   * @since 1.1
   */
  public void generateMenu(HttpServletRequest request, String actionPath) {
  }
  
  /**
   * Implements a default "stub" handler for the generateMenu()
   * ControllerMainMenuHook method
   *
   * @param request    Description of Parameter
   * @param actionPath Description of Parameter
   * @since 1.1
   */
  public void generateMenuSuap(HttpServletRequest request, String actionPath) {
  }


  /**
   * Initializes the MainMenuHook with the servletconfig
   *
   * @param config Description of Parameter
   * @return Description of the Returned Value
   */
  public String executeControllerMainMenu(ServletConfig config) {
    return null;
  }


  /**
   * Implements a default "stub" handler for the generateItems()
   * ControllerGlobalItemsHook method
   *
   * @param request Description of Parameter
   * @param servlet Description of the Parameter
   * @return Description of the Returned Value
   * @since 1.1
   */
  public String generateItems(Servlet servlet, HttpServletRequest request) {
    return null;
  }


  /**
   *  Returns the servlet path of the request.
   *
   *@param  request  Description of Parameter
   *@return          The actionPath value
   */
  private String getActionPath(HttpServletRequest request) {
    String s = request.getServletPath();
    // For extension matching, we want to strip the extension (if any)
    int slash = s.lastIndexOf("/");
    int period = s.lastIndexOf(".");
    if ((period >= 0) && (slash >= 0) && (period > slash)) {
      return s.substring(slash + 1, period);
    }
    return s;
  }
  
  
  public static String getInitParametersFromProperties(String value) {  
      
    
	  ApplicationPropertiesStart properties = new ApplicationPropertiesStart("starting_gisarpac.properties");
  if (value == null) {  
      return null;  
  }  
  String initialValue = null;  
  final Pattern p = Pattern.compile("\\$\\{([\\p{Alnum}|\\.|\\-]*)\\}");  
  while (!value.equals(initialValue)) {  
      initialValue = value;  
      final Matcher m = p.matcher(value);  
      while (m.find()) {  
          final String propName = m.group(1);  
          final String propValue = properties.getProperty(propName) ;
          if (propValue != null) {  
              value = value.replaceAll("\\$\\{" + propName + "\\}", Matcher.quoteReplacement(propValue));  
          }  
      }  
  }  
  return value;  
} 


}

