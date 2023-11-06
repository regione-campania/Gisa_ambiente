<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
  <jsp:useBean id="SERVER_DOCUMENTALE" class="java.lang.String" scope="request"/>
  <jsp:useBean id="APP_VERIFICA" class="java.lang.String" scope="request"/>
  <jsp:useBean id="SERVER_BDU" class="java.lang.String" scope="request"/>
   <jsp:useBean id="db" class="java.lang.String" scope="request"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Verifica Glifo</title>
</head>
<body>
<p style="text-align: center;"><span style="font-size: medium; font-family: trebuchet ms,geneva;"><strong><span style="font-size: medium; font-family: trebuchet ms,geneva;"><strong><span style="font-size: medium; font-family: trebuchet ms,geneva;"><strong><span style="font-size: medium; font-family: trebuchet ms,geneva;"><strong>
<img style="text-decoration: none;" src="<%=SERVER_BDU %>anagrafe_animali/documenti/images/bdu.png" />
</strong></span></strong></span></strong></span></strong></span></p>
<p style="text-align: center;"><span style="font-family: terminal,monaco; color: #ff0000;"><em><span style="font-size: large;">Decodifica del timbro digitale</span></em></span></p>
<blockquote>
<p style="text-align: center;"><span style="font-size: medium; font-family: trebuchet ms,geneva;"><strong>Procedere all'upload del file da verificare.</strong></span></p>
</blockquote>
<p style="text-align: left;">&nbsp;</p>
<hr style="width: 400px;" width="400" />
<p>&nbsp;</p>

<form id="form1" action="http://<%=SERVER_DOCUMENTALE %>/<%=APP_VERIFICA %>?tipo=Doc" method="post" name="form1" enctype="multipart/form-data"><input type="hidden" name="hiddenfield1" value="ok" />
<p style="text-align: center;"><span style="font-size: medium; font-family: trebuchet ms,geneva;">Carica file <span style="color: #ff0000;"><strong>(Scan documento)</strong></span> <br /><input type="file" name="file1" size="50" accept="image/*" /><br /> <input type="submit" value="UPLOAD DOCUMENTO" /></p>
</form><form id="form1" action="http://<%=SERVER_DOCUMENTALE %>/<%=APP_VERIFICA %>?tipo=Doc&db=<%=db%>" method="post" name="form1" enctype="multipart/form-data">
<!-- p style="text-align: right;"><em><strong><span style="font-family: trebuchet ms,geneva; font-size: medium;"><a href="http://docupub.com/pdfconvert/" target="_blank">PDF to Image converter</a></span></strong></em></p-->
<p style="text-align: right;"><em><strong><span style="font-family: trebuchet ms,geneva; font-size: medium;"><br /></span></strong></em></p>
</p>
</form>
<form id="form2" action="http://<%=SERVER_DOCUMENTALE %>/<%=APP_VERIFICA %>?tipo=Glifo&db=<%=db%>" method="post" name="form1" enctype="multipart/form-data"><input type="hidden" name="hiddenfield1" value="ok" />
<p style="text-align: center;"><span style="font-size: medium; font-family: trebuchet ms,geneva;">Carica file <span style="color: #006400;"><strong>(Glifo)</strong></span> <br /><input type="file" name="file1" size="50" accept="image/*" /><br /> <input type="submit" value="UPLOAD GLIFO" /></p>
</form><form id="form2" action="http://<%=SERVER_DOCUMENTALE %>/<%=APP_VERIFICA %>?tipo=Glifo" method="post" name="form2" enctype="multipart/form-data">
</p>
</form>
</body>
</html>
