
<%@page import="org.aspcfs.modules.macellazioni.base.Condizione"%>
<%@page import="org.aspcfs.modules.acquedirete.actions.AcqueReteVigilanza"%>
<%@page import="org.aspcfs.modules.dpat2019.base.PianoMonitoraggio"%>
<%@page import="org.aspcfs.modules.oia.base.OiaNodo"%>
<%@page import="org.aspcfs.utils.web.LookupElement"%>
<%@page import="org.aspcfs.utils.PopolaCombo"%>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></script>
<%@page import="org.aspcfs.modules.login.beans.UserBean"%>
<jsp:useBean id="SpecieA" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="OggettoAudit" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="Condizionalita" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="VerificaQuantitativo" class="org.aspcfs.utils.web.LookupList" scope="request" />	

<script type="text/javascript" src="dwr/interface/PopolaCombo.js"> </script>
<script type="text/javascript" src="dwr/interface/NucleoIspettivo.js"> </script>
<script type="text/javascript" src="dwr/engine.js"> </script>
<script type="text/javascript" src="dwr/util.js"></script>

<SCRIPT LANGUAGE="JavaScript" SRC="javascript/CalendarPopup.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">document.write(getCalendarStyles());</SCRIPT>
<SCRIPT LANGUAGE="JavaScript" ID="js19">
	var cal19 = new CalendarPopup();
	cal19.showYearNavigation();
	cal19.showYearNavigationInput();
	cal19.showNavigationDropdowns();
</SCRIPT>




<script type="text/javascript">

 


function controlloCuSorveglianza()
{

	loadModalWindow();
	
if (document.addticket.assignedDate.value == '')
	return checkForm(document.addticket);
orgId = document.addticket.idstabilimentoopu.value;
assetId = -1 ;
if (document.addticket.assetId!=null)
{
	assetId = document.addticket.assetId.value;
}




PopolaCombo.controlloInserimentoCuSorveglianza(orgId, false,false,document.addticket.assignedDate.value,assetId, {callback:viewMessageCallback1,async:false } );
return formTest;
}



function mostraStrutturaAsl()
{
tipoIspezione = document.getElementById('tipoCampione').value ;
select=document.getElementById('uo') ;

if (tipoIspezione == '4' || tipoIspezione == '3')
{
	document.getElementById('per_conto_di').style.display="none";
	
	
	

}
else
{
	document.getElementById('per_conto_di').style.display="";

	
}



}

function viewMessageCallback1(returnValue) {

    messaggio1 = returnValue[0];
    messaggio2 = returnValue[1];
    messaggio3 = returnValue[2];
    messaggio4 = returnValue[3];
    messaggio5 = returnValue[4];
    messaggio6 = returnValue[5];

    role = document.getElementById("role_user").value;
    flag = true ;

 
    	
    	if (messaggio4!='')
    	{
    		alert(messaggio4);
    		flag=false;
    	}
    	if(messaggio2!="" || messaggio3!="" || messaggio5!="")
    	{
    		
    		/**
    		 * SE DATA INIZIO CONTROLLO � ANTECEDENTE ALLA DATA PROSSIMO CONTROLLO - 30 GG
    		 * IL SISTEMA GENERER� UN MESSAGGIO NON BLOCCANTE.
    		 * (VALE SOLO PER I CONTROLLI IN SORVEGLIANZA)
    		 */
    	
    	/**
    	 * SE DATA INIZIO CONTROLLO � INFERIORE ALLA DATA ATTUALE -30 GIORNI IL SISTEMA SEGNALA UN
    	 * MESSAGGIO NON BLOCCANTE (IL MESSAGGIO SARA BLOCCANTE A PARTIRE DA GENNAIO 2012)
    	 * VALE PER TUTTI I TIPI DI CONTROLLO
    	 */
    	 
    	//messaggio3 � legato all'inserimento dei controlli per l'anno 2014...
    	//messaggio5 � legato all'inserimento dei controlli per l'anno 2013...
    	
    	if ((messaggio3 != null && messaggio3 != "" ) ) 
    	{
    		//mssg = "Se la richiesta per l'inserimento dei controlli � per l'anno corrente cliccando su OK, sar� possibile proseguire con l'operazione.\n Viceversa, non sar� possibile proseguire." ;
    		if (flag == true)
    		{
    			if (isPianomonitoraggio==false)
    			{

    				alert(messaggio3 );

    			}
    			else
    			{
    				alert(messaggio3 );

    			}
    		}
    	}
    		
    	if ((messaggio5 != null && messaggio5 != "" ) ) 
    	{
    		//mssg = "Se la richiesta per l'inserimento dei controlli � per l'anno corrente cliccando su OK, sar� possibile proseguire con l'operazione.\n Viceversa, non sar� possibile proseguire." ;
    		if (flag == true)
    		{
    			if (isPianomonitoraggio==false)
    			{

    				alert(messaggio5 );

    			}
    			else
    			{
    				alert(messaggio5 );

    			}
    		}
    	}
    	
    	

    	if ((messaggio2 != null && messaggio2 != "" && isSorveglianza==true) ) 
    	    	{
    	    		//mssg = "Se la richiesta per l'inserimento dei controlli � per l'anno corrente cliccando su OK, sar� possibile proseguire con l'operazione.\n Viceversa, non sar� possibile proseguire." ;
    	    		if (flag == true)
    	    		{
    	    			

    	    				alert('Attenzione non � possibile inserire Controlli in Sorveglianza Ravvicinati. Controllo inseribile a partire dal'+messaggio2 );

    	    			    		}
    	    	}

    		
    		if(document.getElementById("cu_pregresso")==null || (document.getElementById("cu_pregresso")!= null && document.getElementById("cu_pregresso").checked == false))
    			flag = false;
    		else
    			if(document.getElementById("cu_pregresso").checked==true && messaggio5 =='')
    				flag = true;
    			else
    				{
    				if(document.getElementById("cu_pregresso").checked==true && messaggio5 !=''){
    					
    					flag = false;
    				}
    				//pregresso 2013 di nurecu non per autorit� competenti
    				if(document.getElementById("cu_pregresso").checked==true && messaggio5 !='' ){
    					
    					flag = false;
    				}
    					
    				}

    	}
    	else
    		{
    		
    			if (flag == true)
    				return checkForm(document.addticket);
    		}
    if (flag == true)
    {
        
    	
    return checkForm(document.addticket);
    }
    else{
    	if(messaggio2 != null && messaggio2 != "" )
    	//CASO MESSAGGIO 2 valorizzato: la data del prossimo controllo � successiva alla data in cui tenti
    	//di inserire il controllo.
    		alert('ATTENZIONE! La data del prossimo controllo in sorveglianza che � possibile inserire in G.I.S.A. per questo operatore � '+messaggio2+'.');	
    	return false;
    }
   
    }

</script>



<%
		UserBean utente1 = (UserBean)session.getAttribute("User");
%>
<input type="hidden" name="role_user" id="role_user" value="<%=utente1.getUserRecord().getRoleId() %>">



<dhv:include name="stabilimenti-sites" none="true">
	<%--  <dhv:evaluate if="<%= SiteIdList.size() > 1 %>"> --%>
	<tr>
		<td nowrap class="formLabel"><dhv:label name="stabilimenti.site">Site</dhv:label>
		</td> 
		<td>
		
		<%
		UserBean utente = (UserBean)session.getAttribute("User");
		if (utente.getSiteId()>0){ %>
		<%=SiteIdList.getSelectedValue(utente.getSiteId())%> 
		<input type="hidden" name="siteId" id = "siteId" value="<%=utente.getSiteId()%>">
		
		<%}
		else
		{
			if(OrgDetails.getIdAsl()>0)
			{
				
				%>
				<%=SiteIdList.getSelectedValue(OrgDetails.getIdAsl())%> 
		<input type="hidden" name="siteId" id = "siteId" value="<%=OrgDetails.getIdAsl()%>">
		<%}
		else
		{%>
		
		<%=SiteIdList.getHtmlSelect("siteId",-1)%>
		<%}
				
				
			}
		%>
		</td>
	</tr>
	<%--</dhv:evaluate>  --%>
	<dhv:evaluate if="<%=SiteIdList.size() <= 1%>">
		<input type="hidden" name="siteId" id="siteId" value="-1" />
	</dhv:evaluate>
</dhv:include>

 <tr class="containerBody">
      <td nowrap class="formLabel">
       Operatore Sottoposto a controllo
      </td>
      <td><%="<b>"+OrgDetails.getName()+"<b>" %> </h3></td>
    </tr>

<tr class="containerBody">
	<td nowrap class="formLabel"><dhv:label name="">Tecnica di controllo</dhv:label>
	</td>
	<td><%=TipoCampione.getHtmlSelect("tipoCampione", 4)%></td>
	</tr>





<%-- <% if (OrgDetails.getContainer().equals("sintesis")){%> --%>
<%-- <%@ include file="../controlliufficiali/sintesis_linea_attivita_imprese.jsp" %> --%>

<%-- <%}  --%>
<% if (request.getAttribute("ViewLdA")!=null)
{
%>
<%@ include file="../controlliufficiali/linea_attivita_imprese.jsp" %>

<%	
}


if (request.getAttribute("ViewLdAStab")!=null)
{
%>
<%@ include file="../controlliufficiali/linea_attivita_stabilimenti.jsp" %>

<%	
}
if (request.getAttribute("ViewLdASoa")!=null)
{
%>
<%@ include file="../controlliufficiali/linea_attivita_soa.jsp" %>

<%	
}

%>


<tr class="containerBody">
	<td nowrap class="formLabel"><dhv:label
		name="sanzionia.data_richiesta">Data Inizio Controllo</dhv:label></td>
	<td>
<font color="red">*</font>

<input readonly type="text" id="assignedDate" name="assignedDate" size="10" />
		<a href="#" onClick="cal19.select(document.forms[0].assignedDate,'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19">
		<img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle">
		</a>
<font color="red"><%= showError(request, "assignedDateError") %>


	<dhv:permission name="cu-pregresso-view" >
		Inserimento cu Pregresso <input type = "checkbox" name = "cu_pregresso" id = "cu_pregresso" value = "1">
		<!-- A seguito di una richiesta da parte dell'ORSA di poter inserire i CU degli anni precedenti
		verr� commentato quanto riportato tra parentesi e dato il permesso.
			(non e' possibile inserire controlli per gli anni precedenti)
		 -->
	
	</dhv:permission>
	
	</td>
</tr>


<tr class="containerBody">
	<td nowrap class="formLabel"><dhv:label name="">Data Fine Controllo</dhv:label>
	</td>
	<td>

	
		
		<input readonly type="text" id="dataFineControllo" name="dataFineControllo" size="10" />
		<a href="#" onClick="cal19.select(document.forms[0].dataFineControllo,'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19">
		<img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
</td>
</tr>

<tr>
	<td valign="top" class="formLabel"><dhv:label name="sanzioni.note">Note</dhv:label>
	</td>
	<td>
	<table border="0" cellspacing="0" cellpadding="0" class="empty">
		<tr>
			<td><textarea name="problem" cols="55" rows="8"><%=toString(TicketDetails.getProblem())%></textarea>
			</td>
			<td valign="top"><%=showAttribute(request, "problemError")%></td>
		</tr>
	</table>
	</td>
</tr>

<tr id="oggetto_controllo">
	<td valign="top" class="formLabel">Oggetto del Controllo</td>
	<td>
	<table border="0" cellspacing="0" cellpadding="0" class="empty">
		<tr>
		
		<td rowspan="3" id = "sorveglianza" style="display: none">
		<%=IspezioneMacrocategorie.getHtmlSelect("ispezione_macro",-1) %>
		<font color="red">*</font>
		</td>
		
		
			<td rowspan="3" id = "non_sorveglianza" style="display: block">
			<select name="ispezione" <%if (TipoIspezione.size()>1){ %> multiple="multiple" size="10"<%} %> id="ispezione"
				onmouseout="abilitaNoteDescrizioni();">
				<%
					Iterator<Integer> itLista = Ispezione.keySet().iterator();
					while (itLista.hasNext()) {
						int key = itLista.next();
				%>
				<optgroup label="<%=IspezioneMacrocategorie.getValueFromId(key)%>" style="color: blue"></optgroup>

				<%
					HashMap<Integer, String> l = (HashMap<Integer, String>) Ispezione.get(key);
						Iterator<Integer> itL = l.keySet().iterator();
						while (itL.hasNext()) {
							int code = itL.next();
							String desc = l.get(code);
							boolean sel = false;

							if (request.getAttribute("listaControlliIspezione")!=null)
							{
								ArrayList<Integer> lista = (ArrayList<Integer>) request.getAttribute("listaControlliIspezione");
								if (lista != null) {
									for (int code2 : lista) {

										if (code2 == code) {
											sel = true;
										}
									}
								}
							}
								
				%>


				<option value="<%=code%>" <%if (sel == true) {%> selected="selected"
					<%}%>><%=desc%></option>
				<%
					}

					}
				%>
			</select><font color="red">*</font></td>
			<td>&nbsp;</td>
			<td>
			<table>
				<tr id="desc_note1" style="display: none">
					<td><b>Settore Alimenti per il consumo Umano (Descrizione)</b><br>
					<textarea rows="3" cols="20" name="ispezioni_desc1"></textarea></td>
				</tr>
				<tr id="desc_note2" style="display: none">
					<td><b>Settore alimenti Zootecnici (Descrizione)</b><br>
					<textarea rows="3" cols="20" name="ispezioni_desc2"></textarea></td>
				</tr>
				<tr id="desc_note3" style="display: none">

					<td><b>Settore Benessere Animale non durante il trasporto</b><br>

					<td><b>Settore Benessere Animale (Descrizione)</b><br>

					<textarea rows="3" cols="20" name="ispezioni_desc3"></textarea></td>
				</tr>
				<tr id="desc_note4" style="display: none">
					<td><b>Settore Sanita animale (Descrizione)</b><br>
					<textarea rows="3" cols="20" name="ispezioni_desc4"></textarea></td>
				</tr>
				<tr id="desc_note5" style="display: none">
					<td><b>Settore S.O.A. negli Impianti di trasformazione (Descrizione)</b><br>
					<textarea rows="3" cols="20" name="ispezioni_desc5"></textarea></td>
				</tr>
				<tr id="desc_note6" style="display: none">
					<td><b>Settore Rifiuti S.O.A. nelle altre imprese (Descrizione)</b><br>
					<textarea rows="3" cols="20" name="ispezioni_desc6"></textarea></td>
				</tr>
				<tr id="desc_note7" style="display: none">
					<td><b>Altro (Descrizione)</b><br>
					<textarea rows="3" cols="20" name="ispezioni_desc7"></textarea></td>
				</tr>
				<tr id="desc_note8" style="display: none">
					<td><b>Settore benessere animale durante il trasporto </b><br>
					<textarea rows="3" cols="20" name="ispezioni_desc8"></textarea></td>
				</tr>
				
			</table>
			</td>

		</tr>
	</table>
	</td>
</tr>

 <input type = "hidden" id = "modificabile" name  = "modificabile" value = "yes">
<input type="hidden" name="ncrilevate" value="2" />
<!-- nucleo ispettivo -->
<%@ include file="nucleo_ispettivo_modify.jsp"%>

