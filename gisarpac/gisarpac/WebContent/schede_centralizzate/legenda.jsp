<style type="text/css">
table a:link {
	color: #666;
	font-weight: bold;
	text-decoration:none;
}
table a:visited {
	color: #999999;
	font-weight:bold;
	text-decoration:none;
}
table a:active,
table a:hover {
	color: #bd5a35;
	text-decoration:underline;
}
table {
	font-family:Arial, Helvetica, sans-serif;
	color:#666;
	font-size:12px;
	text-shadow: 1px 1px 0px #fff;
	background:#eaebec;
	margin:20px;
	border:#ccc 1px solid;

	-moz-border-radius:3px;
	-webkit-border-radius:3px;
	border-radius:3px;

	-moz-box-shadow: 0 1px 2px #d1d1d1;
	-webkit-box-shadow: 0 1px 2px #d1d1d1;
	box-shadow: 0 1px 2px #d1d1d1;
}
table th {
	padding:21px 25px 22px 25px;
	border-top:1px solid #fafafa;
	border-bottom:1px solid #e0e0e0;

	background: #ededed;
	background: -webkit-gradient(linear, left top, left bottom, from(#ededed), to(#ebebeb));
	background: -moz-linear-gradient(top,  #ededed,  #ebebeb);
}
table th:first-child {
	text-align: left;
	padding-left:20px;
}
table tr:first-child th:first-child {
	-moz-border-radius-topleft:3px;
	-webkit-border-top-left-radius:3px;
	border-top-left-radius:3px;
}
table tr:first-child th:last-child {
	-moz-border-radius-topright:3px;
	-webkit-border-top-right-radius:3px;
	border-top-right-radius:3px;
}
table tr {
	text-align: center;
	padding-left:20px;
}
table td:first-child {
	text-align: left;
	padding-left:20px;
	border-left: 0;
}
table td {
	padding:18px;
	border-top: 1px solid #ffffff;
	border-bottom:1px solid #e0e0e0;
	border-left: 1px solid #e0e0e0;

	background: #fafafa;
	background: -webkit-gradient(linear, left top, left bottom, from(#fbfbfb), to(#fafafa));
	background: -moz-linear-gradient(top,  #fbfbfb,  #fafafa);
}
table tr.even td {
	background: #f6f6f6;
	background: -webkit-gradient(linear, left top, left bottom, from(#f8f8f8), to(#f6f6f6));
	background: -moz-linear-gradient(top,  #f8f8f8,  #f6f6f6);
}
table tr:last-child td {
	border-bottom:0;
}
table tr:last-child td:first-child {
	-moz-border-radius-bottomleft:3px;
	-webkit-border-bottom-left-radius:3px;
	border-bottom-left-radius:3px;
}
table tr:last-child td:last-child {
	-moz-border-radius-bottomright:3px;
	-webkit-border-bottom-right-radius:3px;
	border-bottom-right-radius:3px;
}
table tr:hover td {
	background: #f2f2f2;
	background: -webkit-gradient(linear, left top, left bottom, from(#f2f2f2), to(#f0f0f0));
	background: -moz-linear-gradient(top,  #f2f2f2,  #f0f0f0);	
}
</style>


<table> 
<tr>
<td>Tipo operatore</td>
<td> Id da lookup_tipo_scheda_operatore </td>
</tr>

<tr>
<td>Label</td>
<td> Label del valore </td>
</tr>

<tr>
<td>Campo da recuperare</td>
<td> Nome del campo in cui � contenuto il valore </td>
</tr>

<tr>
<td>Tabella di origine</td>
<td>Tabelle (comprese di join) su cui ricercare</td>
</tr>

<tr>
<td>Condizione da applicare</td>
<td>Clausola WHERE da applicare nella query. L'unico parametro di input (org_id) va indicato con lo standard #orgid# </td>
</tr>

<tr>
<td>Tipo campo</td>
<td> Valori possibili: <br/>
[Vuoto]: Campo di testo classico <br/>
"capitolo": Il valore label sar� mostrato come intestazione<br/>
"asl": Il valore campo sar� convertito in immagine dell'asl<br/>
"barcode": Il valore campo sar� convertito in barcode<br/>
"indirizzo": Verr� aggiunto il link "visualizza su mappa"
 </td>
</tr>

<tr>
<td>Destinazione</td>
<td> Valori possibili: <br/>
[Vuoto]: Tutto <br/>
"print": Il record sar� mostrato solo nelle stampe<br/>
"screen": Il record sar� mostrato solo nei dettagli a schermo
 </td>
</tr>

<tr>
<td> Ordine </td>
<td>Valore alfanumerico indicante l'ordine del record nell'elenco finale
 </td>
</tr>

<tr>
<td> Enabled </td>
<td> Record attivo / non attivo
 </td>
</tr>

</table>