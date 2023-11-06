<%-- 
  - Copyright(c) 2004 Dark Horse Ventures LLC (http://www.centriccrm.com/) All
  - rights reserved. This material cannot be distributed without written
  - permission from Dark Horse Ventures LLC. Permission to use, copy, and modify
  - this material for internal use is hereby granted, provided that the above
  - copyright notice and this permission notice appear in all copies. DARK HORSE
  - VENTURES LLC MAKES NO REPRESENTATIONS AND EXTENDS NO WARRANTIES, EXPRESS OR
  - IMPLIED, WITH RESPECT TO THE SOFTWARE, INCLUDING, BUT NOT LIMITED TO, THE
  - IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY PARTICULAR
  - PURPOSE, AND THE WARRANTY AGAINST INFRINGEMENT OF PATENTS OR OTHER
  - INTELLECTUAL PROPERTY RIGHTS. THE SOFTWARE IS PROVIDED "AS IS", AND IN NO
  - EVENT SHALL DARK HORSE VENTURES LLC OR ANY OF ITS AFFILIATES BE LIABLE FOR
  - ANY DAMAGES, INCLUDING ANY LOST PROFITS OR OTHER INCIDENTAL OR CONSEQUENTIAL
  - DAMAGES RELATING TO THE SOFTWARE.
  - 
  - Version: $Id: documents_add_include.jsp 11310 2005-04-13 20:05:00Z mrajkowski $
  - Description: 
  --%>
<script language="JavaScript">
  function checkFileForm(form) {
    if (form.dosubmit.value == "false") {
      return true;
    }
    var formTest = true;
    var messageText = "";
    if (form.subject.value == "") {
      messageText += label("Subject.required", "- Subject is required\r\n");
      formTest = false;
    }
    if (form.id<%= TicketDetails.getId() %>.value.length < 5) {
      messageText += label("file.required", "- File is required\r\n");
      formTest = false;
    }
    if (form.motivazioni!=null)
    {
		if (form.motivo_chiusura.value == "")
		{
			 messageText += label(""," - Inserire una descrizione nelle motivazioni \r\n");
		      formTest = false;
		}
    }
    if (formTest == false) {
      messageText = label("File.not.submitted", "The file could not be submitted.          \r\nPlease verify the following items:\r\n\r\n") + messageText;
      form.dosubmit.value = "true";
      alert(messageText);
      return false;
    } else {
      if (form.upload.value != label("button.pleasewait","Please Wait...")) {
        form.upload.value=label("button.pleasewait","Please Wait...");
        return true;
      } else {
        return false;
      }
    }
  }
</script>
<dhv:formMessage />
<table cellpadding="4" cellspacing="0" width="100%" class="details">
  <tr>
    <th colspan="2">
      <img border="0" src="images/file.gif" align="absmiddle">
    <%if(request.getAttribute("header")!=null)
  {%>
   <b>Caricare Allegato </b>
  <%}else
	  {%>
    <%
  if(request.getAttribute("ListaCommercializzazzione") !=null)
  {
	  %>
	<b>  Allega Lista di Commercializzazzione per l'allerta inserita <%=request.getAttribute("idAllerta") %></b>
	  <%
	  
  }
  else
  {
  %>
      <b><dhv:label name="accounts.accounts_documents_upload.UploadNewDocument">Upload a New Document</dhv:label></b>
    <%}} %>
    
    </th>
  </tr>
  <tr class="containerBody">
    <td class="formLabel">
    
    <%if(header != null){
    	%>
    
   
    	<%
	
	if (chiusura != null)
	{
		%>
		 
		 <dhv:label name="">Oggetto</dhv:label>
	<%	
	}
	else{
		%>
		<dhv:label name="">Note di Chiusura</dhv:label>
		
		<%
	}
    	
    	%>
    	
    	<%
	
}
    else
    {
%>
    
      <dhv:label name="accounts.accounts_contacts_calls_details_include.Subject">Subject</dhv:label>
      <%} %>
    </td>
    <td>
    <table class = "noborder">
    <tr><td>
      <input type="hidden" name="folderId" value="<%= (String)request.getAttribute("folderId") %>">
      <input type="text" name="subject" size="59" maxlength="255" value="<%= toHtmlValue((String)request.getAttribute("subject")) %>"><font color="red">*</font>
      <%= showAttribute(request, "subjectError") %></td>
      <%if (header != null) 
      {
      %>
      <td>
      	Attenzione! Al momento della chiusura dell'allerta il sistema invier� <br>
    	in automatico una copia dell'Allegato F al nodo regionale
      </td>
      <%
      
      }%>
      </tr></table>
    </td>
  </tr>
  <tr class="containerBody">
    <td class="formLabel">
      <dhv:label name="contacts.companydirectory_confirm_importupload.File">File</dhv:label>
    </td>
    <td>
      <input type="file" name="id<%= TicketDetails.getId() %>" size="45">
    </td>
  </tr>
  <%if (request.getAttribute("motivazioni")!=null)
	 {
	%>
	  <input type = "hidden" name ="motivazioni" value ="si"> 
	    <tr class="containerBody">
    <td class="formLabel">
     Motivazione del mancato completamento dei CU pianificati
    </td>
    <td>
      <textarea rows="6" cols="55" name="motivo_chiusura"></textarea>
    </td>
  </tr>
	  <%} %>
  
</table>
