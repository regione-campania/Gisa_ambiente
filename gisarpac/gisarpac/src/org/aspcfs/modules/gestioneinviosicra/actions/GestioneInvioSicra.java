
package org.aspcfs.modules.gestioneinviosicra.actions;
import it.izs.ws.WsPost;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.ConnectException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.logging.Logger;

import javax.mail.MessagingException;
import javax.mail.internet.AddressException;

import org.apache.commons.lang.ArrayUtils;
import org.aspcfs.modules.actions.CFSModule;
import org.aspcfs.modules.gestioneinviosicra.util.SicraUtil;
import org.aspcfs.modules.login.beans.UserBean;
import org.aspcfs.modules.suap.base.PecMailSender;
import org.aspcfs.modules.util.imports.ApplicationProperties;
import org.json.JSONException;
import org.json.JSONObject;

import com.darkhorseventures.framework.actions.ActionContext;


public final class GestioneInvioSicra extends CFSModule {
	Logger logger = Logger.getLogger("MainLogger");

	public String executeCommandInviaInserisciProtocolloEAnagrafiche(ActionContext context) throws JSONException {

		System.out.println(" ------ INVIO DATI A SICRA executeCommandInviaInserisciProtocolloEAnagrafiche -----"); 

		Connection db = null;

		String tipoVerbale = context.getRequest().getParameter("tipoVerbale");
		String oggetto =  context.getRequest().getParameter("oggetto");
		String base64file =  context.getRequest().getParameter("base64file");
		String nomeAllegato =  context.getRequest().getParameter("nomeAllegato");
		String tipoFile =  context.getRequest().getParameter("tipoFile");
		String returnTipo = context.getRequest().getParameter("returnTipo");
		String invioMail = context.getRequest().getParameter("invioMail");
		String mailDestinatari = context.getRequest().getParameter("mailDestinatari");

		int idGiornataIspettiva = -1;
		int idCampione = -1;
		int idArea = -1;		
		
		try {idGiornataIspettiva = Integer.parseInt(context.getRequest().getParameter("idGiornataIspettiva"));} catch (Exception e){}
		try {idCampione = Integer.parseInt(context.getRequest().getParameter("idCampione"));} catch (Exception e){}
		try {idArea = Integer.parseInt(context.getRequest().getParameter("idArea"));} catch (Exception e){}
		
		JSONObject jsonEntita = new JSONObject();
		if (idGiornataIspettiva > 0)
			jsonEntita.put("idGiornataIspettiva", idGiornataIspettiva);
		if (idCampione > 0)
			jsonEntita.put("idCampione", idCampione);
		if (idArea > 0)
			jsonEntita.put("idArea", idArea);
		
		System.out.println(" ------ INVIO DATI A SICRA jsonEntita "+ jsonEntita + " -----");
		
		String pathFile = context.getRequest().getParameter("pathFile");
		
		if (base64file==null || base64file.equals("")) {

		        File file = new File(pathFile);
		        try (FileInputStream imageInFile = new FileInputStream(file)) {
		            // Reading a file from file system
		            byte fileData[] = new byte[(int) file.length()];
		            imageInFile.read(fileData);
		            base64file = Base64.getEncoder().encodeToString(fileData);
		        } catch (FileNotFoundException e) {
		            System.out.println("File not found" + e);
		        } catch (IOException ioe) {
		            System.out.println("Exception while reading the file " + ioe);
		        }
		       
		}

		String esitoInvio[] = {"", "", "", ""};

		try {
			db = this.getConnection(context);

			esitoInvio = gestioneInvioInserisciProtocolloEAnagrafiche(db, jsonEntita, base64file, oggetto, nomeAllegato, tipoFile, tipoVerbale, getUserId(context));

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e); 
			e.printStackTrace();
		} finally{
			freeConnection(context, db);
		}
		
		
		if (invioMail != null && invioMail.equalsIgnoreCase("si"))
		try {
			
			UserBean u =((UserBean) context.getRequest().getSession().getAttribute("User"));
			invioMail((new File(pathFile)), mailDestinatari, nomeAllegato, tipoVerbale, u);
			}catch(Exception e) {}

		context.getRequest().setAttribute("idGiornataIspettiva", String.valueOf(idGiornataIspettiva));
		context.getRequest().setAttribute("idCampione", String.valueOf(idCampione));
		context.getRequest().setAttribute("idArea", String.valueOf(idArea));
		context.getRequest().setAttribute("annoProtocollo", String.valueOf(esitoInvio[2]));
		context.getRequest().setAttribute("numeroProtocollo", String.valueOf(esitoInvio[3]));
		context.getRequest().setAttribute("dataProtocollo", esitoInvio[4]);
		context.getRequest().setAttribute("idDocumento", String.valueOf(esitoInvio[5]));
		context.getRequest().setAttribute("esito", esitoInvio[6]);
		context.getRequest().setAttribute("faultString", esitoInvio[7]);

		if (returnTipo!=null && returnTipo.equalsIgnoreCase("json")) {
		
			context.getResponse().setHeader("Content-disposition","application/json");
	        context.getResponse().setContentType("application/json");
	        // Get the printwriter object from response to write the required json object to the output stream      
	        PrintWriter out;
			try {
				out = context.getResponse().getWriter();
			
	     	// Assuming your json object is jsonObject, perform the following, it will return your json object  
	        JSONObject jo = new JSONObject();
	     	jo.put("Esito", esitoInvio[6]);
	     	jo.put("faultString", esitoInvio[7]);
	     	out.print(jo);
	     	out.flush();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	        return ("-none-");	
		}

		return "InvioOK";
		
	}

	private String[] gestioneInvioInserisciProtocolloEAnagrafiche(Connection db, JSONObject jsonEntita, String base64file, String oggetto, String nomeAllegato, String tipoFile, String tipoVerbale, int idUtente) throws SQLException, JSONException, IOException{

		int idDocumento = -1;
		int numeroProtocollo = -1;
		int annoProtocollo = -1;
		String dataProtocollo = "";

		String esito = "";
		String faultString = null;

		String response = "";

		System.out.println(" ------ INVIO DATI A SICRA "+jsonEntita+" -----"); 

		response= InserisciProtocolloEAnagrafiche(db, jsonEntita, base64file, oggetto, nomeAllegato, tipoFile, tipoVerbale, idUtente);

		if (response==null || response.equals("")){
			esito = "KO";
			faultString = "NESSUNA RISPOSTA DALLA COOPERAZIONE APPLICATIVA";
		}
		else {

			try {idDocumento = Integer.parseInt(SicraUtil.estraiDaPattern("<IdDocumento>", "</IdDocumento>", response));} catch (Exception e) {}
			try {numeroProtocollo = Integer.parseInt(SicraUtil.estraiDaPattern("<NumeroProtocollo>", "</NumeroProtocollo>", response));} catch (Exception e) {}
			try {annoProtocollo = Integer.parseInt(SicraUtil.estraiDaPattern("<AnnoProtocollo>", "</AnnoProtocollo>", response));} catch (Exception e) {}
			try {dataProtocollo =SicraUtil.estraiDaPattern("<DataProtocollo>", "</DataProtocollo>", response);} catch (Exception e) {}
			try {faultString = SicraUtil.estraiDaPattern("<faultstring>", "</faultstring>", response);} catch (Exception e) {}

			if (idDocumento>0)
				esito = "OK";
			else
				esito = "KO";
		}

		//AGGIORNA ESITO
		if (jsonEntita.has("idGiornataIspettiva") && (int) jsonEntita.get("idGiornataIspettiva") > 0)
			aggiornaDatiProtocolloGiornataIspettiva(db,  (int) jsonEntita.get("idGiornataIspettiva"), tipoVerbale, idDocumento, numeroProtocollo, annoProtocollo, dataProtocollo, esito, faultString, base64file, idUtente);
		else if (jsonEntita.has("idCampione") && (int) jsonEntita.get("idCampione") > 0)
			aggiornaDatiProtocolloCampione(db,  (int) jsonEntita.get("idCampione"), tipoVerbale, idDocumento, numeroProtocollo, annoProtocollo, dataProtocollo, esito, faultString, base64file, idUtente);
		else if (jsonEntita.has("idArea") && (int) jsonEntita.get("idArea") > 0)
			aggiornaDatiProtocolloArea(db,  (int) jsonEntita.get("idArea"), tipoVerbale, idDocumento, numeroProtocollo, annoProtocollo, dataProtocollo, esito, faultString, base64file, idUtente);
		
		String esitoInvio[] = {"", "", String.valueOf(annoProtocollo), String.valueOf(numeroProtocollo), dataProtocollo, String.valueOf(idDocumento), esito, faultString};
		return esitoInvio;

	}


	private void aggiornaDatiProtocolloGiornataIspettiva(Connection db, int idGiornataIspettiva, String tipoVerbale, int idDocumento, int numeroProtocollo, int annoProtocollo, String dataProtocollo, String esito, String faultString, String base64file, int userId) throws SQLException {
		PreparedStatement pst = db.prepareStatement("select * from aggiorna_giornate_ispettive_verbali_protocolli(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"); 
		int i = 0; 
		pst.setInt(++i, idGiornataIspettiva);
		pst.setString(++i, tipoVerbale);
		pst.setInt(++i, idDocumento);
		pst.setInt(++i, numeroProtocollo);
		pst.setInt(++i, annoProtocollo);
		pst.setString(++i, dataProtocollo);
		pst.setString(++i, esito);
		pst.setString(++i, faultString);
		pst.setString(++i, base64file);
		pst.setInt(++i, userId);
		pst.executeQuery();
	}
	
	private void aggiornaDatiProtocolloCampione(Connection db, int idCampione, String tipoVerbale, int idDocumento, int numeroProtocollo, int annoProtocollo, String dataProtocollo, String esito, String faultString, String base64file, int userId) throws SQLException {
		PreparedStatement pst = db.prepareStatement("select * from aggiorna_campioni_verbali_protocolli(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"); 
		int i = 0; 
		pst.setInt(++i, idCampione);
		pst.setString(++i, tipoVerbale);
		pst.setInt(++i, idDocumento);
		pst.setInt(++i, numeroProtocollo);
		pst.setInt(++i, annoProtocollo);
		pst.setString(++i, dataProtocollo);
		pst.setString(++i, esito);
		pst.setString(++i, faultString);
		pst.setString(++i, base64file);
		pst.setInt(++i, userId);
		pst.executeQuery();
	}
	
	private void aggiornaDatiProtocolloArea(Connection db, int idArea, String tipoVerbale, int idDocumento, int numeroProtocollo, int annoProtocollo, String dataProtocollo, String esito, String faultString, String base64file, int userId) throws SQLException {
		PreparedStatement pst = db.prepareStatement("select * from aggiorna_aree_verbali_protocolli(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"); 
		int i = 0; 
		pst.setInt(++i, idArea);
		pst.setString(++i, tipoVerbale);
		pst.setInt(++i, idDocumento);
		pst.setInt(++i, numeroProtocollo);
		pst.setInt(++i, annoProtocollo);
		pst.setString(++i, dataProtocollo);
		pst.setString(++i, esito);
		pst.setString(++i, faultString);
		pst.setString(++i, base64file);
		pst.setInt(++i, userId);
		pst.executeQuery();
	}

	private String InserisciProtocolloEAnagrafiche(Connection db, JSONObject jsonEntita, String base64file, String oggetto, String nomeAllegato, String tipoFile, String tipoVerbale, int idUtente) throws SQLException, IOException{

		WsPost ws = new WsPost();
		String envelope = null;
		String response = null;
		PreparedStatement pst = null;
		ResultSet rs = null;
		
		String entita = "";
		
		try {
		String key = (String) jsonEntita.keys().next();
		int value = (int) jsonEntita.getInt(key);
		entita = key+":"+value;
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		logger.info(" ------ INVIO DATI InserisciProtocolloEAnagrafiche A SICRA "+entita+" -----");
		ws.setWsUrl(ApplicationProperties.getProperty("END_POINT_SICRA"));

		pst = db.prepareStatement("select * from get_chiamata_ws_sicra_inserisci_protocollo_e_anagrafiche(?, ?, ?, ?, ?, ?)");
		int i = 0;
		pst.setString(++i, entita);
		pst.setString(++i, base64file);
		pst.setString(++i, oggetto);
		pst.setString(++i, nomeAllegato);
		pst.setString(++i, tipoFile);
		pst.setString(++i, tipoVerbale);

		logger.info(" ------ INVIO DATI InserisciProtocolloEAnagrafiche A SICRA dbi: "+pst.toString()+" -----");
		rs = pst.executeQuery();
		while (rs.next())
			envelope = rs.getString(1);

		ws.setWsRequest(envelope); 
		response= ws.postWithHeader(db, idUtente, "SOAPAction", "http://tempuri.org/InserisciProtocolloEAnagrafiche");

		return response;
	}


		
	
	public String executeCommandInviaLeggiProtocollo(ActionContext context) {

		Connection db = null;

		int annoProtocollo = Integer.parseInt(context.getRequest().getParameter("annoProtocollo"));
		int numeroProtocollo =  Integer.parseInt(context.getRequest().getParameter("numeroProtocollo"));
		
		String[] esitoInvio ={"", "", "", ""};

		try {
			db = this.getConnection(context);

			esitoInvio = gestioneInvioLeggiProtocollo(db, annoProtocollo, numeroProtocollo, getUserId(context));

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e); 
			e.printStackTrace();
		} finally{
			freeConnection(context, db);
		}

		context.getRequest().setAttribute("annoProtocollo", String.valueOf(esitoInvio[0]));
		context.getRequest().setAttribute("numeroProtocollo", String.valueOf(esitoInvio[1]));
		context.getRequest().setAttribute("dataProtocollo", esitoInvio[2]);
		context.getRequest().setAttribute("idDocumento", String.valueOf(esitoInvio[3]));
		context.getRequest().setAttribute("oggetto", String.valueOf(esitoInvio[4]));
		context.getRequest().setAttribute("tipoDocumento", String.valueOf(esitoInvio[5]));
		context.getRequest().setAttribute("tipoDocumentoDescrizione", String.valueOf(esitoInvio[6]));
		context.getRequest().setAttribute("dataInserimento", String.valueOf(esitoInvio[7]));
		context.getRequest().setAttribute("tipoFile", String.valueOf(esitoInvio[8]));
		context.getRequest().setAttribute("base64file", String.valueOf(esitoInvio[9]));
		context.getRequest().setAttribute("commento", String.valueOf(esitoInvio[10]));
		context.getRequest().setAttribute("nomeAllegato", String.valueOf(esitoInvio[11]));
		context.getRequest().setAttribute("esito", esitoInvio[12]);
		context.getRequest().setAttribute("faultString", esitoInvio[13]);		

		return "LeggiOK";

	}

	private String[] gestioneInvioLeggiProtocollo(Connection db,int annoProtocollo, int numeroProtocollo, int idUtente) throws SQLException, IOException{

		int r_idDocumento = -1;
		int r_annoProtocollo = -1;
		int r_numeroProtocollo = -1;
		String r_dataProtocollo = "";
		String r_oggetto = "";
		String r_tipoDocumento = "";
		String r_tipoDocumentoDescrizione = "";
		String r_dataInserimento = "";
		String r_tipoFile ="";
		String r_base64file = "";
		String r_commento = "";
		String r_nomeAllegato = "";

		String esito = "";
		String faultString = null;

		String response = "";

		System.out.println(" ------ INVIO DATI A SICRA numeroProtocollo "+numeroProtocollo+" -----"); 

		// ----------------------------------------- CHECKLIST

		response= LeggiProtocollo(db, annoProtocollo, numeroProtocollo, idUtente);

		if (response==null || response.equals("")){
			esito = "KO";
			faultString = "NESSUNA RISPOSTA DALLA COOPERAZIONE APPLICATIVA";
		}
		else {

			try {r_idDocumento = Integer.parseInt(SicraUtil.estraiDaPattern("<IdDocumento>", "</IdDocumento>", response));} catch (Exception e) {}
			try {r_numeroProtocollo = Integer.parseInt(SicraUtil.estraiDaPattern("<NumeroProtocollo>", "</NumeroProtocollo>", response));} catch (Exception e) {}
			try {r_annoProtocollo = Integer.parseInt(SicraUtil.estraiDaPattern("<AnnoProtocollo>", "</AnnoProtocollo>", response));} catch (Exception e) {}
			try {r_dataProtocollo =SicraUtil.estraiDaPattern("<DataProtocollo>", "</DataProtocollo>", response);} catch (Exception e) {}
			try {r_oggetto =SicraUtil.estraiDaPattern("<Oggetto>", "</Oggetto>", response);} catch (Exception e) {}
			try {r_tipoDocumento =SicraUtil.estraiDaPattern("<TipoDocumento>", "</TipoDocumento>", response);} catch (Exception e) {}
			try {r_tipoDocumentoDescrizione =SicraUtil.estraiDaPattern("<TipoDocumento_Descrizione>", "</TipoDocumento_Descrizione>", response);} catch (Exception e) {}
			try {r_dataInserimento =SicraUtil.estraiDaPattern("<DataInserimento>", "</DataInserimento>", response);} catch (Exception e) {}
			try {r_tipoFile =SicraUtil.estraiDaPattern("<TipoFile>", "</TipoFile>", response);} catch (Exception e) {}
			try {r_base64file =SicraUtil.estraiDaPattern("<Image>", "</Image>", response);} catch (Exception e) {}
			try {r_commento =SicraUtil.estraiDaPattern("<Commento>", "</Commento>", response);} catch (Exception e) {}
			try {r_nomeAllegato =SicraUtil.estraiDaPattern("<NomeAllegato>", "</NomeAllegato>", response);} catch (Exception e) {}

			if (r_idDocumento>0)
				esito = "OK";
			else
				esito = "KO";
		}

		String esitoInvio[] = {String.valueOf(r_annoProtocollo), String.valueOf(r_numeroProtocollo), r_dataProtocollo, String.valueOf(r_idDocumento), r_oggetto, r_tipoDocumento, r_tipoDocumentoDescrizione, r_dataInserimento, r_tipoFile, r_base64file, r_commento, r_nomeAllegato,  esito, faultString};
		return esitoInvio;

	}


	private String LeggiProtocollo(Connection db, int annoProtocollo, int numeroProtocollo, int idUtente) throws SQLException, IOException{

		WsPost ws = new WsPost();
		String envelope = null;
		String response = null;
		PreparedStatement pst = null;
		ResultSet rs = null;

		logger.info(" ------ INVIO DATI LeggiProtocollo A SICRA numeroProtocollo "+numeroProtocollo+" -----");
		ws.setWsUrl(ApplicationProperties.getProperty("END_POINT_SICRA"));

		pst = db.prepareStatement("select * from get_chiamata_ws_sicra_leggi_protocollo(?, ?)");
		int i = 0;
		pst.setInt(++i, annoProtocollo);
		pst.setInt(++i, numeroProtocollo);
		
		logger.info(" ------ INVIO DATI LeggiProtocollo A SICRA dbi: "+pst.toString()+" -----");
		rs = pst.executeQuery();
		while (rs.next())
			envelope = rs.getString(1);

		ws.setWsRequest(envelope); 
		response= ws.postWithHeader(db, idUtente, "SOAPAction", "http://tempuri.org/LeggiProtocollo");

		return response;
	}

	
	public String executeCommandDownloadProtocollo(ActionContext context) throws SQLException, IOException {
	
		int annoProtocollo = Integer.parseInt(context.getRequest().getParameter("annoProtocollo"));
		int numeroProtocollo =  Integer.parseInt(context.getRequest().getParameter("numeroProtocollo"));
		
		String[] esitoInvio ={"", "", "", ""};
		
		Connection db = null;

		try {
			db = this.getConnection(context);

			esitoInvio = gestioneInvioLeggiProtocollo(db, annoProtocollo, numeroProtocollo, getUserId(context));

		} catch (Exception e) {
			context.getRequest().setAttribute("Error", e); 
			e.printStackTrace();
		} finally{
			freeConnection(context, db);
		}

		
		String base64 = new String(esitoInvio[9]);
		String tipoFile = esitoInvio[8];
		String nomeAllegato = esitoInvio[11];
		
		// Cartella temporanea sull'APP
		String path_doc = getWebInfPath(context, "tmp_file");

		File theDir = new File(path_doc);
		theDir.mkdirs();

		File outputFile = new File(path_doc + nomeAllegato);
		if (!outputFile.exists())
			outputFile.createNewFile();
		
		 try ( FileOutputStream fos = new FileOutputStream(outputFile); ) {
		      // To be short I use a corrupted PDF string, so make sure to use a valid one if you want to preview the PDF file
		      byte[] decoder = Base64.getDecoder().decode(base64);
		      fos.write(decoder);
		      System.out.println("File Saved");
		    } catch (Exception e) {
		      e.printStackTrace();
		    }
	
	
		try {
		
			String fileType = "";
			context.getResponse().setContentType(fileType);
			context.getResponse().setHeader("Content-disposition", "attachment; filename=" + nomeAllegato);

			File my_file = new File(outputFile.getAbsolutePath());

			// This should send the file to browser
			OutputStream out = context.getResponse().getOutputStream();
			FileInputStream in = new FileInputStream(my_file);
			byte[] buffer = new byte[4096];
			int length;
			while ((length = in.read(buffer)) > 0) {
				try {
					out.write(buffer, 0, length);
				} catch (Exception e1) {
					in.close();
					System.out.println("Sessione invalidata");
					return ("-none-");
				}
			}
			in.close();
			out.flush();
			return ("-none-");
		}

		catch (ConnectException e1) {
			context.getRequest().setAttribute("error", "SERVER DOCUMENTALE OFFLINE");
			context.getRequest().setAttribute("label", "documents");
			return "documentaleAllegatiError";
		}

	}
	
	private void invioMail(File allegato, String altriDestinatari, String nomeAllegato, String tipoVerbale, UserBean user){
		
		String from=ApplicationProperties.getProperty("SENDER_EMAIL_FIRMA");
		String toDest=ApplicationProperties.getProperty("DEST_EMAIL_FIRMA");
		String object=ApplicationProperties.getProperty("OGGETTO_EMAIL_FIRMA");

		String dateFormat = "dd/MM/yyyy HH:mm";
		String data =new SimpleDateFormat(dateFormat).format(new Date());
		
		String testo = "E' stato generato un nuovo documento firmato.<br/><br/>"
				+ "Data: "+ data + "<br/>"
				+ "Tipo: "+ tipoVerbale + "<br/>"
				+ "Nome: "+ nomeAllegato + "<br/>"
				+ "Utente: "+ user.getContact().getNameFirst() + " " + user.getContact().getNameLast();
		
		String[] toDestArray = toDest.split(";");
		String[] toAltriDestArray = altriDestinatari.split(";");
		
		String[] tuttiDestArray  = new String []{"", ""};
		
		if (toAltriDestArray.length>0)
			tuttiDestArray = (String[]) ArrayUtils.addAll(toDestArray, toAltriDestArray);
		else
			tuttiDestArray = toDestArray;
		
		HashMap<String,String> configs = new HashMap<String,String>();
		configs.put("mail.smtp.starttls.enable",ApplicationProperties.getProperty("mail.smtp.starttls.enable"));
		configs.put("mail.smtp.auth", ApplicationProperties.getProperty("mail.smtp.auth"));
		configs.put("mail.smtp.host", ApplicationProperties.getProperty("mail.smtp.host"));
		configs.put("mail.smtp.port", ApplicationProperties.getProperty("mail.smtp.port"));
		configs.put("mail.smtp.ssl.enable",ApplicationProperties.getProperty("mail.smtp.ssl.enable"));
		configs.put("mail.smtp.ssl.protocols", ApplicationProperties.getProperty("mail.smtp.ssl.protocols"));
		configs.put("mail.smtp.socketFactory.class", ApplicationProperties.getProperty("mail.smtp.socketFactory.class"));
		configs.put("mail.smtp.socketFactory.fallback", ApplicationProperties.getProperty("mail.smtp.socketFactory.fallback"));
		
		PecMailSender sender = new PecMailSender(configs,ApplicationProperties.getProperty("username"), ApplicationProperties.getProperty("password"));
		try {
			System.out.println("[INVIO MAIL] "+object +"a: "+toDest+";"+altriDestinatari+" - "+ testo);
			sender.sendMailConAllegato(object,testo,from, tuttiDestArray, allegato);
		} catch (AddressException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}



	
	}
	
}
