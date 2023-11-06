

<%@page import="org.aspcfs.utils.web.CustomLookupElement"%>
<%@page import="java.util.ArrayList"%><jsp:useBean id="TipoCampione_istologico" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoCampione_sierologico" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="MatriciCanili" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="CU" class="org.aspcfs.modules.vigilanza.base.Ticket" scope="request"/>
<jsp:useBean id="ListaMc" class="org.aspcfs.utils.web.CustomLookupList" scope="request"/>
<jsp:useBean id="Motivazione" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="PianiMonitoraggio" class="org.aspcfs.utils.web.LookupList" scope="request"/>

<%-- lookup per la gestione dei campi previsti per piano pnaa con matrice mangimi --%>

<jsp:useBean id="ListaSpecie" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ListaProdotti" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="CategorieBovine" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="CategorieBufaline" class="org.aspcfs.utils.web.LookupList" scope="request"/>


<script type="text/javascript" src="dwr/interface/ServiziRestJson.js"> </script>
<script type="text/javascript" src="dwr/engine.js"></script>
<script type="text/javascript" src="dwr/util.js"></script>


<!-- JQUERY UI PER FINESTRE DI CONFERMA  -->


<!-- RELATIVO AL NUOVO CALENDARIO CON MESE E ANNO FACILMENTE MODIFICABILI -->
<SCRIPT LANGUAGE="JavaScript" SRC="javascript/CalendarPopup.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="javascript/common.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">document.write(getCalendarStyles());</SCRIPT>
<SCRIPT LANGUAGE="JavaScript" ID="js19">
	var cal19 = new CalendarPopup();
	cal19.showYearNavigation();
	cal19.showYearNavigationInput();
	cal19.showNavigationDropdowns();
</SCRIPT>

<script language="JavaScript">

function chiudiDialog(){
	$("#dialog2").dialog("close");
}
function openTree(campoid1,campoid2,table,id,idPadre,livello,multiplo,divPath,idRiga)
{

	window.open('Tree.do?command=DettaglioTree&multiplo='+multiplo+'&divPath='+divPath+'&idRiga='+idRiga+'&campoId1='+campoid1+'&campoId2='+campoid2+'&nomeTabella='+table+'&campoId='+id+'&campoPadre='+idPadre+'&campoDesc=nome&campoLivello=livello&campoEnabled=nuova_gestione&sel=true');

}

function openTreeAnaliti()
{

	window.open('Tree.do?command=DettaglioTree&nomeTabella=analiti&campoId=analiti_id&campoPadre=id_padre&campoDesc=nome&campoLivello=livello&campoEnabled=nuova_gestione&sel=true');

}
function disabilitaAbilitaBottoneInserimentoCampione(){
	if(document.getElementById("checkMatriciCanili").checked == true){
		document.getElementById('bottoneInserimentoCampioneSu').disabled = true;
		document.getElementById('bottoneInserimentoCampioneGiu').disabled = true;
	}
	else{
		document.getElementById('bottoneInserimentoCampioneSu').disabled = false;
		document.getElementById('bottoneInserimentoCampioneGiu').disabled = false;
	}
	
}

function verificaMicrochip(){

	var mc = trim(document.getElementById('microchipMatriciCanili').value);
	if( mc == '' ){
		alert('Inserire il Microchip!');
		return;
	}
	var idCanile = document.getElementById('orgIdC').value;

	ServiziRestJson.getInfoCaneCanile(mc,idCanile,verificaMicrochipReturn );
	
}


function verificaMicrochipReturn(ret){

	if(document.getElementById('noteMatriciCanili')){
		document.addticket.noteMatriciCanili.value = ret;
	}
	
}



function trim(str){
    return str.replace(/^\s+|\s+$/g,"");
} 

function abilitaMatriciCanili()
{
	checkMatriciCanili = document.getElementById("checkMatriciCanili");
    //sel2 = document.getElementById("lookupVegetale");
    if(checkMatriciCanili.checked==true)
    { 
    document.getElementById("matriciCaniliSelect").style.display="block";
    document.getElementById("noteMatriciCanili").style.display="block";
    document.getElementById("mcMatriciCanili").style.display="block";

    disabilitaCompostiVegetale();
	disabilitaCompostiAnimale();
    disabilitaComposti();
    disabilitaAcque();
   
 	disabilitaMaterialiAlimenti();
 	//disabilitaDolciumi();
 	//disabilitaGelati();
    disabilitaAdditivi();
    disabilitaAltriAlimenti();
    disabilitaBevande();
    disabilitaMangimi();
    }
    else
    { 
    	abilitaAltriAlimenti();
    	abilitaAcqueCheck();
    	abilitaCompostiVegetaleCheck()
    	abilitaAnimaliCheck();
        abilitaCompostiCheck();
		abilitaAdditivi();
    	abilitaMaterialiAlimenti();
    	abilitaBevandeCheck();
    	abilitaMangimiCheck();
    	//abilitaDolciumiCheck();
        //abilitaGelatiCheck();
        
    	document.getElementById("matriciCaniliSelect").style.display="none";
        document.getElementById("noteMatriciCanili").style.display="none";
        document.getElementById("mcMatriciCanili").style.display="none";

        document.getElementById("matriciCaniliSelect").value="-1"
        document.getElementById("noteMatriciCanili").value="";
        document.getElementById("microchipMatriciCanili").value="";
        
     //abilitaAnimaliCheck();
     //abilitaCompostiCheck();
          
    }  
}

function disabilitaMatriciCanili(){
	if (document.getElementById("checkMatriciCanili")!=null)
	document.getElementById("checkMatriciCanili").disabled=true;
	
}

function abilitaMatriciCaniliCheck(){
	if (document.getElementById("checkMatriciCanili")!=null)
	document.getElementById("checkMatriciCanili").disabled=false; 
	
}






// INIZIO DEFINIZIONE FUNZIONI PER POPUP MODALE PER PNAA

function popolaCampi(id_operatore, id_asl){
<%if (CU.getId()==-1){%>
return null;
<%}%> 

<% String idCU2 = request.getAttribute("idC").toString();%>
 
//	alert('ddd');
	var idPiano = -1 ;
	if ($("#idControlloUfficiale").val()=='N.D')
		idPiano = $("#quesiti_diagnostici_sigla").children("option:selected").val()
		else
			idPiano =  $("#motivazione_piano_campione").children("option:selected").val()
		 
			//Gestione dei campi per il PNAA
		if(id_asl >0 && (1==1 || id_asl == '204' || id_asl == '202')){
			if(id_operatore == '1' || id_operatore == '97' || id_operatore == '2' || id_operatore == '801' || id_operatore == '800'){
				
				$.ajax({
			        type: "GET",
			        url: "<%=request.getContextPath() %>/ServletForm?motivazione_piano_campione="+ idPiano+"&idControllo="+<%= idCU2%>,
			        async: false,
			        dataType: "json", 
			        error: function(XMLHttpRequest, status, errorThrown) {
			            alert("oh no!");
			            alert(status);
			        },
			        success: function (data, status) {
			        	var  toinsert = '';
			        	var html = '';
			        	
			        	var proprietario = "";
			        	if (data.length == 0){
			        		showInvia = false;
			        	}else{
			        		showInvia = true;
			        	}
					if (data.length > 0){
	    	        	toinsert = toinsert + '<table id="dati" cellpadding="2" cellspacing="0" border="0" width="100%"'+
		        		'class="details">'+
		        	'<tr>'+
		        		'<th colspan="2"><strong><dhv:label name="">Dati da inserire</dhv:label></strong>'+
		        		'</th>'
		        	'</tr>';
	}
			        	for (var i = 0; i < data.length; i++) {
				        	
			        	    var row = data[i];
			        	    		
			        	            var label = row['label'];
			        	            var labelLink = row['label_link'];
			        	   			var type = row['type'];
			        	   			var name = row['name'];
			        	   			var lookupname = row['lookup'];
			        	   			var value = row['value'];
			        	   			var javascript = row['javascript'];
			        	   			var controlli = row['controlli'];
			        	   			var label_controlli = row['label_data'];
			        	   			var size = row['size'];
			        	   			var obbligatorio = row['obbligatorio'];

								
			        	     	if (obbligatorio==true)
			        	     		obbligatorio = 'obbligatorio = "si" ';
			        	     	else
			        	     		obbligatorio = 'obbligatorio = "no" ';
			        	        		        	        	
			        	  if (type == 'data'){
			            	//  alert ('in if');
			        		  toinsert = toinsert + '<tr>  <td > <dhv:label name="">'+label+'</dhv:label></td> <td>';
			                  
			        		  if(row['obbligatorio']==false)
			        		  		toinsert = toinsert + '<input  readonly label="'+label+'" type="text" '+obbligatorio+javascript+' id="'+name+'" name="'+name+'" size="10" value="" nomecampo="'+name+'" tipocontrollo="'+controlli+'" labelcampo="'+label_controlli+'" />&nbsp;'
			        		  		else
			        		  			toinsert = toinsert + '<input  readonly label="'+label+'" type="text" '+obbligatorio+javascript+' id="'+name+'" name="'+name+'" size="10" value="" nomecampo="'+name+'" tipocontrollo="'+controlli+'" labelcampo="'+label_controlli+'" /><font color="red">*</font>&nbsp;'
								
			        		  			
				              		toinsert = toinsert + '<a href="#"" onClick="cal19.select2(document.forms[0].'+name+',\'anchor19\',\'dd/MM/yyyy\'); return false;" NAME="anchor19" ID="anchor19"><img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a></td></tr>';
								 

			              }else if (type == 'select'){

								 html = row['html'];
			            	  
			        		//  var toinsert = toinsert + '<tr><td><a href="javascript:popUp(\'Soggetto.do?command=Search&tipologiaSoggetto=1&popup=true\');">Ricerca soggetto</a></td></tr>'
			        		   toinsert = toinsert + '<tr><td > <dhv:label name="">'+label+'</dhv:label></td><td>'+html+'</td></tr>'
			            	  }else if (type == 'textarea'){
								toinsert = toinsert + '<tr><td nowrap>'+label+'</td><td><textarea rows="10" cols="10" name="'+name+'" id="'+name+'"></textarea></td></tr>';
				            	  
			            	  } else if (type == 'hidden'){

							
			          	  
			        		    toinsert = toinsert + '<input type = "'+type+'" label="'+label+'" name="'+name+'" id="'+name+'" '+obbligatorio+' value ="'+value+'"/>';
			          	  }else{
			            	 
			          		  if(row['obbligatorio']==false)
			        	  			var  toinsert = toinsert + '<tr><td nowrap>'+label+'</td><td><input label="'+label+'" type = "'+type+'" ' + obbligatorio+' name="'+name+'" id="'+name+'" value="'+value+'" maxlength="'+size+'" '+javascript+' /></td></tr>';
			        	  			else
			        	  				var  toinsert = toinsert + '<tr><td nowrap>'+label+'</td><td><input label="'+label+'" type = "'+type+'" ' + obbligatorio+' name="'+name+'" id="'+name+'" value="'+value+'" maxlength="'+size+'" '+javascript+' /><font color="red">*</font></td></tr>';
			        	  //	alert(toinsert);
			        	  }
			        	}
			        	var chiudi = '<div align="right"><input type="button" value="X" onClick="chiudiDialog()"/></div>';
			        	if (toinsert!=null && toinsert!='')
				          toinsert+=chiudi;
			          //  alert(toinsert);
			            $("#datireg").html("");
			            $("#datireghidden").html("");
			          
			            	$("#datireg").append(toinsert);
			            	$("#datireghidden").append(toinsert);
			            
			          
			        },
			        complete: function() {
			        	  if ($("#datireg").html() != '')
			        		 
			        	$("#dialog2").dialog("open");
			        	  
			        	  $("#datireghidden").find("input[name*='b14']").bind('change',function(){
			        			
			        			
			        			setDataScadenza('b14');
			        		});
			        	
			        }
			    });
				
			}//chiudo tipologia operatore
			
		}//chiudo asl	
		else {
			//NUOVA GESTIONE PER I PIANI PNR E PNBA DEL CAMPO SPECIE DA ASSOCIARE AI CAMPIONI
			$.ajax({
		        type: "GET",
		        url: "<%=request.getContextPath() %>/ServletForm?motivazione_piano_campione="+idPiano+"&idControllo="+<%= idCU2%>,
		        async: false,
		        dataType: "json",
		        error: function(XMLHttpRequest, status, errorThrown) {
		            alert("oh no!");
		            alert(status);
		        },
		        success: function (data, status) {
		        	var  toinsert = '';
		        	var html = '';
		        	
		        	var proprietario = "";
		        	if (data.length == 0){
		        		showInvia = false;
		        	}else{
		        		showInvia = true;
		        	}
				if (data.length > 0){
    	        	toinsert = toinsert + '<table id="dati" cellpadding="2" cellspacing="0" border="0" width="100%"'+
	        		'class="details">'+
	        	'<tr>'+
	        		'<th colspan="2"><strong><dhv:label name="">Dati da inserire</dhv:label></strong>'+
	        		'</th>'
	        	'</tr>';
}
		        	for (var i = 0; i < data.length; i++) {
			        	
		        	    var row = data[i];
		        	    		
		        	            var label = row['label'];
		        	            var labelLink = row['label_link'];
		        	   			var type = row['type'];
		        	   			var name = row['name'];
		        	   			var lookupname = row['lookup'];
		        	   			var value = row['value'];
		        	   			var javascript = row['javascript'];
		        	   			var controlli = row['controlli'];
		        	   			var label_controlli = row['label_data'];
		        	   			var size = row['size'];
		        	   			var obbligatorio = row['obbligatorio'];

							
		        	     	if (obbligatorio==true)
		        	     		obbligatorio = 'obbligatorio = "si" ';
		        	     	else
		        	     		obbligatorio = 'obbligatorio = "no" ';
		        	        		        	        	
		        	  if (type == 'data'){
		            	//  alert ('in if');
		        		  toinsert = toinsert + '<tr>  <td > <dhv:label name="">'+label+'</dhv:label></td> <td>';
		                  
		        		  if(row['obbligatorio']==false)
		        		  		toinsert = toinsert + '<input  readonly label="'+label+'" type="text" '+obbligatorio+javascript+' id="'+name+'" name="'+name+'" size="10" value="" nomecampo="'+name+'" tipocontrollo="'+controlli+'" labelcampo="'+label_controlli+'" />&nbsp;'
		        		  		else
		        		  			toinsert = toinsert + '<input  readonly label="'+label+'" type="text" '+obbligatorio+javascript+' id="'+name+'" name="'+name+'" size="10" value="" nomecampo="'+name+'" tipocontrollo="'+controlli+'" labelcampo="'+label_controlli+'" /><font color="red">*</font>&nbsp;'
							
		        		  			
			              		toinsert = toinsert + '<a href="#"" onClick="cal19.select2(document.forms[0].'+name+',\'anchor19\',\'dd/MM/yyyy\'); return false;" NAME="anchor19" ID="anchor19"><img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a></td></tr>';
							 

		              }else if (type == 'select'){

							 html = row['html'];
		            	  
		        		//  var toinsert = toinsert + '<tr><td><a href="javascript:popUp(\'Soggetto.do?command=Search&tipologiaSoggetto=1&popup=true\');">Ricerca soggetto</a></td></tr>'
		        		   toinsert = toinsert + '<tr><td > <dhv:label name="">'+label+'</dhv:label></td><td>'+html+'</td></tr>'
		            	  }else if (type == 'textarea'){
							toinsert = toinsert + '<tr><td nowrap>'+label+'</td><td><textarea rows="10" cols="10" name="'+name+'" id="'+name+'"></textarea></td></tr>';
			            	  
		            	  } else if (type == 'hidden'){

						
		          	  
		        		    toinsert = toinsert + '<input type = "'+type+'" label="'+label+'" name="'+name+'" id="'+name+'" '+obbligatorio+' value ="'+value+'"/>';
		          	  }else{
		            	 
		          		  if(row['obbligatorio']==false)
		        	  			var  toinsert = toinsert + '<tr><td nowrap>'+label+'</td><td><input label="'+label+'" type = "'+type+'" ' + obbligatorio+' name="'+name+'" id="'+name+'" value="'+value+'" maxlength="'+size+'" '+javascript+' /></td></tr>';
		        	  			else
		        	  				var  toinsert = toinsert + '<tr><td nowrap>'+label+'</td><td><input label="'+label+'" type = "'+type+'" ' + obbligatorio+' name="'+name+'" id="'+name+'" value="'+value+'" maxlength="'+size+'" '+javascript+' /><font color="red">*</font></td></tr>';
		        	  //	alert(toinsert);
		        	  }
		        	}

		          //  alert(toinsert);
		         		var chiudi = '<div align="right"><input type="button" value="X" onClick="chiudiDialog()"/></div>';
		         		if (toinsert!=null && toinsert!='')
					          toinsert+=chiudi;
		            $("#datireg").html("");
		            $("#datireghidden").html("");
		          
		            	$("#datireg").append(toinsert);
		            	$("#datireghidden").append(toinsert);
		            
		          
		        },
		        complete: function() {
		        	  if ($("#datireg").html() != '')
		        		 
		        	$("#dialog2").dialog("open");
		        	  
		        	  $("#datireghidden").find("input[name*='b14']").bind('change',function(){
		        			
		        			
		        			setDataScadenza('b14');
		        		});
		        	
		        }
		    });
			
			
		}
			
		
	}


function setValueCircuito(field)
{
	opt = field.options;
	for(i=0;i<opt.length;i++)
	{
		if (opt[i].selected)
		{
			
			
				opt[i].value=opt[i].text;
				
		}
	}

	
}

function setValuepadded3 (field,idsel)
		{
	opt = field.options;
	for(i=0;i<opt.length;i++)
	{
		if (opt[i].selected)
		{
			
			if (opt[i].value.length==1)
				opt[i].value='00'+idsel;
				else
					if(opt[i].value.length==2)
					opt[i].value='0'+idsel;
		}
	}

	}

function setValueMatrice (field,idsel)
{
	
	$("#datireg").find('select')
    .each(function() {
        $("#datireghidden").find("select[name*='"+$(this).attr('name')+"']").val($(this).val());
        
    });	
opt = field.options;
for(i=0;i<opt.length;i++)
{
	if (opt[i].selected)
	{
		if (opt[i].value.length==1)
		opt[i].value='m'+idsel;
	}
}

}

function showTesto(val)
{
	
	if (val=='m1')
	{
		document.getElementById("materia_prima").style.display="";
		$("#datireg").find("input[id*='materia_prima']").attr("style","display:block");
	}
	else
		{
		$("#datireg").find("input[id*='materia_prima']").attr("style","display:none");
		
		}
	
	}


	
	function setDataScadenza (name)
	{
		
		$("#datireg").find("input[id*='"+name+"']").val($("#datireghidden").find("input[id*='"+name+"']").val());
	}

	checkform = true ;
	msg = 'Controllare di aver compilato i seguenti campi \n';
	function checkMatrice(valmatrice,valcodice)
	{
		
		if(valmatrice=='m1' && valcodice =='')
			{
			checkform = false ;
			msg+='- Codice Matrice \n';
			}
		
	}
function checkFormDialog()
{
		checkform = true ;
		msg = 'Controllare di aver compilato i seguenti campi \n';
		setDataScadenza ('b14');
		
		$("#datireg").find('select')
	    .each(function() {
	    	
	    	$("#datireghidden").find("select[name*='"+$(this).attr('name')+"'] option").remove();
	    	
	    	
	    	
	    	var name = $(this).attr('name');
	    
	    	$("#datireg").find("select[name*='"+name+"'] :selected").each(
	    	function(i, selectedElement)
	    	{
	    		
	    		$("#datireghidden").find("select[name*='"+name+"']").append($('<option>',{
	                value:$(selectedElement).val(),
	                text:$(selectedElement).val(),
	                selected : true
	        }));
	    		
	    		
	    		if (($("#datireghidden").find("select[name*='"+name+"']").val() =='-1' || $("#datireghidden").find("select[name*='"+name+"']").val() =='--SELEZIONA--') && $("#datireghidden").find("select[name*='"+name+"']").attr("obbligatorio")=='si')
	    		{
	            	checkform = false ;
	            	msg+='- '+$("#datireghidden").find("select[name*='"+name+"']").attr("label")+'\n';
	            	}
	    	}
	    	);
	    	
	    	
	    
	    	
	        //$("#datireghidden").find("select[name*='"+$(this).attr('name')+"']").val($(this).val());
	        
	    });
		
	$("#datireg").find('input')
    .each(function() {
        $("#datireghidden").find("input[name*='"+$(this).attr('name')+"']").val($(this).val());
        
        
        if ($("#datireghidden").find("input[name*='"+$(this).attr('name')+"']").attr('name')=='materia_prima')
        	{
        	checkMatrice($("#datireghidden").find("select[name*='b1']").val(),$("#datireghidden").find("input[name*='"+$(this).attr('name')+"']").val())
        	}
        else
        if ($("#datireghidden").find("input[name*='"+$(this).attr('name')+"']").val()=='' && $("#datireghidden").find("input[name*='"+$(this).attr('name')+"']").attr('obbligatorio')=='si')
        	{
        	checkform = false ;
        	msg+='- '+$("#datireghidden").find("input[name*='"+$(this).attr('name')+"']").attr("label")+'\n';
        	}
        	
    });
	
	$("#datireg").find('radio')
    .each(function() {
        $("#datireghidden").find("radio[name*='"+$(this).attr('name')+"']").val($(this).val());
        
    });
	

	
	
	
	if(checkform==true)
	$("#dialog2").dialog("close");
	else
		{alert(msg);
		}
	
}




$(function() {
	var Return;
	$( "#dialog2" ).dialog({
    	autoOpen: false,
        resizable: false,
        closeOnEscape: false,
        modal: true,
        width:850,
        height:700,
        draggable: true,
        
       
        buttons: {
            "Salva": function() {
            	
            	checkFormDialog();
                return true;
            }
            
        }
    });
});

//FINE DEFINIZIONE FUNZIONI PER POPUP MODALE PER PNAA







































//FINESTRA DI CONFERMA SI/NO

$(function() {
		var Return;
        $( "#dialog" ).dialog({
        	autoOpen: false,
            resizable: false,
            closeOnEscape: false,
            width:400,
            height:150,
            draggable: false,
            modal: true,
            buttons: {
                "Si": function() {
        			if(checkForm(document.addticket)){
        				setTimestampStartRichiesta();
        				document.addticket.submit();
        			}
                    $( this ).dialog( "close" );
                    return true;
                },
                "No": function() {
                    $( this ).dialog( "close" );
                    return false
                }
            }
        });
    });
    
    

</script>

<script>
function setVerbale(radio){
	
	if(radio=="Genera"){ 
		document.getElementById("locationRadio2").checked=false;
		document.getElementById("location").value="AUTOMATICO";
//		document.getElementById("location").disabled="disabled";
		document.getElementById("location").readOnly=true;
	}

	if(radio=="Inserisci"){ 
		document.getElementById("locationRadio1").checked=false;
//		document.getElementById("location").disabled="";
		document.getElementById("location").readOnly=false;
		document.getElementById("location").value="";
	}
}

$(document).ready(function () {
	$(".save").click(function() {
		if (ret == true)
			$("#dialog").dialog("open");
		return false;
	});
});

function controllaAnaliti(){
	/*var status=-1;
	var i = 1;
	var size = document.getElementById("size").value;
	var analita="";
	var radio = document.getElementById("locationRadio1").checked;
	var tipologia = document.getElementById('tipologia').value;
	if (radio==true){
		for (i=1; i<=size; i++){
			analita=document.getElementById("pathAnaliti_"+i).value;
			if (analita.indexOf("BATTERIOLOGICO") !== -1){
				status=1;
			}
			if (analita.indexOf("CHIMICO") !== -1){
				status=1;
			}		
		}
		if (status==-1 && tipologia!= '201' && tipologia != '211') {
			alert("Attenzione la generazione automatica del Numero Verbale � prevista solo per analisi di tipo Batteriologico o Chimico.");
		}
		else {
			$(document).ready(function () {
				$(".save").click(function() {
					$("#dialog").dialog("open");
					return false;
				});
			});
		}
	}
	else {
		$(document).ready(function () {
			$(".save").click(function() {
				$("#dialog").dialog("open");
				return false;			
			});
		});
	}*/
	
	//DWR
	var radio = document.getElementById("locationRadio1").checked;
	if(radio != null && radio == false){
		var numVerbale = document.getElementById('location').value;
		var id_asl = document.getElementById('siteId').value;
		fixNumeroVerbale(numVerbale);
		controlloEsistenzaNumVerbale(numVerbale, id_asl);	
	}
	else {
		ret = true ;
		
	}
}

function fixNumeroVerbale(numero){
	
	var numero2 = numero.replace(/ /g, "");
	numero2 = numero2.replace(/\t/g, '');
	document.getElementById('location').value = numero2;
	if (numero!=numero2)
		document.getElementById("location").style.borderColor="red";
	else
		document.getElementById("location").style.borderColor="#EBE9ED";
}

function controlloEsistenzaNumVerbale(numVerbale, id_asl)
{
	 dwr.util.useLoadingImage('images/ajax-loader.gif');
	   PopolaCombo.controlloEsistenzaNumVerbale(numVerbale, id_asl,{callback:gestisciRispostaEsistenzaNumVerbaleCallBack,async:false});
	   
}


var ret =true ;
function gestisciRispostaEsistenzaNumVerbaleCallBack(returnValue)
{
	if(returnValue == 'true'){
			alert('Attenzione! Il numero verbale inserito manualmente risulta associato ad un altro campione.');
			ret = false;
			
	} 
		else { 
			ret = true;
			//$(".save").click();
	}	
	   
}

	
</script>


<div id="dialog" title="Conferma Inserimento">
    <p>Attenzione! Controlla bene tutti i dati inseriti perch� non potrai pi� modificarli. Vuoi concludere l'inserimento?</p>
</div>
<font color="red"></font> <%= showError(request, "locationError") %>

<center>
<div id="disabledImageZone" style="visibility: hidden;"><b>Verifica Esistenza Numero Verbale</b><br><img id="imageZone" src="" name="imageZone" /></div>
</center>
<tr>
      <td nowrap class="formLabel">
        <dhv:label name="stabilimenti.site">ASL</dhv:label>
      </td>
      <td>
 
 		<%if (CU.getSiteId()>0 ){ %>
       <%=SiteIdList.getSelectedValue(CU.getSiteId())%>
          <input type="hidden" id ="siteId" name="siteId" value="<%=CU.getSiteId()%>" >
          <input type="hidden" name="tipologia" id="tipologia" value="<%=OrgDetails.getTipologia()%>" >
     <%}
 		else
 		{
 			%>
 			<%=SiteIdList.getSelectedValue(CU.getSiteId())%>
          <input type="hidden" id="siteId" name="siteId" value="<%=CU.getSiteId()%>" >
           <input type="hidden" name="tipologia" id="tipologia" value="<%=OrgDetails.getTipologia()%>" >
 			<%
 			
 		}
 		%>
      </td>
    </tr>

  
<!--	<% if (!"true".equals(request.getParameter("contactSet"))) { %>-->
  <tr>
    <td class="formLabel">
      <dhv:label name="sanzioni.richiedente">Impresa</dhv:label>
    </td>
   
     
      <td>
        <%= toHtml(OrgDetails.getName()) %>
        <input type="hidden" name="orgId" value="<%=OrgDetails.getOrgId()%>">
        <input type="hidden" name="orgSiteId" id="orgSiteId" value="<%=  OrgDetails.getSiteId() %>" />
      </td>
    
  </tr>
  
<!--  <% }else{ %>-->
<!--    <input type="hidden" name="orgSiteId" id="orgSiteId" value="<%=  TicketDetails.getId() > 0 ? TicketDetails.getOrgSiteId() : User.getSiteId()%>" />-->
<!--    <input type="hidden" name="orgId" value="<%= toHtmlValue(request.getParameter("orgId")) %>">-->
<!--    <input type="hidden" name="contactId" value="<%= request.getParameter("contactId") %>">-->
<!--  <% } %>-->
  

 <% 
  String idCU = "" ;
  if(request.getAttribute("idControllo") !=null)
  {
	  idCU = request.getAttribute("idControllo").toString();
   } 
	 
  else {
	  idCU = "N.D";
  }
  %>

  
  <tr class="containerBody">
    <td valign="top" class="formLabel">
      <dhv:label name="">Identificativo C.U.</dhv:label>
    </td>
    <td>
      <%= idCU %>
      <input type="hidden" name="idControlloUfficiale" id="idControlloUfficiale" value="<%= idCU%>"/>
      <input type="hidden" name="idC" id="idC" value="<%= (String)request.getParameter("idC") %>"/>
    </td>
  </tr>
  
  
   <tr class="containerBody">
    <td valign="top" class="formLabel">
      <dhv:label name="">Motivazione</dhv:label>
    </td>
   
    <td>
     
     <table class="noborder">
     <tr>
     <td>
     <% if(!idCU.equals("N.D")) { %>
      <%Motivazione.setJsEvent("onchange=mostraUlteririNote('addticket')"); %>
      <%=Motivazione.getHtmlSelect("motivazione_campione",-1) %>    
   		 <FONT color="red">*</FONT>
     <% } else {
    	 Motivazione.setJsEvent("onchange=popolaCampi("+OrgDetails.getTipologia()+","+CU.getSiteId()+")");
    	 %>
     
     		<%= Motivazione.getHtmlSelect("quesiti_diagnostici_sigla","-1")%>
     		
     	<% } %>	
    </td><td id ="noteMotivazione" style="display: none">
    &nbsp;
    Note <br> <textarea rows="5" cols="30" name = "noteMotivazione"></textarea>
    
    </td>
    <td id ="pianomonitoraggio" style="display: none">
    
     <%
   PianiMonitoraggio.setJsEvent("onchange=popolaCampi("+OrgDetails.getTipologia()+","+CU.getSiteId()+")"); %>
    <%=PianiMonitoraggio.getHtmlSelectWithdisabled("motivazione_piano_campione","-1") %>
    
    </td>
    </tr>

</table>     
     
    </td>
  </tr>

<div id="dialog2" title="Campi Aggiuntivi" style="width: 610px;height: 400px;">
    <span id="datireg" class="datireg"> </span>
</div>

  

<%if(!idCU.equals("N.D")){ %>
 <tr class="containerBody">
    <td valign="top" class="formLabel">
      <dhv:label name="">Numero Verbale</dhv:label>
    </td>
    <td>
    	<input type="radio" id="locationRadio1" value="Genera" onClick="javascript:setVerbale('Genera');"/>Genera Verbale Prelievo<br><br>
    	<input type="radio" id="locationRadio2" value="Inserisci" onClick="javascript:setVerbale('Inserisci');"/>Inserisci Verbale Prelievo<br>
    	<input type="text" id="location" name="location" value="" onblur="fixNumeroVerbale(this.value)"/>
    	<font color="red"></font> <%= showError(request, "locationError") %>
    	<font color="red" siz='10px'>***SI PREGA DI NON INSERIRE IL CARATTERE � PER EVITARE PROBLEMI DI GENERAZIONE STAMPA BARCODE***</font>
    </td>
  </tr> 
 <%} %>
 
 

  <% 
  String dataC = "" ;
  if(request.getAttribute("dataC") !=null)
  {
	  dataC = request.getAttribute("dataC").toString();
	  } 
	  
	  %>

 
  <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="sanzionia.data_richiesta">Data Prelievo</dhv:label>
    </td>
    <td>
    	<input readonly type="text" id="assignedDate" name="assignedDate" size="10" />
		<a href="#" onClick="cal19.select(document.forms[0].assignedDate,'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19">
		<img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
		<% if(!idCU.equals("N.D")) { %>
        	<font color="red">*</font> <%= showAttribute(request, "assignedDateError") %>
        <% } %>	
       <font color="red"></font> <%= showAttribute(request, "assignedDateError") %>
	   <font color="red"></font> <%= showError(request, "assignedDateError") %>
    </td>
  </tr>
  
<% if(!idCU.equals("N.D")) { %>
 
	 <dhv:evaluate if="<%= ( request.getAttribute("isCanile") != null && request.getAttribute("isCanile").equals("si") ) || 
	 					   ( request.getAttribute("isCanePadronale") != null && "si".equals(request.getAttribute("isCanePadronale")) ) || 
	 					   ( request.getAttribute("isOperatoreCommerciale") != null && request.getAttribute("isOperatoreCommerciale").equals("si") ) %>">
		 <tr class="containerBody">
		        <td valign="top" class="formLabel">
		          <dhv:label name="">Cane</dhv:label>
		       </td>
		       <td>
		         <table class="noborder">
		         <tr>
		         
	
		     	   <!-- CASO VALIDO SOLO PER CANILI  -->
		     	     <dhv:evaluate if="<%= request.getAttribute("isCanile") != null && request.getAttribute("isCanile").equals("si") %>">
		     	   
		     	   <td  id="mcMatriciCanili">
		     	   		Microchip:<input type="text" id="microchipMatriciCanili" name="microchipMatriciCanili" maxlength="15" size="20" value="" ></input><font color="red">*</font>
		     	   		
		     	   		<br><br>
		     	   		Numero Box<input type="text" id="numBoxCanile" name="numBoxCanile" maxlength="15" size="20" ></input><font color="red">*</font>
		     	  </td>
		     	    </dhv:evaluate>
		     	    
		     	    <!-- CASO VALIDO SOLO PER OPERATORI COMMERCIALI  -->
		     	    <dhv:evaluate if="<%= request.getAttribute("isOperatoreCommerciale") != null && request.getAttribute("isOperatoreCommerciale").equals("si") %>">
		     	   
		     	   <td  id="mcMatriciCanili">
		     	   		Microchip:<input type="text" id="microchipMatriciCanili" name="microchipMatriciCanili" maxlength="15" size="20" value="" ></input><font color="red">*</font>
		     	  </td>
		     	    </dhv:evaluate>
		     	    
		     	       <!-- CASO VALIDO SOLO PER CANI PADRONALI  -->
		     	       
		     	   <dhv:evaluate if="<%= (request.getAttribute("isCanePadronale") != null )&& (request.getAttribute("isCanePadronale").equals("si") ) %>">
		     	   
		     	   <td  id="mcMatriciCanili">
		     	   		
		     	   		Microchip <select id="microchipMatriciCanili" name="microchipMatriciCanili">
		     	   		<%
		     	   		if (ListaMc !=null)
		     	   		{
		     	   			Iterator itMc = ListaMc.iterator();
		     	   		while (itMc.hasNext() ){
		     	   			
		     	   			CustomLookupElement el = (CustomLookupElement)itMc.next();
		     	   			%>
		     	   			
		     	   			<option value = "<%=el.getValue("mc") %>"><%=el.getValue("mc") %></option>
		     	   			<%
		     	   		}
		     	   		}
		     	   		%>
		     	   		</select>
		     	   		 </td>
		     	    </dhv:evaluate>
		     	  
		        </tr>
		        </table>
		       </td>  
		   </tr>
	   </dhv:evaluate>
  <% } %>
    <%@ include file="/campioni/matrici_analiti_tree.jsp" %>
    
        <!-- GESTIONE CAMPI AGGIUNTIVI IN CASP DI PIANO PNAA MATRICE OGM -->
    
    
    
  
  
  
<dhv:include name="organization.source" none="true">
   <tr>
      <td name="destinatarioCampione1" id="destinatarioCampione1" nowrap class="formLabel">
        <dhv:label name="">Laboratorio di Destinazione </dhv:label>
      </td>
    <td>
      <% if(!idCU.equals("N.D")) { %>
      	<%= DestinatarioCampione.getHtmlSelect("DestinatarioCampione",TicketDetails.getDestinatarioCampione()) %><font color="red">*</font>
      <% } else { %>
      	<%= "IZSM" %> 
      	<% } %>
    </td>
  </tr>
</dhv:include>

<!-- <tr class="containerBody"> -->
<!--     <td nowrap class="formLabel"> -->
<!--       <dhv:label name="">Data Accettazione</dhv:label> -->
<!--     </td> -->
<!--     <td> -->
<!--     	<input readonly type="text" id="dataAccettazione" name="dataAccettazione" size="10" /> -->
<!-- 		<a href="#" onClick="cal19.select(document.forms[0].dataAccettazione,'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19"> -->
<!-- 		<img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a> -->
<!--     </td> -->
<!--   </tr> -->
  

<!--   <tr class="containerBody"> -->
<!--     <td valign="top" class="formLabel"> -->
<!--       <dhv:label name="sanzionia.importo">Codice Accettazione</dhv:label> -->
<!--     </td> -->
<!--     <td> -->
<%--       <input type="text" name="cause" id="cause" value="<%= toHtmlValue(TicketDetails.getCause()) %>" size="20" maxlength="256" /> --%>
<!--     </td> -->
<!--   </tr> -->


     

  <tr>
    <td valign="top" class="formLabel">
      <dhv:label name="sanzioni.note">Note</dhv:label>
    </td>
    <td>
      <table border="0" cellspacing="0" cellpadding="0" class="empty">
        <tr>
          <td>
            <textarea name="problem" cols="55" rows="8"><%= toString(TicketDetails.getProblem()) %></textarea>
		<font color="red" siz='10px'>*** In caso di prelievi per AMR in tale campo specificare il numero lotto del campione ***</font>          
		</td>
          <td valign="top">
            <%= showAttribute(request, "problemError") %>
          </td>
        </tr>
      </table>
    </td>
	</tr>
	
	<div id="datireghidden" class="datireghidden" style="display:none" > </div>