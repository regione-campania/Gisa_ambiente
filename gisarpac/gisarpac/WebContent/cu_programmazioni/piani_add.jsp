
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<%@page import="org.aspcfs.modules.programmazzionecu.base.PianoMonitoraggioList"%>


<%@page import="org.aspcfs.modules.dpat.base.PianoMonitoraggio"%>
<jsp:useBean id="PianoRiferimentoAtt" class = "org.aspcfs.modules.dpat.base.DpatAttivita" scope = "request"/>
<jsp:useBean id="PianoRiferimentoInd" class = "org.aspcfs.modules.dpat.base.DpatIndicatore" scope = "request"/>
<jsp:useBean id="IstanzaDpat" class = "org.aspcfs.modules.dpat.base.DpatIstanza" scope = "request"/>


<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>
<link rel="stylesheet" type="text/css" href="css/capitalize.css"></link>

<script src='javascript/modalWindow.js' type="text/javascript" ></script>


<jsp:useBean id="lookup_sezioni_piani" class = "org.aspcfs.utils.web.LookupList" scope = "request">
</jsp:useBean>

<jsp:useBean id="lookup_piani" class = "org.aspcfs.utils.web.LookupList" scope = "request">
</jsp:useBean>
<jsp:useBean id="lookup_asl" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<%@ include file="../initPage.jsp" %>


 <script>
 
 function verificaEsistenzaCodiceCallback(ret)
 {
	 if (ret[0]=="true")
		 {
	 	flag=false;
	 	msg+=" - Attenzione Il codice Univoco Inserito è Occupato. ";
	 	if(ret[1]!="ko")
	 		{
	 		
	 		msg+="Il prossimo codice libero è il seguente : "+ret[1];
	 		}
	 	
		 }
 }
 function verificaEsistenzaCodice(codiceAttivita)
 {
	 if(codiceAttivita!='')
		 PopolaCombo.verificaEsistenzaCodiceAttivita(codiceAttivita,{callback:verificaEsistenzaCodiceCallback,async:false})
 }
 

 
 var flag = true ;	
 var msg = '' ;
 function checkForm()
 {
	 flag = true ;
	 msg = '' ;
	
	 verificaEsistenzaCodice(document.getElementById("cup").value);
	 
	 
	 if (document.addPiano.descrizione.value == '')
	 {
		flag = false ;
		msg += " - Attenzione ! Inserire la descrizione del piano che si intende inserire \n ";
	 }

	 if (document.addPiano.root.value == '-1')
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
		  window.opener.document.forms[0].action = 'Dpat.do?command=SearchPianiMonitoraggio';
		  window.opener.loadModalWindowCustom("Ricaricamento in Corso");
		  window.opener.document.forms[0].submit();
		  window.close();
	  }

	}
 </script>
 <body  onblur="if(focus_==true){window.focus();}"  onload = "chiudiPopUp('<%=request.getAttribute("inserito")%>')" onmouseout="focus_=true;" onmouseover="focus_=false;" >
 <form name="addPiano" action="Dpat.do?command=Insert" method="post">
 <input type = "hidden" name = "anno" value="<%=IstanzaDpat.getAnno() %>">
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
	else
	{
%>

<table cellpadding="4" cellspacing="0" width="100%" class="details">
	<tr>
    <th colspan="2">
      <strong><dhv:label name="">NUOVA ATTIVITA/INDICATORE</dhv:label></strong>
    </th>
	</tr>
	
	
	<tr>
      <td nowrap class="formLabel">
      CODICE UNIVOCO
      </td>
      <td>
     <input type = "text" name = "cup" id = "cup" value = "">
       </td>
    </tr>
	
	<tr>
      <td nowrap class="formLabel">
      ATTIVITA/SEZIONE
      </td>
      <td>
     
    	<%=(PianoRiferimentoAtt.getDescrizioneSezione()!= null ? PianoRiferimentoAtt.getDescrizioneSezione() : PianoRiferimentoInd.getDescrizioneAttivita())%>
    	<input type = "hidden" name = "root" value="<%=PianoRiferimentoAtt.getIdSezione() > 0 ? PianoRiferimentoAtt.getIdSezione() : PianoRiferimentoInd.getIdAttivita_()%>">
     	
       </td>
    </tr>
    
      <tr>
      <td nowrap class="formLabel">
       Tipo Inserimento
      </td>
      <td>
      <%=(PianoRiferimentoAtt.getTipoInserimento()!=null)? PianoRiferimentoAtt.getTipoInserimento() : PianoRiferimentoInd.getTipoInserimento() %>
     	<input type ="hidden" name="tipoInserimento" value="<%=(PianoRiferimentoAtt.getTipoInserimento()!=null)? PianoRiferimentoAtt.getTipoInserimento() : PianoRiferimentoInd.getTipoInserimento()  %>">
     	
       </td>
    </tr>
    
    
    <tr>
      <td nowrap class="formLabel">
       RIFERIMENTO ALL'ATTIVITA
      </td>
      <td>
            <%=(PianoRiferimentoAtt.getDescription()!=null)? PianoRiferimentoAtt.getDescription() : PianoRiferimentoInd.getDescription() %>
      
     	 <input type="hidden" name="tipoInserimento" value="<%=(PianoRiferimentoAtt.getTipoInserimento()!=null) ? PianoRiferimentoAtt.getTipoInserimento():PianoRiferimentoInd.getTipoInserimento()  %>"/>
     	<input type="hidden" name="idPianoRiferimento" value="<%=(PianoRiferimentoAtt.getId()>0)?PianoRiferimentoAtt.getId() : PianoRiferimentoInd.getId() %>"/>
     	
       </td>
    </tr>
    
    

	
	<tr>
      <td nowrap class="formLabel">
       <img title="Si Tratta della descrizione breve presente dopo la riga della sezione nel foglio allegato 5-foglio delle attivita" class="masterTooltip" src="images/questionmark.png" width="20"/> 
       
        ALIAS [ES. A1 PER ATTIVITA DELLA SEZIONE , A1_A PER INDICATORE DELL'ATTIVITA]
      </td>
      <td>
     <input type = "text" name="alias" required >
   
       </td>
    </tr>
    
    
    <%
    String tipologia = "" ;
    if (PianoRiferimentoAtt.getTipoAttivita()!=null)
    	tipologia = PianoRiferimentoAtt.getTipoAttivita() ;
    else
    	tipologia = PianoRiferimentoInd.getTipoAttivitaPiano();
    
    if (tipologia == null)
    	tipologia = "" ;
    
    %>
    <tr>
      <td nowrap class="formLabel">
      Tipo
       </td>
      <td>
      
      <%
      if(tipologia!=null && !"".equalsIgnoreCase(tipologia) && PianoRiferimentoAtt.getId()<=0)
      {
    	  %>
    	  
    	  <%=tipologia.toUpperCase() %>
    	  <input type = "hidden" name = "tipoAttivita" value = "<%=tipologia.toUpperCase() %>">
    	  <%
      }
      else
      {
      %>
      <select name="tipoAttivita" required>
      <option <%=tipologia.equals("") ? "selected" : "" %> value="">Seleziona Tipo </option>
      <option <%=tipologia.equalsIgnoreCase("piano") ? "selected" : "" %> value="PIANO">PIANO</option>
      <option <%=tipologia.equalsIgnoreCase("ATTIVITA-AUDIT") ? "selected" : "" %> value="ATTIVITA-AUDIT">ATTIVITA-AUDIT</option>
       <option <%=tipologia.equalsIgnoreCase("ATTIVITA-SORVEGLIANZA") ? "selected" : "" %> value="ATTIVITA-SORVEGLIANZA">ATTIVITA-SORVEGLIANZA</option>
       <option <%=tipologia.equalsIgnoreCase("ATTIVITA-ISPEZIONE") ? "selected" : "" %> value="ATTIVITA-ISPEZIONE">ATTIVITA-ISPEZIONE</option>
      </select>
   <%} %>
       </td>
    </tr>
      <tr>
      <td nowrap class="formLabel">
      Codice Esame
       </td>
      <td>
     <input type = "text" name="codice_esame" value="<%= PianoRiferimentoAtt.getCodiceEsame()!= null ? toHtml(PianoRiferimentoAtt.getCodiceEsame()) : toHtml(PianoRiferimentoInd.getCodiceEsame())  %>">
   
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
    
    
    <%if(PianoRiferimentoInd.getDescription()!=null){ %>
    <tr>
      <td nowrap class="formLabel">
      Coefficiente Indicatore
      </td>
      <td>
     SI <INPUT TYPE ="radio" value = "si" name ="uiCalcolabile" onclick="document.getElementById('coefficiente').style.display='';"> NO <INPUT TYPE ="radio" value = "no" name ="uiCalcolabile" onclick="document.getElementById('coefficiente').value='0' ; document.getElementById('coefficiente').style.display='none';">
    
    <input type = "number" name = "coefficiente" id = "coefficiente" value ="0" style="display:none">
       </td>
    </tr>
    <%} %>
    
    
  <input type ="hidden" name="tipoPianoAttInd" value = "<%=(PianoRiferimentoAtt.getId()>0) ? "dpat_attivita" : "dpat_indicatore" %>">
 
       </table>
       <%} %>
     
<br />


<br>
<input type="submit" value="<dhv:label name="button.insert">Insert</dhv:label>" name="Save" onClick="return checkForm(this.form)">
<input type="button" value="Annulla"  onClick="window.close()">
</form>

</body>