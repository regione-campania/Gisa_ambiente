 
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
		<td>PRATICHE SUAP 2.0</td>
	</tr>
	</table>
<%-- Trails --%>


<br>
<div align="center">
<input type="button" class="yellowBigButton" style="width: 300px;" 
		onclick="loadModalWindowCustom('Attendere Prego...'); window.location.href='GestioneAnagraficaAction.do?command=CreaPratica';" 
		value="NUOVA PRATICA" />
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" class="yellowBigButton" style="width: 300px;" 
		onclick="loadModalWindowCustom('Attendere Prego...'); window.location.href='GestioneAnagraficaAction.do?command=SearchFormPratica';" 
		value="RICERCA IN TUTTE LE PRATICHE" />
</div>
<br><br>
<center>
<b>Lista pratiche</b><br/>
<i>In questa pagina sono elencate le ultime 100 pratiche inserite nel sistema.</i>
<br><br>
<table class="table details" id="tabella_pratiche" style="border-collapse: collapse" border="1" width="100%" cellpadding="5"> 
<tr>
	<th style="text-align:center; width:15%;">
		<p>Numero pratica</p><hr>
		<p><input type="text" id="num_prat_col"  style="text-align:center; width:90%;" onkeyup="filtra_pratiche(this.id,0)" placeholder="cerca num. pratica" ></p>
	</th>
	<th style="text-align:center; width:25%;">
		<p>Dati impresa e stabilimento</p><hr>
		<p><input type="text" id="dati_stab_col"  style="text-align:center; width:90%;" onkeyup="filtra_pratiche(this.id,1)" placeholder="cerca dati impresa/stabilimento" ></p>
	</th>
	<th style="text-align:center; width:10%;">
		<p>comune</p><hr>
		<p><input type="text" id="comune_ric_col"  style="text-align:center; width:90%;" onkeyup="filtra_pratiche(this.id,2)" placeholder="cerca comune" ></p>
	</th>
	<th style="text-align:center">
		<p>data pec</p><hr>
		<p><input type="text" id="data_ric_col"  style="text-align:center; width:90%;" onkeyup="filtra_pratiche(this.id,3)" placeholder="cerca data" ></p>
	</th>
	<th style="text-align:center">
		<p>tipo pratica</p><hr>
		<p><input type="text" id="tipo_pratica_col"  style="text-align:center; width:90%;" onkeyup="filtra_pratiche(this.id,4)" placeholder="cerca tipo" ></p>
	</th> 
	
	<th style="text-align:center; width:10%;">
		<p>Utente</p><hr>
		<p><input type="text" id="utente_col"  style="text-align:center; width:90%;" onkeyup="filtra_pratiche(this.id,6)" placeholder="cerca utente" ></p>
	</th> 
	<th style="text-align:center; width:10%;" ><p>ALLEGATI</p></th> 
	<th style="text-align:center"></th> 
</tr>

<% int j=0; 
for ( int i = 0; i<ListaPratiche.size(); i++) {
	
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
<tr class="row<%=j%2%>">
<td align="center"><p><%=p.getNumeroPratica() %></p></td>

<td align="center">
	
	<%if((p.getIdTipologiaPratica() != 1 || p.getStatoPratica() == 1) && p.getAltId() != -1 ){ %>
	<!-- 	<a style="text-decoration: none;" href='GestioneAnagraficaAction.do?command=Details&stabId=<%=p.getIdStabilimento()%>'> -->
			<b><%=p.getRagioneSociale() %></b>
			<br>P. IVA/cod. fiscale impresa: <%=p.getPartitaIva() %>
			<br>Num. Reg.: <%=p.getNumeroRegistrazione() %>
			<br>Indirizzo: <%=p.getIndirizzo() %>
		<!-- </a> -->
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

<%
  j++;
	}
}
%>
</table>
<br>
<br>

<script>
function filtra_pratiche(colid,ordine_col) {
  var input, filter, table, tr, td, i, txtValue;
  input = document.getElementById(colid);
  filter = input.value.toUpperCase();
  table = document.getElementById("tabella_pratiche");
  tr = table.getElementsByTagName("tr");
  for (i = 0; i < tr.length; i++) {
    td = tr[i].getElementsByTagName("td")[ordine_col];
    if (td) {
      txtValue = td.textContent || td.innerText;
      if (txtValue.toUpperCase().indexOf(filter.trim()) > -1) {
        tr[i].style.display = "";
      } else {
        tr[i].style.display = "none";
      }
    }       
  }
}


</script>  		

  	
 