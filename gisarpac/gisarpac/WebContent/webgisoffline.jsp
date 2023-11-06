
 <link rel="stylesheet" type="text/css" href="css/colore_demo.css"></link>	
<link rel="stylesheet" type="text/css" href="css/demo.css"></link>		
<link rel="stylesheet" type="text/css" href="css/custom.css"></link>	
<link rel="stylesheet" type="text/css" href="css/modalWindow.css"></link>
<link rel="stylesheet" type="text/css" href="css/capitalize.css"></link>		

<script src='javascript/modalWindow.js'></script>
<script src='javascript/jquerymini.js'></script>	
<script>
function wait()
{
	
	
//loadModalWindowCustom("ATTENZIONE! LA REPORTISTICA DI.GE.MON NON E' IN TEMPO REALE");

//href='Reportistica.do?command=LoginDigemon';
//if('demo.gisacampania.it' == document.referrer.split('/')[2])
//        location.href='http://col2.gisacampania.it/DiGeMon';
//else

setTimeout(function(){document.location.href="Webgis.do?command=LoginWebgis"}, 1000);
//setTimeout(function(){document.location.href="Reportistica.do?command=LoginDigemon"}, 1000);

}
</script>
<body onload="wait()">
<DIV ID='modalWindow' CLASS='unlocked'><P CLASS='wait'>Attendere il completamento dell'operazione...</P></DIV>


</body>