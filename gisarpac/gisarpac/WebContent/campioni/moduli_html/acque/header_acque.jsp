<%@page import="javax.imageio.ImageIO"%>
<%@ page import="java.awt.*, java.awt.image.*,  java.util.StringTokenizer, com.itextpdf.text.pdf.*, java.io.*, java.util.*,org.aspcfs.utils.web.*, com.itextpdf.text.pdf.codec.*,org.aspcfs.modules.campioni.base.SpecieAnimali" %>

    <script>
function verificaStatoControllo(dataChiusura){
	
	if(dataChiusura != null && dataChiusura != '' && dataChiusura != 'null'){
		  var inputs = document.getElementsByTagName("input");
		  for (var i = 0; i < inputs.length; i++) {
			  if (inputs[i].type=='text'){
		    	inputs[i].disabled = true;
		    	//inputs[i].className = "layout";
		    	inputs[i].style.background = "#ffffff";
			  }
		    }

				
	}
}
</script>

<body onload="javascript:verificaStatoControllo('<%=OrgCampione.getData_chiusura_campione()%>'); catturaHtml(this.gestionePdf); this.gestionePdf.submit();">

<%!
	
	public static String createBarcodeImage(String code) {
	
	Barcode128 code128 = new Barcode128();
	code128.setCode(code);
	java.awt.Image im = code128.createAwtImage(Color.BLACK, Color.WHITE);
	int w = im.getWidth(null);
	int h = im.getHeight(null);
	BufferedImage img = new BufferedImage(w, h+12, BufferedImage.TYPE_INT_ARGB);
	Graphics2D g2d = img.createGraphics();
	g2d.drawImage(im, 0, 0, null);
	g2d.drawRect(0, h, w, 12);
	g2d.fillRect(0, h+1, w, 12);
	g2d.setColor(Color.WHITE);
	String s = code128.getCode();
	g2d.setColor(Color.BLACK);
	//g2d.drawString(s,h+2,34);
	g2d.drawString(s,0,34);
	g2d.dispose();

	ByteArrayOutputStream out = new ByteArrayOutputStream();
	try {
	   ImageIO.write(img, "PNG", out);
	} catch (IOException e) {
	  e.printStackTrace();
	}
	byte[] bytes = out.toByteArray();
	
	String base64bytes = com.itextpdf.text.pdf.codec.Base64.encodeBytes(bytes);
	String src = "data:image/png;base64," + base64bytes;
	
	return src;

	}; 
%>

<!--  INIZIO HEADER -->
<div class="header">
<TABLE cellpadding="10" style="border-collapse: collapse">
 <col width="10%">
<col width="20%">
<col width="30%">
<col width="10%">
<col width="30%"> 
<TR>
<Td style="border:1px solid black;"><div class="boxIdDocumento"></div><br/><b><center>REGIONE<br> CAMPANIA</center></b>
<br/>
<center><img style="text-decoration: none;" height="80" width="80" documentale_url="" src="gestione_documenti/schede/images/<%=(OrgOperatore.getAsl()!=null) ? OrgOperatore.getAsl().toLowerCase() : ""%>.jpg" />
</center>


</Td>
<TD style="border:1px solid black;"><center><b>DIP. DI PREVENZIONE</b></center><BR>
<%-- SERVIZIO <input class="editField" type="text"  name="servizio" id="servizio"  value="<%=valoriScelti.get(z++) %>" size="20" maxlength=""/><br>
U.O. <input class="editField" type="text" name="uo" id="uo"  value="<%=valoriScelti.get(z++) %>" size="20" maxlength="" /><BR>
--%>
SERVIZIO  <input class="editField" type="text" name="servizio" id="servizio"  value="<%=valoriScelti.get(z++) %>"  size="20" maxlength="" /></br>
U.O. <label class="layout"><%=OrgCampione.getUo() != null ? OrgCampione.getUo() : ""  %></label><BR>
SEDE <input class="editField" type="text" name="via_amm" id="via_amm"  value="<%=valoriScelti.get(z++) %>"  size="20" maxlength="" /></br>
MAIL <input class="editField" type="text" name="mail" id="mail"  value="<%=valoriScelti.get(z++) %>" size="20" maxlength="" /></TD>
<TD style="border:1px solid black;"><b>CAMPIONE EFFETTUATO PER:</b><br> 
<label class="layout"><%= (OrgCampione.getPiano() != null) ? OrgCampione.getPiano().toUpperCase() : "" %></label>
</TD>									
<TD style="border:1px solid black;"><center><b>&nbsp; MOD <%=request.getParameter("tipo")%> &nbsp;</b><BR>
&nbsp; Rev. 6 del &nbsp; <BR>
&nbsp; 24/01/14&nbsp;</center>
</TD>
<TD  style="border:1px solid black;" ><center>
VERBALE PRELEVAMENTO<br>CAMPIONE N.<br>
<input class="editField" type="text" name="codice2" id="codice2"  value="<%=valoriScelti.get(z++) %>" size="20" maxlength="" />
<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="<%=createBarcodeImage(OrgCampione.getBarcodePrelievo())%>" />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>
</center>
</TD>
</TR>
</table>
</div>
<!-- FINE HEADER -->