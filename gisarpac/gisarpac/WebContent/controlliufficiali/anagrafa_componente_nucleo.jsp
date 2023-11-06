<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<script src='javascript/modalWindow.js'></script>
<script src="javascript/jquery-1.8.2.js"></script>
<script src="javascript/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>

<jsp:useBean id="nomeQualifica" class="java.lang.String" scope="request"/>
<jsp:useBean id="idQualifica" class="java.lang.String" scope="request"/>
<jsp:useBean id="indice" class="java.lang.String" scope="request"/>
    
    <script>
    function checkForm(form){
    	
    	var nome = document.getElementById("nome").value;
    	var cognome = document.getElementById("cognome").value;
    	var message="";
    	
    	if (nome.trim() == '')
    		message+="Compilare il campo nome/matricola \n";
    	if (cognome.trim() == '')
    		document.getElementById("cognome").value=" ";
    	
  	 	if (message!=''){
    		alert(message);
    		return false;
    	}
    	
    	
    	loadModalWindow();
    	form.submit();
    }
    
    
    </script>
    
    <DIV ID='modalWindow' CLASS='unlocked'><P CLASS='wait'>Attendere il completamento dell'operazione...</P></DIV>
    
    
    <form id = "addComponente" name="addComponente" action="NucleoIspettivo.do?command=InsertComponenteNucleo&auto-populate=true" method="post">
    
   <table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
	<tr>
	  <th colspan="2"><strong>Contatto</strong></th>
	</tr>
	<tr>
	  <td class="formLabel">Nome / Matricola</td>
	  <td><input type="text" name="nome" id="nome" value="" maxlength="70"/><font color=red>*</font></td>
	</tr>
	<tr>
	  <td class="formLabel">Cognome</td>
	  <td><input type="text" name="cognome" id="cognome" value=""  maxlength="70"/></td>
	</tr>
	
	<tr>
	  <td class="formLabel">Qualifica</td>
	  <td><b><%=nomeQualifica %></b></td>
	</tr>
	
	<input type="hidden" id="idQualifica" name="idQualifica" value="<%=idQualifica %>"/>
	<input type="hidden" id="indice" name="indice" value="<%=indice %>"/>
	

	<tr>
	  <td class="formLabel" colspan="2"><input type="button" value="SALVA" onClick="checkForm(this.form)"/></td>
	</tr>

	</table>
    
    
    </form>
    
    