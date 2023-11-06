<%@page import="org.aspcfs.modules.opu.base.LineaProduttiva"%>
<%@ page import="java.util.*,java.text.DateFormat,org.aspcfs.modules.accounts.base.*,org.aspcfs.modules.opu.base.*,org.aspcfs.modules.contacts.base.*,org.aspcfs.modules.base.Constants" %>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="StabilimentoDettaglio" class="org.aspcfs.modules.opu.base.Stabilimento" scope = "request"/>
<jsp:useBean id="ListaStati" class="org.aspcfs.utils.web.LookupList" scope="request"/>

<script src="javascript/vendor/moment.min.js"></script>
<script src="javascript/noscia/addNoScia.js"></script>
<script type="text/javascript" src="dwr/interface/DWRnoscia.js"> </script>
<script type="text/javascript" src="dwr/interface/SuapDwr.js"> </script>

<script  src="dwr/interface/PopolaCombo.js"> </script>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>

<script src="javascript/gestioneanagrafica/aggiungiLinea.js"></script>
<script src="javascript/gestioneanagrafica/add.js"></script>


<table class="trails" cellspacing="0">
	<tr>
		<td>
			<a href="OpuStab.do?command=SearchForm">ANAGRAFICA STABILIMENTI</a> > 
			<a href="GestioneAnagraficaAction.do?command=Details&altId=${altId}"> SCHEDA</a> > AMPLIAMENTO
		</td>
	</tr>
</table>

<form class="form-horizontal" role="form" method="post" action="GestioneAnagraficaAction.do?command=Ampliamento" onsubmit="return validateForm();">
<b>MODIFICA SCHEDA: AMPLIAMENTO</b><br>
<input type="hidden" id="stabId" name="stabId" value="<%=StabilimentoDettaglio.getIdStabilimento()%>"/>
<input type="hidden" id="altId" name="altId" value="<%=StabilimentoDettaglio.getAltId()%>"/>
<input type="hidden" id="numero_linee_attuali" name="numero_linee_attuali" value="<%=StabilimentoDettaglio.getListaLineeProduttive().size()%>"/>
<input type="hidden" id="tipo_linee_attivita" value="<%=StabilimentoDettaglio.getTipoAttivita()%>" />

<div id="dati_pratica" style="border: 1px solid black; background: #BDCFFF">
<br>
&nbsp;&nbsp;&nbsp;&nbsp;NUMERO PRATICA: ${numeroPratica} <br>
&nbsp;&nbsp;&nbsp;&nbsp;DATA PEC: ${dataPratica} <br>
<br>
<input type="hidden" id="numeroPratica" name="numeroPratica" value="${numeroPratica}"/>
<input type="hidden" id="idTipologiaPratica" name="idTipologiaPratica" value="${tipoPratica}"/>
<input type="hidden" id="idComunePratica" name="idComunePratica" value="${comunePratica}"/>
</div>
<br/>

<table class="details" id="tabella_linee" cellspacing="0" border="0" width="100%" cellpadding="4">
<tbody>
	<tr>
		<th colspan="2">Riepilogo</th>
	</tr>
	<tr>
		<td class="formLabel">Numero registrazione</td>
		<td><%=StabilimentoDettaglio.getNumero_registrazione()%></td>
	</tr>
	<tr>
		<td class="formLabel">Ragione Sociale Impresa</td>
		<td><%=StabilimentoDettaglio.getOperatore().getRagioneSociale()%></td>
	</tr>
	<tr>
		<td class="formLabel">Data inizio attivita'</td>
		<td><%=StabilimentoDettaglio.getDataInizioAttivitaString().replaceAll("/", "-")%>
		<input type="hidden" id="data_inizio_stab" name="data_inizio_stab" value="<%=StabilimentoDettaglio.getDataInizioAttivitaString().replaceAll("/", "-") %>">
		</td>
	</tr>
	<tr>
		<td class="formLabel">Linee produttive</td>
		<td>
			<table class="details" cellspacing="0" border="0" width="100%" cellpadding="4"> 
				<% 
				for(int i = 0; i < StabilimentoDettaglio.getListaLineeProduttive().size(); i++ ){ %>
			  		<%LineaProduttiva lp = (LineaProduttiva) StabilimentoDettaglio.getListaLineeProduttive().get(i); %>
			  		<tr>
			  			<td style="width:10%">
			  				<%=lp.getNumeroRegistrazione() %>
			  			</td>
			  			<td>
			  				<div id="div_linee_<%=i%>" ></div>
			  				<input type="hidden" id="linea_<%=i%>" name="linea_<%=i%>" value="<%=lp.getDescrizione_linea_attivita() %>" >
			  				<input type="hidden" id="id_lp_<%=i%>" name="id_lp_<%=i%>" value="<%=lp.getId()%>">
			  				<input type="hidden" id="codice_lp_<%=i%>" name="codice_lp_<%=i%>" value="<%=lp.getCodice()%>">
			  				<input type="hidden" id="stato_lp_<%=i%>" name="stato_lp_<%=i%>" value="<%=lp.getStato()%>">
			  			</td>	
			  		</tr>
					<%} %> 
				
			</table>
		</td>
	</tr>
	
	<tr id="tr_attivita_id_sezione">
		<th colspan="2">
			ATTIVITA PRODUTTIVE
			<input id="attivita_id_sezione" type="button" value="aggiungi attivita produttiva" onclick="aggiungi_linea();">
		</th>
	</tr>
	<input type="hidden" id="numero_linee" name="numero_linee" value="1">
	<input type="hidden" id="numero_linee_effettivo" name="numero_linee_effettivo" value="0">
	
</tbody>
</table>
<br><br>
<center>

<button type="submit" class="yellowBigButton" style="width: 250px;">Salva</button>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

<button type="button" id="torna" class="yellowBigButton" style="width: 250px;"
	onClick="loadModalWindowCustom('Attendere Prego...'); window.location.href='GestioneAnagraficaAction.do?command=ListaPraticheStabilimenti'">Annulla</button>

</center>
</form>
<br><br>

<div id='popuplineeattivita'/>

<script>

function validateForm(){
	
	var num_linee = document.getElementById('numero_linee_effettivo').value;
	if(num_linee == '0'){
		alert('Nessuna linea di attivita inserita');
		return false;
	}
	
	for(var i=0; i< document.getElementById('numero_linee_attuali').value; i++ ){
		var cod_linea_presente = document.getElementById('codice_lp_'+i).value;
		var stato_linea_presente = document.getElementById('stato_lp_'+i).value;
		for(var j=1; j < document.getElementById('numero_linee').value; j++){
			var field_linea_inserita = document.getElementById('lineaattivita_'+j+'_codice_univoco_ml');
			if (typeof(field_linea_inserita) != 'undefined' && field_linea_inserita != null){
				var cod_linea_inserita = field_linea_inserita.value;
				if(cod_linea_presente == cod_linea_inserita && stato_linea_presente == '0'){
					alert('Attenzione! una o piu linee di attivita\' gia presenti ed attive nello stabilimento');
					return false;
				}
			}
			
		}
	}
	
	for(var j=1; j < document.getElementById('numero_linee').value; j++){
		var field_linea_inserita_data_inizio = document.getElementById('lineaattivita_'+j+'_data_inizio_attivita');
		if (typeof(field_linea_inserita_data_inizio) != 'undefined' && field_linea_inserita_data_inizio != null){
			var data_linea = field_linea_inserita_data_inizio.value.split('-');
			var data1 = new Date(data_linea[2] + '-' + data_linea[1] + '-' + data_linea[0]);
		    var data_stab = document.getElementById('data_inizio_stab').value.split('-');
		    var data2 = new Date(data_stab[2] + '-' + data_stab[1] + '-' + data_stab[0]);
		    
		    if (data2 > data1){
		    	alert('Attenzione! la data inizio attivita\' non puo\' essere antecedente alla data inizio stabilimento');
		    	return false;
		    }
		}
	}
	
	//da implementare action java, mettere return true con loadModalWindowCustom('Attendere Prego...')
	loadModalWindowCustom('Attendere Prego...');
	return true;
}

if(document.getElementById('tipo_linee_attivita').value == '2'){
	alert('Attenzione: Operazione di amplimento non consentita per osa senza sede fissa!');
	loadModalWindowCustom('Attendere Prego...');
	window.location.href='GestioneAnagraficaAction.do?command=Details&altId='+ document.getElementById('altId').value;
}

if(document.getElementById('numeroPratica').value == ''){
	document.getElementById('dati_pratica').style.display = 'none';
	document.getElementById('torna').onclick = function(){
		loadModalWindowCustom('Attendere Prego...');
		window.location.href='GestioneAnagraficaAction.do?command=Details&altId='+ document.getElementById('altId').value;
	};
}

for(var i=0; i< document.getElementById('numero_linee_attuali').value; i++){
	var desc = document.getElementById('linea_' + i).value;
	var res = desc.split("->");
	document.getElementById('div_linee_' + i).innerHTML = res[0] + '-><br>' + res[1] + '-><br>' + res[2];
}

function trim(str) {
    try {
        if (str && typeof(str) == 'string') {
            return str.replace(/^\s*|\s*$/g, "");
        } else {
            return '';
        }
    } catch (e) {
        return str;
    }
}

</script>
