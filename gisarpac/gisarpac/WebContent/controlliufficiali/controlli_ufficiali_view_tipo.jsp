<jsp:useBean id="TipoIspezione" class="org.aspcfs.utils.web.LookupList" scope="request"/>

<jsp:useBean id="listaCodiciEstesi" class="java.util.ArrayList" scope="request"/>

<jsp:useBean id="ListaDistribuzione" class="org.aspcfs.modules.allerte_new.base.ListaDistribuzione" scope="request"/>

<%! public static boolean inLista(ArrayList<String> listaCodiciEstesi, String value)
  {
	if (listaCodiciEstesi!=null)
	for (int i =0; i<listaCodiciEstesi.size(); i++){
		if (listaCodiciEstesi.get(i).equals(value))
			return true;
	}
	return false;
  }%>
  

<script type="text/javascript">
function openPopup(url){
	var res;
	var result;
		window.open(url,'popupSelect',
		'height=400px,width=200px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
}

function openPopupLarge(url){
	var res;
	var result;
		window.open(url,'popupSelect',
		'height=300px,width=500px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
}

function openPopupBox(url){
	var res;
	var result;
		window.open(url,'popupSelect', 
		'height=500px,width=500px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
}
</script>

<tr class="containerBody">
	<td name="tipoCampione1" id="tipoCampione1" nowrap class="formLabel">
	<dhv:label name="">Tecnica del controllo ufficiale</dhv:label></td>
	<td>
	<%
		String tipoControllo1 = "";
		if (TicketDetails.getTipoCampione() == 23 || TicketDetails.getTipoCampione() == 7) {

			
			if(TicketDetails.getTipoCampione() == 3){
				tipoControllo1 = "Audit - ";
			}
			else if(TicketDetails.getTipoCampione() == 7){
				tipoControllo1 = "Audit interno - ";
			}
			else{
				tipoControllo1 = "Audit di follow up - ";
			}
			
			tipoControllo1 = tipoControllo1 +
					 AuditTipo.getSelectedValue(TicketDetails
							.getAuditTipo());

			if (TicketDetails.getAuditTipo() == 1) {
				String bpi = "";
				String haccp = "";
				String tipiaudit = "<b>Oggetto dell audit</b><br>";

				Iterator<Integer> itTipoAudit = TicketDetails.getTipoAudit().keySet().iterator();
				while (itTipoAudit.hasNext()) {
					int tipoAudit = itTipoAudit.next();
					String descrizioneTipoAudit = TicketDetails.getTipoAudit().get(tipoAudit);

					tipiaudit += descrizioneTipoAudit + "<br/>";

				}

				if (TicketDetails.getTipoAudit().containsKey(2)) {

					HashMap<Integer, String> listaBpi = TicketDetails
							.getLisaElementibpi();
					Iterator<Integer> valoriBpiSel = TicketDetails
							.getLisaElementibpi().keySet().iterator();

					while (valoriBpiSel.hasNext()) {
						String bpiSel = listaBpi.get(valoriBpiSel.next());

						bpi = bpi + " " + bpiSel + " - ";
					}

				}

				if (TicketDetails.getTipoAudit().containsKey(3)) {

					HashMap<Integer, String> listahaccp = TicketDetails
							.getLisaElementihaccp();
					Iterator<Integer> valoriHaccpSel = TicketDetails
							.getLisaElementihaccp().keySet().iterator();

					while (valoriHaccpSel.hasNext()) {
						String haccpSel = listahaccp.get(valoriHaccpSel
								.next());

						haccp = haccp + " " + haccpSel + " - ";
					}

				}

				out.print(tipoControllo1 + "<br>");

				out.println(tipiaudit);

				if (!bpi.equals(""))
					out.println("<br><b>BPI</b><br>" + bpi + "<br>");
				if (!haccp.equals(""))
					out.println("<br><b>HACCP</b><br> : " + haccp + "<br>");
			} else {
				out.print(tipoControllo1 + "<br>");
			}

		} else if (TicketDetails.getTipoCampione() == 4 || TicketDetails.getTipoCampione() == 3 ) {

			
			if (TicketDetails.getTipoCampione() == 4)
			tipoControllo1 = "Ispezione Semplice <br>";
			else if (TicketDetails.getTipoCampione() == 3){
				tipoControllo1 = "Audit <br>";
			}
			String tipiispezione = "<br><b>Motivo ispezione</b><br>";
			String piani = "";
			Iterator<Integer> itTipoIspezione = TicketDetails
					.getTipoIspezione().keySet().iterator();
			
			
			
			while (itTipoIspezione.hasNext()) {
				int tipoIspezione = itTipoIspezione.next();
				String descrizioneTipoIspezione = TicketDetails.getTipoIspezione().get(tipoIspezione);

				String infoTipoIspezione = "";
				if (TipoIspezione.getElementfromValue(tipoIspezione)!=null)
				{
				String codInterno = TipoIspezione.getElementfromValue(tipoIspezione).getCodiceInterno();
				
				
				if (inLista(listaCodiciEstesi, codInterno)){ 
					String url = "CuHtmlFieldsAction.do?command=TicketDetailsEstesi&idCU="+TicketDetails.getId()+"&idCodiceInterno="+codInterno;
					infoTipoIspezione = "<input type=\"button\" onClick=\"openPopup('"+url+"')\" value=\"info\"/>";
					} 
				descrizioneTipoIspezione = descrizioneTipoIspezione+infoTipoIspezione;
				}

				String percontidi = "" ;
				if (TicketDetails.getLista_uo_ispezione().containsKey(tipoIspezione))
				{
					if(TicketDetails.getLista_uo_ispezione().get(tipoIspezione)!=null)
						percontidi =TicketDetails.getLista_uo_ispezione().get(tipoIspezione).getDescrizione_lunga();
				}
				if (percontidi!= null && !percontidi.equals(""))
					tipiispezione += descrizioneTipoIspezione + " <b>Per conto di :</b>"+percontidi+ "<br/>";
					else
						tipiispezione += descrizioneTipoIspezione + "<br/>";
				
			}


			out.print(tipoControllo1);
			out.print(tipiispezione);
			
			if (TicketDetails.tipoIspezioneCodiceInternoContainsIgnoreCase("58a")) {
				
				if (!TicketDetails.getAzioneIsNull()){
					if (TicketDetails.isAzione()){
						
						out.print("<br>Le azioni correttive risultano adeguate ed efficaci");					
						out.print(TicketDetails.getAzione_descrizione()!=null && !TicketDetails.getAzione_descrizione().equals("") ? " - Descrizione : "+ TicketDetails.getAzione_descrizione():"");
						out.print("<br>");
					} else {
						out.print("<br>Le azioni correttive non risultano adeguate ed efficaci<br>");
					}
				} else {
					out.print("<br>Azioni Correttive N.D.<br>");
				}
				
				String contributi = "<br>Contributi in Euro (solo nei casi in cui &egrave; previsto dal D.Lgs 194/2008) : "+ TicketDetails.getContributi_verifica_risoluzione_nc() +"<br>";
				out.print(contributi);
			}

			if (TicketDetails.tipoIspezioneCodiceInternoContainsIgnoreCase("4a") && TicketDetails.getIspezioneAltro() != null) {
				out.print("Note : " + TicketDetails.getIspezioneAltro());
			}

		} else {
			if (TicketDetails.getTipoCampione() == 5) {

				out.print("Ispezione con la tecnica della sorveglianza");

			}
			else
			{
				out.print(TipoCampione.getSelectedValue(TicketDetails.getTipoCampione()));
			}
		}
	%> <input type="hidden" name="tipoCampione"
		value="<%=TicketDetails.getTipoCampione()%>"> </td>
</tr>


<%if (TicketDetails.getListaStruttureControllareAutoritaCompetenti().size()>0)
{
	%>
	<tr class="containerBody" >
    <td nowrap class="formLabel">
      Strutture Controllate
    </td>
    <td>
    <%
    HashMap<Integer,OiaNodo > listaStruttureControllate = TicketDetails.getListaStruttureControllareAutoritaCompetenti();
    Iterator<Integer> itstrutt = listaStruttureControllate.keySet().iterator();
   while (itstrutt.hasNext())
    {
    	out.println(""+listaStruttureControllate.get(itstrutt.next()).getDescrizione_lunga()+ "<br>");
    }
    %>
</td></tr>
	<%
}
	%>
	
	
<%
if (TicketDetails.getAuditTipo()==2 || TicketDetails.getAuditTipo()==3 || TicketDetails.getAuditTipo()==101 || TicketDetails.getAuditTipo()==102 || TicketDetails.getAuditTipo()==103)
{
%>
<tr class="containerBody" >
    <td nowrap class="formLabel">
      Oggetto Dell'Audit
    </td>
    <td>
    <%
    HashMap<Integer,String > mapOggettoAudit = TicketDetails.getOggettoAudit();
    Iterator<Integer> itOggAudit = mapOggettoAudit.keySet().iterator();
   while (itOggAudit.hasNext())
    {
    	out.println(""+mapOggettoAudit.get(itOggAudit.next())+ "<br>");
    }
    %>
</td></tr>




<% if (TicketDetails.getAuditTipo()==101 || TicketDetails.getAuditTipo()==102 || TicketDetails.getAuditTipo()==103)
{ %>
<tr class="containerBody"><td nowrap class="formLabel">Audit di follow up?</td> <td>
<% if (Boolean.TRUE.equals(TicketDetails.isAuditDiFollowUp())){%>
SI
<%} else if (Boolean.FALSE.equals(TicketDetails.isAuditDiFollowUp())){%>
NO
<%} else {%>
&nbsp;<%} %>
</td></tr>
<% } %>
<%
	

}
%>


<%
if (TicketDetails.getTipoCampione()==22)
{
%>
   <tr class="containerBody" id = "hidden3"  >
    <td nowrap class="formLabel">
      <dhv:label name="sanzionia.data_richiesta">Verbale</dhv:label>
    </td>
    <td>
    <table class = "noborder">
    <tr><td>
     <a href="GestioneAllegatiUpload.do?command=DownloadPDF&codDocumento=<%=TicketDetails.getHeaderAllegatoDocumentale()%>&nomeDocumento=VerbaleSupervisione"><b><u>Verbale</u></b></a>
	     	
    </td>
   
    
    </tr></table></td>
  </tr>
<% } %>

<%


	// Se il CU è "ISPEZIONE/IN SORVEGLIANZA" il codice Ateco non deve essere visualizzato
	if ((TicketDetails.getTipoCampione() == 5)) {
	} else {
		
		if (request.getAttribute("linea_attivita") != null) {

			ArrayList<LineeAttivita> linee = (ArrayList<LineeAttivita>) request
					.getAttribute("linea_attivita");
%>
<tr class="containerBody">
	<td valign="top" class="formLabel">Linea Attività Sottoposta a
	Controllo</td>

	<td>
	<table class="noborder">
		<%
			for (LineeAttivita linea_di_attivita : linee) {
			
		%>
		<tr>
		
			<% if (linea_di_attivita.isMappato()) { %>
<%-- 				<td><%=((linea_di_attivita.getMacroarea()!=null ? linea_di_attivita.getMacroarea()+""  : "") + " - " +(linea_di_attivita.getAggregazione()!=null ? linea_di_attivita.getAggregazione()+""  : "")+ " - " + linea_di_attivita.getAttivita())%></td> --%>
				<td><%= linea_di_attivita.getAttivita()%></td>
			<% } else if (linea_di_attivita.getAttivita() != null && !linea_di_attivita.getAttivita().equals("null")) { %>
				<td><%=( (linea_di_attivita.getMacroarea()!=null ? linea_di_attivita.getMacroarea()+" - "  : "") + " - " +linea_di_attivita.getCategoria()+ " - " + linea_di_attivita.getLinea_attivita()+ " - " + linea_di_attivita.getAttivita())%></td>
				<% } else { %>
				<td><%=( (linea_di_attivita.getMacroarea()!=null ? linea_di_attivita.getMacroarea()+" - "  : "")  +linea_di_attivita.getCategoria()+ " - " + linea_di_attivita.getLinea_attivita()) %></td>
				<% } %>
		</tr>
		<%
			}
		%>
	</table>

	</td>
</tr>
<%
	} else {
			if (request.getAttribute("linee_attivita_stabilimenti") != null) {
				ArrayList<LineaAttivitaSoa> linee = (ArrayList<LineaAttivitaSoa>) request
						.getAttribute("linee_attivita_stabilimenti");
%>
<tr class="containerBody">
	<td valign="top" class="formLabel">Linea Attività Sottoposta a
	Controllo</td>

	<td>
	<table class="noborder">
		<%
			for (LineaAttivitaSoa linea_di_attivita : linee) {
		%>
		<tr>
			<td><%=(linea_di_attivita.getCategoria())%> -> <%=(linea_di_attivita.getImpianto())%></td> <!-- //modifica 14/12 -->
		</tr>
		<%
			}
		%>
	</table>

	</td>
</tr>

<%
	}

		}

	}
%>

<%
if(TicketDetails.getNoteOperatoreMercatoIttico()!=null)
{
%>
	<tr class="containerBody">
	<td nowrap class="formLabel">Note operatore mercato ittico </td>
	<td>
	<%=TicketDetails.getNoteOperatoreMercatoIttico()%>
	</td>
	</tr>
<%
}%>





<%
if((TicketDetails.getLista_unita_operative()!=null  && ! TicketDetails.getLista_unita_operative().isEmpty() && TicketDetails.getLista_unita_operative().size()>0))
{
%>
	<tr class="containerBody">
	<td nowrap class="formLabel">Per Conto di </td>
	<td>
	<%
	for(OiaNodo uo : TicketDetails.getLista_unita_operative() )
	{
		out.println(uo.getDescrizione_lunga()+ "<br>");
		
	}
	
	%>
	</td>
	</tr>


<%
}
	if (TicketDetails.getTipoIspezioneCodiceInterno().contains("5a") || TicketDetails.getTipoIspezioneCodiceInterno().contains("30a")) {
%>
<tr>
	<td nowrap class="formLabel">Rilascio Certificazione
	<td>
	<table class="noborder">
		<tr>
			<td>&nbsp;&nbsp;Contributi in Euro <br>
			(solo nei casi in cui è previsto <br>
			dal D.Lgs 194/2008)</td>
			<td>&nbsp;&nbsp;<%=TicketDetails
										.getContributi_rilascio_certificazione()%></td>
		</tr>
	</table>
	</td>
</tr>

<%
	}%>
	

<%
	if (TicketDetails.getTipoIspezioneCodiceInterno().contains("9a")) {
%>
<tr>
	<td nowrap class="formLabel">Tipo di sospetto<td>
	<table class="noborder">
		<tr class="noborder">
			<td><%=TicketDetails.getTipoSospetto()%></td>
			<td>
			<% if(BufferDetails.getCodiceBuffer()!= null) {%>
			&nbsp;&nbsp;Codice buffer: <%= (BufferDetails.getCodiceBuffer()!= null && !BufferDetails.getCodiceBuffer().equals("")) ? BufferDetails.getCodiceBuffer() : "N.D"%><br>
			&nbsp;&nbsp;Data:<%=(BufferDetails.getDataEvento()!= null && !BufferDetails.getDataEvento().equals("")) ? (new SimpleDateFormat("dd/MM/yyyy"))
					.format(BufferDetails.getDataEvento()) : "N.D"%><br>
			&nbsp;&nbsp;Comuni coinvolti: <%
				for (org.aspcfs.modules.buffer.base.Comune c : BufferDetails.getListaComuni())
				{
					out.println("- "+c.getDescrizione());
				}
			
			} %>
				
			</td>	 		
		</tr>
	</table>
	</td>
</tr>

<%
	}%>	
	
<%
	if (TicketDetails.getTipoIspezioneCodiceInterno().contains("20a")) {
%>
<tr id="svincolisanitari">
	<td class="formLabel">Svincoli Sanitari
	<td>
	<table class="noborder">
		<tr>
			<td>Data Preavviso</td>
			<td><%=TicketDetails.getData_preavvisoasString()%></td>
			<td>Protocollo Preavviso</td>
			<td><%=TicketDetails.getProtocollo_preavviso()%></td>

		</tr>
		<tr>
			<td>Data Comunicazione Svincolo</td>
			<td><%=TicketDetails.getcomunicazione_svincoloasString()%></td>
			<td>Protocollo Svincolo</td>
			<td><%=TicketDetails.getProtocollo_svincolo()%></td>

		</tr>
		<tr>
			<td>Tipologia Sottoprodotto</td>
			<td><%=TicketDetails.getTipologia_sottoprodotto()%></td>
			<td>Peso</td>
			<td><%=TicketDetails.getPeso()%></td>

		</tr>
	</table>
	</td>
</tr>

<%
	}

boolean flagCondizionalita= false ;
%>



<%
if (TicketDetails.getTipoIspezioneCodiceInterno().contains("47a")) // in piano di monitoraggio
{
	flagCondizionalita=true;
}
	if (TicketDetails.getTipoIspezioneCodiceInterno().contains("2a")) // in piano di monitoraggio
	{

		Iterator<Integer> kiave = TicketDetails
				.getLisaElementipianoMonitoraggio_ispezioni().keySet()
				.iterator();
%>

	
	
<tr class="containerBody">
	<td nowrap class="formLabel">Lista Piani</td>

	<td>
	<table class="noborder">
		<%
			int i = 1;
				for(Piano p :TicketDetails.getPianoMonitoraggio()) {
					
					if ("982".equalsIgnoreCase(p.getCodice_interno())  || "983".equalsIgnoreCase(p.getCodice_interno())  || "1483".equalsIgnoreCase(p.getCodice_interno()))
					{
						flagCondizionalita=true;
					}

				
		%>
		<tr>
			<td>
			
			<%=i+ ") "+ p.getDescrizione()%></td>
												<td><%="<b>PER CONTO DI <b>"+p.getDesc_uo() %> 
												
												<%if (inLista(listaCodiciEstesi, p.getCodice_interno())){ 
												String url = "CuHtmlFieldsAction.do?command=TicketDetailsEstesi&idCU="+TicketDetails.getId()+"&idCodiceInterno="+p.getCodice_interno();%> 
												<input type="button" onClick="openPopup('<%=url %>')" value="info"/><%} %>
												
												</td>
										
		</tr>
		<%
			i++;
				}
		%>


	</table>

	</td>
</tr>
<%
	}
%>



<%
	if (TicketDetails.getTipoIspezioneCodiceInterno().contains("7a")) {
%>

<tr class="containerBody">
	<td nowrap class="formLabel">Sistema Allarme Rapido</td>
	<td>
	<table class="noborder">
		<tr>
			<td>Codice Allerta</td>
			<td><%=TicketDetails.getCodiceAllerta()%>&nbsp;&nbsp;</td>
		</tr>
		
	<tr>
			<td>&nbsp;&nbsp; Contributi in Euro <br>
			(solo nei casi in cui è previsto <br>
			dal D.Lgs 194/2008)</td>
			<td><%=TicketDetails.getContributi_allarme_rapido()%></td>

		</tr>

	</table>

	</td>


</tr>

<%
	}
%>



<%
	if (TicketDetails.getTipoIspezioneCodiceInterno().contains("10a")) {
%>

<tr class="containerBody">
	<td nowrap class="formLabel">Controllo Importazione Scambio</td>
	<td>
	<table class="noborder">
		<tr>
			<td>&nbsp;&nbsp;Contributi in Euro <br>
			(solo nei casi in cui è previsto <br>
			dal D.Lgs 194/2008)</td>
			<td>&nbsp;&nbsp;<%=TicketDetails.getContributi_importazione_scambio()%></td>
		</tr>
	</table>
	</td>

</tr>

<%
	}
%>

<%
	if (TicketDetails.getTipoIspezioneCodiceInterno().contains("58a")) {
%>

<tr class="containerBody">
	<td nowrap class="formLabel">Verifica Risoluzione N.C Precedenti
	<td>
	<table class="noborder">
		<tr>
			<td>Le azioni correttive <br>
			risultano adeguate ed efficaci ?</td>
			<td>SI <input type="radio" name="azione" disabled="disabled"
				<%if (TicketDetails.isAzione()) {%> checked="checked" <%}%>>
			</td>
			<td>NO <input type="radio" <%if (!TicketDetails.isAzione()) {%>
				checked="checked" <%}%> disabled="disabled"></td>
			<td>Contributi in Euro <br>
			</td>
			<td>&nbsp;&nbsp; <%=TicketDetails.getContributi_verifica_risoluzione_nc()%></td>

		</tr>

		<%
			if (TicketDetails.isAzione()) {
		%>
		<tr id="desc1">
			<td>Descrizione :</td>
			<td><%=TicketDetails.getAzione_descrizione()%></td>
			<td>&nbsp;</td>
		</tr>

		<%
			}
		%>
	</table>
	</td>
</tr>

<%
	}
%>


<%
	if (TicketDetails.getTipoIspezioneCodiceInterno().contains("14a")) {
%>

<tr id="macellazione">
	<td nowrap class="formLabel">Macellazione Privata
	<td>
	<table class="noborder">
		<tr>
			<td>Contributi in Euro <br>
			</td>
			<td>&nbsp;&nbsp;<%=TicketDetails.getContributi_macellazione()%></td>
		</tr>
	</table>
	</td>
</tr>




<%
	}
	else if (TicketDetails.getTipoIspezioneCodiceInterno().contains("28a")) {
		%>

		<tr id="macellazione">
			<td nowrap class="formLabel">Macellazione d'urgenza
			<td>
			<table class="noborder">
				<tr>
					<td>Contributi in Euro <br>
					</td>
					<td>&nbsp;&nbsp;<%=TicketDetails.getContributi_macellazione_urgenza()%></td>
				</tr>
			</table>
			</td>
		</tr>




		<%
			} 
		
%>


<%-- 
<%
	}
%>
--%>


<%
if (flagCondizionalita==true)
{
%>
<tr class="containerBody">
	<td nowrap class="formLabel">Condizionalita</td>
	<td>
	<table class="noborder">
	<%
	Iterator <Integer > itKeyCond = TicketDetails.getTipo_ispezione_condizionalita().keySet().iterator();
	while(itKeyCond.hasNext())
	{
		
		
		out.println("<tr><td>"+TicketDetails.getTipo_ispezione_condizionalita().get(itKeyCond.next())+"</td></tr>");
		
	}
	%>
		

	</table>

	</td>
</tr>
<% if(TicketDetails.getFlag_checklist()!= null && !TicketDetails.getFlag_checklist().equals("") && !TicketDetails.getFlag_checklist().equals("-1")) { %>
<tr id="checklist_ba_tr" class="containerBody">
		 <td  class="formLabel">
					E' stata consegnata una copia della<br>
					presente checklist all'allevatore?
					</td>
					<td>
						<%if ("N".equalsIgnoreCase(TicketDetails.getFlag_checklist()) ){%>NO<%} %>
						<%if ("S".equalsIgnoreCase(TicketDetails.getFlag_checklist()) ){%>SI<%} %>
				    </td>
</tr>
<!-- Aggiunta RM per visualizzazione preavviso -->
<tr id="preavviso"   class="containerBody">
		<td  class="formLabel">
			Effettuato Preavviso
			</td>
		<td>
		<%if ("N".equalsIgnoreCase(TicketDetails.getFlag_preavviso()) ){%>Nessun Preavviso<%} 
		else if ("P".equalsIgnoreCase(TicketDetails.getFlag_preavviso()) ){%>Telefono<%} 
		else if ("T".equalsIgnoreCase(TicketDetails.getFlag_preavviso()) ){%>Telegramma<%}
		else if ("A".equalsIgnoreCase(TicketDetails.getFlag_preavviso()) ){%>Altro<%} 
		 else {  %>Nessun Preavviso<%} %>
		</td>
		</tr>
		
		
		<%if (TicketDetails.getData_preavviso_ba() != null) {%>
		<tr id="data_preavviso_ba_tr" class="containerBody">
		<td  class="formLabel">
			Data Preavviso
			</td>
		<td>
		
		<%=toDateasString(TicketDetails.getData_preavviso_ba())%>
		
		</td>
		</tr>
		<%}%>

<% }} %>


<% if(TicketDetails.isVincoloChecklistMacelli()) { %>
<tr id="checklist_macelli_tr" class="containerBody">
		 <td  class="formLabel">
					CHECKLIST MACELLI
					</td>
					<td>
				
				<% if (TicketDetails.getChecklistMacelli()!=null){ %>
				
				<a href="GestioneAllegatiUpload.do?command=DownloadPDF&codDocumento=<%=TicketDetails.getChecklistMacelli()%>&tipoDocumento=pdf&nomeDocumento=<%=TicketDetails.getChecklistMacelli()%>.pdf">
				<%=TicketDetails.getChecklistMacelli()%> (Download)
				</a>
				
				<%} %>	

<% if (TicketDetails.getClosed()==null){ %>
<dhv:permission name="documentale_documents-add">		
<input type="button" value="ALLEGA NUOVA" onClick="openPopupLarge('GestioneAllegatiUpload.do?command=PrepareAllegaChecklistMacelli&ticketId=<%=TicketDetails.getId()%>&altId=<%=TicketDetails.getAltId()%>&stabId=<%=TicketDetails.getIdStabilimento()%>')"/>
</dhv:permission>
<%} %>
				
				
				
				    </td>
</tr>

		<%}%>
		
		
<%

	if (TicketDetails.getTipoIspezioneCodiceInterno().contains("1a")) {
%>
<tr id="seguitodicampionamento">
	<td nowrap class="formLabel">A seguito di Campioni/tamponi nc
	<td>
	<table class="noborder">
		<tr>
			<td>&nbsp;&nbsp;Contributi in Euro <br>
			(solo nei casi in cui è previsto <br>
			dal D.Lgs 194/2008)</td>
			<td>&nbsp;&nbsp;<%=TicketDetails
								.getContributi_seguito_campioni_tamponi()%></td>
		</tr>
	</table>
	</td>
</tr>


<%
	}%>