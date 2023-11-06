<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
        
    <%@ include file="../../initPage.jsp"%>
    <jsp:useBean id="messaggioPost" class="java.lang.String" scope="request"/>
    <jsp:useBean id="orgId" class="java.lang.String" scope="request"/>
      <jsp:useBean id="label" class="java.lang.String" scope="request"/>
       <jsp:useBean id="codDocumento" class="java.lang.String" scope="request"/>
        <jsp:useBean id="titolo" class="java.lang.String" scope="request"/>
         <jsp:useBean id="idRiga" class="java.lang.String" scope="request"/>

<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>
<%@ page import="java.util.*,org.aspcfs.modules.opu.base.*, org.aspcfs.modules.base.*" %>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>

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
  
<script>
function ritornaAllegato (cod, tit, riga){
// 	window.opener.document.getElementById('codDocumento_'+riga).value=cod;
// 	window.opener.document.getElementById('titoloDocumento_'+riga).innerHTML = tit;
// 	window.opener.document.getElementById('codDocumento_'+riga).onchange();
		window.close();
}
function setAllegato (cod, tit, riga){
	var codici = window.opener.document.getElementById('allegato_documentale_'+riga).value;
	if (codici!='')
		codici = codici + ";";
	codici = codici + cod;
	window.opener.document.getElementById('allegato_documentale_'+riga).value=codici;
	var inn = window.opener.document.getElementById('linkDocumento_'+riga).innerHTML;
	window.opener.document.getElementById('linkDocumento_'+riga).innerHTML = inn + '<a href=\"GestioneAllegatiTrasgressori.do?command=DownloadPDF&codDocumento='+cod+'&nomeDocumento='+tit+' \">'+tit+ '</a><br/><br/>';
	//window.opener.document.getElementById('linkDocumento_'+riga).style.display='none';
	window.opener.document.getElementById('allegato_documentale_'+riga).onchange();
	}
</script>

	<% String param1 = "orgId=" + orgId;   
%>
<body onload="setAllegato('<%=codDocumento %>', '<%=fixStringa(titolo) %>', '<%=idRiga%>')">
<center><b><p><span style="color:green"><%=codDocumento %> - <%=titolo %></span> </p></b>
<dhv:evaluate if="<%=(messaggioPost!=null) %>"> 
<label><font size="5"><%=messaggioPost %></font></label>
</dhv:evaluate>
<br/>

<input type="button" class="buttonClass" style="width:200px;height:50px" value="CHIUDI E CONTINUA" onclick="ritornaAllegato('<%=codDocumento %>', '<%=fixStringa(titolo) %>', '<%=idRiga %>')" />

</center>
</body>
