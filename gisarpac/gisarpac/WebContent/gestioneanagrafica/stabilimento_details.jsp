<%@page import="java.util.Date"%>
<%@page import="org.aspcfs.modules.opu.base.LineaProduttiva"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="StabilimentoDettaglio" class="org.aspcfs.modules.opu.base.Stabilimento" scope = "request"/>

  
  <%@ include file="../initPage.jsp" %>
  
<style>
	
	.dropbtn {
	}

	.dropdown {
	  position: relative;
	  display: inline-block;
	}
	
	.dropdown-content {
	  display: none;
	  position: absolute;
	  background-color: #E8E8E8;
	  overflow: auto;
	  box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
	  z-index: 1;
	}
	
	.dropdown-content a {
	  display: block;
	  padding: 12px 16px;
	  
	}
	
	
	.show {display: block;}
	
	/* Change color of dropdown links on hover */
	.dropdown-content a:hover {background-color: #D0D0D0}

</style>
  
  
  <script>
function refreshDimensioniIframe(){
	var iframe = document.getElementById("dettaglioTemplate");
	$(iframe).height($(iframe).contents().find('html').height());
}
</script>
  
<%-- Trails --%>
	<table class="trails" cellspacing="0">
	<tr>
		<td><a href="OpuStab.do?command=SearchForm">ANAGRAFICA STABILIMENTI</a> >  SCHEDA</td>
	</tr>
	</table>
<%-- Trails --%>

<%
String nomeContainer = "gestioneanagrafica";
request.setAttribute("Operatore",StabilimentoDettaglio.getOperatore());
String param = "altId="+StabilimentoDettaglio.getAltId();
%>

<%@ include file="../../controlliufficiali/diffida_list.jsp" %>


<div align="right">
<jsp:include page="../gestione_documenti/boxDocumentaleIframe.jsp">
<jsp:param name="iframeId" value="dettaglioTemplate" />
<jsp:param name="altId" value="<%=StabilimentoDettaglio.getAltId() %>" />
<jsp:param name="tipo" value="SchedaAnagrafica" />
</jsp:include>
</div>
<br/>

<!--  
<jsp:include page="../note_hd/link_note_hd.jsp">
<jsp:param name="riferimentoId" value="<%=StabilimentoDettaglio.getIdStabilimento() %>" />
<jsp:param name="riferimentoIdNomeTab" value="opu_stabilimento" />
<jsp:param name="typeView" value="button" />
</jsp:include>


<jsp:include page="../preaccettazionesigla/button_preaccettazione.jsp">    
    		<jsp:param name="riferimentoIdPreaccettazione" value="<%=StabilimentoDettaglio.getIdStabilimento() %>" />
    		<jsp:param name="riferimentoIdNomePreaccettazione" value="stabId" />
    		<jsp:param name="riferimentoIdNomeTabPreaccettazione" value="opu_stabilimento" />
   	 		<jsp:param name="userIdPreaccettazione" value="<%=User.getUserId() %>" />
</jsp:include>

<%if (!StabilimentoDettaglio.isLineePregresse()) {%>  
				<dhv:permission name="variazione_stato_stabilimento-view"> 
							<jsp:include page="../variazionestati/variazione.jsp">
								<jsp:param name="id" value="<%=StabilimentoDettaglio.getIdStabilimento() %>" />
								<jsp:param name="tipologia" value="999" />
							</jsp:include>			
				</dhv:permission>
			<%} %>



<dhv:permission name="gestioneanagrafica-modifica-scheda-view">
<div class="dropdown">
	<input type="button" onclick="mostraListaOperazioni('dropdownModificaSenzaScia')" value="Modifica anagrafica senza SCIA" class="dropbtn" style="width:250px"/>
		<div id="dropdownModificaSenzaScia" class="dropdown-content" style="width:250px">
			
			<dhv:permission name="gestioneanagrafica-errata-corrige-view">
				<a href="GestioneAnagraficaAction.do?command=Modify&altId=<%=StabilimentoDettaglio.getAltId() %>">ERRATA CORRIGE MODIFICA ANAGRAFICA</a>
			
				<a href="GestioneAnagraficaAction.do?command=ModifyGeneric&altId=<%=StabilimentoDettaglio.getAltId() %>&operazione=modifylinee">ERRATA CORRIGE MODIFICA LINEE</a>
			</dhv:permission>
			
			<dhv:permission name="opu-edit">
				<a href="#" onClick="openPopupLarge('OpuStab.do?command=ListaLivelliAggiuntivi&stabId=<%=StabilimentoDettaglio.getIdStabilimento()%>')">Livelli aggiuntivi masterlist</a>
			</dhv:permission>
			
			<dhv:permission name="gestioneanagrafica-aggiungi-linea-pregressa-view">
				<a href="GestioneAnagraficaAction.do?command=ModifyGeneric&altId=<%=StabilimentoDettaglio.getAltId() %>&operazione=lineapregressa">AGGIUNGI LINEA PREGRESSA</a>
			</dhv:permission>
			
		</div>
</div>
</dhv:permission>
-->

<dhv:permission name="gestioneanagrafica-modifica-scheda-view">
<div class="dropdown">
	<input type="button" onclick="mostraListaOperazioni('dropdownModifica')" value="Modifica dati scheda" class="dropbtn" style="width:250px"/>
		<div id="dropdownModifica" class="dropdown-content" style="width:250px">
			<%if(StabilimentoDettaglio.getTipoAttivita() == 1){ %>
				<a href="GestioneAnagraficaAction.do?command=ModifyGeneric&altId=<%=StabilimentoDettaglio.getAltId() %>&operazione=ampliamento">AMPLIAMENTO</a>
			<%} %>
			
			<%if(StabilimentoDettaglio.getStato() != 4) { %>
				<a href="GestioneAnagraficaAction.do?command=ModifyGeneric&altId=<%=StabilimentoDettaglio.getAltId() %>&operazione=cessazione">CESSAZIONE</a>
			<%} %>
			
				<a href="GestioneAnagraficaAction.do?command=TemplateVariazione&altId=<%=StabilimentoDettaglio.getAltId() %>">VARIAZIONE TITOLARITA'</a>
			
			<%if(StabilimentoDettaglio.getTipoAttivita() == 1){ %>
				<a href="GestioneAnagraficaAction.do?command=ModifyGeneric&altId=<%=StabilimentoDettaglio.getAltId() %>&operazione=modificaStatoDeiLuoghi">MODIFICA STATO DEI LUOGHI</a>
			
				<a href="GestioneAnagraficaAction.do?command=ModifyGeneric&altId=<%=StabilimentoDettaglio.getAltId() %>&operazione=trasferimentoSede">TRASFERIMENTO SEDE</a>
			<%} %>
			
			<%if(StabilimentoDettaglio.getTipoAttivita() == 2){ %>
				<a href="GestioneAnagraficaAction.do?command=ModifyGeneric&altId=<%=StabilimentoDettaglio.getAltId() %>&operazione=trasferimentoSede">CAMBIO SEDE LEGALE</a>
			<%} %>
		</div>
</div>
</dhv:permission>

<!-- 
<dhv:permission name="gestioneanagrafica-modifica-scheda-view">
<input type="button" onclick="loadModalWindowCustom('Attendere Prego...'); 
			window.location.href='GestioneAnagraficaAction.do?command=CreaPratica&altId=<%=StabilimentoDettaglio.getAltId() %>';" 
		value="Modifica anagrafica da pratica SCIA" style="width:250px"/>
</dhv:permission>
-->

<dhv:permission name="gestioneanagrafica-add">
	<input type="button" value="associa pratica" style="width:250px" 
		title="operazione che consente di associare a quest osa una pratica suap già inserita nel sistema"
		onclick="gestione_associa_pratica(<%=StabilimentoDettaglio.getSedeOperativa().getComune() %>, 
										  <%=StabilimentoDettaglio.getAltId() %>,
										  <%=StabilimentoDettaglio.getIdStabilimento() %>)"/>
	<div>
	<jsp:include page="../javascript/gestioneanagrafica/associa_pratica.jsp"/>
	</div>
</dhv:permission>

<!--  
<dhv:permission name = "opu-sposta-controlli-view">
	<br><br>
	<div>
	<jsp:include page="../dialog_convergenza_cu_elimina_anagrafica.jsp"/>
	</div>
</dhv:permission>
-->


<br><br>

<dhv:container name="<%=nomeContainer %>"  selected="details" object="Operatore" param="<%=param%>"  hideContainer="false">

<iframe scrolling="no" src="GestioneAnagraficaAction.do?command=TemplateDetails&altId=<%=StabilimentoDettaglio.getAltId() %>" id="dettaglioTemplate" style="top:0;left: 0;width:100%;height: 200%; border: none; " onload="refreshDimensioniIframe()"></iframe>

</dhv:container>

<script>


function mostraListaOperazioni(listadamostrare){
	
	var dropdowns = document.getElementsByClassName("dropdown-content");
    var i;
    for (i = 0; i < dropdowns.length; i++) {
      var openDropdown = dropdowns[i];
      if (openDropdown.classList.contains('show')) {
        openDropdown.classList.remove('show');
      }
    }
	
	document.getElementById(listadamostrare).classList.toggle("show");
}

//Close the dropdown if the user clicks outside of it
window.onclick = function(event) {
  if (!event.target.matches('.dropbtn')) {
    var dropdowns = document.getElementsByClassName("dropdown-content");
    var i;
    for (i = 0; i < dropdowns.length; i++) {
      var openDropdown = dropdowns[i];
      if (openDropdown.classList.contains('show')) {
        openDropdown.classList.remove('show');
      }
    }
  }
}

function openPopupLarge(url){
	
	  var res;
    var result;
    	  window.open(url,'popupSelect',
          'height=600px,width=1000px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=yes,resizable=yes ,modal=yes');
	}
</script>


