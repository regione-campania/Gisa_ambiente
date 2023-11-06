<br/>
<TABLE rules="all" cellpadding="10" style="border-collapse: collapse">
<tr>
		<td style="text-align:center; width:200px;border: 1px solid black;">
		<b>Codice<br>Quesito<br>Diagnostico</b> 
	</td>
		<td style="text-align:center; width:200px; border: 1px solid black;">
		<% if(OrgCampione.getBarcodeMotivazione() != null ){ %>
			<img src="<%=createBarcodeImage(OrgCampione.getBarcodeMotivazione())%>" />
			<% } else { %>
				NON DISPONIBILE
			<% } %>
		
	</td>
</tr>
<tr>
		<td style="text-align:center; width:200px; border: 1px solid black;">
		<b>Codice<br>Stabilimento</b>
	</td>
		<td style="text-align:center; width:200px; border: 1px solid black;">
	<% //if(OrgCampione.getMotivazione() != null && !OrgCampione.getMotivazione().equals("") && OrgCampione.getBarcodeMotivazione() != null &&
			if(OrgCampione.getBarcodeOSA() != null){ %>
			<img class="codeOsa" ="middle" src="<%=createBarcodeImage(OrgCampione.getBarcodeOSA())%>" />
			<% } else { %>
				NON DISPONIBILE
			<% } %>
		
	</td>
</tr>
<tr>
		<td style="text-align:center; width:200px; border: 1px solid black;">
		<b>Codice<br>Matrice</b> 
	</td>
		<td style="text-align:center; width:200px; border: 1px solid black;">
	<%	
		if(OrgCampione.getCodiciMatrice() != null && !OrgCampione.getCodiciMatrice().equals("")){
			int k = 0;
			StringTokenizer st = new StringTokenizer(OrgCampione.getCodiciMatrice(),";");
			while(st.hasMoreTokens()){
				++k;  %>
				<img align="middle" src="<%=createBarcodeImage(st.nextToken())%>" /><br><br>
				  
			<% 
			} 
		}  else { %>
				NON DISPONIBILE
			<% } %>
		</td>   	
</tr>
</TABLE>