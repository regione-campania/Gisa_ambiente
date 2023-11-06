<%@page import="org.aspcfs.modules.dpat.actions.DpatSDC"%>
<%@page import="org.aspcfs.modules.dpat.base.DpatIndicatore"%>
<%@page import="org.aspcfs.modules.dpat.base.DpatAttivita"%>
<%@page import="org.aspcfs.modules.dpat.base.DpatPiano"%>
<%@page import="org.aspcfs.modules.dpat.base.DpatSezione"%>
<%@page import="org.aspcfs.modules.dpat.base.DpatIstanza"%>
<%@page import="org.aspcfs.modules.dpat.base.PianoMonitoraggio"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio"%>

<%@page import="org.aspcfs.modules.dpat.base.Dpat"%>


<jsp:useBean id="TicListPiani"
	class="org.aspcfs.modules.programmazzionecu.base.PianoMonitoraggioList"
	scope="request" />
<jsp:useBean id="TicListPianiInfo"
	class="org.aspcfs.utils.web.PagedListInfo" scope="session" />
<jsp:useBean id="lookup_asl" class="org.aspcfs.utils.web.LookupList"
	scope="request"></jsp:useBean>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean"
	scope="session" />
<jsp:useBean id="lookup_sezioni_piani"
	class="org.aspcfs.utils.web.LookupList" scope="request"></jsp:useBean>

<%@ include file="../initPage.jsp"%>
<%@ include file="../initPopupMenu.jsp"%>

<%@ include file="troubletickets_searchresults_menu.jsp"%>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript"
	SRC="javascript/spanDisplay.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript"
	SRC="javascript/confirmDelete.js"></SCRIPT>

<script type="text/javascript" src="dwr/interface/PopolaCombo.js">
	
</script>

<script type="text/javascript" src="dwr/engine.js">
	
</script>
<script type="text/javascript" src="dwr/util.js"></script>

<script language="JavaScript" type="text/javascript">
	
<%-- Preload image rollovers for drop-down menu --%>
function scrollToElement() {
	var ele = document.getElementById("scroll");
	if(ele!=null)
   	 $(window).scrollTop(ele.offset().top).scrollLeft(ele.offset().left);
}
</script>


<%


	DpatIstanza IstanzaDpat = (DpatIstanza) request.getAttribute("IstanzaDpat");
%>

<script>


function apriDettaglioAttivita(idAttivita,anno)
{
	
	
	
	window
	.open(
			'Dpat.do?command=ListaAttivitaCodiceInterno&anno='+anno+'&idAttivita='+idAttivita,
			null,
			'scrollbar=yes,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,modal=yes');

	
	
}


function apriDettaglioIndicatore(idIndicatore,anno)
{
	
	
	
	window
	.open(
			'Dpat.do?command=ListaIndicatoriCodiceInterno&anno='+anno+'&idIndicatore='+idIndicatore,
			null,
			'scrollbar=yes,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,modal=yes');

	
	
}

	function salvaCoefficienteCallback(retVal) {
		alert(retVal.descrizione);
	}
	var val;

	function verificaEsistenzaControlliSuPianoCallback(val) {

		if (val == true) {

			alert('Sono stati Inseriti Controlli Su Questo Piano. Non è possibile procedere con la modifica-!');
		} else {
			location.href = urlToLoad;
		}

	}
	var urlToLoad = '';
	function verificaEsistenzaControlliSuPiano(idPiano, url) {

		urlToLoad = url;
		PopolaCombo.vreificaEsistenzaControlliPerPianiConfiguratore(idPiano, {
			callback : verificaEsistenzaControlliSuPianoCallback,
			async : false
		});

	}

	function saveCoefficiente(valore, field, idIndicatore) {

		if (!isNaN(valore)) {

			val = field.value;
			PopolaCombo.salvaCoefficiente(idIndicatore, valore, {
				callback : salvaCoefficienteCallback,
				async : false
			});
		} else {

			if (!isNaN(val)) {
				field.value = val;

			} else
				field.value = '';

			alert('Valore Non Consentito');
		}
	}

	function openNotePianoMonitoraggioAdd(tipoInserimento, idPianoRiferimento,
			nuovasezione, tipo_piano_attivita_ind) {
		var res;
		var result;
		// tipoInserimento : up , down ,firstchild
		window
				.open(
						'Dpat.do?command=Add&tipoPianoAtt='
								+ tipo_piano_attivita_ind + '&nuovasezione='
								+ nuovasezione + '&tipoInserimento='
								+ tipoInserimento + '&idPianoRiferimento='
								+ idPianoRiferimento+'&anno='+<%=IstanzaDpat.getAnno() %>,
						null,
						'scrollbar=yes,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,modal=yes');

	}

	function openNotePianoMonitoraggioReplace(dataScadenza, idPianoRiferimento,
			tipo_piano_attivita_ind, cessato) {
		var res;
		var result;
		// tipoInserimento : up , down ,firstchild

		if (dataScadenza == '' || dataScadenza == 'null'
				|| dataScadenza == null) {
			window
					.open(
							'Dpat.do?command=ToReplace&cessato=' + cessato+'&anno='+<%=IstanzaDpat.getAnno() %>
									+ '&tipoPianoAtt='
									+ tipo_piano_attivita_ind
									+ '&idPianoRiferimento='
									+ idPianoRiferimento,
							null,
							'height=700px,width=900px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=no,resizable=no ,modal=yes');
		} else {
			if (confirm('ATTENZIONE SU QUESTO RECORD CI SONO MODIFICHE NON ATTUALIZZATE . PROCEDERE COMUNQUE CON LA MODIFICA ?')) {

				window
						.open(
								'Dpat.do?command=ToReplace&cessato=' + cessato+'&anno='+<%=IstanzaDpat.getAnno() %>
										+ '&tipoPianoAtt='
										+ tipo_piano_attivita_ind
										+ '&idPianoRiferimento='
										+ idPianoRiferimento,
								null,
								'scrollbar=yes,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,modal=yes');
			}

		}
	}
	
	
	function openNotePianoMonitoraggioReplaceIndicatore(dataScadenza, idPianoRiferimento,
			tipo_piano_attivita_ind, cessato) {
		var res;
		var result;
		// tipoInserimento : up , down ,firstchild

		if (dataScadenza == '' || dataScadenza == 'null'
				|| dataScadenza == null) {
			window
					.open(
							'Dpat.do?command=ToMoveIndicatore&cessato=' + cessato+'&anno='+<%=IstanzaDpat.getAnno() %>
									+ '&tipoPianoAtt='
									+ tipo_piano_attivita_ind
									+ '&idPianoRiferimento='
									+ idPianoRiferimento,
							null,
							'scrollbar=yes,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,modal=yes');
		} else {
			if (confirm('ATTENZIONE SU QUESTO RECORD CI SONO MODIFICHE NON ATTUALIZZATE . PROCEDERE COMUNQUE CON LA MODIFICA ?')) {

				window
						.open(
								'Dpat.do?command=ToMoveIndicatore&cessato=' + cessato+'&anno='+<%=IstanzaDpat.getAnno() %>
										+ '&tipoPianoAtt='
										+ tipo_piano_attivita_ind
										+ '&idPianoRiferimento='
										+ idPianoRiferimento,
								null,
								'scrollbar=yes,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,modal=yes');
			}

		}
	}
	
	function openNotePianoMonitoraggioReplaceAttivita(dataScadenza, idPianoRiferimento,
			tipo_piano_attivita_ind, cessato) {
		var res;
		var result;
		// tipoInserimento : up , down ,firstchild

		if (dataScadenza == '' || dataScadenza == 'null'
				|| dataScadenza == null) {
			window
					.open(
							'Dpat.do?command=ToMoveAttivita&cessato=' + cessato+'&anno='+<%=IstanzaDpat.getAnno() %>
									+ '&tipoPianoAtt='
									+ tipo_piano_attivita_ind
									+ '&idPianoRiferimento='
									+ idPianoRiferimento,
							null,
							'scrollbar=yes,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,modal=yes');
		} else {
			if (confirm('ATTENZIONE SU QUESTO RECORD CI SONO MODIFICHE NON ATTUALIZZATE . PROCEDERE COMUNQUE CON LA MODIFICA ?')) {

				window
						.open(
								'Dpat.do?command=ToMoveAttivita&cessato=' + cessato+'&anno='+<%=IstanzaDpat.getAnno() %>
										+ '&tipoPianoAtt='
										+ tipo_piano_attivita_ind
										+ '&idPianoRiferimento='
										+ idPianoRiferimento,
								null,
								'scrollbar=yes,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,modal=yes');
			}

		}
	}

	var colorprec = '';
	function hover(item) {

		$('#elenco tr').hover(function() {
			colorprec = $(this).css('background-color');
			$(this).css('background', '#dedede');
		}, function() {
			$(this).css('background', colorprec);
		});
	}

	function ricaricaPiani() {

		if (document.getElementById("checkAtt").checked) {
			location.href = "Dpat.do?command=SearchPianiMonitoraggio&includiAttivita=si";
		} else {
			location.href = "Dpat.do?command=SearchPianiMonitoraggio&includiAttivita=no";
		}

	}
</script>
<%-- Trails --%>
<table class="trails" cellspacing="0">
	<tr>
		<td>Elenco</td>
	</tr>
</table>

<%
	int tipo_piano = -1;
	String descrizione_piano = "";
	if (request.getAttribute("searchcodetipo_piano") != null)
		tipo_piano = (Integer) request.getAttribute("searchcodetipo_piano");
	if (request.getAttribute("searchdescrizione_piano") != null)
		descrizione_piano = (String) request.getAttribute("searchdescrizione_piano");
%>




<div align="left">

<font color="red" size="4">ATTENZIONE! Tramite Questa configurazione verrà composto il  foglio  attività. <br>
Appena completato le modifiche occorre cliccare sul pulsante congela configurazione per abilitare i motivi di ispezione semplice nei controlli.<br>
Le modifiche successive alla congelazione saranno ATTIVE solo nei controlli e non sul foglio Attività.</font>
</div>

<div align="right">

<input type="button" onclick="loadModalWindow();location.href='Dpat.do?command=DpatPreviewGenerale&anno=<%=IstanzaDpat.getAnno() %>'" value="Visualizza Anteprima Dpat">
	<%
		if (!IstanzaDpat.getStato().equals("2")) {
	%>


	<input type="button" value="Congela Configurazione"
		onClick="if(confirm('Attenzione ! In Dopo La congelazione le modifiche non avranno piu impatto sul foglio Attivita. LE modifiche verranno Propagate solo nei controlli')==true) {location.href='Dpat.do?command=CongelaConfigurazioneDpat&idDpatIstanza=<%=IstanzaDpat.getAnno()%>';}"
		style="background-color: #FF4D00; font-weight: bold;" />

	<%
		}
	%>
</div>


<br>
<br>
<%
	int year = Calendar.getInstance().get(Calendar.YEAR);
%>




<%=(request.getAttribute("ErrorDpat") != null) ? "<font color='red'>"
					+ request.getAttribute("ErrorDpat") + "</font>" : ""%>

<!-- <input type="button" value="Raggruppa Piani Selezionati" onclick="alert('Dovrebbe raggruppare i piani padre selezionati contigui !!')"> -->



<br>
<dhv:pagedListStatus title="" object="TicListPianiInfo" />
<table cellpadding="4" cellspacing="0" width="100%" class="details"
	id="elenco">
	<tr>
		<th>Codice</th>
		<th>Alias</th>
		<th>Tipo Attivita</th>
		<th>Descrizione</th>
		<th>CodiceEsame</th>
		<th>Asl</th>
		
		<th>&nbsp;</th>
	</tr>
	<%
		Iterator<DpatPiano> itPiani = null;
		Iterator<DpatSezione> itSezioni = IstanzaDpat.getDpat().getElencoSezioni().iterator();
		if (itSezioni.hasNext()) {
			while (itSezioni.hasNext()) {
				DpatSezione sezione = (DpatSezione) itSezioni.next();
				String color = "#FFF";
				if (sezione.getDescription().equalsIgnoreCase("sezione a")) {
					color = "#ABDC53";
				} else if (sezione.getDescription().equalsIgnoreCase("sezione b")) {
					color = "#00BFFF";
				} else if (sezione.getDescription().equalsIgnoreCase("sezione c")) {
					color = "#DA70D6";
				} else if (sezione.getDescription().equalsIgnoreCase("sezione d")) {
					color = "#FFBF00";
				} else if (sezione.getDescription().equalsIgnoreCase("sezione e")) {
					color = "#964B00";
				}
				itPiani = sezione.getElencoPiani().iterator();
	%>

	<tr>
		<td colspan="6" style="background-color: <%=color%>" valign="center"><center><%=sezione.getDescription().toUpperCase()%></center></td>
	</tr>


	<%
		while (itPiani.hasNext()) {
					DpatPiano piano = itPiani.next();
	%>
	<%
		Iterator<DpatAttivita> itAttivita = piano.getElencoAttivita().iterator();
					while (itAttivita.hasNext()) {
						DpatAttivita attivita = itAttivita.next();
	%>
	<tr>
	<td style="background-color: <%=color%>"><a href=  "#" onclick = "apriDettaglioAttivita(<%=attivita.getId() %>,<%=IstanzaDpat.getAnno() %>)" ><%=toHtml2(attivita.getCodiceAlias()).toUpperCase()%>&nbsp;</a></td>
		<td style="background-color: <%=color%>"><%=toHtml2(attivita.getAlias()).toUpperCase()%>&nbsp;</td>
		<td style="background-color: <%=color%>"><%=toHtml2(attivita.getTipoAttivita()).toUpperCase()%>&nbsp;</td>
		<td style="background-color: <%=color%>"><%=piano.getDescription() + ":" + attivita.getDescription().toUpperCase()%></td>

		<td style="background-color: <%=color%>">&nbsp;<%=toHtml2(attivita.getCodiceEsame())%>&nbsp;
		</td>
		<td style="background-color: <%=color%>">&nbsp;<%=toHtml2(lookup_asl.getSelectedValue(attivita.getAsl()))%>&nbsp;
		</td>

		
		<td>
			<%
				if (attivita.getElencoIndicatori().size() == 0) {
			%>
			<table class="noborder">
				<tr>

					<td><a
						href="javascript:openNotePianoMonitoraggioAdd('firstchild',<%=attivita.getId()%>,'no','dpat_indicatore')"><img
							title="Aggiungi Sottopiano a <%=piano.getDescription()%>"
							width="25px" height="25px"
							src="./cu_programmazioni/image/add.png"></a></td>
					<td><a
						href="javascript:openNotePianoMonitoraggioAdd('up',<%=attivita.getId()%>,'no','dpat_attivivita')"><img
							title="Aggiungi Piano Fratello Sopra <%=attivita.getDescription()%>"
							width="25px" height="25px"
							src="./cu_programmazioni/image/add_up_padre.png"></a></td>
					<td><a
						href="javascript:openNotePianoMonitoraggioAdd('down',<%=attivita.getId()%>,'no','dpat_attivivita')"><img
							title="Aggiungi Piano Fratello Sotto <%=attivita.getDescription()%>"
							width="25px" height="25px"
							src="./cu_programmazioni/image/add_down_padre.png"></a></td>

					<td><img style="opacity: 0.2" width="25px" height="25px"
						src="./cu_programmazioni/image/addup.png"></td>
					<td><img style="opacity: 0.2" width="25px" height="25px"
						src="./cu_programmazioni/image/adddown.png"></td>
					<td><a
						href="javascript:openNotePianoMonitoraggioReplaceAttivita('<%=attivita.getDataScadenza()%>',<%=attivita.getId()%>,'dpat_attivivita','no')"><img
							title="ESEGUI VARIAZIONE SUL PIANO/ATTIVITA (LE POSSIBILI VARIAZIONI SONO DEL TIPO MODIFICA O SPOSTAMENTO)"
							width="25px" height="25px"
							src="./cu_programmazioni/image/edit.jpg"></a></td>
					<td><a
						href="javascript:openNotePianoMonitoraggioReplace('<%=attivita.getDataScadenza()%>',<%=attivita.getId()%>,'dpat_attivivita','si')"><img
							title="Rendi Obsoleto <%=attivita.getDescription()%>"
							width="25px" height="25px"
							src="./cu_programmazioni/image/remove.png"></a></td>
				</tr>
			</table> <%
 	} else {
 %>
			<table class="noborder">
				<tr>
					<td><img
						title="Aggiungi Sottopiano a <%=attivita.getDescription()%>"
						width="25px" height="25px" src="./cu_programmazioni/image/add.png"
						style="opacity: 0.2"></td>
					<td><a
						href="javascript:openNotePianoMonitoraggioAdd('up',<%=attivita.getId()%>,'no','dpat_attivivita')"><img
							title="Aggiungi Piano Fratello Sopra <%=attivita.getDescription()%>"
							width="25px" height="25px"
							src="./cu_programmazioni/image/add_up_padre.png"></a></td>
					<td><a
						href="javascript:openNotePianoMonitoraggioAdd('down',<%=attivita.getId()%>,'no','dpat_attivivita')"><img
							title="Aggiungi Piano Fratello Giu <%=attivita.getDescription()%>"
							width="25px" height="25px"
							src="./cu_programmazioni/image/add_down_padre.png"></a></td>
					<td><img style="opacity: 0.2" width="25px" height="25px"
						src="./cu_programmazioni/image/addup.png"></td>
					<td><img style="opacity: 0.2" width="25px" height="25px"
						src="./cu_programmazioni/image/adddown.png"></td>
					<td><a
						href="javascript:openNotePianoMonitoraggioReplaceAttivita('<%=attivita.getDataScadenza()%>',<%=attivita.getId()%>,'dpat_attivivita','no')"><img
							title="ESEGUI VARIAZIONE SUL PIANO/ATTIVITA (LE POSSIBILI VARIAZIONI SONO DEL TIPO MODIFICA O SPOSTAMENTO)"
							width="25px" height="25px"
							src="./cu_programmazioni/image/edit.jpg"></a></td>
					<td><a
						href="javascript:openNotePianoMonitoraggioReplace('<%=attivita.getDataScadenza()%>',<%=attivita.getId()%>,'dpat_attivivita','si')"><img
							title="Rendi Obsoleto <%=attivita.getDescription()%>"
							width="25px" height="25px"
							src="./cu_programmazioni/image/remove.png"></a></td>


				</tr>
			</table> <%
 	}
 %>
		</td>
	</tr>



	<%
		if (attivita.getElencoIndicatori().size() > 0) {
							for (DpatIndicatore sp : attivita.getElencoIndicatori()) {
	%>
	<tr>
	<td style="background-color: <%=color%>"><a href=  "#" onclick = "apriDettaglioIndicatore(<%=sp.getId() %>,<%=IstanzaDpat.getAnno() %>)" ><%=toHtml2(sp.getCodiceAlias()).toUpperCase()%>&nbsp;</a></td>
		<td style="background-color: <%=color%>"><%=toHtml2(sp.getAlias()).toUpperCase()%>&nbsp;</td>
		<td style="background-color: <%=color%>"><%=toHtml2(sp.getTipoAttivita()).toUpperCase()%>&nbsp;</td>

		<td style="background-color: <%=color%>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=sp.getDescription().toUpperCase()%></td>

		<td style="background-color: <%=color%>">&nbsp;<%=toHtml2(sp.getCodiceEsame())%>&nbsp;
		</td>
		<td style="background-color: <%=color%>">&nbsp;<%=toHtml2(lookup_asl.getSelectedValue(sp.getAsl()))%>&nbsp;
		</td>
		
		<td>
			<table class="noborder">
				<tr>
					<td><img
						title="Aggiungi Sottopiano a <%=sp.getDescription()%>"
						width="25px" height="25px" src="./cu_programmazioni/image/add.png"
						style="opacity: 0.2"></td>

					<td><img style="opacity: 0.2" width="25px" height="25px"
						src="./cu_programmazioni/image/add_up_padre.png"></td>
					<td><img style="opacity: 0.2" width="25px" height="25px"
						src="./cu_programmazioni/image/add_down_padre.png"></td>

					<td><a
						href="javascript:openNotePianoMonitoraggioAdd('up',<%=sp.getId()%>,'no','dpat_indicatore')"><img
							title="Aggiungi Piano Fratello Sopra <%=sp.getDescription()%>"
							width="25px" height="25px"
							src="./cu_programmazioni/image/addup.png"></a></td>
					<td><a
						href="javascript:openNotePianoMonitoraggioAdd('down',<%=sp.getId()%>,'no','dpat_indicatore')"><img
							title="Aggiungi Piano Fratello Giu <%=sp.getDescription()%>"
							width="25px" height="25px"
							src="./cu_programmazioni/image/adddown.png"></a></td>
					<td><a
						href="javascript:openNotePianoMonitoraggioReplaceIndicatore('<%=sp.getDataScadenza()%>',<%=sp.getId()%>,'dpat_indicatore','no')"><img
							title="ESEGUI VARIAZIONE SU indicatore (LE POSSIBILI VARIAZIONI SONO DEL TIPO MODIFICA O SPOSTAMENTO)"
							width="25px" height="25px"
							src="./cu_programmazioni/image/edit.jpg"></a></td>
					<td><a
						href="javascript:openNotePianoMonitoraggioReplace('<%=sp.getDataScadenza()%>',<%=sp.getId()%>,'dpat_indicatore','si')"><img
							title="Rendi Obsoleto <%=sp.getDescription()%>" width="25px"
							height="25px" src="./cu_programmazioni/image/remove.png"></a></td>
				</tr>
			</table>
		</td>
	</tr>
	<%
		}
						}
					}
				}

			}
	%>

</table>
<%
	} else {
%>
<tr class="containerBody">
	<td colspan="<%=3%>">Nessuna Piano Trovata</td>
</tr>
</table>
<%
	}
%>
<dhv:pagedListControl object="TicListPianiInfo" tdClass="row1" />
<br>
<br>

