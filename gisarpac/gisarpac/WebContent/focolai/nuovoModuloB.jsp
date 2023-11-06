<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio"%>
<%@ include file="../initPage.jsp"%>
<%@ page
	import="java.util.*,java.text.DateFormat,org.aspcfs.modules.allevamenti.base.*,org.aspcfs.modules.contacts.base.*,org.aspcfs.modules.base.Constants"%>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean"
	scope="session" />
<jsp:useBean id="Asl" class="org.aspcfs.utils.web.LookupList"
	scope="request" />
<jsp:useBean id="OrgDetails"
	class="org.aspcfs.modules.allevamenti.base.Organization"
	scope="request" />
<jsp:useBean id="focolaio"
	class="org.aspcfs.modules.focolai.base.Focolaio" scope="request" />



<script language="JavaScript" TYPE="text/javascript"
	SRC="javascript/popCalendar.js"></script>

<script type="text/javascript">


function totaleMalati(id)
{
	//alert(" id vale:" +id);
	morti = document.getElementById("morti"+""+id);
	//alert(morti.value);
	abbattuti = document.getElementById("abbattuti"+id);
	guariti = document.getElementById("guariti"+id);
	 totMal = Number(morti.value) + Number(abbattuti.value) + Number(guariti.value);
	totale = document.getElementById("totaleMalati"+id);
	totale.value = totMal;
	totaleEsistenti(id);
}

</script>


<script type="text/javascript">


function totaleEsistenti(id)
{
	//alert(" id vale:" +id);
	totaleM = document.getElementById("totaleMalati"+""+id);
	//alert(totaleM.value);
	smarriti = document.getElementById("smarriti"+id);
	sani = document.getElementById("sani"+id);
	 totE = Number(totaleM.value) + Number(smarriti.value) + Number(sani.value);
	totale = document.getElementById("esistenti"+id);
	totale.value = totE;
}

</script>


<script type="text/javascript">


function totaleMorti(id)
{
	//alert(" id vale:" +id);
	morti = document.getElementById("morti"+""+id);
	totale = document.getElementById("morti6");
	totale.value = Number(totale.value)+ Number(morti.value);
}

function totaleAbbattuti(id)
{
	//alert(" id vale:" +id);
	abbattuti = document.getElementById("abbattuti"+""+id);
	totale = document.getElementById("abbattuti6");
	totale.value = Number(totale.value)+ Number(abbattuti.value);
}

function totaleGuariti(id)
{
	//alert(" id vale:" +id);
	guariti = document.getElementById("guariti"+""+id);
	totale = document.getElementById("guariti6");
	totale.value = Number(totale.value)+ Number(guariti.value);
}

function totaleSmarriti(id)
{
	//alert(" id vale:" +id);
	smarriti = document.getElementById("smarriti"+""+id);
	totale = document.getElementById("smarriti6");
	totale.value = Number(totale.value)+ Number(smarriti.value);
}

function totaleSani(id)
{
	//alert(" id vale:" +id);
	sani = document.getElementById("sani"+""+id);
	totale = document.getElementById("sani6");
	totale.value = Number(totale.value)+ Number(sani.value);
}

function totaleComplessivoMalati(id)
{
	//alert(" id vale:" +id);
	malati = document.getElementById("malati"+""+id);
	//alert(malati.value);
	totale = document.getElementById("malati6");
	totale.value = Number(totale.value)+ Number(malati.value);
}

function totaleDeiTotali(id)
{
	//alert(" id totale vale:" +id);
	esistenti = document.getElementById("esistenti"+""+id);
	//alert(esistenti.value);
	totale = document.getElementById("esistenti6");
	totale.value = Number(totale.value)+ Number(esistenti.value);
}


</script>

<script type="text/javascript">

	<%--
	function doCheck(form) {
		//alert("nel docheck");
	    if (form.dosubmit.value == "false") {
           // alert("nell if");
		    return true;
	  } else {
	    return(checkForm(form));
	  }
	}


	
	
	function checkForm()
	{
		 formTest = true;
		    message = "";
		    alertMessage = "";

            alert("nella funzione");
		    alert("loc: "+form.localita.value);
		    alert("data sosp: "+form.dataSospetto.value);
		    alert("data ap: "+form.dataApertura.value);
		    if (form.localita){
		        if ((checkNullString(form.localita.value))){
		          message += "- Localit� richiesta\r\n";
		          formTest = false;
		        }
		      }

		    if(checkNullString(form.dataSospetto.value)){
	    		message += "- Data sospetto richiesta\r\n";
	    		formTest = false;
	    	}   

		    if(checkNullString(form.dataApertura.value)){
	    		message += "- Data apertura richiesta\r\n";
	    		formTest = false;
	    	}

		    if (formTest == false) {
		        alert(label("check.form", "Form could not be saved, please check the following:\r\n\r\n") + message);
		        return false;
		      } else {
			      return true;
		      }
	}

--%>
	function controlloNumeri(obj) {
		if (isNaN(obj.value) || parseInt(obj.value)<0 || parseInt(obj.value) > 9999)
		{
		alert('Nel campo � possibile immettere solo numeri!');
		obj.value="";
		obj.focus();
		}
		}
	
	
</script>



<form name="focolai"
	action="Focolai.do?command=SalvaModuloB&focolaioId=<%=focolaio.getFocolaioId() %>"
	onsubmit="return doCheck(this);" method="post"><%-- Trails --%>
<table class="trails" cellspacing="0">
	<tr>
		<td><a href="Allevamenti.do"><dhv:label
			name="allevamenti.allevamenti">Accounts</dhv:label></a> > <%
			if (request.getParameter("return") == null) {
		%> <a href="Allevamenti.do?command=Search"><dhv:label
			name="allevamenti.SearchResults">Search Results</dhv:label></a> > <%
			} else if (request.getParameter("return").equals("dashboard")) {
		%> <a href="Allevamenti.do?command=Dashboard"><dhv:label
			name="communications.campaign.Dashboard">Dashboard</dhv:label></a> > <%
			}
		%> <a
			href="Allevamenti.do?command=Details&orgId=<%=OrgDetails.getOrgId() %>"><dhv:label
			name="allevamenti.details">Account Details</dhv:label> </a> > <a
			href="Focolai.do?&orgId=<%=OrgDetails.getOrgId() %>"><dhv:label
			name="focolai">Focolai</dhv:label></a> > <dhv:label
			name="focolai.aggiungi">Aggiungi</dhv:label></td>
	</tr>
</table>

 <input type="hidden" name="siteId" value="<%=OrgDetails.getSiteId()%>">
 <input type="hidden" name="orgId" value="<%=OrgDetails.getOrgId()%>">

<table cellpadding="2" cellspacing="2" border="0" width="100%">
	<tr>
		<td width="100%" valign="top">


		<table cellpadding="4" cellspacing="0" border="0" width="100%"
			class="details">
			<tr>
				<th colspan="2"><strong><dhv:label name="titolo">Denuncia di malattia infettiva e diffusiva degli animali</dhv:label></strong>
				</th>
			</tr>

 
			<!-- modifiche d.dauria -->
			<tr >
				<td class="formLabel"><dhv:label name="allevamenti.site">Site</dhv:label>
				</td>
				<td width="90%"><%=Asl.getSelectedValue(OrgDetails.getSiteId())%>

				</td>
			</tr>


			<dhv:evaluate if="<%=hasText(OrgDetails.getName())%>">
				<tr class="containerBody">
					<td class="formLabel"><dhv:label name="">Denominazione</dhv:label>
					</td>
					<td><%=toHtml(OrgDetails.getName())%>&nbsp;</td>
				</tr>
			</dhv:evaluate>

			<dhv:evaluate if="<%=hasText(OrgDetails.getAccountNumber())%>">
				<tr class="containerBody">
					<td class="formLabel"><dhv:label
						name="organization.accountNumbera">Codice Azienda</dhv:label></td>
					<td><%=toHtml(OrgDetails.getAccountNumber())%>&nbsp;</td>
				</tr>
			</dhv:evaluate>

			<dhv:evaluate if="<%=hasText(OrgDetails.getSpecieAllev())%>">
				<tr class="containerBody">
					<td class="formLabel"><dhv:label
						name="organization.specieAlleva">Specie Allevata</dhv:label></td>
					<td><%=toHtml(OrgDetails.getSpecieAllev())%>&nbsp;</td>
				</tr>
			</dhv:evaluate>

			<dhv:evaluate if="<%=hasText(OrgDetails.getPartitaIva())%>">
				<tr class="containerBody">
					<td class="formLabel"><dhv:label name="">Partita IVA / Codice Fiscale</dhv:label>
					</td>
					<td><%=toHtml(OrgDetails.getPartitaIva())%>&nbsp;</td>
				</tr>
			</dhv:evaluate>


				<%
					Iterator iaddress = OrgDetails.getAddressList().iterator();
						if (iaddress.hasNext()) {
							while (iaddress.hasNext()) {
								OrganizationAddress thisAddress = (OrganizationAddress) iaddress
										.next();
				%>
				<tr class="containerBody">
					<td class="formLabel" valign="top">Sede Legale</td>
					<td><%=toHtml(thisAddress.toString())%>&nbsp; <dhv:evaluate
						if="<%=thisAddress.getPrimaryAddress()%>">
						<dhv:label name="stabilimenti.primary.brackets">(Primary)</dhv:label>
					</dhv:evaluate></td>
				</tr>
				<%
					}
						} else {
				%>
				<tr class="containerBody">
					<td colspan="2"><font color="#9E9E9E"><dhv:label
						name="contacts.NoAddresses">No addresses entered.</dhv:label></font></td>
				</tr>
				<%
					}
				%>
	


			<!--  fine -->



			<tr>
				<th colspan="2"><strong><dhv:label
					name="focolai.denuncia">Denuncia malattia</dhv:label></strong></th>
			</tr>

			<tr>
				<td class="formLabel"><dhv:label name="loc">Malattia</dhv:label>
				</td>
				<td><%=focolaio.getMalattia()%> <input id="classe_sprincipale"
					type="hidden" maxlength="100" size="70" name="malattia"
					value="<%=focolaio.getMalattia()%>" /></td>
			</tr>

			

			<tr>
				<td class="formLabel"><dhv:label name="loc">Localit� della stalla o del pascolo infetto</dhv:label>
				</td>
				<td><%=focolaio.getLocalita()%> <input id="classe_principale"
					type="hidden" maxlength="50" size="50" name="localita"
					value="<%=focolaio.getLocalita()%>" /></td>
			</tr>
			<tr>
				<td class="formLabel"><dhv:label name="acque classificate.cla">Data del sospetto</dhv:label>
				</td>

				<td>
				<%if (focolaio.getDataSospetto() != null) {%> <zeroio:tz
					 timestamp="<%=focolaio.getDataSospetto()%>"
					showTimeZone="false"  dateOnly="true"/>
				<%} %> <input id="classe_principale" type="hidden" maxlength="50"
					size="50" name="dataSospetto"
					value="<%=focolaio.getDataSospetto()%>" /></td>
			</tr>
			<tr>
				<td class="formLabel"><dhv:label name="acque classificate.cla">Data della prova</dhv:label>
				</td>
				<td>
				<%if (focolaio.getDataProva() != null) { %><zeroio:tz  dateOnly="true"
					timestamp="<%=focolaio.getDataProva()%>"
					showTimeZone="false" /> 
				<%} %> <input id="classe_principale" type="hidden" maxlength="50"
					size="50" name="dataProva" value="<%=focolaio.getDataProva()%>" />


				</td>
			</tr>
			<tr>
				<td class="formLabel"><dhv:label name="acque classificate.cla">Data apertura</dhv:label>
				</td>
				<td>
				<%if(focolaio.getDataApertura() != null) {%><zeroio:tz
					    dateOnly="true" timestamp="<%=focolaio.getDataApertura()%>"
					showTimeZone="false" />  
				<%} %> <input id="classe_principale" type="hidden" maxlength="50"
					size="50" name="dataApertura"
					value="<%=focolaio.getDataApertura()%>" /></td>
			</tr>
			<tr>
				<td class="formLabel"><dhv:label name="loc">Origine malattia</dhv:label>
				</td>
				<td><%=focolaio.getOrigineMalattia()%> <input
					id="classe_principaled" maxlength="50"
					value="<%=focolaio.getOrigineMalattia()%>" size="50" type="hidden"
					name="origineMalattia" /></td>
			</tr>




<%--parte vecchia gi� commentata %>
			<%-- 		<tr>
				<td></td>
				<td>In caso di malattie soggette a piani di risanamento
				specificare</td>
			</tr>
			<tr>
				<td class="formLabel"><dhv:label name="loc">Animali di provenienza regionale</dhv:label>
				</td>
				<td>
				<% if( focolaio.getProvenienzaRegionale() != false){ %> <input
					type="checkbox" name="provenienzaRegionale" checked="checked">
				<% }else {%> <input type="checkbox" name="provenienzaRegionale">
				<%} %> &nbsp;&nbsp;Data ultima introduzione <zeroio:dateSelect
					form="focolai" field="dataProvenienzaRegionale" timestamp="<%=focolaio.getDataProvenienzaRegionale()%>"
					showTimeZone="false" /></td>
			</tr>

			<tr>
				<td class="formLabel"><dhv:label name="loc">Animali di provenienza extraregionale</dhv:label>
				</td>
				<td>
				<% if( focolaio.getProvenienzaExtraRegionale() != false){ %> <input
					type="checkbox" name="provenienzaExtraRegionale" checked="checked">
				<% }else {%> <input type="checkbox" name="provenienzaExtraRegionale">
				<%} %> &nbsp;&nbsp;Data ultima introduzione <zeroio:dateSelect
					form="focolai" field="dataProvenienzaExtraRegionale"
					timestamp="<%=focolaio.getDataProvenienzaExtraRegionale()%>"
					showTimeZone="false" /></td>
			</tr>

			<tr>
				<td class="formLabel"><dhv:label name="loc">Pascolo infetto</dhv:label>
				</td>
				<td>
				<% if( focolaio.getPascoloInfetto() != false){ %> <input
					type="checkbox" name="pascoloInfetto" checked="checked"> <% }else {%>
				<input type="checkbox" name="pascoloInfetto"> <%} %>
				</td>
			</tr>

			<tr>
				<td class="formLabel"><dhv:label name="loc">Reinfezione</dhv:label>
				</td>
				<td>
				<% if( focolaio.getReinfezione() != false){ %> <input type="checkbox"
					name="reinfezione" checked="checked"> <% }else {%> <input
					type="checkbox" name="reinfezione"> <%} %>
				</td>
			</tr>

			<tr>
				<td class="formLabel"><dhv:label name="loc">Cani infetti</dhv:label>
				</td>
				<td>
				<% if( focolaio.getCaniInfetti() != false){ %> <input type="checkbox"
					name="caniInfetti" checked="checked"> <% }else {%> <input
					type="checkbox" name="caniInfetti"> <%} %>
				</td>
			</tr>

			<tr>
				<td class="formLabel"><dhv:label name="loc">Monta esterna</dhv:label>
				</td>
				<td>
				<% if( focolaio.getMontaEsterna() != false){ %> <input type="checkbox"
					name="montaEsterna" checked="checked"> <% }else {%> <input
					type="checkbox" name="montaEsterna"> <%} %>
				</td>
			</tr>

			<tr>
				<td class="formLabel"><dhv:label name="loc">Iatrogena</dhv:label>
				</td>
				<td>
				<% if( focolaio.getIatrogena() != false){ %> <input type="checkbox"
					name="iatrogena" checked="checked"> <% }else {%> <input
					type="checkbox" name="iatrogena"> <%} %>
				</td>
			</tr>
		
		
	fino a qui--%>
	
		</table>
		<br />
		<table cellpadding="4" cellspacing="0" border="0" width="100%"
			class="details">

			<tr>
				<th colspan="2"><strong><dhv:label
					name="acque classificate.decrddeto">Riepilogo dati sul decorso della malattia</dhv:label></strong>
				</th>

			</tr>
			<tr>

				<td>
				<table width="100%" border="1">
					<tr>
						<td width="20%" colspan="2">*</td>
						<td width="30%" colspan="4" align="center">Animali malati</td>
						<td width="15%" align="center">Smarriti/sottratti</td>
						<td width="15%" align="center">Sani</td>
						<td width="20%" align="center">Esistenti</td>

					</tr>

					<tr>

						<td rowspan="4">A. Animali recettivi alla malattia esistenti
						all'inizio</td>

						<td align="center"><dhv:label
							name="acque classificate.identificativo_decrecccto">Specie</dhv:label>
						</td>


						<td align="center" ><dhv:label
							name="acque classificate.identificativo_decrecccto">1.morti</dhv:label>
						</td>

						<td align="center"><dhv:label
							name="acque classificate.identificativo_decrecccto">2.abbattuti</dhv:label>
						</td>

						<td align="center" ><dhv:label
							name="acque classificate.identificativo_decrecccto">3.guariti</dhv:label>
						</td>

						<td align="center" ><dhv:label
							name="acque classificate.identificativo_decrecccto">4.totale malati (1+2+3)</dhv:label>
						</td>


						<td align="center" ><dhv:label
							name="acque classificate.identificativo_decrecccto">5</dhv:label>
						</td>

						<td align="center"><dhv:label
							name="acque classificate.identificativo_decrecccto">6</dhv:label>
						</td>

						<td align="center" ><dhv:label
							name="acque classificate.identificativo_decrecccto">7 (4+5+6)</dhv:label>
						</td>

					</tr>

					<tr>

						<td align="center"><input type="text" size="20"
							name="specie1" /></td>


						<td align="center" ><input type="text" size="7" name="morti1"
							onBlur="controlloNumeri(this)" value="0" id="morti1"
							onChange="totaleMalati(1);totaleMorti(1);" /></td>

						<td align="center"><input type="text" size="7"
							name="abbattuti1" onBlur="controlloNumeri(this)" id="abbattuti1"
							onChange="totaleMalati(1);totaleAbbattuti(1);" value="0" /></td>

						<td align="center"><input type="text" size="7"
							name="guariti1" onBlur="controlloNumeri(this)" id="guariti1"
							onChange="totaleMalati(1);totaleGuariti(1);" value="0" /></td>

						<td align="center"><input type="text" size="7" id="totaleMalati1"
							name="totaleMalati1" onBlur="controlloNumeri(this)" onChange="totaleEsistenti(1);totaleComplessivoMalati(1);" value="0" /></td>


						<td align="center"><input type="text" size="7" id="smarriti1"
							name="smarriti1" onBlur="controlloNumeri(this)" onChange="totaleEsistenti(1);totaleSmarriti(1);" value="0" /></td>

						<td align="center"><input type="text" size="7" name="sani1" id="sani1"
							onBlur="controlloNumeri(this)" onChange="totaleEsistenti(1);totaleSani(1);" value="0" /></td>

						<td align="center"><input type="text" size="7" id="esistenti1"
							name="esistenti1" onBlur="controlloNumeri(this)" value="0" onChange="totaleDeiTotali(1);" /></td>

					</tr>



					<tr>

						<td align="center"><input type="text" size="20"
							name="specie2" /></td>


						<td align="center" ><input type="text" size="7" name="morti2"  id="morti2"
							onBlur="controlloNumeri(this)" value="0"
							 onChange="totaleMalati(2);totaleMorti(2);"></td>

						<td align="center" ><input type="text" size="7" id="abbattuti2"
							name="abbattuti2" onBlur="controlloNumeri(this)" value="0"
							onChange="totaleMalati(2);totaleAbbattuti(2);" /></td>

						<td align="center"><input type="text" size="7" id="guariti2"
							name="guariti2" onBlur="controlloNumeri(this)" value="0"
							onChange="totaleMalati(2);totaleGuariti(2);" /></td>

						<td align="center"><input type="text" size="7"
							name="totaleMalati2" id="totaleMalati2" onBlur="controlloNumeri(this)" onChange="totaleEsistenti(2);totaleComplessivoMalati(2);" value="0" /></td>


						<td align="center"><input type="text" size="7"
							name="smarriti2" id="smarriti2" onBlur="controlloNumeri(this)" onChange="totaleEsistenti(2);totaleSmarriti(2);" value="0" /></td>

						<td align="center"><input type="text" size="7" name="sani2" id="sani2"
							onBlur="controlloNumeri(this)" value="0" onChange="totaleEsistenti(2);totaleSani(2);" /></td>

						<td align="center"><input type="text" size="7" id="esistenti2"
							name="esistenti2" onBlur="controlloNumeri(this)" value="0" onChange="totaleDeiTotali(2);"/></td>

					</tr>



					<tr>

						<td align="center"><input type="text" size="20"
							name="specie3" /></td>


						<td align="center" ><input type="text" size="7" name="morti3" id="morti3"
							onBlur="controlloNumeri(this)" value="0"
							onChange="totaleMalati(3);totaleMorti(3);" /></td>

						<td align="center"><input type="text" size="7" id="abbattuti3"
							name="abbattuti3" onBlur="controlloNumeri(this)" value="0"
							onChange="totaleMalati(3);totaleAbbattuti(3);" /></td>

						<td align="center"><input type="text" size="7" id="guariti3"
							name="guariti3" onBlur="controlloNumeri(this)" value="0"
							onChange="totaleMalati(3);totaleGuariti(3);" /></td>

						<td align="center"><input type="text" size="7" id="totaleMalati3"
							name="totaleMalati3" onBlur="controlloNumeri(this)" value="0" onChange="totaleEsistenti(3);totaleComplessivoMalati(3);" /></td>


						<td align="center"><input type="text" size="7" id="smarriti3"
							name="smarriti3" onBlur="controlloNumeri(this)" value="0" onChange="totaleEsistenti(3);totaleSmarriti(3);" /></td>

						<td align="center"><input type="text" size="7" name="sani3" id="sani3"
							onBlur="controlloNumeri(this)" value="0" onChange="totaleEsistenti(3);totaleSani(3);" /></td>

						<td align="center"><input type="text" size="7" id="esistenti3"
							name="esistenti3" onBlur="controlloNumeri(this)" value="0" onChange="totaleDeiTotali(3);"/></td>

					</tr>



					<tr>

						<td rowspan="2">B. Animali recettivi alla malattia nati dopo
						l'apertura del focolaio</td>

						<td align="center"><input type="text" size="20" 
							name="specie4" /></td>


						<td align="center" ><input type="text" size="7" name="morti4" id="morti4"
							onBlur="controlloNumeri(this);totaleMorti(4);" onChange="totaleMalati(4)"
							value="0" /></td>

						<td align="center"><input type="text" size="7"
							name="abbattuti4" onBlur="controlloNumeri(this)" id="abbattuti4"
							onChange="totaleMalati(4);totaleAbbattuti(4);" value="0" /></td>

						<td align="center"><input type="text" size="7" id="guariti4"
							name="guariti4" onBlur="controlloNumeri(this)"
							onChange="totaleMalati(4);totaleGuariti(4);" value="0" /></td>

						<td align="center"><input type="text" size="7" id="totaleMalati4"
							name="totaleMalati4" onBlur="controlloNumeri(this)" value="0" onChange="totaleEsistenti(4);totaleComplessivoMalati(4);" /></td>


						<td align="center"><input type="text" size="7" id="smarriti4"
							name="smarriti4" onBlur="controlloNumeri(this)" value="0" onChange="totaleEsistenti(4);totaleSmarriti(4);" /></td>

						<td align="center"><input type="text" size="7" name="sani4" id="sani4"
							onBlur="controlloNumeri(this)" value="0" onChange="totaleEsistenti(4);totaleSani(4);" /></td>


						<td align="center"><input type="text" size="7" id="esistenti4"
							name="esistenti4" onBlur="controlloNumeri(this)" value="0" onChange="totaleDeiTotali(4);"/></td>

					</tr>




					<tr>



						<td align="center"><input type="text" size="20"
							name="specie5" /></td>


						<td align="center" ><input type="text" size="7" name="morti5" id="morti5"
							onBlur="controlloNumeri(this);totaleMorti(5);" onChange="totaleMalati(5)"
							value="0" /></td>

						<td align="center"><input type="text" size="7" id="abbattuti5"
							name="abbattuti5" onBlur="controlloNumeri(this)"
							onChange="totaleMalati(5);totaleAbbattuti(5);" value="0" /></td>

						<td align="center"><input type="text" size="7" id="guariti5"
							name="guariti5" onBlur="controlloNumeri(this)"
							onChange="totaleMalati(5);totaleGuariti(5);" value="0" /></td>

						<td align="center"><input type="text" maxlength="50" size="7" id="totaleMalati5"
							name="totaleMalati5" onBlur="controlloNumeri(this)" value="0" onChange="totaleEsistenti(5);totaleComplessivoMalati(5);" /></td>


						<td align="center"><input type="text" size="7" id="smarriti5"
							name="smarriti5" onBlur="controlloNumeri(this)" value="0" onChange="totaleEsistenti(5);totaleSmarriti(5);" /></td>


						<td align="center"><input type="text" maxlength="50" size="7" id="sani5"
							name="sani5" onBlur="controlloNumeri(this)" value="0" onChange="totaleEsistenti(5);totaleSani(5);" /></td>


						<td align="center"><input type="text" size="7" id="esistenti5"
							name="esistenti5" onBlur="controlloNumeri(this)" value="0" onChange="totaleDeiTotali(5);"/></td>

					</tr>

					<tr>

						<td>Totale (A+B)</td>

						<td align="center"><input type="text" size="20"
							name="specie6" /></td>


						<td align="center" bgcolor="yellow"><input type="text" size="7" name="morti6" id="morti6"
							onBlur="controlloNumeri(this)" value="0" /></td>

						<td align="center" ><input type="text" size="7" id="abbattuti6"
							name="abbattuti6" onBlur="controlloNumeri(this)" value="0" /></td>

						<td align="center" ><input type="text" size="7" id="guariti6"
							name="guariti6" onBlur="controlloNumeri(this)" value="0" /></td>

						<td align="center" ><input type="hidden" size="7" id="totaleMalati6"
							name="totaleMalati6" onBlur="controlloNumeri(this)" value="0" /></td>


						<td align="center" ><input type="text" size="7" id="smarriti6"
							name="smarriti6" onBlur="controlloNumeri(this)" value="0" /></td>

						<td align="center" ><input type="text" size="7" name="sani6" id="sani6"
							onBlur="controlloNumeri(this)" value="0" /></td>


						<td align="center"><input type="hidden" size="7" id="esistenti6"
							name="esistenti6" onBlur="controlloNumeri(this)" value="0" /></td>

					</tr>

				</table>

				</td>

			</tr>


		</table>



		<br />
		<table cellpadding="4" cellspacing="0" border="0" width="100%"
			class="details">

			<tr>
				<th colspan="2"><strong><dhv:label
					name="acque classificate.decrddeto">Provvedimenti</dhv:label></strong></th>
			</tr>

			<tr>
				<td class="formLabel"><dhv:label name="acque classificate.cla">Sindaco</dhv:label>
				</td>
				<td>Data <zeroio:dateSelect form="focolai"
					field="dataProvvedimenti" showTimeZone="false" /> Numero dei
				provvedimenti <input type="text" size="30"
					name="numeroProvvedimenti" /></td>
			</tr>

			<tr>
				<td class="formLabel"><dhv:label name="acque classificate.cla">Proposte Settore Veterinario Regionale</dhv:label>
				</td>
				<td><input type="text" size="30" name="proposteAdozione" /></td>
			</tr>

			<tr>
				<td class="formLabel"><dhv:label name="acque classificate.cla">Date esito (guarigione /morte/ abbattimento) ultimo caso malattia</dhv:label>
				</td>
				<td><zeroio:dateSelect form="focolai" field="dataUltimoCaso"
					showTimeZone="false" /></td>
			</tr>

			<tr>
				<td class="formLabel"><dhv:label name="acque classificate.cla">Date revoca provvedimenti del Sindaco</dhv:label>
				</td>
				<td><zeroio:dateSelect form="focolai" field="dataRevocaSindaco"
					showTimeZone="false" /></td>
			</tr>

			<tr>
				<td class="formLabel"><dhv:label name="acque classificate.cla">Proposte di revoca</dhv:label>
				</td>
				<td><input type="text" size="50" name="proposteRevoca" /></td>
			</tr>

			<tr>
				<td class="formLabel"><dhv:label name="acque classificate.cla">Osservazioni</dhv:label>
				</td>
				<td><input type="text" size="50" name="osservazioni" /></td>
			</tr>

		</table>







		</td>

	</tr>

</table>



<input type="submit"
	value="<dhv:label name="button.save">Save</dhv:label>"></form>


