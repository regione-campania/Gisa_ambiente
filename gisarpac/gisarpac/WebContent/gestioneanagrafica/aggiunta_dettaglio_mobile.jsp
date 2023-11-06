<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>
<%@ include file="../initPage.jsp"%>
<%@page import="org.aspcfs.modules.opu.base.LineaProduttiva"%>
<%@page import="org.aspcfs.modules.opu.base.LineaProduttivaList"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.aspcfs.modules.opu.base.LineeMobiliHtmlFields"%>
<%@page import="java.util.*"%>
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/suapUtil.js"></script>

<jsp:useBean id="messaggioOk" class="java.lang.String" scope="request"/>

<jsp:useBean id="campiHash" class="java.util.LinkedHashMap" scope="request"/>
<jsp:useBean id="campiHashSenzaValore" class="java.util.LinkedHashMap" scope="request"/>
<jsp:useBean id="campiHashVisualize" class="java.util.LinkedHashMap" scope="request"/>
<jsp:useBean id="Operatore" class="org.aspcfs.modules.opu.base.Operatore" scope="request"/>
<jsp:useBean id="StabilimentoDettaglio" class="org.aspcfs.modules.opu.base.Stabilimento" scope="request"/>
<jsp:useBean id="TipoAlimentoDistributore" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="TipoMobili" class="org.aspcfs.utils.web.LookupList" scope="request"/>


<%
	boolean consentiUploadFile = (Boolean)request.getAttribute("consentiUploadFile");
	boolean consentiValoriMultipli = (Boolean)request.getAttribute("consentiValoriMultipli");
%>


	<%if (messaggioOk!=null && !messaggioOk.equals("")){ %>
	<script>alert('<%=messaggioOk%>');
	//window.close();
	window.location.href='GestioneAnagraficaAction.do?command=GestioneMobile&stabId=<%=StabilimentoDettaglio.getIdStabilimento()%>&opId=<%=Operatore.getIdOperatore()%>';
	</script>
	<font color="green"><b><%=messaggioOk %></b></font>
	<%}else{ %>
	
	


	
<DIV ID='modalWindow' CLASS='unlocked'><P CLASS='wait'>Attendere il completamento dell'operazione...</P></DIV>
</div>

<input type="button" value="ESCI" onClick="$( '#dialogMOBILE' ).dialog('close');"/>


<!-- -----------FORM VISUALIZZAZIONE----------- -->
<% 
int numCol=	(Integer)request.getAttribute("numeroCampi");
Set<Entry> entries = campiHash.entrySet();

ArrayList<LineeMobiliHtmlFields> elementi=(ArrayList<LineeMobiliHtmlFields>) request.getAttribute("listaElementi");


if (!entries.isEmpty())
{ 

%>
<br><br>


<%
	if(consentiValoriMultipli)
	{
%>
		<table width="100%">
			<th align="center" colspan="<%=(numCol+2) %>" bgcolor="#5CB8E6">ELEMENTI GIA' PRESENTI</th>
			<tr>
<% 
			// Costruisco intestazione tabella elemtni presenti
			for (Entry entry : entries) 
			{ 
%>
				<td align="center" style="border:1px solid black;"> 
					<b><%=entry.getKey().toString().toUpperCase() %></b>
				</td>
<% 
			} 
%>
				<td align="center" style="border:1px solid black;"><b>DATI INSERIMENTO </b></td>
				<td align="center" style="border:1px solid black;"><b>OPERAZIONE </b></td>
			</tr>
<%
			int i=1;
			String indice="";
			// Costruisco tabella elementi presenti
			Iterator<LineeMobiliHtmlFields> elem =  elementi.iterator();
			
			while(elem.hasNext())
			{
				LineeMobiliHtmlFields elemento = (LineeMobiliHtmlFields) elem.next();
				if(i==1)
				{
%>
					<tr>
<% 
				} 
%>
					<td style="border:1px solid black;" bgcolor="#E6E6E6">&nbsp;
<%
					if(elemento.getTabella_lookup()==null || elemento.getTabella_lookup().equals(""))
					if(elemento.getTipo_campo().equals("checkbox"))
					{
						out.print((elemento.getValore_campo()!=null && elemento.getValore_campo().equalsIgnoreCase("true")) ? "SI": "NO");
					}
					else
						out.print((elemento.getValore_campo()!=null) ? elemento.getValore_campo().toUpperCase(): "");
					else
					{
						if(elemento.getTabella_lookup().contains("mobili"))
							out.print(TipoMobili.getSelectedValue(elemento.getValore_campo()).toUpperCase());
						else
							out.print(elemento.getLookupCampo().getSelectedValue(elemento.getValore_campo()).toUpperCase());
					}
%>
					</td>
<% 
					i++;
					if(i==numCol+1)
					{
						i=1;
						indice=elemento.getIndice();
%>
					<td align="center" style="border:1px solid black;" bgcolor="#E6E6E6"><dhv:username id="<%= elemento.getIdUtenteInserimento() %>" /> il <%=toDateasString(elemento.getDataInserimento()) %>    </td>
					<td align="center" style="border:1px solid black;" bgcolor="#E6E6E6"><input type="button" value="Elimina" onclick="location.href='GestioneAnagraficaAction.do?command=EliminaMobileDaLinea&indice=<%=indice%>&ldaStabId=<%=request.getParameter("ldaStabId") %>&stabId=<%=request.getParameter("stabId") %>'"/></td></tr>
<%
					}
				} 
%>
</table>
<%
	}
	else
	{
%>
		<table width="100%">
			<th align="center" colspan="<%=(numCol+2) %>" bgcolor="#5CB8E6">ELEMENTI GIA' PRESENTI</th>
			<tr>
				<td align="center" style="border:1px solid black;"> 
					NOME CAMPO
				</td>
				<td align="center" style="border:1px solid black;"> 
					VALORE
				</td>
				<td align="center" style="border:1px solid black;"> 
					DATI MODIFICA
				</td>
			</tr>
<% 
			Iterator<LineeMobiliHtmlFields> elem =  elementi.iterator();
			for (Entry entry : entries) 
			{ 
				LineeMobiliHtmlFields elemento = (LineeMobiliHtmlFields) elem.next();
%>
				<tr>
				<td style="border:1px solid black;" bgcolor="#E6E6E6">
					<%=entry.getKey().toString().toUpperCase()%>
				</td>
				<td style="border:1px solid black;" bgcolor="#E6E6E6">
<%
				if(elemento.getTabella_lookup()==null || elemento.getTabella_lookup().equals(""))
					if(elemento.getTipo_campo().equals("checkbox"))
					{
						out.print((elemento.getValore_campo()!=null && elemento.getValore_campo().equalsIgnoreCase("true")) ? "SI": "NO");
					}
					else
						out.print((elemento.getValore_campo()!=null) ? elemento.getValore_campo().toUpperCase(): "");
				else
				{
					if(elemento.getTabella_lookup().contains("mobili"))
						out.print(TipoMobili.getSelectedValue(elemento.getValore_campo()).toUpperCase());
					else
						out.print(elemento.getLookupCampo().getSelectedValue(elemento.getValore_campo()).toUpperCase());
				}
%>
				</td>
				<td style="border:1px solid black;" bgcolor="#E6E6E6">
					Inserito da <dhv:username id="<%= elemento.getIdUtenteInserimento() %>" /> il <%=toDateasString(elemento.getDataInserimento()) %>
<%
					if(elemento.getDataModifica()!=null)
					{
%>
						<br/>Modificato da <dhv:username id="<%= elemento.getIdUtenteModifica() %>" /> il <%=toDateasString(elemento.getDataModifica()) %>
<%
					}
%>
				</td>
				</tr>
<%
			}
%>
		</table>
<%
	} 
}
%>
	
<%
	if(consentiValoriMultipli)
	{
%>
		<font color="red"><b>Attenzione! Per l'aggiornamento del singolo automezzo bisogna eliminare e reinserire il dato.</b></font>
<%
	}
%>
<!-- ------------------------------------------ -->

<br><br>


<%
	if(consentiValoriMultipli || entries.isEmpty())
	{
%>
<form method="post" name="modificaModulo" id="modificaModulo" action="GestioneAnagraficaAction.do?command=InserisciDettaglioMobile">

<input type="hidden" id="ldaMacroId" name="ldaMacroId" value="<%=request.getParameter("ldaMacroId") %>"/>
<input type="hidden" id="ldaStabId" name="ldaStabId" value="<%=request.getParameter("ldaStabId") %>"/>
<input type="hidden" id="stabId" name="stabId" value="<%=request.getParameter("stabId") %>"/>

<input type="hidden" id="impresa_hid" name="impresa_hid" value="<%=StabilimentoDettaglio.getName() %>"/>
<input type="hidden" id="indirizzo_hid" name="indirizzo_hid" value="<%=	(String)request.getAttribute("indirizzohid") %>"/>
<input type="hidden" id="comune_hid" name="comune_hid" value="<%=(String)request.getAttribute("comunehid") %>"/>
<input type="hidden" id="provincia_hid" name="provincia_hid" value="<%=(String)request.getAttribute("provinciahid") %>"/>
<input type="hidden" id="asl_hid" name="asl_hid" value="<%=(String)request.getAttribute("aslhid") %>"/>
<input type="hidden" id="cap_hid" name="cap_hid" value="<%=(String)request.getAttribute("caphid") %>"/>
<input type="hidden" id="asl_hid" name="asl_hid" value="<%=(String)request.getAttribute("aslhid") %>"/>
<table width="100%">
<th align="center" colspan="2" bgcolor="#5CB8E6">INSERIMENTO DETTAGLI LINEA ATTIVITA'</th>

<%
Set<Entry> entriesSenzaValore = campiHashSenzaValore.entrySet();
for (Entry elementoSenzaValore : entriesSenzaValore) 
{
		
		
%>
<tr style="border:1px solid black;"><td style="border:1px solid black;"> 
&nbsp;&nbsp;<b><%=elementoSenzaValore.getKey().toString().toUpperCase() %></b>
</td>

<td style="border:1px solid black;" bgcolor="#E6E6E6">
<%=elementoSenzaValore.getValue() %>
</td></tr>

<% } %>

</table>

<input type="submit" value="SALVA" />




&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" value="PULISCI" onClick="pulisciCampi()"/>

<%
	}
	else
	{
%>
	<form method="post" name="modificaModulo" id="modificaModulo" action="GestioneAnagraficaAction.do?command=ModificaDettaglioMobile">
	<input type="hidden" id="ldaMacroId" name="ldaMacroId" value="<%=request.getParameter("ldaMacroId") %>"/>
<input type="hidden" id="ldaStabId" name="ldaStabId" value="<%=request.getParameter("ldaStabId") %>"/>
<input type="hidden" id="stabId" name="stabId" value="<%=request.getParameter("stabId") %>"/>

<input type="hidden" id="impresa_hid" name="impresa_hid" value="<%=StabilimentoDettaglio.getName() %>"/>
<input type="hidden" id="indirizzo_hid" name="indirizzo_hid" value="<%=	(String)request.getAttribute("indirizzohid") %>"/>
<input type="hidden" id="comune_hid" name="comune_hid" value="<%=(String)request.getAttribute("comunehid") %>"/>
<input type="hidden" id="provincia_hid" name="provincia_hid" value="<%=(String)request.getAttribute("provinciahid") %>"/>
<input type="hidden" id="asl_hid" name="asl_hid" value="<%=(String)request.getAttribute("aslhid") %>"/>
<input type="hidden" id="cap_hid" name="cap_hid" value="<%=(String)request.getAttribute("caphid") %>"/>
<input type="hidden" id="asl_hid" name="asl_hid" value="<%=(String)request.getAttribute("aslhid") %>"/>

		<table width="100%">
		<th align="center" colspan="2" bgcolor="#5CB8E6">MODIFICA DETTAGLI LINEA ATTIVITA'</th>
<%
		for (Entry elemento : entries) 
		{
%>
			<tr style="border:1px solid black;">
				<td style="border:1px solid black;"> 
					&nbsp;&nbsp;<b><%=elemento.getKey().toString().toUpperCase() %></b>
				</td>
				<td style="border:1px solid black;" bgcolor="#E6E6E6">
					<%=elemento.getValue() %>
				</td></tr>
	
<% 
		} 
%>

		</table>

		<input type="submit" value="AGGIORNA" />

		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="button" value="PULISCI" onClick="pulisciCampi()"/>

<%
	}
%>
<script>


inizializzaForm();

</script>



</form>

<br><br><br>
<form method="post" action="GestioneAnagraficaAction.do?command=ImportDistributori" enctype="multipart/form-data">
<input type="hidden" id="ldaMacroId" name="ldaMacroId" value="<%=request.getParameter("ldaMacroId") %>"/>
<input type="hidden" id="ldaStabId" name="ldaStabId" value="<%=request.getParameter("ldaStabId") %>"/>
<input type="hidden" id="stabId" name="stabId" value="<%=request.getParameter("stabId") %>"/>


<%


if(consentiUploadFile)
{
%>
<table width="100%">
<tr>
<th align="center" colspan="2" bgcolor="#5CB8E6">IMPORTA DISTRIBUTORI DA FILE</th>
</tr>
<tr style="border:1px solid black;">
<td style="border:1px solid black;">  Seleziona File</td>

<td><input type="file" name="file1" required="required">
</td>
<td><a download href="images/esempio_import_distributori.csv">SCARICA FILE ESEMPIO <br>(eliminare la intestazione nel file)</a></td> 

</tr>
<tr><td colspan="2"><input type="submit" value="SALVA"></td></tr>
</table>
</form>
<%} %>
<input type="button" value="ESCI" onClick="$( '#dialogMOBILE' ).dialog('close');"/>


<%
	}
%>












