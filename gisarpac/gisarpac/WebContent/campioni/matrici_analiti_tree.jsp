<script language="JavaScript">
function openTree(campoid1,campoid2,table,id,idPadre,livello,multiplo,divPath,idRiga)
{
	idPiano='-1';
	controllo = true ;
	if(document.getElementById('motivazione_campione')!=null  && document.getElementById('motivazione_campione').value=='89')
	{
		idPiano=document.getElementById('motivazione_piano_campione').value;
		if (idPiano=='-1')
		{
			alert('- Controllare di aver selezionato il piano come motivazione del campione');
			controllo = false ;
		}
		else
		{
			window.open('Tree.do?command=DettaglioTree&idPiano='+idPiano+'&multiplo='+multiplo+'&divPath='+divPath+'&idRiga='+idRiga+'&campoId1='+campoid1+'&campoId2='+campoid2+'&nomeTabella='+table+'&campoId='+id+'&campoPadre='+idPadre+'&campoDesc=nome&campoLivello=livello&campoEnabled=nuova_gestione&sel=true');

		}
	}
	else
	{
		window.open('Tree.do?command=DettaglioTree&multiplo='+multiplo+'&divPath='+divPath+'&idRiga='+idRiga+'&campoId1='+campoid1+'&campoId2='+campoid2+'&nomeTabella='+table+'&campoId='+id+'&campoPadre='+idPadre+'&campoDesc=nome&campoLivello=livello&campoEnabled=nuova_gestione&sel=true');
		

		}

}

function mostracampiPnaaMangimi()
{
	alert('entrato');
if (document.getElementById('path_1').value != '' && document.getElementById('path_1').value.indexOf("MANGIM") != -1)
{
	alert('Hai selezionato Mangimi devi compilare i campi');
}

}
</script>

<script>
function bloccaSelezioneAnaliti(){
	var num_analiti_selezionati = document.getElementById("elementi").value;
	if (num_analiti_selezionati!=0){
		openTree('analitiId','pathAnaliti','analiti','analiti_id','id_padre','livello','si','divPathAnaliti','clona');
	}
	else {
		openTree('analitiId','pathAnaliti','analiti','analiti_id','id_padre','livello','si','divPathAnaliti','clona');
	}
}
</script>


 <tr>
    <td valign="top" class="formLabel">
      <dhv:label name="">Matrice</dhv:label>
    </td>
   
    
    <td>
    <table class = "noborder"><tr><td>
    <input type = "hidden" name = "elementi1" id = "elementi1" value = "0">
    <input type = "hidden" name = "size1" id = "size1" value = "0">
    <tr id = "clonaM" style="">
    <td>
    <input type = "hidden" name = "idMatrice" id = "idMatrice" value = "-1">
    <input type = "hidden" name = "path" id = "path" onchange="mostracampiPnaaMangimi();">
    <div id = "divPath"></div>     
   </td>
   </tr>
   <tr>
   <td>
    <a href = "javascript:openTree('idMatrice','path','matrici','matrice_id','id_padre','livello','no','divPath','clonaM')">(Selezionare Matrice)</a><font color="red">*</font>
   <br> <br>
     <textarea rows="5" cols="30" name = "noteMatrici"></textarea></br>
   </td>
   </tr>
   </table>
    </td>
	</tr>
	
  <tr>
      <td name="tipoCampione1" id="tipoCampione1" nowrap class="formLabel">
        <dhv:label name="">Tipo di Analisi</dhv:label>
      </td>
      <td>
    <table class = "noborder"><tr><td>
    <input type = "hidden" name = "elementi" id = "elementi" value = "0">
    <input type = "hidden" name = "size" id = "size" value = "0">
    <tr id = "clona" style="display: none">
    <td>
    <input type = "hidden" name = "analitiId">
    <input type = "hidden" name = "pathAnaliti">
    
    <div id = "divPathAnaliti"></div>
     
   </td>
   </tr>
   <tr>
   <td>
   <a href = "javascript:bloccaSelezioneAnaliti();">(Selezionare Tipo Analisi)</center></a><font color="red">*</font>
   <br> <br>
    <textarea rows="8" cols="40" name="noteAnalisi"></textarea></br>
   </td>
   </tr>
   </table>
    </td>
     </tr>

