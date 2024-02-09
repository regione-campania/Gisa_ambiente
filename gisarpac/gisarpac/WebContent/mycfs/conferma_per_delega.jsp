<script>
$(function () {
    
	
	 
	 $( "#dialogDelega" ).dialog({
	    	autoOpen: true,
	        resizable: false,
	        closeOnEscape: false,
	       	title:"ATTENZIONE! DELEGA PRESENTE",
	        width:850,
	        height:400,
	        draggable: false,
	        modal: true,
	       
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


<div id = "dialogDelega">
<center>
<p>
Attenzione: la gestione dei tuoi dati apistici risulta attualmente in delega. Scegli cosa fare:
</p>
<input type="button" class="aniceBigButton" style="height:50px !important; width:350px !important;" value="Procedi e annulla la delega" onClick="location.href='ApicolturaAttivita.do?command=RevocaDelegaApicoltore';"/>  <br/><br/>
 <input type="button" class="aniceBigButton" style="height:50px !important; width:350px !important;" value=" Esci dal sistema e mantieni attiva la delega" onClick="location.href='Login.do?command=Logout'"/>
</center>

</div>