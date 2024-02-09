package org.aspcfs.utils.web;

import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;

import org.aspcfs.controller.ApplicationPrefs;

import com.darkhorseventures.framework.actions.ActionContext;

/**
 * Description
 *
 * @author mrajkowski
 * @version $Id: RequestUtils.java 12404 2005-08-05 17:37:07Z mrajkowski $
 * @created Apr 11, 2005
 */

public class RequestUtils {
  /**
   * Adds a feature to the LinkParams attribute of the HTTPUtils class
   *
   * @param request The feature to be added to the LinkParams attribute
   * @param tmp     The feature to be added to the LinkParams attribute
   * @return Description of the Return Value
   */
  public static String addLinkParams(HttpServletRequest request, String tmp) {
    String params = "";
    StringTokenizer tokens = new StringTokenizer(tmp, "|");
    while (tokens.hasMoreTokens()) {
      String param = tokens.nextToken();
      if (request.getParameter(param) != null) {
        params += ("&" + param + "=" + request.getParameter(param));
      }
    }
    return params;
  }

  public static String getLink(ActionContext context, String url) {
    ApplicationPrefs prefs = (ApplicationPrefs) context.getServletContext().getAttribute(
        "applicationPrefs");
    boolean sslEnabled = "true".equals(prefs.get("ForceSSL"));
    if (sslEnabled) {
      return ("https://" + RequestUtils.getServerUrl(context.getRequest()) + "/" + url);
    } else {
      return ("http://" + RequestUtils.getServerUrl(context.getRequest()) + "/" + url);
    }
  }

  /**
   * Returns the server's url that was specified in the request, excluding the
   * scheme
   *
   * @param request Description of the Parameter
   * @return The serverURL value
   */
  public static String getServerUrl(HttpServletRequest request) {
    int port = request.getServerPort();
    return (request.getServerName() + (port != 80 && port != 443 ? ":" + String.valueOf(
        port) : "") + request.getContextPath());
  }
}
