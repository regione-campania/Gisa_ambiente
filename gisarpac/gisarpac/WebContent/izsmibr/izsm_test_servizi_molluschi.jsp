<h1>Test Invio Di Prelievi/Campioni su Molluschi : verra' eseguito l'invio di prova dei primi tre record</h1>

<script>

function rimuoviFile(id){
	 document.getElementById("file"+id).value="";
	 


}

$(document).ready(function () {
    $("#testInvioMolluschi").submit(function (event) {

    	
    	loadModalWindowCustom("Tentativo di Invio di un Prelievo");
        //disable the default form submission
        event.preventDefault();
        //grab all form data  
        var formData = new FormData(jQuery('form')[0]);
        $.ajax({
            url: 'GestioneInvioMolluschi.do?command=TestInvio',
            type: 'POST',
            data: formData,
            async: false,
            cache: false,
            contentType: false,
            processData: false,
            success: function (msg) {
                
                if(msg.esito=='KO')
                	$("#resultInvio").html("<font color='red'>RISULTATO INVIO : KO.<br> ERRORE SERVIZIO WEB :"+msg.messaggio+"</font>");
                else
                	$("#resultInvio").html("<font color='green'>"+msg.messaggio+"</font>");
                	
            	loadModalWindowUnlock();

            },
            error: function(){
                alert("error in ajax form submission");
            }
        });

        return false;
    });
});

</script>

<%@ include file="../initPage.jsp"%>

<fieldset>
<legend> <%="Il File Da Fornire In input deve rispettare il seguente ordine dei campi".toUpperCase()  %></legend>
<table border="1" class="pagedList">
<thead>
<tr style="background-color: yellow">
<th>Posizione File Xls</th>
<th>Intestazione Colonna</th>
<th>Nome Campo da Manuale</th>
</tr>
</thead>

<tbody>
<tr>
<td>A:1</td>
<td>pianoCodice</td>
<td>pianoCodice</td>
</tr>
<tr>
<td>B:1</td>
<td>numeroSchedaPrelievo</td>
<td>numeroScheda</td>
</tr>
<tr>
<td>C:1</td>
<td>DATAPREL</td>
<td>DATAPREL</td>
</tr>


<tr>
<td>D:1</td>
<td>luogoPrelievoCodice</td>
<td>luogoPrelievoCodice</td>
</tr>
		
<tr>
<td>E:1</td>
<td>metodoCampionamentoCodice</td>
<td>metodoCampionamentoCodice</td>
</tr>

<tr>
<td>F:1</td>
<td>motivoCodice</td>
<td>motivoCodice</td>
</tr>
			
<tr>
<td>G:1</td>
<td>prelNome</td>
<td>prelNome</td>
</tr>

<tr>
<td>H:1</td>
<td>PrelCognome</td>
<td>PrelCognome</td>
</tr>

<tr>
<td>I:1</td>
<td>prelCodFiscale</td>
<td>prelCodFiscale</td>
</tr>

<tr>
<td>J:1</td>
<td>sitoCodice</td>
<td>sitoCodice</td>
</tr>

<tr>
<td>K:1</td>
<td>comuneCodiceIstatParziale</td>
<td>comuneCodiceIstatParziale</td>
</tr>

<tr>
<td>L:1</td>
<td>siglaProvincia</td>
<td>siglaProvincia</td>
</tr>

			
<tr>
<td>M:1</td>
<td>laboratorioCodice</td>
<td>laboratorioCodice</td>
</tr>

<tr>
<td>N:1</td>
<td>latitudine</td>
<td>latitudine</td>
</tr>

<tr>
<td>O:1</td>
<td>longitudine</td>
<td>longitudine</td>
</tr>

						
<tr>
<td>P:1</td>
<td>PRELIEVI.codiceContaminante</td>
<td>PRELIEVI.codiceContaminante</td>
</tr>

<tr>
<td>Q:1</td>
<td>CAMPIONI MOLLUSCHI.numeroSchedaPrelievo</td>
<td>CAMPIONI MOLLUSCHI.numeroSchedaPrelievo</td>
</tr>

<tr>
<td>R:1</td>
<td>progressivoCampione</td>
<td>progressivoCampione</td>
</tr>

<tr>
<td>S:1</td>
<td>foodexCodice</td>
<td>foodexCodice</td>
</tr>

<tr>
<td>T:1</td>
<td>CAMPIONI MOLLUSCHI.ProfFondale.ProfFondale</td>
<td>CAMPIONI MOLLUSCHI.ProfFondale.ProfFondale</td>
</tr>

<tr>
<td>U:1</td>
<td>classificazioneDellaZonaDiMareCe8542004</td>
<td>classificazioneDellaZonaDiMareCe8542004</td>
</tr>


</tbody>
</table>
</fieldset>
<hr>
<form method="post" id="testInvioMolluschi" action="GestioneInvioMolluschi.do?command=TestInvio" enctype="multipart/form-data">
<table cellspacing="0" border="0" width="100%" class="details">
    <tr>
      <th colspan="2">
        <img border="0" src="images/file.gif" align="absmiddle"><b>File da Inviare</b>
      </th>
    </tr>
   
      <tr class="containerBody">
      <td class="formLabel">
       File
      </td>
      <td>
        <input type="file" id="file1" name="file" size="45"  required="required">  <a href="#" onclick="rimuoviFile(1); return false;"><img src="images/delete.gif"></a>
      <%=showError(request, "ImportKoError") %>
      </td>
    </tr>
    
  </table>
<input type ="submit" value="Invia File a BDN" onclick="loadModalWindowCustom('ATTENDERE IL COMPLETAMENTO DELL\' INVIO VERSO LA BDN.')">
</form>

<div id="resultInvio"></div>
<br><br>

														
