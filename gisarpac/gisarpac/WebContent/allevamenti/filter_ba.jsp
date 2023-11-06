<%@page import="com.itextpdf.text.log.SysoLogger"%>
<%@ page import="java.util.*,org.aspcfs.utils.*"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio"%>
<%@ include file="../initPage.jsp"%>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean"
	scope="session" />
<SCRIPT LANGUAGE="JavaScript" SRC="javascript/CalendarPopup.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">document.write(getCalendarStyles());</SCRIPT>
<SCRIPT LANGUAGE="JavaScript" ID="js19">
var cal19 = new CalendarPopup();
cal19.showYearNavigation();
cal19.showYearNavigationInput();
cal19.showNavigationDropdowns();
</SCRIPT>

 <link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>
  
 <script src='javascript/modalWindow.js'></script>
  <script src='javascript/jquerymini.js'></script>	
  
<script type="text/javascript" src="dwr/interface/PopolaCombo.js"> </script>
        <script type="text/javascript" src="dwr/engine.js"> </script>
        <script type="text/javascript" src="dwr/util.js"></script>
        <script type="text/javascript">
  
        
    	function checkValue(){
    		
    		formTest = true;
    		message = "";
    		idCu = document.getElementById('idControllo').value; 
    		
    		if(idCu == ""){
    			message+='Inserire un identificativo del controllo\n';
    			formTest = false;
    		}
    		
    		if(message != ""){
    			alert(message);
    		}
    		if(formTest){
    			loadModalWindow();
    	        document.forms['deletecu'].submit();    
    				
    		}

    		return formTest;	
    		
    	}
        
    	function checkData(){

    		formTest = true;
    		message = "";
    		data1 = document.getElementById('data1').value;
    		data2 = document.getElementById('data2').value; 
    		
    		if( data1 == "" && data2 == ""){
    			message+='Inserire un range di date\n';
    			formTest = false;
    		}
    		if( data1 == "" && data2 != ""){
    			message+='Inserire una data di inizio periodo\n';
    			formTest = false;
    		}
    		if( data2 == "" && data1 !=""){
    			message+='Inserire una data di fine periodo\n';
    			formTest = false;
    		}
    		else{
    			if(data2 != ""){
    				//data1 > data2
    				if(giorni_differenza(data1,data2) < 0 ){
    					message+='Data di inizio periodo > Data di fine periodo\n';
    					formTest = false;
    				}			
    			}
    		}
    	
    		if(message != ""){
    			alert(message);
    		}
    		if(formTest){
    			loadModalWindow();
    	        document.forms['generateReport'].submit();    
    				
    		}

    		return formTest;	
    	}
        
    	function checkDataB11(){

    		formTest = true;
    		message = "";
    		data1 = document.getElementById('data1_b11').value;
    		data2 = document.getElementById('data2_b11').value; 
    		
    		if( data1 == "" && data2 == ""){
    			message+='Inserire un range di date\n';
    			formTest = false;
    		}
    		if( data1 == "" && data2 != ""){
    			message+='Inserire una data di inizio periodo\n';
    			formTest = false;
    		}
    		if( data2 == "" && data1 !=""){
    			message+='Inserire una data di fine periodo\n';
    			formTest = false;
    		}
    		else{
    			if(data2 != ""){
    				//data1 > data2
    				if(giorni_differenza(data1,data2) < 0 ){
    					message+='Data di inizio periodo > Data di fine periodo\n';
    					formTest = false;
    				}			
    			}
    		}
    	
    		if(message != ""){
    			alert(message);
    		}
    		if(formTest){
    			loadModalWindow();
    	        document.forms['generateReportB11'].submit();    
    				
    		}

    		return formTest;	
    	}
        
    	
</script>

 <dhv:container name="inviocuba" selected="Invia" object="">
 <% 
 	String messaggio = "";
    if(request.getParameter("esito")!= null && request.getParameter("esito").equals("OK")){
    	messaggio = "Cancellazione effettuta con successo!";
    }
    else if(request.getParameter("esito")!= null && request.getParameter("esito").equals("KO")){
    	messaggio = "Cancellazione non avvenuta per errore. Contattare l\'HD di II livello.";
    }
    else {
    	messaggio = "Puoi Cancellare un CU dalla BDN oppure inviare massivamente i CU sul Benessere Animale e B26";
   
    }
    	
    
 %>
 
 <body onload="alert('<%=messaggio%>');">
 
<%-- Trails --%>
<table class="trails" cellspacing="0">
	<tr>
		<td width="100%"><a href="Stabilimenti.do"><dhv:label
			name="">Benessere Animale</dhv:label></a> > <dhv:label
			name="">Importa Schede Benessere Animale</dhv:label>
		</td>
	</tr>
</table>
<%-- End Trails --%>

<br>
<form  name="deletecu" method="post" action = "Allevamenti.do?command=DeleteCuBenessere">
    <input type = "text" id="idControllo" name="idControllo"/>
	<input type = "button" onclick="javascript: checkValue();" value ="Cancella CU dalla BDN">
</form>
<br>
<br>

<form  name="generateReport" method="post" action = "Allevamenti.do?command=SendCUBenessere&tipo=massivo">

	 <table cellpadding="4" cellspacing="0" border="0" width="70%" class="details">
        <tr>
          <th colspan="2">
            <strong><dhv:label name="Invia CU Benessere animale">Invia CU Benessere animale</dhv:label></strong>
          </th>
        </tr>
        <tr>
          <td nowrap class="formLabel">
            <dhv:label name=""></dhv:label>
          </td>
          <td>
           Dal <input readonly type="text" name="searchtimestampInizio" id="data1" size="10" />
			<a href="#" onClick="cal19.select(document.generateReport.searchtimestampInizio,'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19">
			<img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a><font color="red">*</font>
			Al <input readonly type="text" name="searchtimestampFine" id="data2" size="10" />&nbsp;
			<a href="#" onClick="cal19.select(document.generateReport.searchtimestampFine,'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19">
			<img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a><font color="red">*</font>&nbsp;				  	
         </td>
        </tr>
	</table>	
<input type = "button" value = "INVIA" onclick="javascript:checkData();">
</form>

<form  name="generateReportB11" method="post" action = "Allevamenti.do?command=SendCUB11&tipo=massivo">

	 <table cellpadding="4" cellspacing="0" border="0" width="70%" class="details">
        <tr>
          <th colspan="2">
            <strong>Invia CU per la sicurezza alimentare - Atto B26</strong>
          </th>
        </tr>
        <tr>
          <td nowrap class="formLabel">
            <dhv:label name=""></dhv:label>
          </td>
          <td>
           Dal <input readonly type="text" name="searchtimestampInizio_b11" id="data1_b11" size="10" />
			<a href="#" onClick="cal19.select(document.generateReportB11.searchtimestampInizio_b11,'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19">
			<img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a><font color="red">*</font>
			Al <input readonly type="text" name="searchtimestampFine_b11" id="data2_b11" size="10" />&nbsp;
			<a href="#" onClick="cal19.select(document.generateReportB11.searchtimestampFine_b11,'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19">
			<img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a><font color="red">*</font>&nbsp;				  	
         </td>
        </tr>
	</table>	
<input type = "button" value = "INVIA" onclick="javascript:checkDataB11();">
</form>
</body>
</dhv:container>


	