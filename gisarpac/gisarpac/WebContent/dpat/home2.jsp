<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"
	import="java.util.GregorianCalendar, java.util.Calendar"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>

<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session" />
<jsp:useBean id="dsc" class="org.aspcfs.modules.dpat.base.DpatStrumentoCalcolo" scope="request" />
<jsp:useBean id="dpatAtt" class="org.aspcfs.modules.dpat.base.Dpat" scope="request" />
<jsp:useBean id="idAsl" class="java.lang.String" scope="request" />
<jsp:useBean id="anno" class="java.lang.String" scope="request" />
<jsp:useBean id="ListaAsl" class="org.aspcfs.utils.web.LookupList" scope="request"/>
<jsp:useBean id="listaAllegati" class="org.aspcfs.modules.gestioneDocumenti.base.DocumentaleAllegatoList" scope="request"/>
<jsp:useBean id="ListaStruttureDirezione" class="org.aspcfs.utils.web.LookupList" scope="request"/>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body>

<dhv:container name="dpat" selected="details" object="" param="<%="idAsl="+dsc.getStrutturaAmbito().getId_asl()+"&combo_area="+dsc.getStrutturaAmbito().getId()+"&anno="+dsc.getAnno() %>"  hideContainer="false">


	<table class="trails" cellspacing="0">
		<tr>
			<td width="100%"><a href="Dpat.do">DPAT</a> &gt Allegati DPAT - ASL : <%=ListaAsl.getSelectedValue(idAsl) %> > <%=dsc.getStrutturaAmbito() !=null && dsc.getStrutturaAmbito().getId()>0 ?dsc.getStrutturaAmbito().getDescrizione_lunga() :"" %>
			</td>
		</tr>
	</table>
	
<%  String edit = ""; 
	if (dsc.isCompleto()==true) {
		edit = "view";
	} else {
		edit = "edit";
	}
%>

<script>

function downloadModello(nomeClient,tipoAllegato,headerDoc,idDocumento)
{
	
	if (idDocumento!=-1)
		{
		
		location.href='GestioneAllegatiUpload.do?command=DownloadPDF&codDocumento='+headerDoc+'&idDocumento'+idDocumento+'&tipoDocumento='+tipoAllegato+'&nomeDocumento='+nomeClient;
		}
	else
		alert('Il modello selezionato non è ancora disponibile');
}
</script>


  <%! public static String fixStringa(String nome)
  {
	  String toRet = nome;
	  if (nome == null || nome.equals("null"))
		  return toRet;
	  toRet = nome.replaceAll("'", "");
	  toRet = toRet.replaceAll(" ", "_");
	  toRet = toRet.replaceAll("\\?","");
	
	  return toRet;
	  
  }%>
  
 
  
  <br>
  <br>
  <br>
  <center>
  
  <script>
  
  function ricaricaDpat(idAsl,anno)
  {
	  loadModalWindowCustom("Caricamento In corso");
	  var idStrutturaSelezionata = document.getElementById("combo_area").value;
	  location.href="Dpat.do?command=Home&idAsl="+idAsl+"&anno="+anno+"&combo_area="+idStrutturaSelezionata;
  }
  
  </script>
  <%
  
  if(dsc.getStrutturaAmbito()!=null && dsc.getStrutturaAmbito().getId()>0)
  {
		  ListaStruttureDirezione.setJsEvent("onchange='ricaricaDpat("+dsc.getStrutturaAmbito().getIdAsl()+","+dsc.getStrutturaAmbito().getAnno()+ ")'");
  }
  %>
  
  
  <h3>
  <%=((dsc.getStrutturaAmbito()!=null && dsc.getStrutturaAmbito().getId()>0))? "DPAT - ANNO: "+dsc.getStrutturaAmbito().getAnno() : "DPAT - ANNO: "+dsc.getAnno()  %>
  </h3>
  <fieldset>
  <legend><h3><%=((dsc.getStrutturaAmbito()!=null && dsc.getStrutturaAmbito().getId()>0) ? "STRUTTURA SELEZIONATA :"+ ListaStruttureDirezione.getHtmlSelect("combo_area", dsc.getStrutturaAmbito().getId()) : "")  %></h3></legend>
<%
if (dsc.getStrutturaAmbito().getStato()==2 && dsc.getAnno()>2015)
{
%>
  	      <table>
                <tr><td>
                        <input type="button" title="MODELLO I (ALLEGATO DALLA REGIONE)" 
                        <%=listaAllegati.cercTipoAllegato("DPAT_MOD1") !=null ? "class=\"greenBigButton\"" : "class=\"greyBigButton\"" %>
                        class="greenBigButton"  style="width: 400px !important;" value="Modello 1"  
                        style="background-color:#FF4D00; font-weight: bold;" 
                        onclick="downloadModello('<%=listaAllegati.cercTipoAllegato("DPAT_MOD1") !=null ? 
                        		fixStringa(listaAllegati.cercTipoAllegato("DPAT_MOD1").getNomeClient()) : -1  %>',
                        		'<%=listaAllegati.cercTipoAllegato("DPAT_MOD1") !=null ? listaAllegati.cercTipoAllegato("DPAT_MOD1").getTipoAllegato() : -1  %>',
                        		'<%=listaAllegati.cercTipoAllegato("DPAT_MOD1") !=null ? listaAllegati.cercTipoAllegato("DPAT_MOD1").getIdHeader() : -1  %>',
                        		<%=listaAllegati.cercTipoAllegato("DPAT_MOD1") !=null ? listaAllegati.cercTipoAllegato("DPAT_MOD1").getIdDocumento() : -1  %>)"/>
                        </td>
                </tr>
        </table>
        <%} %>
        
        <%
if ((dsc.getStrutturaAmbito().getStato()==2 && dsc.getStrutturaAmbito().getAnno()>2015) || (dsc.getAnno()<2016 && dsc.getStrutturaAmbito().getId()<=0 ))
{
%>
        <table>
                <tr>
					<td>
                        <input type="button" title="RISORSE STRUMENTALI (EX ALLEGATO 2) : COMPILATO DALL'ASL" 
                        <%=listaAllegati.cercTipoAllegato("DPAT_MOD2") !=null ? "class=\"greenBigButton\"" : "class=\"greyBigButton\"" %>
                        class="greenBigButton"  style="width: 400px !important;" value="Modello 2"  
                        style="background-color:#FF4D00; font-weight: bold;" 
                        onclick="downloadModello('<%=listaAllegati.cercTipoAllegato("DPAT_MOD2") !=null ? 
                        		fixStringa(listaAllegati.cercTipoAllegato("DPAT_MOD2").getNomeClient()) : -1  %>',
                        		'<%=listaAllegati.cercTipoAllegato("DPAT_MOD2") !=null ? listaAllegati.cercTipoAllegato("DPAT_MOD2").getTipoAllegato() : -1  %>',
                        		'<%=listaAllegati.cercTipoAllegato("DPAT_MOD2") !=null ? listaAllegati.cercTipoAllegato("DPAT_MOD2").getIdHeader() : -1  %>',
                        		<%=listaAllegati.cercTipoAllegato("DPAT_MOD2") !=null ? listaAllegati.cercTipoAllegato("DPAT_MOD2").getIdDocumento() : -1  %>)"/>
                     		
                                               	
<%--  <input type="button" 
title="RISORSE STRUMENTALI (EX ALLEGATO 2) : COMPILATO DALL'ASL" class="greenBigButton" 
style="width: 400px !important;" value="Modello 2 <%if(dsc.getAnno()==2016){ %> LICENZIATO AL 8-3-2016 <%} 
%>" onClick="location.href='DpatRS.do?command=AddModify&combo_area=<%=dsc.getIdStrutturaAreaSelezionata()%>&idAsl=<%=dsc.getIdAsl()%>'" style="background-color:#FF4D00; font-weight: bold;"/> --%>
                        
                               
                         </td>
                 </tr>
        </table>
        <%} %>
               <%
if (dsc.getStrutturaAmbito().getStato()==2 && dsc.getAnno()>2015)
{
%>
        <table>
                <tr>
                        <td>
                        	<input type="button" title="MODELLO III (ALLEGATO A CARICO DELL'ASL)" 
                        	<%=listaAllegati.cercTipoAllegato("DPAT_MOD3") !=null ? "class=\"greenBigButton\"" : "class=\"greyBigButton\"" %>  
                        	style="width: 400px !important;" value="Modello 3  <%if(dsc.getAnno()==2016){ %> LICENZIATO AL 8-3-2016 <%} %>"  
                        	style="background-color:#FF4D00; font-weight: bold;" 
                        	onclick="downloadModello('<%=listaAllegati.cercTipoAllegato("DPAT_MOD3") !=null ? 
                        			fixStringa(listaAllegati.cercTipoAllegato("DPAT_MOD3").getNomeClient()) : -1  %>',
                        			'<%=listaAllegati.cercTipoAllegato("DPAT_MOD3") !=null ? listaAllegati.cercTipoAllegato("DPAT_MOD3").getTipoAllegato() : -1  %>',
                        			'<%=listaAllegati.cercTipoAllegato("DPAT_MOD3") !=null ? listaAllegati.cercTipoAllegato("DPAT_MOD3").getIdHeader() : -1  %>',
                        			<%=listaAllegati.cercTipoAllegato("DPAT_MOD3") !=null ? listaAllegati.cercTipoAllegato("DPAT_MOD3").getIdDocumento() : -1  %>)"/>
                        
                               
                        </td>
                </tr>
        </table>
        <%} %>
        <dhv:permission name="modello4-view">
        <table>
                <tr>
                <td>
                <input type="button" class="greenBigButton" title="STRUMENTO DI CALCOLO (EX ALLEGATO 5 - I FOGLIO) COMPILATO DALL'ASL"   style="width: 400px !important;"  id="A5" value="Modello 4 - DINAMICO" onClick="" style="background-color:#FF4D00; font-weight: bold;"/>

	<dhv:permission name="dpat-view">
	<script>
		document.getElementById("A5").onclick=function(){window.location='DpatSDC.do?command=Details&idAsl=<%=idAsl%>&anno=<%=anno%>&combo_area=<%=dsc.getIdStrutturaAreaSelezionata()%>';}
	</script>
	</dhv:permission>
	<dhv:permission name="dpat-edit">
	<script>
		var annoCorrente = <%=GregorianCalendar.getInstance().get(Calendar.YEAR )%>;
		var annoInput = <%=anno%>;
		if (annoCorrente==annoInput || annoInput>annoCorrente){
			document.getElementById("A5").onclick=function(){window.location='DpatSDC.do?command=AddModify&idAsl=<%=idAsl%>&anno=<%=anno%>&combo_area=<%=dsc.getIdStrutturaAreaSelezionata()%>';}
		}
		else {
			document.getElementById("A5").onclick=function(){window.location='DpatSDC.do?command=Details&idAsl=<%=idAsl%>&anno=<%=anno%>&combo_area=<%=dsc.getIdStrutturaAreaSelezionata()%>';}
		}
	</script>
	</dhv:permission>
	
                </td></tr>
     </table>
     </dhv:permission>
                
                
                <%
if ((dsc.getStrutturaAmbito().getStato()==2 && dsc.getStrutturaAmbito().getAnno()>2015) )
{
%>
                
                 <table>
                <tr>
                        <td>
                        	<input type="button" title="EX STRUMENTO DI CALCOLO" <%=listaAllegati.cercTipoAllegato("DPAT_MOD4") !=null ? "class=\"greenBigButton\"" : "class=\"greyBigButton\"" %>   style="width: 400px !important;" value="Modello 4  <%if(dsc.getAnno()==2016){ %> LICENZIATO AL 8-3-2016 <%} %>"
		onclick="downloadModello('<%=listaAllegati.cercTipoAllegato("DPAT_MOD4") !=null ? fixStringa(listaAllegati.cercTipoAllegato("DPAT_MOD4").getNomeClient()) : -1  %>','<%=listaAllegati.cercTipoAllegato("DPAT_MOD4") !=null ? listaAllegati.cercTipoAllegato("DPAT_MOD4").getTipoAllegato() : -1  %>','<%=listaAllegati.cercTipoAllegato("DPAT_MOD4") !=null ? listaAllegati.cercTipoAllegato("DPAT_MOD4").getIdHeader() : -1  %>',<%=listaAllegati.cercTipoAllegato("DPAT_MOD4") !=null ? listaAllegati.cercTipoAllegato("DPAT_MOD4").getIdDocumento() : -1  %>)"
		style="background-color:#FF4D00; font-weight: bold;"/>
                               
                         </td>
                 </tr>
        </table>
            
            <%} %>
           
           
<%
if ((dsc.getStrutturaAmbito().getStato()==2 && dsc.getStrutturaAmbito().getAnno()>2015) || (dsc.getAnno()<2016 && dsc.getStrutturaAmbito().getId()<=0 ))
{
%>
            <table>
                <tr>
                        <td>
		<%--VECCHIO FLUSSO DPAT --%>
		<%-- onClick="location.href='Dpat.do?command=DpatModifyGeneraleCompetenze&combo_area=<%=dsc.getIdStrutturaAreaSelezionata()%>&idAsl=<%=dsc.getIdAsl()%>&anno=<%=dsc.getAnno()%>'" --%> 
		<%--NUOVO FLUSSO DPAT --%>
		 
<%-- 		<input type="button" title="ATTRIBUZIONE DELLE COMPETENZE (EX ALLEGATO 6) COMPILATO DALL'ASL" class="greenBigButton"  style="width: 400px !important;" value="Modello 5  <%if(dsc.getAnno()==2016){ %> LICENZIATO AL 8-3-2016 <%} %>" --%>
<%-- 		 onClick="location.href='Dpat.do?command=DpatModifyGeneraleCompetenzeNEW&combo_area=<%=dsc.getIdStrutturaAreaSelezionata()%>&idAsl=<%=dsc.getIdAsl()%>&anno=<%=dsc.getAnno()%>'"  --%>
<!-- 		 style="background-color:#FF4D00; font-weight: bold;"/>  -->
             
               <input type="button" title="ATTRIBUZIONE DELLE COMPETENZE (EX ALLEGATO 6) COMPILATO DALL'ASL" 
                        <%=listaAllegati.cercTipoAllegato("DPAT_MOD5") !=null ? "class=\"greenBigButton\"" : "class=\"greyBigButton\"" %>
                        class="greenBigButton"  style="width: 400px !important;" value="Modello 5"  
                        style="background-color:#FF4D00; font-weight: bold;" 
                        onclick="downloadModello('<%=listaAllegati.cercTipoAllegato("DPAT_MOD2") !=null ? 
                        		fixStringa(listaAllegati.cercTipoAllegato("DPAT_MOD5").getNomeClient()) : -1  %>',
                        		'<%=listaAllegati.cercTipoAllegato("DPAT_MOD5") !=null ? listaAllegati.cercTipoAllegato("DPAT_MOD5").getTipoAllegato() : -1  %>',
                        		'<%=listaAllegati.cercTipoAllegato("DPAT_MOD5") !=null ? listaAllegati.cercTipoAllegato("DPAT_MOD5").getIdHeader() : -1  %>',
                        		<%=listaAllegati.cercTipoAllegato("DPAT_MOD5") !=null ? listaAllegati.cercTipoAllegato("DPAT_MOD5").getIdDocumento() : -1  %>)"/>                    
                         </td>
                 </tr>
        </table>
          <%} %>
          
          <%
if ((dsc.getStrutturaAmbito().getStato()==2 && dsc.getStrutturaAmbito().getAnno()>2015) )
{
%>
        
         <table>
                <tr>
                        <td>
                        	<input type="button" title="FOGLIO ATTIVITA (EX ALLEGATO 5 - II FOGLIO) ALLEGATO DALLA REGIONE"  <%=listaAllegati.cercTipoAllegato("DPAT_MOD6") !=null ? "class=\"greenBigButton\"" : "class=\"greyBigButton\"" %> style="width: 400px !important;" value="Modello 6  <%if(dsc.getAnno()==2016){ %> LICENZIATO AL 8-3-2016 <%} %>"  style="background-color:#FF4D00; font-weight: bold;" onclick="downloadModello('<%=listaAllegati.cercTipoAllegato("DPAT_MOD6") !=null ? fixStringa(listaAllegati.cercTipoAllegato("DPAT_MOD6").getNomeClient()) : -1  %>','<%=listaAllegati.cercTipoAllegato("DPAT_MOD6") !=null ? listaAllegati.cercTipoAllegato("DPAT_MOD6").getTipoAllegato() : -1  %>','<%=listaAllegati.cercTipoAllegato("DPAT_MOD6") !=null ? listaAllegati.cercTipoAllegato("DPAT_MOD6").getIdHeader() : -1  %>',<%=listaAllegati.cercTipoAllegato("DPAT_MOD6") !=null ? listaAllegati.cercTipoAllegato("DPAT_MOD6").getIdDocumento() : -1  %>)"/>
                        
                               
                         </td>
                 </tr>
        </table> 
               
                <%} %>
  
           </fieldset>    
  </center>





	




	<dhv:permission name="dpat-view">
	<!-- SERVER DOCUMENTALE -->
<p align="left">
	 <script language="JavaScript" TYPE="text/javascript"
	SRC="gestione_documenti/generazioneDocumentale.js"></script>
		
	  
</p>
 <!-- SERVER DOCUMENTALE -->
 </dhv:permission>
</dhv:container>
 
</body>
</html>