<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

	<form action="/suap/rest/services/send" method="post" enctype="multipart/form-data">
		<input type="file" name="file1" size="50"/><br>
<!-- 		<input type="hidden" value="95.242.200.174" name="suap_ip"/> Verificare che l'ip sia corretto 	80.82.6.88 -->
				<input type="hidden" value="80.82.6.88" name="suap_ip"/> <!-- Verificare che l'ip sia corretto --> 	
		
		<input type="hidden" name="debugServizioRest" value="true" />
		<input type="text" name="encrypted_token" /><br>
		
		<b>firma digitalez</b>&nbsp;
		<input type="checkbox" name="con_firma_digitale" value="true"><br>
		<input type="submit" value="invia" />
	</form>
	<br><br><br> 
	
	

</body>
</html>