
 <link rel="stylesheet" type="text/css" href="css/colore_demo.css"></link>	
<link rel="stylesheet" type="text/css" href="css/demo.css"></link>		
<link rel="stylesheet" type="text/css" href="css/custom.css"></link>	
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>
<link rel="stylesheet" type="text/css" href="css/capitalize.css"></link>		

<script src='javascript/modalWindow.js'></script>
<script src='javascript/jquerymini.js'></script>	
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
 
<%
String ruolo = User.getRole();
int idDca = -1;
switch (ruolo) {
case "DCA 43 ASL AVELLINO": idDca = 1;  break;
case "DCA 43 ASL BENEVENTO": idDca = 2;  break;
case "DCA 43 ASL CASERTA": idDca = 3;  break;
case "DCA 43 ASL NAPOLI 1 CENTRO": idDca = 4;  break;
case "DCA 43 ASL NAPOLI 2 NORD": idDca = 5;  break;
case "DCA 43 ASL NAPOLI 3 SUD": idDca = 6;  break;
case "DCA 43 ASL SALERNO": idDca = 7;  break;
case "DCA 43 AO CARDARELLI": idDca = 8;  break;
case "DCA 43 AO SANTOBONO": idDca = 9;  break;
case "DCA 43 AO DEI COLLI": idDca = 10;  break;
case "DCA 43 AOU RUGGI": idDca = 11;  break;
case "DCA 43 AO MOSCATI": idDca = 12;  break;
case "DCA 43 AO RUMMO": idDca = 13;  break;
case "DCA 43 AO SAN SEBASTIANO": idDca = 14;  break;
case "DCA 43 AOU SUN": idDca = 15;  break;
case "DCA 43 AOU FEDERICO II": idDca = 16;  break;
case "DCA 43 IRCCS PASCALE": idDca = 17;  break;
case "DCA 43 Regione": idDca = -1;  break;
}
%>

<script>
function wait()
{
	
	
//loadModalWindowCustom("ATTENZIONE! LA REPORTISTICA DI.GE.MON NON E' IN TEMPO REALE");

//href='Reportistica.do?command=LoginDigemon';
//if('demo.gisacampania.it' == document.referrer.split('/')[2])
//        location.href='http://col2.gisacampania.it/DiGeMon';
//else

setTimeout(function(){document.location.href="http://37.187.199.91/<%=idDca%>"}, 1000);

}
</script>
<body onload="wait()">
<DIV ID='modalWindow' CLASS='unlocked'><P CLASS='wait'>Attendere il completamento dell'operazione...</P></DIV>


</body>


