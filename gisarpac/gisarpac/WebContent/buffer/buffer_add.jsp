<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="java.util.*,org.aspcfs.modules.troubletickets.base.*" %>
<%@ include file="../initPage.jsp" %>

<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.text.DateFormat, org.aspcfs.modules.actionplans.base.*" %>

<jsp:useBean id="ListaStato" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ListaComuni" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="systemStatus" class="org.aspcfs.controller.SystemStatus" scope="request"/>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popAccounts.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popServiceContracts.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popAssets.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popProducts.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popURL.js"></script>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popCalendar.js"></script>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popContacts.js"></SCRIPT>
<script language="JavaScript">
  
  function checkForm(form){
  	  
    formTest = true;
    message = "";
   

   
    if (form.dataEvento.value == "") {
        message += label("check..data_richiesta.selezionato","- Controllare che il campo \"Data Evento\" sia stato popolato\r\n");
        formTest = false;
      }

    if (form.codiceBuffer.value == "") {
        message += label("check..data_richiesta.selezionato","- Controllare che il campo \"Codice Buffero\" sia stato popolato\r\n");
        formTest = false;
      }

    if (form.descrizioneBreve.value == "") {
        message += label("check..data_richiesta.selezionato","- Controllare che il campo \"Descrizione Breve\" sia stato popolato\r\n");
        formTest = false;
      }

	comunesel = false ;
	for (i=0 ; i <form.comuniCoinvolti.options.length ; i++ )
	{
		if (form.comuniCoinvolti.options[i].selected == true && form.comuniCoinvolti.options[i].value !='-1')
		{
			comunesel = true ;
			break ;
		}
	}
	   if (comunesel == false) {
	        message += label("check..data_richiesta.selezionato","- Controllare che il campo \"Comuni Coinvolti\" sia stato popolato\r\n");
	        formTest = false;
	      }

	
	
    
    if (formTest == false) {
      alert(label("check.form", "Form could not be saved, please check the following:\r\n\r\n") + message);
      return false;
    } else {
      loadModalWindow(); 
      return true;
    }
  }


</script>


<form name="addticket"  action="Buffer.do?command=Insert&auto-populate=true" method="post">
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Buffer.do?command=SearchForm"><dhv:label name="sanzioniss">Buffer</dhv:label></a> > 
Aggiungi Buffer
</td>
</tr>
</table>


<br>
<%-- End Trails --%>
<input type="submit" value="<dhv:label name="button.insert">Insert</dhv:label>" name="Save" onClick="return checkForm(this.form)">
<input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.action='Buffer.do?command=SearchForm'">
<br>

<dhv:formMessage />



<table cellpadding="4" cellspacing="0" width="100%" class="details">
	<tr>
    <th colspan="2">
      <strong><dhv:label name="">Aggiungi Buffer</dhv:label></strong>
    </th>
	</tr>
	
	<tr>
      <td  nowrap class="formLabel">
        <dhv:label name="">Codice Buffer</dhv:label>
      </td>
    <td>
    <input type = "text" name = "codiceBuffer" >
	</td>
 </tr>
 
	<tr>
      <td  nowrap class="formLabel">
        <dhv:label name="">Descrizione Evento in Breve</dhv:label>
      </td>
    <td>
     <textarea rows="6" cols="30" name="descrizioneBreve"></textarea>
	</td>
 </tr>
 
 <tr>
      <td  nowrap class="formLabel">
        <dhv:label name="">Data Evento</dhv:label>
      </td>
    <td>
       <input type="text" name="dataEvento" id ="dataEvento" readonly="readonly" size="10" value="" />&nbsp;<a href="javascript:popCalendar('addticket','dataEvento','it','IT','Europe/Berlin');"><img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>

	</td>
 </tr>
 
 
 <tr>
      <td  nowrap class="formLabel">
        <dhv:label name="">Comuni Coinvolti Dall'Evento</dhv:label>
      </td>
    <td>
       <%
       ListaComuni.setMultiple(true);
       ListaComuni.setSelectSize(9);
       
       %>
		<%=ListaComuni.getHtmlSelect("comuniCoinvolti",-1) %>
	</td>
 </tr>
 
  <tr>
      <td  nowrap class="formLabel">
        <dhv:label name="">Stato</dhv:label>
      </td>
    <td>
      
		<%=ListaStato.getHtmlSelect("stato",1) %>
	</td>
 </tr>
 
  <tr>
      <td  nowrap class="formLabel">
        <dhv:label name="">Note</dhv:label>
      </td>
    <td>
           <textarea rows="6" cols="30" name="note"></textarea>

	</td>
 </tr>
 
 
 
  
 
 
 

 
</table>


<br>
<input type="submit" value="<dhv:label name="button.insert">Insert</dhv:label>" name="Save" onClick="return checkForm(this.form)">
<input type="submit" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" onClick="javascript:this.form.action='Bufffer.do?command=SearchForm'">
</form>
</body>