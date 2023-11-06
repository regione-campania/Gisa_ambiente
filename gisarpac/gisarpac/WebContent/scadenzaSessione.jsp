<%
int secondiSessione= session.getMaxInactiveInterval();
int minutiSessione = secondiSessione/60;

//A volte viene recuperato 5 minuti all'inizio. Sovrascrivo per evitare ambiguita'
if (minutiSessione <=5)
	minutiSessione = 30;
%>

<script>

// CONFIGURAZIONE
var minutiAttesaGiallo = 10;
var secondiAttesaGiallo = minutiAttesaGiallo*60;
var millisecondiAttesaGiallo = secondiAttesaGiallo*1000;

var minutiAttesaRosso = <%=minutiSessione%>-5;
var secondiAttesaRosso = minutiAttesaRosso*60;
var millisecondiAttesaRosso = secondiAttesaRosso*1000;

var secondiRefresh = 60;
var durataSessione = <%=minutiSessione%>;

</script>

<label id="contatoreScadenza"><%=minutiSessione %></label>

<script>

//ALERT ALLARME ROSSO (5 minuti prima della fine sessione)
setTimeout(function(){
alert('Attenzione. Sono passati '+minutiAttesaRosso+' minuti dall\'apertura della pagina. LA SESSIONE STA PER SCADERE! Salvare le eventuali modifiche per evitare di perderle a causa dello scadere della sessione di lavoro tra circa '+ (durataSessione-minutiAttesaRosso)  +' minuti.'); }, millisecondiAttesaRosso);

//ALERT ALLARME GIALLO (10 minuti dopo inizio sessione)
setTimeout(function(){
	document.getElementById("scadenzaSessione").style.display="block"; alert('Attenzione. Sono passati '+minutiAttesaGiallo+' minuti dall\'apertura della pagina. Salvare le eventuali modifiche per evitare di perderle a causa dello scadere della sessione di lavoro tra circa '+ (durataSessione-minutiAttesaGiallo)  +' minuti.'); }, millisecondiAttesaGiallo);
	
//REFRESH SCADENZA
setInterval(function() {
	refreshScadenza();}, secondiRefresh*1000);

	function refreshScadenza(){
		var minutiRecuperati = Number(document.getElementById("contatoreScadenza").innerHTML);
		minutiRecuperati = minutiRecuperati-secondiRefresh/60;
		if (minutiRecuperati<0)
			minutiRecuperati=0;
		document.getElementById("contatoreScadenza").innerHTML=minutiRecuperati;
	}
</script>



