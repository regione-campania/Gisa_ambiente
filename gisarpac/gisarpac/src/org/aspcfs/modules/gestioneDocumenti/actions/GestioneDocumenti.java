package org.aspcfs.modules.gestioneDocumenti.actions;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.ConnectException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Calendar;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.aia.base.ImpresaAIA;
import org.aspcfs.modules.aia.base.StabilimentoAIA;
import org.aspcfs.modules.gestioneDocumenti.base.DocumentaleDocumentoList;
import org.aspcfs.modules.login.beans.UserBean;
import org.aspcfs.modules.schedeCentralizzate.base.SchedaCentralizzata;
import org.aspcfs.modules.util.imports.ApplicationProperties;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.darkhorseventures.framework.actions.ActionContext;

public class GestioneDocumenti extends CFSModule {

//	private String encoded = "";
//	private String tabellaName=ApplicationProperties.getProperty("DOCUMENTALE_GISA_NT_TABELLA_NAME");
//	private int idDocumento=-1; //creazione documenti timbrati, id dell'entry nel db timbro_storage
	//private String driverName = "org.postgresql.Driver"; //dati per connessione a DB
	//String databaseURL = ApplicationPrefs.getPref(context.getServletContext(), "GATEKEEPER.URL");
	//private String databaseURL = "jdbc:postgresql://"+ApplicationProperties.getProperty("GESTOREGLIFODBSERVER")+":"+ApplicationProperties.getProperty("GESTOREGLIFODBPORT")+"/"+ApplicationProperties.getProperty("GESTOREGLIFODBNAME");
	//private String DB_USER= ApplicationProperties.getProperty("DOCUMENTALEDBUSER");
	//private String DB_PASSWORD=ApplicationProperties.getProperty("DOCUMENTALEDBPWD");
		
	public GestioneDocumenti(){
		
	}
	
public String executeCommandGeneraPDF(ActionContext context) throws SQLException, IOException, JSONException{
	
	Boolean documentaleDisponibile = Boolean.valueOf(ApplicationProperties.getProperty("DOCUMENTALE_DISPONIBILE"));
	String documentaleNonDisponibileMessaggio =ApplicationProperties.getProperty("DOCUMENTALE_DISPONIBILE_MESSAGGIO");
	if (!documentaleDisponibile){
		context.getRequest().setAttribute("error", documentaleNonDisponibileMessaggio);
		return "documentaleError";
	}
	JSONObject jo = null;
	String test = ""; //conterra' l'html recuperato
	String tipo = context.getRequest().getParameter("tipo"); //tipo certificato
	String orgId = context.getRequest().getParameter("orgId"); 
	String stabId = context.getRequest().getParameter("stabId"); 
	String urlId =  context.getRequest().getParameter("url");
	String idCU = context.getRequest().getParameter("idGiornataIspettiva");
	String altId =  context.getRequest().getParameter("altId");
	String ticketId = context.getRequest().getParameter("idCampione"); 
	String htmlcode = (String)context.getSession().getAttribute("htmlcode");
	String returnTipo = context.getRequest().getParameter("returnTipo");
	if(htmlcode != null)
		context.getSession().removeAttribute("htmlcode");
	else
		htmlcode = context.getRequest().getParameter("htmlcode");
	String glifo =  context.getRequest().getParameter("glifo");
	String actionName = "PrintModulesHTML.do"; //nome action da cchiamare
	String file = context.getRequest().getParameter("file");
	String extra =  context.getRequest().getParameter("extra"); //PARAMETRO AGGIUNTIVO PER VALORI NECESSARI SOLO IN ALCUNI DOCUMENTI (es. anno del registro trasgressori)
	String urlOriginale = "";
	
	//Apparo per OPU
	if (urlId!=null && urlId.endsWith("Opu")){
		if (stabId==null)
			stabId=orgId;
			orgId = null;
	}
	//Apparo per SINTESIS
	else if (urlId!=null && urlId.contains("Sintesis")){
		if (altId==null)
			altId=orgId;
			orgId = null;
	}
	//Apparo per NUOVA ANAGRAFICA
			else if (urlId!=null && urlId.contains("Operatoriprivati")){
				if (altId==null)
					altId=orgId;
					orgId = null;
			}
	
	String generazionePulita =  context.getRequest().getParameter("generazionePulita");
	boolean statico = false;
	String urlChiamante = context.getRequest().getScheme() + "://" + context.getRequest().getLocalAddr()+":"+context.getRequest().getLocalPort() + context.getRequest().getContextPath() + "/";
	
	System.out.println("[DOCUMENTALE GISA] urlChiamante: "+urlChiamante);
	
	//inizializzo la variabile glifo nel caso sia null
	//glifo valorizzata: aggiungi timbro
	if (glifo==null || glifo.equals("")){
		glifo="";
	}
	if (orgId==null){
		orgId="-1";
	}
	if (altId==null){
		altId="-1";
	}
	if (stabId==null){
		stabId="-1";
	}
	if (ticketId==null){
		ticketId="-1";
	}if (idCU==null){
		idCU="-1";
	}
	
	if (htmlcode!=null)
		test = htmlcode; //test contiene il sorgente html della pagina
	
	if (file!=null){
		URL oracle = null;
		
		String id = context.getRequest().getParameter("id"); 
		if (id!=null && !id.equals("null"))
			orgId = id;
		
		if (id==null || id.equals("null"))
			id=stabId;
		
		String add1 = context.getRequest().getParameter("address1");
		String add2 = context.getRequest().getParameter("address2");
		String add3 = context.getRequest().getParameter("address3");
		String idSessione = context.getRequest().getSession().getId();
		
		String idAslCorrente ="";
		String idTipoDownload ="";
		if (tipo.equals("AllegatoF")){
			ticketId = id;
			orgId = "-1";
			idAslCorrente = add1;
			idTipoDownload=add2;
			context.getRequest().setAttribute("asl_regione_corrente", idAslCorrente);
			context.getRequest().setAttribute("tipo_download", idTipoDownload);
		}
				
		String url          	= urlChiamante;
		String metodo="";
		
		if (tipo.equals("SchedaImpresa") || tipo.equals("ComunicazioneNumeroRegistrazione") || tipo.equals("SchedaCessazione") || tipo.equals("SchedaStabilimento") || tipo.equals("SchedaSOA") || tipo.equals("SchedaImbarcazioni")  || tipo.equals("SchedaOSM") || tipo.equals("SchedaMolluschi") || tipo.equals("SchedaCanili") ||tipo.equals("SchedaColonie") || tipo.equals("SchedaOperatoriCommerciali") || tipo.equals("SchedaOperatori193") || tipo.equals("SchedaFarmacie") || tipo.equals("SchedaAziendeAgricole") || tipo.equals("SchedaOperatoriSperimentazioneAnimale") || tipo.equals("SchedaStruttureRiproduzioneAnimale") || tipo.equals("SchedaOperatoriNonAltrove") || tipo.equals("SchedaPrivati")){
			actionName="SchedaPrint.do";
			metodo="StampaScheda";
			}
		else if (tipo.equals("AllegatoTrasporti")){
			actionName="TrasportoAnimali.do";
			metodo="StampaAllegato";
			}
		else if (tipo.equals("SchedaAllevamenti")){
			actionName="Allevamenti.do";
			metodo="StampaSchedaAllevamento";
			}
		else if (tipo.equals("5")){
			actionName="Modello5.do";
			metodo="View";
			}
		else if (tipo.equals("AllegatoF")){
			actionName="TroubleTicketsAllerte.do";
			metodo="StampaAllegatoF";
			}
		else if (tipo.equals("VariazioneCensimento")){
			actionName="ApicolturaApiari.do";
			metodo="StampaCensimento";
			}
		else if (tipo.equals("ApicolturaAllegatoC")){
			actionName="ApicolturaApiari.do";
			metodo="StampaAllegatoC";
			}
		else if (tipo.equals("ApicolturaMovimentazione")){
			actionName="ApicolturaApiari.do";
			metodo="StampaMovimentazione";
			}
		if (actionName.equals("SchedaPrint.do"))
			url+=actionName+
					"?command="+ metodo + "&id=" + id + "&addressid=" + add1 + "&addressid2=" + add2 + "&addressid3=" + add3 + "&file=" + file; //PAGINA DA LEGGERE E CODIFICARE
		else if(actionName.equals("TrasportoAnimali.do"))
			url+=actionName+
			"?command="+ metodo + "&id=" + id + "&file=" + file;
		else if(actionName.equals("Allevamenti.do"))
			url+=actionName+
			"?command="+ metodo + "&id=" + id;
		else if(actionName.equals("TroubleTicketsAllerte.do"))
			url+=actionName+
			"?command="+ metodo + "&ticketid=" + id+ "&tipo_download=" + idTipoDownload+ "&asl_regione_corrente=" + idAslCorrente;
		else if(actionName.equals("Modello5.do"))
			url+=actionName+
			"?command="+ metodo + "&idControllo=" + idCU+ "&tipoMod=" + extra+"&print=print";
		else if(actionName.equals("ApicolturaApiari.do"))
			url+=actionName+
			"?command="+ metodo + "&id=" + id;
		
		//PAGINA DA LEGGERE E CODIFICARE
		urlOriginale = url;
		}
	
	if (tipo.equals("RegistroTrasgressori")){ 
		
		String anno = context.getRequest().getParameter("anno"); 
		extra = anno;
		String idSessione = context.getRequest().getSession().getId();
		String url          	= urlChiamante;
		String metodo="";
		
		if (tipo.equals("RegistroTrasgressori")){
			actionName="RegistroTrasgressori.do";
			metodo="RegistroSanzioniDettaglio";
			}
		
		if (actionName.equals("RegistroTrasgressori.do"))
			url+=actionName+
					"?command="+ metodo + "&anno=" + anno+"&layout=style"; //PAGINA DA LEGGERE E CODIFICARE
		//PAGINA DA LEGGERE E CODIFICARE
		urlOriginale = url;
	
	}

	if (test!=null){
		test = fixHtml2(test);
		test = test.replaceAll("style=", "class=\"tableClass\" style=");
	}
	
	UserBean user = (UserBean) context.getSession().getAttribute("User");
	String ip = context.getIpAddress();
	int user_id = user.getUserRecord().getId();

	String url = ApplicationProperties.getProperty("APP_DOCUMENTALE_URL") + ApplicationProperties.getProperty("APP_DOCUMENTALE_CODIFICA");
	//STAMPE
	System.out.println("\nUrl generato(chiamata a servlet): "+url.toString());
	URL obj;
	HttpURLConnection conn=null;
	
	try {
		obj = new URL(url);
		conn = (HttpURLConnection) obj.openConnection();
		conn.setDoOutput(true);
		conn.setRequestMethod("GET");

		// conn.connect();
		StringBuffer requestParams = new StringBuffer();
		requestParams.append(URLEncoder.encode("html", "UTF-8"));
		requestParams.append("=").append(URLEncoder.encode(test, "UTF-8"));
		requestParams.append("&");
		requestParams.append("tipoCertificato");
		requestParams.append("=").append(tipo);
		requestParams.append("&");
		requestParams.append("orgId");
		requestParams.append("=").append(orgId);
		requestParams.append("&");
		requestParams.append("altId");
		requestParams.append("=").append(altId);
		requestParams.append("&");
		requestParams.append("stabId");
		requestParams.append("=").append(stabId);
		requestParams.append("&");
		requestParams.append("idCU");
		requestParams.append("=").append(idCU);
		requestParams.append("&");
		requestParams.append("ticketId");
		requestParams.append("=").append(ticketId);
		requestParams.append("&");
		requestParams.append("app_name");
		requestParams.append("=").append(ApplicationProperties.getProperty("APP_NAME_GISA"));
		requestParams.append("&");
		requestParams.append("aggiungiGlifo");
		requestParams.append("=").append(glifo);
		requestParams.append("&");
		requestParams.append("tipoTimbro");
		requestParams.append("=").append("GISA");
		requestParams.append("&");
		requestParams.append("idUtente");
		requestParams.append("=").append(user_id);
		requestParams.append("&");
		requestParams.append("ipUtente");
		requestParams.append("=").append(ip);
		requestParams.append("&");
		requestParams.append("generazionePulita");
		requestParams.append("=").append(generazionePulita);
		requestParams.append("&");
		requestParams.append("statico");
		requestParams.append("=").append(statico);
		requestParams.append("&");
		requestParams.append("extra");
		requestParams.append("=").append(extra);
		requestParams.append("&");
		requestParams.append("urlOriginale");
		requestParams.append("=").append(URLEncoder.encode(urlOriginale, "ISO-8859-1"));
		requestParams.append("&");
		requestParams.append("caller");
		requestParams.append("=").append(URLEncoder.encode(urlChiamante, "ISO-8859-1"));
		requestParams.append("&");
		requestParams.append("idSessione");
		requestParams.append("=").append(context.getSession().getId());
		requestParams.append("&");
		requestParams.append("sostituisciCaller"); 
		requestParams.append("=").append(ApplicationProperties.getProperty("APP_DOCUMENTALE_SOSTITUISCI_CALLER"));
		
		OutputStreamWriter wr = new OutputStreamWriter(conn
					.getOutputStream());
		wr.write(requestParams.toString());
		wr.flush();
		//System.out.println("[DOCUMENTALE GISA] CONNESSIONE: "+conn.toString()+"?"+requestParams.toString());
		System.out.println("[DOCUMENTALE GISA] CONNESSIONE: "+conn.toString());
		conn.getContentLength();
	
		String codDocumento="", titolo="";
		BufferedReader in = new BufferedReader( new InputStreamReader(conn.getInputStream()));
		StringBuffer result = new StringBuffer();

		//Leggo l'output: l'header del documento generato e il nome assegnatogli
		if (in != null) {
			String ricevuto = in.readLine();
			result.append(ricevuto); }
			in.close();
		jo = new JSONObject(result.toString());
		codDocumento = jo.get("codDocumento").toString();
		titolo = jo.get("titolo").toString();
		context.getRequest().setAttribute("codDocumento", codDocumento);
		context.getRequest().setAttribute("titolo", titolo);
		} catch (MalformedURLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
				context.getRequest().setAttribute("error", "SERVER DOCUMENTALE OFFLINE");
				return "documentaleError";
			}
			finally{
				conn.disconnect();
			}
	
	

	if(returnTipo.equalsIgnoreCase("json") ){
		System.out.println("- returnTipo = JSON");
		context.getResponse().setHeader("Content-disposition","application/json");
        context.getResponse().setContentType("application/json");
        // Get the printwriter object from response to write the required json object to the output stream      
        PrintWriter out = context.getResponse().getWriter();
     	// Assuming your json object is *jsonObject*, perform the following, it will return your json object  
     	out.print(jo);
     	out.flush();
        return ("-none-");	
	}
	
	return executeCommandDownloadPDF(context);
}
	

public String executeCommandGeneraPDFCentralizzato(ActionContext context) throws SQLException, IOException, JSONException, ParseException{
		
	Boolean documentaleDisponibile = Boolean.valueOf(ApplicationProperties.getProperty("DOCUMENTALE_DISPONIBILE"));
	String documentaleNonDisponibileMessaggio =ApplicationProperties.getProperty("DOCUMENTALE_DISPONIBILE_MESSAGGIO");
	if (!documentaleDisponibile){
		context.getRequest().setAttribute("error", documentaleNonDisponibileMessaggio);
		return "documentaleError";
	}
	
		//URL oracle = null;
		String test = ""; //conterra' l'html recuperato
		String tipoOperatore = context.getRequest().getParameter("tipoOperatore"); //tipo certificato
		String actionName = "SchedaCentralizzataAction.do"; //nome action da cchiamare
		String urlOriginale = "";
		String extra = context.getRequest().getParameter("extra"); 
		String generazionePulita = "";
		
		String idSessione = context.getRequest().getSession().getId();
		
		String tipoCertificato ="SchedaOperatore";
		
		JSONObject jsonEntita = new JSONObject();
		try { jsonEntita =  new JSONObject(context.getRequest().getParameter("jsonEntita")); } catch (Exception e) {}

		
		Connection dbGisa = null;
		String nomeFile = "";
		try {
		 dbGisa = this.getConnection(context);
		  nomeFile = SchedaCentralizzata.getNomeFile(dbGisa, tipoOperatore);
	}
		catch (Exception errorMessage) {
			errorMessage.printStackTrace();
			}
		finally {
			this.freeConnection(context, dbGisa);
		}
		
		if (nomeFile!=null && !nomeFile.equals(""))
			tipoCertificato = nomeFile;
		
//		if (context.getRequest().getParameter("tipoCertificato")!=null && !context.getRequest().getParameter("tipoCertificato").equals(""))
//			tipoCertificato = context.getRequest().getParameter("tipoCertificato");
		
		String urlChiamante = "http://"+context.getRequest().getLocalAddr()+":"+context.getRequest().getLocalPort() + context.getRequest().getContextPath() + "/";
		
		System.out.println("[DOCUMENTALE GISA] urlChiamante: "+urlChiamante);
				
		if (extra!=null){
			if (extra.equals("_ModificaData_")){
				extra = getDataCorrente() + " - Documento generato prima di modifica in questa data.";
				generazionePulita ="si";
			}
		}
		
		HttpURLConnection conn=null;
			
			String url          	= urlChiamante;
			String metodo="";
			metodo = "GeneraScheda";
			
			url+=actionName+
						"?command="+ metodo + "&stabId=" + jsonEntita.get("idStabilimentoAIA") + "&tipoOperatore=" + tipoOperatore; //PAGINA DA LEGGERE E CODIFICARE
			
			//PAGINA DA LEGGERE E CODIFICARE
			urlOriginale = url;
		
		UserBean user = (UserBean) context.getSession().getAttribute("User");
		String ip = context.getIpAddress();
		int user_id = user.getUserRecord().getId();

		String urlDocumentale = ApplicationProperties.getProperty("APP_DOCUMENTALE_URL")+ApplicationProperties.getProperty("APP_DOCUMENTALE_CODIFICA");
		//STAMPE
		System.out.println("\nUrl generato(chiamata a servlet): "+url.toString());
		URL obj;
		try {
			obj = new URL(urlDocumentale);
			conn = (HttpURLConnection) obj.openConnection();
			conn.setDoOutput(true);
			conn.setRequestMethod("GET");

			// conn.connect();
			StringBuffer requestParams = new StringBuffer();
			requestParams.append("tipoCertificato");
			requestParams.append("=").append(tipoCertificato);
			requestParams.append("&");
			requestParams.append("jsonEntita");
			requestParams.append("=").append(jsonEntita);
			requestParams.append("&");
			requestParams.append("tipoOperatore");
			requestParams.append("=").append(tipoOperatore);
			requestParams.append("&");
			requestParams.append("extra");
			requestParams.append("=").append(extra);
			requestParams.append("&");
			requestParams.append("app_name");
			requestParams.append("=").append(ApplicationProperties.getProperty("APP_NAME_GISA"));
			requestParams.append("&");
			requestParams.append("sostituisciCaller");
			requestParams.append("=").append(ApplicationProperties.getProperty("APP_DOCUMENTALE_SOSTITUISCI_CALLER"));
			requestParams.append("&");
			requestParams.append("tipoTimbro");
			requestParams.append("=").append("GISA");
			requestParams.append("&");
			requestParams.append("idUtente");
			requestParams.append("=").append(user_id);
			requestParams.append("&");
			requestParams.append("ipUtente");
			requestParams.append("=").append(ip);
			requestParams.append("&");
			requestParams.append("urlOriginale");
			requestParams.append("=").append(URLEncoder.encode(urlOriginale, "ISO-8859-1"));
			requestParams.append("&");
			requestParams.append("caller");
			requestParams.append("=").append(URLEncoder.encode(urlChiamante, "ISO-8859-1"));
			requestParams.append("&");
			requestParams.append("idSessione");
			requestParams.append("=").append(context.getSession().getId());
			requestParams.append("&");
			requestParams.append("generazionePulita");
			requestParams.append("=").append(generazionePulita);
			
			OutputStreamWriter wr = new OutputStreamWriter(conn
						.getOutputStream());
			wr.write(requestParams.toString());
			wr.flush();
			System.out.println("[DOCUMENTALE GISA] CONNESSIONE: "+conn.toString()+"?"+requestParams.toString());
			conn.getContentLength();
		
			String codDocumento="", titolo="";
			BufferedReader in = new BufferedReader( new InputStreamReader(conn.getInputStream()));
			StringBuffer result = new StringBuffer();
	
			//Leggo l'output: l'header del documento generato e il nome assegnatogli
			if (in != null) {
				String ricevuto = in.readLine();
				result.append(ricevuto); }
				in.close();
			JSONObject jo = new JSONObject(result.toString());
			codDocumento = jo.get("codDocumento").toString();
			titolo = jo.get("titolo").toString();
			context.getRequest().setAttribute("codDocumento", codDocumento);
			context.getRequest().setAttribute("titolo", titolo);
			} catch (MalformedURLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
					context.getRequest().setAttribute("error", "SERVER DOCUMENTALE OFFLINE");
					return "documentaleError";
				}
				finally{
					conn.disconnect();
				}
				return executeCommandDownloadPDF(context);
	}


	public String executeCommandDownloadPDF(ActionContext context) throws SQLException, IOException {
		
		//recupero l'id timbro
			String codDocumento 		=  null;
				codDocumento = context.getRequest().getParameter("codDocumento");
			if (codDocumento==null)
				codDocumento = (String)context.getRequest().getAttribute("codDocumento");
			String idDocumento 				= null;
			idDocumento = context.getRequest().getParameter("idDocumento");
			
			String titolo="";
			String provenienza = ApplicationProperties.getProperty("APP_NAME_GISA");
		
			String download_url = ApplicationProperties.getProperty("APP_DOCUMENTALE_URL") + ApplicationProperties.getProperty("APP_DOCUMENTALE_DOWNLOAD_SERVICE");
			
			if (codDocumento!=null && !codDocumento.equals("null")){
				download_url+="?codDocumento="+codDocumento;
				titolo=codDocumento+".pdf";
			}
			else {
				
				download_url+="?idDocumento="+idDocumento+"&provenienza="+provenienza;
				titolo=provenienza+"_"+idDocumento+".pdf";
			}
			
				if (context.getRequest().getAttribute("titolo")!=null)
					titolo= (String)context.getRequest().getAttribute("titolo");
				else if (context.getRequest().getParameter("titolo")!=null)
					titolo= (String)context.getRequest().getParameter("titolo");
				
			//Cartella temporanea sull'APP
	        String path_doc = getWebInfPath(context,"tmp_documentale");
	        //Creare il file ...(ispirarsi a GestoreGlifo servlet)
	        
	        File theDir = new File(path_doc);
         	theDir.mkdirs();

         	File inputFile = new File(path_doc+titolo);
         	if (!inputFile.exists())
         		inputFile.createNewFile();
         	URL copyurl;
         	InputStream outputFile=null;
        copyurl = new URL(download_url);
        try {
        outputFile = copyurl.openStream();  
        FileOutputStream out2 = new FileOutputStream(inputFile);
        int c;
        while ((c = outputFile.read()) != -1)
            out2.write(c);
        outputFile.close();
        out2.close();
	 
        String fileType = "";
         
      //  if (new File(fileName).exists()){
         // Find this file id in database to get file name, and file type

         // You must tell the browser the file type you are going to send
         // for example application/pdf, text/plain, text/html, image/jpg
         context.getResponse().setContentType(fileType);

         // Make sure to show the download dialog
         context.getResponse().setHeader("Content-disposition","attachment; filename="+titolo);

         // Assume file name is retrieved from database
         // For example D:\\file\\test.pdf

         File my_file = new File(inputFile.getAbsolutePath());

         // This should send the file to browser
         OutputStream out = context.getResponse().getOutputStream();
         FileInputStream in = new FileInputStream(my_file);
         byte[] buffer = new byte[4096];
         int length;
         while ((length = in.read(buffer)) > 0){
            out.write(buffer, 0, length);
         }
         in.close();
         out.flush();
  
         return ("-none-");	
}
         
         catch (ConnectException e1){
	        	context.getRequest().setAttribute("error", "SERVER DOCUMENTALE OFFLINE");
				return "documentaleError";
	        }
	        
		}

public String executeCommandListaDocumenti(ActionContext context) throws SQLException, UnknownHostException, JSONException, ParseException {
	//MOSTRA LISTA DOCUMENTI TIMBRATI PER L'ANIMALE
	
	JSONObject jsonEntita = new JSONObject();
	String jsonEntitaString = fixJsonEntita((String) context.getRequest().getAttribute("jsonEntita"));
	try {jsonEntita = new JSONObject(jsonEntitaString);} catch (Exception e) {}
	if (jsonEntita == null || jsonEntita.length() == 0){
		jsonEntitaString = fixJsonEntita(context.getRequest().getParameter("jsonEntita"));
		try {jsonEntita = new JSONObject(jsonEntitaString);} catch (Exception e) {}
	}
	
	Connection db = null;
	try {
		db = this.getConnection(context);
	
		if (Integer.parseInt((String)jsonEntita.get("idStabilimentoAIA"))>0){
			StabilimentoAIA stab = new StabilimentoAIA (db, Integer.parseInt((String)jsonEntita.get("idStabilimentoAIA")));
			context.getRequest().setAttribute("StabilimentoAIADettaglio", stab);
			
			ImpresaAIA operatore = new ImpresaAIA() ; 
			operatore.queryRecordImpresaAIA(db, stab.getIdImpresa());	
			context.getRequest().setAttribute("ImpresaAIADettaglio", operatore);
		}
				
	}
	catch(SQLException e1){
		e1.printStackTrace();
	} 
	finally{
		this.freeConnection(context, db);
	}
	
	context.getRequest().setAttribute("jsonEntita", jsonEntita.toString());
	context.getRequest().setAttribute("op", context.getRequest().getParameter("op"));
	
	HttpURLConnection conn = null;
	String url = ApplicationProperties.getProperty("APP_DOCUMENTALE_URL")+ApplicationProperties.getProperty("APP_DOCUMENTALE_LISTA_DOCUMENTI");

	//STAMPE
	System.out.println("\nUrl generato(chiamata a servlet): "+url.toString());

	URL obj;
	
		try {
			obj = new URL(url);
		
	
	conn = (HttpURLConnection) obj.openConnection();
	conn.setDoOutput(true);
	conn.setRequestMethod("GET");
	StringBuffer requestParams = new StringBuffer();
	requestParams.append("jsonEntita");
	requestParams.append("=").append(jsonEntita);
	requestParams.append("&");
	requestParams.append("app_name");
	requestParams.append("=").append(ApplicationProperties.getProperty("APP_NAME_GISA"));
	

	OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
	wr.write(requestParams.toString());
	wr.flush();
	System.out.println("[DOCUMENTALE GISA] CONNESSIONE: "+conn.toString()+"?"+requestParams.toString());
	conn.getContentLength();
			
	BufferedReader in = new BufferedReader( new InputStreamReader(conn.getInputStream()));
	//String inputLine; 
	StringBuffer html = new StringBuffer();
	if (in != null) {
		html.append(in.readLine()); }
		in.close();
		JSONArray jo = new JSONArray(html.toString());
		
		 DocumentaleDocumentoList docList = new DocumentaleDocumentoList();
		 docList.creaElenco(jo);
		 context.getRequest().setAttribute("listaDocumenti", docList);
	
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			context.getRequest().setAttribute("error", "SERVER DOCUMENTALE OFFLINE");
			context.getRequest().setAttribute("label", "Documenti PDF");
			return "documentaleAllegatiError";
			
		}
		finally{
			conn.disconnect();
		}
	return "listaDocOK";
}


private String getHtml(String url, String idSessione) 
{
	URL urlToCall	= null; 
	String html 	= "";
	System.out.println("[DOCUMENTALE GISA]: Pagina da recuperare "+url);
	
	try 
	{
		urlToCall = new URL(url); 
	} 
	catch (Exception e) 
	{
		e.printStackTrace();
		return "";
	}

	HttpURLConnection conn;
	try 
	{
		conn = (HttpURLConnection) urlToCall.openConnection();
		conn.setRequestProperty("cookie", "JSESSIONID=" + idSessione);
		conn.setDoOutput(false);
		conn.setReadTimeout(200*1000);
		conn.setConnectTimeout(200*1000);
		
		conn.getInputStream();
		BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
		String inputLine;
		while ((inputLine = in.readLine()) != null) 
		{
			html += inputLine;
		}
		in.close();
	} 
	catch (IOException e2) 
	{
		e2.printStackTrace();
		return "";
	}
	
	return html;
	
}


public String executeCommandGeneraPDFDettaglioCentralizzato(ActionContext context) throws SQLException, IOException, JSONException, ParseException{
	
	Boolean documentaleDisponibile = Boolean.valueOf(ApplicationProperties.getProperty("DOCUMENTALE_DISPONIBILE"));
	String documentaleNonDisponibileMessaggio =ApplicationProperties.getProperty("DOCUMENTALE_DISPONIBILE_MESSAGGIO");
	if (!documentaleDisponibile){
		context.getRequest().setAttribute("error", documentaleNonDisponibileMessaggio);
		return "documentaleError";
	}
	
	String tipoDettaglio = context.getRequest().getParameter("tipoDettaglio"); //tipo certificato
	String objectId = context.getRequest().getParameter("objectId"); 
	String servletName = "ServletServiziScheda"; //nome action da cchiamare
	String urlOriginale = "";
	
	String add1 = context.getRequest().getParameter("address1");
	String add2 = context.getRequest().getParameter("address2");
	String add3 = context.getRequest().getParameter("address3");
	
	String urlChiamante = "http://"+context.getRequest().getLocalAddr()+":"+context.getRequest().getLocalPort() + context.getRequest().getContextPath() + "/";
	
	System.out.println("[DOCUMENTALE GISA] urlChiamante: "+urlChiamante);
	
	if (objectId==null){
		objectId="-1";
	}
	
			
	HttpURLConnection conn=null;
		
		String url          	= urlChiamante;
		
		url+=servletName+
					"?object_id="+ objectId + "&tipo_dettaglio=" + tipoDettaglio + "&output_type=html&visualizzazione=print"; //PAGINA DA LEGGERE E CODIFICARE
		
		//PAGINA DA LEGGERE E CODIFICARE
		urlOriginale = url;
	
	UserBean user = (UserBean) context.getSession().getAttribute("User");
	String ip = context.getIpAddress();
	int user_id = user.getUserRecord().getId();

	String urlDocumentale = ApplicationProperties.getProperty("APP_DOCUMENTALE_URL")+ApplicationProperties.getProperty("APP_DOCUMENTALE_CODIFICA");
	//STAMPE
	System.out.println("\nUrl generato(chiamata a servlet): "+url.toString());
	URL obj;
	try {
		obj = new URL(urlDocumentale);
		conn = (HttpURLConnection) obj.openConnection();
		conn.setDoOutput(true);
		conn.setRequestMethod("GET");

		// conn.connect();
		StringBuffer requestParams = new StringBuffer();
		requestParams.append("tipoCertificato");
		requestParams.append("=").append("SchedaOperatore");
		requestParams.append("&");
		requestParams.append("orgId");
		requestParams.append("=").append(objectId);
		requestParams.append("&");
		requestParams.append("app_name");
		requestParams.append("=").append(ApplicationProperties.getProperty("APP_NAME_GISA"));
		requestParams.append("&");
		requestParams.append("sostituisciCaller");
		requestParams.append("=").append(ApplicationProperties.getProperty("APP_DOCUMENTALE_SOSTITUISCI_CALLER"));
		requestParams.append("&");
		requestParams.append("tipoTimbro");
		requestParams.append("=").append("GISA");
		requestParams.append("&");
		requestParams.append("idUtente");
		requestParams.append("=").append(user_id);
		requestParams.append("&");
		requestParams.append("ipUtente");
		requestParams.append("=").append(ip);
		requestParams.append("&");
		requestParams.append("urlOriginale");
		requestParams.append("=").append(URLEncoder.encode(urlOriginale, "ISO-8859-1"));
		requestParams.append("&");
		requestParams.append("caller");
		requestParams.append("=").append(URLEncoder.encode(urlChiamante, "ISO-8859-1"));
		requestParams.append("&");
		requestParams.append("idSessione");
		requestParams.append("=").append(context.getSession().getId());
		
		OutputStreamWriter wr = new OutputStreamWriter(conn
					.getOutputStream());
		wr.write(requestParams.toString());
		wr.flush();
		System.out.println("[DOCUMENTALE GISA] CONNESSIONE: "+conn.toString()+"?"+requestParams.toString());
		conn.getContentLength();
	
		String codDocumento="", titolo="";
		BufferedReader in = new BufferedReader( new InputStreamReader(conn.getInputStream()));
		StringBuffer result = new StringBuffer();

		//Leggo l'output: l'header del documento generato e il nome assegnatogli
		if (in != null) {
			String ricevuto = in.readLine();
			result.append(ricevuto); }
			in.close();
		JSONObject jo = new JSONObject(result.toString());
		codDocumento = jo.get("codDocumento").toString();
		titolo = jo.get("titolo").toString();
		context.getRequest().setAttribute("codDocumento", codDocumento);
		context.getRequest().setAttribute("titolo", titolo);
		} catch (MalformedURLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
				context.getRequest().setAttribute("error", "SERVER DOCUMENTALE OFFLINE");
				return "documentaleError";
			}
			finally{
				conn.disconnect();
			}
			return executeCommandDownloadPDF(context);
}


private String getDataCorrente(){
	Calendar calendar = null;
	calendar = Calendar.getInstance();
	int mese = calendar.get(Calendar.MONTH)+1;  
	int anno = calendar.get(Calendar.YEAR);  
	int giorno = calendar.get(Calendar.DAY_OF_MONTH);
	int ora = calendar.get(Calendar.HOUR_OF_DAY);
	int minuti = calendar.get(Calendar.MINUTE);
	
	String giornoString = String.valueOf(giorno);
	  if (giornoString.length()!=2)
		  giornoString = "0"+giorno;
	  
	 String meseString = String.valueOf(mese);
	  if (meseString.length()!=2)
		  meseString = "0"+mese;
	
	String oraString = String.valueOf(ora);
	  if (oraString.length()!=2)
		  oraString = "0"+ora;
	  
	  String minutiString = String.valueOf(minuti);
	  if (minutiString.length()!=2)
		  minutiString = "0"+minuti;
	 		   
     return giornoString + "/"  + meseString + "/" + anno + " " + oraString + ":" + minutiString;
}

private String fixHtml2(String test){

	//rimuovo tutti gli onblur (Non riconosciuti in conversione)
			test = test.replaceAll("(?s)onblur=\".*?\"", "");
			test=test.replaceAll("onblur=\"\"", "");
			
			//rimuovo tutti i readonly
			test=test.replaceAll(" readonly=\"\"", "");
			
			//rimuovo finestra modale di attesa
			test = test.replaceAll("(?s)<div id=\"modalWindow\".*?</div>", "");
			
			/* Estraggo tutti i campi di input */
			
					
			Pattern pattern = Pattern.compile("<input (.*?)>");
		    Matcher matcher = pattern.matcher(test);
		 
		    while (matcher.find()) { 
		    	//System.out.println(matcher.group(1));
		    	String pattern_new = matcher.group(1); // INTERO CAMPO DI INPUT
		    	
		    	Pattern pattern3 = Pattern.compile("type=\"(.*?)\"");
			    Matcher matcher3 = pattern3.matcher(pattern_new);
			    String typeInput="";
			     while (matcher3.find())  // CONTENUTO DEL TYPE
			    	 typeInput = matcher3.group(1);
			    
			     if ((typeInput.equals("text") ||typeInput.equals("number") || typeInput.equals("date") || typeInput.equals("time")) && (!pattern_new.contains("hidden") && !pattern_new.contains("style=\"display: none")))
			     {
			     Pattern pattern4 = Pattern.compile("size=\"(.*?)\"");
				    Matcher matcher4 = pattern4.matcher(pattern_new);
				    String sizeString="";
				    int size = 10;
				    while (matcher4.find())  //CONTENUTO DEL SIZE
				    	   	sizeString = matcher4.group(1);
				    try { 
				    	size = Integer.parseInt(sizeString);
				    } catch(NumberFormatException e) { 
				        size = 10;
				    }
				    
				    Pattern pattern5 = Pattern.compile("class=\"(.*?)\"");
				    Matcher matcher5 = pattern5.matcher(pattern_new);
				    String className="";
				   
				    while (matcher5.find())  //CONTENUTO DEL CLASS
				    	className = matcher5.group(1);
				    
				    className ="layout"; //Sovrascrivo e metto layout
				    
				 Pattern pattern2 = Pattern.compile("value=\"(.*?)\"");
			    Matcher matcher2 = pattern2.matcher(pattern_new);
			    while (matcher2.find()) {
			    	//System.out.println(matcher2.group(1));
			    	String pattern_new2 = matcher2.group(1);
			    	if (pattern_new2.replaceAll(" ", "").replaceAll("&nbsp;", "").equals("")){
			    		for (int i=0;i<size;i++)
			    		pattern_new2 = pattern_new2+"&nbsp;"; 
			    		}
			    	else
			    		pattern_new2=pattern_new2.toUpperCase();
			    	//SOSTITUIRE INPUT TYPE CON LABEL
			    	test = test.replace(pattern_new, "<label class = \""+className+"\">"+pattern_new2+"</label>");
			    
			    		  }
			     }
		      }
		  
		    test = togliTagScript(test);
		    
		    //Gestione RadioButton e checkbox
		    String strRegEx = "<[^>]*radio[^>]*checked[^>]*>";
		    test = test.replaceAll(strRegEx, "[X]") ;
		    
	        strRegEx = "<[^>]*checked[^>]*radio[^>]*>";
	        test = test.replaceAll(strRegEx, "[X]") ;
	        
	        strRegEx = "<[^>]*radio[^>]*>";
	        test = test.replaceAll(strRegEx, "[ ]") ;
	        
	        strRegEx = "<[^>]*checkbox[^>]*checked[^>]*>";
		    test = test.replaceAll(strRegEx, "[X]") ;
		    
	        strRegEx = "<[^>]*checked[^>]*checkbox[^>]*>";
	        test = test.replaceAll(strRegEx, "[X]") ;
	        
	        strRegEx = "<[^>]*checkbox[^>]*>";
	        test = test.replaceAll(strRegEx, "[ ]") ;
	        //Fine gestione radio button e checkbox
		    
			//Rimuovo tutti i tag appesi
		    test=test.replaceAll("label>>", "label>");

		    //gestisco lettere accentate non lette in conversione
			//test = gestioneCaratteriSpeciali(test);
			
		    return test;

}



public String scaricaFileInLocale(ActionContext context) throws SQLException, IOException {
	
	//recupero l'id timbro
		String codDocumento 		=  null;
			codDocumento = context.getRequest().getParameter("codDocumento");
		if (codDocumento==null)
			codDocumento = (String)context.getRequest().getAttribute("codDocumento");
		String idDocumento 				= null;
		idDocumento = context.getRequest().getParameter("idDocumento");
		
		String titolo="";
		String provenienza = ApplicationProperties.getProperty("APP_NAME_GISA");
	
		String download_url = ApplicationProperties.getProperty("APP_DOCUMENTALE_URL")+ApplicationProperties.getProperty("APP_DOCUMENTALE_DOWNLOAD_SERVICE");
		
		if (codDocumento!=null && !codDocumento.equals("null")){
			download_url+="?codDocumento="+codDocumento;
			titolo=codDocumento+".pdf";
		}
		else {
			
			download_url+="?idDocumento="+idDocumento+"&provenienza="+provenienza;
			titolo=provenienza+"_"+idDocumento+".pdf";
		}
		
			if (context.getRequest().getAttribute("titolo")!=null)
				titolo= (String)context.getRequest().getAttribute("titolo");
			
		//Cartella temporanea sull'APP
        String path_doc = getWebInfPath(context,"tmp_documentale");
        //Creare il file ...(ispirarsi a GestoreGlifo servlet)
        
        File theDir = new File(path_doc);
     	theDir.mkdirs();

     	File inputFile = new File(path_doc+titolo);
     	if (!inputFile.exists())
     		inputFile.createNewFile();
     	URL copyurl;
     	InputStream outputFile=null;
    copyurl = new URL(download_url);
    try {
    outputFile = copyurl.openStream();  
    FileOutputStream out2 = new FileOutputStream(inputFile);
    int c;
    while ((c = outputFile.read()) != -1)
        out2.write(c);
    outputFile.close();
    out2.close();
 
     return inputFile.getAbsolutePath();	
}
     
     catch (ConnectException e1){
        	context.getRequest().setAttribute("error", "SERVER DOCUMENTALE OFFLINE");
			return "documentaleError";
        }
        
	}


public String executeCommandGeneraPDFdaHtml(ActionContext context) throws SQLException, IOException, JSONException, ParseException{ 
	
	Boolean documentaleDisponibile = Boolean.valueOf(ApplicationProperties.getProperty("DOCUMENTALE_DISPONIBILE"));
	String documentaleNonDisponibileMessaggio =ApplicationProperties.getProperty("DOCUMENTALE_DISPONIBILE_MESSAGGIO");
	if (!documentaleDisponibile){
		context.getRequest().setAttribute("error", documentaleNonDisponibileMessaggio);
		return "documentaleError";
	}
	
	String test = ""; //conterra' l'html recuperato
	String tipo = context.getRequest().getParameter("tipo"); //tipo certificato
	String orgId = context.getRequest().getParameter("orgId"); 
	String stabId = context.getRequest().getParameter("stabId"); 
	String urlId =  context.getRequest().getParameter("url");
	String idCU = context.getRequest().getParameter("idCU");
	String altId =  context.getRequest().getParameter("altId");
	String ticketId = context.getRequest().getParameter("ticketId"); 
	String htmlcode = context.getRequest().getParameter("htmlcode");

	if (htmlcode==null){
		htmlcode = (String)context.getSession().getAttribute("htmlcode"); 
		context.getSession().removeAttribute("htmlcode");
	}
	String glifo =  context.getRequest().getParameter("glifo");
	String extra =  context.getRequest().getParameter("extra"); //PARAMETRO AGGIUNTIVO PER VALORI NECESSARI SOLO IN ALCUNI DOCUMENTI (es. anno del registro trasgressori)
	String urlOriginale = "";
	
	//Apparo per OPU
	if (urlId!=null && urlId.endsWith("Opu")){
		if (stabId==null)
			stabId=orgId;
			orgId = null;
	}
	//Apparo per SINTESIS
	else if (urlId!=null && urlId.contains("Sintesis")){
		if (altId==null)
			altId=orgId;
			orgId = null;
	}
	//Apparo per NUOVA ANAGRAFICA
			else if (urlId!=null && urlId.contains("Operatoriprivati")){
				if (altId==null)
					altId=orgId;
					orgId = null;
			}
	
	String generazionePulita =  context.getRequest().getParameter("generazionePulita");
	boolean statico = false;
	String urlChiamante = "http://"+context.getRequest().getLocalAddr()+":"+context.getRequest().getLocalPort() + context.getRequest().getContextPath() + "/";
	
	System.out.println("[DOCUMENTALE GISA] urlChiamante: "+urlChiamante);
	
	//inizializzo la variabile glifo nel caso sia null
	//glifo valorizzata: aggiungi timbro
	if (glifo==null || glifo.equals("")){
		glifo="";
	}
	if (orgId==null){
		orgId="-1";
	}
	if (altId==null){
		altId="-1";
	}
	if (stabId==null){
		stabId="-1";
	}
	if (ticketId==null){
		ticketId="-1";
	}if (idCU==null){
		idCU="-1";
	}
	
	if (htmlcode!=null)
		test = htmlcode; //test contiene il sorgente html della pagina
	

	if (test!=null){
		test = fixHtml2(test);
	}
	
	UserBean user = (UserBean) context.getSession().getAttribute("User");
	String ip = context.getIpAddress();
	int user_id = user.getUserRecord().getId();

	String url = ApplicationProperties.getProperty("APP_DOCUMENTALE_URL")+ApplicationProperties.getProperty("APP_DOCUMENTALE_CODIFICA");
	//STAMPE
	System.out.println("\nUrl generato(chiamata a servlet): "+url.toString());
	URL obj;
	HttpURLConnection conn=null;
	
	try {
		obj = new URL(url);
		conn = (HttpURLConnection) obj.openConnection();
		conn.setDoOutput(true);
		conn.setRequestMethod("GET");

		// conn.connect();
		StringBuffer requestParams = new StringBuffer();
		requestParams.append(URLEncoder.encode("html", "UTF-8"));
		requestParams.append("=").append(URLEncoder.encode(test, "UTF-8"));
		requestParams.append("&");
		requestParams.append("tipoCertificato");
		requestParams.append("=").append(tipo);
		requestParams.append("&");
		requestParams.append("orgId");
		requestParams.append("=").append(orgId);
		requestParams.append("&");
		requestParams.append("stabId");
		requestParams.append("=").append(stabId);
		requestParams.append("&");
		requestParams.append("altId");
		requestParams.append("=").append(altId);
		requestParams.append("&");
		requestParams.append("idCU");
		requestParams.append("=").append(idCU);
		requestParams.append("&");
		requestParams.append("ticketId");
		requestParams.append("=").append(ticketId);
		requestParams.append("&");
		requestParams.append("app_name");
		requestParams.append("=").append(ApplicationProperties.getProperty("APP_NAME_GISA"));
		requestParams.append("&");
		requestParams.append("sostituisciCaller");
		requestParams.append("=").append(ApplicationProperties.getProperty("APP_DOCUMENTALE_SOSTITUISCI_CALLER"));
		requestParams.append("&");
		requestParams.append("aggiungiGlifo");
		requestParams.append("=").append(glifo);
		requestParams.append("&");
		requestParams.append("tipoTimbro");
		requestParams.append("=").append("GISA");
		requestParams.append("&");
		requestParams.append("idUtente");
		requestParams.append("=").append(user_id);
		requestParams.append("&");
		requestParams.append("ipUtente");
		requestParams.append("=").append(ip);
		requestParams.append("&");
		requestParams.append("generazionePulita");
		requestParams.append("=").append(generazionePulita);
		requestParams.append("&");
		requestParams.append("statico");
		requestParams.append("=").append(statico);
		requestParams.append("&");
		requestParams.append("extra");
		requestParams.append("=").append(extra);
		requestParams.append("&");
		requestParams.append("urlOriginale");
		requestParams.append("=").append(URLEncoder.encode(urlOriginale, "ISO-8859-1"));
		requestParams.append("&");
		requestParams.append("caller");
		requestParams.append("=").append(URLEncoder.encode(urlChiamante, "ISO-8859-1"));
		requestParams.append("&");
		requestParams.append("idSessione");
		requestParams.append("=").append(context.getSession().getId());
		
		OutputStreamWriter wr = new OutputStreamWriter(conn
					.getOutputStream());
		wr.write(requestParams.toString());
		wr.flush();
		//System.out.println("[DOCUMENTALE GISA] CONNESSIONE: "+conn.toString()+"?"+requestParams.toString());
		System.out.println("[DOCUMENTALE GISA] CONNESSIONE: "+conn.toString());
		conn.getContentLength();
	
		String codDocumento="", titolo="";
		BufferedReader in = new BufferedReader( new InputStreamReader(conn.getInputStream()));
		StringBuffer result = new StringBuffer();

		//Leggo l'output: l'header del documento generato e il nome assegnatogli
		if (in != null) {
			String ricevuto = in.readLine();
			result.append(ricevuto); }
			in.close();
		JSONObject jo = new JSONObject(result.toString());
		codDocumento = jo.get("codDocumento").toString();
		titolo = jo.get("titolo").toString();
		context.getRequest().setAttribute("codDocumento", codDocumento);
		context.getRequest().setAttribute("titolo", titolo);
		} catch (MalformedURLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
				context.getRequest().setAttribute("error", "SERVER DOCUMENTALE OFFLINE");
				return "documentaleError";
			}
			finally{
				conn.disconnect();
			}
			return executeCommandDownloadPDF(context);
}


private String togliTagScript(String test)
{
	int inizio = test.indexOf("<script");
    int fine = test.indexOf("/script>")+8;
    while(inizio>0)
    {
    	
    	String toReplace = test.substring(inizio, fine);
    	test = test.replace(toReplace, "");
    	inizio = test.indexOf("<script");
	    fine = test.indexOf("/script>")+8;
    }
    
    return test;
	
}

private String fixJsonEntita(String jsonEntitaString) throws JSONException { 
	
	if (jsonEntitaString == null)
		return null;
	
	JSONObject jsonRet = new JSONObject();
	
	if (jsonEntitaString.contains("&")){
		jsonEntitaString = jsonEntitaString.replace("{", "");
		jsonEntitaString = jsonEntitaString.replace("}", "");
		jsonEntitaString = jsonEntitaString.replace("'", "");
		String jsonEntitaArray[] = jsonEntitaString.split("&");
		
		for (int i = 0; i< jsonEntitaArray.length; i++){
			if (jsonEntitaArray[i].contains("=")){
				String temp[] = jsonEntitaArray[i].split("=");
				jsonRet.put(temp[0], temp[1]);
			}
			else if (jsonEntitaArray[i].contains(":")){
				String temp[] = jsonEntitaArray[i].split(":");
				jsonRet.put(temp[0], temp[1]);
			}
		}
		jsonEntitaString = jsonRet.toString();
	} else {
		if (!jsonEntitaString.endsWith("}")){
			jsonEntitaString = jsonEntitaString.replace("{", "");
			jsonEntitaString = jsonEntitaString.replace("}", "");
			jsonEntitaString = jsonEntitaString.replace("'", "");
			
			if (jsonEntitaString.contains("=")){
					String temp[] = jsonEntitaString.split("=");
					jsonRet.put(temp[0], temp[1]);
			}
			else if (jsonEntitaString.contains(":")){
					String temp[] = jsonEntitaString.split(":");
					jsonRet.put(temp[0], temp[1]);
				}
			jsonEntitaString = jsonRet.toString();
			}
		}

	return jsonEntitaString;
}
}
