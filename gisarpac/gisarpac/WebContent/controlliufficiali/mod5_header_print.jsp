
<!--  INIZIO HEADER -->
<div class="header">
<TABLE  cellpadding="10" width="100%" style="border-collapse: collapse">
 <col width="10%">
<col width="50%">
<col width="30%">
<col width="10%">
<TR>
<Td style="border:1px solid black;"><div class="boxIdDocumento"></div><br/><b><center>REGIONE<br> VALLE D'AOSTA</center></b>
<br/>
<center><img style="text-decoration: none;" height="80" width="80" documentale_url="" src="gestione_documenti/schede/images/<%=OrgOperatore.getAsl().toLowerCase() %>.jpg" />
</center>

</Td>
<TD style="border:1px solid black;"><center><b>AMMINISTRAZIONE COMPETENTE DIP. DI PREVENZIONE</b></center><BR/>
<label class="layout"><%=fixValore(OrgUtente.getServizio())%></label> <br/>
U.O. <label class="layout"><%=fixValore(OrgUtente.getUo())%></label> <br/>
SEDE <label class="layout"><%=fixValore(OrgUtente.getVia_amm())%></label> <br/>
MAIL <label class="layout"><%=fixValore(OrgUtente.getMail())%></label> </TD>

<% int anno = Integer.parseInt(OrgOperatore.getAnnoReferto());

if(anno<2015) { %>
<TD style="border:1px solid black;"><center><b>&nbsp; MOD 5/A &nbsp;</b><BR>
&nbsp; Rev. 6 del &nbsp; <BR>
&nbsp; 25/03/13&nbsp;</center>
</TD> 
<% } else { %>
<TD style="border:1px solid black;"><center><b>&nbsp; MOD 5/A &nbsp;</b><BR>
&nbsp; Rev. 7 del &nbsp; <BR>
&nbsp; 31/12/14&nbsp;</center>
</TD>
<% } %>

<Td style="border:1px solid black;"><center>
&nbsp; VERBALE DI ISPEZIONE &nbsp;</center>
</TD>
</TR>
</table>
</div>
<!-- FINE HEADER -->