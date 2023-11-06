<%@page import="org.aspcfs.modules.macellazioninewsintesis.base.Partita"%>
<%@page import="org.aspcfs.modules.macellazioninewsintesis.base.Tampone"%>
<%@page import="org.aspcfs.modules.macellazioninewsintesis.base.TipoRicerca"%>
<%@page import="org.aspcfs.utils.web.LookupElement"%>
<%@page import="org.aspcfs.utils.web.LookupList"%><jsp:useBean id="PianiMonitoraggio" class="org.aspcfs.utils.web.LookupList" scope = "request"/>

<script type="text/javascript" src="dwr/interface/PopolaCombo.js"> </script>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>
<script type="text/javascript">
function setTampone(idMacello,sedutaMacellazione)
{

	
		dataMacellazione = document.getElementById('vpm_data').value ;
		PopolaCombo.getTampone(idMacello,dataMacellazione,sedutaMacellazione,setTamponeCallBack);
	   
}

 function setTamponeCallBack(returnValue)
 {

	 
	 if (document.getElementById('checkTampone').checked)
	 {
	 if (returnValue.id > 0)
	 {	
		
			document.getElementById('id_tampone').value = returnValue.id;

			document.getElementById('id_tipo_carcassa').value = returnValue.id_tipo_carcassa;
			document.getElementById('id_tipo_ricerca').value = returnValue.id_tipo_ricerca;
			if (returnValue.metodo =='true')
			{
				document.getElementById("metodo_distruttivo").checked = "true";
				document.getElementById("metodo_non_distruttivo").checked = "false";
			}
			else
			{
				document.getElementById("metodo_distruttivo").checked = "false";
				document.getElementById("metodo_non_distruttivo").checked = "true";
			}
			
			
	  }
	 document.getElementById('tampon1').style.display = "";
	
	 }
	 else
	 {
		 document.getElementById('tampon1').style.display = "none";
		 document.getElementById('id_tampone').value ="-1";
		 }
	


 }
</script>

<jsp:useBean id="Tampone"			class="org.aspcfs.modules.macellazioninewsintesis.base.Tampone"		scope="request" />
<jsp:useBean id="MatriciTamponi"	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="AnalisiTamponi"	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="OrgDetails"		class="org.aspcfs.modules.sintesis.base.SintesisStabilimento"	scope="request" />
<jsp:useBean id="Partita"				class="org.aspcfs.modules.macellazioninewsintesis.base.Partita"			scope="request" />

<%
int idPianoMonitoraggioTamponi = 469 ;
%>
<table class="details" width="100%" border="0" cellpadding="5" cellspacing="0">
    			<tr>
    				<th colspan="4">Effettuato Tampone <input type = "checkbox" id="checkTampone" <%if(Tampone.getId()>0){%> checked="checked"<%} %> name = "checkTampone" onclick="setTampone(<%=OrgDetails.getAltId() %>,<%=Partita.getCd_seduta_macellazione() %>)" > </th>
    			</tr>
    			
    			<tr>
    				<th>Piano</th><th>Matrice</th> <th>Tipo Analisi</th>  <th colspan="2">Metodo</th>
    				 
    			</tr>
    					
    			<tr class="containerBody" id ="tampon1" value = "-1" <%if(Tampone.getId()<=0){%> style="display: none" <%} %>>
    				<input type="hidden" name="id_tampone" id = "id_tampone" value="<%=Tampone.getId() %>" />
    				<td>
    					<input type="hidden" name="piano_monitoraggio" id = "piano_monitoraggio" value="<%=idPianoMonitoraggioTamponi %>" />
    					<div id="descrizionePiano"></div>
    					
    					</td>
          
    				<td> 
    					<%=MatriciTamponi.getSelectedValue( 4 ) %>
    					<input type = "hidden" name = "id_tipo_carcassa" id = "id_tipo_carcassa" value = "4">
    					</td>
          
    				<td>
    				<%
    				AnalisiTamponi.setMultiple(true);
    				AnalisiTamponi.setSelectSize(6);
    				LookupList listaElementiSel = new LookupList();
    				for (TipoRicerca r : Tampone.getTipo_ricerca())
    				{
    					LookupElement el = new LookupElement();
    					el.setCode(r.getId());
    					el.setDescription(r.getDescrizione());
    					listaElementiSel.add(el);
    					
    				}
    				if (listaElementiSel.size()==0)
    				{
    					LookupElement elm = new LookupElement();
    					elm.setCode(-1);
    					elm.setDescription("Seleziona Analita");
    					listaElementiSel.add(elm);
    					
    				}
    				%>
    					<%=AnalisiTamponi.getHtmlSelect( "id_tipo_ricerca" , listaElementiSel ) %>
    				</td>
    				
    				<td>
    					Distruttivo <input type = "radio" <%if (Tampone.isDistruttivo()) {%>checked="checked"<%}%> name = "metodo" id = "metodo_distruttivo" value = "si">
    					Non Distruttivo <input type = "radio" id = "metodo_non_distruttivo" <%if (!Tampone.isDistruttivo()) {%>checked="checked"<%}%>  name = "metodo" checked="checked"  value = "no">
    					
    				</td>
    				
    				
    				
    				
    				
    			</tr>
    			
    		
    			
</table>
<script>getCodiceTipoPianoFromCodiceInterno(<%=idPianoMonitoraggioTamponi%>)</script>

