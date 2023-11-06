<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio" %>

<jsp:useBean id="categoria" class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="impianto" class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="statoLab" class="org.aspcfs.utils.web.LookupList"	scope="request" />
<jsp:useBean id="tipoAutorizzazzione" class="org.aspcfs.utils.web.LookupList" scope="request" />
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></script>


<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popCalendar.js"></script>
<body >

	<%-- Trails --%>
	<table class="trails" cellspacing="0">
		<tr>
			<td width="100%"><a href="UnitaCrisi.do">Aggiunta SottoAttività</a>  
			</td>
		</tr>
	</table>
	<%-- End Trails --%>
	
	
	<form name="addAccount" 
		  action="#" 
		  method="post" >
		
		
		<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
			<tr>
				<td  nowrap class="formLabel">Attività</td>
				<td>
					<%=impianto.getHtmlSelect("impianto",-1)%>&nbsp;
				</td>
		    </tr>	
	        
	        <tr>
	  			<td  nowrap class="formLabel">Impianto</td>
	  			<td>
	  			<%= categoria.getHtmlSelect("categoria",-1) %>&nbsp;
				</td>
			</tr>
			
			<tr>
	  			<td nowrap class="formLabel">Descrizione Stato Attività</td>
	  			<td>
	  			<%=statoLab.getHtmlSelect("statoLab",-1)%>&nbsp;
				</td>
			</tr>
			
			<tr>
	  			<td  nowrap class="formLabel">Data Inizio</td>
	  			<td>
	  				<zeroio:dateSelect form="addAccount" field="dateI" timestamp="<%=""%>" showTimeZone="false" /><font color="red">*</font>
				</td>
			</tr>
			
			<tr>
	  			<td  nowrap class="formLabel">Data Fine</td>
	  			<td>
	  				<zeroio:dateSelect form="addAccount" field="dateF" timestamp="<%= "" %>" showTimeZone="false" /><font color="red">*</font>
	  			</td>
			</tr>
			
			<tr>
	  			<td  nowrap class="formLabel">Autorizzazzione</td>
	  			<td>
	  				<%= tipoAutorizzazzione.getHtmlSelect("tipoAutorizzazzione",-1) %>&nbsp;
				</td>
			</tr>
			
			
		</table>
		
		<input type="button" value="Aggiungi" onclick="return clonaNelPadre()"/>
		<input type="button" value="Annulla" onclick="javascript:annulla()">
		
	</form>
	

</body>