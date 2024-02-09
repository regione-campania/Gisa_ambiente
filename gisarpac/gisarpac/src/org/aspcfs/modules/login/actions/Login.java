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
package org.aspcfs.modules.login.actions;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.URL;
import java.net.URLEncoder;
import java.net.UnknownHostException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Hashtable;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.KeyGenerator;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.http.HttpSession;

import org.aspcfs.controller.ApplicationPrefs;
import org.aspcfs.controller.MiddleServlet;
import org.aspcfs.controller.SecurityHook;
import org.aspcfs.controller.SessionManager;
import org.aspcfs.controller.SystemStatus;
import org.aspcfs.controller.UserSession;
import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.admin.base.Suap;
import org.aspcfs.modules.admin.base.User;
import org.aspcfs.modules.admin.base.UserOperation;
import org.aspcfs.modules.base.Constants;
import org.aspcfs.modules.login.beans.LoginBean;
import org.aspcfs.modules.login.beans.UserBean;
import org.aspcfs.modules.login.utils.CheckLock;
import org.aspcfs.modules.system.base.Site;
import org.aspcfs.modules.system.base.SiteList;
import org.aspcfs.modules.util.imports.ApplicationProperties;
import org.aspcfs.utils.DatabaseUtils;
import org.aspcfs.utils.FileAesKeyException;
import org.aspcfs.utils.LDAPUtils;
import org.directwebremoting.WebContext;
import org.json.JSONException;
import org.json.JSONObject;

import sun.misc.BASE64Encoder;

import com.darkhorseventures.database.ConnectionElement;
import com.darkhorseventures.database.ConnectionPool;
import com.darkhorseventures.framework.actions.ActionContext;
import com.darkhorseventures.framework.hooks.CustomHook;
import com.lowagie.text.Image;
import com.lowagie.text.pdf.PdfPTable;

import crypto.nuova.gestione.ClientSCAAesServlet;

/**
 * The Login module.F
 *
 * @author mrajkowski
 * @version $Id: Login.java 22322 2007-08-01 13:08:17Z matt $
 * @created July 9, 2001
 */
public final class Login extends CFSModule {

	org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(Login.class);

	public final static String fs = System.getProperty("file.separator");
	public Image mappa = null;// inserito da carmela
	PdfPTable tabellaAnalisi = new PdfPTable(100);
	SimpleDateFormat sdfLog = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

	public static final int CONTEXT_GISA = 1;
	public static final int CONTEXT_SUAP = 2;

	private String getContext(ActionContext context) {
		String contesto = (String) context.getServletContext().getAttribute("SUFFISSO_TAB_ACCESSI");
		if (contesto != null && contesto.equals("_ext"))
			return "Ext";
		return "Gisa";
	}

	// Metodo per logout da DWR - VERONICA
	public String executeCommandLogout(WebContext context) {
		HttpSession oldSession = context.getSession();
		if (oldSession != null) {
			oldSession.removeAttribute("User");
			oldSession.invalidate();
		}
		return "LoginRetry";
	}

	public String executeCommandDefault(ActionContext context) {
		// Will need to use the following objects in some way...
		ApplicationPrefs prefs = (ApplicationPrefs) context.getServletContext().getAttribute("applicationPrefs");
		Connection db = null;
		try {

			HttpSession oldSession = context.getRequest().getSession(false);
			if (oldSession != null) {
				oldSession.removeAttribute("User");
			}

			Site thisSite = SecurityHook.retrieveSite(context.getServletContext(), context.getRequest());
			// Store a ConnectionElement in session for the LabelHandler to find
			// the corresponding language

		} catch (Exception e) {

		}
		// Determine entry page
		String scheme = context.getRequest().getScheme();
		// If SSL is configured, but this user isn't using SSL, then go to the
		// welcome page
		if ("true".equals((String) context.getServletContext().getAttribute("ForceSSL")) && scheme.equals("http")) {
			context.getRequest().setAttribute("LAYOUT.JSP", prefs.get("LAYOUT.JSP.WELCOME"));
		} else {
			context.getRequest().setAttribute("LAYOUT.JSP", prefs.get("LAYOUT.JSP.LOGIN"));
		}

		return "IndexPageOK";
	}

	public static byte[] lenientHexToBytes(String hex) {
		byte[] result = null;
		if (hex != null) {
			result = new byte[hex.length() / 2];
			for (int i = 0; i < result.length; i++) {
				result[i] = (byte) Integer.parseInt(hex.substring(2 * i, 2 * i + 2), 16);
			}
		}

		return result;
	}

	public static SecretKeySpec getKeySpec(String path) throws IOException, NoSuchAlgorithmException,
			FileAesKeyException {
		byte[] bytes = new byte[16];
		File f = new File(path.replaceAll("%20", " "));

		SecretKeySpec spec = null;
		if (f.exists()) {
			new FileInputStream(f).read(bytes);

		} else {
			throw new FileAesKeyException("File aes_key not found");

		}
		spec = new SecretKeySpec(bytes, "AES");
		return spec;
	}

	public static byte[] getKeySpecByte(String path) throws IOException, NoSuchAlgorithmException, FileAesKeyException {
		byte[] bytes = new byte[16];
		File f = new File(path.replaceAll("%20", " "));

		SecretKeySpec spec = null;
		if (f.exists()) {
			new FileInputStream(f).read(bytes);

		} else {
			throw new FileAesKeyException("File aes_key not found");

		}

		return bytes;
	}

	public static SecretKeySpec getKeySpecByString(byte[] preSharedKey) throws IOException, NoSuchAlgorithmException,
			FileAesKeyException {

		SecretKeySpec spec = null;

		spec = new SecretKeySpec(preSharedKey, "AES");
		return spec;
	}

	public static String decrypt(String text, URL url) throws Exception {
		if (url == null)
			throw new FileAesKeyException("File aes_key not found");

		SecretKeySpec spec = getKeySpec(url.getPath());
		Cipher cipher = Cipher.getInstance("AES");
		cipher.init(Cipher.DECRYPT_MODE, spec);
		sun.misc.BASE64Decoder dec = new sun.misc.BASE64Decoder();
		return (new String(cipher.doFinal(dec.decodeBuffer(text))));
	}

	public static String encrypt(String text, URL url) throws IOException, NoSuchAlgorithmException,
			FileAesKeyException, NoSuchPaddingException, InvalidKeyException, IllegalBlockSizeException,
			BadPaddingException {

		if (url == null) {
			throw new FileAesKeyException("File aes_key not found");
		}
		SecretKeySpec spec = getKeySpec(url.getPath());
		Cipher cipher = Cipher.getInstance("AES");
		cipher.init(Cipher.ENCRYPT_MODE, spec);
		sun.misc.BASE64Encoder enc = new sun.misc.BASE64Encoder();

		return enc.encode(cipher.doFinal(text.getBytes()));
	}

	public static String NEWencrypt(String input, URL url) {
		byte[] crypted = null;
		try {
			// SecretKeySpec skey = new SecretKeySpec(key.getBytes(), "AES");
			SecretKeySpec skey = getKeySpec(url.getPath());
			Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
			cipher.init(Cipher.ENCRYPT_MODE, skey);
			crypted = cipher.doFinal(input.getBytes());
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return new String(org.apache.commons.codec.binary.Base64.encodeBase64(crypted));
	}

	public String NEWdecrypt(String input, byte[] preSharedKey) {
		byte[] output = null;
		try { 
			// SecretKeySpec skey = new SecretKeySpec(key.getBytes(), "AES");
			SecretKeySpec skey = getKeySpecByString(preSharedKey);
			Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
			cipher.init(Cipher.DECRYPT_MODE, skey);
			output = cipher.doFinal(org.apache.commons.codec.binary.Base64.decodeBase64(input.replaceAll(" ", "+")
					.getBytes()));
		} catch (Exception e) {
			System.out.println(e.toString());
		}
		return new String(output);
	}


	
	public String executeCommandValidate(ActionContext context) throws SQLException,
	NoSuchAlgorithmException, BadPaddingException, InvalidKeyException, NoSuchPaddingException 
	{
		String[] params = null;
		String decrypteToken = "";
		String encrypteToken = context.getParameter("encryptedToken");

		if (encrypteToken == null) 
		{
			System.out.println("executeCommandValidate - return null: " );
			context.getRequest().setAttribute("risultato", "KO: Token non passato");
			return "ValidateOK";
		} 
		else 
		{
			String msg = "" ;
	
			LoginBean loginBean = (LoginBean) context.getRequest().getAttribute("LoginBean");
			String username = context.getRequest().getParameter("username");
			String serverName = context.getRequest().getServerName();

	
			String gkDriver = getPref(context, "GATEKEEPER.DRIVER");
			String gkHost = getPref(context, "GATEKEEPER.URL");
			String gkUser = getPref(context, "GATEKEEPER.USER");
			String gkUserPw = getPref(context, "GATEKEEPER.PASSWORD");
			String siteCode = getPref(context, "GATEKEEPER.APPCODE");
			ConnectionElement gk = new ConnectionElement(gkHost, gkUser, gkUserPw);
			gk.setDriver(gkDriver);
			ConnectionPool sqlDriver = (ConnectionPool) context.getServletContext().getAttribute("ConnectionPool");
			if (sqlDriver == null) 
			{
				context.getRequest().setAttribute("risultato", "KO: Connection missing");
				return "ValidateOK";
			}
			Connection db = null;
			ConnectionElement ce = null;

			String ip = context.getRequest().getRemoteAddr();

			try 
			{
				if ("true".equals((String) context.getServletContext().getAttribute("WEBSERVER.ASPMODE"))) 
				{
					// Scan for the virtual host
					db = sqlDriver.getConnection(gk, context);
					SiteList siteList = new SiteList();
					siteList.setSiteCode(siteCode);
					siteList.setVirtualHost(serverName);
					siteList.buildList(db);
					if (siteList.size() > 0) 
					{
						Site thisSite = (Site) siteList.get(0);
						ce = new ConnectionElement(thisSite.getDatabaseUrl(), thisSite.getDatabaseUsername(),
								thisSite.getDatabasePassword());
						ce.setDbName(thisSite.getDatabaseName());
						ce.setDriver(thisSite.getDatabaseDriver());
					} 
					else 
					{
						context.getRequest().setAttribute("risultato", "KO: Access denied, Host does not exist");
						return "ValidateOK";
					}
				} 
				else 
				{
					ce = new ConnectionElement(gkHost, gkUser, gkUserPw);
					ce.setDbName(getPref(context, "GATEKEEPER.DATABASE"));
					ce.setDriver(gkDriver);
				}
			} 
			catch (Exception e) 
			{
				loginBean.setMessage("* Gatekeeper: " + e.getMessage());
			} 
			finally 
			{
				if (db != null) 
				{
					sqlDriver.free(db, context);
				}
			}

			String ipAddressSuap2 = context.getParameter("SuapIP");

			if (!ip.equalsIgnoreCase(ipAddressSuap2)) 
			{
				if (context.getRequest().getParameter("debugServizioRest") != null) 
				{
					System.out.println("#SUAP#] [IP NON CORRISPONDENTE CON IL CHIAMANTE : IP CHIAMANTE ]" + ip
					+ " IP PASSATO : " + ipAddressSuap2 + "\nPROSEGUO LO STESSO POICHE' IN DEBUG");
				} 
				else 
				{
					System.out.println("#SUAP#] [ACCESSO FALLITO - IP NON CORRISPONDENTE CON IL CHIAMANTE : IP CHIAMANTE ]"
							+ ip + " IP PASSATO : " + ipAddressSuap2);
					
					loginBean.setMessage("ACCESSO FALLITO - IP NON CORRISPONDENTE CON IL CHIAMANTE : IP CHIAMANTE "+ ip + " IP PASSATO : " + ipAddressSuap2);
					context.getRequest().setAttribute("risultato", "KO: IP NON CORRISPONDENTE CON IL CHIAMANTE");
					return "ValidateOK";
				}
			}

			String timeToLog = sdfLog.format(new Date(System.currentTimeMillis()));

			context.getRequest().setAttribute("LoginBean", loginBean);
			if (ce == null) 
			{
				logger.info(timeToLog + " - [gisa] - Login Fallito: ip=" + context.getIpAddress() + " username="
				+ username);

				context.getRequest().setAttribute("risultato", "KO: Connection missing");
				return "ValidateOK";
			}

			UserBean thisUser = null;
			int userId = -1;
			int aliasId = -1;
			int roleId = -1;
			String role = null;
			String userId2 = null;
			java.util.Date now = new java.util.Date();

			try 
			{
				SystemStatus thisSystem = null;
				db = sqlDriver.getConnection(ce, context);

				System.out.println("#SUAP#] [RICHIESTA ACCESSO DA IP : ]" + ipAddressSuap2);
				if (!isInWhiteList(ipAddressSuap2, db)) 
				{
					loginBean.setMessage("INDIRIZZO DI PROVENIENZA NON RICONOSCIUTO");
					logger.info("TENTATIVO DI ACCESSO FALLITO PROVENIENTE DA IP : " + ipAddressSuap2
					+ ". INDIRIZZO NON PRESENTE IN WITHELIST");
					System.out.println("#SUAP#] [ACCESSO FALLITO - IP NON PRESENTE IN WHITE LIST : IP ]"
					+ ipAddressSuap2);

			
				
					loginBean.setMessage("TENTATIVO DI ACCESSO FALLITO PROVENIENTE DA IP : " + ipAddressSuap2+" INDIRIZZO NON RICONOSCIUTO");
					context.getRequest().setAttribute("risultato", "KO: IP NON PRESENTE IN WHITE LIST");
					return "ValidateOK";
				}

				long loginTime = 0;
				ArrayList<String> preSharedKeyList = getSharedKey(ipAddressSuap2, db);

				int numTentativo = 0;
				for (String preSharedKey : preSharedKeyList) 
				{
					numTentativo++;
					try 
					{

						if (preSharedKey.length() == 32) // caso esadecimale
							decrypteToken = NEWdecrypt(encrypteToken, lenientHexToBytes(preSharedKey));
						else
							decrypteToken = NEWdecrypt(encrypteToken, preSharedKey.getBytes());

						params = decrypteToken.split("@");

						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

						long currTime = System.currentTimeMillis();

						Date d = new Date(currTime);
						loginTime = sdf.parse(params[0]).getTime();

						if (currTime - loginTime > 15 * 1000 * 60) 
						{
							context.getRequest().setAttribute("risultato", "KO: Token non piu valido");

							System.out.println("#SUAP#] [ACCESSO FALLITO - TOKEN NON VALIDO PASSATO TROPPO TEMPO ] "
							+ ip + " DATA CORRENTE" + (d) + " DATA RICHIESTA " + sdf.parse(params[0]));

							loginBean.setMessage("ACCESSO FALLITO - TOKEN SCADUTO PER CUI NON VALIDO");
							context.getRequest().setAttribute("LoginBean", loginBean);
							return "ValidateOK";
						}

						break;

					} 
					catch (Exception e) 
					{
							System.out.println("#SUAP#] [ACCESSO FALLITO - TOKEN NON VALIDO SI E VERIFICATO IL SEGUENTE ERRORE IP:] "
								+ ip
								+ " ERRORE : "
								+ e.getMessage()
								+ "+TENTATIVO :"
								+ numTentativo
								+ " sharedKEy utilizzata " + preSharedKey);
							
							context.getRequest().setAttribute("risutato", "KO: " + e.getMessage());

							if (numTentativo == preSharedKeyList.size()) 
							{
								loginBean.setMessage("ACCESSO FALLITO - TOKEN NON VALIDO");
								context.getRequest().setAttribute("LoginBean", loginBean);
								context.getRequest().setAttribute("risutato", "KO: TOKEN NON VALIDO");
								return "ValidateOK";
							} 
							else
								continue;
					}

				}

				String istatComune = params[1];
				String ipPubblico = params[2];
				String cfRichiedente ="" ;
				String cfDelegato="";
				try
				{
			
					cfRichiedente = params[3];
		
					if(params.length==5)
						cfDelegato = params[4];
				}
				catch(ArrayIndexOutOfBoundsException e)
				{
					context.getRequest().setAttribute("risutato", "KO: NEL TOKEN MANCA IL CODICE FISCALE DELEGATO");
					System.out.println("###SUAP WARNING- NEL TOKEN MANCA IL CODICE FISCALE DELEGATO");
					return "ValidateOK";
				}

				java.sql.Date expDate = null;
				int tmpUserId = -1;
				int roleType = -1;

		
			} 
			catch (Exception e) 
			{
				loginBean.setMessage("* Access: " + e.getMessage());
				context.getRequest().setAttribute("risutato", "KO: " + e.getMessage());
				e.printStackTrace();
				if (System.getProperty("DEBUG") != null) {
					e.printStackTrace(System.out);
				}
				thisUser = null;
				return "ValidateOK";
			} 
			finally 
			{
				if (db != null) 
				{
					sqlDriver.free(db, context);
				}
			}
			
			context.getRequest().setAttribute("risultato", "OK");
			System.out.println("Sessione: " + context.getRequest().getSession().getId());
			System.out.println("Token messo in sessione: " + encrypteToken);
			context.getRequest().getSession().setAttribute("encryptedToken", encrypteToken);
			return "ValidateOK";

		}

	}
	
	
	
	/**
	 * Processes the user login
	 *
	 * @param context
	 *            Description of Parameter
	 * @return Description of the Returned Value
	 * @throws SQLException
	 * @throws IOException
	 * @throws IndirizzoNotFoundException
	 * @throws JSONException 
	 * @since 1.0
	 */
	
	public String executeCommandLoginLDAP(ActionContext context) throws SQLException, IOException,
	JSONException {
		
		String cfSpid = context.getParameter("cfSpid");
		
		if (cfSpid!=null && !cfSpid.equals(""))
			return executeCommandLoginSpid(context);
		else
			return executeCommandLogin(context);
		
	}


	public String executeCommandLogin(ActionContext context) throws SQLException, IOException,
			JSONException {
		
		// LogBean lb = new LogBean();

		String timeToLog = sdfLog.format(new Date(System.currentTimeMillis()));

		ApplicationPrefs applicationPrefs = (ApplicationPrefs) context.getServletContext().getAttribute(
				"applicationPrefs");
		// Process the login request
		LoginBean loginBean = (LoginBean) context.getRequest().getAttribute("LoginBean");
		loginBean.checkURL(context);

		if (context.getParameter("access_position_lat") != null
				&& !"".equals(context.getParameter("access_position_lat")))
			loginBean.setAccess_position_lat(context.getParameter("access_position_lat"));

		if (context.getParameter("access_position_lon") != null
				&& !"".equals(context.getParameter("access_position_lon")))
			loginBean.setAccess_position_lon(context.getParameter("access_position_lon"));

		if (context.getParameter("access_position_err") != null)
			loginBean.setAccess_position_err(context.getParameter("access_position_err"));

		String username = loginBean.getUsername(); 
		String password = loginBean.getPassword();
		String serverName = context.getRequest().getServerName();
		String cfSpid = context.getParameter("cfSpid");

		String loginSospeso = ApplicationProperties.getProperty("loginSospeso");

		if (loginSospeso != null && loginSospeso.equals("si")) {
			loginBean.setMessage("Login temporaneamente sospeso - Il portale tornera' disponibile a breve");
			if (context.getRequest().getParameter("mobile") != null) {
				return "LoginRetryMobile";
			}
			return "LoginRetry";
		}

		JSONObject jsonObj = ApplicationProperties.checkBrowser(context.getRequest().getHeader("User-Agent"));
		String msg = "";
		if (jsonObj != null) {
			if (jsonObj.getString("esito").equals("1")) {
				msg = jsonObj.getString("msg");
				loginBean.setMessage(msg);
				context.getRequest().setAttribute("LoginBean", loginBean);
				return "LoginRetry";
			}

			if (jsonObj.getString("esito").equals("2")) {
				msg = jsonObj.getString("msg");
			}

		}

		// Throw out empty passwords
		if ((password == null || "".equals(password.trim())) && (cfSpid == null || "".equals(cfSpid.trim())) ) {
			if (context.getRequest().getParameter("mobile") != null) {
				return "LoginRetryMobile";
			}
			return "LoginRetry";
		}
		// Prepare the gatekeeper
		String gkDriver = getPref(context, "GATEKEEPER.DRIVER");
		String gkHost = getPref(context, "GATEKEEPER.URL");
		String gkUser = getPref(context, "GATEKEEPER.USER");
		String gkUserPw = getPref(context, "GATEKEEPER.PASSWORD");
		String siteCode = getPref(context, "GATEKEEPER.APPCODE");
		ConnectionElement gk = new ConnectionElement(gkHost, gkUser, gkUserPw);
		gk.setDriver(gkDriver);
		// Prepare the database connection
		ConnectionPool sqlDriver = (ConnectionPool) context.getServletContext().getAttribute("ConnectionPool");

		if (sqlDriver == null) {
			loginBean.setMessage("Connection pool missing!");
			if (context.getRequest().getParameter("mobile") != null) {
				return "LoginRetryMobile";
			}
			return "LoginRetry";
		}
		Connection db = null;
		ConnectionElement ce = null;

		// Controllo Ip - BlackList / WhiteList
		String ip = context.getRequest().getRemoteAddr();
		logger.info("IP loggato: " + ip);
		
		/**
		 * CONTROLLO SE L'UTENTE CHE SI STA LOGGANDO IN GISA E' ANAGRAFATO SU
		 * GISA_EXT
		 */

		String ambiente = (String) context.getServletContext().getAttribute("SUFFISSO_TAB_ACCESSI");

		if (ambiente == null || "".equalsIgnoreCase(ambiente)) {
			try {
				db = sqlDriver.getConnection(gk, context);
				
				//CERCO DI ENTRARE
				
				//CHECK LOCK
					if (CheckLock.checkLocked(db, context.getIpAddress(), username)){
						context.getRequest().setAttribute("messaggio", "Accesso bloccato a causa dei troppi tentativi falliti. Attendere circa 3 minuti per riprovare.");
						return "LoginRetry";
					}
				//FINE CHECK LOCK
				
				
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				sqlDriver.free(db, context);
			}
		}

		if (!ip.equals("0:0:0:0:0:0:0:1")) { // se non e' localhost ha senso
			// controllare l'ip
			try {
				db = sqlDriver.getConnection(gk, context);

				if (!isInWhiteList(ip, db) && (isInBlackList(ip, db) || isInBlackListRange(ip, db))) {
					logger.info("Tentativo di accesso da parte dell'IP < " + ip + " >");
					loginBean.setMessage("Accesso al sistema negato per il seguente IP: " + ip);
					context.getRequest().setAttribute("isBannato", "si");

					MiddleServlet.writeLoginFault(username, ip, loginBean.getMessage(), context);

					if (context.getRequest().getParameter("mobile") != null) {
						return "LoginRetryMobile";
					}
					return "LoginRetry";
				}

			} catch (Exception e) {
				logger.error("Eccezione durante il controllo dell'IP.");
				e.printStackTrace();
			} finally {
				if (db != null) {
					sqlDriver.free(db, context);
				}
			}

		}
		// ArrayList<String> coordinate = new ArrayList<String>();
		// Connect to the gatekeeper, validate this host and get new connection
		// info
		try {
			if ("true".equals((String) context.getServletContext().getAttribute("WEBSERVER.ASPMODE"))) {
				// Scan for the virtual host
				db = sqlDriver.getConnection(gk, context);
				SiteList siteList = new SiteList();
				siteList.setSiteCode(siteCode);
				siteList.setVirtualHost(serverName);
				siteList.buildList(db);
				if (siteList.size() > 0) {

					Site thisSite = (Site) siteList.get(0);
					ce = new ConnectionElement(thisSite.getDatabaseUrl(), thisSite.getDatabaseUsername(),
							thisSite.getDatabasePassword());
					ce.setDbName(thisSite.getDatabaseName());
					ce.setDriver(thisSite.getDatabaseDriver());
				} else {
					loginBean.setMessage("* Access denied: Host does not exist (" + serverName + ")");
				}
			} else {
				// A single database is configured, so use it only regardless of
				// ip/domain name
				ce = new ConnectionElement(gkHost, gkUser, gkUserPw);
				ce.setDbName(getPref(context, "GATEKEEPER.DATABASE"));
				ce.setDriver(gkDriver);
			}
		} catch (Exception e) {
			loginBean.setMessage("* Gatekeeper: " + e.getMessage());
		} finally {
			if (db != null) {
				sqlDriver.free(db, context);
			}
		}
		if (ce == null) {
			// lb.store( -1, -1, 1, "Login Fallito ",username, context, db );
			logger.info(timeToLog + " - [gisa] - Login Fallito: ip=" + context.getIpAddress() + " username=" + username);

			MiddleServlet.writeLoginFault(username, context.getIpAddress(), "Connection Element null", context);

			if (context.getRequest().getParameter("mobile") != null) {
				return "LoginRetryMobile";
			}
			return "LoginRetry";
		}

		// Connect to the customer database and validate user
		UserBean thisUser = null;

		int userId = -1;
		int aliasId = -1;
		int roleId = -1;
		String role = null;
		String userId2 = null;
		java.util.Date now = new java.util.Date();
		boolean continueId = false;
		try {
			SystemStatus thisSystem = null;
			db = sqlDriver.getConnection(ce, context);
			// If system is not upgraded, perform lightweight validation to
			// ensure backwards compatibility
			if (applicationPrefs.isUpgradeable()) {
				continueId = true;
			} else {
				// A good place to initialize this SystemStatus, must be done
				// before getting a user
				Site thisSite = SecurityHook.retrieveSite(context.getServletContext(), context.getRequest());
				thisSystem = SecurityHook.retrieveSystemStatus(context.getServletContext(), db, ce,
						thisSite.getLanguage());
				if (System.getProperty("DEBUG") != null) {
					logger.info("Login-> Retrieved SystemStatus from memory : "
							+ ((thisSystem == null) ? "false" : "true"));
				}
				continueId = CustomHook.populateLoginContext(context, db, thisSystem, loginBean);
			}

			// Query the user record
			String pw = null;
			java.sql.Date expDate = null;
			int tmpUserId = -1;
			int roleType = -1;
			if (continueId) {
				String endPoing = (String) context.getServletContext().getAttribute("END_POINT_ROLE_EXT");
				// NOTE: The following is the simplest valid SQL that works
				// on all versions of Centric CRM. It must not be
				// modified with new fields because .war users need to
				// be able to login first, before the upgrade has happened
				PreparedStatement pst = db.prepareStatement("SELECT a." + DatabaseUtils.addQuotes(db, "password")
						+ ", a.role_id, r." + DatabaseUtils.addQuotes(db, "role")
						+ ", a.expires, a.alias, a.user_id, r.role_type " + "FROM "
						+ DatabaseUtils.addQuotes(db, "access_") + super.getSuffiso(context) + " a, "
						+ DatabaseUtils.addQuotes(db, "role") + super.getSuffiso(context) + " r "
						+ "WHERE a.role_id = r.role_id " + " AND  " 
						+ "(a.username = lower (?) OR a.alias_utente =  lower (?))  AND a.in_access is not false "
						+ " AND  a.enabled = ? and a.trashed_date is null "
						+ ((endPoing != null && !"".equals(endPoing)) ? " and r.super_ruolo=" + endPoing : ""));
				pst.setString(1, username.toLowerCase());
				pst.setString(2, username.toLowerCase());
				pst.setBoolean(3, true);
				ResultSet rs = pst.executeQuery();
				if (rs.next()) {
					pw = rs.getString("password");
					roleId = rs.getInt("role_id");
					role = rs.getString("role");
					expDate = rs.getDate("expires");
					aliasId = rs.getInt("alias");
					tmpUserId = rs.getInt("user_id");
					roleType = rs.getInt("role_type");
				}
				rs.close();
				pst.close();
				if (tmpUserId == -1) {
					
					//LOGIN ERRATA
					
					//CHECK LOCK
					CheckLock.incLock(db, context.getIpAddress(), username);
					//FINE CHECK LOCK
					
					// NOTE: This could be modified so that LDAP records get
					// inserted into CRM on the fly if they do not exist yet

					// User record not found in database
					// logger.info("#### ACCESSO NEGATO PER UTENTE "+username+" #####");
					loginBean.setMessage("* " + thisSystem.getLabel("login.msg.invalidLoginInfo"));
					if (System.getProperty("DEBUG") != null) {
						logger.info("Login-> User record not found in database for: " + username.toLowerCase());
					}
					MiddleServlet.writeLoginFault(username, context.getIpAddress(), loginBean.getMessage(), context);

				} else if (expDate != null && now.after(expDate)) {
					// Login expired
					loginBean.setMessage("* " + thisSystem.getLabel("login.msg.accountExpired"));
					MiddleServlet.writeLoginFault(username, context.getIpAddress(), loginBean.getMessage(), context);

				} else {
					// User exists, now verify password
					boolean ldapEnabled = "true".equals(applicationPrefs.get("LDAP.ENABLED"));
					if (ldapEnabled && roleType == Constants.ROLETYPE_REGULAR) {
						// See if the CRM username and password matches in LDAP
						int ldapResult = LDAPUtils.authenticateUser(applicationPrefs, db, loginBean);
						if (ldapResult == LDAPUtils.RESULT_VALID) {
							userId = tmpUserId;
						}
					} else {
						// Validate against Centric CRM for PortalRole users
						
						if (pw == null
								|| pw.trim().equals("")
								|| (!pw.equals(password) && !context.getServletContext().getAttribute("GlobalPWInfo")
										.equals(password))) {
							
							//LOGIN ERRATA
							
							//CHECK LOCK
							CheckLock.incLock(db, context.getIpAddress(), username);
							//FINE CHECK LOCK
							
							loginBean.setMessage("* " + thisSystem.getLabel("login.msg.invalidLoginInfo"));
							MiddleServlet.writeLoginFault(username, context.getIpAddress(), loginBean.getMessage(),
									context);
							
						} else {
							userId = tmpUserId;
							
							//LOGIN CORRETTA
							
							//CHECK LOCK
							CheckLock.resetLock(db, context.getIpAddress(), username);
							//FINE CHECK LOCK
						}
					}
				}
			}

			// Perform rest of user initialization if a valid user
			if (userId > -1) {
				thisUser = new UserBean();
				thisUser.setSessionId(context.getSession().getId());
				thisUser.setUserId(aliasId > 0 ? aliasId : userId);
				thisUser.setActualUserId(userId);
				thisUser.setConnectionElement(ce);
				thisUser.setClientType(context.getRequest());

				User userRecord = null;
				if (thisSystem != null) {
					// The user record must be in user cache to proceed
					userRecord = thisSystem.getUser(thisUser.getUserId());

					Suap ss = userRecord.getSuap();
					ss.setContesto(getContext(context));
					userRecord.setSuap(ss);

					if (userRecord != null) {
						// userRecord.setSuap(null);
						if (System.getProperty("DEBUG") != null) {
							logger.info("Login-> Retrieved user from memory: " + userRecord.getUsername());
						}
						// CHECK LAST LOGIN
						if (userRecord.getLastLogin() != null && !userRecord.getLastLogin().equals("")) {
							String s = new SimpleDateFormat("dd/MM/yyyy").format(userRecord.getLastLogin());
							String timeout = "6";// ApplicationProperties.getProperty("timeout");
							int time = Integer.parseInt(timeout);
							Calendar cal = Calendar.getInstance();
							cal.add(Calendar.MONTH, -time);
							Timestamp calTime = new Timestamp(cal.getTimeInMillis());
							// Se la last login e' antecedente al timeout
							if (userRecord.getLastLogin() != null && userRecord.getLastLogin().before(calTime)) {
								logger.info(timeToLog + " - [gisa] - Login Fallito: ip=" + context.getIpAddress()
										+ " username=" + username);
								context.getRequest()
										.setAttribute(
												"messaggio",
												"ATTENZIONE! NON PUOI ACCEDERE AL SISTEMA IN QUANTO IL TUO ACCOUNT RISULTA DISATTIVATO. "
														+ "IL TUO ULTIMO ACCESSO RISALE AL GIORNO "
														+ s
														+ ". PER ESSERE RIATTIVATO, SI PREGA DI CONTATTARE IL SERVIZIO DI HD I LIVELLO.");
								return "LoginRetry";
							} else {

								thisUser.setIdRange(userRecord.getIdRange());
								thisUser.setUserRecord(userRecord);

								// Log that the user attempted login (does not
								// necessarily mean logged in
								// anymore due to the single-session manager
								// below
								userRecord.setIp(context.getRequest().getRemoteAddr());
								userRecord.setAccess_position_lat(loginBean.getAccess_position_lat());
								userRecord.setAccess_position_lon(loginBean.getAccess_position_lon());
								userRecord.setAccess_position_err(loginBean.getAccess_position_err());

								// userRecord.setBrowser(context.getRequest().getHeader("user-agent"));
								userRecord.updateLogin(db, super.getSuffiso(context), context);
								// coordinate =
								// userRecord.getCoordinateUltimoAccesso(db);

								userRecord.checkWebdavAccess(db, context.getRequest().getParameter("password"));

								// lb.store( thisUser.getSiteId(),
								// thisUser.getUserId(),
								// 2, "Login Success ",username, context, db );
								logger.info(timeToLog + " - [gisa] - Login Success: ip=" + context.getIpAddress()
										+ " username=" + username + " user_id=" + thisUser.getUserId());
							}
						}
					}// chiudi if user not null

				
					if (!thisSystem.hasPermissions()) {
						logger.info("Login-> This system does not have any permissions loaded!");
					}
				} else {
					if (System.getProperty("DEBUG") != null) {
						logger.info("Login-> Fatal: User not found in this System!");
					}
				}
			} else {
				// lb.store( -1, -1, 1, "Login Fallito ",username, context, db
				// );
				logger.info(timeToLog + " - [gisa] - Login Fallito: ip=" + context.getIpAddress() + " username="
						+ username);
				if (System.getProperty("DEBUG") != null) {

					logger.info("Login-> Fatal: User does not have an Id!");
				}

			}
		} catch (Exception e) {
			loginBean.setMessage("* Access: " + e.getMessage());
			e.printStackTrace();
			if (System.getProperty("DEBUG") != null) {
				e.printStackTrace(System.out);
			}
			thisUser = null;
		} finally {
			if (db != null) {
				sqlDriver.free(db, context);
			}
		}
		// If user record is not found, ask them to login again
		if (thisUser == null) {

			return "LoginRetry";
		}
		// A valid user must have this information in their session, or the
		// security manager will not let them access any secure pages
		// if(ip.startsWith(applicationPrefs.get("IP_MOBILE")))
		// {
		//
		// PreparedStatement pst = db.prepareStatement(
		// "SELECT (cognome || ' ' || nome) as assegnatario from monitoring_report where ip_portatile = ?");
		// pst.setString(1, ip);
		// ResultSet rs = pst.executeQuery();
		// if (rs.next()) {
		// thisUser.setAssegnatario(rs.getString("assegnatario"));
		// }
		// User user_record = thisUser.getUserRecord();
		// user_record.setTipoDispositivo(applicationPrefs.get("CONNECTION_MOBILE"));
		// thisUser.setUserRecord(user_record);
		// }
		context.getRequest().getSession().setAttribute("User", thisUser);
		context.getSession().setAttribute("ConnectionElement", ce);

		if (applicationPrefs.isUpgradeable()) {
			if (roleId == 1 || "Administrator".equals(role)) {
				context.getSession().setAttribute("UPGRADEOK", "UPGRADEOK");
				return "PerformUpgradeOK";
			} else {
				return "UpgradeCheck";
			}
		} else {
			// Check to see if user is already logged in.
			// If not then add them to the valid users list
			SystemStatus thisSystem = (SystemStatus) ((Hashtable) context.getServletContext().getAttribute(
					"SystemStatus")).get(ce.getUrl());
			SessionManager sessionManager = thisSystem.getSessionManager();
			if (sessionManager.isUserLoggedIn(userId)) {
				UserSession thisSession = sessionManager.getUserSession(userId);
				context.getSession().setMaxInactiveInterval(300);
				context.getRequest().setAttribute("Session", thisSession);

				context.getRequest().setAttribute("access_position_lat", loginBean.getAccess_position_lat() + "");
				context.getRequest().setAttribute("access_position_lon", loginBean.getAccess_position_lon() + "");
				context.getRequest().setAttribute("access_position_err", loginBean.getAccess_position_err() + "");

				if (context.getRequest().getParameter("mobile") != null) {
					return "LoginVerifyOKMobile";
				}

				return "LoginVerifyOK";
			}
			if (System.getProperty("DEBUG") != null) {
				logger.info("Login-> Session Size: " + sessionManager.size());
			}
			// context.getSession().setMaxInactiveInterval(
			// thisSystem.getSessionTimeout());

			sessionManager.addUser(context, userId, thisUser.getUserRecord().getSuap());

			// if (coordinate.size()>0)
			// {
			//
			// UserSession thisSession =
			// (UserSession)sessionManager.getSessions().get(userId);
			//
			// thisSession.setAccess_position_lat(coordinate.get(0));
			// thisSession.setAccess_position_lon(coordinate.get(1));
			// thisSession.setAccess_position_date(coordinate.get(3));
			// thisSession.setAccess_position_err("Ultime coordinate del"+coordinate.get(3))
			// ;
			//
			// sessionManager.getSessions().put(userId, thisSession);
			// }
		}
		// TODO: Replace this so it does not need to be maintained
		// NOTE: Make sure to update this similar code in the following method
		String redirectTo = "MyCFS.do?command=Home&Message=" + msg;
		
		if (!hasPermission(context, "system-access-view")) {
			return "LoginNoAccessKO";
		}

		context.getRequest().setAttribute("to_url", "MyCFS.do?command=Home&Message=" + msg);

		if (ApplicationProperties.getProperty("abilitaStoricoOperazioniUtente") != null
				&& ApplicationProperties.getProperty("abilitaStoricoOperazioniUtente").equalsIgnoreCase("si")) {
			if (userId > 0) {
				ArrayList<UserOperation> op = new ArrayList<UserOperation>();
				UserOperation uo = new UserOperation();
				uo.setUser_id(thisUser.getUserId());
				uo.setUsername(thisUser.getUsername());
				uo.setIp(thisUser.getUserRecord().getIp());
				uo.setData(new Timestamp(new Date().getTime()));
				uo.setUrl(context.getRequest().getRequestURL().toString()
						+ (context.getRequest().getQueryString() != null ? "?" + context.getRequest().getQueryString()
								: ""));
				uo.setParameter("");
				uo.setUserBrowser(context.getRequest().getHeader("user-agent"));
				op.add(uo);
				MiddleServlet.writeStorico(op, "", false, super.getSuffiso(context));
			}
		}

		if (redirectTo != null) {
			// context.getRequest().removeAttribute("PageLayout");

			return "RedirectURL";
		}

		context.getRequest().setAttribute("to_url", "MyCFS.do?command=Home&Message=" + msg);
		return "RedirectURL";// "LoginOK";
	}

	/**
	 * Confirms if the user wants to ovreride previous session or not.<br>
	 * and informs Session Manager accordingly.
	 *
	 * @param context
	 *            Description of the Parameter
	 * @return Description of the Return Value
	 * @throws SQLException
	 * @throws IndirizzoNotFoundException
	 */

	public String executeCommandLoginConfirm(ActionContext context) throws SQLException {
				
		if (!hasPermission(context, "system-access-view")) {
			return "LoginNoAccessKO";
		}
		
		UserBean thisUser = (UserBean) context.getSession().getAttribute("User");
		if (thisUser == null) {
			return executeCommandLogout(context);
		}
		Connection db = null;

		String action = context.getRequest().getParameter("override");
		if ("yes".equals(action)) {
			SystemStatus systemStatus = (SystemStatus) ((Hashtable) context.getServletContext().getAttribute(
					"SystemStatus")).get(thisUser.getConnectionElement().getUrl());
			// context.getSession().setMaxInactiveInterval(systemStatus.getSessionTimeout());
			// replace userSession in SessionManager HashMap & reset timeout

			SessionManager sessionManager = systemStatus.getSessionManager();
			sessionManager.replaceUserSession(context, thisUser.getActualUserId(), thisUser.getUserRecord().getSuap());
			// TODO: Replace this so it does not need to be maintained
			// NOTE: Make sure to update this similar code in the previous
			// method
			if (ApplicationProperties.getProperty("abilitaStoricoOperazioniUtente") != null
					&& ApplicationProperties.getProperty("abilitaStoricoOperazioniUtente").equalsIgnoreCase("si")) {
				if (thisUser.getUserId() > 0) {
					ArrayList<UserOperation> op = new ArrayList<UserOperation>();
					UserOperation uo = new UserOperation();
					uo.setUser_id(thisUser.getUserId());
					uo.setUsername(thisUser.getUsername());
					uo.setIp(thisUser.getUserRecord().getIp());
					uo.setData(new Timestamp(new Date().getTime()));
					uo.setUrl(context.getRequest().getRequestURL().toString()
							+ (context.getRequest().getQueryString() != null ? "?"
									+ context.getRequest().getQueryString() : ""));
					uo.setParameter("");
					uo.setUserBrowser(context.getRequest().getHeader("user-agent"));

					op.add(uo);
					MiddleServlet.writeStorico(op, "", false, super.getSuffiso(context));
				}
			}

			if (thisUser.getRoleType() == Constants.ROLETYPE_REGULAR) {
				ApplicationPrefs applicationPrefs = (ApplicationPrefs) context.getServletContext().getAttribute(
						"applicationPrefs");
				if (applicationPrefs.isUpgradeable()) {
					if (thisUser.getRoleId() == 1 || "Administrator".equals(thisUser.getRole())) {
						return "PerformUpgradeOK";
					} else {
						return "UpgradeCheck";
					}
				}
				// String redirectTo =
				// context.getRequest().getParameter("redirectTo");
				String redirectTo = "MyCFS.do?command=Home";
				
				String destinazione = "MyCFS.do?command=Home";
				if((String) context.getSession().getAttribute("destinazione") != null && !("").equals((String) context.getSession().getAttribute("destinazione")))
				{
					destinazione = (String) context.getSession().getAttribute("destinazione");
					System.out.println("[LOGIN NO PASSWORD URL DESTINAZIONE]: "+destinazione);
				}
				context.getRequest().setAttribute("to_url", destinazione);
			
				if (redirectTo != null) {
					context.getRequest().removeAttribute("PageLayout");

					return "RedirectURL";
				}

				return "LoginOK";
			} else if (thisUser.getRoleType() == Constants.ROLETYPE_CUSTOMER) {
				return "CustomerPortalLoginOK";
			} else if (thisUser.getRoleType() == Constants.ROLETYPE_PRODUCTS) {
				return "ProductsPortalLoginOK";
			}
		} else {
			// logout user from current session
			return executeCommandLogout(context);
		}
		String redirectTo = context.getRequest().getParameter("redirectTo");

		if (hasPermission(context, "myhomepage-dashboard-view")) {
			context.getRequest().setAttribute("to_url", "MyCFS.do?command=Home");
		} else {}
		if (redirectTo != null) {
			context.getRequest().removeAttribute("PageLayout");
			if (context.getRequest().getParameter("mobile") != null)
				return "RedirectURLMobile";
			return "RedirectURL";
		}
		if (context.getRequest().getParameter("mobile") != null)
			return "LoginOKMobile";
		return "LoginOK";
	}

	

	/**
	 * Used for invalidating a user session
	 *
	 * @param context
	 *            Description of Parameter
	 * @return Description of the Returned Value
	 * @throws SQLException
	 * @since 1.1
	 */

	public String executeCommandLogout(ActionContext context) throws SQLException {
		
		String LOGIN_TRAMITE_SPID = (String) context.getSession().getAttribute("LOGIN_TRAMITE_SPID");
		if (LOGIN_TRAMITE_SPID!=null && LOGIN_TRAMITE_SPID.equalsIgnoreCase("SI")){
			context.getRequest().setAttribute("LOGIN_TRAMITE_SPID", LOGIN_TRAMITE_SPID);
		}

		String ambiente = (String) context.getSession().getAttribute("ambiente");

		if (ambiente != null /*
		/*
		 Il sistema setta l'ambiente solo se veniamo da sca o se siamo in gisa_ext.
		 Pero' questo e' un difetto di progettazione. Nella versione precedente si rimanda a sca (loginSirv)
		 se l'ambiente e' diverso da null ,ma questo lo rimanderebbe anche se simao in ext
		 Quindi risolvo con una patch mettendo che rimanda a sca se l'ambiente di provenienza contiene effettivamente la parola sca
		 e non si tratta INOLTRE di una logout
		deve essere sca e non cambio utente TODO >> questo e' un bug di progettazione nel settare ambiente solo se e' sca e d ext */
				&& ambiente.toLowerCase().contains("sca") 
				&& context.getRequest().getAttribute("isCambioUtente") == null) 
		{ 
			return executeCommandLoginSirv(context);
		} else {

			HttpSession oldSession = context.getRequest().getSession(false);
			if (oldSession != null) {
				// oldSession.removeAttribute("User"); //Commentata per log
				// storico operazioni
				try
				{
					oldSession.invalidate();
				}
				catch(Exception ex)
				{
					ex.printStackTrace();
					System.out.println("ECCEZIONE NON BLOCCANTE SULL'INVALIDATE OLD SESSION() PROSEGUO!");
				}
			}
			
			return "LoginRetry";
		}
	}

	public String executeCommandLoginSirv(ActionContext context) {

		try {

			// String SIRV_URL =
			// InetAddress.getByName("endpointAPPSirv").getHostAddress();
			// String SIRV_URL =
			// ApplicationProperties.getProperty("ambiente_sirv");
			String SIRV_URL = (String) context.getSession().getAttribute("ambiente");
			HttpSession oldSession = context.getRequest().getSession(false);
			UserBean thisUser = (UserBean) context.getSession().getAttribute("User");

			// String username = generate(thisUser.getUsername());
			String originalToken = System.currentTimeMillis() + "@" + thisUser.getUsername();

			String encryptedToken = null;
			/*vecchia gestione
			 * encryptedToken = NEWencrypt(originalToken, this.getClass().getResource("aes_key"));
			 */
			ClientSCAAesServlet cclient = new ClientSCAAesServlet();
			encryptedToken = cclient.crypt(originalToken);

			System.out.println("#LOGOUT ---> LOGINSIRV TO: " + SIRV_URL);

			// Se vieni dal sistema SIRV..

			try
			{
				oldSession.invalidate();
			}
			catch(Exception ex)
			{
				ex.printStackTrace();
				System.out.println("ECCEZIONE NON BLOCCANTE SULL'INVALIDATE OLD SESSION() PROSEGUO!");
			}

			context.getResponse().sendRedirect(
					/*"http://" + */SIRV_URL + "/login.LoginNoPassword.us?encryptedToken=" + URLEncoder.encode(encryptedToken,"UTF-8"));

		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		return "";
	}

	public String generate(String username) {
		String ret = null;

		String originalToken = System.currentTimeMillis() + "@" + username;
		byte[] encryptedToken = null;
		KeyGenerator kgen = null;

		try {
			kgen = KeyGenerator.getInstance("AES");
			kgen.init(128);
			// SecretKeySpec skeySpec = new SecretKeySpec(asBytes(
			// Application.get( "KEY" ) ), "AES");
			SecretKeySpec skeySpec = getKeySpec(this.getClass().getResource("aes_key").getPath());
			Cipher cipher = Cipher.getInstance("AES");
			cipher.init(Cipher.ENCRYPT_MODE, skeySpec);
			BASE64Encoder enc = new BASE64Encoder();
			encryptedToken = enc.encode(cipher.doFinal(originalToken.getBytes())).getBytes();
		} catch (Exception e) {
			e.printStackTrace();
		}

		ret = asHex(encryptedToken);

		return ret;
	}

	public static String asHex(byte buf[]) {
		StringBuffer sb = new StringBuffer(buf.length * 2);
		for (int i = 0; i < buf.length; i++) {
			if (((int) buf[i] & 0xff) < 0x10) {
				sb.append("0");
			}
			sb.append(Long.toString((int) buf[i] & 0xff, 16));
		}

		return sb.toString();
	}

	public String executeCommandLogoutSuap(ActionContext context) throws SQLException {

		System.out.println("Remote Addr : " + context.getRequest().getRemoteAddr());

		// LogBean lb = new LogBean();
		HttpSession oldSession = context.getRequest().getSession(false);
		Connection db = null;
		if (oldSession != null) {

			UserBean thisUser = (UserBean) context.getSession().getAttribute("User");

			Suap ss = thisUser.getUserRecord().getSuap();
			System.out.println("#####CALBACK DI KOO : "+ss.getCallbackSuapKo());
			context.getRequest().setAttribute("SupLogout", ss);
			oldSession.removeAttribute("User");
			oldSession.invalidate();
		}
		return "LoginRetrySuapJson";
	}


	private boolean isInWhiteList(String ip, Connection db) throws SQLException {

		String query = "select ip from whitelist_ip where ip = ?";

		PreparedStatement ps = db.prepareStatement(query);
		ps.setString(1, ip);
		ResultSet rs = ps.executeQuery();

		if (rs.next()) {
			return true;
		} else {
			return false;
		}

	}

	private ArrayList<String> getSharedKey(String ip, Connection db) throws SQLException {

		ArrayList<String> listSharedKey = new ArrayList<String>();
		String query = "select shared_key_suap from whitelist_ip where ip = ?";
		String sharedKey = "";
		PreparedStatement ps = db.prepareStatement(query);
		ps.setString(1, ip);
		ResultSet rs = ps.executeQuery();

		while (rs.next()) {
			sharedKey = rs.getString(1);
			listSharedKey.add(sharedKey);
		}
		if (sharedKey == null || "".equals(sharedKey))
			System.out.println("#SUAP#] [ACCESSO FALLITO - NON PRESENTE VALORE DI SHARED KEY  IN WHITELIST PER IP ] "
					+ ip);
		return listSharedKey;

	}

	private boolean isInBlackList(String ip, Connection db) throws SQLException {

		String query = "select ip from blacklist_ip where ip = ?";

		PreparedStatement ps = db.prepareStatement(query);
		ps.setString(1, ip);
		ResultSet rs = ps.executeQuery();

		if (rs.next()) {
			return true;
		} else {
			return false;
		}

	}

	private boolean isInBlackListRange(String ip, Connection db) throws SQLException, UnknownHostException {

		String query = "select ip_from, ip_to from blacklist_range_ip ";

		PreparedStatement ps = db.prepareStatement(query);
		ResultSet rs = ps.executeQuery();

		while (rs.next()) {
			if (isIpInRange(ip, rs.getString("ip_from"), rs.getString("ip_to"))) {
				return true;
			}
		}

		return false;
	}

	private boolean isIpInRange(String ip, String ipFrom, String ipTo) throws UnknownHostException {

		InetAddress ia = InetAddress.getByName(ip);
		InetAddress iaFrom = InetAddress.getByName(ipFrom);
		InetAddress iaTo = InetAddress.getByName(ipTo);

		long ipLong = 256L * 256L * 256L * (ia.getAddress()[0] & 0xFF) + 256L * 256L * (ia.getAddress()[1] & 0xFF)
				+ 256L * (ia.getAddress()[2] & 0xFF) + (ia.getAddress()[3] & 0xFF);
		long ipFromLong = 256L * 256L * 256L * (iaFrom.getAddress()[0] & 0xFF) + 256L * 256L
				* (iaFrom.getAddress()[1] & 0xFF) + 256L * (iaFrom.getAddress()[2] & 0xFF)
				+ (iaFrom.getAddress()[3] & 0xFF);
		long ipToLong = 256L * 256L * 256L * (iaTo.getAddress()[0] & 0xFF) + 256L * 256L
				* (iaTo.getAddress()[1] & 0xFF) + 256L * (iaTo.getAddress()[2] & 0xFF) + (iaTo.getAddress()[3] & 0xFF);

		if (ipFromLong <= ipLong && ipLong <= ipToLong) {
			return true;
		} else {
			return false;
		}
	}
	
	
	public String executeCommandLoginSpid(ActionContext context) throws SQLException, IOException,
	JSONException {
	
	// LogBean lb = new LogBean();

	String timeToLog = sdfLog.format(new Date(System.currentTimeMillis()));

	ApplicationPrefs applicationPrefs = (ApplicationPrefs) context.getServletContext().getAttribute(
			"applicationPrefs");
	// Process the login request
	LoginBean loginBean = (LoginBean) context.getRequest().getAttribute("LoginBean");
	loginBean.checkURL(context);

	if (context.getParameter("access_position_lat") != null
			&& !"".equals(context.getParameter("access_position_lat")))
		loginBean.setAccess_position_lat(context.getParameter("access_position_lat"));

	if (context.getParameter("access_position_lon") != null
			&& !"".equals(context.getParameter("access_position_lon")))
		loginBean.setAccess_position_lon(context.getParameter("access_position_lon"));

	if (context.getParameter("access_position_err") != null)
		loginBean.setAccess_position_err(context.getParameter("access_position_err"));

	String serverName = context.getRequest().getServerName();
	String cfSpid = context.getParameter("cfSpid");
	int userIdScelta = -1;
	try {userIdScelta = Integer.parseInt(context.getParameter("userIdScelta"));} catch(Exception e) {};

	String loginSospeso = ApplicationProperties.getProperty("loginSospeso");

	if (loginSospeso != null && loginSospeso.equals("si")) {
		loginBean.setMessage("Login temporaneamente sospeso - Il portale tornera' disponibile a breve");
		if (context.getRequest().getParameter("mobile") != null) {
			return "LoginRetryMobile";
		}
		return "LoginRetry";
	}

	JSONObject jsonObj = ApplicationProperties.checkBrowser(context.getRequest().getHeader("User-Agent"));
	String msg = "";
	if (jsonObj != null) {
		if (jsonObj.getString("esito").equals("1")) {
			msg = jsonObj.getString("msg");
			loginBean.setMessage(msg);
			context.getRequest().setAttribute("LoginBean", loginBean);
			return "LoginRetry";
		}

		if (jsonObj.getString("esito").equals("2")) {
			msg = jsonObj.getString("msg");
		}

	}

	
	// Prepare the gatekeeper
	String gkDriver = getPref(context, "GATEKEEPER.DRIVER");
	String gkHost = getPref(context, "GATEKEEPER.URL");
	String gkUser = getPref(context, "GATEKEEPER.USER");
	String gkUserPw = getPref(context, "GATEKEEPER.PASSWORD");
	String siteCode = getPref(context, "GATEKEEPER.APPCODE");
	ConnectionElement gk = new ConnectionElement(gkHost, gkUser, gkUserPw);
	gk.setDriver(gkDriver);
	// Prepare the database connection
	ConnectionPool sqlDriver = (ConnectionPool) context.getServletContext().getAttribute("ConnectionPool");

	if (sqlDriver == null) {
		loginBean.setMessage("Connection pool missing!");
		if (context.getRequest().getParameter("mobile") != null) {
			return "LoginRetryMobile";
		}
		return "LoginRetry";
	}
	Connection db = null;
	ConnectionElement ce = null;

	// Controllo Ip - BlackList / WhiteList
	String ip = context.getRequest().getRemoteAddr();
	logger.info("IP loggato: " + ip);
	
	/**
	 * CONTROLLO SE L'UTENTE CHE SI STA LOGGANDO IN GISA E' ANAGRAFATO SU
	 * GISA_EXT
	 */

	if (!ip.equals("0:0:0:0:0:0:0:1")) { // se non e' localhost ha senso
		// controllare l'ip
		try {
			db = sqlDriver.getConnection(gk, context);

			if (!isInWhiteList(ip, db) && (isInBlackList(ip, db) || isInBlackListRange(ip, db))) {
				logger.info("Tentativo di accesso da parte dell'IP < " + ip + " >");
				loginBean.setMessage("Accesso al sistema negato per il seguente IP: " + ip);
				context.getRequest().setAttribute("isBannato", "si");

				if (context.getRequest().getParameter("mobile") != null) {
					return "LoginRetryMobile";
				}
				return "LoginRetry";
			}

		} catch (Exception e) {
			logger.error("Eccezione durante il controllo dell'IP.");
			e.printStackTrace();
		} finally {
			if (db != null) {
				sqlDriver.free(db, context);
			}
		}

	}
	// ArrayList<String> coordinate = new ArrayList<String>();
	// Connect to the gatekeeper, validate this host and get new connection
	// info
	try {
		if ("true".equals((String) context.getServletContext().getAttribute("WEBSERVER.ASPMODE"))) {
			// Scan for the virtual host
			db = sqlDriver.getConnection(gk, context);
			SiteList siteList = new SiteList();
			siteList.setSiteCode(siteCode);
			siteList.setVirtualHost(serverName);
			siteList.buildList(db);
			if (siteList.size() > 0) {

				Site thisSite = (Site) siteList.get(0);
				ce = new ConnectionElement(thisSite.getDatabaseUrl(), thisSite.getDatabaseUsername(),
						thisSite.getDatabasePassword());
				ce.setDbName(thisSite.getDatabaseName());
				ce.setDriver(thisSite.getDatabaseDriver());
			} else {
				loginBean.setMessage("* Access denied: Host does not exist (" + serverName + ")");
			}
		} else {
			// A single database is configured, so use it only regardless of
			// ip/domain name
			ce = new ConnectionElement(gkHost, gkUser, gkUserPw);
			ce.setDbName(getPref(context, "GATEKEEPER.DATABASE"));
			ce.setDriver(gkDriver);
		}
	} catch (Exception e) {
		loginBean.setMessage("* Gatekeeper: " + e.getMessage());
	} finally {
		if (db != null) {
			sqlDriver.free(db, context);
		}
	}
	if (ce == null) {
		// lb.store( -1, -1, 1, "Login Fallito ",username, context, db );
		logger.info(timeToLog + " - [gisa] - Login Fallito: ip=" + context.getIpAddress() + " cfSpid=" + cfSpid);

		MiddleServlet.writeLoginFault(cfSpid, context.getIpAddress(), "Connection Element null", context);

		if (context.getRequest().getParameter("mobile") != null) {
			return "LoginRetryMobile";
		}
		return "LoginRetry";
	}

	// Connect to the customer database and validate user
	UserBean thisUser = null;

	int userId = -1;
	int aliasId = -1;
	int roleId = -1;
	String role = null;
	String userId2 = null;
	java.util.Date now = new java.util.Date();
	boolean continueId = false;
	try {
		SystemStatus thisSystem = null;
		db = sqlDriver.getConnection(ce, context);
		// If system is not upgraded, perform lightweight validation to
		// ensure backwards compatibility
		if (applicationPrefs.isUpgradeable()) {
			continueId = true;
		} else {
			// A good place to initialize this SystemStatus, must be done
			// before getting a user
			Site thisSite = SecurityHook.retrieveSite(context.getServletContext(), context.getRequest());
			thisSystem = SecurityHook.retrieveSystemStatus(context.getServletContext(), db, ce,
					thisSite.getLanguage());
			if (System.getProperty("DEBUG") != null) {
				logger.info("Login-> Retrieved SystemStatus from memory : "
						+ ((thisSystem == null) ? "false" : "true"));
			}
			continueId = CustomHook.populateLoginContext(context, db, thisSystem, loginBean);
		}

		// Query the user record
		String pw = null;
		java.sql.Date expDate = null;
		int tmpUserId = -1;
		int roleType = -1;
		String tmpUsername = null;
		String tmpSiteIdName = null;
		int tmpSiteId = -1;
		
		ArrayList<User> listaUtenti = new ArrayList<User>();
		
		if (continueId) {
			String endPoing = (String) context.getServletContext().getAttribute("END_POINT_ROLE_EXT");
			// NOTE: The following is the simplest valid SQL that works
			// on all versions of Centric CRM. It must not be
			// modified with new fields because .war users need to
			// be able to login first, before the upgrade has happened
			
			String queryLogin = "SELECT a.password, a.role_id, r.role, a.expires, a.alias, a.user_id, r.role_type, asl.code as id_asl, asl.description as nome_asl, a.username  FROM access a join contact c on a.contact_id = c.contact_id join role r on r.role_id = a.role_id left join access_dati ad on ad.user_id = a.user_id left join lookup_site_id asl on asl.code = ad.site_id WHERE a.in_access is not false AND a.enabled = '1' and a.trashed_date is null and r.super_ruolo=1 ";
			
			if (cfSpid!=null && !cfSpid.equals(""))
				queryLogin+= " AND c.codice_fiscale ilike ?";
			if (userIdScelta > 0)
				queryLogin+= " AND a.user_id = ?";

			PreparedStatement pst = db.prepareStatement(queryLogin);
			
			int i = 0;
			
			if (cfSpid!=null && !cfSpid.equals(""))
				pst.setString(++i, cfSpid);
			if (userIdScelta > 0)
				pst.setInt(++i, userIdScelta);
			
			ResultSet rs = pst.executeQuery();
			while (rs.next()) {
				roleId = rs.getInt("role_id");
				role = rs.getString("role");
				expDate = rs.getDate("expires");
				aliasId = rs.getInt("alias");
				tmpUserId = rs.getInt("user_id");
				roleType = rs.getInt("role_type");
				tmpUsername = rs.getString("username");
				tmpSiteId = rs.getInt("id_asl");
				tmpSiteIdName = rs.getString("nome_asl");
				
				User utente = new User();
				utente.setRoleId(roleId);
				utente.setRole(role);
				utente.setId(tmpUserId);
				utente.setUsername(tmpUsername);
				utente.setSiteIdName(tmpSiteIdName);
				utente.setSiteId(tmpSiteId);
				listaUtenti.add(utente);
				
			}
			rs.close();
			pst.close();
			if (tmpUserId == -1) {
				
				//LOGIN ERRATA
				
				
				
				// NOTE: This could be modified so that LDAP records get
				// inserted into CRM on the fly if they do not exist yet

				// User record not found in database
				// logger.info("#### ACCESSO NEGATO PER UTENTE "+username+" #####");
				loginBean.setMessage("* " + thisSystem.getLabel("login.msg.invalidLoginInfo"));
				if (System.getProperty("DEBUG") != null) {
					logger.info("Login-> User record not found in database for: " + cfSpid);
				}
				MiddleServlet.writeLoginFault(cfSpid, context.getIpAddress(), loginBean.getMessage(), context);

			} else if (listaUtenti.size() >1) {
				
				//PIU' DI UN UTENTE PER QUESTO CF
				
				
				loginBean.setMessage("* Impossibile identificare univocamente un accesso per questo codice fiscale. Risulta associato piu' di un utente.");
				if (System.getProperty("DEBUG") != null) {
					logger.info("Login-> User record not identified in database for: " + cfSpid);
				}
				context.getRequest().setAttribute("listaUtenti", listaUtenti);
				context.getRequest().setAttribute("cfSpid", cfSpid);

				return "LoginScelta";
				//MiddleServlet.writeLoginFault(cfSpid, context.getIpAddress(), loginBean.getMessage(), context);

			} else if (expDate != null && now.after(expDate)) {
				// Login expired
				loginBean.setMessage("* " + thisSystem.getLabel("login.msg.accountExpired"));
				MiddleServlet.writeLoginFault(cfSpid, context.getIpAddress(), loginBean.getMessage(), context);

			} else {
				
						userId = tmpUserId;
						
				
				
			}
		}

		// Perform rest of user initialization if a valid user
		if (userId > -1) {
			thisUser = new UserBean();
			thisUser.setSessionId(context.getSession().getId());
			thisUser.setUserId(aliasId > 0 ? aliasId : userId);
			thisUser.setActualUserId(userId);
			thisUser.setConnectionElement(ce);
			thisUser.setClientType(context.getRequest());

			User userRecord = null;
			if (thisSystem != null) {
				// The user record must be in user cache to proceed
				userRecord = thisSystem.getUser(thisUser.getUserId());

				Suap ss = userRecord.getSuap();
				ss.setContesto(getContext(context));
				userRecord.setSuap(ss);

				if (userRecord != null) {
					// userRecord.setSuap(null);
					if (System.getProperty("DEBUG") != null) {
						logger.info("Login-> Retrieved user from memory: " + userRecord.getUsername());
					}
					// CHECK LAST LOGIN
					if (userRecord.getLastLogin() != null && !userRecord.getLastLogin().equals("")) {
						String s = new SimpleDateFormat("dd/MM/yyyy").format(userRecord.getLastLogin());
						String timeout = "6";// ApplicationProperties.getProperty("timeout");
						int time = Integer.parseInt(timeout);
						Calendar cal = Calendar.getInstance();
						cal.add(Calendar.MONTH, -time);
						Timestamp calTime = new Timestamp(cal.getTimeInMillis());
						// Se la last login e' antecedente al timeout
						if (userRecord.getLastLogin() != null && userRecord.getLastLogin().before(calTime)) {
							logger.info(timeToLog + " - [gisa] - Login Fallito: ip=" + context.getIpAddress()
									+ " cfSpid=" + cfSpid);
							context.getRequest()
									.setAttribute(
											"messaggio",
											"ATTENZIONE! NON PUOI ACCEDERE AL SISTEMA IN QUANTO IL TUO ACCOUNT RISULTA DISATTIVATO. "
													+ "IL TUO ULTIMO ACCESSO RISALE AL GIORNO "
													+ s
													+ ". PER ESSERE RIATTIVATO, SI PREGA DI CONTATTARE IL SERVIZIO DI HD I LIVELLO.");
							return "LoginRetry";
						} else {

							thisUser.setIdRange(userRecord.getIdRange());
							thisUser.setUserRecord(userRecord);

							// Log that the user attempted login (does not
							// necessarily mean logged in
							// anymore due to the single-session manager
							// below
							userRecord.setIp(context.getRequest().getRemoteAddr());
							userRecord.setAccess_position_lat(loginBean.getAccess_position_lat());
							userRecord.setAccess_position_lon(loginBean.getAccess_position_lon());
							userRecord.setAccess_position_err(loginBean.getAccess_position_err());

							// userRecord.setBrowser(context.getRequest().getHeader("user-agent"));
							userRecord.updateLogin(db, super.getSuffiso(context), context);
							// coordinate =
							// userRecord.getCoordinateUltimoAccesso(db);

							userRecord.checkWebdavAccess(db, context.getRequest().getParameter("password"));

							// lb.store( thisUser.getSiteId(),
							// thisUser.getUserId(),
							// 2, "Login Success ",username, context, db );
							logger.info(timeToLog + " - [gisa] - Login Success: ip=" + context.getIpAddress()
									+ " cfSpid=" + cfSpid + " user_id=" + thisUser.getUserId());
						}
					}
				}// chiudi if user not null

				
				if (!thisSystem.hasPermissions()) {
					logger.info("Login-> This system does not have any permissions loaded!");
				}
			} else {
				if (System.getProperty("DEBUG") != null) {
					logger.info("Login-> Fatal: User not found in this System!");
				}
			}
		} else {
			// lb.store( -1, -1, 1, "Login Fallito ",username, context, db
			// );
			logger.info(timeToLog + " - [gisa] - Login Fallito: ip=" + context.getIpAddress() + " cfSpid="
					+ cfSpid);
			if (System.getProperty("DEBUG") != null) {

				logger.info("Login-> Fatal: User does not have an Id!");
			}

		}
	} catch (Exception e) {
		loginBean.setMessage("* Access: " + e.getMessage());
		e.printStackTrace();
		if (System.getProperty("DEBUG") != null) {
			e.printStackTrace(System.out);
		}
		thisUser = null;
	} finally {
		if (db != null) {
			sqlDriver.free(db, context);
		}
	}
	// If user record is not found, ask them to login again
	if (thisUser == null) {

		return "LoginRetry";
	}
	// A valid user must have this information in their session, or the
	// security manager will not let them access any secure pages
	// if(ip.startsWith(applicationPrefs.get("IP_MOBILE")))
	// {
	//
	// PreparedStatement pst = db.prepareStatement(
	// "SELECT (cognome || ' ' || nome) as assegnatario from monitoring_report where ip_portatile = ?");
	// pst.setString(1, ip);
	// ResultSet rs = pst.executeQuery();
	// if (rs.next()) {
	// thisUser.setAssegnatario(rs.getString("assegnatario"));
	// }
	// User user_record = thisUser.getUserRecord();
	// user_record.setTipoDispositivo(applicationPrefs.get("CONNECTION_MOBILE"));
	// thisUser.setUserRecord(user_record);
	// }
	context.getRequest().getSession().setAttribute("User", thisUser);
	context.getSession().setAttribute("ConnectionElement", ce);

	if (applicationPrefs.isUpgradeable()) {
		if (roleId == 1 || "Administrator".equals(role)) {
			context.getSession().setAttribute("UPGRADEOK", "UPGRADEOK");
			return "PerformUpgradeOK";
		} else {
			return "UpgradeCheck";
		}
	} else {
		// Check to see if user is already logged in.
		// If not then add them to the valid users list
		SystemStatus thisSystem = (SystemStatus) ((Hashtable) context.getServletContext().getAttribute(
				"SystemStatus")).get(ce.getUrl());
		SessionManager sessionManager = thisSystem.getSessionManager();
		if (sessionManager.isUserLoggedIn(userId)) {
			UserSession thisSession = sessionManager.getUserSession(userId);
			context.getSession().setMaxInactiveInterval(300);
			context.getRequest().setAttribute("Session", thisSession);

			context.getRequest().setAttribute("access_position_lat", loginBean.getAccess_position_lat() + "");
			context.getRequest().setAttribute("access_position_lon", loginBean.getAccess_position_lon() + "");
			context.getRequest().setAttribute("access_position_err", loginBean.getAccess_position_err() + "");

			if (context.getRequest().getParameter("mobile") != null) {
				return "LoginVerifyOKMobile";
			}

			return "LoginVerifyOK";
		}
		if (System.getProperty("DEBUG") != null) {
			logger.info("Login-> Session Size: " + sessionManager.size());
		}
		// context.getSession().setMaxInactiveInterval(
		// thisSystem.getSessionTimeout());

		sessionManager.addUser(context, userId, thisUser.getUserRecord().getSuap());

		// if (coordinate.size()>0)
		// {
		//
		// UserSession thisSession =
		// (UserSession)sessionManager.getSessions().get(userId);
		//
		// thisSession.setAccess_position_lat(coordinate.get(0));
		// thisSession.setAccess_position_lon(coordinate.get(1));
		// thisSession.setAccess_position_date(coordinate.get(3));
		// thisSession.setAccess_position_err("Ultime coordinate del"+coordinate.get(3))
		// ;
		//
		// sessionManager.getSessions().put(userId, thisSession);
		// }
	}
	// TODO: Replace this so it does not need to be maintained
	// NOTE: Make sure to update this similar code in the following method
	String redirectTo = "MyCFS.do?command=Home&Message=" + msg;
	
	if (!hasPermission(context, "system-access-view")) {
		return "LoginNoAccessKO";
	}

	switch (thisUser.getRoleId()) {
	
	default: {
		context.getRequest().setAttribute("to_url", "MyCFS.do?command=Home&Message=" + msg);
		break;
	}

	}

	if (ApplicationProperties.getProperty("abilitaStoricoOperazioniUtente") != null
			&& ApplicationProperties.getProperty("abilitaStoricoOperazioniUtente").equalsIgnoreCase("si")) {
		if (userId > 0) {
			ArrayList<UserOperation> op = new ArrayList<UserOperation>();
			UserOperation uo = new UserOperation();
			uo.setUser_id(thisUser.getUserId());
			uo.setUsername(thisUser.getUsername());
			uo.setIp(thisUser.getUserRecord().getIp());
			uo.setData(new Timestamp(new Date().getTime()));
			uo.setUrl(context.getRequest().getRequestURL().toString()
					+ (context.getRequest().getQueryString() != null ? "?" + context.getRequest().getQueryString()
							: ""));
			uo.setParameter("");
			uo.setUserBrowser(context.getRequest().getHeader("user-agent"));
			op.add(uo);
			MiddleServlet.writeStorico(op, "", false, super.getSuffiso(context));
		}
	}

	if (redirectTo != null) {
		// context.getRequest().removeAttribute("PageLayout");

		return "RedirectURL";
	}

	
	context.getRequest().setAttribute("to_url", "MyCFS.do?command=Home&Message=" + msg);
	return "RedirectURL";// "LoginOK";

	
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
