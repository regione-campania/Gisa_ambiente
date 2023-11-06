
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<%@page import="org.aspcfs.modules.programmazzionecu.base.PianoMonitoraggioList"%>


<%@page import="org.aspcfs.modules.dpat.base.PianoMonitoraggio"%>
 
<!-- nuova gestione dpat -->
<%@page import="org.aspcfs.modules.dpatnew_interfaces.*" %>
 

<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>
<link rel="stylesheet" type="text/css" href="css/capitalize.css"></link>

<script src='javascript/modalWindow.js' type="text/javascript" ></script>

<jsp:useBean id="lookup_sezioni_piani" class = "org.aspcfs.utils.web.LookupList" scope = "request">
</jsp:useBean>

<jsp:useBean id="lookup_piani" class = "org.aspcfs.utils.web.LookupList" scope = "request">
</jsp:useBean>
<jsp:useBean id="lookup_asl" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<%@ include file="../initPage.jsp" %>

<%
	DpatPianoAttivitaNewBeanInterface PianoAttivitaNewDPat = (DpatPianoAttivitaNewBeanInterface)request.getAttribute("PianoAttivitaNewDPat");
	DpatIndicatoreNewBeanAbstract IndicatoreNewDPat = (DpatIndicatoreNewBeanAbstract)request.getAttribute("IndicatoreNewDPat");
	int anno = request.getAttribute("anno") != null ? Integer.parseInt((String)request.getAttribute("anno")) : -1;
	Boolean congelato = request.getAttribute("congelato") != null ? Boolean.parseBoolean((String)request.getAttribute("congelato")) : false;
	System.out.println(congelato+"%%%%%%%");
%>

 <script>
 
 function verificaEsistenzaCodiceCallback(ret)
 {
	 //alert("ret[0]:"+ret[0]+" - ret[1]:"+ret[1]);
	 
	 if (ret[0]=="true")
		 {
	 	flag=false;
	 	msg+=" - Attenzione Il codice Univoco Inserito è Occupato. ";
	 	if(ret[1]!="ko")
	 		{
	 		
	 		msg+="Il prossimo codice libero è il seguente : "+ret[1];
	 		document.getElementById("cup").value=ret[1];
	 		}
	 	
		 }
 }


 function verificaEsistenzaCodice(codiceAttivita, anno, idpianoatt, tipologia)
 {
	 var idindicatore = document.getElementById("idIndicatore").value;
	 
	 //alert ("codiceAttivita: "+codiceAttivita+" - anno: "+anno+" - idpianoatt: "+idpianoatt+" - tipologia: "+tipologia+" - idindicatore: "+idindicatore);
	 
	 if(codiceAttivita!='')
	 {
		 if(tipologia == 'piano_attivita'){
			PopolaCombo.verificaEsistenzaCodiceAttivitaNEW(codiceAttivita, anno, idpianoatt, {callback:verificaEsistenzaCodiceCallback,async:false})
		 }else{			
			PopolaCombo.verificaEsistenzaCodiceIndicatoreNEW(codiceAttivita,  anno, idpianoatt, idindicatore, {callback:verificaEsistenzaCodiceCallback,async:false})
	 	}
	 }
		 
 }
 
 var flag = true ;	
 var msg = '' ;
 function checkForm(form,tipologia)
 {
	 flag = true ;
	 msg = '' ;
	
	/* if(/^[0-9]{5}$/.test(document.getElementById("cup").value) == false)
	 {
		alert("Formato codice univoco non valido. Formato di esempio: 00010");
		flag = false;
		return flag;
	 }*/
	 	 
	 verificaEsistenzaCodice(document.getElementById("cup").value,document.getElementById("anno").value,document.getElementById("idPianoRiferimento").value,tipologia);

	 
	 if (document.addPiano.descrizione.value == '')
	 {
		flag = false ;
		msg += " - Attenzione ! Inserire la descrizione del piano che si intende inserire \n ";
	 }

	/* if (document.addPiano.root.value == '-1')
	 {
		flag = false ;
		msg += " - Attenzione ! Inserire la sezione del piano che si intende inserire \n ";
	 }*/
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
		  window.opener.document.forms[0].action = 'Dpat.do?command=SearchPianiMonitoraggioNewDpat&congelato=<%=congelato%>&anno=<%=anno%>';
		  window.opener.loadModalWindowCustom("Ricaricamento in Corso");
		  window.opener.document.forms[0].submit();
		  window.close();
	  }

	}
 </script>
 <body  onblur="if(focus_==true){window.focus();}"  onload = "chiudiPopUp('<%=request.getAttribute("inserito")%>')" onmouseout="focus_=true;" onmouseover="focus_=false;" >
 <form name="addPiano" action="Dpat.do?command=InsertEffettivo" method="post" onsubmit="return checkForm(this.form, '<%= PianoAttivitaNewDPat != null && !PianoAttivitaNewDPat.getTipoInserimento().equalsIgnoreCase("firstchild") ? "piano_attivita" : "indicatore" %>' )">
 <input type="hidden" name="congelato" value="<%=congelato %>" />  
 <input type = "hidden" id="anno" name = "anno" value="<%=PianoAttivitaNewDPat  != null ? PianoAttivitaNewDPat.getAnno(): IndicatoreNewDPat.getAnno() %>">
<%-- Trails --%>

<%-- End Trails --%>
<input type="submit" value="<dhv:label name="button.insert">Insert</dhv:label>" name="Save" >
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
      <strong><dhv:label name=""><%=(PianoAttivitaNewDPat !=null && !PianoAttivitaNewDPat.getTipoInserimento().equals("firstchild") ) ? "NUOVO PIANO/ATTIVITA" : "NUOVO INDICATORE" %></dhv:label></strong>
    </th>
	</tr>
	
	
	 
	
	 
    
      <tr>
      <td nowrap class="formLabel">
       Tipo Inserimento
      </td>
      <td>
      
         <%=(PianoAttivitaNewDPat !=null)? PianoAttivitaNewDPat.getTipoInserimento() : IndicatoreNewDPat.getTipoInserimento() %>
     	<input type ="hidden" name="tipoInserimento" value="<%=(PianoAttivitaNewDPat !=null)? PianoAttivitaNewDPat.getTipoInserimento() : IndicatoreNewDPat.getTipoInserimento()  %>">
       </td>
    </tr>
    
    
    <tr>
      <td nowrap class="formLabel">
       RIFERIMENTO <%=(PianoAttivitaNewDPat !=null) ?  "AL PIANO/ATTIVITA" : "ALL'INDICATORE" %>
      </td>
      <td>
            <%=(PianoAttivitaNewDPat !=null)? PianoAttivitaNewDPat.getDescrizione() : IndicatoreNewDPat.getDescrizione() %>
      
     	 <input type="hidden" name="tipoInserimento" value="<%=(PianoAttivitaNewDPat !=null) ? PianoAttivitaNewDPat.getTipoInserimento():IndicatoreNewDPat.getTipoInserimento()  %>"/>
     	 <%-- 
     	<input type="hidden" id="idPianoRiferimento" name="idPianoRiferimento" value="<%=(PianoAttivitaNewDPat != null)?PianoAttivitaNewDPat.getOid() : IndicatoreNewDPat.getOid() %>"/>
     	--%>
     	<input type="hidden" id="idPianoRiferimento" name="idPianoRiferimento" value="<%=(PianoAttivitaNewDPat != null)?PianoAttivitaNewDPat.getOid() : IndicatoreNewDPat.getOidPianoAttivita() %>"/>
     	<input type="hidden" id="idIndicatore" name="idIndicatore" value="<%=(PianoAttivitaNewDPat != null)?-1 : IndicatoreNewDPat.getOid() %>"/>
     	
       </td>
    </tr>
    
    
   <tr>
      <td nowrap class="formLabel">
       
       CODICE UNIVOCO
      </td>
      <td>
     <input type = "text" name="cup" id="cup" pattern="\d*" required  >
   
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
    if (PianoAttivitaNewDPat !=null)
    	tipologia = PianoAttivitaNewDPat.getTipoAttivita();
    else
    	tipologia = IndicatoreNewDPat.getTipoAttivita();
    
    if (tipologia == null)
    	tipologia = "" ;
    
    %>
    <tr>
      <td nowrap class="formLabel">
      Tipo
       </td>
      <td>
      
      <%
      if(tipologia!=null && !"".equalsIgnoreCase(tipologia) && (PianoAttivitaNewDPat  == null || PianoAttivitaNewDPat.getTipoInserimento().equalsIgnoreCase("firstchild")) )
      {
    	  %>
    	  
    	  <%--=tipologia.toUpperCase() --%><%="INDICATORE ("+tipologia.toUpperCase()+")" %>
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
     <input type = "text" name="codice_esame" value="<%= PianoAttivitaNewDPat != null ? toHtml(PianoAttivitaNewDPat.getCodiceEsame()) : toHtml(IndicatoreNewDPat.getCodiceEsame())  %>">
   
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
    
  
    
  <input type ="hidden" name="tipoPianoAttInd" value = "<%=(PianoAttivitaNewDPat != null) ? "dpat_attivita" : "dpat_indicatore" %>">
 
       </table>
       <%} %>
     
<br />


<br>
<input type="submit" value="<dhv:label name="button.insert">Insert</dhv:label>" name="Save"  >
<input type="button" value="Annulla"  onClick="window.close()">
</form>

</body>