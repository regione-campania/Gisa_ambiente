<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<%@page import="org.aspcfs.modules.programmazzionecu.base.PianoMonitoraggioList"%>


<%@page import="org.aspcfs.modules.dpat.base.PianoMonitoraggio"%>
<jsp:useBean id="PianoRiferimento" class = "org.aspcfs.modules.dpat.base.PianoMonitoraggio" scope = "request"/>

<jsp:useBean id="lookup_sezioni_piani" class = "org.aspcfs.utils.web.LookupList" scope = "request">
</jsp:useBean>

<jsp:useBean id="lookup_piani" class = "org.aspcfs.utils.web.LookupList" scope = "request">
</jsp:useBean>
<jsp:useBean id="lookup_asl" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<%@ include file="../initPage.jsp" %>

 <script>
 function checkForm()
 {
	 flag = true ;	
	 msg = '' ;
	
	 if (document.addPiano.descrizione.value == '')
	 {
		flag = false ;
		msg += " - Attenzione ! Inserire la descrizione del piano che si intende inserire \n ";
	 }

	 if (document.addPiano.sezione.value == '-1')
	 {
		flag = false ;
		msg += " - Attenzione ! Inserire la sezione del piano che si intende inserire \n ";
	 }
	 if (flag ==false)
		 alert(msg) ;
	 return flag ;
	 
}

 function abilitaAsl()
 {
	 if (document.addPiano.sezione.value=='10')
	 {
		document.getElementById("asl").style.display="";
	 }
	 else
	 {
		 document.getElementById("asl").style.display="none";
	}
 }

 function chiudiPopUp(flagInserimento)
 {
	  if(flagInserimento != null && flagInserimento != 'null')
	  {
		  window.opener.document.forms[0].action = 'Dpat.do?command=SearchPianiMonitoraggioAttivi';
		  window.opener.document.forms[0].submit();
		  window.close();
	  }

	}
 </script>
 <body  onblur="if(focus_==true){window.focus();}"  onload = "chiudiPopUp('<%=request.getAttribute("inserito")%>')" onmouseout="focus_=true;" onmouseover="focus_=false;" >
 <form name="addPiano" action="Dpat.do?command=InsertEnabled" method="post">
<%-- Trails --%>

<%-- End Trails --%>
<input type="submit" value="<dhv:label name="button.insert">Insert</dhv:label>" name="Save" onClick="return checkForm(this.form)">
<input type="button" value="Annulla"  onClick="window.close()">
<dhv:formMessage />


<%
	if (request.getAttribute("inserito")!=null)
{
%>
<font color = "red">Piano Inserito in maniera corretta.</font>
<a href = "#" >Torna Indietro</a>

<%
	}
%>

<table cellpadding="4" cellspacing="0" width="100%" class="details">
	<tr>
    <th colspan="2">
      <strong><dhv:label name="">Aggiungi Nuovo Piano di Monitoraggio</dhv:label></strong>
    </th>
	</tr>
	
	
	
	<tr>
      <td nowrap class="formLabel">
       Piano Radice
      </td>
      <td>
     
    	<%=lookup_piani.getSelectedValue(PianoRiferimento.getId_padre()) %>
    	<input type = "hidden" name = "root" value="<%=PianoRiferimento.getId_padre()%>">
     	
       </td>
    </tr>
    
      <tr>
      <td nowrap class="formLabel">
       Tipo Inserimento
      </td>
      <td>
      <%=PianoRiferimento.getTipoInserimento() %>
     	
     	
       </td>
    </tr>
    
    
    <tr>
      <td nowrap class="formLabel">
       Attivita di Riferimento
      </td>
      <td>
      <%=lookup_piani.getSelectedValue(PianoRiferimento.getCode()) %>
     	 <input type="hidden" name="tipoInserimento" value="<%=PianoRiferimento.getTipoInserimento()%>"/>
     	<input type="hidden" name="idPianoRiferimento" value="<%=PianoRiferimento.getCode()%>"/>
     	
       </td>
    </tr>
    
    
	<tr>
	<td class="formLabel">Sezione</td>
	<td>
	<%
	lookup_sezioni_piani.setJsEvent("onchange='abilitaAsl()'");
	
	%>
	<%= (PianoRiferimento.getId_padre()>0)? "<input type = 'hidden' name ='sezione' id='sezione' value ='"+lookup_sezioni_piani.getIdFromDescription(PianoRiferimento.getSezione())+"' >"+PianoRiferimento.getSezione() : lookup_sezioni_piani.getHtmlSelect("sezione",lookup_sezioni_piani.getIdFromDescription(PianoRiferimento.getSezione())) %>
	</td>
	
	</tr>
	
	<tr>
      <td nowrap class="formLabel">
       <img title="Si Tratta della descrizione breve presente dopo la riga della sezione nel foglio allegato 5-foglio delle attivita" class="masterTooltip" src="images/questionmark.png" width="20"/> Alias
      </td>
      <td>
     <input type = "text" name="alias" required >
   
       </td>
    </tr>
    
    <tr>
      <td nowrap class="formLabel">
      Tipo
       </td>
      <td>
      <select name="tipoAttivita" required>
      <option value="">Seleziona Tipo </option>
      <option value="PIANO">PIANO </option>
      <option value="ATTIVITA">ATTIVITA</option>
      </select>
   
       </td>
    </tr>
      <tr>
      <td nowrap class="formLabel">
      Codice Esame
       </td>
      <td>
     <input type = "text" name="codice_esame" value="<%=(PianoRiferimento.getId_padre()>0) ? PianoRiferimento.getCodiceEsame() :""%>">
   
       </td>
    </tr>
    
   
	<tr>
      <td nowrap class="formLabel">
      Descrizione
      </td>
      <td>
     <textarea rows="6" cols="75" name="descrizione" required></textarea>
       </td>
    </tr>
    
     <tr>
      <td nowrap class="formLabel">
      Note
      </td>
      <td>
         <textarea rows="6" cols="75" name="note" value =""></textarea>

       </td>
    </tr>
    
   
  
	
    <tr id = "asl" style="display: none">
      <td nowrap class="formLabel">
        <dhv:label name="stabilimenti.site">Site</dhv:label>
      </td>
      <td>
       <%=lookup_asl.getHtmlSelect("asl",-1)%>
       </td>
    </tr>

 
       </table>
     
<br />


<br>
<input type="submit" value="<dhv:label name="button.insert">Insert</dhv:label>" name="Save" onClick="return checkForm(this.form)">
<input type="button" value="Annulla"  onClick="window.close()">
</form>

</body>