package org.aspcfs.modules.ldap.actions;

import java.util.HashMap;
import java.util.Hashtable;

import javax.naming.AuthenticationException;
import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.Attribute;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;

import org.aspcfs.modules.util.imports.ApplicationProperties;

public class LdapConnectionRegione {


	private static HashMap<String, String> errorMap;

	public final static int STATUS_OK = 1;
	public final static int STATUS_KO = -1;

	public static int main(String username) {
		System.out.println("[LDAP] starting program.");
		
		String LDAP_URL = ApplicationProperties.getProperty("LDAP_URL_REGIONE_1");
		String LDAP_DOMAIN = ApplicationProperties.getProperty("LDAP_DOMAIN_REGIONE_1");
		
		
		int status = -1;
		
		System.out.println("[LDAP] trying with: "+username+" on domain: "+LDAP_DOMAIN+" on ldap: "+LDAP_URL+" ...");
		try {status = testLDAP(username, LDAP_DOMAIN, LDAP_URL);} catch (Exception e) {}
		System.out.println("[LDAP] status= "+status);
		
		if (status == -1) {
			//PROVO A CONTROLLARE SENZA IL PUNTO NEL CASO CE L'ABBIA
			System.out.println("[LDAP] trying with: "+username.replaceAll(".", "")+" on domain: "+LDAP_DOMAIN+" on ldap: "+LDAP_URL+" ...");
			try {status = testLDAP(username.replaceAll(".", ""), LDAP_DOMAIN, LDAP_URL);} catch (Exception e) {}
			System.out.println("[LDAP] status= "+status);
		}

		System.out.println("[LDAP] ending program.");
		return status;
	}

	private static int testLDAP(String USER_TO_SEARCH, String LDAP_DOMAIN, String LDAP_URL) {

		boolean isAuthenticated = false;
		int status = -1;

		Hashtable<String, String> authEnv = new	Hashtable<String, String>(11);
		String dn = USER_TO_SEARCH + "@" + LDAP_DOMAIN;

		authEnv.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
		authEnv.put(Context.PROVIDER_URL, LDAP_URL);
		authEnv.put(Context.SECURITY_PRINCIPAL, "");
		authEnv.put(Context.SECURITY_CREDENTIALS, "");

		isAuthenticated = false;

		System.out.println( "[LDAP] ["+dn+"]");

		try {

			DirContext context = new InitialDirContext(authEnv);
			isAuthenticated = true;
			String searchBase = "";
			String FILTER ="(&(objectClass=pwmUser)(objectClass=person)((mail="+ dn +")))";
			SearchControls ctls = new SearchControls();
			ctls.setSearchScope(SearchControls.SUBTREE_SCOPE);
			NamingEnumeration<SearchResult> answer = context.search(searchBase, FILTER, ctls);
			SearchResult result = answer.next();
			Attribute attrSn = result.getAttributes().get("sn");
			Attribute attrN = result.getAttributes().get("givenName");
			System.out.println("[LDAP] ["+dn+"] "+ attrN + " " + attrSn);

			} catch (AuthenticationException authEx) {

			String msg = authEx.getMessage();
			for (String key : errorMap.keySet()) {
				if (msg.contains("data " + key)) {
					System.out.println("[LDAP] ["+dn+"] "+errorMap.get(key));
				}
			}

			System.out.println("[LDAP] ["+dn+"] Exception message: " + msg);
			status = STATUS_KO;
			isAuthenticated = false;
		} catch (NamingException namEx) {

			System.out.println("[LDAP] ["+dn+"] Something went wrong connecting to the server!");
			namEx.printStackTrace(System.out);
			status = STATUS_KO;
			isAuthenticated = false;
		}

		if (!isAuthenticated) {
			System.out.println("[LDAP] ["+dn+"] Not authenticated!");
			status = STATUS_KO;
		} else {
			System.out.println("[LDAP] ["+dn+"] Authenticated!");
			status = STATUS_OK;
		}
		return status;
	}


	static {
		errorMap = new HashMap<String, String>();

		errorMap.put("525", "ERROR_NO_SUCH_USER (The specified account does not exist.)" + "\nNOTE: Returns when username is invalid.");
		errorMap.put("52e","ERROR_LOGON_FAILURE (Logon failure: unknown user name or bad password.)"+ "\nNOTE: Returns when username is valid but password/credential is invalid."+ "\nWill prevent most other errors from being displayed as noted.");
		errorMap.put("530","ERROR_INVALID_LOGON_HOURS (Logon failure: account logon time restriction violation.)"+ "\nNOTE: Returns only when presented with valid username and password/credential.");
		errorMap.put("531","ERROR_INVALID_WORKSTATION (Logon failure: user not allowed to log on to this computer.)"+ "\nLDAP[userWorkstations: <multivalued list of workstation names>]"+ "\nNOTE: Returns only when presented with valid username and password/credential.");
		errorMap.put("532","ERROR_PASSWORD_EXPIRED (Logon failure: the specified account password has expired.)"+ "\nLDAP[userAccountControl: <bitmask=0x00800000>] - PASSWORDEXPIRED"+ "\nNOTE: Returns only when presented with valid username and password/credential.");
		errorMap.put("533","ERROR_ACCOUNT_DISABLED (Logon failure: account currently disabled.)"+ "\nLDAP[userAccountControl: <bitmask=0x00000002>] - ACCOUNTDISABLE"+ "\nNOTE: Returns only when presented with valid username and password/credential");
		errorMap.put("701","ERROR_ACCOUNT_EXPIRED (The user's account has expired.)"+ "\nLDAP[accountExpires: <value of -1, 0, or extemely large value indicates account will not expire>] - ACCOUNTEXPIRED"+ "\nNOTE: Returns only when presented with valid username and password/credential.");
		errorMap.put("773","ERROR_PASSWORD_MUST_CHANGE (The user's password must be changed before logging on the first time.)"+ "\nLDAP[pwdLastSet: <value of 0 indicates admin-required password change>] - MUST_CHANGE_PASSWD"+ "\nNOTE: Returns only when presented with valid username and password/credential.");
		errorMap.put("775","ERROR_ACCOUNT_LOCKED_OUT (The referenced account is currently locked out and may not be logged on to.)"+ "\nLDAP[userAccountControl: <bitmask=0x00000010>] - LOCKOUT"+ "\nNOTE: Returns even if invalid password is presented");

	}

}

