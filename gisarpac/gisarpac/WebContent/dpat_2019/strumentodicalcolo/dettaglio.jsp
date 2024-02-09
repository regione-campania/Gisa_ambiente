<%@page import="java.util.Date"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>

<%@page import="org.aspcfs.modules.dpat2019.base.oia.OiaNodo"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.aspcfs.modules.dpat2019.base.DpatStrumentoCalcoloNominativi"%>
<%@page import="org.aspcfs.modules.dpat2019.base.DpatStrumentoCalcoloNominativiList"%>
<%@page import="org.aspcfs.modules.dpat2019.base.DpatStrumentoCalcoloStruttureList"%>
<%@page import="org.aspcfs.modules.dpat2019.base.DpatStruttura"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>

<script type='text/javascript' src='TableLock.js'></script>
<%@ include file="../../initPage.jsp" %>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session" />
<jsp:useBean id="DpatSDC" class="org.aspcfs.modules.dpat2019.base.DpatStrumentoCalcolo" scope="request"/>
<jsp:useBean id="Qualifica" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="lookupTipologia" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="dpat" class="org.aspcfs.modules.dpat2019.base.Dpat" scope="request"/>
<jsp:useBean id="lookupTipologia2" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="ListaAsl" class="org.aspcfs.utils.web.LookupList" scope="request"/>


<script src="javascript/jquery-1.8.2.js"></script>
<script src="javascript/jquery-ui.js"></script>

<link rel="stylesheet" href="css/jquery-ui.css" />

	<link href="css/smart_wizard.css" rel="stylesheet" type="text/css">

<!--  SERVER DOCUMENTALE -->
 <%@ page import=" org.aspcfs.modules.util.imports.ApplicationProperties"%>
    <%@page import="java.net.InetAddress"%>    
    <link rel="stylesheet" type="text/css" media="print" documentale_url="" href="css/dpat_print_timbro.css" />
<!--  SERVER DOCUMENTALE -->

<script type="text/javascript">
	//loadModalWindow();
	loadModalWindowCustom('<div style="color:red; font-size: 20px;">Attendere prego.... <br>(Se il browser dovesse visualizzare un messaggio di avviso secondo il quale lo script <br> sta impiegando troppo tempo,  cliccare su "continua"  e attendere il completamento)</div>');
	</script>

<script>	


function openMessaggioForm()
{
	
	$( "#esportazioneSdc").dialog({
	    modal: true,
	    title: "ESTRAZIONE ORGANIGRAMMA",
	    height: '400',
	    autoOpen: true,
	    zIndex: 400,
	    width :'750px',
	    show: { effect: 'drop', direction: "down" },
	    buttons: {
	        
	        "CONTINUA": function() {
	        	$("#esportazioneSdcForm").submit();
	        	 $( this ).dialog( "close" );
	           // $( this ).dialog( "close" );
	        },
	        "Esci": function() {
	        	
		           $( this ).dialog( "close" );
		        }
	    }
	});
	
}

	  $(document).ready(function() {
      // Initialize Smart Wizard
      loadModalWindowUnlock();
      
    //  $('#wizard').smartWizard();
      $('#wizard').smartWizard(    		  
    		     {
    		      divHeadPaddingLeft:  2,
    		      divBodyPaddingLeft:   2,
    		      fixedTypeNumber:  1
    		      			
    		      	    }); 

      
  }); 
</script>

<iframe src="empty.html" name="server_commands" id="server_commands" style="visibility:hidden" height="0"></iframe>

<body onload="resizeGlobalItemsPane('hide');">

	<h1>LAVORAZIONE STRUMENTO DI CALCOLO PER LA STRUTTURA : <B><%=DpatSDC.getStrutturaAmbito().getDescrizione_lunga().toUpperCase()%></B></h1>
	<br>

<table class="trails" cellspacing="0" >
		<tr>	
			<td width="100%"><div align="left"><a href="dpat2019.do">DPAT</a> &gt <a href="dpat2019.do?command=Home&combo_area=<%=DpatSDC.getIdStrutturaAreaSelezionata() %>&idAsl=<%=DpatSDC.getIdAsl()%>&anno=<%=DpatSDC.getAnno()%>">Allegati DPAT</a> &gt Organigramma <%=DpatSDC.getAnno() %> ASL <%=ListaAsl.getSelectedValue(DpatSDC.getIdAsl()) %></div></td>
		</tr>
	</table>
 
 <a name= "link" ></a>

		<dhv:permission name="dpat-view">
		<script>
// 		if (document.getElementById("CL")!=null)
// 			{
// 			document.getElementById("CL").style.display="block";
<%-- 			document.getElementById("CL").onclick=function(){window.location='DpatSDC2019.do?command=GeneraXls&idAsl=<%=DpatSDC.getIdAsl()%>&anno=<%=DpatSDC.getAnno()%>&combo_area=<%=DpatSDC.getIdStrutturaAreaSelezionata()%>'; } --%>
// 	}
			</script>
		</dhv:permission>
	
	



<br><br>
 


<br><br>

<table width="100%" border="1" id = "myTable05">
<thead>

<tr style="background-color: red;height: 40px;" >
	<th colspan="4">ORGANIGRAMMA E STRUMENTI DI CALCOLO</th>

</tr>

<tr style="background-color: rgb(204,193,218) ">


	<th>STRUTTURA DI APPARTENENZA</th>
	<th width="300px;" >NOMINATIVO</th>
	<th width="200px;">QUALIFICA</th>
</tr>

</thead>

<%
DpatStrumentoCalcoloStruttureList listStrutture =  DpatSDC.getListaStrutture();

OiaNodo strutturaAmbito = null ;
int rowspan = listStrutture.size()-1;
for (int k = 0 ; k <listStrutture.size();k++)
{
	OiaNodo strutturaTmp = (OiaNodo)listStrutture.get(k);
	if (strutturaTmp.getTipologia_struttura()!=13)
	{
		rowspan+=strutturaTmp.getListaNominativi().size()+1;
	}
	else
	{
		strutturaAmbito = strutturaTmp;
	}
}


int rowid = 0 ;
Qualifica.setSelectStyle("style=\"width: 100%;heigh:100%;\"");
if (listStrutture.size()>0)
{
for (int i = 0 ; i < listStrutture.size(); i++)
{
	rowid = (rowid != 1 ? 1 : 2);
	OiaNodo struttura = (OiaNodo)listStrutture.get(i);
	DpatStrumentoCalcoloNominativiList listaNominativiStruttura = struttura.getListaNominativi();
	String color = "";
	if (struttura.getN_livello()==2){
		if (struttura.getTipologia_struttura()==15){
			color="#A6FBB2";
		} else{
			color="#FFFF00";
		}
	}
	else{
		color="#FFFFFF";
	}
	%>
<%-- 	<tbody id="div_struttura_<%=struttura.getId()%>"  class="row<%= rowid %>"> --%>
	
	
			
	<tr class = "rowclass_t1" <%if((struttura.getTipologia_struttura()==13 || struttura.getTipologia_struttura()==14) && struttura.getAnno()==2016 ){ %> style="display:none" <%} %>>
		
	
		<td  bgcolor="<%=color%>" align="center" style="width: 65px;height: 65px;" rowspan="<%=(listaNominativiStruttura.size()>0)?""+(listaNominativiStruttura.size()+1) :"2"%>">
		<%="<b>" + struttura.getDescrizione_lunga().toUpperCase()+"</b><BR><BR><BR><b>TIPOLOGIA</b> "+lookupTipologia2.getSelectedValue(struttura.getTipologia_struttura())+"" %>
		</td>
	
	</tr>
		
		
		<% 
		if(listaNominativiStruttura.size()>0)
		{
			%>
			
			<%
			for (int j = 0 ; j < listaNominativiStruttura.size(); j++)
			{
				DpatStrumentoCalcoloNominativi nominativo = (DpatStrumentoCalcoloNominativi)listaNominativiStruttura.get(j);
		
		%>
				
				
					<tr id = "nominativo_<%=(j+1) %>_<%=struttura.getId()%>" style="margin-top: 0px;" >
					
					<td align="center" style="font-weight: bold">
					<%=nominativo.getNominativo().getContact().getNameLast() +" " +nominativo.getNominativo().getContact().getNameFirst() %>
					
					</td>
					<td align="center" style="font-weight: bold"><%=Qualifica.getSelectedValue(nominativo.getIdLookupQualifica()).toUpperCase() %></td>
			
				</tr>
				
		<%
			}
		}
		else{
			%>
			
			<tr style="margin-top: 0px;" <%if((struttura.getTipologia_struttura()==13 || struttura.getTipologia_struttura()==14) && struttura.getAnno()==2016 ){ %> style="display:none" <%} %> >
			
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			
		</tr>
		
	<%}
		
}
		
		%>
<!-- 		</tbody> -->
		

	
	<%
}

%>

</tbody>

</table>
 
 
 <div id="esportazioneSdc" style="display: none">
<form method="post" id="esportazioneSdcForm" action="DpatSDC2019.do?command=GeneraXls&idAsl=<%=DpatSDC.getIdAsl()%>&anno=<%=DpatSDC.getAnno()%>&combo_area=<%=DpatSDC.getIdStrutturaAreaSelezionata()%>">
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
       
<tr><th colspan="2"><strong>Questa Estrazione sarà storicizzata all'interno del sistema con le seguenti informazioni</strong></th></tr>       
         <tr>
					<td nowrap class="formLabel">Tipo Estrazione</td>
					
					<td >ORGANIGRAMMA</td>
			</tr>
			<tr>
					<td nowrap class="formLabel">Data Estrazione</td>
					
					<td ><%
					SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
					%>
					<%=sdf.format(new Date(System.currentTimeMillis())) %>
					</td>
			</tr>
			<tr>
					<td nowrap class="formLabel">Estratto da</td>
					
					<td ><%=User.getContact().getNameFirst()+" "+User.getContact().getNameLast() %></td>
			</tr>
			<tr>
					<td nowrap class="formLabel">Estrazione Per Tutte le Strutture Complesse</td>
					
					<td ><input  type = "checkbox" name="checkStrutture" value = "1"></td>
			</tr>
			<tr>
					<td nowrap class="formLabel">Struttura Complessa</td>
					
					<td ><%=DpatSDC.getStrutturaAmbito().getDescrizione_lunga() %></td>
			</tr>
			<tr>
					<td nowrap class="formLabel">Asl</td>
					
					<td ><%= DpatSDC.getStrutturaAmbito().getIdAsl() %></td>
			</tr>
			<tr>
					<td nowrap class="formLabel">Note</td>
					
					<td ><textarea rows="6" cols="30" name="note"></textarea> </td>
			</tr>
</table>
</form>
</div>

</body>

