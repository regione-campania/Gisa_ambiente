<%--Pagina JSP creata da Alberto --%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>

<%@ include file="../initPage.jsp" %>
<body>

<table class="trails" >
	<tr > 
		<td width="100%">
			Seleziona operazione 
		</td> 
	</tr>
</table>

<form name="scelta" action="" method="post">
	<table >
	  <tr>
	    <td>
	    	<input	type="submit"
      				name="Farmacie/Grossisti"
	      			value="Farmacie/Grossisti"
    	  			onclick="javascript:this.form.action='Farmacosorveglianza.do?command=SearchFormFcie'"
      		/>
	    </td>
	  
	    <td>
	    	<input type="submit" 
	    		   name="Parafarmacie/Farmacie" 
	    		   value="Parafarmacie/Farmacie"
    	  		   onclick="javascript:this.form.action='Parafarmacie.do?command=SearchFormFcie'"
        	/>
	    </td>
	  </tr>
	
	</table>
</form>

<br/>

</body>