<script>

function apriMessaggiImportanti()
{	
		 $( "#dialogMessaggi").dialog('open');
}

function closeDialogMessaggi(){
	  $('#dialogMessaggi').dialog('close');
}

$(function () {
	 
	 $( "#dialogMessaggi" ).dialog({
	    	autoOpen: true,
	        resizable: false,
	        closeOnEscape: false,
	       	title:"MESSAGGIO IMPORTANTE",
	        width:700,
	        height:'auto', 
	        position: 'center',
	        draggable: false,
	        modal: true,
	       show: {
	            effect: "bounce",
	            duration: 1000 
	        },
	        hide: {
	            effect: "drop",
	            duration: 1000
	        }
	    }).prev(".ui-dialog-titlebar").css("background","#FF9999");
});         

</script>

<!--  spostare prima della dialog se dà errore -->
<script>$('#dialogMessaggi').dialog('open');</script>  

<div id = "dialogMessaggi">
<center>

<font color="red">Attenzione. Sono presenti i seguenti messaggi non letti: </font><br/>
</center>

<%for (int i =0; i<5;i++){ %>
<b><%=i+1 %>. </b> Messaggio importante <%=i+1 %> <br/>
<%} %>

<center>
<input type="button" value="OK" onClick="closeDialogMessaggi()"/>
</center>
</div>

  
<input id="btnMessaggi" type="button" onClick="apriMessaggiImportanti()" value="Controlla Messaggi Importanti"/>

