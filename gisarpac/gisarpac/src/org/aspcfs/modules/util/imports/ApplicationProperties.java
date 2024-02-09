package org.aspcfs.modules.util.imports;


import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.InetAddress;
import java.net.URL;
import java.net.UnknownHostException;
import java.nio.charset.Charset;
import java.text.ParseException;
import java.util.Properties;
import java.util.logging.Logger;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import configurazione.centralizzata.nuova.gestione.ClientServizioCentralizzato;

public class ApplicationProperties {
	
	private static Properties applicationProperties = null;
	private static String ambiente = null;
	private static String fileProperties = null;
	private ApplicationProperties(){ }
	
	public static String getAmbiente() {
		return ambiente;
	}
	public static InputStream is = null;
	
	static{
	
		fileProperties = "application.properties";
		is = ApplicationProperties.class.getResourceAsStream(fileProperties);
		applicationProperties = new Properties();
		try {
			applicationProperties.load( is );
		} catch (IOException e) {
			applicationProperties = null;
		}
	}
	
	public static Properties getApplicationProperties() {
		return applicationProperties;
	}


	public static String getProperty( String property ){
		Logger logger = Logger.getLogger("MainLogger");
		if (applicationProperties.getProperty( property )==null)
			logger.info("[ERROR] [ApplicationProperties] Nell'application.properties ["+fileProperties+"] manca la riga: "+property);
		return (applicationProperties != null) ? applicationProperties.getProperty( property ) : "";
	}
	
	
	public static JSONObject  checkBrowser(String userAgent)
	{
		
		JSONArray jsonArray =new JSONArray();
		try {
			// Recupero il IP pubblico del server
			
			
			/*vecchia gestione
			JSONObject json = readJsonFromUrl("http://mon.gisacampania.it/configuratoreAmbiente.php?service=checkBrowser&userAgent="+userAgent);
			*/
			/*nuova gestione */
			ClientServizioCentralizzato sclient = new ClientServizioCentralizzato();
			JSONObject json = sclient.checkBrowser(userAgent);
			
           return json;
            
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		return null;
		
	}
	
	

	public static void setAmbiente(String string)   {
		// TODO Auto-generated method stub
		ambiente = string;
		
		try {
			
		  	/*nuova gestione*/
            ClientServizioCentralizzato sclient = new ClientServizioCentralizzato();
            ambiente = sclient.getAmbiente().getString("ambiente");
            System.out.println("***CARICATO AMBIENTE: "+ambiente);
            fileProperties = "application.properties"+ambiente;
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("------>VADO AVANTI UGUALMENTE CARICANDO application.propertiesUFFICIALE-AMBIENTE");
            fileProperties = "application.propertiesUFFICIALE";
        }  
		
			is = ApplicationProperties.class.getResourceAsStream(fileProperties);
			applicationProperties = new Properties();
			try {
				applicationProperties.load( is );
			} catch (IOException e) {
				applicationProperties = null;
			}
		//}
			Logger logger = Logger.getLogger("MainLogger");
			logger.info("[ApplicationProperties] Ambiente rilevato: "+ambiente+ "; application.properties caricato: "+fileProperties);

}
	
	
	
	
	public static void main (String [] arg) throws UnknownHostException{
		
		InetAddress[] machines = InetAddress.getAllByName("srv.anagrafecaninacampania.it");
		for(InetAddress address : machines){
		  System.out.println(address.getHostAddress());
		}
	}
	
	
    public static String readAll(Reader rd) throws IOException {
        StringBuilder sb = new StringBuilder();
        int cp;
        while ((cp = rd.read()) != -1) {
            sb.append((char) cp);
        }
        return sb.toString();
    }

    public static JSONObject readJsonFromUrl(String url) throws IOException, ParseException, JSONException {
        // String s = URLEncoder.encode(url, "UTF-8");
        // URL url = new URL(s);
        InputStream is = new URL(url).openStream();
        JSONObject json = null;
        try {
            BufferedReader rd = new BufferedReader(new InputStreamReader(is, Charset.forName("UTF-8")));
            String jsonText = readAll(rd);
            json = new JSONObject(jsonText);
        } finally {
            is.close();
        }
        return json;
    }

	
	
	
}