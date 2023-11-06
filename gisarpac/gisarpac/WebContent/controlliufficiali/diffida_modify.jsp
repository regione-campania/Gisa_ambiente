
<%@page import="java.util.Iterator"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.aspcfs.utils.web.LookupList"%>
<%@page import="org.aspcf.modules.controlliufficiali.action.Diffida"%>
<%@page import="org.aspcfs.utils.web.LookupElement"%><jsp:useBean id="Ispezioni" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="CU" class="org.aspcfs.modules.vigilanza.base.Ticket" scope="request"/>
<jsp:useBean id="ListaNorme" class="org.aspcfs.utils.web.LookupList" scope="request"/>


<script language="JavaScript">


formTest = true;
message = "";
  function checkForm(form){
	  formTest = true;
    message = "";

arr=form.Provvedimenti;

 for(k=0 ; k<arr.length;k++){
		if(arr[k].value=="-1" && arr[k].selected==true){
			message += label("check.sanzioni.richiedente.selezionato","- Controllare di aver selezionato una azione \r\n");
		      formTest = false;

			}
		

     }
 

if(form.Provvedimenti.value==""){
	 message += label("check.sanzioni.data_richiesta.selezionato","- Controllare che il campo \"Azione non conforme per\" sia stato popolato\r\n");
     formTest = false;

}


arr=form.listaNorme;
for(k=0 ; k<arr.length;k++){
	if(arr[k].value=="-1" && arr[k].selected==true){
		message += label("check.sanzioni.richiedente.selezionato","- Controllare di aver selezionato una norma \r\n");
	      formTest = false;

		}
	else
		{
		if( arr[k].selected==true){
			var idc = document.getElementsByName("idC")[0].value;
			var id = document.getElementsByName("id")[0].value;
		PopolaCombo.verificaEsistenzaDiffida( arr[k].value,idc,id,{callback:verificaEsistenzaDiffidaCallback,async:false});
		}
		
		}
	

 }

if(form.listaNorme.value==-1){
	
    formTest = false;

}
    
	
    if (formTest == false) {
      alert(label("check.form", "Form could not be saved, please check the following:\r\n\r\n") + message);
      return false;
    } else {
      return true;
    }
  }
  
  
  function verificaEsistenzaDiffidaCallback(val)
  {
	  if (val==true)
		  {
		  formTest = false;
		  message += label("check.sanzioni.listaNorme.selezionato","- L'operatore risulta gi� diffidato per questa norma. \r\n");
		  }
	  
  }
  //used when a new contact is added
    function checkDiffida()
	{
	  form= document.forms[0];
	  arr=form.listaNorme;
	  for(k=0 ; k<arr.length;k++){
			if(arr[k].value=="-1" && arr[k].selected==true){
				 	
			      	formTest = false;

				}
			else
				{
				if( arr[k].selected==true){
					
				item = arr[k];
				PopolaCombo.verificaNormaInDiffida(arr[k].value,{callback:verificaNormaInDiffidaCallback,async:false});
				
				
				}
				}
				}
			
		
		
	}
    function verificaNormaInDiffidaCallback(retVal)
	{
		if (retVal==false)
			{
			
			alert('Attenzione! Questa norma non rientra tra quelle per le quali e possibile applicare la diffida.Bisogna applicare direttamente la Sanzione');
			document.getElementById("listaNorme").value="-1";
			formTest = false;
			checkNorma=false;
			}
	}
</script>

<%
ListaNorme.setJsEvent("onchange='checkDiffida()'");

%>
<%=showError(request, "listanormeError")%>
<%

String permission = TicketDetails.getPermission_ticket()+"-sanzioni-edit";

%>
<dhv:evaluate if="<%= !TicketDetails.isTrashed() %>" >
      <dhv:evaluate if="<%= TicketDetails.getClosed() != null %>" >
          <dhv:permission name="<%=permission%>">
            <input type="submit" value="<dhv:label name="button.reopen">Reopen</dhv:label>" onClick="javascript:this.form.action='<%=TicketDetails.getURlDettaglio() %>Diffida.do?command=ReopenTicket&id=<%=TicketDetails.getId()%><%= addLinkParams(request, "popup|popupType|actionId") %>'">
           </dhv:permission>
           <dhv:evaluate if='<%= "list".equals(request.getParameter("return"))%>' >
            <input type="button" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="window.history.back();" />
           </dhv:evaluate>
           <dhv:evaluate if='<%= !"list".equals(request.getParameter("return"))%>' >
<input type="button" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="window.history.back();" />           </dhv:evaluate>
      </dhv:evaluate>
      <dhv:evaluate if="<%= TicketDetails.getClosed() == null %>" >
          <dhv:permission name="<%=permission%>">
            <input type="submit" value="<dhv:label name="global.button.update">Update</dhv:label>" onClick="return checkForm(this.form)" />
          </dhv:permission>
           <dhv:evaluate if='<%= "list".equals(request.getParameter("return"))%>' >
<input type="button" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="window.history.back();" />           </dhv:evaluate>
           <dhv:evaluate if='<%= !"list".equals(request.getParameter("return"))%>' >
<input type="button" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="window.history.back();" />           </dhv:evaluate>
          <%= showAttribute(request, "closedError") %>
       </dhv:evaluate>
      </dhv:evaluate>
    <br />
    <dhv:formMessage />

<table cellpadding="4" cellspacing="0" width="100%" class="details">
	<tr>
      <th colspan="2">
        <strong><dhv:label name="sanzioni.information">Scheda Diffida</dhv:label></strong>
      </th>
	</tr>
	<dhv:include name="" none="true">
	
  <dhv:evaluate if="<%= SiteIdList.size() > 1 %>">
  <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="stabilimenti.site">Site</dhv:label>
    </td>
    <td>
      <%= SiteIdList.getSelectedValue(TicketDetails.getSiteId()) %>
      <input type="hidden" name="siteId" value="<%=TicketDetails.getSiteId()%>" >
    </td>
  </tr>
  </dhv:evaluate> 
 
</dhv:include>
	<% if (!"true".equals(request.getParameter("contactSet"))) { %>
  <tr class="containerBody">
    <td class="formLabel">
      <dhv:label name="sanzioni.richiedente">Impresa</dhv:label>
    </td>
   
     
      <td>
        <%= toHtml(OrgDetails.getName()) %>
        <input type="hidden" name="orgId" value="<%=OrgDetails.getOrgId()%>">
        <input type="hidden" name="orgSiteId" id="orgSiteId" value="<%=  OrgDetails.getSiteId() %>" />
      </td>
    
  </tr>
 
  <% }else{ %>
    <input type="hidden" name="orgSiteId" id="orgSiteId" value="<%=  TicketDetails.getId() > 0 ? TicketDetails.getOrgSiteId() : User.getSiteId()%>" />
    <input type="hidden" name="orgId" value="<%= toHtmlValue(request.getParameter("orgId")) %>">
    <input type="hidden" name="contactId" value="<%= request.getParameter("contactId") %>">
  <% } %>
	<tr class="containerBody">
    <td valign="top" class="formLabel">
   Identificativo Non Conformit�
    </td>
    <td>
     <%= TicketDetails.getIdentificativonc() %>
    </td>
  </tr>
	
	
  <dhv:include name="organization.source" none="true">
   <tr class="containerBody">
      <td  id="provvedimento1" nowrap class="formLabel">
       Azione non Conforme per
      </td>
    <td>
    
      <table border=0 class="noborder">
      <tr>
      <td >
     
        		<%= Provvedimenti.getHtmlSelect("Provvedimenti",TicketDetails.getProvvedimenti()) %>
        	
        
         
         <font color="red">*</font>
         <br><br>
       
    		</td>
    		   </tr>
       </table>
    </td>
  </tr>
</dhv:include>


<% if(TicketDetails.getNormaviolata()!=null && !TicketDetails.getNormaviolata().equals("")){
				//if(!TicketDetails.getNormaviolata().equals("")){ %>
				
	<tr class="containerBody">
  	<td nowrap class="formLabel">
      Norma Violata

   </td>
   <td>
      <%= TicketDetails.getNormaviolata() %>
      
   </td>
   </tr>
   <% } else { %>
	
	<tr class="containerBody"> 
    <td valign="top" class="formLabel">
     Norma Violata
    </td>
   <td>
   		  <%
       ListaNorme.setMultiple(true);
       ListaNorme.setSelectSize(9);
       
       %>
          <%
          LookupList selNorme = new LookupList();
          if(TicketDetails.getListaNorme().size()!=0) { 
       			%> 
				<%
						
						HashMap<Integer,String> listanorme =TicketDetails.getListaNorme();
						Set<Integer> setkiavi = listanorme.keySet();
						Iterator<Integer> iteraNorme=setkiavi.iterator();
						
						while(iteraNorme.hasNext()){
							int chiave = iteraNorme.next();
							String value=listanorme.get(chiave);					
						
							LookupElement elem = new LookupElement();
							elem.setCode(chiave);
							elem.setDescription(value);
							selNorme.add(elem);
							} %> 
			<%=ListaNorme.getHtmlSelect("listaNorme",selNorme) %>
			<% } else {
				%>
	   				<%=ListaNorme.getHtmlSelect("listaNorme",-1) %>
			<% } %>
			
	</td>
	
	
	
   </tr>
	   
   <% } %>
   
   





<tr class="containerBody">
    <td valign="top" class="formLabel">
      <dhv:label name="sanzioni.note">Raccolta Evidenze</dhv:label>
    </td>
    <td>
  </br>
      <table border="0" cellspacing="0" cellpadding="0" class="empty">
        <tr>
          <td>
            <textarea name="problem" cols="55" rows="8"><%= toString(TicketDetails.getProblem()) %></textarea>
          </td>
          <td valign="top">
            <%= showAttribute(request, "problemError") %>
          </td>
        </tr>
      </table>
    </td>
	</tr>
  
	</table>
	
	<dhv:evaluate if="<%= !TicketDetails.isTrashed() %>" >
    <dhv:evaluate if="<%= TicketDetails.getClosed() != null %>" >
        <dhv:permission name="<%=permission%>">
          <input type="submit" value="<dhv:label name="button.reopen">Reopen</dhv:label>" onClick="javascript:this.form.action='<%=TicketDetails.getURlDettaglio() %>Diffida.do?command=ReopenTicket&id=<%=TicketDetails.getId()%><%= addLinkParams(request, "popup|popupType|actionId") %>'">
         </dhv:permission>
         <dhv:evaluate if='<%= "list".equals(request.getParameter("return"))%>' >
<input type="button" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="window.history.back();" />         </dhv:evaluate>
         <dhv:evaluate if='<%= !"list".equals(request.getParameter("return"))%>' >
<input type="button" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="window.history.back();" />         </dhv:evaluate>
    </dhv:evaluate>
    <dhv:evaluate if="<%= TicketDetails.getClosed() == null %>" >
        <dhv:permission name="<%=permission%>">
          <input type="submit" value="<dhv:label name="global.button.update">Update</dhv:label>" onClick="return checkForm(this.form)" />
        </dhv:permission>
         <dhv:evaluate if='<%= "list".equals(request.getParameter("return"))%>' >
<input type="button" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="window.history.back();" />         </dhv:evaluate>
         <dhv:evaluate if='<%= !"list".equals(request.getParameter("return"))%>' >
<input type="button" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="window.history.back();" />         </dhv:evaluate>
        <%= showAttribute(request, "closedError") %>
     </dhv:evaluate>
    </dhv:evaluate>
    <input type="hidden" name="modified" value="<%= TicketDetails.getModified() %>">
    <input type="hidden" name="orgId" value="<%=TicketDetails.getOrgId()%>">
    <input type="hidden" name="orgSiteId" id="orgSiteId" value="<%=  TicketDetails.getOrgSiteId() %>" />
    <input type="hidden" name="id" value="<%= TicketDetails.getId() %>">
    <input type="hidden" name="companyName" value="<%= toHtml(TicketDetails.getCompanyName()) %>">
    <input type="hidden" name="statusId" value="<%=  TicketDetails.getStatusId() %>" />
    <input type="hidden" name="trashedDate" value="<%=  TicketDetails.getTrashedDate() %>" />
    <input type="hidden" name="close" value="">
    <input type="hidden" name="refresh" value="-1">
    <input type="hidden" name="currentDate" value="<%=  request.getAttribute("currentDate") %>" />