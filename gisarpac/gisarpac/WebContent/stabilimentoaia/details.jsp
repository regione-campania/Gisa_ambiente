
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="org.aspcfs.modules.aia.base.StabilimentoAIA"%>
<%@page import="org.aspcfs.modules.aia.base.ImpresaAIA"%>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>
<script language="JavaScript" TYPE="text/javascript"
	SRC="dwr/interface/PopolaCombo.js"> </script>
	
<html>
<head>
<jsp:useBean id="StabilimentoDettaglio"
	class="org.aspcfs.modules.aia.base.StabilimentoAIA" scope="request" />
<jsp:useBean id="ImpresaDettaglio"
	class="org.aspcfs.modules.aia.base.ImpresaAIA" scope="request" />
<jsp:useBean id="JsonIPPC" class="org.json.JSONArray" scope="request" />
<jsp:useBean id="JsonDecreti" class="org.json.JSONArray" scope="request" />
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body>












	<script language="JavaScript" type="text/javascript"
		src="dwr/interface/PopolaCombo.js">
		
	</script>



	<link rel="stylesheet" type="text/css"
		href="css/jquery.calendars.picker.css">
	<link href="javascript/datepicker/jquery.datepick.css" rel="stylesheet">
	<script type="text/javascript" src="javascript/jquery.calendars.js"></script>
	<script type="text/javascript"
		src="javascript/jquery.calendars.plus.js"></script>
	<script type="text/javascript" src="javascript/jquery.plugin.js"></script>
	<script type="text/javascript"
		src="javascript/jquery.calendars.picker.js"></script>
	<script src="javascript/parsedate.js"></script>

	<script src="javascript/datepicker/jquery.plugin.js"></script>
	<script src="javascript/datepicker/jquery.datepick.js"></script>

	<script language="JavaScript" src="javascript/CalendarPopup.js"></script>
	<script language="JavaScript">
		document.write(getCalendarStyles());
	</script>

	<script language="JavaScript" id="js19">
		var cal19 = new CalendarPopup();
		cal19.showYearNavigation();
		cal19.showYearNavigationInput();
		cal19.showNavigationDropdowns();
	</script>
	<style>
.ovale {
	border-style: solid;
	border-color: #405c81;
	border-width: 1px;
}

input[type=button], input[type=submit], input[type=reset] {
	font-size: 15px;
}
</style>



	<script>
		function openPopup(url) {

			var res;
			var result;
			window
					.open(
							url,
							'popupSelect',
							'height=600px,width=600px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		}
		function openPopupLarge(url) {

			var res;
			var result;
			window
					.open(
							url,
							'popupSelect',
							'height=600px,width=1400px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
		}

		function checkFieldRiattivazione() {
			var msg = "Attenzione controllare che i seguenti campi siano valorizzati : \n";
			formTest = true;
			if ($("#dataRiattivazione2").val() == "") {
				formTest = false;
				msg += "- Controllare il Campo Data Riattivazione\n";
			}

			if ($("#decretoRiattivazione").val() == "") {
				formTest = false;
				msg += "- Controllare il Campo Decreto Riattivazione\n";
			}

			var checkedVal = $('input[name=idLineaProduttivaRiattivazione]:checked');

			if (checkedVal.length == 0) {
				formTest = false;
				msg += "- Controllare di aver Spuntato almeno un codice IPPC \n";
			}

			if (formTest == false)
				alert(msg);

			return formTest;

		}

		$(function() {

			// NUOVA GESTIONE BOTTONI
			$("#dialogModifica").dialog({
				autoOpen : false,
				resizable : false,
				closeOnEscape : false,
				title : "Operazioni di modifica",
				width : 850,
				height : 250,
				draggable : false,
				modal : true,
				buttons : {

					"ESCI" : function() {
						$(this).dialog("close");
					}

				},
				show : {
					effect : "blind",
					duration : 1000
				},
				hide : {
					effect : "explode",
					duration : 1000
				}

			}).prev(".ui-dialog-titlebar").css("background", "#bdcfff");

			$("#dialogSincronizzazioneAltriSistemi").dialog({
				autoOpen : false,
				resizable : false,
				closeOnEscape : false,
				title : "Operazioni di sincronizzazione",
				width : 850,
				height : 250,
				draggable : false,
				modal : true,
				buttons : {

					"ESCI" : function() {
						$(this).dialog("close");
					}

				},
				show : {
					effect : "blind",
					duration : 1000
				},
				hide : {
					effect : "explode",
					duration : 1000
				}

			}).prev(".ui-dialog-titlebar").css("background", "#bdcfff");

			$("#dialogPreaccettazione").dialog({
				autoOpen : false,
				resizable : false,
				closeOnEscape : false,
				title : "Operazioni su preaccettazione",
				width : 850,
				height : 250,
				draggable : false,
				modal : true,
				buttons : {

					"ESCI" : function() {
						$(this).dialog("close");
					}

				},
				show : {
					effect : "blind",
					duration : 1000
				},
				hide : {
					effect : "explode",
					duration : 1000
				}

			}).prev(".ui-dialog-titlebar").css("background", "#bdcfff");

			// FINE NUOVA GESTIONE BOTTONI -->

			$("#dialogGestioneScia").dialog({
				autoOpen : false,
				resizable : false,
				closeOnEscape : false,
				title : "Operazioni di modifica stabilimento",
				width : 850,
				height : 500,
				draggable : false,
				modal : true,
				buttons : {

					"ESCI" : function() {
						$(this).dialog("close");
					}

				},
				show : {
					effect : "blind",
					duration : 1000
				},
				hide : {
					effect : "explode",
					duration : 1000
				}

			}).prev(".ui-dialog-titlebar").css("background", "#bdcfff");

			$("#dialogRiattivazione").dialog({
				autoOpen : false,
				resizable : false,
				closeOnEscape : false,
				title : "RIATTIVAZIONE PER CODICE IPPC",
				width : 850,
				height : 500,
				draggable : false,
				modal : true,
				buttons : {

					"ESCI" : function() {
						$(this).dialog("close");
					}

				},
				show : {
					effect : "blind",
					duration : 1000
				},
				hide : {
					effect : "explode",
					duration : 1000
				}

			}).prev(".ui-dialog-titlebar").css("background", "#bdcfff");

		});

		
	</script>


	<table class="trails" cellspacing="0">
		<tbody>
			<tr>
				<td width="100%"><a href="">Anagrafica stabilimenti</a> &gt; <a
					href="StabilimentoAIA.do?command=SearchForm">Ricerca</a> &gt; <a
					href="StabilimentoAIA.do?command=Search">Risultato ricerca</a> &gt;
					Scheda Anagrafica Impresa</td>
			</tr>
		</tbody>
	</table>


	<table>
		<tbody>
			<tr>


			</tr>
		</tbody>
	</table>





	<script language="JavaScript" type="text/javascript"
		src="gestione_documenti/generazioneDocumentale.js"></script>

	<div style="float: right; padding: 50px">

		<img src="images/icons/stock_print-16.gif" border="0"
			align="absmiddle" height="16" width="16"> <input type="button"
			title="Stampa Scheda" value="Stampa Scheda"
			onclick="openRichiestaPDFAiaAnagrafica('<%=StabilimentoDettaglio.getIdStabilimento()%>', '1');"> <br>

	</div>
	<%
	String param = "stabId="+StabilimentoDettaglio.getIdStabilimento();

	%>
<dhv:container name="aia" object="StabilimentoDettaglio" selected="details"  param="<%=param%>"  hideContainer="false">

	
<br><br>

										<center>
											<table style="border: 1px solid black" cellpadding="20"
												cellspacing="20">

												<tbody>
													<tr>

														<td><input type="button"
															title="GESTIONE STATO ANAGRAFICA"
															value="GESTIONE STATO ANAGRAFICA"
															onclick="openPopup('GestioneStatoAnagrafica.do?command=View&riferimentoId=<%=StabilimentoDettaglio.getIdStabilimento()%>&riferimentoIdNomeTab=aia_stabilimento')">
														</td>

														<td><input type="button"
															title="GESTIONE DATI AUTORIZZATIVI"
															value="GESTIONE DATI AUTORIZZATIVI"
															onclick="openPopupLarge('GestioneDatiAutorizzativi.do?command=View&riferimentoId=<%=StabilimentoDettaglio.getIdStabilimento()%>&riferimentoIdNomeTab=aia_stabilimento')">
														</td>

														<td><input type="button"
															title="GESTIONE DATI ACQUE REFLUE"
															value="GESTIONE DATI ACQUE REFLUE"
															 id="acque"
															onclick="openPopupLarge('GestioneDatiAcqueReflue.do?command=View&riferimentoId=<%=StabilimentoDettaglio.getIdStabilimento()%>&riferimentoIdNomeTab=aia_stabilimento')">
														</td>

													</tr>

												</tbody>
											</table>
										</center> <br> <script>
											
										</script> <script type="text/javascript"
											src="dwr/interface/PopolaCombo.js">
	
</script> <script type="text/javascript"
											src="dwr/interface/DwrPreaccettazione.js">
											
										</script> 
												
										<jsp:include page="../preaccettazionesigla/button_preaccettazione.jsp">
   										<jsp:param name="riferimentoIdPreaccettazione" value="<%=StabilimentoDettaglio.getIdStabilimento() %>" />
  										<jsp:param name="riferimentoIdNomePreaccettazione" value="stabId" />
  										<jsp:param name="riferimentoIdNomeTabPreaccettazione" value="aia_stabilimento" />
    									<jsp:param name="userIdPreaccettazione" value="<%=User.getUserId()%>" />
										</jsp:include>
										<input
										style="width: 250px" type="button" id="modificaDati"
										value="Modifica Dati" onclick="window.open('StabilimentoAIA.do?command=PrepareUpdate&stabId=<%=StabilimentoDettaglio.getIdStabilimento()%>','_self');">
										<input
										style="width: 250px" type="button" id="cambioTitolarita"
										value="Cambio titolarita'" onclick="window.open('StabilimentoAIA.do?command=PrepareCambio&stabId=<%=StabilimentoDettaglio.getIdStabilimento()%>','_self');">
										<input
										style="width: 250px" type="button" id="modificaIPPC" 
										value="Modifica Codici IPPC" onclick="window.open('StabilimentoAIA.do?command=PrepareUpdateIppc&stabId=<%=StabilimentoDettaglio.getIdStabilimento()%>','_self');">
									
									
									<script>
					
					(PopolaCombo.hasMatriceAnagrafica(<%=StabilimentoDettaglio.getIdStabilimento()%>, "aia_stabilimento", "ACQUE REFLUE", {callback:acqueReflue,async:true}));
						
					
					function acqueReflue(returnValue){
						
					//if(returnValue)
					//document.getElementById("acque").removeAttribute("hidden");
					}
					
					</script>	

<jsp:include page="../schede_centralizzate/iframe.jsp">
    <jsp:param name="objectId" value="<%=StabilimentoDettaglio.getIdStabilimento() %>" />
       <jsp:param name="objectIdName" value="stab_id" />
     <jsp:param name="tipo_dettaglio" value="1" />
     </jsp:include>

					</dhv:container>
					
					
					
</body>
</html>

