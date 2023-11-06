<%-- <% if (1==1) { %> --%>
<%-- <%@ include file="dpatDismesso.jsp" %> --%>
<%-- <%} else { %> --%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.aspcfs.modules.dpat.base.DpatIstanza"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"
	import="java.util.Calendar, java.util.Iterator"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>
<%@page import="org.aspcfs.utils.web.CustomLookupElement"%>


<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session" />
<jsp:useBean id="siteList" class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="anniList" class="java.util.ArrayList" scope="request" />

<script type="text/javascript" src="dwr/interface/PopolaCombo.js"> </script>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>



<script>
function getAreaStruttureComplesse()
{
	
	
	idAsl = document.getElementById("ASL").value ; 
	anno = document.getElementById("ANNO").value ; 
	
	if (idAsl>0 && anno >0)
		PopolaCombo.getAreeStruttureComplesse(idAsl,anno,-1,{callback: getStruttureComplesseCallBack,async:false});
		

}

function getStruttureComplesseCallBack(arrayNodi)
{
	
	var select = document.getElementById('combo_area');
	select.value="";
	anno = document.getElementById("ANNO").value ; 
	for (i = select.length - 1; i>=0; i--) {
	    
	      select.remove(i);
	    }
	if (anno>=2016)
		document.getElementById("tr_area").style.display="";
	else
		{
		document.getElementById("tr_area").style.display="none";
		var opt = document.createElement('option');
 	    opt.value = '';
 	   opt.selected = true ;
 	    opt.innerHTML = '-SELEZIONA STRUTTURA-';
 	    select.appendChild(opt);
 	   select.value="";
		
		}
	
// 	 	var opt = document.createElement('option');
// 	    opt.value = '';
	  
// 	    opt.innerHTML = '-SELEZIONA STRUTTURA-';
// 	    select.appendChild(opt);
	    
	for ( i = 0; i<arrayNodi.length; i++){
		if (arrayNodi[i]!=null)
			{
	    var opt = document.createElement('option');
	    opt.value = arrayNodi[i].codiceInternoFK;
	  
	    opt.innerHTML = arrayNodi[i].descrizioneAreaStruttureComplesse;
	    select.appendChild(opt);
			}
	}
}

$(function () {
    
	
	
	
	 $( "#congelaStruttureReportistica" ).dialog({
	    	autoOpen: false,
	        resizable: false,
	        closeOnEscape: false,
	       	title:"CONGELA STRUTTURE PER REPORTISTICA",
	        width:420,
	        height:200,
	        draggable: false,
	        modal: true,
	        buttons:{
	        	 "CONGELA": function() {  $( "#reportistica" ).submit(); $(this).dialog("close"); } ,
	        	 "ESCI" : function() { $(this).dialog("close");}
	        	
	        },
	        show: {
	            effect: "blind",
	            duration: 1000
	        },
	        hide: {
	            effect: "explode",
	            duration: 1000
	        }
	       
	    }).prev(".ui-dialog-titlebar").css("background","#bdcfff");
	 
 
});         

</script>



	
	<script>function inviaFileExcel(form){
		var errorString = '';
		var s = document.getElementById("ASL");
		var asl = s.options[s.selectedIndex].value;
		var t = document.getElementById("ANNO");
		var anno = t.options[t.selectedIndex].value;
		var comboArea =  document.getElementById('combo_area');
		var idArea = comboArea.options[comboArea.selectedIndex].value;
		
		if(asl == -1)
		{
			errorString+='Selezionare ASL di riferimento';
		}
		
		
		
		var areaIdInput = document.createElement('input');
		areaIdInput.type = 'hidden';
		areaIdInput.name = 'combo_area';
		areaIdInput.value = idArea;
		
		
		var aslInput = document.createElement('input');
		aslInput.type = 'hidden';
		aslInput.name = 'asl';
		aslInput.value = asl;
		
		var annoInput = document.createElement('input');
		annoInput.type = "hidden";
		annoInput.name = 'anno';
		annoInput.value = anno;
		
		form.appendChild(aslInput);
		form.appendChild(annoInput);
		form.appendChild(areaIdInput);
		
		//alert(idArea);
		var fileCaricato = form.file1;
		//var oggetto = form.subject.value;
		
		if (fileCaricato.value==''){// || (!fileCaricato.value.endsWith(".pdf") && !fileCaricato.value.endsWith(".csv"))){
			errorString+=' Errore! Selezionare un file!';
			form.file1.value='';
		}
		/*if (oggetto==''){
			errorString+='\nErrore! L\'oggetto è obbligatorio.';
			}
		if (!GetFileSize(form.file1))
			errorString+='\nErrore! Selezionare un file con dimensione inferiore a 3,00 MB'; */
		if (errorString!= '')
			alert(errorString);
		else
		{
		//form.filename.value = fileCaricato.value;	
		
		
		form.asl= asl;
		form.anno = anno;
		
		loadModalWindow();
		form.submit();
		}
	}</script>
	
	
	
	<div align="right">

<input type = "button" value = "CONGELA STRUTTURE PER REPORTISTICA" onclick=" $( '#congelaStruttureReportistica' ).dialog('open');">
</div>

	<dhv:permission name="dpat-sdc-stato-view">
	<a  href = "#" onclick="javascript:window.open('http://srv.gisacampania.it/sdc/stato_mod2.jsp')">Stato Avanzamento Modello 2</a>
	<a  href = "#" onclick="javascript:window.open('http://srv.gisacampania.it/sdc/stato_mod4.jsp')">Stato Avanzamento Modello 4</a>
	<a  href = "#" onclick="javascript:window.open('http://srv.gisacampania.it/sdc/stato_mod5.jsp')">Stato Avanzamento Modello 5</a>
		</dhv:permission>
			 <table class="details" border="0" cellpadding="4" cellspacing="0" width="100%">
			    <tbody>
			    <tr>
			      <th colspan="2">
			        <img src="images/file.gif" align="absmiddle" border="0"><b>Gestione DPAT</b>
			      </th>
			    </tr>
			     
			     <tr class="containerBody">
				      <td id="selAslTd">
				       SELEZIONARE IL DIPARTIMENTO
				       <%
				       	siteList.setJsEvent("onchange='getAreaStruttureComplesse()'");
				       	%>
						<%=siteList.getHtmlSelect("ASL", User.getSiteId())%>
				      </td>
			    </tr>
			    <tr class="containerBody">
			    	<td id="selAnnoTd">
			    		SELEZIONARE L'ANNO
						<select id="ANNO" onchange="getAreaStruttureComplesse()">
							<option value = "">--SELEZIONARE--</option>
							<% if (anniList.size()>0){
									for (DpatIstanza ist : (ArrayList<DpatIstanza>)anniList){
										%>
										<option value="<%=ist.getAnno()%>"><%=ist.getAnno()%></option>
								<%  }
							} %>
						</select>
			    	</td>
			    </tr>
			    
			      <tr class="containerBody" id = "tr_area">
			    	<td >
			    		SELEZIONARE L'AREA DI STRUTTURA COMPLESSA
						<select id="combo_area" name = "combo_area" onchange="" required="required">
						<option value = "">SELEZIONARE PRIMA ASL E ANNO</option>
						</select>
			    	</td>
			    </tr>
			    <tr class="containerBody">
			    	
			    	<td >
			    		<input id="btnVai" type="button" onclick="javascript: getOption('tipoHtml');" value="VAI"/>
			    		<dhv:permission name="dpat_export-view">
			    		<input type="button" onclick="javascript:  getOption('tipoExcel');" value="Esporta come foglio Excel"/>
			    		 <select id="selectTrasposto" name="trasposto">
			    			<option value="false">ORIZZONTALE</option>
			    			<option value="true" >VERTICALE</option>
			    		</select> 
			    		<script>
			    			$("#selectTrasposto").hide();
			    		</script>
			    	</dhv:permission>
			    	<!-- </td> -->
			    </tr> 
			  <!-- </tbody>
			  </table> -->
		
	
			<TR>
			<TD>
		<dhv:permission name="dpat_import-view">
			<form id="form2" action="GenerazioneExcel.do?command=PutExcel" method="post" name="form2" enctype="multipart/form-data">
		
			        <input id="file1" name="file1" size="45" type="file" title="import excel per asl selezionata"> 
			    <!--  </tr> -->
			     <!-- <tr class ="containerBody"> -->
			        	<input id="uploadButton" name="uploadButton" value="UPLOAD" onclick="inviaFileExcel(document.forms['form2'])" type="button">
			      		<%if(request.getAttribute("msg_import") != null) {%>
							
							<div style="background-color: lightgreen;" >${msg_import}</div> 
						<%} %>
			      <!-- </tr> -->
			          <img id="image_loading" src="gestione_documenti/images/loading.gif" height="15" hidden="hidden">
			          <input disabled="" id="text_loading" name="text_loading" value="Caricamento in corso..." style="border: none" hidden="hidden" type="text">
			    <!-- </tr> -->
			    <input name="tipo_richiesta" id="tipo_richiesta" type="hidden" value="dpat"/>
			    
			 <!--  </tbody></table> -->
			   </form>
			</dhv:permission>
			
			</td>
			</TR>
	</tr>
	 </tbody>
			  </table>
	
	
	
	
<script>

	var ancoraDaScegliereSeTrasposto = true;

	function getOption(tipoRichiesta){
		var s = document.getElementById("ASL");
		var asl = s.options[s.selectedIndex].value;
		
		var t = document.getElementById("ANNO");
		var anno = t.options[t.selectedIndex].value;
		area = document.getElementById("combo_area").value ; 
		
		var flag = -1;
		var idAslUtente = <%=User.getSiteId()%>;
		if (idAslUtente>0){  // UTENTE ASL
			if (idAslUtente!=asl){
				flag=0;
				alert("Impossibile accedere ai dati di un'altra asl");
			}
			if (flag!=0 && anno=='')
			{
				flag=0;	
				alert("Selezionare anno");
			}

		} else { //UTENTE REGIONE
			if (asl==-1){
				flag=0;
				alert("Selezionare un'asl");
			}
		if (flag!=0 && anno=='')
		{
			flag=0;	
			alert("Selezionare anno");
		}
		if (area=='' && anno >=2016)
			{
				alert("Selezionare un'area");
				flag=0;
			}
		}
		
		if (flag==-1 && asl!=-1 ){
			//DAVIDE
			//window.location="Dpat.do?command=Home&idAsl="+asl+"&anno="+anno;
			
			if(tipoRichiesta == 'tipoExcel')
			{
				
				
			
				if(ancoraDaScegliereSeTrasposto == true)
				{
					$("#selectTrasposto").show(500);
					ancoraDaScegliereSeTrasposto = false;
					//disabilito tutti gli altri campi della ofrm (tranne il bottone esporta)....
					$("#ASL").prop("disabled",true);
					$("#ASL").fadeTo('slow',0.2);
					$("#ANNO").prop("disabled",true);
					$("#ANNO").fadeTo("slow",0.2);
					$("#selAnnoTd").fadeTo('slow',0.2);
					$("#selAslTd").fadeTo("slow",0.2);
					if(document.getElementById("tr_area").style.display!="none") //la select delle sole strutture complesse viene disabilitata solo se era già visibile
					{
						$("#tr_area").fadeTo("slow",0.2);
						$("#combo_area").prop("disabled",true);
						$("#combo_area").fadeTo("slow",0.2);
					}
					$("#btnVai").prop("disabled",true);
					$("#btnVai").fadeTo("slow",0.2);
					$("#uploadButton").prop("disabled",true);
					$("#uploadButton").fadeTo('slow',0.2);
					$("#file1").prop("disabled",true);
					$("#file1").fadeTo('slow',0.2);
					//---------------------------------------------------------------------------
					
				}
				else
				{
					$("#selectTrasposto").hide();
					//riabilito tutti gli altri campi della ofrm (tranne il bottone esporta)....
					$("#ASL").prop("disabled",false);
					$("#ASL").fadeTo('slow',1.0);
					$("#ANNO").prop("disabled",false);
					$("#ANNO").fadeTo("slow",1.0);
					$("#selAnnoTd").fadeTo('slow',1.0);
					$("#selAslTd").fadeTo("slow",1.0);
					if(document.getElementById("tr_area").style.display!="none") //la select delle sole strutture complesse viene riabilitata solo se era già visibile
					{
						$("#tr_area").fadeTo("slow",1.0);
						$("#combo_area").prop("disabled",false);
						$("#combo_area").fadeTo("slow",1.0);
					}
					
					$("#btnVai").prop("disabled",false);
					$("#btnVai").fadeTo("slow",1.0);
					$("#uploadButton").prop("disabled",false);
					$("#uploadButton").fadeTo('slow',1.0);
					$("#file1").prop("disabled",false);
					$("#file1").fadeTo('slow',1.0);
					
					ancoraDaScegliereSeTrasposto = true;
					
					//---------------------------------------------------------------------------
					
					
				alert('ATTENZIONE ! IL FOGLIO DI ATTIVITA CHE STAI PER ESTRARRE RIPORTA IL CARICO DI LAVORO DELLA STRUTTURA COMPLESSA SU CUI è STATO ESEGUITO L OPERAZIONE DI SALVATAGGIO-CHIUSURA DELLO STRUMENTO DI CALCOLO');	
				  var link = "GenerazioneExcel.do?command=GetExcel&tipo_richiesta=dpat&idAsl="+asl+"&anno="+anno+"&combo_area="+area+"&trasposto="+$("#selectTrasposto").val(); 
				  var result = window.open(link,'popupSelect',
					'height=400px,width=400px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
				  var text = document.createTextNode('GENERAZIONE EXCEL IN CORSO.');
					span = document.createElement('span');
					span.style.fontSize = "30px";
					span.style.fontWeight = "bold";
					span.style.color ="#ff0000";
					span.appendChild(text);
					var br = document.createElement("br");
					var text2 = document.createTextNode('Attendere la generazione del documento entro qualche secondo...');
					span2 = document.createElement('span');
					span2.style.fontSize = "20px";
					span2.style.fontStyle = "italic";
					span2.style.color ="#000000";
					span2.appendChild(text2);
					result.document.body.appendChild(span);
					result.document.body.appendChild(br);
					result.document.body.appendChild(span2);
					result.focus();  
					
				}
			}
			else
			{
					window.location="Dpat.do?command=Home&idAsl="+asl+"&anno="+anno+"&combo_area="+area;
					
			}
			
			
		}
	
}
</script>
<br><br>
<br><br>
<br><br>


<div id ="congelaStruttureReportistica">
<form method="post" id = "reportistica" action="DpatSDC.do?command=CongelaStruttureReportistica">
<table>

<tr class="containerBody">
			    	<td  class="formLabel">
			    		SELEZIONARE L'ANNO
						<select id="ANNO" onchange="getAreaStruttureComplesse()">
							<% if (anniList.size()>0){
									for (DpatIstanza ist : (ArrayList<DpatIstanza>)anniList){
										%>
										<option value="<%=ist.getAnno()%>"><%=ist.getAnno()%></option>
								<%  }
							} %>
						</select>
						
				
		
			    	</td>
			    </tr>
</table>
	</form>
	
	
		</div>
		
		
				<input type="button" value="Esporta Modello 5 - Attribuzione competenze PER TUTTE LE STRUTTURE"
		onClick="scaricaExcelMod5Totale()" style="background-color:#FF4D00; font-weight: bold;"/>
		
		<script>
		function scaricaExcelMod5Totale(){
				var idAsl = document.getElementById("ASL").value;
				var anno = document.getElementById("ANNO").value;
				
				if (idAsl=="-1" || anno == ""){
					alert('Selezionare ASL ed ANNO');
					return false;
					}
				alert('Il report impiegherà qualche minuto ad essere generato.');
		
				var result=
				window.open('Dpat.do?command=DpatGeneraXlsModifyGeneraleCompetenze&combo_area=-999&idAsl='+idAsl+'&anno='+anno);
				var text = document.createTextNode('GENERAZIONE EXCEL IN CORSO.');
				span = document.createElement('span');
				span.style.fontSize = "30px";
				span.style.fontWeight = "bold";
				span.style.color ="#ff0000";
				span.appendChild(text);
				var br = document.createElement("br");
				var text2 = document.createTextNode('Attendere la generazione del documento entro qualche minuto...');
				span2 = document.createElement('span');
				span2.style.fontSize = "20px";
				span2.style.fontStyle = "italic";
				span2.style.color ="#000000";
				span2.appendChild(text2);
				result.document.body.appendChild(span);
				result.document.body.appendChild(br);
				result.document.body.appendChild(span2);
				result.focus();
		}
		</script>
<%-- <% } %> --%>