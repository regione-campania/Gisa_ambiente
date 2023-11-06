<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<%@page import="org.aspcfs.modules.programmazzionecu.base.PianoMonitoraggioList"%>


<%@page import="org.aspcfs.modules.dpat.base.PianoMonitoraggio"%>
<jsp:useBean id="PianoRiferimentoAtt" class = "org.aspcfs.modules.dpat.base.DpatAttivita" scope = "request"/>
<jsp:useBean id="PianoRiferimentoInd" class = "org.aspcfs.modules.dpat.base.DpatIndicatore" scope = "request"/>
<jsp:useBean id="IstanzaDpat" class = "org.aspcfs.modules.dpat.base.DpatIstanza" scope = "request"/>
<jsp:useBean id="ListaSezioniDpat" class = "org.aspcfs.modules.dpat.base.Dpat" scope = "request"/>



<jsp:useBean id="lookup_asl" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<%@ include file="../initPage.jsp" %>
<SCRIPT LANGUAGE="JavaScript" SRC="javascript/CalendarPopup.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="javascript/common.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">document.write(getCalendarStyles());</SCRIPT>
<SCRIPT LANGUAGE="JavaScript" ID="js19">
	var cal19 = new CalendarPopup();
	cal19.showYearNavigation();
	cal19.showYearNavigationInput();
	cal19.showNavigationDropdowns();
</SCRIPT>
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
		  window.opener.document.forms[0].action = 'Dpat.do?command=SearchPianiMonitoraggio';
		  window.opener.document.forms[0].submit();
		  window.close();
	  }

	}
 </script>
 <body  onblur="if(focus_==true){window.focus();}"  onload = "chiudiPopUp('<%=request.getAttribute("inserito")%>')" onmouseout="focus_=true;" onmouseover="focus_=false;" >
 <form name="addPiano" action="Dpat.do?command=Replace" method="post">
<%-- Trails --%>
<input type ="hidden" name = "anno" value = "<%=IstanzaDpat.getAnno() %>">
<%-- End Trails --%>
<input type="submit" value="Aggiorna" name="Save" onClick="return checkForm(this.form)">
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
      <strong><dhv:label name="">MODICIA PIANO</dhv:label></strong>
    </th>
	</tr>
	
	
	
	<tr>
      <td nowrap class="formLabel">
       ATTIVITA / SEZIONE
      </td>
      <td>
     
    	<%=PianoRiferimentoAtt.getId()>0 ? PianoRiferimentoAtt.getDescrizioneSezione() : PianoRiferimentoInd.getDescrizioneAttivita() %>
    	<input type = "hidden" name = "root" value="<%=PianoRiferimentoAtt.getId()>0 ? PianoRiferimentoAtt.getIdSezione(): PianoRiferimentoInd.getIdAttivita_() %>">
       </td>
    </tr>
    
   
    

    
  
	
	
	
	
	<tr>
      <td nowrap class="formLabel">
       <img title="Si Tratta della descrizione breve presente dopo la riga della sezione nel foglio allegato 5-foglio delle attivita" class="masterTooltip" src="images/questionmark.png" width="20"/> 
       ALIAS [ES. A1 PER ATTIVITA DELLA SEZIONE , A1_A PER INDICATORE DELL'ATTIVITA]
      </td>
      <td>
        <input type = "text" name="alias" <%="no".equals(request.getAttribute("Cessazione")+"") ? "required" : "" %>  value="<%=PianoRiferimentoAtt.getId()>0 ? PianoRiferimentoAtt.getAlias() : PianoRiferimentoInd.getAlias() %>" >
   
    
       </td>
    </tr>
    
    

      <%
    String tipologia = "" ;
    if (PianoRiferimentoAtt.getTipoAttivita()!=null)
    	tipologia = PianoRiferimentoAtt.getTipoAttivita() ;
    else
    	tipologia = PianoRiferimentoInd.getTipoAttivitaPiano();
    
    %>
    <tr>
      <td nowrap class="formLabel">
      TIPO DI ATTIVITA
       </td>
       
     
      <td>
      <select name="tipoAttivita" required <%= (PianoRiferimentoInd.getId()>0 ||( PianoRiferimentoAtt.getId()>0 && (PianoRiferimentoAtt.getElencoIndicatori().size()>0 || (PianoRiferimentoAtt.getElencoIndicatori().size()==1 && PianoRiferimentoAtt.getElencoIndicatori().get(0).getDescription().contains("DEFAULT"))))) ? "disabled" :"" %>>
      <option <%=tipologia.equals("") ? "selected" : "" %> value="">Seleziona Tipo </option>
      <option <%=tipologia.equalsIgnoreCase("piano") ? "selected" : "" %> value="PIANO">PIANO </option>
      <option <%=tipologia.equalsIgnoreCase("ATTIVITA-AUDIT") ? "selected" : "" %> value="ATTIVITA-AUDIT">ATTIVITA-AUDIT</option>
       <option <%=tipologia.equalsIgnoreCase("ATTIVITA-SORVEGLIANZA") ? "selected" : "" %> value="ATTIVITA-SORVEGLIANZA">ATTIVITA-SORVEGLIANZA</option>
       <option <%=tipologia.equalsIgnoreCase("ATTIVITA-ISPEZIONE") ? "selected" : "" %> value="ATTIVITA-ISPEZIONE">ATTIVITA-ISPEZIONE</option>
      </select>
      
      <%
     if(  PianoRiferimentoAtt.getId()>0 && (PianoRiferimentoAtt.getElencoIndicatori().size()>0 || (PianoRiferimentoAtt.getElencoIndicatori().size()==1 && PianoRiferimentoAtt.getElencoIndicatori().get(0).getDescription().contains("DEFAULT"))))
     {
    	 %>
    	 <input type = "hidden" name = "tipoAttivita" value="<%=PianoRiferimentoAtt.getId()>0 ? PianoRiferimentoAtt.getTipoAttivita() : PianoRiferimentoInd.getTipoAttivita() %>">
    	 <%
     }
     else
     {
    	 if (PianoRiferimentoInd.getId()>0)
    	 {
    		 %>
        	 <input type = "hidden" name = "tipoAttivita" value="<%=PianoRiferimentoAtt.getId()>0 ? PianoRiferimentoAtt.getTipoAttivita() : PianoRiferimentoInd.getTipoAttivita() %>">
        	 <%
    	 }
     }
      %>
   
       </td>
    </tr>
    
   <tr>
      <td nowrap class="formLabel">
      Codice Esame
       </td>
      <td>
     <input type = "text" name="codice_esame" value="<%=PianoRiferimentoAtt.getId()>0 ? toHtml(PianoRiferimentoAtt.getCodiceEsame()) : toHtml(PianoRiferimentoInd.getCodiceEsame()) %>">
   
       </td>
    </tr>
  
  
    
	<tr>
      <td nowrap class="formLabel">
      Descrizione
      </td>
      <td>
         <textarea rows="6" cols="75" required name="descrizione" value ="<%=PianoRiferimentoAtt.getId()>0 ? PianoRiferimentoAtt.getDescription() : PianoRiferimentoInd.getDescription() %>"><%=PianoRiferimentoAtt.getId()>0 ? PianoRiferimentoAtt.getDescription() : PianoRiferimentoInd.getDescription() %></textarea>

       </td>
    </tr>
    
    
     <%if(PianoRiferimentoInd.getDescription()!=null){ %>
    <tr>
      <td nowrap class="formLabel">
      Coefficiente Indicatore
      </td>
      <td>
     SI <INPUT TYPE ="radio" value = "si" name ="uiCalcolabile" <%=PianoRiferimentoInd.getUiCalcolabile()==true ? "checked" : "" %> onclick="document.getElementById('coefficiente').style.display='';"> NO <INPUT TYPE ="radio" <%=PianoRiferimentoInd.getUiCalcolabile()==false ? "checked" : "" %>  value = "no" name ="uiCalcolabile" onclick="document.getElementById('coefficiente').value='0' ; document.getElementById('coefficiente').style.display='none';">
    
    <input type = "number" pattern="[0-9]+([\.][0-9]+)?" step="0.01"  name = "coefficiente" id = "coefficiente" value ="<%=PianoRiferimentoInd.getCoefficiente()!=null ? ""+PianoRiferimentoInd.getCoefficiente().getCoefficiente() : "0" %>" <%=PianoRiferimentoInd.getUiCalcolabile()==false ? "style='display:none'" : "" %>>
       </td>
    </tr>
    <%} %>
    
   
   
   <tr>
      <td nowrap class="formLabel">
      Data Inizio Validita
      </td>
      <td>
         <input required="required" type="text" readonly="readonly" id="dataScadenza" name="dataScadenza" size="10" value = "<%=toDateasString(new Timestamp(System.currentTimeMillis())) %>" />
		
       </td>
    </tr>
    
  


 
       </table>
     
<br />


<br>
<input type="hidden" name="cessazione" value="<%=request.getAttribute("Cessazione") %>">

<input type = "hidden" name = "id" value = "<%=PianoRiferimentoAtt.getId()>0 ? PianoRiferimentoAtt.getId() : PianoRiferimentoInd.getId() %>">
<input type = "hidden" name = "tipoClasse" value = "<%=PianoRiferimentoAtt.getId()>0 ? "dpat_attivita" : "dpat_indicatore" %>">
<input type = "hidden" name = "disabilita" value = "">
<input type = "hidden" name="cessato" value ="<%=request.getAttribute("Cessazione") %>">


<input type="submit" value="Aggiorna" name="Save" onClick="return checkForm(this.form)">
<input type="button" value="Annulla"  onClick="window.close()">
</form>

</body>