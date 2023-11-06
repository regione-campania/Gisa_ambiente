<%@page import="org.aspcfs.modules.dpat.base.DpatSezione"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<%@page import="org.aspcfs.modules.programmazzionecu.base.PianoMonitoraggioList"%>


<%@page import="org.aspcfs.modules.dpat.base.PianoMonitoraggio"%>
<jsp:useBean id="PianoRiferimentoAtt" class = "org.aspcfs.modules.dpat.base.DpatAttivita" scope = "request"/>
<jsp:useBean id="PianoRiferimentoInd" class = "org.aspcfs.modules.dpat.base.DpatIndicatore" scope = "request"/>
<jsp:useBean id="IstanzaDpat" class = "org.aspcfs.modules.dpat.base.DpatIstanza" scope = "request"/>
<jsp:useBean id="ListaSezioniDpat" class = "org.aspcfs.modules.dpat.base.Dpat" scope = "request"/>



<jsp:useBean id="lookup_sezioni_piani" class = "org.aspcfs.utils.web.LookupList" scope = "request">
</jsp:useBean>

<jsp:useBean id="lookup_piani" class = "org.aspcfs.utils.web.LookupList" scope = "request">
</jsp:useBean>
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
 
<script type="text/javascript" src="javascript/jquery.miny_1.7.2.js"></script>

<script src="javascript/jquery-ui.js" type="text/javascript" ></script>
 

 
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
	 cupIniziale = document.getElementById("cupIniziale").value;
	 if(cupIniziale!=codiceAttivita && codiceAttivita!='')
	 	PopolaCombo.verificaEsistenzaCodiceAttivita(codiceAttivita,{callback:verificaEsistenzaCodiceCallback,async:false})
 }
 
 
 
 function setIdPianoAttivita()
 {
	 var idpiano_ =$('#piano option:selected').attr("chiave"); 
    $("#idPiano_").val(idpiano_);
    
   
 }
 
 
 function setPianiCombo(valori)
 {
	 $("select#piano option").remove(); 
	 for ( i = 0 ; i <valori.length; i++)
		 {
	 $("#piano").append('<option value="'+valori[i].id+'" chiave="'+valori[i].id_+'" >'+valori[i].description+'</option>');
		 }
	 
	 $("#idPiano_").val(valori[0].id_);
	 
	 
 }
 
 function setAttivitaCombo(valori)
 {
	
	 $("select#root option").remove(); 
	 for ( i = 0 ; i <valori.length; i++)
		 {
		 if(i==0)
	 		$("#root").append('<option value="'+valori[i].id+'"  selected ="selected">'+valori[i].description+'</option>');
		 else
			 $("#root").append('<option value="'+valori[i].id+'">'+valori[i].description+'</option>');
	 
		 }
	 
	 $("#root_").val(valori[0].id_);
 }
 
 function setIndicatoriCombo(valori)
 {
	
	 $("select#indicatoreRiferimento option").remove(); 
	 for ( i = 0 ; i <valori.length; i++)
		 {
		 if (i==0)
	 $("#indicatoreRiferimento").append('<option value="'+valori[i].id+'" selected="selected">'+valori[i].alias+'</option>');
		 else
			 $("#indicatoreRiferimento").append('<option value="'+valori[i].id+'">'+valori[i].alias+'</option>');
		 }
 }
 
 
 
 function setListaPianiFromSezione(idSezione,anno)
{
	 
	 PopolaCombo.getListaPiani(idSezione,anno,{callback:setPianiCombo,async:false});
	 setListaAttivitaFromPiano(document.getElementById("piano").value,anno);
	 setIdPianoAttivita();
} 
 

 function reCheck()
 {
	 if (!document.getElementById("posizioneInizio").checked)
	 {
	 document.getElementById("posizioneFine").checked = false;
	 document.getElementById("posizioneInizio").checked = true;
	 
	 }
 }
 
 function setListaAttivitaFromPiano(idPiano,anno)
 {
	 
	 PopolaCombo.getListaAttivita(idPiano,anno,{callback:setAttivitaCombo,async:false});
	
	 setListaIndicatoriFromAttivita(document.getElementById("root").value,anno);
	 reCheck();
 } 
 
 function setListaIndicatoriFromAttivita(idAttivita,anno)
 {
	 PopolaCombo.getListaIndicatori(idAttivita,anno,{callback:setIndicatoriCombo,async:false});
 	 
 } 
 
 function sceltaOperazione(anno,scelta,sezione,piano,attivita,idsez,idpiano,idatt)
 {
	 if (scelta=='3')
	 {
		 $(".enabledCombo").prop('disabled', false);
		 
		 
		 setListaPianiFromSezione(idsez,anno);
		 setListaAttivitaFromPiano(document.getElementById("piano").value,anno);
		
		 document.getElementById("posizioneIndicatore").style.display="";
		 $("#codice_esame").prop('readonly', true);
		 $("#cup").prop('readonly', true);
		 $("#alias").prop('readonly', true);
		 $("#descrizione").prop('readonly', true);
	 }
	 else
		 {
		 $(".enabledCombo").prop('disabled', true);
		 
		 $("select#sezione").val(idsez); 
		 $("select#piano option").remove(); 
		 $("select#root option").remove(); 
		 $("#root_").val(idatt); 
		 $("#idPiano_").val(""); 
		 $("#piano").append('<option value="'+idpiano+'">'+piano+'</option>');
		 $("#root").append('<option value="'+idatt+'">'+attivita+'</option>');
		 document.getElementById("posizioneIndicatore").style.display="none";
		 $("#codice_esame").prop('readonly', false);
		 $("#cup").prop('readonly', false);
		 $("#alias").prop('readonly', false);
		 $("#descrizione").prop('readonly', false);
		 
		 }
 }
 
 flag = true ;	
 msg = '' ;

 
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
 <form name="addPiano" action="Dpat.do?command=UpdateIndicatore" method="post">
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
      <strong><dhv:label name="">VARIAZIONE INDICATORE</dhv:label></strong>
    </th>
	</tr>
	
	<tr>
      <td nowrap class="formLabel">
      OPERAZIONE
      </td>
      <td>
     MODIFICA INDICATORE (*) <input type="radio" name="operazione" checked="checked" value="1" onclick="sceltaOperazione(<%=IstanzaDpat.getAnno() %>,'1','<%=PianoRiferimentoInd.getDescrizioneSezione()%>','<%=PianoRiferimentoInd.getDescrcizionePiano()%>','<%=PianoRiferimentoInd.getDescrizioneAttivita().replaceAll("'", " ")%>',<%=PianoRiferimentoInd.getIdSezione()%>,<%=PianoRiferimentoInd.getIdPiano()%>,<%=PianoRiferimentoInd.getIdAttivita_()%>)">  |  
     SOSTITUISCI INDICATORE CON NUOVO (**) <input type="radio" name="operazione" value="2" onclick="sceltaOperazione(<%=IstanzaDpat.getAnno() %>,'2','<%=PianoRiferimentoInd.getDescrizioneSezione()%>','<%=PianoRiferimentoInd.getDescrcizionePiano()%>','<%=PianoRiferimentoInd.getDescrizioneAttivita().replaceAll("'", " ")%>',<%=PianoRiferimentoInd.getIdSezione()%>,<%=PianoRiferimentoInd.getIdPiano()%>,<%=PianoRiferimentoInd.getIdAttivita_()%>)">
     
     SPOSTA INDICATORE(***)<input type="radio" name="operazione" value="3" onclick="sceltaOperazione(<%=IstanzaDpat.getAnno() %>,'3','<%=PianoRiferimentoInd.getDescrizioneSezione()%>','<%=PianoRiferimentoInd.getDescrcizionePiano()%>','<%=PianoRiferimentoInd.getDescrizioneAttivita().replaceAll("'", "")%>',<%=PianoRiferimentoInd.getIdSezione()%>,<%=PianoRiferimentoInd.getIdPiano()%>,<%=PianoRiferimentoInd.getIdAttivita_()%>)">
     
       </td>
    </tr>
	
	<tr>
      <td nowrap class="formLabel">
      CODICE UNIVOCO
      </td>
      <td>
     <input type = "text" name = "cup" id = "cup" value="<%=toHtml(PianoRiferimentoInd.getCodiceAlias())%>">
       </td>
    </tr>
   
    
    <tr>
      <td nowrap class="formLabel">
       <img title="Si Tratta della descrizione breve presente dopo la riga della sezione nel foglio allegato 5-foglio delle attivita" class="masterTooltip" src="images/questionmark.png" width="20"/> 
       ALIAS [ES. A1 PER ATTIVITA DELLA SEZIONE , A1_A PER INDICATORE DELL'ATTIVITA]
      </td>
      <td>
        <input type = "text" name="alias" id = "alias" <%="no".equals(request.getAttribute("Cessazione")+"") ? "required" : "" %>  value="<%=PianoRiferimentoAtt.getId()>0 ? PianoRiferimentoAtt.getAlias() : PianoRiferimentoInd.getAlias() %>" >
   
    
       </td>
    </tr>
    <tr>
      <td nowrap class="formLabel">
      Descrizione
      </td>
      <td>
         <textarea rows="6" cols="75" required name="descrizione" id="descrizione" value ="<%=PianoRiferimentoAtt.getId()>0 ? PianoRiferimentoAtt.getDescription() : PianoRiferimentoInd.getDescription() %>"><%=PianoRiferimentoAtt.getId()>0 ? PianoRiferimentoAtt.getDescription() : PianoRiferimentoInd.getDescription() %></textarea>

       </td>
    </tr>
    
   
	
	<tr>
      <td nowrap class="formLabel">
      SEZIONE
      </td>
      <td>
     
     <select name = "sezione" id = "sezione" disabled="disabled" class="enabledCombo" onchange="setListaPianiFromSezione(this.value,<%=IstanzaDpat.getAnno()%>)">
     <%for (DpatSezione sez : ListaSezioniDpat.getElencoSezioni()) 
     {
    	 
    	 %>
    	 <option value = "<%=sez.getId()%>" <%=sez.getId()==PianoRiferimentoInd.getIdSezione() ? "selected" : "" %>><%=sez.getDescription() %></option>
    	 <%
    	 
     }
     %>
     </select>
       </td>
    </tr>
    
    <tr>
      <td nowrap class="formLabel">
      PIANO
      </td>
      <td>
     
     <select name = "piano" id = "piano" disabled="disabled" class="enabledCombo" onchange="setListaAttivitaFromPiano(this.value,<%=IstanzaDpat.getAnno()%>);setIdPianoAttivita()">
    
    	 <option value = "<%=PianoRiferimentoInd.getIdPiano() %>"><%=PianoRiferimentoInd.getDescrcizionePiano() %></option>
    
     </select>

       </td>
    </tr>
    
    
    <tr>
      <td nowrap class="formLabel">
      ATTIVITA
      </td>
      <td>
     
     <select name = "root" id = "root">
    
    	 <option value = "<%=PianoRiferimentoInd.getIdAttivita_() %>"><%=PianoRiferimentoInd.getDescrizioneAttivita()  %></option>
    
     </select>

       </td>
    </tr>
    
    
      <tr id = "posizioneIndicatore" style="display: none">
      <td nowrap class="formLabel">
      SCEGLI LA POSIZIONE
      </td>
      <td>
     INSERISCI PRIMA DI <input type = "radio" name = "posizione" value="1" checked="checked" id = "posizioneInizio"> 
     <select name = "indicatoreRiferimento" id = "indicatoreRiferimento" class="enabledCombo">
    
     </select>
     &nbsp;&nbsp;
     INSERISCI ALLA FINE <input type = "radio" name = "posizione" id = "posizioneFine" value="2" onclick="$('#indicatoreRiferimento option:last').attr('selected','selected');">

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
     <input type = "text" name="codice_esame" id = "codice_esame" value="<%=PianoRiferimentoAtt.getId()>0 ? PianoRiferimentoAtt.getCodiceEsame() : PianoRiferimentoInd.getCodiceEsame() %>">
   
       </td>
    </tr>
  
  
    
	
    
   
   
   <tr>
      <td nowrap class="formLabel">
      Data Inizio Validita
      </td>
      <td>
         <input required="required" readonly="readonly" type="text" id="dataScadenza" name="dataScadenza" size="10" value = "<%=toDateasString(new Timestamp(System.currentTimeMillis())) %>" />
		
       </td>
    </tr>
           </table>
     <input type="submit" value="Aggiorna" name="Save" onClick="return checkForm(this.form)">
<input type="button" value="Annulla"  onClick="window.close()">
<br />
<br />
<br />
<br />
(*) 	

CON TALE OPERAZIONE SI AVRA IL MANTENIMENTO DELLA STORIA DI TUTTI I CU DI TUTTI I PIANI CHE CONDIVIDONO ATTUALMENTE LO STESSO CODICE UNIVOCO <BR>
(**) 	

CON TALE OPERAZIONE NON SI AVRA IL MANTENIMENTO DELLA STORIA DI TUTTI I CU DI TUTTI I PIANI CHE CONDIVIDONO ATTUALMENTE LO STESSO CODICE UNIVOCO<BR>
(***) 	

CON TALE OPERAZIONE SI HA LO SPOSTAMENTO DELL'INDICATORE MANTENENDO LA STORIA DI TUTTI I CU DI TUTTI I PIANI CHE CONDIVIDONO ATTUALMENTE LO STESSO CODICE UNIVOCO<BR>


<br>
<input type="hidden" name="cessazione" value="<%=request.getAttribute("Cessazione") %>">

<input type = "hidden" name = "id" value = "<%=PianoRiferimentoInd.getId() %>">
<input type = "hidden" name = "tipoClasse" value = "<%="dpat_indicatore" %>">
<input type = "hidden" name = "disabilita" value = "">
<input type = "hidden" name="cessato" value ="no">
<input type = "hidden" name="cupIniziale" id = "cupIniziale" value ="<%=PianoRiferimentoInd.getCodiceAlias()%>">

<input type = "hidden" id="idPiano_" name="idPiano_" value ="">
<input type = "hidden" id="root_" name="root_" value ="<%=PianoRiferimentoInd.getIdAttivita_()%>">



</form>

</body>