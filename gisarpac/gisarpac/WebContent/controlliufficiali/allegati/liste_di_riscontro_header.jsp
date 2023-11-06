<P text-align="center" style="text-align: center">
	<b>PROTEZIONE DEGLI ANIMALI NEGLI ALLEVAMENTI 
	
	<%if (nuova_gestione.equals("true") && numAllegato.equals("1")) {%>
	<br/> <b>ALTRE SPECIE: </b>	
	<% }%>
	<label class="layout"><%=specie%></label>
	<br/></b>
	
	<%if (nuova_gestione.equals("true") && numAllegato.equals("1")) {%>
	 <i>("ALTRE SPECIE": qualsiasi animale, inclusi pesci, rettili e anfibi, allevati o custoditi per la produzione di derrate alimentari, lana, pelli, pellicce o per altri scopi agricoli)</i>
	 <br/>	
	<% }%>
	
	   RISULTATI DEI CONTROLLI EFFETTUATI PRESSO LE AZIENDE
</P>
<BR>
<p style="">
 REGIONE <input type="text" class="layout" readonly value="CAMPANIA"/>
 ASL <input type="text" class="layout" readonly value="<%= Allevamento.getAsl()%>"/>
<br> 
EXTRAPIANO: <span class="NocheckedItem">SI&nbsp;&nbsp;</span>
<span class="NocheckedItem">NO&nbsp;&nbsp;</span>
DATA DEL CONTROLLO:<input type="text" class="layout" readonly value="<%= Allevamento.getGiornoReferto()+ " " + Allevamento.getMeseReferto() + " "+ Allevamento.getAnnoReferto()%>" /> 
</p>
