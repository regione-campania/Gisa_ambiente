
<%@page import="org.aspcfs.modules.gestioneml.base.SuapMasterListMacroarea"%>
<%@page import="com.aspcfs.modules.aziendezootecniche.base.IstanzaAllevamentoBdn"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,org.aspcfs.modules.allevamenti.base.*, org.aspcfs.modules.base.*" %>

<jsp:useBean id="IstanzaAllevamentoBdn" class="com.aspcfs.modules.aziendezootecniche.base.IstanzaAllevamentoBdn" scope="request"/>
<jsp:useBean id="AslList" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ListaMacroarea" class="org.aspcfs.modules.gestioneml.base.SuapMasterListMacroareaList" scope="request"/>


<%@ include file="../initPage.jsp" %>

<link rel="stylesheet" type="text/css"
	href="css/jquery-ui-1.9.2.custom.css" />

<SCRIPT src="javascript/masterList.js"></SCRIPT>

  <script src="javascript/jquery.js"></script>
	<script src="javascript/jquery-ui-1.10.4.min.js"></script>
    <script src="javascript/jquery-1.8.3.min.js"></script>
<script type="text/javascript" src="v/jquery-ui-1.9.2.custom.min.js"></script>
    <!-- bootstrap -->
<script src="javascript/bootstrap.min.js"></script>
<script src="javascript/angular/angular.js"></script>
		

<table class="trails" cellspacing="0">
<tr>
<td>
<a href="Allevamenti.do"><dhv:label name="allevamenti.allevamenti">Accounts</dhv:label></a> > 
Interroga BDN >
Dettaglio BDN
</tr>
</table>
<%-- End Trails --%>
<%

if(IstanzaAllevamentoBdn.getCod_errore()>0)
{%>
	<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
	  <tr>
	    <th colspan="2">
	      <strong>Errore</strong>
	    </th>
	  </tr>
	 
	 <tr class="containerBody">
	    <td nowrap class="formLabel">Errore</td>
	    <td><font color="red"><%=IstanzaAllevamentoBdn.getErrore() %></font></td>
	  </tr>
	  </table>
	  <%
}
else
{
	
	%>

	<center>
	
</center>

<form method="post" action="AziendeZootecniche.do?command=GetAllevamentoBDN&mode=SYNC">
<input type = "hidden" name = "codAzienda" value = "<%=IstanzaAllevamentoBdn.getAziendaCodice() %>">
<input type = "text" name = "specieAzienda" value = "<%=IstanzaAllevamentoBdn.getCodiceSpecie() %>">
<input type = "hidden" name = "idFiscaleAzienda" value = "<%=IstanzaAllevamentoBdn.getIdFiscaleAllevamento() %>">
<input type = "submit" value = "SINCRONIZZA IN GISA">
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
      <strong>Dati Azienda</strong>
    </th>
  </tr>
 
 <tr class="containerBody">
    <td nowrap class="formLabel">Codice Azienda</td>
    <td><%=IstanzaAllevamentoBdn.getAziendaCodice() %></td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">Data Apertura</td>
    <td><%=IstanzaAllevamentoBdn.getAziendaDataApertura() %></td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">ASL</td>
    <td><%=AslList.getSelectedValue(IstanzaAllevamentoBdn.getIdAsl()) %></td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">Comune</td>
    <td><%=IstanzaAllevamentoBdn.getAziendDescrizioneComune()%></td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">Indirizzo</td>
    <td><%=IstanzaAllevamentoBdn.getAziendaIndirizzo() %></td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">Latituine</td>
    <td><%= toHtml(IstanzaAllevamentoBdn.getAziendaLatitudine()) %></td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">Longitudine</td>
    <td><%=toHtml(IstanzaAllevamentoBdn.getAziendaLongitudine()) %></td>
  </tr>
 
  
</table>
<br>
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
      <strong>Dati Allevamento</strong>
    </th>
  </tr>
 	<tr class="containerBody">
    <td nowrap class="formLabel">Indirizzo</td>
    <td><%=IstanzaAllevamentoBdn.getIndirizzoAllevmanentoVia() %></td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">Provincia</td>
    <td><%=IstanzaAllevamentoBdn.getIndirizzoAllevamentoSiglaProvincia() %></td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">Comune</td>
    <td><%=IstanzaAllevamentoBdn.getIndirizzoAllevamentoDescrizioneComune() %></td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">Cap</td>
    <td><%=IstanzaAllevamentoBdn.getIndirizzoAllevamentoCap() %></td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">Data Inizio Attivita</td>
    <td><%=IstanzaAllevamentoBdn.getDataInizioAttivita() %></td>
  </tr>
   <tr class="containerBody">
    <td nowrap class="formLabel">Data Fine Attivita</td>
    <td><%=(IstanzaAllevamentoBdn.getDataFineAttivita()!=null && !"".equalsIgnoreCase(IstanzaAllevamentoBdn.getDataFineAttivita())) ? IstanzaAllevamentoBdn.getDataFineAttivita() :"" %></td>
  </tr>
</table>
<br>
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details" ng-app="attivita">
  <tr>
    <th colspan="3">
      <strong>ATTIVITA SVOLTA</strong>
    </th>
  </tr>
 
  <tr class="containerBody">
    <td nowrap class="formLabel" >ATTIVITA</td>
    <td style="width: 30%"><%=IstanzaAllevamentoBdn.getDescrizioneSpecie() %><br>
    <%=IstanzaAllevamentoBdn.getDescrizioneTipoProduzione() %><br>
    <%= IstanzaAllevamentoBdn.getDescrizioneOrientamentoProduttivo()%>
    </td>
    <td>
    
    <div ng-controller="AttCtrl"  >
  
  <select ng-model="selectedMacroarea"  style="width: 30%"
  		
  		ng-change="changedValueAggregazione(selectedMacroarea)" 
  		ng-options="item.macroarea for item in itemsMacroarea track by item.id">
  <option value="-1">Seleziona Macroarea</option>
</select>  

<br>
<br>
  
  <select ng-model="selectedAggregazione"  style="width: 30%"
    		ng-change="changedValueAttivita(selectedAggregazione)" 
  
  ng-options="itemAgg.aggregazione for itemAgg in itemsAggregazione track by itemAgg.id">
  
  <option value="-1">Seleziona Aggregazione</option>
</select>  
<br>
<br>

<select ng-model="selectedAttivita" style="width: 30%" name = "idLineaProduttiva" required="required"
  
  ng-options="itemAtt.lineaAttivita for itemAtt in itemsAttivita track by itemAtt.id">
  
  <option value="">Seleziona Linea Attivita</option>
</select>  
<br>
<br>
<b>{{selectedMacroarea.macroarea}}  - {{selectedAggregazione.aggregazione}} - {{selectedAttivita.lineaAttivita}}</b>

</div>


    </td>
    
    
  </tr>
  

  </table>
  <br>

<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
      <strong>Dati Proprietario</strong>
    </th>
  </tr>
 
  <tr class="containerBody">
    <td nowrap class="formLabel">Nominativo</td>
    <td><%=IstanzaAllevamentoBdn.getProprietarioNominativo() %></td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">Id Fiscale</td>
    <td><%=IstanzaAllevamentoBdn.getProprietarioIdFiscale()%></td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">Comune</td>
    <td><%=IstanzaAllevamentoBdn.getProprietarioIndirizzoDescrizioneComune()%></td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">Cap</td>
    <td><%=IstanzaAllevamentoBdn.getProprietarioIndirizzoCap() %></td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">Indirizzo</td>
    <td><%=IstanzaAllevamentoBdn.getProprietarioIndirizzoVia() %></td>
  </tr>  
</table>
<br>
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
      <strong>Dati Detentore</strong>
    </th>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">Nominativo</td>
    <td><%=IstanzaAllevamentoBdn.getDetentoreNominativo() %></td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">Id Fiscale</td>
    <td><%=IstanzaAllevamentoBdn.getDetentoreIdFiscale()%></td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">Comune</td>
    <td><%=IstanzaAllevamentoBdn.getDetentoreIndirizzoDescrizioneComune()%></td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">Cap</td>
    <td><%=IstanzaAllevamentoBdn.getDetentoreIndirizzoCap() %></td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">Indirizzo</td>
    <td><%=IstanzaAllevamentoBdn.getDetentoreIndirizzoVia() %></td>
  </tr>  
</table>
</form>
<%} %>

<script>



angular.module('attivita', []).controller('AggCtrl', function ($scope, $http) {
    $scope.selectedTestAccount = null;
    $scope.testAccounts = [];
    var data = {};
    data.tipologia="macroarea";
    data.flussoOrig="3";
   
    $http({
        method: 'POST',
        datatype:"json",
        header: {
            "contentType": 'application/json'
        },
        data: JSON.stringify(data),
        url: 'GestioneMasterList.do?command=CostruisciMasterList&flussoOrig=3&tipologia=aggregazione&idMacroarea='+item.id,
    }).success(function(data, status, headers, config) {
        $scope.itemsAggregazione= data;
    }).error(function(data, status, headers, config) {
        alert( "failure");
    });
    
     
});


angular.module('attivita', []).controller('AttCtrl', function ($scope, $http) {
    $scope.selectedTestAccount = null;
    $scope.testAccounts = [];
    var data = {};
    data.tipologia="macroarea";
    data.flussoOrig="3";
   
    $http({
        method: 'POST',
        datatype:"json",
        header: {
            "contentType": 'application/json'
        },
        data: JSON.stringify(data),
        url: 'GestioneMasterList.do?command=CostruisciMasterList&flussoOrig=3&tipologia=macroarea',
    }).success(function(data, status, headers, config) {
        $scope.itemsMacroarea = data;
    }).error(function(data, status, headers, config) {
        alert( "failure");
    });
    
    
    
    $scope.changedValueAggregazione = function(item) {
       
    	 $http({
    	        method: 'POST',
    	        datatype:"json",
    	        header: {
    	            "contentType": 'application/json'
    	        },
    	        data: JSON.stringify(data),
    	        url: 'GestioneMasterList.do?command=CostruisciMasterList&flussoOrig=3&tipologia=aggregazione&idMacroarea='+item.id,
    	    }).success(function(data, status, headers, config) {
    	        $scope.itemsAggregazione= data;
    	    }).error(function(data, status, headers, config) {
    	        alert( "failure");
    	    });
    	
      }   
    
    $scope.changedValueAttivita = function(item) {
        
     	 $http({
     	        method: 'POST',
     	        datatype:"json",
     	        header: {
     	            "contentType": 'application/json'
     	        },
     	        data: JSON.stringify(data),
     	        url: 'GestioneMasterList.do?command=CostruisciMasterList&flussoOrig=3&tipologia=attivita&idAggregazione='+item.id,
     	    }).success(function(data, status, headers, config) {
     	        $scope.itemsAttivita= data;
     	    }).error(function(data, status, headers, config) {
     	        alert( "failure");
     	    });
     	
       }   
});
</script>
