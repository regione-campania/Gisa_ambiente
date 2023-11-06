
<%int z = 0; %>

<!-- INIT DOCUMENTALE -->
	<%@ include file="/gestione_documenti/initDocumentale.jsp" %>
<!-- FINE INIT DOCUMENTALE -->

<!-- INIZIO HEADER -->
	<%@ include file="/campioni/moduli_html/header.jsp" %>
<!-- FINE HEADER -->

<div class="boxOrigineDocumento"><%@ include file="../../../hostName.jsp" %></div>

<table><tr>
<TD>
<div id="idbutn" style="display:block;">
<%-- <input type="button" class = "buttonClass" value ="Salva in modalita' definitiva" onclick="this.form.bozza.value='false';javascript:checkSubmit();"/>
--%>
</div>
<input id="stampaId" type="button" class = "buttonClass"  style="display:none" value ="Stampa" onclick="javascript:if( confirm('Attenzione! Controlla bene tutti i dati inseriti in quanto alla chiusura della finestra, i dati saranno persi.\nVuoi effettuare la stampa?')){return window.print();}else return false;"/>
<input type="hidden" id = "bozza" name = "bozza" value="">

<%-- onclick="this.form.bozza.value='false';" --%>
<br>

<dhv:permission name="server_documentale-view">
<%if (definitivoDocumentale!=null && definitivoDocumentale.equals("true")){ %>
<!--  BOX DOCUMENTALE -->
	  <jsp:include page="../../gestione_documenti/boxDocumentale.jsp">
    <jsp:param name="orgId" value="<%=request.getParameter("orgId") %>" />
     <jsp:param name="ticketId" value="<%=request.getParameter("ticketId") %>" />
      <jsp:param name="tipo" value="<%=request.getParameter("tipo") %>" />
       <jsp:param name="idCU" value="<%=request.getParameter("idCU") %>" />
        <jsp:param name="url" value="<%=request.getParameter("url") %>" />
</jsp:include>
<!--  BOX DOCUMENTALE -->
<% } else {%>
<form method="post" name="form2" action="PrintModulesHTML.do?command=ViewModules">
<input id="stampaPdfId" type="button" class = "buttonClass" value ="Genera e Stampa PDF" onclick="if (confirm ('Nella prossima schermata sara' possibile recuperare l\'ultimo PDF generato a partire dal documento a schermo, \n oppure generarne uno nuovo.')){javascript:salva(this.form)}"/>
<input type="hidden" id="documentale" name ="documentale" value="ok"></input>
<input type="hidden" id="listavalori" name ="listavalori" value=""></input>
 <input type="hidden" id ="orgId" name ="orgId" value="<%=request.getParameter("orgId") %>" />
  <input type="hidden" id ="ticketId" name ="ticketId" value="<%=request.getParameter("ticketId") %>" />
   <input type="hidden" id ="tipo" name ="tipo" value="<%=request.getParameter("tipo") %>" />
    <input type="hidden" id ="idCU" name ="idCU" value="<%=request.getParameter("idCU") %>" />
      <input type="hidden" id ="url" name ="url" value="<%=request.getParameter("url") %>" />
</form>
<% } %>
</dhv:permission>
</TD>
</TABLE>


<table style="border: 1px solid black; border-collapse: collapse" width="100%">

<tr>
<td style="border: 1px solid black" valign="top">
<center>ANAGRAFICA PROGCODE [PROGCODE]</center>
[<%= fixValore(Modulo.getListaCampiModulo().get("progcode").get("progcode")).equals("2") ? "X" : ""%>] VIG001AL - Altre analisi chimiche<br/>
[<%= fixValore(Modulo.getListaCampiModulo().get("progcode").get("progcode")).equals("3") ? "X" : ""%>] VIG003AL - 3MCPD<br/>
[<%= fixValore(Modulo.getListaCampiModulo().get("progcode").get("progcode")).equals("4") ? "X" : ""%>] VIG004AL - Diossine<br/>
[<%= fixValore(Modulo.getListaCampiModulo().get("progcode").get("progcode")).equals("5") ? "X" : ""%>] VIG005AL - Contaminanti agricoli e tossine vegetali naturali<br/>
[<%= fixValore(Modulo.getListaCampiModulo().get("progcode").get("progcode")).equals("6") ? "X" : ""%>] VIG001MC - Materiali e oggetti a contatto con gli alimenti<br/>
[<%= fixValore(Modulo.getListaCampiModulo().get("progcode").get("progcode")).equals("7") ? "X" : ""%>] VIG001AD - Additivi negli alimenti oppure criteri di purezza negli Additivi<br/>
[<%= fixValore(Modulo.getListaCampiModulo().get("progcode").get("progcode")).equals("8") ? "X" : ""%>] VIG00MON - Monitoraggi conoscitivi
</td>

<td style="border: 1px solid black" valign="top">
<center>STRATEGIA DI CAMPIONAMENTO  [SAMPSTR]</center><br/>
[<%= fixValore(Modulo.getListaCampiModulo().get("strategiacampionamento").get("strategiacampionamento")).equals("2") ? "X" : ""%>] ST20A - Campione prelevato su pianificazione ordinaria<br/>
[<%= fixValore(Modulo.getListaCampiModulo().get("strategiacampionamento").get("strategiacampionamento")).equals("3") ? "X" : ""%>] ST30A - Campione prelevato su sospetto<br/>
[<%= fixValore(Modulo.getListaCampiModulo().get("strategiacampionamento").get("strategiacampionamento")).equals("4") ? "X" : ""%>] Altro
</td>
</tr>

<tr>
<td style="border: 1px solid black" valign="top">
<center>TIPO DI PROGRAMMA DI CAMPIONAMENTO  [PROGTYP]</center><br/>
[<%= fixValore(Modulo.getListaCampiModulo().get("programmacampionamento").get("programmacampionamento")).equals("2") ? "X" : ""%>] K005A - Campione ufficiale<br/>
[<%= fixValore(Modulo.getListaCampiModulo().get("programmacampionamento").get("programmacampionamento")).equals("3") ? "X" : ""%>] K022A - Monitoraggio (solo se VIG00MON)
</td>

<td style="border: 1px solid black" valign="top">
ORGANO PRELEVATORE (sampOrg): 020101</td>
</tr>

</table>



<P class="main">
L'anno <label class="layout"><%= fixValore( OrgOperatore.getAnnoReferto()) %></label> addi' <label class="layout"><%= fixValore(OrgOperatore.getGiornoReferto())%></label> del mese di <label class="layout"><%= fixValore(OrgOperatore.getMeseReferto())%></label> alle ore <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("ora_controllo").get("ora_controllo"))%> </label>, il/i sottoscritto/i  
<% if (OrgOperatore.getComponente_nucleo()!=null) {%> <label class="layout"><%= fixValore(OrgOperatore.getComponente_nucleo()) %></label> <%} %> 
<% if (OrgOperatore.getComponente_nucleo_due()!=null) {%> <label class="layout"><%= fixValore(OrgOperatore.getComponente_nucleo_due()) %></label> <%} %> 
<% if (OrgOperatore.getComponente_nucleo_tre()!=null) {%> <label class="layout"><%= fixValore(OrgOperatore.getComponente_nucleo_tre()) %></label> <%} %> 
<% if (OrgOperatore.getComponente_nucleo_quattro()!=null) {%> <label class="layout"><%= fixValore(OrgOperatore.getComponente_nucleo_quattro()) %></label> <%} %> 
<% if (OrgOperatore.getComponente_nucleo_cinque()!=null) {%> <label class="layout"><%= fixValore(OrgOperatore.getComponente_nucleo_cinque()) %></label> <%} %> 
<% if (OrgOperatore.getComponente_nucleo_sei()!=null) {%> <label class="layout"><%= fixValore(OrgOperatore.getComponente_nucleo_sei()) %></label> <%} %> 
<% if (OrgOperatore.getComponente_nucleo_sette()!=null) {%> <label class="layout"><%= fixValore(OrgOperatore.getComponente_nucleo_sette()) %></label> <%} %> 
<% if (OrgOperatore.getComponente_nucleo_otto()!=null) {%> <label class="layout"><%= fixValore(OrgOperatore.getComponente_nucleo_otto()) %></label> <%} %> 
<% if (OrgOperatore.getComponente_nucleo_nove()!=null) {%> <label class="layout"><%= fixValore(OrgOperatore.getComponente_nucleo_nove()) %></label> <%} %> 
<% if (OrgOperatore.getComponente_nucleo_dieci()!=null) {%> <label class="layout"><%= fixValore(OrgOperatore.getComponente_nucleo_dieci()) %></label> <%} %>  
appartenenti/e alla S.C. Igiene degli Alimenti e della Nutrizione dell'Azienda USL della Valle d'Aosta, in qualita' di organo di controllo dell'Autorita' Competente Locale per la sicurezza alimentare, si e'/sono presentato/i presso:<br/><br/>

Stabilimento/azienda/altro<br/>
sito/a nel Comune di <label class="layout"><%= fixValore(OrgOperatore.getComune())%></label><br/> in via/fraz. <label class="layout"><%= fixValore(OrgOperatore.getIndirizzo()) %></label>, <br/>
Attivita' registr./cod.az./targa <label class="layout"><%= fixValore(OrgOperatore.getN_reg()) %></label> 
- linea di attivita' ispezionata: <label class="layout"><%= fixValore(OrgOperatore.getTipologia_att())%></label>.<br/>
[Fase filiera: [<%= fixValore(Modulo.getListaCampiModulo().get("fase_filiera").get("fase_filiera")).equals("2") ? "X" : ""%>] AIT01 - Produzione [<%= fixValore(Modulo.getListaCampiModulo().get("fase_filiera").get("fase_filiera")).equals("3") ? "X" : ""%>] AIT02 - Commercializzazione/Distribuzione] [MTX.gen] <br/><br/>

Nome/ditta/ragione/denominazione sociale: <label class="layout"><%= fixValore(OrgOperatore.getRagione_sociale())%></label> con sede legale nel  <br/> 
comune di <label class="layout"><%= fixValore(OrgOperatore.getSede_legale())%></label> in via/fraz. <label class="layout"><%= fixValore(OrgOperatore.getIndirizzo_legale()) %></label> N <label class="layout"><%= fixValore(OrgOperatore.getIndirizzo_legale_civico()) %></label> <br/>
PI/CF <label class="layout"><%= fixValore(OrgOperatore.getCodice_fiscale()) %></label><br/>
Titolare/Legale rappresentante Sig./ra <label class="layout"><%= fixValore(OrgOperatore.getLegale_rapp()) %></label> 
nato/a a <label class="layout"><%= fixValore(OrgOperatore.getLuogo_nascita_rappresentante()) %></label> il <label class="layout"><%= fixValore(OrgOperatore.getGiornoNascita())%></label>/<label class="layout"><%= fixValore(OrgOperatore.getMeseNascita())%></label>/<label class="layout"><%= fixValore(OrgOperatore.getAnnoNascita())%></label> <br/>
e residente in  <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("comune_residenza_rapp_legale").get("comune_residenza_rapp_legale"))%> </label> alla via/fraz <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("indirizzo_residenza_rapp_legale").get("indirizzo_residenza_rapp_legale"))%> </label> n. <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("num_indirizzo_residenza_rapp_legale").get("num_indirizzo_residenza_rapp_legale"))%> </label><br/>
domicilio digitale <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("domicilio_digitale_rapp_legale").get("domicilio_digitale_rapp_legale"))%> </label><br/><br/>

Presente al prelievo: Sig./ra <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("nome_presente_ispezione").get("nome_presente_ispezione"))%> </label> nato/a a <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("luogo_nascita_presente_ispezione").get("luogo_nascita_presente_ispezione"))%> </label> il <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("data_nascita_presente_ispezione").get("data_nascita_presente_ispezione"))%> </label> e <br/>
residente in <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("comune_residenza_presente_ispezione").get("comune_residenza_presente_ispezione"))%> </label> in via/fraz. <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("indirizzo_residenza_presente_ispezione").get("indirizzo_residenza_presente_ispezione"))%> </label> n <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("num_indirizzo_residenza_presente_ispezione").get("num_indirizzo_residenza_presente_ispezione"))%> </label>
[<%= fixValore(Modulo.getListaCampiModulo().get("documento").get("documento")).equals("2") ? "X" : ""%>] doc. ident. [<%= fixValore(Modulo.getListaCampiModulo().get("documento").get("documento")).equals("3") ? "X" : ""%>] pat. auto [<%= fixValore(Modulo.getListaCampiModulo().get("documento").get("documento")).equals("4") ? "X" : ""%>] C.I. [<%= fixValore(Modulo.getListaCampiModulo().get("documento").get("documento")).equals("5") ? "X" : ""%>] <br/>
altro doc. (ultime 4 cifre <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("documento_ultime").get("documento_ultime"))%> </label>) [<%= fixValore(Modulo.getListaCampiModulo().get("documento").get("documento")).equals("6") ? "X" : ""%>] personalmente conosciuto [<%= fixValore(Modulo.getListaCampiModulo().get("documento").get("documento")).equals("7") ? "X" : ""%>] sprovvisto, nella sua qualita' di <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("qualita_presente_ispezione").get("qualita_presente_ispezione"))%> </label><br/><br/>

Motivo del campionamento: <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("motivo_campionamento").get("motivo_campionamento"))%> </label><br/><br/>

Il/i sottoscritto/i ha/hanno proceduto, ai sensi della seguente normativa <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("normativa").get("normativa"))%> </label> al prelievo di un campione di <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("campione_prelevato").get("campione_prelevato"))%> </label><br/>
codice <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("codice_campione_prelevato").get("codice_campione_prelevato"))%> </label> <br/>. 
[MTX.Building] <br/> trasformazione/trattamento <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("trasformazione_trattamento").get("trasformazione_trattamento"))%> </label> [MTX.Process] <br/><br/>

Metodo di produzione: 
[<%= fixValore(Modulo.getListaCampiModulo().get("metodo_produzione").get("metodo_produzione")).equals("2") ? "X" : ""%>] Biologico/Organico [<%= fixValore(Modulo.getListaCampiModulo().get("metodo_produzione").get("metodo_produzione")).equals("3") ? "X" : ""%>] Non biologico [<%= fixValore(Modulo.getListaCampiModulo().get("metodo_produzione").get("metodo_produzione")).equals("4") ? "X" : ""%>] Lotta integrata [<%= fixValore(Modulo.getListaCampiModulo().get("metodo_produzione").get("metodo_produzione")).equals("5") ? "X" : ""%>] Sconosciuto <br/>
[Pronto al consumo o no: [<%= fixValore(Modulo.getListaCampiModulo().get("pronto_consumo").get("pronto_consumo")).equals("2") ? "X" : ""%>] A07VP - Ready to eat [<%= fixValore(Modulo.getListaCampiModulo().get("pronto_consumo").get("pronto_consumo")).equals("3") ? "X" : ""%>] A07VQ - Non ready to eat [MTX.use] nella quantita' di <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("quantita_produzione").get("quantita_produzione"))%> </label> rappresentativo di una partita di <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("rappresentativo_partita").get("rappresentativo_partita"))%> </label> [<%= fixValore(Modulo.getListaCampiModulo().get("unita_partita").get("unita_partita")).equals("2") ? "X" : ""%>] kg [<%= fixValore(Modulo.getListaCampiModulo().get("unita_partita").get("unita_partita")).equals("3") ? "X" : ""%>] lt [<%= fixValore(Modulo.getListaCampiModulo().get("unita_partita").get("unita_partita")).equals("4") ? "X" : ""%>] unita , con n. lotto <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("num_lotto").get("num_lotto"))%> </label> data di produzione <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("data_produzione_lotto").get("data_produzione_lotto"))%> </label> e <br/>
[<%= fixValore(Modulo.getListaCampiModulo().get("scadenza_tmc").get("scadenza_tmc")).equals("2") ? "X" : ""%>] data di scadenza / [<%= fixValore(Modulo.getListaCampiModulo().get("scadenza_tmc").get("scadenza_tmc")).equals("3") ? "X" : ""%>] TMC <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("data_scadenza_tmc").get("data_scadenza_tmc"))%> </label>.
Detta merce, al momento del prelievo, posta in (descrizione dettagliata) <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("descrizione_merce").get("descrizione_merce"))%> </label> alla [<%= fixValore(Modulo.getListaCampiModulo().get("temperatura_merce").get("temperatura_merce")).equals("2") ? "X" : ""%>] temperatura di <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("temperatura_merce_gradi").get("temperatura_merce_gradi"))%> </label> .C / [<%= fixValore(Modulo.getListaCampiModulo().get("temperatura_merce").get("temperatura_merce")).equals("3") ? "X" : ""%>] temperatura ambiente, 
si presenta: [<%= fixValore(Modulo.getListaCampiModulo().get("confezione").get("confezione")).equals("2") ? "X" : ""%>] confezione originale integra [<%= fixValore(Modulo.getListaCampiModulo().get("confezione").get("confezione")).equals("3") ? "X" : ""%>] confezione originale non integra [<%= fixValore(Modulo.getListaCampiModulo().get("confezione").get("confezione")).equals("4") ? "X" : ""%>] preincarto [<%= fixValore(Modulo.getListaCampiModulo().get("confezione").get("confezione")).equals("5") ? "X" : ""%>] sfusa [<%= fixValore(Modulo.getListaCampiModulo().get("confezione").get("confezione")).equals("6") ? "X" : ""%>] porzionata al momento del prelievo<br/><br/>

La merce e' contrassegnata da cartelli/etichette/involucri/documenti 
[<%= fixValore(Modulo.getListaCampiModulo().get("allegato").get("allegato")).equals("2") ? "X" : ""%>] di cui si allega copia/rilievo fotografico che e' parte integrante del presente verbale /[<%= fixValore(Modulo.getListaCampiModulo().get("allegato").get("allegato")).equals("3") ? "X" : ""%>] recanti le seguenti diciture: <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("diciture").get("diciture"))%> </label><br/>________________________________________________________________________<br/>________________________________________________________________________<br/>________________________________________________________________________<br/>
e le seguenti informazioni fornite al consumatore/utilizzatore sul modo di evitare possibili effetti nocivi per la salute (queste ultime informazioni possono essere sostituite da documentazione fotografica allegata al verbale): <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("informazioni_consumatore").get("informazioni_consumatore"))%> </label><br/>

Preso atto che il prodotto campionato e' preparato/confezionato dalla Ditta <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("ditta_confezione").get("ditta_confezione"))%> </label>  nello stabilimento sito/a nel Comune di <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("comune_confezione").get("comune_confezione"))%> </label> in via/fraz. <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("via_confezione").get("via_confezione"))%> </label>, n <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("num_via_confezione").get("num_via_confezione"))%> </label> , <br/>
avente marchio CE <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("ce_confezione").get("ce_confezione"))%> </label> e ha quindi origine [Country: <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("origine_confezione").get("origine_confezione"))%> </label> ]. [COUNTRY] <br/><br/>

Rintracciabilita' della merce: il/la Sig./Sig.ra <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("nome_rintracciabilita").get("nome_rintracciabilita"))%> </label> dichiara che trattasi di merce [<%= fixValore(Modulo.getListaCampiModulo().get("merce_rintracciabilita").get("merce_rintracciabilita")).equals("2") ? "X" : ""%>] prodotta [<%= fixValore(Modulo.getListaCampiModulo().get("merce_rintracciabilita").get("merce_rintracciabilita")).equals("3") ? "X" : ""%>] ricevuta [<%= fixValore(Modulo.getListaCampiModulo().get("merce_rintracciabilita").get("merce_rintracciabilita")).equals("4") ? "X" : ""%>] <br>
acquistata dalla Ditta <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("ditta_rintracciabilita").get("ditta_rintracciabilita"))%> </label>, sita nel Comune di <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("comune_rintracciabilita").get("comune_rintracciabilita"))%> </label> <br/> 
in via/fraz. <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("via_rintracciabilita").get("via_rintracciabilita"))%> </label>, n <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("num_via_rintracciabilita").get("num_via_rintracciabilita"))%> </label> in data <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("data_rintracciabilita").get("data_rintracciabilita"))%> </label>, con <br> 
documentazione commerciale giustificativa [<%= fixValore(Modulo.getListaCampiModulo().get("documentazione_rintracciabilita").get("documentazione_rintracciabilita")).equals("2") ? "X" : ""%>] bolla [<%= fixValore(Modulo.getListaCampiModulo().get("documentazione_rintracciabilita").get("documentazione_rintracciabilita")).equals("3") ? "X" : ""%>] fattura [<%= fixValore(Modulo.getListaCampiModulo().get("documentazione_rintracciabilita").get("documentazione_rintracciabilita")).equals("4") ? "X" : ""%>] D.d.T. n. <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("numero_documentazione_rintracciabilita").get("numero_documentazione_rintracciabilita"))%> </label> del <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("data_documentazione_rintracciabilita").get("data_documentazione_rintracciabilita"))%> </label>, e che la merce <br>
[<%= fixValore(Modulo.getListaCampiModulo().get("trattamenti_merce_rintracciabilita").get("trattamenti_merce_rintracciabilita")).equals("2") ? "X" : ""%>] ha [<%= fixValore(Modulo.getListaCampiModulo().get("trattamenti_merce_rintracciabilita").get("trattamenti_merce_rintracciabilita")).equals("3") ? "X" : ""%>] non ha subito eventuali aggiunte o trattamenti all'atto del prelievo.<br/>

Il campione e' da considerarsi [<%= fixValore(Modulo.getListaCampiModulo().get("considerazione_campione").get("considerazione_campione")).equals("2") ? "X" : ""%>] deteriorabile [<%= fixValore(Modulo.getListaCampiModulo().get("considerazione_campione").get("considerazione_campione")).equals("3") ? "X" : ""%>] non deteriorabile [<%= fixValore(Modulo.getListaCampiModulo().get("considerazione_campione").get("considerazione_campione")).equals("4") ? "X" : ""%>] deteriorabilita' (D.M. 16/12/93) da accertarsi in laboratorio.In caso di <br/>
elemento deteriorabile e in caso di non conformita' dell'aliquota, sara' cura del laboratorio comunicare all'interessato il giorno, l'ora e il <br/>
luogo della seconda analisi.<br/><br/>

Il campione, effettuato per la ricerca di <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("campione_ricerca").get("campione_ricerca"))%> </label> e prelevato con <br>
le modalita' atte a garantire la rappresentativita' e l'assenza di contaminazioni, utilizzando attrezzature e contenitori puliti, <br>
asciutti e di materiale inerte e sterile o reso tale, e' stato suddiviso in n. <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("num_aliquote").get("num_aliquote"))%> </label> aliquota/e del peso di circa <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("peso_aliquote").get("peso_aliquote"))%> </label> g/ml ciascuna, ogni <br>
aliquota e' composta da n. <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("num_unita_aliquote").get("num_unita_aliquote"))%> </label> unita' campionarie del peso di circa <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("peso_unita_aliquote").get("peso_unita_aliquote"))%> </label> g/ml ciascuna. La/le aliquota/e e'/sono <br/>
posta/e in [<%= fixValore(Modulo.getListaCampiModulo().get("confezione_aliquote").get("confezione_aliquote")).equals("2") ? "X" : ""%>] sacchetti di materiale plastico muniti di banda sigillante antimanomissione riportanti le indicazioni e le firme del presente verbale [<%= fixValore(Modulo.getListaCampiModulo().get("confezione_aliquote").get("confezione_aliquote")).equals("3") ? "X" : ""%>] altro <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("confezione_aliquote_altro").get("confezione_aliquote_altro"))%> </label>

[<%= fixValore(Modulo.getListaCampiModulo().get("aliquote_aggiuntive").get("aliquote_aggiuntive")).equals("2") ? "X" : ""%>] e' presente n. <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("num_unita_aliquote_laboratorio").get("num_unita_aliquote_laboratorio"))%> </label> aliquota/e aggiuntiva/e che il laboratorio utilizzera' per gli esami, compresi quelli di conferma da eseguire presso laboratori terzi.
[<%= fixValore(Modulo.getListaCampiModulo().get("aliquote_aggiuntive").get("aliquote_aggiuntive")).equals("3") ? "X" : ""%>] la persona presente al campionamento dichiara di voler rinunciare alle aliquote per la controperizia/controversia (Reg. UE 2017/625).
[<%= fixValore(Modulo.getListaCampiModulo().get("aliquote_aggiuntive").get("aliquote_aggiuntive")).equals("4") ? "X" : ""%>] una delle aliquote contrassegnata dalla lettera/numero <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("num_unita_aliquote_consegnate").get("num_unita_aliquote_consegnate"))%> </label> e' stata consegnata al/alla Sig./Sig.ra  <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("nome_unita_aliquote_consegnate").get("nome_unita_aliquote_consegnate"))%> </label> con indicazione di conservarla in ambiente protetto dai raggi solari, ad una temperatura di <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("gradi_unita_aliquote_consegnate").get("gradi_unita_aliquote_consegnate"))%> </label>  
[<%= fixValore(Modulo.getListaCampiModulo().get("aliquote_aggiuntive").get("aliquote_aggiuntive")).equals("5") ? "X" : ""%>] Trattandosi di aliquota unica (art. 7 co. 2 del D.Lgs. 27/2021) per quantita' insufficiente alla composizione delle aliquote di legge, si <br/>
richiede di eseguire un'analisi unica ed irripetibile garantendo i diritti alla difesa,  da effettuare il <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("data_unita_aliquote_unica").get("data_unita_aliquote_unica"))%> </label> alle ore <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("ore_unita_aliquote_unica").get("ore_unita_aliquote_unica"))%> </label> <br/>
presso <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("presso_unita_aliquote_unica").get("presso_unita_aliquote_unica"))%> </label> sito nel Comune di <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("comune_unita_aliquote_unica").get("comune_unita_aliquote_unica"))%> </label> <br/>
in via/fraz.<label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("via_unita_aliquote_unica").get("via_unita_aliquote_unica"))%> </label>, n <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("num_via_unita_aliquote_unica").get("num_via_unita_aliquote_unica"))%> </label> con facolta' della parte di partecipare.<br/>
L'unica aliquota/le restanti aliquote e'/sono inviata/e al [<%= fixValore(Modulo.getListaCampiModulo().get("destinazione_aliquote").get("destinazione_aliquote")).equals("2") ? "X" : ""%>] Istituto Zooprofilattico Sperimentale del Piemonte, Liguria e Valle d'Aosta [<%= fixValore(Modulo.getListaCampiModulo().get("destinazione_aliquote").get("destinazione_aliquote")).equals("3") ? "X" : ""%>]<br> 
A.R.P.A. Valle d'Aosta e trasportata/e mediante [<%= fixValore(Modulo.getListaCampiModulo().get("contenitore_destinazione_aliquote").get("contenitore_destinazione_aliquote")).equals("2") ? "X" : ""%>] contenitore isotermico refrigerato con siberini [<%= fixValore(Modulo.getListaCampiModulo().get("contenitore_destinazione_aliquote").get("contenitore_destinazione_aliquote")).equals("3") ? "X" : ""%>] contenitore frigorifero alla <br/>
temperatura di <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("gradi_contenitore_destinazione_aliquote").get("gradi_contenitore_destinazione_aliquote"))%> </label> .C / [<%= fixValore(Modulo.getListaCampiModulo().get("contenitore_destinazione_aliquote").get("contenitore_destinazione_aliquote")).equals("4") ? "X" : ""%>] contenitore a temperatura ambiente.<br/>

[<%= fixValore(Modulo.getListaCampiModulo().get("sequestro_partita").get("sequestro_partita")).equals("2") ? "X" : ""%>] si e' [<%= fixValore(Modulo.getListaCampiModulo().get("sequestro_partita").get("sequestro_partita")).equals("3") ? "X" : ""%>] non si e' proceduto al sequestro della partita/lotto relativa al campione prelevato (verbale n. <label class="layout"><%= fixValore(Modulo.getListaCampiModulo().get("num_verbale_sequestro_partita").get("num_verbale_sequestro_partita"))%> </label> )<br/><br/>

Il presente verbale e' stato redatto in n. ........... copie originali di cui una copia e' stata letta, sottoscritta e consegnata al/alla Sig./Sig.ra presente al campionamento il/la quale ha dichiarato quanto segue: ...................................................................................... <br/><br/>
Note: ........................................................................... <br/><br/>

Ai sensi dell'art. 6, punto 1, lettera e), del Reg UE 679/16 si assicura la liceita' del trattamento dei dati personali che potranno essere inviati ad altre P.A. con finalita' che riguardano la definizione della presente procedura e degli atti conseguenti, o resi pubblici in ottemperanza al Reg UE 625/17 ed agli altri obblighi normativi in materia di trasparenza.<br/><br/>


<div align="left">Firma del presente al campionamento</div>
<div align="right">Gli operatori del controllo ufficiale</div>


</P>
<div style="page-break-before:always"> 
<!-- INIZIO HEADER -->
	<%@ include file="/campioni/moduli_html/header.jsp" %>
<!-- FINE HEADER -->

<!-- INIZIO FOOTER -->
	<%@ include file="/campioni/moduli_html/footer.jsp" %>
<!-- FINE FOOTER -->

</div>
