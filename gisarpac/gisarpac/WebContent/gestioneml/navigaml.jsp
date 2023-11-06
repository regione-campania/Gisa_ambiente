<SCRIPT src="${pageContext.request.contextPath}/javascript/masterList.js"></SCRIPT>
<!-- <script src="javascript/jquery.js"></script> -->
<!-- <script src="javascript/jquery-ui-1.10.4.min.js"></script> -->
<!-- <script src="javascript/jquery-1.8.3.min.js"></script> -->
<%-- <script type="text/javascript" src="${pageContext.request.contextPath}/javascript/jquery-ui-1.9.2.custom.min.js"></script> --%>
<script type="text/javascript" src="${pageContext.request.contextPath}/javascript/jquery-1.9.1.min.js"></script>
<script type="text/javascript">
var jQuery_1_9_1 = $.noConflict(true);
</script>
<!-- bootstrap -->
<script src="${pageContext.request.contextPath}/javascript/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/javascript/angular/angular.js"></script>
		
		
<%
String idFlussoOrig = request.getParameter("idFlussoOrig"); 
String flagFisso = request.getParameter("flagFisso");
String flagMobile = request.getParameter("flagMobile");
String flagApicoltura = request.getParameter("flagApicoltura");
String flagRegistrabili = request.getParameter("flagRegistrabili");
String flagRiconoscibili = request.getParameter("flagRiconoscibili");
String flagSintesis = request.getParameter("flagSintesis");
String flagBdu = request.getParameter("flagBdu");
String flagVam = request.getParameter("flagVam");
String flagNoScia = request.getParameter("flagNoScia");
%>		
		
		
<div ng-app= "attivita">
<div ng-controller="AttCtrl">
	
	
		<table width="100%">
		<col width="10%">
		
		<tr>
		<td>Macroarea</td>	
		<td>
 		<select ng-model="selectedMacroarea"  style="width: 30%" name = "idMacroarea"
 		ng-change="changedValueAggregazione(selectedMacroarea); resetValueAttivita()" 
  		ng-options="item.macroarea for item in itemsMacroarea track by item.id">
  		<option value="-1" >Seleziona Macroarea</option>
		</select>  
		</td></tr>
<tr><td><br/></td></tr>		<tr>
		<td>Aggregazione</td>	
		<td>

		<select ng-model="selectedAggregazione"  style="width: 30%" name = "idAggregazione"
   		ng-change="changedValueAttivita(selectedAggregazione)" 
		ng-options="itemAgg.aggregazione for itemAgg in itemsAggregazione track by itemAgg.id">
  		<option value="-1">Seleziona Aggregazione</option>
		</select>
		</td></tr>
<tr><td><br/></td></tr>
 		<tr>
		<td>Linea attivita'</td>	
		<td> 
		<select ng-model="selectedAttivita" style="width: 30%" name = "idLineaProduttiva" required="required"
  		ng-options="itemAtt.lineaAttivita for itemAtt in itemsAttivita track by itemAtt.id">
  		<option value="-1">Seleziona Linea Attivita</option>
		</select>
  		</td></tr>
  		
  		
<tr><td colspan="2">
<b>{{selectedMacroarea.macroarea}}  - {{selectedAggregazione.aggregazione}} - {{selectedAttivita.lineaAttivita}}</b>
</td></tr>

</table>

</div>
</div>
		


<script>

angular.module('attivita', []).controller('AggCtrl', function ($scope, $http) {
    $scope.selectedTestAccount = null;
    $scope.testAccounts = [];
    var data = {};
      
    $http({
        method: 'POST',
        datatype:"json",
        header: {
            "contentType": 'application/json'
        },
        data: JSON.stringify(data),
        url: 'GestioneMasterList.do?command=CostruisciMasterList&flussoOrig=<%=idFlussoOrig%>&flagFisso=<%=flagFisso %>&flagMobile=<%=flagMobile %>&flagApicoltura=<%=flagApicoltura %>&flagRegistrabili=<%=flagRegistrabili %>&flagRiconoscibili=<%=flagRiconoscibili %>&flagSintesis=<%=flagSintesis %>&flagBdu=<%=flagBdu %>&flagVam=<%=flagVam %>&flagNoScia=<%=flagNoScia %>&tipologia=aggregazione&idMacroarea='+item.id,
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
   
    $http({
        method: 'POST',
        datatype:"json",
        header: {
            "contentType": 'application/json'
        },
        data: JSON.stringify(data),
        url: 'GestioneMasterList.do?command=CostruisciMasterList&flussoOrig=<%=idFlussoOrig%>&flagFisso=<%=flagFisso %>&flagMobile=<%=flagMobile %>&flagApicoltura=<%=flagApicoltura %>&flagRegistrabili=<%=flagRegistrabili %>&flagRiconoscibili=<%=flagRiconoscibili %>&flagSintesis=<%=flagSintesis %>&flagBdu=<%=flagBdu %>&flagVam=<%=flagVam %>&flagNoScia=<%=flagNoScia %>&tipologia=macroarea',
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
    	        url: 'GestioneMasterList.do?command=CostruisciMasterList&flussoOrig=<%=idFlussoOrig%>&flagFisso=<%=flagFisso %>&flagMobile=<%=flagMobile %>&flagApicoltura=<%=flagApicoltura %>&flagRegistrabili=<%=flagRegistrabili %>&flagRiconoscibili=<%=flagRiconoscibili %>&flagSintesis=<%=flagSintesis %>&flagBdu=<%=flagBdu %>&flagVam=<%=flagVam %>&flagNoScia=<%=flagNoScia %>&tipologia=aggregazione&idMacroarea='+item.id,
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
     	        url: 'GestioneMasterList.do?command=CostruisciMasterList&flussoOrig=<%=idFlussoOrig%>&flagFisso=<%=flagFisso %>&flagMobile=<%=flagMobile %>&flagApicoltura=<%=flagApicoltura %>&flagRegistrabili=<%=flagRegistrabili %>&flagRiconoscibili=<%=flagRiconoscibili %>&flagSintesis=<%=flagSintesis %>&flagBdu=<%=flagBdu %>&flagVam=<%=flagVam %>&flagNoScia=<%=flagNoScia %>&tipologia=attivita&idAggregazione='+item.id,
     	    }).success(function(data, status, headers, config) {
     	        $scope.itemsAttivita= data;
     	    }).error(function(data, status, headers, config) {
     	        alert( "failure");
     	    });
     	
       }   
    
    $scope.resetValueAttivita = function(item) {
    	 $http({
    	        method: 'POST',
    	        datatype:"json",
    	        header: {
    	            "contentType": 'application/json'
    	        },
    	        data: JSON.stringify(data),
    	        url: 'GestioneMasterList.do?command=CostruisciMasterList&flussoOrig=<%=idFlussoOrig%>&flagFisso=<%=flagFisso %>&flagMobile=<%=flagMobile %>&flagApicoltura=<%=flagApicoltura %>&flagRegistrabili=<%=flagRegistrabili %>&flagRiconoscibili=<%=flagRiconoscibili %>&flagSintesis=<%=flagSintesis %>&flagBdu=<%=flagBdu %>&flagVam=<%=flagVam %>&flagNoScia=<%=flagNoScia %>&tipologia=attivita&idAggregazione='+'',
    	    }).success(function(data, status, headers, config) {
    	        $scope.itemsAttivita= data;
    	    }).error(function(data, status, headers, config) {
    	        alert( "failure");
    	    });
    	item.id = "-1";
      }   
    
});
</script>
	

		