<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio"%>


<%@page
	import="org.aspcfs.modules.macellazioni.base.Casl_Non_Conformita_Rilevata"%>
<%@page import="org.aspcfs.modules.macellazioni.base.ProvvedimentiCASL"%>
<%@page import="org.aspcfs.modules.macellazioni.base.NonConformita"%>
<%@page import="org.aspcfs.modules.macellazioni.base.Campione"%><%@page
	import="org.aspcfs.modules.macellazioni.base.Organi"%>
<%@page import="org.aspcfs.modules.macellazioni.base.PatologiaRilevata"%>

<%@page import="org.aspcfs.modules.util.imports.ApplicationProperties"%>

<%@page import="org.aspcfs.modules.macellazioni.base.TipoRicerca"%><jsp:useBean
	id="Tampone" class="org.aspcfs.modules.macellazioni.base.Tampone"
	scope="request" />

<jsp:useBean id="OrgDetails"
	class="org.aspcfs.modules.stabilimenti.base.Organization"
	scope="request" />
<jsp:useBean id="Speditore"
	class="org.aspcfs.modules.speditori.base.Organization" scope="request" />
<jsp:useBean id="SpeditoreAddress"
	class="org.aspcfs.modules.speditori.base.OrganizationAddress"
	scope="request" />
<jsp:useBean id="Capo" class="org.aspcfs.modules.macellazioni.base.Capo"
	scope="request" />
<jsp:useBean id="NCVAM" class="java.util.ArrayList" scope="request" />
<jsp:useBean id="Campioni" class="java.util.ArrayList" scope="request" />
<jsp:useBean id="OrganiList" class="java.util.ArrayList" scope="request" />
<jsp:useBean id="OrganiListNew" class="java.util.TreeMap"
	scope="request" />
<jsp:useBean id="PatologieRilevate" class="java.util.ArrayList"
	scope="request" />
<jsp:useBean id="casl_NCRilevate" class="java.util.ArrayList"
	scope="request" />
<jsp:useBean id="MatriciTamponi" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="AnalisiTamponi" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="PianiMonitoraggio"
	class="org.aspcfs.utils.web.LookupList" scope="request" />

<jsp:useBean id="casl_Provvedimenti_effettuati"
	class="java.util.ArrayList" scope="request" />

<jsp:useBean id="Nazioni" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="Matrici" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="ASL" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="LuoghiVerifica" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="Regioni" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="Razze" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="Specie" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="CategorieBovine"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="CategorieBufaline"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="PianiRisanamento"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="BseList" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="TipiMacellazione"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="EsitiVpm" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="Patologie" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="PatologieOrgani"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="Azioni" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="Stadi" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="Organi" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="TipiAnalisi" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="Molecole" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="TipiNonConformita"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="MotiviASL" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="ProvvedimentiVAM"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="look_ProvvedimentiCASL"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="EsitiCampioni" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="MotiviCampioni" class="org.aspcfs.utils.web.LookupList"
	scope="request" />


<!-- Lookup istopatologico -->
<jsp:useBean id="listaDestinatariRichiestaIstopatologico"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="lookup_alimentazione"
	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="lookup_habitat"
	class="org.aspcfs.utils.web.LookupList" scope="request" />

<%@ include file="../initPage.jsp"%>

<link type="text/css" href="css/ui.all.css" rel="stylesheet" />
<link type="text/css" href="css/demos.css" rel="stylesheet" />
<script language="JavaScript" TYPE="text/javascript"
	SRC="javascript/popCalendar.js"></script>

<script type="text/javascript" src="javascript/jquery-1.8.min.js"></script>
<script type="text/javascript" src="javascript/ui.core.js"></script>
<script type="text/javascript" src="javascript/ui.tabs.js"></script>

<!-- RELATIVO AL NUOVO CALENDARIO CON MESE E ANNO FACILMENTE MODIFICABILI -->
<SCRIPT LANGUAGE="JavaScript" SRC="javascript/CalendarPopup.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="javascript/common.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	document.write(getCalendarStyles());
</SCRIPT>

<SCRIPT LANGUAGE="JavaScript" ID="js19">
	var cal19 = new CalendarPopup();
	cal19.showYearNavigation();
	cal19.showYearNavigationInput();
	cal19.showNavigationDropdowns();

	function svuotaData(input) {
		input.value = '';
	}
</SCRIPT>

<script type="text/javascript">
<!--
function controllaForm()
{
	
	try{
		var form = document.main;
		message ="";
		ret = true;	
		
		
		
	//	alert(document.getElementById("dataPrelievo").value);
		if (document.getElementById("dataPrelievo") == null ||
				document.getElementById("dataPrelievo").value == ""){
			message += label(""," La data di prelievo campioni non pu� essere vuota\r\n" );
			ret = false;
		}
		
		//var peso = $("#pesoAnimale").val();
	//	alert(peso);
	  /*   if (peso !== "" && isNaN(peso))		
	{
			message += label(""," Il valore peso animale deve essere di tipo numerico\r\n" );
			ret = false;
		} */
		
		
		 if (ret == false) {
			
      		alert(label("", "La form non puo' essere salvata, verifica i seguenti errori:\r\n\r\n") + message);
    	}
		 else{
			 document.main.submit();
		}

		
	  }
	catch(err)
	  {
		alert(err);
	  }

	return ret;
}

$(document).ready(function() {
	
	$("#tabs").tabs().addClass('ui-tabs-vertical ui-helper-clearfix');
	$("#tabs li").removeClass('ui-corner-top').addClass('ui-corner-left');

}); 

//-->
</script>

<%
	String param1 = "orgId=" + OrgDetails.getOrgId();
	String param2 = "capoId=" + Capo.getId();
%>

<table class="trails" cellspacing="0">
	<tr>
		<td>
			<a href="Stabilimenti.do"><dhv:label name="stabilimenti.stabilimenti">Accounts</dhv:label></a> >
		
					<a href="Stabilimenti.do?command=Search"><dhv:label
					name="stabilimenti.SearchResults">Search Results</dhv:label></a> >
					<a href="Stabilimenti.do?command=Details&orgId=<%=OrgDetails.getOrgId()%>">Scheda Stabilimento</a> >
	
			
			<a href="Macellazioni.do?command=List&orgId=<%=OrgDetails.getOrgId()%>">Macellazioni Ovicaprini</a> > 
			<a href="Macellazioni.do?command=Details&orgId=<%=OrgDetails.getOrgId()%>&id=<%=Capo.getId()%>">Dettaglio capo</a>	> Richiesta istopatologico		
		</td>
	</tr>
</table>
<dhv:container
	name="<%=(OrgDetails.isMacelloUngulati()) ? ("stabilimenti_macellazioni_ungulati") : ("stabilimenti")%>"
	selected="macellazioni" object="OrgDetails" param="<%=param1%>"
	appendToUrl='<%=addLinkParams(request, "popup|popupType|actionId")%>'
	hideContainer="<%=!OrgDetails.getEnabled() || OrgDetails.isTrashed()%>">

	<br />


	<br />
	<br />


<div class="demo">
<div id="tabs">
<ul>
		<li id="li-1" ><a href="#tabs-1">Richiesta istopatologico</a></li>
	</ul>
<div id="tabs-1">

	<form name="main" action="Macellazioni.do?command=SaveIstopatologico&auto-populate=true<%=addLinkParams(request, "popup|popupType|actionId")%>"
		method="post" onsubmit="return controllaForm();">
		<div >
COMPILAZIONE SCHEDA ANAMNESTICA PER CAMPIONI PROVENIENTI DA ANIMALI DI REDDITO DA SOTTOPORRE AD ESAME ISTOPATOLOGICO 
		</div>
		<br></br>
		<div>
			Seleziona destinatario richiesta
			<%=listaDestinatariRichiestaIstopatologico.getHtmlSelect("idDestinatarioRichiesta", -1)%>
		</div>
		<div>
		<input type="hidden" name="idCapo" id="idCapo" value="<%=Capo.getId() %>" />
			Data prelievo: <input readonly type="text"
				name="dataPrelievo" size="10"
				value="<%=DateUtils.timestamp2string(Capo.getVpm_data())%>" id="dataPrelievo" />&nbsp;
			<a href="#"
				onClick="cal19.select(document.forms[0].dataPrelievo,'anchor19','dd/MM/yyyy'); return false;"
				NAME="anchor19" ID="anchor19"> <img
				src="images/icons/stock_form-date-field-16.gif" border="0"
				align="absmiddle"></a> <a style="cursor: pointer;" href="#"
				onclick="svuotaData(document.forms[0].dataPrelievo);"><img
				src="images/delete.gif" align="absmiddle" /></a> <font color="red">*</font>

			<div>Veterinario prelevatore:</div>
			<div>
				Cognome:
				<%=Capo.getVpm_veterinario()%>
				<input type= "hidden" name="nominativoVeterinarioPrelevatore" id="nominativoVeterinarioPrelevatore" value="<%=Capo.getVpm_veterinario() %>"/>
				</div>

			<br></br>
			<div class="sezione_macello">
				Luogo del prelievo:
				<table border="1" width="50%">
					<tr>
						<td>Macello<br> <%=OrgDetails.getName()%></td>
						<td>Numero di riconoscimento<br><%=OrgDetails.getApprovalNumber()%>
						</td>
						<td>Telefono<br><%=(OrgDetails.getPrimaryPhoneNumber() != null && !("").equals(OrgDetails
						.getPrimaryPhoneNumber())) ? OrgDetails.getPrimaryPhoneNumber() : "---"%></td>
					</tr>
				</table>

			</div>


			<br></br>
			<div class="sezione_provenienza">
				Provenienza del capo:
				<table border="1" width="50%">
					<tr>
					<%String asl = "";
		/* 			 if (Capo.getCod_asl_azienda_prov() != null || !("").equals(Capo.getCod_asl_azienda_prov()))
						// asl = ASL.getSelectedValue(Capo.getCod_asl_azienda_prov()); */
					// else 
						if ((Capo.getCod_asl_azienda_prov() == null || ("").equals(Capo.getCod_asl_azienda_prov()) )&& Capo.getDenominazione_asl_azienda_prov() != null && !("").equals(Capo.getDenominazione_asl_azienda_prov()))
						 asl = Capo.getDenominazione_asl_azienda_prov();
					 
					%>
						<td>Specie<br> <%=Specie.getSelectedValue(Capo.getCd_specie())%><br>Razza<br><%=(Capo.getCd_id_razza() > 0) ? Razze.getSelectedValue(Capo.getCd_id_razza()) : "N.D."%></td>
						<td>Ragione sociale allevamento<br><%=Capo.getRag_soc_azienda_prov()%>
						<input type="hidden" value="<%=Capo.getRag_soc_azienda_prov()%>" name="ragioneSocialeAllevamentoProvenienzaCapo" id="ragioneSocialeAllevamentoProvenienzaCapo" /></td></td>
						<td>Codice allevamento<br><%=Capo.getCd_codice_azienda_provenienza()%>
						<input type="hidden" value="<%=Capo.getCd_codice_azienda_provenienza()%>" name="codiceAllevamentoProvenienza" id="codiceAllevamentoProvenienza" /></td>
						<td>ASL provenienza Capo <br><%=(!("").equals(asl)) ? asl : ASL.getSelectedValue(Capo.getCod_asl_azienda_prov()) %>
						<input type="hidden" value="<%=(Capo.getCod_asl_azienda_prov() == null || ("").equals(Capo.getCod_asl_azienda_prov()) ) ? asl : "" %>" name="denominazioneAsl" id="denominazioneAsl"/>
						<input type="hidden" value="<%=Capo.getCod_asl_azienda_prov() %>" name="idAslProvenienzaCapo" id="idAslProvenienzaCapo"/>
						</td>
					</tr>
				</table>

			</div>

			<br></br>
			<div class="sezione_animale">
				Segnalamento dell'animale:
				<table border="1" width="50%">
					<tr>
					<%String categoria = "";
						categoria = 	(Capo.getCd_categoria_bovina() > 0) ? CategorieBovine.getSelectedValue(Capo.getCd_categoria_bovina()) : CategorieBufaline.getSelectedValue(Capo.getCd_categoria_bufalina());
					%>
						<td>Categoria<br> <%=(!("").equals(categoria))? categoria : "N.D"%></td>
						<td>Data di nascita<br><%=DateUtils.timestamp2string(Capo.getCd_data_nascita())%></td>
						<td>Sesso<br><%=(Capo.isCd_maschio()) ? "M" : "F"%></td>
						<td>Marca auricolare <br><%=Capo.getCd_matricola()%></td>
					</tr>
				</table>

			</div>
			
		<%-- 				<br></br>
			<div class="sezione_dati_generici_animale">
				Dati generici sul capo:
				<table border="1" width="50%">
					<tr>
						<td>Habitat<br><%=lookup_habitat.getHtmlSelect("idHabitatAnimale", -1)%></td>
						<td>Alimentazione<br><%=lookup_alimentazione.getHtmlSelect("idAlimentazioneAnimale", -1)%>
						<td>Peso (in kg):<br><input type="text" value="" name="pesoAnimale" id="pesoAnimale">
					</tr>
				</table>

			</div> --%>


			<br></br>
			<div class="sezione_organi_prelevati">
				Organi prelevati:
				<table border="1" width="50%">
					<tr>
						<th>Organo</th>
						<th>Topografia</th>
						<th>Interessamento altri organi</th>
					</tr>
					<%
						Iterator i = OrganiList.iterator();
							while (i.hasNext()) {
								Organi thisOrgano = (Organi) i.next();
					%>

					<tr>
						<td style="text-align: center;"><%=Organi.getSelectedValue(thisOrgano.getLcso_organo())%><input type="hidden" value="<%=thisOrgano.getId()%>" name="organi_id_<%=thisOrgano.getId()%>" id="organi_id_<%=thisOrgano.getId()%>"/></td>
						<td style="text-align: center;"><input type="text" name="istopatologico_topografia_<%=thisOrgano.getId()%>" id="istopatologico_topografia_<%=thisOrgano.getId()%>" /></td>
						<td style="text-align: center;"><input type="text" name="istopatologico_interessamento_altri_organi_<%=thisOrgano.getId()%>" id="istopatologico_interessamento_altri_organi_<%=thisOrgano.getId()%>" /></td>
						

					</tr>
					<%
						}
					%>
				</table>

			</div>
<br></br>
			<div class="sezione_osservazioni_veterinario">
				Osservazioni del veterinario:<br>
<textarea rows="8" cols="80" name="noteRichiesta" id="noteRichiesta"></textarea>
			</div>




		</div>
		
<input type="submit" value="Salva" >
	</form></div></div></div>
</dhv:container>

