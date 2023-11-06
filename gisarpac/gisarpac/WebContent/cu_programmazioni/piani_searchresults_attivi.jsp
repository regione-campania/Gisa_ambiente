<%@page import="org.aspcfs.modules.dpat.base.DpatIstanza"%>
<%@page import="org.aspcfs.modules.dpat.base.PianoMonitoraggio"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<%@page import="org.aspcfs.modules.dpat.base.Dpat"%>


<jsp:useBean id="TicListPiani" class="org.aspcfs.modules.programmazzionecu.base.PianoMonitoraggioList" scope="request"/>
<jsp:useBean id="TicListPianiInfo" class="org.aspcfs.utils.web.PagedListInfo" scope="session"/>
<jsp:useBean id="lookup_asl" class = "org.aspcfs.utils.web.LookupList" scope = "request"></jsp:useBean>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<jsp:useBean id="lookup_sezioni_piani" class = "org.aspcfs.utils.web.LookupList" scope = "request"></jsp:useBean>

<%@ include file="../initPage.jsp" %>
<%@ include file="../initPopupMenu.jsp" %>

<%@ include file="troubletickets_searchresults_menu.jsp" %>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/spanDisplay.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/confirmDelete.js"></SCRIPT>

<script type="text/javascript" src="dwr/interface/PopolaCombo.js"> </script>

<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>

<script language="JavaScript" type="text/javascript">
  <%-- Preload image rollovers for drop-down menu --%>
  
</script>

<script>


var val;


function verificaEsistenzaControlliSuPianoCallback(val)
{
	
	if (val==true)
		{
		
		alert('Sono stati Inseriti Controlli Su Questo Piano. Non è possibile procedere con la modifica-!');
		}
	else
		{
		location.href=urlToLoad;
		}
	
	}
var urlToLoad = '';
function verificaEsistenzaControlliSuPiano(idPiano,url)
{
	
		urlToLoad = url;
		PopolaCombo.vreificaEsistenzaControlliPerPiani(idPiano,{callback:verificaEsistenzaControlliSuPianoCallback,async:false});


	}


function openNotePianoMonitoraggioAdd(tipoInserimento,idPianoRiferimento,nuovasezione){
	var res;
	var result;
// tipoInserimento : up , down ,firstchild
		window.open('Dpat.do?command=AddEnabled&nuovasezione='+nuovasezione+'&tipoInserimento='+tipoInserimento+'&idPianoRiferimento='+idPianoRiferimento,null,
		'height=400px,width=600px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=no,resizable=no ,modal=yes');
		
		} 
		
function openNotePianoMonitoraggioReplace(idPianoRiferimento){
	var res;
	var result;
// tipoInserimento : up , down ,firstchild
		window.open('Dpat.do?command=ToReplaceEnabled&idPianoRiferimento='+idPianoRiferimento,null,
		'height=400px,width=600px,toolbar=no,directories=no,status=no,continued from previous linemenubar=no,scrollbars=no,resizable=no ,modal=yes');
		
		} 

var colorprec = '';
function hover(item){
	
	
    $('#elenco tr').hover(function(){
    	colorprec =  $(this).css('background-color');
          $(this).css('background','#dedede');
    }, function(){
          $(this).css('background',colorprec);
    });
}

function ricaricaPiani()
{
	
	if (document.getElementById("checkAtt").checked)
		{
		location.href="Dpat.do?command=SearchPianiMonitoraggioAttivi&includiAttivita=si";
		}
	else
		{location.href="Dpat.do?command=SearchPianiMonitoraggioAttivi&includiAttivita=no";}
	
	}
</script>
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
Elenco

</td>
</tr>
</table>

<%
	int tipo_piano = -1 ;
String descrizione_piano = "" ;
if (request.getAttribute("searchcodetipo_piano")!=null)
	tipo_piano = (Integer) request.getAttribute("searchcodetipo_piano");
if (request.getAttribute("searchdescrizione_piano")!=null)
	descrizione_piano = (String) request.getAttribute("searchdescrizione_piano");
%>
<%-- End Trails --%>
<form name="searchPiano" action="Dpat.do?command=SearchPianiMonitoraggioAttivi" method="post">
<%
DpatIstanza IstanzaDpat = (DpatIstanza) request.getAttribute("IstanzaDpat");
%>

<a href="javascript:openNotePianoMonitoraggioAdd('down',-1,'si')" <%=("permanente".equalsIgnoreCase(IstanzaDpat.getStato()))? "style='display:none'"  :""%>>Aggiungi Sezione</a>
<br>
<br>
<br>
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
<tr><th colspan="2">Filtra Attivita</th></tr>
<tr>
	<td class="formLabel">Sezione</td>
	<td>
	<%=lookup_sezioni_piani.getHtmlSelect("searchcodetipo_piano",tipo_piano)%>
	
	</td>
	
	</tr>
	<tr>
	<td class="formLabel">Descrizione</td>
	<td>
	<input type = "text" name = "searchdescrizione_piano" value = "<%=descrizione_piano%>">
	</td>
	</tr>
   	
</table>
<br/>
<input type="submit" value="Ricerca" onclick='loadModalWindow();'>

</form>
<br><br>
<%
int year = Calendar.getInstance().get(Calendar.YEAR); 
%>




<br>
<dhv:pagedListStatus title="" object="TicListPianiInfo"/>
<table cellpadding="4" cellspacing="0" width="100%" class="details" id ="elenco">
<tr><th>Sezione</th><th>Alias</th><th>Descrizione</th><th>Asl</th><th>Ui Sottopiano/SottoAttivita</th><th  <%= "permanente".equalsIgnoreCase(IstanzaDpat.getStato())? "style='display:none'" : "" %>>&nbsp;</th></tr>
 <%
 	Iterator itPiani = TicListPiani.iterator(); 
  if (itPiani.hasNext())
  {
 	 while (itPiani.hasNext())
 	 {
  PianoMonitoraggio piano = (PianoMonitoraggio)itPiani.next();
  String color = "#FFF" ;
  if (piano.getSezione().equalsIgnoreCase("sezione a"))
  {
	  color ="#ABDC53";
  }
  else
	  if (piano.getSezione().equalsIgnoreCase("sezione b"))
	  {
		  color = "#00BFFF";
	  }
	  else
		  if (piano.getSezione().equalsIgnoreCase("sezione c"))
		  {
			  color = "#FFBF00";
		  }
		  else
			  if (piano.getSezione().equalsIgnoreCase("sezione d"))
			  {
				  color = "#DA70D6";
			  }
			  else
				  if (piano.getSezione().equalsIgnoreCase("sezione e"))
				  {
					  color ="#964B00";
				  }
	  
  
 
 
 
  

 %>
 <tr >
 

 <td style="background-color: <%=color%>"><%=piano.getSezione()%></td>
 <td style="background-color: <%=color%>"><%= toHtml2(piano.getAlias()  ).toUpperCase() %>&nbsp;</td>
 <td style="background-color: <%=color%>"><%=piano.getDescrizione().toUpperCase()%></td>
 
 
 <td style="background-color: <%=color%>" >&nbsp;<%=toHtml2(lookup_asl.getSelectedValue(piano.getAsl())) %>&nbsp;</td>
 <td width="3px;"style="background-color: <%=color%>">&nbsp;</td>
 <td>
 
 
 <%
  	if(piano.getLista_sottopiani().size()==0){
  %>
  <table class="noborder">
 <tr <%="permanente".equalsIgnoreCase(IstanzaDpat.getStato()) ? "style='display:none'" : "" %>>
 
 <td><a href="javascript:openNotePianoMonitoraggioAdd('firstchild',<%=piano.getCode() %>,'no')"><img title="Aggiungi Sottopiano a <%=piano.getDescrizione() %>" width="25px" height="25px" src="./cu_programmazioni/image/add.png"></a></td>
 <td><a href="javascript:openNotePianoMonitoraggioAdd('up',<%=piano.getCode()%>,'no')"><img title="Aggiungi Piano Fratello Sopra <%=piano.getDescrizione() %>" width="25px" height="25px" src="./cu_programmazioni/image/add_up_padre.png"></a></td>
 <td><a href="javascript:openNotePianoMonitoraggioAdd('down',<%=piano.getCode()%>,'no')"><img title="Aggiungi Piano Fratello Sotto <%=piano.getDescrizione() %>" width="25px" height="25px" src="./cu_programmazioni/image/add_down_padre.png"></a></td>
 
 <td><img style="opacity:0.2" width="25px" height="25px" src="./cu_programmazioni/image/addup.png"></td>
  <td><img style="opacity:0.2" width="25px" height="25px" src="./cu_programmazioni/image/adddown.png"></td>
 <td><a href="javascript:openNotePianoMonitoraggioReplace(<%=piano.getCode()%>)"><img title="Sostituisci Piano '<%=piano.getDescrizione() %>' Con" width="25px" height="25px" src="./cu_programmazioni/image/edit.jpg"></a></td>
 <td>
  <a href="javascript:if(confirm('Sicuro di Voler Eliminare Il piano : <%=piano.getDescrizione().replace("'", "") %>')){verificaEsistenzaControlliSuPiano(<%=piano.getCode() %>,'Dpat.do?command=EliminaEnabled&code=<%=piano.getCode()%>&searchcodetipo_piano=<%=tipo_piano%>&searchdescrizione_piano=<%=descrizione_piano%>')}"><img title="Rendi Obsoleto <%=piano.getDescrizione() %>" width="25px" height="25px" src="./cu_programmazioni/image/remove.png"></a>
  </td></tr>
  </table>
  <%
  	}
  	else
  	{%>
  	 <table class="noborder">
 <tr <%="permanente".equalsIgnoreCase(IstanzaDpat.getStato()) ? "style='display:none'" : "" %>>
 <td><img  title="Aggiungi Sottopiano a <%=piano.getDescrizione() %>" width="25px" height="25px" src="./cu_programmazioni/image/add.png" style="opacity:0.2"></td>
 <td><a href="javascript:openNotePianoMonitoraggioAdd('up',<%=piano.getCode()%>,'no')"><img title="Aggiungi Piano Fratello Sopra <%=piano.getDescrizione() %>" width="25px" height="25px" src="./cu_programmazioni/image/add_up_padre.png"></a></td>
 <td><a href="javascript:openNotePianoMonitoraggioAdd('down',<%=piano.getCode()%>,'no')"><img title="Aggiungi Piano Fratello Giu <%=piano.getDescrizione() %>" width="25px" height="25px" src="./cu_programmazioni/image/add_down_padre.png"></a></td>
   <td><img style="opacity:0.2" width="25px" height="25px" src="./cu_programmazioni/image/addup.png"></td>
  <td><img style="opacity:0.2" width="25px" height="25px" src="./cu_programmazioni/image/adddown.png"></td>
  <td><a href="javascript:openNotePianoMonitoraggioReplace(<%=piano.getCode()%>)"><img title="Sostituisci Piano '<%=piano.getDescrizione() %>' Con" width="25px" height="25px" src="./cu_programmazioni/image/edit.jpg"></a></td>
  <td>
  <a href="javascript:if(confirm('Sicuro di Voler Eliminare Il piano : <%=piano.getDescrizione().replace("'", "") %>')){verificaEsistenzaControlliSuPiano(<%=piano.getCode() %>,'Dpat.do?command=EliminaEnabled&code=<%=piano.getCode()%>&searchcodetipo_piano=<%=tipo_piano%>&searchdescrizione_piano=<%=descrizione_piano%>');}"><img title="Rendi Obsoleto <%=piano.getDescrizione() %>" width="25px" height="25px" src="./cu_programmazioni/image/remove.png"></a>
  </td></tr>
  </table>
  	<%
  		
  		
  	}
  %>
  </td></tr> 	



	<%
 			if(piano.getLista_sottopiani().size()>0)
 			{
 				for (PianoMonitoraggio sp : piano.getLista_sottopiani())
 				{
 		%>
			<tr>
				

			<td style="background-color: <%=color%>"><%=sp.getSezione()%></td>
   <td style="background-color: <%=color%>" ><%= toHtml2(sp.getAlias()  ).toUpperCase() %>&nbsp;</td>

 <td style="background-color: <%=color%>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=sp.getDescrizione().toUpperCase() %></td>
 
 
 <td style="background-color: <%=color%>">&nbsp;<%=toHtml2(lookup_asl.getSelectedValue(piano.getAsl()))%>&nbsp;</td>
 <td width="3px;"style="background-color: <%=color%>">&nbsp;</td>
 <td>
  <table class="noborder">
 <tr  <%="permanente".equalsIgnoreCase(IstanzaDpat.getStato()) ? "style='display:none'" : "" %>>
 <td><img  title="Aggiungi Sottopiano a <%=sp.getDescrizione() %>" width="25px" height="25px" src="./cu_programmazioni/image/add.png" style="opacity:0.2"></td>
 
 <td><img  style="opacity:0.2" width="25px" height="25px" src="./cu_programmazioni/image/add_up_padre.png"></td>
  <td><img  style="opacity:0.2" width="25px" height="25px" src="./cu_programmazioni/image/add_down_padre.png"></td>
 
 <td><a href="javascript:openNotePianoMonitoraggioAdd('up',<%=sp.getCode()%>,'no')"><img title="Aggiungi Piano Fratello Sopra <%=sp.getDescrizione() %>" width="25px" height="25px" src="./cu_programmazioni/image/addup.png"></a></td>
  <td><a href="javascript:openNotePianoMonitoraggioAdd('down',<%=sp.getCode()%>,'no')"><img title="Aggiungi Piano Fratello Giu <%=sp.getDescrizione() %>" width="25px" height="25px" src="./cu_programmazioni/image/adddown.png"></a></td>
  <td><a href="javascript:openNotePianoMonitoraggioReplace(<%=sp.getCode()%>)"><img title="Sostituisci Piano '<%=sp.getDescrizione() %>' Con" width="25px" height="25px" src="./cu_programmazioni/image/edit.jpg"></a></td>
  <td>
 
 <%if(sp.getLista_sottopiani().size()==0){ %><a href="javascript:if(confirm('Sicuro di Voler Eliminare Il piano : <%=sp.getDescrizione().replace("'", "") %>')){verificaEsistenzaControlliSuPiano(<%=sp.getCode() %>,'Dpat.do?command=EliminaEnabled&code=<%=sp.getCode()%>&searchcodetipo_piano=<%=tipo_piano%>&searchdescrizione_piano=<%=sp.getDescrizione()%>')}"><img title="Rendi Obsoleto <%=sp.getDescrizione() %>" width="25px" height="25px" src="./cu_programmazioni/image/remove.png"></a><%} %>
 </td></tr></table></td></tr>
			<%
		}
		
	}
	 
	 
	 
	 }%>
	
	</table>
	<%} else {%>
		<tr class="containerBody">
      <td colspan="<%=3 %>">
        Nessuna Piano Trovata
      </td>
    </tr>
  </table>
<%} %>
<dhv:pagedListControl object="TicListPianiInfo" tdClass="row1"/>
<br>
<br>

