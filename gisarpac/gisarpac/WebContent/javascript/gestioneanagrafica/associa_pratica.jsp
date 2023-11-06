
<script type="text/javascript" src="dwr/interface/DWRnoscia.js"> </script>

<script  src="dwr/interface/PopolaCombo.js"> </script>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>

<div id='popup_associa_pratica' />

<script>

$(function() {
	
	 $('#popup_associa_pratica').dialog({
		title : 'ASSOCIA PRATICA A STABILIMENTO',
        autoOpen: false,
        resizable: false,
        closeOnEscape: false,
        width:300,
        height:160,
        draggable: false,
        modal: true
	});
	 
});

function gestione_associa_pratica(cod_comune, alt_id, stab_id){
	var htmlText = '<center>' +
	   '<b>inserisci numero pratica</b><br><br>' + 
	   '<form id="associaPratica" name="associaPratica" class="form-horizontal" role="form" method="post" ' + 
	   'action="GestioneAnagraficaAction.do?command=AssociaPraticaDaStabilimento" ' +  //"GestioneAnagraficaAction.do?command=AssociaPraticaDaStabilimento"
	   'onsubmit="return validateFormAssociaPratica(' + cod_comune + ',' + alt_id + ',' + stab_id + ');">' +
	   '<input type="text" id="numero_pratica" name="numero_pratica" placeholder="numero pratica" style="text-align:center;" size="40" autocomplete="off" required/>' + 
	   '<input type="hidden" id="tipo_pratica" name="tipo_pratica" />' +
	   '<input type="hidden" id="stato_pratica" name="stato_pratica" />' +
	   '<input type="hidden" id="id_stab" name="id_stab" />' +
	   '<input type="hidden" id="alt_id" name="alt_id" />' +
	   '<input type="hidden" id="cod_comune" name="cod_comune" />' +
	   '<br><br>' + 
	   '<button  type="submit" class="btn btn-primary" style="width: 80px;">ASSOCIA</button>' +
	   '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
	   '<button type="button" class="btn btn-primary" style="width: 80px;" onclick="loadModalWindowUnlock(); $(\'#popup_associa_pratica\').dialog(\'close\'); ">ESCI</button>' +
	   '</form>' +
	   '</center>';
	$('#popup_associa_pratica').html(htmlText);
    $('#popup_associa_pratica').dialog('open');
}


function validateFormAssociaPratica(cod_comune, alt_id, stab_id){
	var numero_pratica = document.getElementById('numero_pratica').value;
	controllaEsistenzaNumeroPratica(numero_pratica.trim(), cod_comune);
	
	if(document.getElementById('cod_comune').value){
		
		if(document.getElementById('stato_pratica').value != '0' && document.getElementById('id_stab').value == stab_id){
			alert('Attenzione!!! operazione non consentita per questo numero pratica.');
			return false;
		}
		
		document.getElementById('id_stab').value = stab_id;
		document.getElementById('alt_id').value = alt_id;
		document.getElementById('cod_comune').value = cod_comune;
		
	} else {
		return false;
	}
	
	loadModalWindowCustom('Attendere Prego...'); 
	
	return true; 
}

function controllaEsistenzaNumeroPratica(numeroPratica, comune_ric)
{
	loadModalWindowCustom('Verifica esistenza pratica in corso. Attendere...');
	DWRnoscia.controlloEsistenzaNumeroPratica(numeroPratica, comune_ric,{callback:controllaEsistenzaNumeroPraticaCallBack,async:false});
}

function controllaEsistenzaNumeroPraticaCallBack(val)
{	
	var dati = val;
	var objresp;
	objresp = JSON.parse(dati);
	var len = objresp.length;
	if (len > 0){

		var praticaobj;
		praticaobj = objresp[0];
		document.getElementById('tipo_pratica').value = praticaobj.id_tipo_operazione; 
		document.getElementById('stato_pratica').value = praticaobj.stato_pratica;
		document.getElementById('id_stab').value = praticaobj.id_stabilimento;
		document.getElementById('alt_id').value = praticaobj.alt_id;
		document.getElementById('cod_comune').value = praticaobj.id_comune_richiedente;
		loadModalWindowUnlock();
	} else {
		alert('il numero pratica inserito non esiste');
		loadModalWindowUnlock();
		}
	
}


</script>
