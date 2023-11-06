
/*ottengo il modulo */
var main_module = angular.module("main_module");

/*creo controller che setta sul rootScope (scope condiviso da tutti i controller)*/
main_module.controller("root_controller",["$scope","$rootScope",function($scope,$rootScope){
	
	
	/*definisco le costanti nel rootScope condiviso da tutti i controller*/
	
	
	$rootScope.msg_errore_data_mancante = "Scegliere una data valida";
	
	
	
	$rootScope.MAXLENGTH_RAGIONESOCIALE = 70;
	$rootScope.msg_errore_ragionesociale = "Inserire ragione sociale valida";
	
	$rootScope.pattern_piva = /^[0-9]{11}$/
	$rootScope.msg_errore_piva = "Inserire partita iva valida";
		
	$rootScope.pattern_cf_o_iva = /(^[0-9]{11}$)|(^[0-9a-zA-Z]{16}$)/
	$rootScope.msg_errore_cf_o_iva = "Inserire codice fiscale valido";
		
	$rootScope.pattern_mail = /^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i
	$rootScope.msg_errore_mail = 'Formato mail non valido';	
	
	$rootScope.msg_errore_campo_mancante_generico = "Valorizzare il campo";
	
	$rootScope.pattern_cf = /^[0-9a-zA-Z]{16}$/
	$rootScope.msg_errore_cf = "Inserire codice fiscale valido";
	
	$rootScope.pattern_tel = /^[0-9]*$/;
	$rootScope.msg_errore_telefono ="Formato telefono non valido";
	
	$rootScope.pattern_data = /^[0-9]{2}\/[0-9]{2}\/[0-9]{4}$/;
	$rootScope.msg_errore_formato_data = "Formato data atteso: dd/mm/yyyy";
	
	$rootScope.msg_errore_indirizzo = "Valorizzare  tutti i campi";
	
	$rootScope.pattern_coordinate = /[0-9]+/
	$rootScope.msg_errore_coordinate = "Valorizzare col formato corretto le coordinate"
	
	$rootScope.debug_mode = true;
	 
	/*messaggi usati per l'alert dopo aver chiamato il servizio di inserimento nuova anagrafica */
	$rootScope.MSG_STATI_OPS_DBI_INSERIMENTO = {
			
			"-1" : "Qualcosa e' andato storto"
			, "0" : "INSERIMENTO EFFETTUATO CON SUCCESSO : TUTTE LE ENTITA' SPECIFICATE INSERITE EX NOVO"
			, "1" : "INSERIMENTO EFFETTUATO CON SUCCESSO : IMPRESA GIA' ESISTENTE, LO STABILIMENTO SPECIFICATO E' STATO AGGIUNTO ALL'IMPRESA GIA' PRESENTE NEL SISTEMA"
			, "2" : "INSERIMENTO EFFETTUATO CON SUCCESSO : RAPPRESENTANTE LEGALE GIA' ESISTENTE E ASSOCIATO ALLA NUOVA IMPRESA."
	};
		
}]);




