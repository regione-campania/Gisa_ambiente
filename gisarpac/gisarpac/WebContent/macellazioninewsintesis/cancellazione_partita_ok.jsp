<jsp:useBean id="Partita" class="org.aspcfs.modules.macellazioninewsintesis.base.Partita" scope="request" />

<script>function reloadPadre(){
	window.parent.opener.location.href = "MacellazioniNewSintesis.do?command=List&altId=<%=Partita.getId_macello()%>&tipo=2";
	window.close();
}</script>




<br/>
<h4>Cancellazione della partita <%=Partita.getCd_partita() %> eseguita con successo.</h4>
<br/><br/>
<input type="button" value="chiudi" onClick="reloadPadre()"/>