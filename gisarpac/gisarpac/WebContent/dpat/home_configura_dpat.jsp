<%@page import="java.util.ArrayList"%>
<%@page import="org.aspcfs.modules.dpat.base.DpatIstanza"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"
	import="java.util.Calendar, java.util.Iterator"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>
<%@page import="org.aspcfs.utils.web.CustomLookupElement"%>


<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session" />
<jsp:useBean id="siteList" class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="anniList" class="java.util.ArrayList" scope="request" />

	<table class="trails" cellspacing="0">
		<tr>
			<td width="100%"><a href="Dpat.do">DPAT</a>  
			</td>
		</tr>
	</table>


	SELEZIONARE L'ANNO
	<select id="ANNO">
		<% if (anniList.size()>0){
				for (DpatIstanza ist : (ArrayList<DpatIstanza>)anniList){
					%>
					<option value="<%=ist.getAnno()%>"><%=ist.getAnno() %></option>
			<%  }
		} %>
	</select>
	<br><br>
	<input type="button" style="background-color:#FF4D00; font-weight: bold;" onclick="javascript: getOption();" value="VAI"/>

<script>
	function getOption(){
		
		var t = document.getElementById("ANNO");
		var anno = t.options[t.selectedIndex].value;
		
		var flag = -1;
		
		
		if (flag==-1){
			/*
				Modificare qui per la vecchia / nuova gestione
			*///window.location="Dpat.do?command=SearchPianiMonitoraggio&anno="+anno;
			/*vecchia : */
			window.location="Dpat.do?command=SearchPianiMonitoraggio&anno="+anno;
			 
		}
	
			
        //alert("Dpat.do?command=Home&idAsl="+asl+"&anno="+anno);
	}
</script>
<br><br>
<br><br>
<br><br>
