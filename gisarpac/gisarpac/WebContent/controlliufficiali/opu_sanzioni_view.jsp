<jsp:useBean id="Ispezioni" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ListaNorme" class="org.aspcfs.utils.web.LookupList" scope="request"/>

<table cellpadding="4" cellspacing="0" width="100%" class="details">
		<tr>
			<th colspan="2"><strong><dhv:label
				name="sanzioni.information">Scheda Sanzione Amministrativa</dhv:label></strong></th>
		</tr>
	
		<dhv:include name="" none="true">
			<dhv:evaluate if="<%= SiteIdList.size() > 1 %>">
				<tr class="containerBody">
					<td nowrap class="formLabel"><dhv:label
						name="stabilimenti.site">Site</dhv:label></td>
					<td><%=SiteIdList.getSelectedValue(TicketDetails
										.getSiteId())%>
					<%
						
					%> <input type="hidden"
						name="siteId" value="<%=TicketDetails.getSiteId()%>"></td>
				</tr>
			</dhv:evaluate>
			<dhv:evaluate if="<%= SiteIdList.size() <= 1 %>">
				<input type="hidden" name="siteId" id="siteId" value="-1" />
						</dhv:evaluate>
		</dhv:include>
	
  <input type="hidden" name="id" id="id"
			value="<%=  TicketDetails.getId() %>" />
		<input type="hidden" name="stabId" id="orgId"
			value="<%=  TicketDetails.getIdStabilimento() %>" />
			
	
	<%if(TicketDetails.getIdentificativonc()!=null){ %>
			
<tr class="containerBody">
    <td class="formLabel">
      <dhv:label name="">Identificativo Non Conformit�</dhv:label>
    </td>
   
     
      <td> 
      		<%= TicketDetails.getIdentificativonc() %>
      </td>
    
  </tr><%} %>
  
  <%if(TicketDetails.getIdentificativo()!=null){ %>
  <tr class="containerBody">
    <td class="formLabel">
      <dhv:label name="">Codice Sanzione Amministrativa</dhv:label>
    </td>
   
     
      <td>
      		<%= toHtmlValue(TicketDetails.getIdentificativo()) %>
      </td>
    
  </tr>	
		<tr class="containerBody" style="display: none">
			<td nowrap class="formLabel"><dhv:label
				name="sanzioni.data_richie">Data Accertamento</dhv:label></td>
			<td><zeroio:tz
				timestamp="<%= TicketDetails.getAssignedDate() %>" dateOnly="true"
				timeZone="<%= TicketDetails.getAssignedDateTimeZone() %>"
				showTimeZone="false" default="&nbsp;" /> 
				
				</td></tr><%} %>
				
  
  
  <%
  
  
  if(TicketDetails.getTrasgressore()!=""){
  if(!TicketDetails.getTrasgressore().equals("")){ %>
  
  <tr class="containerBody">
  <td nowrap class="formLabel">
Trasgressore
   </td>
   <td>
      <%=toHtmlValue(TicketDetails.getTrasgressore()) %>
      
   </td>
</tr>
<%}}%>

 <%
  if(TicketDetails.getTrasgressore2()!=null){
  if(!TicketDetails.getTrasgressore2().equals("")){ %>
  
  <tr class="containerBody">
  <td nowrap class="formLabel">
Trasgressore 2
   </td>
   <td>
      <%=toHtmlValue(TicketDetails.getTrasgressore2()) %>
      
   </td>
</tr>
<%}}%>

<%
  if(TicketDetails.getTrasgressore3()!=null){
  if(!TicketDetails.getTrasgressore3().equals("")){ %>
  
  <tr class="containerBody">
  <td nowrap class="formLabel">
Trasgressore 3
   </td>
   <td>
      <%=toHtmlValue(TicketDetails.getTrasgressore3()) %>
      
   </td>
</tr>
<%}}%>

<% 
if(TicketDetails.getObbligatoinSolido()!=null){
if(!TicketDetails.getObbligatoinSolido().equals("")) {%>
<tr class="containerBody">
  <td nowrap class="formLabel">
      Obbligato in solido

   </td>
   <td>
      <%= toHtmlValue(TicketDetails.getObbligatoinSolido()) %>
      
   </td>
</tr>
<%} }%>



<% 
if(TicketDetails.getObbligatoinSolido2()!=null){
if(!TicketDetails.getObbligatoinSolido2().equals("")) {%>
<tr class="containerBody">
  <td nowrap class="formLabel">
      Obbligato in solido 2

   </td>
   <td>
      <%= toHtmlValue(TicketDetails.getObbligatoinSolido2()) %>
      
   </td>
</tr>
<%} }%>



<% 
if(TicketDetails.getObbligatoinSolido3()!=null){
if(!TicketDetails.getObbligatoinSolido3().equals("")) {%>
<tr class="containerBody">
  <td nowrap class="formLabel">
      Obbligato in solido 3

   </td>
   <td>
      <%= toHtmlValue(TicketDetails.getObbligatoinSolido3()) %>
      
   </td>
</tr>
<%} }%>
  
  
  <%
  if(TicketDetails.getTipo_richiesta()!=null){
  if(!TicketDetails.getTipo_richiesta().equals("")){ %>
<tr class="containerBody">
  <td nowrap class="formLabel">
       Processo Verbale

   </td>
   <td>
      <%= toHtmlValue(TicketDetails.getTipo_richiesta()) %>
      
   </td>
</tr>
		
		<%}} %>
		
		<% 
		
			
		if(TicketDetails.getPagamento()!=0.0){
		
		%>
			<tr class="containerBody">
				<td valign="top" class="formLabel">
					Pagamento in Misura Ridotta(Euro)</td>
				<td><%=TicketDetails.getPagamento()%> </td>
			</tr>
	<%} %>
		
		
	
	<%if(TicketDetails.getAzioninonConformePer().size()!=0){ 
	
	HashMap<Integer,String> azionenonConformePer=TicketDetails.getAzioninonConformePer();
	Set<Integer> setkiavi=azionenonConformePer.keySet();
	Iterator<Integer> itera=setkiavi.iterator();

	%>
	
	    
		<tr class="containerBody">
					<td nowrap class="formLabel"><dhv:label name="">Azione non Conforme Per</dhv:label>
					</td>
		
					<td><%
				
					if ((CU.getTipoCampione()==4 || CU.getTipoCampione()==5 ) && CU.getLisaElementi_Ispezioni().size()!=0)
        		{
						while(itera.hasNext()){
							int chiave=itera.next();
							
							
							%>
					<%="- "+Ispezioni.getSelectedValue(chiave) %>

						<%} %>
        		
        		
        		<%        		
        	}
        	else
        	{
        	while(itera.hasNext()){
						int chiave=itera.next();
						String value=azionenonConformePer.get(chiave);
						
						%>
					<%="- " + value %>

					<%} %>
        	
         <%} %>
					

					</br>
					<% if(!TicketDetails.getDescrizione1().equals("")){%>
					<%="- Descrizione: " + TicketDetails.getDescrizione1() %>
					<%} %>
					</td>
					
			

				</tr>
				
				<%} %>
				
				
				
				<%
				
				if(TicketDetails.getNormaviolata()!=null){
				if(!TicketDetails.getNormaviolata().equals("")){ %>
				
				<tr class="containerBody">
  <td nowrap class="formLabel">
      Norma Violata

   </td>
   <td>
      <%= TicketDetails.getNormaviolata() %>
      
   </td>
   <%} %>
   </tr>
   <% } 
   %>
   
   <%if(TicketDetails.getListaNorme().size()!=0){ 
	
	HashMap<Integer,String> listanorme =TicketDetails.getListaNorme();
	Set<Integer> setkiavi = listanorme.keySet();
	Iterator<Integer> iteraNorme=setkiavi.iterator();

	%>
	
	    
		<tr class="containerBody">
					<td nowrap class="formLabel">
		<dhv:label name="">Norma Violata</dhv:label>
					</td>
		
					<td><%
        	while(iteraNorme.hasNext()){
						int chiave = iteraNorme.next();
						String value=listanorme.get(chiave);
						
						%>
					<%="- "+listanorme.get(chiave)%><br> 

					<%} %>  
</tr>
				
			<% } %>	
				
				
				
				
			<dhv:evaluate if="<%= hasText(TicketDetails.getProblem()) %>">
			<tr class="containerBody">
				<td class="formLabel" valign="top"><dhv:label
					name="sanzioni.note">Note</dhv:label></td>
				<td valign="top">
				</br>
				<%
					//Show audio files so that they can be streamed
							Iterator files = TicketDetails.getFiles().iterator();
							while (files.hasNext()) {
								FileItem thisFile = (FileItem) files.next();
								if (".wav".equalsIgnoreCase(thisFile.getExtension())) {
				%> <a
					href="TroubleTicketsDocuments_asl.do?command=Download&stream=true&tId=<%= TicketDetails.getId() %>&fid=<%= thisFile.getId() %>"><img
					src="images/file-audio.gif" border="0" align="absbottom"><dhv:label
					name="tickets.playAudioMessage">Play Audio Message</dhv:label></a><br />
				<%
					}
							}
				%> <%=TicketDetails.getProblem()%> <input type="hidden"
					name="problem" value="<%=TicketDetails.getProblem()%>">
				</td>
			</tr>
		</dhv:evaluate>
			  

		
	</table>