 
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="ListaPratiche" class="java.util.ArrayList" scope="request"/>

<%@ page import="org.aspcfs.modules.gestioneanagrafica.base.*" %>
<%@ page import="org.aspcfs.modules.gestioneanagrafica.actions.*" %>
  
  <%@ include file="../initPage.jsp" %>
  
  

<%-- Trails --%>
	<table class="trails" cellspacing="0">
	<tr>
		<td><a href="GestioneAnagraficaAction.do?command=ListaPraticheStabilimenti">PRATICHE SUAP 2.0</a> >
		<a href="GestioneAnagraficaAction.do?command=SearchFormPratica"> RICERCA PRATICA</a> > Risultato Ricerca </td>
	</tr>
	</table>
<%-- Trails --%>
<center>
<%if(ListaPratiche.size() != 0){ %>

<br>
	<h3>ELENCO PRATICHE AMMINISTRATIVE CORRISPONDENTI AI PARAMETRI DI RICERCA</h3>
<br>

<form id="ricercaPratica" name="ricercaPratica" class="form-horizontal" role="form" method="post" action="">

<input type="hidden" id="numero_pratica" name="numero_pratica" value="${numeroPratica}" />
<input type="hidden" id="comune_richiedente" name="comune_richiedente" value="${codComune}" />
<input type="hidden" id="data_richiesta" name="data_richiesta" value="${dataPec}" />
<input type="hidden" id="idTipologiaPratica" name="idTipologiaPratica" value="${tipoPratica}" />


<table width="100%" cellspacing="0" cellpadding="4" border="0" align="center">
	<tbody>
		<tr>
			<td valign="bottom" nowrap="" align="right">
				<font color="#666666"> Pagina ${NumeroPagina} di ${NumeroPratichePagine} </font>
		  		[
				<a href="#" onclick="pagina_precc()">
				   <font class="underline">Precedente</font>
				</a>
				|
				<a href="#" onclick="pagina_succ()">
					<font class="underline">Successivo</font>
				</a>
				]
				<a href="#" onclick="vai_a_pagina()">
		      		<img src="images/refresh.gif" border="0" align="absbottom"> 
		     	</a>
		   </td>
		</tr>
	</tbody>
</table>

<table class="table details" id="tabella_pratiche" style="border-collapse: collapse" border="1" width="100%" cellpadding="5"> 

<tr>
	<th style="text-align:center; width:15%;">
		<p>Numero pratica</p>
	</th>
	<th style="text-align:center; width:25%;">
		<p>Dati impresa e stabilimento</p>
	</th>
	<th style="text-align:center; width:10%;">
		<p>comune</p>
	</th>
	<th style="text-align:center">
		<p>data pec</p>
	</th>
	<th style="text-align:center">
		<p>tipo pratica</p>
	</th> 
	<th style="text-align:center; width:10%;">
		<p>Utente</p>
	</th> 
	<th style="text-align:center; width:10%;" ><p>ALLEGATI</p></th>
	<th style="text-align:center"></th>  
</tr>

<% for ( int i = 0; i<ListaPratiche.size(); i++) {
	
	Pratica p = (Pratica) ListaPratiche.get(i);
	String tipoPratica = "";
	if ( p.getSiteIdStab() == User.getSiteId() || User.getSiteId() == -1 ) {
		
	if (p.getIdTipologiaPratica() == GestioneAnagraficaAction.OP_NUOVO_STAB)
		tipoPratica="INSERIMENTO NUOVO STABILIMENTO"; 
	else if (p.getIdTipologiaPratica() == GestioneAnagraficaAction.OP_AMPLIAMENTO)
		tipoPratica="AMPLIAMENTO";
	else if (p.getIdTipologiaPratica() == GestioneAnagraficaAction.OP_CESSAZIONE)
		tipoPratica="CESSAZIONE";
	else if (p.getIdTipologiaPratica() == GestioneAnagraficaAction.OP_VARIAZIONE)
		tipoPratica="VARIAZIONE TITOLARITA";
	else if (p.getIdTipologiaPratica() == GestioneAnagraficaAction.OP_SOSPENSIONE)
		tipoPratica="SOSPENSIONE";
	else if (p.getIdTipologiaPratica() == GestioneAnagraficaAction.OP_MODIFICA_STATO_LUOGHI)
		tipoPratica="MODIFICA STATO DEI LUOGHI";
	else if (p.getIdTipologiaPratica() == GestioneAnagraficaAction.OP_MODIFICA_TRASFERIMENTO_SEDE)
		tipoPratica="TRASFERIMENTO SEDE";
	%>
<tr class="row<%=i%2%>">
<td align="center"><p><%=p.getNumeroPratica() %></p></td>

<td align="center">
	
	 <%if((p.getIdTipologiaPratica() != 1 || p.getStatoPratica() == 1) && p.getAltId() != -1){ %> 
			<b><%=p.getRagioneSociale() %></b>
			<br>P. IVA/cod. fiscale impresa: <%=p.getPartitaIva() %>
			<br>Num. Reg.: <%=p.getNumeroRegistrazione() %>
			<br>Indirizzo: <%=p.getIndirizzo() %>
	<%} %>
</td>

<td align="center"><%=p.getComuneRichiedente() %></td>
<td align="center"><%=toDateasString(p.getDataOperazione()) %></td>
<td align="center"><%=tipoPratica %></td>
<td align="center"> <dhv:username id="<%= p.getIdUtente() %>" /></td> 
<td align="center">
	<%String desc_operatore = "";
	if(p.getAltId() != -1){
		desc_operatore = "<hr>DATI IMPRESA E STABILIMENTO<br>" +
				  "<br><b>RAGIONE SOCIALE</b>: " + p.getRagioneSociale() + 
				  "<br><b>PARTITA IVA/CODICE FISCALE IMPRESA</b>: " + p.getPartitaIva() + 
				  "<br><b>NUMERO REGISTRAZIONE</b>: " + p.getNumeroRegistrazione() +
				  "<br><b>INDIRIZZO</b>: " + p.getIndirizzo();
	}
	%>
	<a style="text-decoration:none" 
	href='GestioneAllegatiGins.do?command=ListaAllegati&numeroPratica=<%=p.getNumeroPratica()%>&desc_operatore=<%=desc_operatore.replaceAll("'", " ")%>&alt_id=<%=p.getAltId()%>&stab_id=<%=p.getIdStabilimento()%>&idComunePratica=<%=p.getIdComuneRichiedente()%>'>
		<img src="gestione_documenti/images/archivio_icon.png" width="35" title="visualizza allegati"/>
	</a>&nbsp;&nbsp;

</td>
<td align="center">
	<%if(p.getStatoPratica() == 0 ){ %>
		
		<a style="text-decoration:none" href="#" onclick="if(confirm('passare alla gestione scheda?')==true)
				{
						loadModalWindowCustom('Attendere Prego...');
						window.location.href='GestioneAnagraficaAction.do?command=CompletaPratica&stabId=<%=p.getIdStabilimento()%>&altId=<%=p.getAltId()%>&numeroPratica=<%=p.getNumeroPratica()%>&tipoPratica=<%=p.getIdTipologiaPratica()%>&dataPratica=<%=toDateasString(p.getDataOperazione())%>&comunePratica=<%=p.getIdComuneRichiedente()%>';		
				}">
		gestisci scheda
		</a>
	<%} else if (p.getStatoPratica() == 1) { %>
		<a style="text-decoration:none" href="#" onclick="if(confirm('visualizzare scheda?')==true)
				{
						loadModalWindowCustom('Attendere Prego...');
						window.location.href='GestioneAnagraficaAction.do?command=Details&stabId=<%=p.getIdStabilimento()%>';		
				}">
		visualizza scheda
		</a>
	<%} %>
	
</td>
</tr>

<%}
	} %>
</table>
<br>
<% } else { %>
	<h3>NESSUN RISULTATO TROVATO</h3><br> <a href="GestioneAnagraficaAction.do?command=SearchFormPratica">torna alla ricerca</a>
<%} %>
</center>

<%if(ListaPratiche.size() != 0){ %>
<center>
<div class="row1">
	<input type="hidden" id="sizepages" value="${SizePagine}"/>
	<input type="hidden" id="npages" value="${NumeroPratichePagine}" />
	[
	<a href="#" onclick="pagina_precc()">
	   <font class="underline">Precedente</font>
	</a>
	|
	<a href="#" onclick="pagina_succ()">
	<font class="underline">Successivo</font>
	</a>
	]
	<font color="#666666">
		Pagina
		<input type="text" name="numero_pagina" id="numero_pagina" value="${NumeroPagina}" size="3" style="text-align:center"  autocomplete="off"/>
		di ${NumeroPratichePagine}, Elementi per pagina:
		<select name="size_pagina" id="size_pagina" onchange="vai_a_pagina()">
			<option value="6">6</option>
			<option value="10">10</option>
			<option value="12">12</option>
			<option value="20">20</option>
			<option value="30">30</option>
			<option value="50">50</option>
		</select>
		<input type="button" value="vai" onclick="vai_a_pagina()"/>
	</font>
</div>
</center>

<br><br>
<%} %>
</form>

<script>

document.getElementById('size_pagina').value = document.getElementById('sizepages').value;


function pagina_succ(){
	var pagina = parseInt(document.getElementById('numero_pagina').value) + 1;
	document.getElementById('numero_pagina').value = '' + pagina;
	var totpagine = parseInt(document.getElementById('npages').value);
	if(pagina < (totpagine + 1)){
		loadModalWindowCustom('Attendere Prego...');
		document.getElementById('ricercaPratica').action = "GestioneAnagraficaAction.do?command=SearchPraticheAmministrative";
		document.getElementById('ricercaPratica').submit(); 
	} else {
		document.getElementById('numero_pagina').value = '' + totpagine;
		return false;
	}
	
}

function pagina_precc(){
	var pagina = parseInt(document.getElementById('numero_pagina').value) - 1;
	document.getElementById('numero_pagina').value = '' + pagina;
	if (pagina > 0){
		loadModalWindowCustom('Attendere Prego...');
		document.getElementById('ricercaPratica').action = "GestioneAnagraficaAction.do?command=SearchPraticheAmministrative";
		document.getElementById('ricercaPratica').submit(); 
	} else {
		document.getElementById('numero_pagina').value = '1';
		return false;
	}
	
}

function vai_a_pagina(){
	loadModalWindowCustom('Attendere Prego...');
	document.getElementById('ricercaPratica').action = "GestioneAnagraficaAction.do?command=SearchPraticheAmministrative";
	document.getElementById('ricercaPratica').submit(); 
}


</script>  		

  	
 