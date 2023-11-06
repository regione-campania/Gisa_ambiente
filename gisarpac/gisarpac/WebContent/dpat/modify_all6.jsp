<%@page import="java.util.Date"%>
<%@page import="org.aspcfs.modules.oia.base.OiaNodo"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>
<%@page import="org.aspcfs.modules.dpat.base.*"%>
<%@ page import="com.darkhorseventures.framework.actions.ActionContext"%>
<jsp:useBean id="dpat" class="org.aspcfs.modules.dpat.base.DpatAttribuzioneCompetenza" scope="request"/>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="edit" class="java.lang.String" scope="request"/>
<jsp:useBean id="anno" class="java.lang.String" scope="request"/>
<jsp:useBean id="idPadre" class="java.lang.String" scope="request"/>
<jsp:useBean id="idSDC" type="java.lang.Integer" scope="request"/>
<jsp:useBean id="ListaAsl" class="org.aspcfs.utils.web.LookupList" scope="request"/>


<script type="text/javascript" src="dwr/interface/PopolaCombo.js"> </script>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>

<iframe src="empty.html" name="server_commands" id="server_commands" style="visibility:hidden" height="0"></iframe>


<script>

</script>
<body onload="resizeGlobalItemsPane('hide')">
<%@ include file="../initPage.jsp"%>
<table class="trails" cellspacing="0">
		<tr>
			<td width="100%"><div align="left"><a href="Dpat.do">DPAT</a> &gt <a href="Dpat.do">Allegati DPAT</a> &gt MODELLO 5 ASL <%=ListaAsl.getSelectedValue(dpat.getIdAsl()) %>
			</div></td>	
		</tr>
	</table>

<head>
	<script type="text/javascript" src="javascript/jquery-2.0.0.min.js"></script>
	
	<link href="css/smart_wizard.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="javascript/jquery.smartWizard.js"></script>
	<link media="screen" rel="stylesheet" href="css/defaultTheme.css"></link>
	<script type="text/javascript" src="javascript/jquery.fixedheadertable.js"></script>
	
	
	<script type="text/javascript">
	//loadModalWindow();
	loadModalWindowCustom('<div style="color:red; font-size: 20px;">Attendere prego.... <br>(Se il browser dovesse visualizzare un messaggio di avviso secondo il quale lo script <br> sta impiegando troppo tempo,  cliccare su "continua"  e attendere il completamento)</div>');
	</script>
	
<style type="text/css">



   .table_sez td, .table_sez th {
        /* appearance */
        border: 1px solid #778899;
        
        /* size */
        /* padding: 5px; */
        }
        
        th.tooltipobsoleto, td.tooltipobsoleto {
                
                
        }
        
        td.tooltipobsoleto span, th.tooltipobsoleto span {
                position: absolute;
                width:140px;
                padding: 3px;                
                background: #000;
                color: #fff;
                text-align: center;
                visibility: hidden;
                border-radius: 5px;
                font-size: 8px;
        } 
                        
        td.tooltipobsoleto span:after {
                content: '';
                position: absolute;
                top: 100%;
                left: 50%;
                margin-left: -8px;
                width: 0; height: 0;
                border-top: 8px solid black;
                border-right: 8px solid transparent;
                border-left: 8px solid transparent;
        }
                        
td:hover.tooltipobsoleto span, th:hover.tooltipobsoleto span {
                visibility: visible;
                opacity: 0.8;
                z-index: 999;
        }
        

         
        
td:hover.tooltipobsoleto span, th:hover.tooltipobsoleto span {
                visibility: visible;
                opacity: 0.8;
                z-index: 999;
        }
        
        
         td{
         text-align:center; 
    vertical-align:middle;
        } 
        
        input[type="text"] { /* Stili per il campo di testo e per la textarea */
    background: #fff; /*Colore di sfondo */
    border: 0px solid #323232; /* Bordo */
    color: #000; /* Colore del testo */
    height: 20px; /* Altezza */
    line-height: 30px; /* Altezza di riga */
    width: 30px; /* Larghezza */
    padding: 0 5px; /* Padding */
    text-align: center;
        }
        
        
        
</style>
	
	
	
	
</head>


<script type="text/javascript">



  $(document).ready(function() {
      // Initialize Smart Wizard
      loadModalWindowUnlock();
      
     // $('#wizard').smartWizard();
     
     
      $('#wizard').smartWizard(    		  
     {
      divHeadPaddingLeft:  0,
      divBodyPaddingLeft:   0,
      fixedTypeNumber:  2
      			
      	    });
     
      
  }); 
  
</script>





	<% if (dpat.getElencoSezioni().size()>0){ %>
	<% if (dpat.isCompleto()==false || (dpat.getStrutturaAmbito()!=null && dpat.getStrutturaAmbito().getStato_all6()!=2)){ %>
	<p align="left">
		<dhv:permission name="dpat-edit">
			<input id="salva" disabled=true type="button" value="Salva Definitivo"  onclick="javascript : if (confirm('ATTENZIONE!!!Chiudere definitivamente il modello 5? se clicchi OK non sarà MAI PIU possibile modificarlo.Se invece prevedi di apportare ancora modifiche clicca su ANNULLA')){window.location='Dpat.do?command=SalvaDefinitivoCompetenze&combo_area=<%=(dpat.getStrutturaAmbito()!=null) ? dpat.getStrutturaAmbito().getId() : "-1"%>&id=<%=dpat.getId()%>&idAsl=<%=dpat.getIdAsl()%>&anno=<%=dpat.getAnno()%>'}">
		</dhv:permission>
	</p>
	<%} }%>
	
	
	<%
	if(dpat.getStrutturaAmbito()!=null && dpat.getStrutturaAmbito().getId()>0)
	{
	%>
	<input type="button" value="Esporta  Modello 5 - Attribuzione competenze"
		onClick="location.href='Dpat.do?command=DpatGeneraXlsModifyGeneraleCompetenze&combo_area=<%=dpat.getStrutturaAmbito().getId()%>&idAsl=<%=dpat.getStrutturaAmbito().getIdAsl()%>&anno=<%=dpat.getStrutturaAmbito().getAnno()%>'" 
		style="background-color:#FF4D00; font-weight: bold;"/>
		
<%} %>





<% if (dpat.getElencoSezioni().size()>0){ %>
<div id="wizard" class="swMain">
 
 
  	<%
  	for(int i=0;i< dpat.getElencoSezioni().size();i++){ 
  		DpatSezione sezione = dpat.getElencoSezioni().get(i);%>
		<div id="s_<%=sezione.getId()+"_"+ i%>" >
		
			<table border="1"  id = "table<%=i %>" class="table_sez">
			<thead>
			<tr bgcolor="<%=sezione.getBgColor()%>">
			<th rowspan="3" bgcolor="red">
			
			<%=("MODELLO 5 ATTRIBUZIONE COMPETENZA DEI PIANI DI MONITORAGGIO E ATTIVITA'".indexOf(' ', 30) > -1) ? "MODELLO 5 ATTRIBUZIONE COMPETENZA DEI PIANI DI MONITORAGGIO E ATTIVITA'".substring(0, "MODELLO 5 ATTRIBUZIONE COMPETENZA DEI PIANI DI MONITORAGGIO E ATTIVITA'".indexOf(' ', 30)) 
					  			+ " <font size=\"1\">[...]</font>" : "MODELLO 5 ATTRIBUZIONE COMPETENZA DEI PIANI DI MONITORAGGIO E ATTIVITA'"%>
					  			</th>
					<th colspan="30" ><%=sezione.getDescription() %></th>
			</tr>
				<tr bgcolor="<%=sezione.getBgColor()%>">
				
					
					<% for (int j=0;j<sezione.getElencoPiani().size();j++){ 
					 	 DpatPiano piano = sezione.getElencoPiani().get(j);
					 	 int numInd=0;
					 	 for (int app=0; app<piano.getElencoAttivita().size();app++){
					 	 	DpatAttivita att =piano.getElencoAttivita().get(app);
					 	 	numInd=numInd+(att.getElencoIndicatori().size());%>
					 	 <%} %>
					 	 <th style="font-weight: bolder;" id="p_<%=piano.getId()%>" colspan="<%=numInd%>" >
					 	 	<%=piano.getDescription()%>
					 	 </th>
					<% }%>
					
				</tr>
				<tr bgcolor="<%=sezione.getBgColor()%>" >
				<% for (int j=0;j<sezione.getElencoPiani().size();j++){
					DpatPiano currPiano  = sezione.getElencoPiani().get(j) ;
					for (int k=0; k<currPiano.getElencoAttivita().size(); k++){
					  DpatAttivita attivita =currPiano.getElencoAttivita().get(k);%>
					 <th class="tooltip" title="<%=attivita.getDescription()%>" style="font-weight: bolder;" id="a_<%=attivita.getId()%>" colspan="<%=attivita.getElencoIndicatori().size()%>">
					  <span></span> 	
					<%=(attivita.getDescription().indexOf(' ', 30) > -1) ? attivita.getDescription().substring(0, attivita.getDescription().indexOf(' ', 30)) 
					  			+ " <font size=\"1\">[...]</font>" : attivita.getDescription()%>
					  </th>
				<% 	}} %>
				</tr>
		 		<tr style ="background-color: rgb(221,217,195)">
		 		<th bgcolor="<%="yellow"%>"  >UU.OO.CC. <br> E UU.OO.SS.DD.</th> 
				<% for (int j=0;j<sezione.getElencoPiani().size();j++){
					DpatPiano piano = sezione.getElencoPiani().get(j) ;
					for (int k=0; k<piano.getElencoAttivita().size(); k++){
						DpatAttivita att =   piano.getElencoAttivita().get(k) ;
						String value = "a";
						int charValue = value.charAt(0);
					  for(int ind=0;ind<att.getElencoIndicatori().size();ind++){
					  	DpatIndicatore indicatore =att.getElencoIndicatori().get(ind);%>
					  	<th class= "tooltip" title="<%=(indicatore.getNote()!=null && !indicatore.getNote().equals("") )? indicatore.getNote()+"\n"+indicatore.getDescription() : indicatore.getDescription()%>" style="font-weight: bolder;" id="i_<%=indicatore.getId()%>" colspan="1">
					  	<% String next = String.valueOf( (char) (charValue + ind));%>
					  	
					  	<%= ( indicatore.getNote()!=null && !indicatore.getNote().equals("") && indicatore.getNote().length()>30) ? 
					  	indicatore.getNote().substring(0, 10) + " <font size=\"1\">[...]</font>" : ((indicatore.getNote()!=null && !indicatore.getNote().equals("")) ? indicatore.getNote() : "")%><br><br> 
					  	<span></span>
					  	<%=(indicatore.getDescription().length()>34 && indicatore.getDescription().indexOf(' ', 34) > -1) ? 
					  indicatore.getDescription().substring(0, indicatore.getDescription().indexOf(' ', 34)) + " <font size=\"1\">[...]</font>" : indicatore.getDescription()%></th>
				<% 	  }  %> 
					  
			<%	}} %>
				</tr>
				
				<tr style ="background-color: rgb(221,217,195)">
		 		<th bgcolor="<%="yellow"%>"  >UU.OO.CC. <br> E UU.OO.SS.DD.</th> 
				<% for (int j=0;j<sezione.getElencoPiani().size();j++){
					DpatPiano piano = sezione.getElencoPiani().get(j) ;
					for (int k=0; k<piano.getElencoAttivita().size(); k++){
						DpatAttivita att =   piano.getElencoAttivita().get(k) ;
						String value = "a";
						int charValue = value.charAt(0);
					  for(int ind=0;ind<att.getElencoIndicatori().size();ind++){
					  	DpatIndicatore indicatore =att.getElencoIndicatori().get(ind);%>
					  	<th class= "tooltip" title="<%=(indicatore.getNote()!=null && !indicatore.getNote().equals("") )? indicatore.getNote()+"\n"+indicatore.getDescription() : indicatore.getDescription()%>" style="font-weight: bolder;" id="i_<%=indicatore.getId()%>" colspan="1">
					  	<% String next = String.valueOf( (char) (charValue + ind));%>
					  	<%=indicatore.getAlias() %>
					  	</th>
				<% 	  }  %> 
					  
			<%	}} %>
				</tr>
				</thead>
				<tbody>
			<%
			
			for (int s=0;s<dpat.getElencoStrutture().size();s++) {
					String color="#FFFFFF";
					String color_tr="#FFFFFF";
					OiaNodo struttura = (OiaNodo)dpat.getElencoStrutture().get(s);
					if (struttura.getN_livello()==2) {color="#FFFF00";}
					else {color="#FFFFFF";}
					if (s%2 == 0)
						color_tr = "#fff";
					else 
						color_tr = "#C0C0C0";
					%>
					<tr bgcolor="<%=color_tr%>">
						<td class="tooltip" title="<%=struttura.getDescrizione_lunga() %>"   id="struttura_<%=struttura.getId()%>" >
							<span ></span>					
						<%=(struttura.getDescrizione_lunga().indexOf(' ', 30) > -1) ? 
								struttura.getDescrizione_lunga().substring(0, struttura.getDescrizione_lunga().indexOf(' ', 30)) + " <font size=\"1\">[...]</font>" : struttura.getDescrizione_lunga()%>
								
								
						</td>
					
					
					<%=sezione.getElencoPiani().size() %>
						
						<% for (int j=0;j<sezione.getElencoPiani().size();j++){
								DpatPiano p =sezione.getElencoPiani().get(j);
							for (int k=0; k<p.getElencoAttivita().size(); k++){ 
								DpatAttivita a = p.getElencoAttivita().get(k);
							 for(int ind=0;ind<a.getElencoIndicatori().size();ind++){
							 	DpatIndicatore in = a.getElencoIndicatori().get(ind);
							 	%>
							 	
					  	 
					  		 	<%
					  		 	if (struttura.getCompetenzeIndicatori().get(in.getId())!=null)
					  		 	{
					  		 		System.out.println("Modello 5 : "+in.getId() + " - "+ struttura.getCompetenzeIndicatori().get(in.getId()));
					  		 	}
					  		 	
					  		 	%>
							 	<td  align="center">
							 	<input type="text" 
							 	onclick="document.getElementById('salva').disabled=false;setValore(this,<%=struttura.getId() %>,<%=in.getId() %>,<%=dpat.getId() %>,<%=User.getUserId() %>)" readonly="readonly" 
							 	value="<%=(struttura.getCompetenzeIndicatori().get(in.getId())!= null && struttura.getCompetenzeIndicatori().get(in.getId())==Boolean.TRUE ) ? "X" : "" %>"
							 	id="struttura_<%=struttura.getId()%>_s_<%=sezione.getId()%>_p_<%=p.getId()%>_a_<%=a.getId()%>_i_<%=in.getId()%>"/>
							 	</td>						
						<% 	 } %>
					 			
						<%	 }} %>
						
					
					</tr>
				
			<% } %>
			
			</tbody>
			</table>   
		</div>	
   <% } %>



   
</div>
<%} else {%>
DATI DPAT NON PRESENTI
<%} %>

<script>
var stato=true;
function setValore(field,idStruttura, idIndicatore, idDpat,  userid){
	var idSDC = "<%=idSDC%>";
	
		if (field.value!= ''){
			field.value = '';
			PopolaCombo.aggiornaDpatCompetenzeStruttura( idStruttura, idIndicatore, idDpat, false, userid,function(){});
		} else {
			field.value = "X";
			PopolaCombo.aggiornaDpatCompetenzeStruttura( idStruttura, idIndicatore, idDpat, true, userid,function(){});	
		}
	
}

function checkStatoSDCCallback(value){
	stato=value;
}

function checkInt(id){
	flag=0;
	var n = document.getElementById(id).value;
	if (isNaN(n)){
		flag=1;
	} else if (n==null || n=="" ){
		flag=1;
	}else if(!Number.isInteger){
		flag=1;
	}	
	return flag;
}

</script>



</body>







