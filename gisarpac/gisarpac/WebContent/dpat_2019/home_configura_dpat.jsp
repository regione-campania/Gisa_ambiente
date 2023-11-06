<%@page import="org.aspcfs.modules.dpat2019.base.DpatWrapperSezioniBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.aspcfs.modules.dpat.base.DpatIstanza"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"
	import="java.util.Calendar, java.util.Iterator"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>
<%@page import="org.aspcfs.utils.web.CustomLookupElement"%>
<%@page import="org.aspcfs.modules.dpat2019.base.*" %>
<%@page import="org.aspcfs.modules.dpat2019.base.*" %>
<%@page import="org.aspcfs.modules.dpat2019.*" %>

<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session" />
<jsp:useBean id="wrapperTuttiModelli" class="org.aspcfs.modules.dpat2019.base.WrapperTuttiModelli" scope="request" />
<jsp:useBean id="annoCorrente" class="java.lang.String" scope="request" />

	<table class="trails" cellspacing="0">
		<tr>
			<td width="100%"><a href="dpat2019.do">DPAT</a>  
			</td>
		</tr>
	</table>

	<%
		ArrayList<DpatWrapperSezioniNewBeanAbstract > congelati = wrapperTuttiModelli.modelliNonTemplates; /*qui ci sono quelli non templates , cio� che non hanno nodi a 1 ma a 0 o 2 come stato */
		ArrayList<DpatWrapperSezioniNewBeanAbstract > noncong = wrapperTuttiModelli.modelliTemplates; /*(solo 1 al max)qui ci sono quelli che hanno tutti i nodi a 1, */
		
	%>
	<%if(congelati != null && congelati.size() > 0) {
		int anno = congelati.get(0).getAnno();
		%>
		
		<fieldset>
		
			<legend>QUI SONO DISPONIBILI I MODELLI A SECONDA DELL'ANNO</legend>
			
			SELEZIONARE L'ANNO
			
			<select id="ANNO">
				  <%
				    if(noncong != null && noncong.size() > 0)
				    { 
				    	for(DpatWrapperSezioniNewBeanAbstract bean : noncong)
				    	{%>
				    		
				    		<option   name="non_congelato" value="<%=bean.getAnno() %>" ><%=bean.getAnno()%> -  NON CONGELATO </option>	
				     
				       <%}
				    } 
				  
				  	for(DpatWrapperSezioniNewBeanAbstract bean : congelati)
				  	{ %>
				  	
				  		<option name="congelato" value="<%=bean.getAnno() %>" ><%=bean.getAnno() %> -  CONGELATO </option>	
				  	<%}
				   %>
				  
			</select>
			<br>
			<br>
			<input type="button" style="background-color:#FF4D00; font-weight: bold;" onclick="javascript: getOption('vaiAModello',<%=anno %>);" value="VAI"/>
			<!-- mettere permessi qui -->
			<dhv:permission name="generaModelloNonCongelato-view">
				<input id="btn_creacong" type="button" style="background-color:#FF4D00; font-weight: bold;" onclick="javascript: getOption('creaNonCongelato',<%=anno %>);" value="CREA MODELLO NON CONGELATO"/>
			</dhv:permission>
				
		</fieldset>
		
		<br><br>
		
	 <%} else {%>
	 	
	 		NON SONO DISPONIBILI MODELLI DI DPAT
	 
	 <%} %>
	 
	 <dhv:permission name="dpat-initNuovoAnno-view">
		<input style="background-color: green;" id="initNuovoAnnoConfiguratore" name="initNuovoAnnoConfiguratore" value="Inizializza nuovo anno" onclick="if(confirm('Sicuro di proseguire?')){location.href='dpat2019.do?command=InitNuovoAnno&annoCorrente=<%=annoCorrente %>';}" type="button">
	 </dhv:permission>

<script>
	function getOption(tipoOp,anno){
		
		
		var t = document.getElementById("ANNO");
		var anno = $(t.options[t.selectedIndex]).val();
		
		if(tipoOp == 'vaiAModello')
		{
			
			var isCongelato = $(t.options[t.selectedIndex]).attr("name") == 'congelato';
			window.location="dpat2019.do?command=SearchPianiMonitoraggioNewDpat&anno="+anno+"&congelato="+isCongelato;
		}
		else if(tipoOp == 'creaNonCongelato') /*crea un non congelato */
		{
			if($("option[name='non_congelato']").length > 0)
			{
				var msg="Attenzione, il modello NON congelato gia' esistente verra' sovrascritto! Sicuro di voler continuare ?";
				var risp = confirm(msg);
			 	
				if(risp == false)
					return;
			}
			 
			
			 
			var urlDest ="dpat2019.do?command=CreaTemplateNewDpat&anno="+anno;
			
			$.ajax({
				method : 'GET'				
				,url : urlDest
				,dataType : 'json'
				,success : function(resp)
				{
					if(resp.status.toLowerCase() == 'ok')
					{
						alert("Template creato correttamente");
						
						document.location.reload(true);
					}
					else
					{
						alert("Qualcosa e' andato storto ");
					}
				}
			});
		}
	 
	 
	}
	/*per la label del bottone di creazione  congelato */
	$(function(){
		
		var label = " MODELLO NON CONGELATO";
		if($("option[name='non_congelato']").length > 0)
		{
			label = "RIGENERA" + label;
		}
		else
		{
			label = "GENERA"+label;
		}

		$("#btn_creacong").val(label);
		
	});
	
	 
	
</script>
<br><br>
<br><br>
<br><br>
