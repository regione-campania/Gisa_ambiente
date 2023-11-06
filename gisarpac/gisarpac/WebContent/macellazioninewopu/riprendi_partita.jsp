<%@page import="org.aspcfs.modules.macellazioninewopu.base.CategoriaRischio"%>
<%@page import="org.aspcfs.modules.macellazioninewopu.utils.ReflectionUtil"%>
<%@page import="org.aspcfs.utils.web.LookupElement"%>	
<%@page import="org.aspcfs.modules.macellazioninewopu.base.Partita"%>
<%@page import="com.darkhorseventures.database.ConnectionPool"%>
<%@page import="org.aspcfs.modules.macellazioninewopu.base.Esito"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio"%>
<%@page import="org.aspcfs.modules.macellazioninewopu.utils.MacelliUtil"%>

<%boolean update = true;%>
<%! SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy"); %>

<%@ include file="../initPage.jsp"%>

<%@page import="org.aspcfs.utils.DateUtils"%>
<jsp:useBean id="Tampone"			class="org.aspcfs.modules.macellazioninewopu.base.Tampone"		scope="request" />
<jsp:useBean id="MatriciTamponi"	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="AnalisiTamponi"	class="org.aspcfs.utils.web.LookupList" scope="request" />

<%@page import="org.aspcfs.modules.macellazioninewopu.base.NonConformita"%>
<%@page import="org.aspcfs.modules.macellazioninewopu.base.PatologiaRilevata"%>
<%@page import="org.aspcfs.utils.web.LookupList"%>
<%@page import="org.aspcfs.modules.macellazioninewopu.base.Casl_Non_Conformita_Rilevata"%>
<%@page import="org.aspcfs.modules.macellazioninewopu.base.ProvvedimentiCASL"%>
<%@page import="org.aspcfs.modules.macellazioninewopu.base.Organi"%>
<%@page import="org.aspcfs.modules.contacts.base.Contact"%>
<%@page import="java.util.Date"%>

<%@page import="org.aspcfs.modules.util.imports.ApplicationProperties"%>

<jsp:useBean id="Partita"				class="org.aspcfs.modules.macellazioninewopu.base.Partita"			scope="request" />

<jsp:useBean id="OrgDetails"		class="org.aspcfs.modules.opu.base.Stabilimento"	scope="request" />
<jsp:useBean id="Speditore" class="org.aspcfs.modules.speditori.base.Organization" 	scope="request" />
<jsp:useBean id="SpeditoreAddress" class="org.aspcfs.modules.speditori.base.OrganizationAddress" 	scope="request" />
<!--<jsp:useBean id="Campione"			class="org.aspcfs.modules.macellazioninewopu.base.Campione"		scope="request" />-->
<!--<jsp:useBean id="Organo"			class="org.aspcfs.modules.macellazioninewopu.base.Organi"			scope="request" />-->

<jsp:useBean id="NCVAM"				class="java.util.ArrayList"				scope="request" />
<jsp:useBean id="Campioni"			class="java.util.ArrayList"				scope="request" />
<jsp:useBean id="OrganiList" 		class="java.util.ArrayList"				scope="request" />
<jsp:useBean id="OrganiListNew" 	class="java.util.TreeMap"				scope="request" />
<jsp:useBean id="PatologieRilevate"	class="java.util.ArrayList"				scope="request" />
<jsp:useBean id="Provvedimenti"		class="java.util.ArrayList"				scope="request" />
<jsp:useBean id="casl_NCRilevate"	class="java.util.ArrayList"				scope="request" />

<jsp:useBean id="casl_Provvedimenti_effettuati"	class="java.util.ArrayList"				scope="request" />

<jsp:useBean id="Nazioni"			class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="Matrici"			class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="ASL"				class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="LuoghiVerifica"	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="Regioni"			class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="Razze"				class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="Specie"			class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="CategorieBovine"	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="CategorieBufaline"	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="PianiRisanamento"	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="BseList"			class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="TipiMacellazione"	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="EsitiVpm"			class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="Patologie"			class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="PatologieOrgani"	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="TipiEsame"			class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="Stadi"				class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="Organi"			class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="TipiAnalisi"		class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="Molecole"			class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="TipiNonConformita"	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="MotiviASL"			class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="ProvvedimentiVAM"	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="look_ProvvedimentiCASL"	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="Veterinari"		class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="EsitiCampioni"		class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="Esiti"	            class="java.util.ArrayList"							scope="request" />
<jsp:useBean id="Categorie"	        class="java.util.ArrayList"							scope="request" />
<jsp:useBean id="MotiviCampioni"	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="MolecolePNR"				class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="MolecoleBatteriologico"	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="MolecoleParassitologico"	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="TipiNonConformita_Gruppo"	class="org.aspcfs.utils.web.LookupList" scope="request" />


<jsp:useBean id="lookup_lesione_generici"			class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="lookup_lesione_altro"			class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="lookup_lesione_milza"			class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="lookup_lesione_cuore"			class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="lookup_lesione_polmoni"		class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="lookup_lesione_visceri"		class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="lookup_lesione_fegato"			class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="lookup_lesione_rene"			class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="lookup_lesione_mammella"		class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="lookup_lesione_apparato_genitale"	class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="lookup_lesione_stomaco"			class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="lookup_lesione_intestino"			class="org.aspcfs.utils.web.LookupList" scope="request" />
<jsp:useBean id="lookup_lesione_osteomuscolari"		class="org.aspcfs.utils.web.LookupList" scope="request" />

<jsp:useBean id="User"		class="org.aspcfs.modules.login.beans.UserBean" scope="session" />



<link type="text/css" href="css/ui.all.css" rel="stylesheet" />
<link type="text/css" href="css/demos.css" rel="stylesheet" />
<script language="JavaScript" TYPE="text/javascript" SRC="javascript/popCalendar.js"></script>
<script type="text/javascript" src="javascript/ui.core.js"></script>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="javascript/popLookupSelect.js"></SCRIPT>
<!-- <script type="text/javascript" src="javascript/ui.tabs.js"></script> -->

<!-- RELATIVO AL NUOVO CALENDARIO CON MESE E ANNO FACILMENTE MODIFICABILI -->
<SCRIPT LANGUAGE="JavaScript" SRC="javascript/CalendarPopup.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript" SRC="javascript/common.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">document.write(getCalendarStyles());</SCRIPT>


<script type="text/javascript" src="dwr/interface/PopolaCombo.js"> </script>

<SCRIPT LANGUAGE="JavaScript" SRC="macellazioninew/cambio_specie.js"></SCRIPT>

<script type="text/javascript">


function confrontaDate(data1, data2) {

	var arr1 = data1.split("/");
	var arr2 = data2.split("/");

	var d1 = new Date(arr1[2], arr1[1] - 1, arr1[0]);
	var d2 = new Date(arr2[2], arr2[1] - 1, arr2[0]);

	var r1 = d1.getTime();
	var r2 = d2.getTime();

	if (r1 < r2)
		return -1;
	else if (r1 == r2)
		return 0;
	else
		return 1;
}

var righeDest = 1;
var righeMax = 1; 

<!--var righeDest = 2;-->
<!--var righeMax = %=(Integer)request.getAttribute("righeDestDefault"); -->
var destinatariSelezionati = new Array();
function controllaObbligNumCapiDestCarni()
{
	var i=0;
	while(i<destinatariSelezionati.length)
	{
		var numCapiOvini   = document.getElementById('num_capi_ovini_' + destinatariSelezionati[i]);
		var numCapiCaprini = document.getElementById('num_capi_caprini_' + destinatariSelezionati[i]);
		
		if(numCapiOvini!=null)
		{
			if(numCapiOvini.value=="")
			{
				if(numCapiCaprini!=null)
				{
					if(numCapiCaprini.value=="")
						return false;
				}
			}
		}
		else
		{
			if(numCapiCaprini.value=="")
				return false;
		}
		i++;
	}
	return true;
}

<%
	ConnectionElement ce = (ConnectionElement) request.getSession().getAttribute("ConnectionElement");
	ConnectionPool sqlDriver = (ConnectionPool) request.getServletContext().getAttribute("ConnectionPool");
	Connection db = sqlDriver.getConnection(ce,null);
%>

var message = "";
function verificaStampaMod10(idMacello,dataPostmortem)
{

		if (dataPostmortem != '')
			PopolaCombo.verificaStampaMod10(idMacello , dataPostmortem,0,verificaStampaMod10CallBack);
	   
}

 function verificaStampaMod10CallBack(returnValue)
 {
		message = '' ;
	if (returnValue+''=='true')
	{
		
		ret = false ;
		message += label("","- [Visita Post Mortem] : \"Data Macellazione Non Valida.\" per Questa seduta � stata effettuata una stampa del Modello 10\r\n" );
alert(message);
		}
	
	


 }
</script>

<SCRIPT LANGUAGE="JavaScript" ID="js19">
var cal19 = new CalendarPopup();
cal19.showYearNavigation();
cal19.showYearNavigationInput();
cal19.showNavigationDropdowns();
</SCRIPT>
<!-- ******************************************************************** -->

<script type="text/javascript">

//funzioni data
var MONTH_NAMES=new Array('January','February','March','April','May','June','July','August','September','October','November','December','Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');var DAY_NAMES=new Array('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sun','Mon','Tue','Wed','Thu','Fri','Sat');
function LZ(x){return(x<0||x>9?"":"0")+x}
function isDate(val,format){var date=getDateFromFormat(val,format);if(date==0){return false;}return true;}
function compareDates(date1,dateformat1,date2,dateformat2){var d1=getDateFromFormat(date1,dateformat1);var d2=getDateFromFormat(date2,dateformat2);if(d1==0 || d2==0){return -1;}else if(d1 > d2){return 1;}return 0;}
function formatDate(date,format){format=format+"";var result="";var i_format=0;var c="";var token="";var y=date.getYear()+"";var M=date.getMonth()+1;var d=date.getDate();var E=date.getDay();var H=date.getHours();var m=date.getMinutes();var s=date.getSeconds();var yyyy,yy,MMM,MM,dd,hh,h,mm,ss,ampm,HH,H,KK,K,kk,k;var value=new Object();if(y.length < 4){y=""+(y-0+1900);}value["y"]=""+y;value["yyyy"]=y;value["yy"]=y.substring(2,4);value["M"]=M;value["MM"]=LZ(M);value["MMM"]=MONTH_NAMES[M-1];value["NNN"]=MONTH_NAMES[M+11];value["d"]=d;value["dd"]=LZ(d);value["E"]=DAY_NAMES[E+7];value["EE"]=DAY_NAMES[E];value["H"]=H;value["HH"]=LZ(H);if(H==0){value["h"]=12;}else if(H>12){value["h"]=H-12;}else{value["h"]=H;}value["hh"]=LZ(value["h"]);if(H>11){value["K"]=H-12;}else{value["K"]=H;}value["k"]=H+1;value["KK"]=LZ(value["K"]);value["kk"]=LZ(value["k"]);if(H > 11){value["a"]="PM";}else{value["a"]="AM";}value["m"]=m;value["mm"]=LZ(m);value["s"]=s;value["ss"]=LZ(s);while(i_format < format.length){c=format.charAt(i_format);token="";while((format.charAt(i_format)==c) &&(i_format < format.length)){token += format.charAt(i_format++);}if(value[token] != null){result=result + value[token];}else{result=result + token;}}return result;}
function _isInteger(val){var digits="1234567890";for(var i=0;i < val.length;i++){if(digits.indexOf(val.charAt(i))==-1){return false;}}return true;}
function _getInt(str,i,minlength,maxlength){for(var x=maxlength;x>=minlength;x--){var token=str.substring(i,i+x);if(token.length < minlength){return null;}if(_isInteger(token)){return token;}}return null;}
function getDateFromFormat(val,format){val=val+"";format=format+"";var i_val=0;var i_format=0;var c="";var token="";var token2="";var x,y;var now=new Date();var year=now.getYear();var month=now.getMonth()+1;var date=1;var hh=now.getHours();var mm=now.getMinutes();var ss=now.getSeconds();var ampm="";while(i_format < format.length){c=format.charAt(i_format);token="";while((format.charAt(i_format)==c) &&(i_format < format.length)){token += format.charAt(i_format++);}if(token=="yyyy" || token=="yy" || token=="y"){if(token=="yyyy"){x=4;y=4;}if(token=="yy"){x=2;y=2;}if(token=="y"){x=2;y=4;}year=_getInt(val,i_val,x,y);if(year==null){return 0;}i_val += year.length;if(year.length==2){if(year > 70){year=1900+(year-0);}else{year=2000+(year-0);}}}else if(token=="MMM"||token=="NNN"){month=0;for(var i=0;i<MONTH_NAMES.length;i++){var month_name=MONTH_NAMES[i];if(val.substring(i_val,i_val+month_name.length).toLowerCase()==month_name.toLowerCase()){if(token=="MMM"||(token=="NNN"&&i>11)){month=i+1;if(month>12){month -= 12;}i_val += month_name.length;break;}}}if((month < 1)||(month>12)){return 0;}}else if(token=="EE"||token=="E"){for(var i=0;i<DAY_NAMES.length;i++){var day_name=DAY_NAMES[i];if(val.substring(i_val,i_val+day_name.length).toLowerCase()==day_name.toLowerCase()){i_val += day_name.length;break;}}}else if(token=="MM"||token=="M"){month=_getInt(val,i_val,token.length,2);if(month==null||(month<1)||(month>12)){return 0;}i_val+=month.length;}else if(token=="dd"||token=="d"){date=_getInt(val,i_val,token.length,2);if(date==null||(date<1)||(date>31)){return 0;}i_val+=date.length;}else if(token=="hh"||token=="h"){hh=_getInt(val,i_val,token.length,2);if(hh==null||(hh<1)||(hh>12)){return 0;}i_val+=hh.length;}else if(token=="HH"||token=="H"){hh=_getInt(val,i_val,token.length,2);if(hh==null||(hh<0)||(hh>23)){return 0;}i_val+=hh.length;}else if(token=="KK"||token=="K"){hh=_getInt(val,i_val,token.length,2);if(hh==null||(hh<0)||(hh>11)){return 0;}i_val+=hh.length;}else if(token=="kk"||token=="k"){hh=_getInt(val,i_val,token.length,2);if(hh==null||(hh<1)||(hh>24)){return 0;}i_val+=hh.length;hh--;}else if(token=="mm"||token=="m"){mm=_getInt(val,i_val,token.length,2);if(mm==null||(mm<0)||(mm>59)){return 0;}i_val+=mm.length;}else if(token=="ss"||token=="s"){ss=_getInt(val,i_val,token.length,2);if(ss==null||(ss<0)||(ss>59)){return 0;}i_val+=ss.length;}else if(token=="a"){if(val.substring(i_val,i_val+2).toLowerCase()=="am"){ampm="AM";}else if(val.substring(i_val,i_val+2).toLowerCase()=="pm"){ampm="PM";}else{return 0;}i_val+=2;}else{if(val.substring(i_val,i_val+token.length)!=token){return 0;}else{i_val+=token.length;}}}if(i_val != val.length){return 0;}if(month==2){if( ((year%4==0)&&(year%100 != 0) ) ||(year%400==0) ){if(date > 29){return 0;}}else{if(date > 28){return 0;}}}if((month==4)||(month==6)||(month==9)||(month==11)){if(date > 30){return 0;}}if(hh<12 && ampm=="PM"){hh=hh-0+12;}else if(hh>11 && ampm=="AM"){hh-=12;}var newdate=new Date(year,month-1,date,hh,mm,ss);return newdate.getTime();}
function parseDate(val){var preferEuro=(arguments.length==2)?arguments[1]:false;generalFormats=new Array('y-M-d','MMM d, y','MMM d,y','y-MMM-d','d-MMM-y','MMM d');monthFirst=new Array('M/d/y','M-d-y','M.d.y','MMM-d','M/d','M-d');dateFirst =new Array('d/M/y','d-M-y','d.M.y','d-MMM','d/M','d-M');var checkList=new Array('generalFormats',preferEuro?'dateFirst':'monthFirst',preferEuro?'monthFirst':'dateFirst');var d=null;for(var i=0;i<checkList.length;i++){var l=window[checkList[i]];for(var j=0;j<l.length;j++){d=getDateFromFormat(val,l[j]);if(d!=0){return new Date(d);}}}return null;}
//

function setCategoriaRischio()
{


	var dataMorteAnteMacellazione = document.getElementById('mavam_data').value != '';
	var luogoMorteAnteMacellazione = document.getElementById('mavam_luogo').selectedIndex > 0;
	var causaMorteAnteMacellazione = trim( document.getElementById('mavam_motivo').value ) != '';

	

	if(document.getElementById('cd_specie').value =='1' || document.getElementById('cd_specie').value =='5')
	{
	if (document.getElementById("mac_tipo").value == '3' )
	{
		if(document.forms[0].cd_categoria_rischio.value !='2')
		{
			alert('Settata la categoria di rischio a 2 : Macellazione di Urgenza con test tse animale superiore a 48 mesi');
		}
		document.getElementById('cd_categoria_rischio_2').checked = true ;
		
	}
	
	
		if (document.getElementById('cd_macellazione_differita')!= null && parseInt(document.getElementById('cd_macellazione_differita').value )>0)
		{
			if(document.forms[0].cd_categoria_rischio.value !='3')
			{
				alert('Settata la categoria di rischio a 3 : Macellazione Differita con BRC,LEU,TBC');
			}
			document.getElementById('cd_categoria_rischio_3').checked = true ;
		}

		if(dataMorteAnteMacellazione && luogoMorteAnteMacellazione && causaMorteAnteMacellazione)
		{
			if(document.forms[0].cd_categoria_rischio.value !='5')
			{
				alert('Settata la categoria di rischio a 5 : capo morto prima della macellazione');
			}
			
			document.getElementById('cd_categoria_rischio_5').checked = true ;
			
		}
		
		
		document.getElementById('cd_categoria_rischio_1').checked = true ;
	}
	

	
	
}

function displayStadio2( index )
{
	var MILZA 			= 1;
	var CUORE 			= 2;
	var POLMONI 		= 3;
	var FEGATO 			= 4;
	var RENE 			= 5;
	var MAMMELLA 		= 6;
	var GENITALE 		= 7;
	var STOMACO 		= 8;
	var INTESTINO 		= 9;
	var OSTEOMUSCOLARI	= 10;
	var VISCERI	= 26;

	value_organo = document.getElementById('lcso_organo_'+String(index)).value;

//	alert('value_organo : ' + value_organo );
//	alert(index);

	var a = document.getElementById('lesione_milza_'+String(index)).value;
	//	alert('Milza_value : ' + a);

	var b = document.getElementById('lesione_cuore_'+String(index)).value;
	//alert('cuore_value : ' + b);

	var c = document.getElementById('polmoni_value'+String(index)).value;
	//	alert('polmoni_value : ' + c);

	
	
	if (value_organo == MILZA)  {

		//		alert('Milza_value' + document.getElementById('lesione_milza_'+String(index)).value );
		
		if( document.getElementById('lesione_milza_'+String(index)).value == 6 )	{
			document.getElementById( "stadio_" + index ).style.display = "table-row";
		}else{
			document.getElementById( "stadio_" + index ).style.display = "none";
		}
	}
	
	if (value_organo == CUORE)  {
		//	alert('************************************')
	//	alert('cuore_value' + document.getElementById('lesione_cuore_'+String(index)).value );
		
		if( document.getElementById('lesione_cuore_'+String(index)).value == 6 )	{
			alert('adesso dovrei comparire');
			document.getElementById( "stadio_" + index ).style.display = "table-row";
		}else{
			alert('adesso non dovrei comparire');
			document.getElementById( "stadio_" + index ).style.display = "none";
		}
	}
	
	if (value_organo == POLMONI){

		//	alert('polmoni_value' + document.getElementById('lesione_polmoni_'+String(index)).value );
		
		if( document.getElementById('lesione_polmoni_'+String(index)).value == 6 )	{
			document.getElementById( "stadio_" + index ).style.display = "table-row";
		}else{
			document.getElementById( "stadio_" + index ).style.display = "none";
		}
		if( document.getElementById('lesione_visceri_'+String(index)).value == 26 )	{
			document.getElementById( "stadio_" + index ).style.display = "table-row";
		}else{
			document.getElementById( "stadio_" + index ).style.display = "none";
		}
	}
	
	if (value_organo == FEGATO)	{
		if( document.getElementById('lesione_fegato_'+String(index)).value == 6 )	{
			document.getElementById( "stadio_" + index ).style.display = "table-row";
		}else{
			document.getElementById( "stadio_" + index ).style.display = "none";
		}
	}
	
	if (value_organo == RENE)	{
		if( document.getElementById('lesione_rene_'+String(index)).value == 6 )	{
			document.getElementById( "stadio_" + index ).style.display = "table-row";
		}else{
			document.getElementById( "stadio_" + index ).style.display = "none";
		}
	}
	
	if (value_organo == MAMMELLA){
		if( document.getElementById('lesione_mammella_'+String(index)).value == 6 )	{
			document.getElementById( "stadio_" + index ).style.display = "table-row";
		}else{
			document.getElementById( "stadio_" + index ).style.display = "none";
		}
	}
	
	if (value_organo == GENITALE){
		if( document.getElementById('lesione_apparato_genitale_'+String(index)).value == 6 )	{
			document.getElementById( "stadio_" + index ).style.display = "table-row";
		}else{
			document.getElementById( "stadio_" + index ).style.display = "none";
		}
	}
	
	if (value_organo == STOMACO){
		if( document.getElementById('lesione_stomaco_'+String(index)).value == 6 )	{
			document.getElementById( "stadio_" + index ).style.display = "table-row";
		}else{
			document.getElementById( "stadio_" + index ).style.display = "none";
		}
	}
	
	if (value_organo == INTESTINO){
		if( document.getElementById('lesione_intestino_'+String(index)).value == 6 )	{
			document.getElementById( "stadio_" + index ).style.display = "table-row";
		}else{
			document.getElementById( "stadio_" + index ).style.display = "none";
		}
	}
	
	if (value_organo == OSTEOMUSCOLARI){
		if( document.getElementById('lesione_osteomuscolari_'+String(index)).value == 6 )	{
			document.getElementById( "stadio_" + index ).style.display = "table-row";
		}else{
			document.getElementById( "stadio_" + index ).style.display = "none";
		}
	}
	
}


function vpm_seleziona_lookup_patologia_organo(indice_riga, value_organo, value_patologia)
{
	//alert("In prova().... Indice_riga=" + indice_riga + " value_organo=" +value_organo  + " value_patologia=" +value_patologia);
try {
	var MILZA 			= 1;
	var CUORE 			= 2;
	var POLMONI 		= 3;
	var FEGATO 			= 4;
	var RENE 			= 5;
	var MAMMELLA 		= 6;
	var GENITALE 		= 7;
	var STOMACO 		= 8;
	var INTESTINO 		= 9;
	var OSTEOMUSCOLARI	= 10;
	var VISCERI	= 26;

	var ALTRO = 11;

	document.getElementById('lesione_milza_'+String(indice_riga)).style.display = "none";
	//document.getElementById('lesione_milza_'+String(indice_riga)).value = -1;
	document.getElementById('lesione_cuore_'+String(indice_riga)).style.display = "none";
	//document.getElementById('lesione_cuore_'+String(indice_riga)).value = -1;
	document.getElementById('lesione_polmoni_'+String(indice_riga)).style.display = "none";
	document.getElementById('lesione_visceri_'+String(indice_riga)).style.display = "none";
	//document.getElementById('lesione_polmoni_'+String(indice_riga)).value = -1;
	document.getElementById('lesione_fegato_'+String(indice_riga)).style.display = "none";
	//document.getElementById('lesione_fegato_'+String(indice_riga)).value = -1;
	document.getElementById('lesione_rene_'+String(indice_riga)).style.display = "none";
	//document.getElementById('lesione_rene_'+String(indice_riga)).value = -1;
	document.getElementById('lesione_mammella_'+String(indice_riga)).style.display = "none";
	//document.getElementById('lesione_mammella_'+String(indice_riga)).value = -1;
	document.getElementById('lesione_apparato_genitale_'+String(indice_riga)).style.display = "none";
	//document.getElementById('lesione_apparato_genitale_'+String(indice_riga)).value = -1;
	document.getElementById('lesione_stomaco_'+String(indice_riga)).style.display = "none";
	//document.getElementById('lesione_stomaco_'+String(indice_riga)).value = -1;
	document.getElementById('lesione_intestino_'+String(indice_riga)).style.display = "none";
	//document.getElementById('lesione_intestino_'+String(indice_riga)).value = -1;
	document.getElementById('lesione_osteomuscolari_'+String(indice_riga)).style.display = "none";
	//document.getElementById('lesione_osteomuscolari_'+String(indice_riga)).value = -1;

	document.getElementById('lesione_generici_'+String(indice_riga)).style.display = "none";
	//document.getElementById('lesione_generici_'+String(indice_riga)).value = -1;

	document.getElementById('lesione_altro_'+String(indice_riga)).style.display = "none";
	//document.getElementById('lesione_altro_'+String(indice_riga)).value = -1;
	
	if (value_organo == MILZA)  {
				document.getElementById('lesione_milza_'+String(indice_riga)).style.display = "";
				//document.getElementById('lesione_milza_'+String(indice_riga)).value = value_patologia;
	}
	else if (value_organo == CUORE)  {
				document.getElementById('lesione_cuore_'+String(indice_riga)).style.display = "";
				//document.getElementById('lesione_cuore_'+String(indice_riga)).value = value_patologia;
	}
	else if (value_organo == POLMONI){
				document.getElementById('lesione_polmoni_'+String(indice_riga)).style.display = "";
				//document.getElementById('lesione_polmoni_'+String(indice_riga)).value = value_patologia;
	}
	else if (value_organo == VISCERI){
		document.getElementById('lesione_visceri_'+String(indice_riga)).style.display = "";
		//document.getElementById('lesione_polmoni_'+String(indice_riga)).value = value_patologia;
	}

	else if (value_organo == FEGATO)	{
				document.getElementById('lesione_fegato_'+String(indice_riga)).style.display = "";
				//document.getElementById('lesione_fegato_'+String(indice_riga)).value = value_patologia;
	}
	else if (value_organo == RENE)	{
				document.getElementById('lesione_rene_'+String(indice_riga)).style.display = "";
				//document.getElementById('lesione_rene_'+String(indice_riga)).value = value_patologia;
	}
	else if (value_organo == MAMMELLA){
				document.getElementById('lesione_mammella_'+String(indice_riga)).style.display = "";
				//document.getElementById('lesione_mammella_'+String(indice_riga)).value = value_patologia;
	}
	else if (value_organo == GENITALE){
				document.getElementById('lesione_apparato_genitale_'+String(indice_riga)).style.display = "";
				//document.getElementById('lesione_apparato_genitale_'+String(indice_riga)).value = value_patologia;
	}
	else if (value_organo == STOMACO){
				document.getElementById('lesione_stomaco_'+String(indice_riga)).style.display = "";
				//document.getElementById('lesione_stomaco_'+String(indice_riga)).value = value_patologia;
	}
	else if (value_organo == INTESTINO){
				document.getElementById('lesione_intestino_'+String(indice_riga)).style.display = "";
				//document.getElementById('lesione_intestino_'+String(indice_riga)).value = value_patologia;
	}
	else if (value_organo == OSTEOMUSCOLARI){
				document.getElementById('lesione_osteomuscolari_'+String(indice_riga)).style.display = "";
				//document.getElementById('lesione_osteomuscolari_'+String(indice_riga)).value = value_patologia;
	}
	else if ( (value_organo == 13) || (value_organo == 14) || (value_organo == 15) || (value_organo == 16) || (value_organo == 17) || (value_organo == 18)
			|| (value_organo == 19) || (value_organo == 20) || (value_organo == 21) || (value_organo == 22) || (value_organo == 23) || (value_organo == 24) || (value_organo == 25)) {
		document.getElementById('lesione_generici_'+String(indice_riga)).style.display = "";
		//document.getElementById('lesione_generici_'+String(indice_riga)).value = value_patologia;
	}
	else{
		document.getElementById('lesione_altro_'+String(indice_riga)).style.display = "";
		//document.getElementById('lesione_altro_'+String(indice_riga)).value = value_patologia;
	}
}
catch(err)
{
	alert(err.description);
}
	
}



function vpm_resetta_lookup_patologia_organo(indice_riga, value_organo, value_patologia)
{

	try {
		var MILZA 			= 1;
		var CUORE 			= 2;
		var POLMONI 		= 3;
		var FEGATO 			= 4;
		var RENE 			= 5;
		var MAMMELLA 		= 6;
		var GENITALE 		= 7;
		var STOMACO 		= 8;
		var INTESTINO 		= 9;
		var OSTEOMUSCOLARI	= 10;
		var VISCERI	= 26;
	
		var ALTRO = 11;
	
		document.getElementById('lesione_milza_'+String(indice_riga)).style.display = "none";
		document.getElementById('lesione_milza_'+String(indice_riga)).value = -1;
		document.getElementById('lesione_cuore_'+String(indice_riga)).style.display = "none";
		document.getElementById('lesione_cuore_'+String(indice_riga)).value = -1;
		document.getElementById('lesione_polmoni_'+String(indice_riga)).style.display = "none";
		document.getElementById('lesione_polmoni_'+String(indice_riga)).value = -1;
		document.getElementById('lesione_visceri_'+String(indice_riga)).style.display = "none";
		document.getElementById('lesione_visceri_'+String(indice_riga)).value = -1;
		document.getElementById('lesione_fegato_'+String(indice_riga)).style.display = "none";
		document.getElementById('lesione_fegato_'+String(indice_riga)).value = -1;
		document.getElementById('lesione_rene_'+String(indice_riga)).style.display = "none";
		document.getElementById('lesione_rene_'+String(indice_riga)).value = -1;
		document.getElementById('lesione_mammella_'+String(indice_riga)).style.display = "none";
		document.getElementById('lesione_mammella_'+String(indice_riga)).value = -1;
		document.getElementById('lesione_apparato_genitale_'+String(indice_riga)).style.display = "none";
		document.getElementById('lesione_apparato_genitale_'+String(indice_riga)).value = -1;
		document.getElementById('lesione_stomaco_'+String(indice_riga)).style.display = "none";
		document.getElementById('lesione_stomaco_'+String(indice_riga)).value = -1;
		document.getElementById('lesione_intestino_'+String(indice_riga)).style.display = "none";
		document.getElementById('lesione_intestino_'+String(indice_riga)).value = -1;
		document.getElementById('lesione_osteomuscolari_'+String(indice_riga)).style.display = "none";
		document.getElementById('lesione_osteomuscolari_'+String(indice_riga)).value = -1;
	
		document.getElementById('lesione_generici_'+String(indice_riga)).style.display = "none";
		document.getElementById('lesione_generici_'+String(indice_riga)).value = -1;
	
		document.getElementById('lesione_altro_'+String(indice_riga)).style.display = "none";
		document.getElementById('lesione_altro_'+String(indice_riga)).value = -1;
		
		if (value_organo == MILZA)  {
					document.getElementById('lesione_milza_'+String(indice_riga)).style.display = "";
		}
		else if (value_organo == CUORE)  {
					document.getElementById('lesione_cuore_'+String(indice_riga)).style.display = "";
		}
		else if (value_organo == POLMONI){
					document.getElementById('lesione_polmoni_'+String(indice_riga)).style.display = "";
		}
		else if (value_organo == VISCERI){
			document.getElementById('lesione_visceri_'+String(indice_riga)).style.display = "";
		}
		else if (value_organo == FEGATO)	{
					document.getElementById('lesione_fegato_'+String(indice_riga)).style.display = "";
		}
		else if (value_organo == RENE)	{
					document.getElementById('lesione_rene_'+String(indice_riga)).style.display = "";
		}
		else if (value_organo == MAMMELLA){
					document.getElementById('lesione_mammella_'+String(indice_riga)).style.display = "";
		}
		else if (value_organo == GENITALE){
					document.getElementById('lesione_apparato_genitale_'+String(indice_riga)).style.display = "";
		}
		else if (value_organo == STOMACO){
					document.getElementById('lesione_stomaco_'+String(indice_riga)).style.display = "";
		}
		else if (value_organo == INTESTINO){
					document.getElementById('lesione_intestino_'+String(indice_riga)).style.display = "";
		}
		else if (value_organo == OSTEOMUSCOLARI){
					document.getElementById('lesione_osteomuscolari_'+String(indice_riga)).style.display = "";
		}
		else if ( (value_organo == 13) || (value_organo == 14) || (value_organo == 15) || (value_organo == 16) || (value_organo == 17) || (value_organo == 18)
				|| (value_organo == 19) || (value_organo == 20) || (value_organo == 21) || (value_organo == 22) || (value_organo == 23) || (value_organo == 24) || (value_organo == 25)) {
			document.getElementById('lesione_generici_'+String(indice_riga)).style.display = "";
		}
		else{
			document.getElementById('lesione_altro_'+String(indice_riga)).style.display = "";
		}
	}
	catch(err)
	{
		alert(err.description);
	}
	
}


//index � l'indice del destinatario (1 se il primo 2 se il secondo)
function selectDestinazioneFromLinkTextarea( index )
{
	try {
		document.getElementById( 'destinatario_label_' + index ).innerHTML	= "-- Seleziona Destinatario/Esercente --";
		if(document.getElementById( 'destinatario_' + index + "_id" ).value != "-999"){
			document.getElementById( 'destinatario_' + index + "_id" ).value	= "-1";
			document.getElementById( 'destinatario_' + index + "_nome" ).value	= "";
			document.getElementById('esercenteNoGisa' + index).value = '';
			document.getElementById('esercenteFuoriRegione' + index).value = '';
		}
		
		
		
		
		inReg = document.getElementById( "inRegione_" + index );
		fuoriReg = document.getElementById( "outRegione_" + index );
	
		if( inReg.checked )
		{
			document.getElementById( 'imprese_' + index ).style.display		= "block";
			document.getElementById( 'esercenti_' + index ).style.display	= "none";
			document.getElementById('esercenteFuoriRegione' + index).style.display = 'none';
			document.getElementById('esercenteFuoriRegione' + index).value = '';
		}
		else if( fuoriReg.checked )
		{
			document.getElementById( 'imprese_' + index ).style.display		= "none";
			document.getElementById( 'esercenti_' + index ).style.display	= "block";
			document.getElementById('esercenteNoGisa' + index).style.display = 'none';
			document.getElementById('esercenteNoGisa' + index).value = '';
		}
	}
	catch(err)
	{
		alert(err.description);
	}
}


function selectDestinazione( index )
{
	try {
		document.getElementById( 'destinatario_label_' + index ).innerHTML	= "-- Seleziona Destinatario/Esercente --";
		
		document.getElementById( 'destinatario_' + index + "_id" ).value	= "-1";
		document.getElementById( 'destinatario_' + index + "_nome" ).value	= "";
		document.getElementById('esercenteFuoriRegione' + index).style.display = 'none';
		document.getElementById('esercenteFuoriRegione' + index).value = '';
		document.getElementById('esercenteNoGisa' + index).style.display = 'none';
		document.getElementById('esercenteNoGisa' + index).value = '';
		
		
		
		inReg = document.getElementById( "inRegione_" + index );
		fuoriReg = document.getElementById( "outRegione_" + index );
	
		if( inReg.checked )
		{
			document.getElementById( 'imprese_' + index ).style.display		= "block";
			document.getElementById( 'esercenti_' + index ).style.display	= "none";
			
		}
		else if( fuoriReg.checked )
		{
			document.getElementById( 'imprese_' + index ).style.display		= "none";
			document.getElementById( 'esercenti_' + index ).style.display	= "block";
			
		}
	}
	catch(err)
	{
		alert(err.description);
	}
}

function mostraDestinazione()
{
	try {
		
		inReg1 = document.getElementById( "inRegione_1");
		fuoriReg1 = document.getElementById( "outRegione_1");
		//inReg2 = document.getElementById( "inRegione_2");
		//fuoriReg2 = document.getElementById( "outRegione_2");
	
		if( inReg1.checked )
		{
			document.getElementById( 'imprese_1').style.display		= "block";
			document.getElementById( 'esercenti_1').style.display	= "none";
			
		}
		else if( fuoriReg1.checked )
		{
			document.getElementById( 'imprese_1').style.display		= "none";
			document.getElementById( 'esercenti_1').style.display	= "block";
			
		}

		/*if( inReg2.checked )
		{
			document.getElementById( 'imprese_2').style.display		= "block";
			document.getElementById( 'esercenti_2').style.display	= "none";
			
		}
		else if( fuoriReg2.checked )
		{
			document.getElementById( 'imprese_2').style.display		= "none";
			document.getElementById( 'esercenti_2').style.display	= "block";
			
		}*/
		
	}
	catch(err)
	{
		alert(err.description);
	}
}

//-------------------------------------------------------------------
//Confronta due date in formato stringa d/MM/y
//Ritorna :
//1 se dateA � maggiore di dateB
//0 se dateB � maggiore o uguale di dateA
//-1 se le date sono in formato errato
//-------------------------------------------------------------------
function confrontoAnni( dataA, dataB )
{
	var dataD_A = getDateFromFormat( dataA, 'd/MM/y' );
	var dataD_B = getDateFromFormat( dataB, 'd/MM/y' );

	if (dataD_A==0 || dataD_B==0) {
		return -1;
		}
	else if (dataD_A > dataD_B) {
		return 1;
		}
	return 0;
}


function sonoPassatiQuattroAnni( dal )
{
	if(dal != null && dal != ''){
		var oggi = new Date();
		var dataDal = getDateFromFormat( dal, 'd/MM/y' );
		var qAnni = ( 1000*60*60*24 * (365 * 4 + 1) );
		var diff = ( oggi.getTime() - dataDal );
		return ( diff >= qAnni );
	}
	else{
		return false;
	}

};

function sonoPassatiNAnni( dal, al, anni )
{
	if(dal != null && dal != '' && al != null && al != ''){
		var dataDal = getDateFromFormat( dal, 'd/MM/y' );
		var dataAl = getDateFromFormat( al, 'd/MM/y' );
		var qAnni = ( 1000*60*60*24 * (365 * anni + 1) );
		var diff = ( dataAl - dataDal );
		return ( diff >= qAnni );
	}
	else{
		return false;
	}

};

function sonoPassatiDueAnni( dal )
{
	var oggi = new Date();
	var dataDal = getDateFromFormat( dal, 'd/MM/y' );
	var qAnni = ( 1000*60*60*24 * (365 * 2 + 1) );
	var diff = ( oggi.getTime() - dataDal );
	return ( diff >= qAnni );
};



$(function() {
	$("#tabs").tabs().addClass('ui-tabs-vertical ui-helper-clearfix');
	$("#tabs li").removeClass('ui-corner-top').addClass('ui-corner-left');
});

var ret = true;

function isIntPositivo(Expression,nomeCampo,campo)
{
    Expression = Expression.toLowerCase();
    RefString = "0123456789";
    
    if (Expression.length < 1) 
        return (false);
    
    for (var i = 0; i < Expression.length; i++) 
    {
        var ch = Expression.substr(i, 1);
        var a = RefString.indexOf(ch, 0);
        if (a < 0)
        {
            alert('Inserire un intero positivo nel campo ' + nomeCampo +'.');
            campo.value='';
            campo.focus();
        	return false;
        }
    }
    return(true);
}

function calcolaNumCapiOviniDestCorrente()
{
	var toReturn = parseInt('0');
	var i=1;
	for(i=1;i<=20;i++)
	{
		if(document.getElementById('num_capi_ovini_'+i)!=null && document.getElementById('num_capi_ovini_'+i).value!="")
			toReturn += parseInt(document.getElementById('num_capi_ovini_'+i).value);
	}
	return toReturn;
}

function calcolaNumCapiCapriniDestCorrente()
{
	var toReturn = parseInt('0');
	var i=1;
	for(i=1;i<=20;i++)
	{
		if(document.getElementById('num_capi_caprini_'+i)!=null && document.getElementById('num_capi_caprini_'+i).value!="")
			toReturn += parseInt(document.getElementById('num_capi_caprini_'+i).value);
	}
	return toReturn;
}

function controllaForm( toLiberoConsumo )
{
	var specie1 = document.getElementById("Specie1").value;
	var specie2 = document.getElementById("Specie2").value;
	try{
		var form = document.main;

		//Geocodifica.isCapoEsistente( form.cd_matricola.value, gestisciCapoEsistente );
		message ="";
		ret = true;
		
		verificaStampaMod10(document.getElementById('altId').value,document.getElementById('vpm_data').value);
		
		var casl_num_capi_ovini = 0;
		var vam_num_capi_ovini = 0;
		var mavam_num_capi_ovini = 0;
		if(form.casl_num_capi_ovini.value!="")
			casl_num_capi_ovini = parseInt(form.casl_num_capi_ovini.value);
		
		if(form.vam_num_capi_ovini.value!="")
			vam_num_capi_ovini = parseInt(form.vam_num_capi_ovini.value);
		if(form.mavam_num_capi_ovini.value!="")
			mavam_num_capi_ovini = parseInt(form.mavam_num_capi_ovini.value);
		if(form.numCapiOviniPartita_AltreSedute.value!="")
			numCapiOviniPartita_AltreSedute = parseInt(form.numCapiOviniPartita_AltreSedute.value);
		
		if( parseInt(form.cd_num_capi_ovini.value)  < casl_num_capi_ovini + mavam_num_capi_ovini + numCapiOviniPartita_AltreSedute)
		{
			message += label("","- [Controllo documentale] : \"Numero Capi "+specie1+" \" non pu� essere inferiore alla somma dei capi ovini specificati nelle sezioni successive\r\n" );
			ret = false;
		}
		
		var casl_num_capi_caprini = 0;
		var vam_num_capi_caprini = 0;
		var mavam_num_capi_caprini = 0;
		if(form.casl_num_capi_caprini.value!="")
			casl_num_capi_caprini = parseInt(form.casl_num_capi_caprini.value);
		if(form.vam_num_capi_caprini.value!="")
			vam_num_capi_caprini = parseInt(form.vam_num_capi_caprini.value);
		if(form.mavam_num_capi_caprini.value!="")
			mavam_num_capi_caprini = parseInt(form.mavam_num_capi_caprini.value);
		if(form.numCapiCapriniPartita_AltreSedute.value!="")
			numCapiCapriniPartita_AltreSedute = parseInt(form.numCapiCapriniPartita_AltreSedute.value);
		
		if( parseInt(form.cd_num_capi_caprini.value)  < casl_num_capi_caprini + mavam_num_capi_caprini + numCapiCapriniPartita_AltreSedute)
		{
			message += label("","- [Controllo documentale] : \"Numero Capi "+specie2+" \" non pu� essere inferiore alla somma dei capi caprini specificati nelle sezioni successive\r\n" );
			ret = false;
		}
		
		var numCapiOviniDestPartita_AltreSedute = document.getElementById("numCapiOviniDestPartita_AltreSedute").value;
		var numCapiCapriniDestPartita_AltreSedute = document.getElementById("numCapiCapriniDestPartita_AltreSedute").value;
		var numCapiOviniMavamPartita_AltreSedute = document.getElementById("numCapiOviniMavamPartita_AltreSedute").value;
		var numCapiCapriniMavamPartita_AltreSedute = document.getElementById("numCapiCapriniMavamPartita_AltreSedute").value;
		
		var numCapiOviniDestTotale = calcolaNumCapiOviniDestCorrente() + mavam_num_capi_ovini + parseInt(numCapiOviniDestPartita_AltreSedute) + parseInt(numCapiOviniMavamPartita_AltreSedute);
		var numCapiOviniControlloDocumentale = parseInt(form.cd_num_capi_ovini.value);
		if(numCapiOviniDestTotale>numCapiOviniControlloDocumentale)
		{
				message += label("","- [Evidenza Visita AM] : \"Numero Capi  "+specie1+" \" specificati nella Visita AM e Morte Ant.macellazione non pu� essere superiore al numero di capi "+specie1+" \" specificati nel controllo documentale\r\n" );
				ret = false;
		}
		
		var numCapiCapriniDestTotale = calcolaNumCapiCapriniDestCorrente() + mavam_num_capi_caprini + parseInt(numCapiCapriniDestPartita_AltreSedute) + parseInt(numCapiCapriniMavamPartita_AltreSedute);
		var numCapiCapriniControlloDocumentale = parseInt(form.cd_num_capi_caprini.value);
		if(numCapiCapriniDestTotale>numCapiCapriniControlloDocumentale)
		{
				message += label("","- [Evidenza Visita AM] : \"Numero Capi  "+specie2+" \" specificati nella Visita AM e Morte Ant.macellazione non pu� essere superiore al numero di capi "+specie2+" \" specificati nel controllo documentale\r\n" );
				ret = false;
		}
		if(!toLiberoConsumo)
		{
			var num_capi_ovini_esito_2_val = 0;
			if(document.getElementById('num_capi_ovini_esito_2')!=null && document.getElementById('num_capi_ovini_esito_2').value!='')
				num_capi_ovini_esito_2_val = parseInt(document.getElementById('num_capi_ovini_esito_2').value);
			if(calcolaNumCapiOviniDestCorrente()+num_capi_ovini_esito_2_val!=vam_num_capi_ovini)
			{
					message += label("","- [Evidenza Visita PM] : \"Numero Capi  "+specie1+" \" specificati nei destinatari delle carni non pu� essere diverso da quello specificato nella Visita AM\r\n" );
					ret = false;
			}
			
			var num_capi_caprini_esito_2_val = 0;
			if(document.getElementById('num_capi_caprini_esito_2')!=null && document.getElementById('num_capi_caprini_esito_2').value!='')
				num_capi_caprini_esito_2_val = parseInt(document.getElementById('num_capi_caprini_esito_2').value);
			if(calcolaNumCapiCapriniDestCorrente()+num_capi_caprini_esito_2_val!=vam_num_capi_caprini)
			{
					message += label("","- [Evidenza Visita PM] : \"Numero Capi  "+specie2+" \" specificati nei destinatari delle carni non pu� essere diverso da quello specificato nella Visita AM\r\n" );
					ret = false;
			}
		}
		var luogoMorteAnteMacellazione = document.getElementById('mavam_luogo').selectedIndex > 0;
		if(luogoMorteAnteMacellazione && form.mavam_num_capi_ovini.value == '' &&  document.getElementById('cd_num_capi_ovini').value!="" )
		{
			message += label("","- [Morte ant.Macellazione] : \"Numero Capi  "+specie1+" \" obbligatorio\r\n" );
			ret = false;
		}
		
		if(!toLiberoConsumo){

			//Controllo che siano valorizzati o tutti o nessuno dei campi obbligatori di Morte ant. macellazione
			var dataMorteAnteMacellazione = document.getElementById('mavam_data').value != '';
			var luogoMorteAnteMacellazione = document.getElementById('mavam_luogo').selectedIndex > 0;
			var causaMorteAnteMacellazione = trim( document.getElementById('mavam_motivo').value ) != '';
		
			//se almeno uno di essi � valorizzato...
			if(dataMorteAnteMacellazione || luogoMorteAnteMacellazione || causaMorteAnteMacellazione){
	
				//...allora vedi se ce n'� almeno uno NON valorizzato
				if(!dataMorteAnteMacellazione || !luogoMorteAnteMacellazione || !causaMorteAnteMacellazione){
					message += label("","- [Morte ant. macellazione] :\r\n \tUno dei seguenti campi � valorizzato:\r\n \t*Data \r\n \t*Luogo di verifica\r\n \t*Causa\r\n \tValorizzare anche gli altri.\r\n"  );
					ret = false;
				}
				
			}
		
		}
		
		if ( form.vam_data.value != '' && form.vpm_data.value != '' )
		{
			if ( confrontaDate( form.vam_data.value, form.vpm_data.value ) == 1 ) { 
				message += label("","- [Evidenza Visita AM] : Inserire \"Data Visita Ante Mortem\" minore o uguale alla \"Data Visita Post Mortem\"" + " (" +  form.vpm_data.value + ")\r\n" );
				ret = false;
			}
		}
		
		if(!toLiberoConsumo){
		
			//Controllo che siano valorizzati o tutti o nessuno dei campi obbligatori di Visita Ante Mortem
			var dataVisitaAnteMortem = document.getElementById('vam_data').value != '';
			var provvedimentoVisitaAnteMortem = document.getElementById('vam_provvedimenti').selectedIndex > 0;
			var vpm_data_valorizzato = form.vpm_data!=null && form.vpm_data.value != '';
			
			var numCapiOvini="";
			var numCapiCaprini="";
			
			if(document.getElementById('vam_num_capi_ovini')!=null)
				numCapiOvini=document.getElementById('vam_num_capi_ovini').value;
			if(document.getElementById('vam_num_capi_caprini')!=null)
				numCapiCaprini=document.getElementById('vam_num_capi_caprini').value;
			
			//se almeno uno di essi � valorizzato...
			if(dataVisitaAnteMortem || provvedimentoVisitaAnteMortem || vpm_data_valorizzato || numCapiOvini!="" || numCapiCaprini!=""){
	
				//...allora vedi se ce n'� almeno uno NON valorizzato
				if(!dataVisitaAnteMortem || !provvedimentoVisitaAnteMortem || !vpm_data_valorizzato){
					message += label("","- [Evidenza Visita AM/PM] :\r\n \tUno dei seguenti campi � valorizzato:\r\n \t*Data \r\n \t*Provvedimento adottato\r\n \t*Data Visita PM\r\n \t*Numero capi\r\n \tValorizzare anche gli altri.\r\n"  );
					ret = false;
				}
				
			}
		
		}
	
		

		if(!toLiberoConsumo){
			if(false){
			//Controllo che siano valorizzati o tutti o nessuno dei campi obbligatori di Visita Post Mortem
			var dataVisitaPostMortem = document.getElementById('vpm_data').value != '';
			var destinatarioVisitaPostMortem = trim(document.getElementById('destinatario_1_nome').value).length > 0;
		
			//se almeno uno di essi � valorizzato...
			if(dataVisitaPostMortem || destinatarioVisitaPostMortem){
	
				//...allora vedi se ce n'� almeno uno NON valorizzato
				if(!dataVisitaPostMortem || !destinatarioVisitaPostMortem){
					message += label("","- [Evidenza Visita PM] :\r\n \tUno dei seguenti campi � valorizzato:\r\n \t*Data Macellazione\r\n \t*Destinatario Carni\r\n \tValorizzare anche gli altri.\r\n"  );
					ret = false;
				}
				
			}
			}
			//Controllo numero capi esito
			var select = document.getElementById('vpm_esito'),
			options = select.getElementsByTagName('option');
			for (var i=0; i<options.length; i++) 
			{
				if(options[i].index>=2)
				{
					var id = options[i].value;
					var selected = options[i].selected;
					if(selected && document.getElementById('num_capi_ovini_esito_'+id).value=="" && document.getElementById('num_capi_caprini_esito_'+id).value=="")
					{
						message += label("","- [Evidenza Visita PM] :\r\n \tValorizzare il numero di capi per ogni esito selezionato.\r\n"  );
						ret = false;	
						break;
					}
				}
			}
			
			if(!controllaObbligNumCapiDestCarni())
			{
				message += label("", "- [Evidenza Visita PM] : Inserire \"Numero Capi\" per ogni destinatario selezionato\r\n" );
				ret = false;	
			}

			if(false)
			{
				if(destinatarioVisitaPostMortem && (dataMorteAnteMacellazione || luogoMorteAnteMacellazione ||  causaMorteAnteMacellazione))
				{
					message += label("","- [Evidenza Visita PM] :\r\n \t Animale morto prima della macellazione.Non � possibile indicare Destinatari delle carni\r\n"  );
					ret = false;
				}
			}

		}
		if ( form.vpm_data.value != '' )
		{
			if ( confrontoAnni( form.abb_data.value, form.vpm_data.value ) == 1 ) { 
				message += label ("","- [Evidenza Visita PM] : Inserire \"Data Visita Post Mortem\" maggiore o uguale alla \"Data Abbattimento\" del capo" + " (" +  form.vam_data.value + ")\r\n" );
				ret = false;
			}
		}	
	
		/*
		if ( form.vam_provvedimenti.value != '-1' && form.vam_data.value == ''  )
		{
			message += label("","- [Evidenza Visita AM] : Inserire la data della Visita Ante Mortem.\r\n" );
			ret = false;
		}
		*/
		if ( form.vam_provvedimenti.value == '4' && form.abb_data.value == ''  )
		{
			message += label("","- [Evidenza Visita AM] : Inserire la data di abbattimento.\r\n" );
			ret = false;
		}
	

		//Controllo che almeno uno dei campi "Destinatario delle Carni" sia stato valorizzato
		/*
		if(!toLiberoConsumo){
			if( trim(form.destinatario_1_nome.value).length == 0 && trim(form.destinatario_2_nome.value).length == 0 ){
				message += label("","- [Evidenza Visita PM] : Inserire almeno un Destinatario delle Carni.\r\n" );
				ret = false;
			}
		}
		*/
		

		if ( (form.cmp_matrice_1.value == '-1' && form.cmp_tipo_1.value != '-1') ||
			 (form.cmp_matrice_2.value == '-1' && form.cmp_tipo_2.value != '-1') ||
			 (form.cmp_matrice_3.value == '-1' && form.cmp_tipo_3.value != '-1') ||
			 (form.cmp_matrice_4.value == '-1' && form.cmp_tipo_4.value != '-1') ||
			 (form.cmp_matrice_5.value == '-1' && form.cmp_tipo_5.value != '-1'))
		{
			message += label("","- [Evidenza Visita PM] : Non � possibile inserire un campione senza scegliere la relativa matrice.\r\n" );
			ret = false;
		}

		//se � selezionato il flag test bse deve essere selezionato un valore dalla tendina corrispondente

		
		//if( form.cd_bse_check.checked && form.cd_data_nascita.value!='' && !sonoPassatiQuattroAnni( form.cd_data_nascita.value)){
			//message += label("","- Il capo non ha pi� di 4 anni.\nPer il test BSE e' obbligatorio specificare una data di nascita opportuna\r\n");
			//ret = false;
		//}

		//if( sonoPassatiNAnni( form.cd_data_nascita.value, form.vpm_data.value, <%= ApplicationProperties.getProperty("numeroAnniTestBse") %> ) && ( (id_specie_selezionata == BOVINI || id_specie_selezionata == BUFALINI)  ) )
		//{
			//if(document.getElementById('cd_bse_check').checked==false){
				/*
				message += label("", "- [Controllo Documentale] : Il capo ha pi� di 4 anni. E\' obbligatorio l\'inserimento dei dati sul test BSE" );
				ret = false;
				document.getElementById('cd_bse_list').style.display = "";
				document.getElementById('sezioneTESTBSE').style.display = "";
				document.getElementById('cd_bse_check').checked = true;
				document.getElementById('cd_bse').style.display = "";
				
				document.getElementById('manca_BSE_Nmesi').value = 'si';*/
			//}
			//else{
				//contralla_cd_bse();
			//}
			
			//document.getElementById('cd_bse_list').style.display = "";
			//document.getElementById('sezioneTESTBSE').style.display = "";
			
			//ret=false;
		//}


		//Test BSE obbligatorio se l'animale muore prima della macellazione
		/*
		if(document.getElementById('cd_bse_check').checked==false && document.getElementById('mavam_luogo').value != '-1' && ( (id_specie_selezionata == BOVINI || id_specie_selezionata == BUFALINI)  ) ){

			document.getElementById('test_bse_etichetta').style.display = "";
			document.getElementById('test_bse_valore').style.display = "";
			document.getElementById('cd_bse_list').style.display = "";
			document.getElementById('sezioneTESTBSE').style.display = "";
			document.getElementById('cd_bse_check').checked = true;
			document.getElementById('cd_bse').style.display = "";
			message += label("", "- [Controllo Documentale] : Animale morto prima della macellazione. E\' obbligatorio l\'inserimento dei dati sul test BSE" );
			ret = false;
			
		}
		*/
			
		
		
		
		//alert("sonoPassatiQuattroAnni( form.cd_data_nascita.value ) : " + sonoPassatiQuattroAnni( form.cd_data_nascita.value ) );
		//alert("form.bse_data_prelievo.value == '' : " + (form.bse_data_prelievo.value == '') );
		//alert("form.bse_data_prelievo.value == '' : " + (form.bse_data_prelievo.value == '') );
		//alert("id_specie_selezionata : " + id_specie_selezionata)
		//alert("document.getElementById('cd_specie').value : " + document.getElementById('cd_specie').value);
		
		
		/*se il capo ha pi� di 48 mesi deve essere eseguito il test bse (l\'esito pu� essere inserito dopo) 
		if( ret && sonoPassatiQuattroAnni( form.cd_data_nascita.value ) && form.bse_data_prelievo.value == '' && ( (id_specie_selezionata == BOVINI || id_specie_selezionata == BUFALINI)  ) )
		{
			alert( "Controllo Documentale : \n\nIl capo ha pi� di 4 anni.\nE\' obbligatorio l\'inserimento dei dati sul test BSE" );
			document.getElementById('cd_bse_check').checked = true;
			contralla_cd_bse();
			ret = false;
		}*/
	
		/*se � selezionato il test bse e il relativo valore allora devono essere inserite le info sul test bse (data prelievo)
		if( ret && form.cd_bse_check.checked && form.cd_bse.value != '-1' && form.bse_data_prelievo.value == '' ) 
		{
			alert( "Controllo Documentale : \n\nHai selezionato Test BSE. Devi inserire la data di prelievo." );
			ret = false;
		}*/
	
		//la selezione di uno dei campi esito e data ricezione esito nella sezione test bse 
		//implica la selezione di tutti tre i campi: esito, data ricezione esito e data prelievo
	//	if( ret && (form.bse_esito.value != '-1' || form.bse_data_ricezione_esito.value != '') //almeno uno dei due valori � selezionato
	//			&& (form.bse_esito.value == '-1' || form.bse_data_ricezione_esito.value == '' || form.bse_data_prelievo.value == '' ) ) //almeno uno dei tre valori non � selezionato
	//	{
	//		alert( "Controllo Documentale : \n\nDati sul Test BSE incompleti. Inserire Data Prelievo." );
	//		ret = false;
	//	} 


		//CONTROLLO SULL'ESITO DISATTIVATO
		/*se si inseriscono le info sul test bse e non le info sull\'esito non si pu� mandare l\'animale al libero consumo
		if( ret && form.bse_data_prelievo.value != '' && form.bse_esito.value == '-1' && ( form.vpm_esito.value == '1' || toLiberoConsumo )  )
		{
			alert( "Controllo Documentale : \n\nNon hai inserito i dati sull\'esito del Test BSE. Non puoi mandare l\'animale in libero consumo." );
			ret = false;
		}*/

		
	
		//Aggiunta
		 if (ret == false) {
			 document.getElementById('submitOK').value = 'no';
      		alert(label("", "La form non puo' essere salvata, verifica i seguenti errori:\r\n\r\n") + message);
    	}
		 else{
			 document.getElementById('submitOK').value = 'si';
		}

		
	  }
	catch(err)
	  {
		alert(err);
	  }

	if (ret== true)
		loadModalWindow();
	return ret;
};




function checkControlloDocumentale( )
{
	try{
		var form = document.main;
		var ret = true;
		message = "";


		/*if( form.cd_dati_speditore.value == '' )
		{
			message += label("","- [Controllo documentale] : \"Speditore\" obbligatorio\r\n" );
			ret = false;

		}*/


		//if( sonoPassatiNAnni( form.vpm_data.value, <%= ApplicationProperties.getProperty("numeroAnniTestBse") %> ) && ( (id_specie_selezionata == BOVINI || id_specie_selezionata == BUFALINI)  ) )
		//{
			//if(document.getElementById('cd_bse_check').checked==false){
				/*
				message += label("", "- [Controllo Documentale] : Il capo ha pi� di 4 anni. E\' obbligatorio l\'inserimento dei dati sul test BSE" );
				ret = false;
				document.getElementById('cd_bse_list').style.display = "";
				document.getElementById('sezioneTESTBSE').style.display = "";
				document.getElementById('cd_bse_check').checked = true;
				document.getElementById('cd_bse').style.display = "";
				
				document.getElementById('manca_BSE_Nmesi').value = 'si';*/
			//}
			//else{
				//contralla_cd_bse();
			//}
			
			//document.getElementById('cd_bse_list').style.display = "";
			//document.getElementById('sezioneTESTBSE').style.display = "";
			
			//ret=false;
		//}


		//Test BSE obbligatorio se l'animale muore prima della macellazione
<%
	if(Partita.getCd_num_capi_ovini_da_testare()<=0 && Partita.getCd_num_capi_caprini_da_testare()<=0)
	{
%>
		if(document.getElementById('mavam_luogo').value != '-1' && ( (id_specie_selezionata == BOVINI || id_specie_selezionata == BUFALINI)  ) ){

			document.getElementById('test_bse_etichetta').style.display = "";
			document.getElementById('test_bse_valore').style.display = "";
			document.getElementById('sezioneTESTBSE').style.display = "";
			message += label("", "- [Controllo Documentale] : Animale morto prima della macellazione. E\' obbligatorio l\'inserimento dei dati sul test TSE" );
			ret = false;
			
		}
<%
	}
%>

		//Aggiunta
		 if (ret == false) {
      		alert(label("", "Prima di poter procedere con altre operazioni, verificare quanto segue:\r\n\r\n") + message);
    	 }
    	 else{
        	 displayTabs();
       	 }

		
	  }
	catch(err)
	  {
		alert(err);
	  }

	return ret;
};



function displayAbbattimento()
{
	try {
			if( document.main.vam_provvedimenti.value==4 )
			{
				document.getElementById("table_abbattimento").style.display="";
			}
			else
			{
				document.getElementById("table_abbattimento").style.display="none";
			}
	  }
	catch(err)
	  {
		alert(err);
	  }
}

function displayLuogoVerifica()
{
	if( document.main.mavam_luogo.value==3 )
	{
		document.getElementById("luogo").style.display="";
	}
	else
	{
		document.getElementById("luogo").style.display="none";
	}
	
}


function displayStadio( index )
{
	if( document.getElementsByName( 'lcso_patologia_' + index )[0].value == 6 )
	{
		document.getElementById( "stadio_" + index ).style.display = "table-row";
	}
	else
	{
		document.getElementById( "stadio_" + index ).style.display = "none";
	}
}

function controlla_esito_testBSE() {

	//alert(document.getElementById('bse_esito').value);
<%
	if((Partita.getCd_num_capi_ovini_da_testare()>0 || Partita.getCd_num_capi_caprini_da_testare()>0)&& ( Partita.getBse_esito()==null || Partita.getBse_esito().equals("-1")))
	{
%>
		document.getElementById('liberoConsumoButton').value="Libero Consumo in attesa di esito Test TSE >>";
<%
	}
	else
	{
%>
		document.getElementById('liberoConsumoButton').value="Libero Consumo >>";
<%
	}
%>
		
}

function nascondi_liberoConsumoButton(nascondi){

	//alert (nascondi);
	
	if (nascondi) {
		document.getElementById('liberoConsumoButton').style.display = "none";
	} else {
		document.getElementById('liberoConsumoButton').style.display = "";
	}
}

function contralla_cd_bse()
{
<%
	if(Partita.getCd_num_capi_ovini_da_testare()>0 || Partita.getCd_num_capi_caprini_da_testare()>0)
	{
		if((Partita.getCd_num_capi_ovini_da_testare()>0 || Partita.getCd_num_capi_caprini_da_testare()>0) && ( Partita.getBse_esito()==null || Partita.getBse_esito().equals("-1")))
		{
%>
			document.getElementById('liberoConsumoButton').value="Libero Consumo in attesa di esito Test TSE >>";
<%
		}
%>
		document.getElementById('sezioneTESTBSE').style.display = "";
<%
	} 
	else 
	{
%>
		document.getElementById('liberoConsumoButton').value="Libero Consumo >>";
		document.getElementById('sezioneTESTBSE').style.display = "none";
<%
	}
%>
}

function annullaID_cd_bse()
{
	document.main.bse_data_prelievo.value = '';
	document.main.bse_data_ricezione_esito.value = '';
	document.main.bse_esito.value = -1;
	document.main.bse_note.value = '';
};

function annullaID_cd_bse_onload()
{
	document.getElementById('sezioneTESTBSE').style.display = "none";
	
	document.main.bse_data_prelievo.value = '';
	document.main.bse_data_ricezione_esito.value = '';
	document.main.bse_esito.value = -1;
	document.main.bse_note.value = '';
};

function controllaStatoItaliano()
{
	if ( document.getElementById('cd_provenienza_stato').value != 113 ) {
		document.getElementById('cd_asl').value 	= -1;
		document.getElementById('cd_asl').disabled  = true;

		document.getElementById('cd_provenienza_regione').value 	= -1;
		document.getElementById('cd_provenienza_regione').disabled  = true;
	} else {
		document.getElementById('cd_asl').disabled  = false;
		document.getElementById('cd_provenienza_regione').disabled  = false;
	}
		
};



function toggleDiv( nomeCampo )
{
	var value = document.getElementById( nomeCampo );

	if( value.style.display == "none" )
	{
		value.style.display = "block";
	}
	else
	{
		value.style.display = "none";
	}
};


function toggleVetDiv( nomeCampo )
{
	var value = document.getElementById( nomeCampo ).value;

	if( value.length > 0 )
	{
		if(document.getElementById( nomeCampo + "_toggle" )){
			document.getElementById( nomeCampo + "_toggle" ).style.display = "block";
		}
	}
};

function contains(a, obj) 
{
    for (var i = 0; i < a.length; i++) 
    {
        if (a[i] == obj) 
            return true;
    }
    return false;
}

function displayVPMpatologie()
{
	var select = document.getElementById('vpm_esito'),
	options = select.getElementsByTagName('option');
	values  = [];

	for (var i=options.length; i--;) 
	{
	     if (options[i].selected) 
	    	 values.push(options[i].value);
	}
	 
	if( contains(values, 4) || contains(values, 2) )
	{
		document.getElementById( "vpm_riga_patologie" ).style.display = "table-row";
	}
	else
	{
		document.getElementById( "vpm_patologie_rilevate").value = -1;
		document.getElementById( "vpm_riga_patologie" ).style.display = "none";
	}
}

function displayNumCapiEsito()
{
	var select = document.getElementById('vpm_esito'),
	options = select.getElementsByTagName('option');
	values  = [];

	for (var i=0; i<options.length; i++) 
	{
		if(options[i].index>=2)
		{
			var id = options[i].value;
			var selected = options[i].selected;
			if(selected)
			{
				document.getElementById('trNumCapiOviniEsito'+id).style.display="";
				document.getElementById('trNumCapiCapriniEsito'+id).style.display="";
			}
			else
			{
				document.getElementById('trNumCapiOviniEsito'+id).style.display="none";
				document.getElementById('trNumCapiCapriniEsito'+id).style.display="none";
			}
		}
	}
}

function resetSelect(){

	for (i=1; i<=3; i++){
		if(document.getElementById("lcso_organo_"+i)){
			document.getElementById("lcso_organo_"+i).value = -1;
		}
		if(document.getElementById("lesione_milza_"+i)){
			document.getElementById("lesione_milza_"+i).value = -1;
		}
		if(document.getElementById("lesione_cuore_"+i)){
			document.getElementById("lesione_cuore_"+i).value = -1;
		}
		if(document.getElementById("lesione_polmoni_"+i)){
			document.getElementById("lesione_polmoni_"+i).value = -1;	
		}
		if(document.getElementById("lesione_visceri_"+i)){
			document.getElementById("lesione_visceri_"+i).value = -1;	
		}
		if(document.getElementById("lesione_fegato_"+i)){
			document.getElementById("lesione_fegato_"+i).value = -1;
		}
		if(document.getElementById("lesione_rene_"+i)){
			document.getElementById("lesione_rene_"+i).value = -1;
		}
		if(document.getElementById("lesione_mammella_"+i)){
			document.getElementById("lesione_mammella_"+i).value = -1;
		}
		if(document.getElementById("lesione_apparato_genitale_"+i)){
			document.getElementById("lesione_apparato_genitale_"+i).value = -1;
		}
		if(document.getElementById("lesione_stomaco_"+i)){
			document.getElementById("lesione_stomaco_"+i).value = -1;
		}
		if(document.getElementById("lesione_intestino_"+i)){
			document.getElementById("lesione_intestino_"+i).value = -1;
		}
		if(document.getElementById("lesione_osteomuscolari_"+i)){
			document.getElementById("lesione_osteomuscolari_"+i).value = -1;
		}
		if(document.getElementById("lesione_generici_"+i)){
			document.getElementById("lesione_generici_"+i).value = -1;
		}
		if(document.getElementById("lesione_altro_"+i)){
			document.getElementById("lesione_altro_"+i).value = -1;
		}
	}
}


function displayLCSO()
{
	if( document.main.vpm_esito.value == 3 )
	{
		
		document.getElementById("lcso").style.display="";
		document.getElementById("lcsobutton").style.display="";
		document.getElementById("lcpr").style.display="none";
		
		
	}
	else if( document.main.vpm_esito.value == 4 )
	{
		/* vecchia versione, nella nuova se 4 si visualizzano anche i campi di 3
		document.getElementById("lcpr").style.display="";
		document.getElementById("lcso").style.display="none";
		document.getElementById("lcsobutton").style.display="none";
		*/
		document.getElementById("lcpr").style.display="";
		document.getElementById("lcso").style.display="";
		document.getElementById("lcsobutton").style.display="";
	}
	else
	{
		document.getElementById("lcso").style.display="none";
		document.getElementById("lcsobutton").style.display="none";
		document.getElementById("lcpr").style.display="none";
/*
		if( document.main.vpm_esito.value==2 )
		{
			document.getElementById("tr_vpm_abb_dist_carcassa").style.display="";
			document.getElementById("vpm_abb_dist_carcassa").checked=true;
		}
		else
		{
			document.getElementById("tr_vpm_abb_dist_carcassa").style.display="none";
			document.getElementById("vpm_abb_dist_carcassa").checked=false;
		}
*/
	}
};
	
/*
function distrCarcassaVMP()
{
	if( document.main.vpm_esito.value==2 )
	{
	document.getElementById("tr_vpm_abb_dist_carcassa").style.display="";
	document.getElementById("vpm_abb_dist_carcassa").checked=true;
	}
	else{
	document.getElementById("tr_vpm_abb_dist_carcassa").style.display="none";
	document.getElementById("vpm_abb_dist_carcassa").checked=false;
	}
};
*/

function set_vet( select, campo )
{
	var value_to_set = "";
	if( select.value != "-1" )
	{
		value_to_set = select.options[ select.selectedIndex ].text;
	}
	document.getElementById( campo ).value = value_to_set;
	toggleVetDiv( campo );
};

function gestisciUtenteVeterinario(){
	var ruolo = '<%= User.getRoleId() %>';
	var userId = '<%= User.getUserId() %>';
	var nome = "<%= User.getContact().getNameLast().toUpperCase().replaceAll("\"","'") + " " + User.getContact().getNameFirst().toUpperCase().replaceAll("\"","'") %>";

	if(ruolo == 43 || ruolo == 19 || ruolo == 46){
		
		var select = document.getElementById('veterinari_cd1');
		for (var i = 0 ; i < select.length - 1; i++){
			if(select.options[i].value == userId ){
				select.options[i].selected = true;
				document.getElementById('cd_veterinario_1').value = nome;
				document.getElementById('vpm_veterinario').value = nome;
				document.getElementById('cd_veterinario_1_toggle').style.display='block';
				document.getElementById('veterinari_vpm').options[select.selectedIndex].selected = true;
				return;
			}
		}
	}
	
}

function preselezionaVeterinario(select, num){

	var value_to_set = "";
	if( select.value != "-1" )
	{
		value_to_set = select.options[ select.selectedIndex ].text;
	}

	if(num == 1){
		document.getElementById('vpm_veterinario').value = value_to_set;
		document.getElementById('veterinari_vpm').options[select.selectedIndex].selected = true;
	}
	else if(num == 2){
		document.getElementById('vpm_veterinario_toggle').style.display='block';
		document.getElementById('vpm_veterinario_2').value = value_to_set;
		document.getElementById('veterinari_vpm2').options[select.selectedIndex].selected = true;
	}
	else if(num == 3){
		document.getElementById('vpm_veterinario_2_toggle').style.display='block';
		document.getElementById('vpm_veterinario_3').value = value_to_set;
		document.getElementById('veterinari_vpm3').options[select.selectedIndex].selected = true;
	}
	
}

function gestisciDataCorrente(){
	var clona = 'si';
	var update = 'si';
	if(clona != 'si' && update != 'si' && document.getElementById('cd_data_arrivo_macello').value == '' ){
		document.getElementById('cd_data_arrivo_macello').value = '<%= sdf.format(new Date()) %>';
	}
	//preselezionaDate();
}

function riportaDataArrivoMacello(input){
	if(input.value == '' && document.getElementById('cd_data_arrivo_macello').value != ''){
		input.value = document.getElementById('cd_data_arrivo_macello').value;
	}
}

function preselezionaDate(){

	if(confirm('Cliccare OK se si vuole propagare la data anche per:\n' +
			   '- Data Comunicazioni Esterne\n' + 
			   '- Data Ricezione Comunicazioni Esterne\n' + 
			   '- Data Morte antecedente macellazione\n' +
			   '- Data Visita Ante Mortem\n' +
			   '- Data Macellazione\n')){

		var value_to_set = document.getElementById('cd_data_arrivo_macello').value;
	
		document.getElementById('casl_data').value = value_to_set;
		document.getElementById('rca_data').value = value_to_set;
		document.getElementById('mavam_data').value = value_to_set;
		document.getElementById('vam_data').value = value_to_set;
		document.getElementById('vpm_data').value = value_to_set;

	}
	
}

function gestisciCapoEsistente(capo){

	var form = document.main;
	if( capo.esistente )
	{
		form.partita_esistente.value = 'si';
		alert( "Matricola " + capo.matricola + " gi� esistente" );
	}
	else
	{
		form.partita_esistente.value = 'no';
		Geocodifica.getCapo( capo.partita, getDatiCapo );
	}
	
}

function getDatiCapo( data )
{
	var form = document.main;
	var partita = form.cd_partita.value	;

	if( partita == '' )
	{
		return;
	}

	form.cd_partita.value = data.partita;
	
	if(data.errore == 0)
	{
		form.cd_codice_azienda.value = data.codice_azienda;
		form.cd_specie.value = data.specie;
	}

};

function trim(str){
    return str.replace(/^\s+|\s+$/g,"");
} 


function mostraTextareaEsercente(idTextarea){
	document.getElementById(idTextarea).style.display = '';
}

function nascondiTextareaEsercente(idTextarea){
	document.getElementById(idTextarea).value = '';
	document.getElementById(idTextarea).style.display = 'none';
}

function valorizzaDestinatario(campoTextarea,idDestinatario){
	document.getElementById(idDestinatario + '_nome').value = campoTextarea.value;
	document.getElementById(idDestinatario + '_id').value = -999;
	gestisciObbligatorietaVisitaPostMortem();
}

function visualizzaTextareaCAslToAltro(){
	if(document.getElementById('casl_to_altro') && document.getElementById('casl_to_altro').checked){
		document.getElementById('casl_to_altro_testo').style.display = '';
	}
	else{
		document.getElementById('casl_to_altro_testo').style.display = 'none';
	}
}

function visualizzaTextareaMavamToAltro(){
	if(document.getElementById('mavam_to_altro') && document.getElementById('mavam_to_altro').checked){
		document.getElementById('mavam_to_altro_testo').style.display = '';
	}
	else{
		document.getElementById('mavam_to_altro_testo').style.display = 'none';
	}
}

function visualizzaTextareaVamToAltro(){
	if(document.getElementById('vam_to_altro') && document.getElementById('vam_to_altro').checked){
		document.getElementById('vam_to_altro_testo').style.display = '';
	}
	else{
		document.getElementById('vam_to_altro_testo').style.display = 'none';
	}
}

function settaSoloCD(valore){
	document.getElementById('solo_cd').value = valore;
}

function displayTabs(){
	document.getElementById('li-7').style.display = '';
	document.getElementById('li-4').style.display = '';
	document.getElementById('li-2').style.display = '';
	document.getElementById('li-3').style.display = '';
	window.location.href="#";
}

function sleep(milliseconds) {
	  var start = new Date().getTime();
	  
	  for (var i = 0; i < 1e7; i++) {
		  
	    if ((new Date().getTime() - start) > milliseconds){
	      break;
	    }
	    
	  }
}

function gestisciUnload(){

	if(document.getElementById('submitOK').value == 'no'){
		if(confirm('Stai uscendo dalla scheda "<%= update ? "Modifica" : "Aggiungi"%> Capo". Cliccare su OK per salvare i dati, altrimenti le informazioni inserite verranno perse.')){
			if(controllaForm(false)){
				document.main.submit();
				alert('Si � scelto di salvare i dati sul capo.');
			}
			else{
				return false;
			}
		}
	}
	
}

function svuotaData(input){
	input.value = '';
	gestisciObbligatorietaMorteAnteMacellazione();
	gestisciObbligatorietaVisitaAnteMortem();
	gestisciObbligatorietaVisitaPostMortem();
}

function gestisciObbligatorietaMorteAnteMacellazione(){

	var dataMorteAnteMacellazione;
	var luogoMorteAnteMacellazione;
	var causaMorteAnteMacellazione;
	
	dataMorteAnteMacellazione = document.getElementById('mavam_data').value != '';
	luogoMorteAnteMacellazione = document.getElementById('mavam_luogo').selectedIndex > 0;
	causaMorteAnteMacellazione = trim( document.getElementById('mavam_motivo').value ) != '';
	
	if(dataMorteAnteMacellazione || luogoMorteAnteMacellazione || causaMorteAnteMacellazione){
		document.getElementById('dataMorteAnteMacellazione').style.display = '';
		document.getElementById('luogoMorteAnteMacellazione').style.display = '';
		document.getElementById('causaMorteAnteMacellazione').style.display = '';
		if(luogoMorteAnteMacellazione)
		{
			document.getElementById('mavam_num_capi_ovini_asterisco').style.display = '';
			document.getElementById('mavam_num_capi_caprini_asterisco').style.display = '';
		}
	}
	else{
		document.getElementById('dataMorteAnteMacellazione').style.display = 'none';
		document.getElementById('luogoMorteAnteMacellazione').style.display = 'none';
		document.getElementById('causaMorteAnteMacellazione').style.display = 'none';
		document.getElementById('mavam_num_capi_ovini_asterisco').style.display = 'none';
		document.getElementById('mavam_num_capi_caprini_asterisco').style.display = 'none';
	}
	
}

function gestisciObbligatorietaVisitaAnteMortem(){

	var dataVisitaAnteMortem;
	var dataVisitaPostMortem;
	var provvedimentoVisitaAnteMortem;
	var numCapiOvini="";
	var numCapiCaprini="";
	
	dataVisitaAnteMortem = document.getElementById('vam_data').value != '';
	dataVisitaPostMortem = document.getElementById('vpm_data').value != '';
	provvedimentoVisitaAnteMortem = document.getElementById('vam_provvedimenti').selectedIndex > 0;
	if(document.getElementById('vam_num_capi_ovini')!=null)
		numCapiOvini=document.getElementById('vam_num_capi_ovini').value;
	if(document.getElementById('vam_num_capi_caprini')!=null)
		numCapiCaprini=document.getElementById('vam_num_capi_caprini').value;
	
	if(dataVisitaAnteMortem || provvedimentoVisitaAnteMortem || numCapiOvini!='' || numCapiCaprini!=''){
		document.getElementById('dataVisitaAnteMortem').style.display = '';
		document.getElementById('dataVisitaPostMortem').style.display = '';
		document.getElementById('provvedimentoVisitaAnteMortem').style.display = '';
		document.getElementById('vam_num_capi_ovini_asterisco').style.display = '';
		document.getElementById('vam_num_capi_caprini_asterisco').style.display = '';
	}
	else{
		document.getElementById('dataVisitaAnteMortem').style.display = 'none';
		document.getElementById('dataVisitaPostMortem').style.display = 'none';
		document.getElementById('destinatarioCarni1').style.display = 'none';
		document.getElementById('provvedimentoVisitaAnteMortem').style.display = 'none';
		document.getElementById('vam_num_capi_ovini_asterisco').style.display = 'none';
		document.getElementById('vam_num_capi_caprini_asterisco').style.display = 'none';
	}
	
	
	
}

function gestisciObbligatorietaVisitaPostMortem(){

	var dataVisitaPostMortem;
	var destinatarioVisitaPostMortem;
	
	dataVisitaPostMortem = document.getElementById('vpm_data').value != '';
	destinatarioVisitaPostMortem = trim(document.getElementById('destinatario_1_nome').value).length > 0;
	
	if(dataVisitaPostMortem || destinatarioVisitaPostMortem){
		document.getElementById('dataVisitaPostMortem').style.display = '';
		//document.getElementById('destinatarioCarni1').style.display = '';
		//document.getElementById('destinatarioCarni2').style.display = '';
	}
	else{
		document.getElementById('dataVisitaPostMortem').style.display = 'none';
		document.getElementById('destinatarioCarni1').style.display = 'none';
		//document.getElementById('destinatarioCarni2').style.display = 'none';
	}
	
	
}


function gestisciTabellaNonConformitaVam(){
	if( document.forms[0].vam_esito[2].checked ){ //se � "non favorevole"
		document.getElementById('vam_tabella_non_conformita').style.display='';
	}
	else{ // se � "favorevole" o "favorevole con riserva"
		document.getElementById('vam_tabella_non_conformita').style.display='none';
	}
}

function mostraLcsoPatologiaAltro(select,index){

	var ALTRO = 5;
	if(select.value == ALTRO){
		document.getElementById('lcso_patologiaaltro_' + index).style.display='';
	}
	else{
		document.getElementById('lcso_patologiaaltro_' + index).style.display='none';
		document.getElementById('lcso_patologiaaltro_' + index).value = '';
	}
}

function impostaDestinatarioMacelloCorrente(index){
	document.getElementById('destinatario_' + index + '_id').value = document.getElementById('id_macello').value;
	document.getElementById('destinatario_' + index + '_nome').value = "<%=OrgDetails.getName().replaceAll("\"","'")%>";
	document.getElementById('destinatario_label_' + index).innerHTML = "<%=OrgDetails.getName().replaceAll("\"","'")%>";
		
	document.getElementById('esercenteNoGisa' + index).style.display = 'none';
}

</script>

<script type="text/javascript">

function showHide(_action) {
	var _myTableObj = document.getElementById('tableID1');
    if (_action == 'show') {
        _myTableObj.style.display = 'block';
    }
    
    if (_action == 'hide') {
        _myTableObj.style.display = 'none';
        //_myObj.parentNode.innerHTML = '<a href="#" onclick="showHide(this,\'show\');">Show Table</a>';      
    }
}
//-->
</script>


<style type="text/css">
	
/* Vertical Tabs
----------------------------------*/
.ui-tabs-vertical { /*width: 55em; */}
.ui-tabs-vertical .ui-tabs-nav { padding: .2em .1em .2em .2em; float: left; width: 12em; }
.ui-tabs-vertical .ui-tabs-nav li { clear: left; width: 100%; border-bottom-width: 1px !important; border-right-width: 0 !important; margin: 0 -1px .2em 0; }
.ui-tabs-vertical .ui-tabs-nav li a { display:block; }
.ui-tabs-vertical .ui-tabs-nav li.ui-tabs-selected { padding-bottom: 0; padding-right: .1em; border-right-width: 1px; border-right-width: 1px; }
.ui-tabs-vertical .ui-tabs-panel { padding: 1em; float: left; width: 50em;}

</style>

<body onbeforeunload="return gestisciUnload();" onload="displayVPMpatologie(),displayLCSO(),resetSelect();displayNumCapiEsito();gestisciUtenteVeterinario();contralla_cd_bse();displayAbbattimento(); mostraDestinazione();gestisciTabellaNonConformitaVam();">
<table class="trails" cellspacing="0">
	<tr>
		<td>
			<a href="OpuStab.do"><dhv:label name="stabilimenti.stabilimenti">Accounts</dhv:label></a> >
			<%
				if (request.getParameter("return") == null) {
			%>
					<a href="OpuStab.do?command=Search"><dhv:label
					name="stabilimenti.SearchResults">Search Results</dhv:label></a> >
					<a href="OpuStab.do?command=Details&altId=<%=OrgDetails.getAltId()%>">Scheda Stabilimento</a> >
			<%
						} else if (request.getParameter("return").equals("dashboard")) {
					%>
					<a href="OpuStab.do?command=Dashboard"><dhv:label
					name="communications.campaign.Dashboard">Dashboard</dhv:label></a> > <%
						}
					%>
			<a href="MacellazioniNewOpu.do?command=List&altId=<%=OrgDetails.getAltId()%>">Macellazioni</a> > Aggiungi Seduta
		</td>
	</tr>
</table>
<%@page import="java.text.SimpleDateFormat"%>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio"%>
<%@page import="org.aspcfs.modules.macellazioninewopu.utils.MacelliUtil"%>
<%
	String param1 = "altId=" + OrgDetails.getAltId()+"&stabId=" + OrgDetails.getIdStabilimento(); request.setAttribute("Operatore",OrgDetails.getOperatore());
%>

<% HashMap<String,ArrayList<Contact>> listaVeterinari = (HashMap<String,ArrayList<Contact>>)request.getAttribute("listaVeterinari"); %>

<%@page import="org.aspcfs.utils.DateUtils"%>

<%@page import="org.aspcfs.modules.macellazioninewopu.base.NonConformita"%>
<%@page import="org.aspcfs.modules.macellazioninewopu.base.PatologiaRilevata"%>
<%@page import="org.aspcfs.utils.web.LookupList"%>
<%@page import="org.aspcfs.modules.macellazioninewopu.base.Casl_Non_Conformita_Rilevata"%>
<%@page import="org.aspcfs.modules.macellazioninewopu.base.ProvvedimentiCASL"%>
<%@page import="org.aspcfs.modules.macellazioninewopu.base.Organi"%>
<%@page import="org.aspcfs.modules.contacts.base.Contact"%>
<%@page import="java.util.Date"%>

<%@page import="org.aspcfs.modules.util.imports.ApplicationProperties"%>

<dhv:container 
	name="suapmacelli"
	selected="macellazioni" 
	object="Operatore"  
	param="<%=param1 %>" 
	appendToUrl='<%= addLinkParams(request, "popup|popupType|actionId") %>' 
	>

<font color="red"><%=toHtmlValue((String) request.getAttribute("messaggio"))%></font><br/><br/>
<form name="main" action="MacellazioniNewOpu.do?command=RiprendiPartita" method="post" onsubmit="return controllaForm( false );" >
<input type="hidden" id="altId" name="altId" value="<%=OrgDetails.getAltId()%>" />
<input type="hidden" id="id_macello" name="id_macello" value="<%=OrgDetails.getAltId()%>" />
<input type="hidden" name="id" value="<%=Partita.getId() %>" />
<input type="hidden" name="id_partita" value="<%=Partita.getId() %>" />
<input type="hidden" id="solo_cd" name="solo_cd" value="<%= Partita.isSolo_cd() ? "true" : "false" %>" />
<input type="hidden" id="manca_BSE_Nmesi" name="manca_BSE_Nmesi" value="no" />
<input type="hidden" id="submitOK" name="submitOK" value="no" />
<input type="hidden" id="updateLiberoConsumo" name="updateLiberoConsumo" value="<%=update %>" />
<input type="hidden" id="numCapiPartita_AltreSedute" name="numCapiPartita_AltreSedute" value="<%=(String)request.getAttribute("numCapiPartita_AltreSedute")%>" />
<input type="hidden" id="numCapiOviniDestPartita_AltreSedute" name="numCapiOviniDestPartita_AltreSedute" value="<%=(String)request.getAttribute("numCapiOviniDestPartita_AltreSedute")%>" />
<input type="hidden" id="numCapiCapriniDestPartita_AltreSedute" name="numCapiCapriniDestPartita_AltreSedute" value="<%=(String)request.getAttribute("numCapiCapriniDestPartita_AltreSedute")%>" />
<input type="hidden" id="numCapiOviniMavamPartita_AltreSedute" name="numCapiOviniMavamPartita_AltreSedute" value="<%=(String)request.getAttribute("numCapiOviniMavamPartita_AltreSedute")%>" />
<input type="hidden" id="numCapiCapriniMavamPartita_AltreSedute" name="numCapiCapriniMavamPartita_AltreSedute" value="<%=(String)request.getAttribute("numCapiCapriniMavamPartita_AltreSedute")%>" />
<input type="hidden" id="numCapiOviniPartita_AltreSedute" name="numCapiOviniPartita_AltreSedute" value="<%=(String)request.getAttribute("numCapiOviniPartita_AltreSedute")%>" />
<input type="hidden" id="numCapiCapriniPartita_AltreSedute" name="numCapiCapriniPartita_AltreSedute" value="<%=(String)request.getAttribute("numCapiCapriniPartita_AltreSedute")%>" />
<input type="hidden" id="casl_num_capi_ovini"   name="casl_num_capi_ovini" value="<%=toHtmlValue(Partita.getCasl_num_capi_ovini()) %>" />
<input type="hidden" id="casl_num_capi_caprini" name="casl_num_capi_caprini" value="<%=toHtmlValue(Partita.getCasl_num_capi_caprini()) %>" />

<div class="demo">


<!-- NON CANCELLARE QUESTA RIGA -->
<a id="tab_test_bse"></a> 

<div id="tabs">
	<ul>
		<li id="li-1" ><a href="#tabs-1" onclick="javascript:showHide('hide');" >Controllo Documentale</a></li>
<!--		<li id="tab_test_bse"><a href="#tabs-14" >Test BSE</a></li> 	-->
		<li id="li-7" style="display: <%= update ? "" : "none" %>;" ><a href="#tabs-7" onclick="javascript:showHide('hide');settaSoloCD('false');" >Comunicazioni Esterne</a></li>
        <%-- <li><a href="#tabs-5">Respingimento</a></li> --%>
		<%-- li><a href="#tabs-6">Blocco Animale</a></li --%>
		<li id="li-4" style="display: <%= update ? "" : "none" %>;" ><a href="#tabs-4" onclick="javascript:showHide('hide');settaSoloCD('false');" >Morte Ant.Macellazione</a></li>
		<li id="li-2" style="display: <%= update ? "" : "none" %>;" ><a href="#tabs-2" onclick="javascript:showHide('hide');settaSoloCD('false');" >Evidenza Visita AM</a></li>
        <li id="li-3" style="display: <%= update ? "" : "none" %>;" ><a href="#tabs-3" onclick="javascript:showHide('show');settaSoloCD('false');" >Evidenza Visita PM</a></li>
        <%--<li><a href="#tabs-9">Macellazione e Distruz. Carcassa</a></li> --%>
		<%-- <li><a href="#tabs-15">Ricezione Esito Accertamenti</a></li> --%>
	</ul>
<div id="tabs-1">
<table width="100%" border="0" cellpadding="2" cellspacing="2">
    <tbody> 
    <tr>
        <td valign="top" width="55%">
        
        <table class="details" width="100%" border="0" cellpadding="4" cellspacing="0">
            <tbody>
            
            <tr>
                <th colspan="2"><strong>Provenienza animale</strong></th>
            </tr>

            

           <%-- <tr class="containerBody">

            	<td class="formLabel">Speditore</td>
            	<% if(Partita.getCd_id_speditore() <= 0){ %>
            	<td>
            		<textarea id = "cd_dati_speditore" name = "cd_dati_speditore" style="width: 401px; height: 132px;" readonly="readonly"></textarea><font color="red"> * </font>
            		<a href="javascript:popLookupSelectorCustomSpeditore('11');"><dhv:label name="">Seleziona Speditore</dhv:label></a>
            		<input type ="hidden" id="cd_id_speditore" name="cd_id_speditore" value="" />
            	</td> 
            	<% } else { %>
            	<td>
            			<%
	            		String asl = null;
	            		if(Speditore.getSiteId() != -1){
	            			System.out.println("IF: " + Speditore.getSiteId());
	            			asl = ASL.getSelectedValue( Speditore.getSiteId() );
	            		}
	            		%>
            		<textarea id = "cd_dati_speditore" name = "cd_dati_speditore" style="width: 401px; height: 132px;" 
            		readonly="readonly">DENOMINAZIONE: <%= Speditore.getName() + "\n"%>CODICE AZIENDA: <%= Speditore.getAccountNumber() + "\n"%>PROPRIETARIO: <%= Speditore.getNomeRappresentante() + "\n"%>ASL: <%= asl != null && !asl.equals("")? asl + "\n" : "N.D." + "\n"%>STATO: <%= SpeditoreAddress.getCountry() != null && !SpeditoreAddress.getCountry().equals("") ? SpeditoreAddress.getCountry() + "\n" : "N.D." + "\n"%>PROVINCIA: <%= SpeditoreAddress.getState() != null && !SpeditoreAddress.getState().equals("") ? SpeditoreAddress.getState() + "\n" : "N.D." + "\n"%>COMUNE: <%= SpeditoreAddress.getCity() != null && !SpeditoreAddress.getCity().equals("") ? SpeditoreAddress.getCity() + "\n" : "N.D." + "\n"%></textarea><font color="red"> * </font>
            		<a href="javascript:popLookupSelectorCustomSpeditore('11');"><dhv:label name="">Seleziona Speditore</dhv:label></a>
            		<input type ="hidden" id="cd_id_speditore" name="cd_id_speditore" value="<%=toHtmlValue( Partita.getCd_id_speditore())%>" />
            	</td>
            	<% } %>

            </tr--> --%>

         

            <tr class="containerBody">
            	<td class="formLabel">Codice Azienda di provenienza</td>
            	 <td>
            	 	<%=toHtmlValue( Partita.getCd_codice_azienda_provenienza() ) %>
                	<input type="hidden" name="cd_codice_azienda_provenienza" value="<%=toHtmlValue( Partita.getCd_codice_azienda_provenienza() ) %>" />
				</td>
            </tr>
            
            <tr>
                <th colspan="2"><strong>Animale</strong>                </th>
            </tr>
            
            <tr class="containerBody">
                <td class="formLabel" >partita</td>
                <td>
                	<%=Partita.getCd_partita()%>
                </td>
            </tr>
            
            <tr class="containerBody">
            	<td class="formLabel">Commerciante/Proprietario degli animali</td>
            	 <td>
            	 	<%=toHtmlValue( Partita.getProprietario() ) %>
                	<input type="hidden" name="proprietario" value="<%=toHtmlValue( Partita.getProprietario() ) %>" />
				</td>
            </tr>
            
            <tr class="containerBody" >
                <td class="formLabel" >Codice Azienda di Nascita</td>
                <td>
                	<%=Partita.getCd_codice_azienda() %>&nbsp;
				</td>
            </tr>
            
            
            
            <tr class="containerBody">
                <td class="formLabel" >Specie<br></td>
                
                <input type="hidden" id="Specie1" name="Specie1" value="Ovini"/>
                <input type="hidden" id="Specie2" name="Specie2" value="Caprini"/>
                <input type="hidden" id="categoriaPartitaOvicaprini" name="categoriaPartita" value="1" <%= (!Partita.isSpecie_suina() ? "checked" : "") %> /> 
                <input type="hidden" id="categoriaPartitaSuini" name="categoriaPartita" value="2" <%= (Partita.isSpecie_suina() ? "checked" : "") %>/>
                <input type="hidden" id="specie_suina" name="specie_suina" value="<%=(Partita.isSpecie_suina() ? "true" : "false") %>"/>
                 
                 
                <td>
<%
                	if(Partita.getCd_num_capi_ovini()>0)
                		out.println(" <label class=\"specie1\">Ovini</label>");	
					if(Partita.getCd_num_capi_caprini()>0)
					{
						if(Partita.getCd_num_capi_ovini()>0)
							out.println(", ");
						out.println(" <label class=\"specie2\">Caprini</label>");
					}
%>
				</td>
            </tr>
            
            <tr class="containerBody">
                <td class="formLabel" >numero capi  <label class="specie1">Ovini</label></td>
                <td>
<%
                	String num_capi_ovini = "";
                	if(Partita.getCd_num_capi_ovini()>0)
                		num_capi_ovini = Partita.getCd_num_capi_ovini()+"";
                	out.println(num_capi_ovini);
%>
				<input type="hidden" name="cd_num_capi_ovini" id="cd_num_capi_ovini" value="<%=num_capi_ovini%>">
                </td>
            </tr>
            
            <tr class="containerBody">
                <td class="formLabel" >numero capi  <label class="specie2">Caprini</label></td>
                <td>
<%
                	String num_capi_caprini = "";
                	if(Partita.getCd_num_capi_caprini()>0)
                		num_capi_caprini = Partita.getCd_num_capi_caprini()+"";
                	out.println(num_capi_caprini);
%>
                <input type="hidden" name="cd_num_capi_caprini" id="cd_num_capi_caprini" value="<%=num_capi_caprini%>">
                </td>
            </tr>
            
            <tr class="containerBody">
                <td class="formLabel" nowrap="nowrap">Dettagli Partita</td>
                <td>
<%
                	for( CategoriaRischio cat: (ArrayList<CategoriaRischio>)Categorie)
                	{
                		if(cat.getId_categoria()==0)
                			out.println("0 [Default]<br/>");
                		else if(cat.getId_categoria()==1)
                			out.println("1 [Presenza animali di et&agrave; &gt; 18 mesi]<br/>");
                		else if(cat.getId_categoria()==2)
                			out.println("2 [MAC. DIFFERITA IN CASO DI BRUC.]<br/>");
                		
					} 
%>
                	<%=(Categorie.size() > 0) ? ("") : ("&nbsp;") %>
				</td> 
            </tr>
            
            <tr class="containerBody">
              <td class="formLabel" >Vincolo sanitario</td>

              <td valign="middle">
              	<%=Partita.isCd_vincolo_sanitario() ? "SI" : "NO" %>
                <%
                	String motivo = Partita.getCd_vincolo_sanitario_motivo();
                	if(motivo != null && !motivo.trim().equals("")){
                %>
                Motivo: <%= motivo %>
                <%		
                	}
                %>
              </td>
            </tr>
            
            <tr class="containerBody">
                <td class="formLabel" nowrap="nowrap">Numero Mod. 4</td>
                <td>
                	<%=Partita.getCd_mod4() %>&nbsp;
				</td>
            </tr>
            
			<tr class="containerBody">
              <td class="formLabel" nowrap="nowrap">Data Mod. 4</td>
              <td>
              		<zeroio:tz timestamp="<%=Partita.getCd_data_mod4()%>" showTimeZone="false" dateOnly="true" />&nbsp;
              </td>
            </tr>
            
            <tr class="containerBody">
              <td class="formLabel" >Macell. differita piani risanamento</td>
              <td>
              <%
              if(Partita.getCd_macellazione_differita() > 0 )
              {
              %>
              	<%=PianiRisanamento.getSelectedValue( Partita.getCd_macellazione_differita() ) %>&nbsp;
              	<%if( Partita.getCd_macellazione_differita() > 0 && ( Partita.getVpm_data() != null || Partita.getMavam_data() != null ) ){ %>
              		<br/>
              	<%}} %>
              </td>
            </tr>
            
            <tr class="containerBody">
              <td class="formLabel" nowrap="nowrap">Partita sottoposta a test TSE</td>
              <td>
              	<%=( Partita.getCd_bse() ) ? ("SI, " ) : ( "NO" ) %>
<%
                	num_capi_ovini = "";
                	if(Partita.getCd_num_capi_ovini_da_testare()>0)
	                	out.println("<br/>numero capi  <label class=\"specie1\">Ovini</label> da testare: " + Partita.getCd_num_capi_ovini_da_testare());
                	num_capi_caprini = "";
                	if(Partita.getCd_num_capi_caprini_da_testare()>0)
	                	out.println("<br/>numero capi  <label class=\"specie1\">Caprini</label> da testare: " + Partita.getCd_num_capi_caprini_da_testare());
%>
              </td>
            </tr>
            
            <tr class="containerBody">
              <td class="formLabel">Disponibili informazioni catena alimentare </td>
              <td><%=Partita.isCd_info_catena_alimentare() ? "SI" : "NO" %></td>
            </tr>
            
			<tr class="containerBody">
                <td class="formLabel">Data arrivo al macello</td>
                <td><zeroio:tz timestamp="<%=Partita.getCd_data_arrivo_macello() %>" showTimeZone="false" dateOnly="true" /> </td>
            </tr>
            
             <tr class="containerBody">
              <td class="formLabel">Data di arrivo dichiarata dal Gestore </td>
              <td><%=Partita.isCd_data_arrivo_macello_flag_dichiarata() ? "SI" : "NO" %></td>
            </tr>
            
            <tr>
                <th colspan="2"><strong>Identificazione Mezzo di Trasporto</strong></th>
            </tr>
            
            <tr class="containerBody" >
                <td class="formLabel" >Tipo</td>
                <td>
                	<%=Partita.getCd_tipo_mezzo_trasporto() != null ? Partita.getCd_tipo_mezzo_trasporto() : "" %>&nbsp;
				</td>
            </tr>
            
            <tr class="containerBody" >
                <td class="formLabel" >Targa</td>
                <td>
                	<%=Partita.getCd_targa_mezzo_trasporto() != null ? Partita.getCd_targa_mezzo_trasporto() : ""%>&nbsp;
				</td>
            </tr>
            
            <tr class="containerBody">
              	<td class="formLabel">Trasporto superiore<br>a 8 ore</td>
              	<td><%=Partita.isCd_trasporto_superiore8ore() ? "SI" : "NO" %></td>
            </tr>
            
<!--            -->

		<tbody id="sezioneTESTBSE">
            <tr>

              <th colspan="2"><strong>Partita sottoposta a test TSE</strong></th>
            </tr>

             <tr class="containerBody">
                <td class="formLabel">Data Prelievo</td>
                <td><zeroio:tz timestamp="<%=Partita.getBse_data_prelievo() %>" showTimeZone="false" dateOnly="true" /> </td>
            </tr>
                
             <tr class="containerBody">
                <td class="formLabel">Data Ricezione Esito</td>
                                                          <td><%=toDateasString(Partita.getBse_data_ricezione_esito()) %>&nbsp; </td>
            </tr>
            
            <tr class="containerBody">
                <td class="formLabel">Esito</td>
                <td>
<%
				if(Partita.getCd_num_capi_ovini_da_testare()>0 || Partita.getCd_num_capi_caprini_da_testare()>0)
				{
					if(Partita.getBse_esito()==null || Partita.getBse_esito().equals("-1"))
						out.println("In attesa di esito");
					else
						out.println(Partita.getBse_esito());
				}
%>                
                </td>
             </tr>
            
			<tr class="containerBody">
                <td class="formLabel">Note</td>
                <td><%=Partita.getBse_note() %></td>
            </tr>
        </tbody>


<!--            -->
            
             <tr>
                <th colspan="2"><strong>Veterinari addetti al controllo </strong>                </th>
            </tr>
              <tr class="containerBody">
                <td class="formLabel" rowspan="3">&nbsp; </td>
                <td>&nbsp;1. <%=Partita.getCd_veterinario_1() %></td>
            </tr>
            
            <tr class="containerBody">
                <td>&nbsp;2. <%=Partita.getCd_veterinario_2() %></td>
            </tr>
            <tr class="containerBody">
                <td>&nbsp;3. <%=Partita.getCd_veterinario_3() %></td>
            </tr>
            
            <tr>
                <th colspan="2"><strong>Dettagli addizionali</strong>                </th>
            </tr>
            
            <tr class="containerBody">
                <td class="formLabel" >Note</td>
                <td>
                	<%=Partita.getCd_note() != null ? Partita.getCd_note() : ""%>&nbsp;
                </td>
            </tr>        
      </tbody></table>        
      </td>

	</tr>
	</tbody>
</table>

<%
	ConfigTipo configTipo = (ConfigTipo)request.getSession().getAttribute("configTipo");
%>
	<input id="liberoConsumoButton" type="button" value="Libero Consumo >>" onclick="if(controllaForm( true )){document.main.action='MacellazioniNewOpu.do?command=ToLiberoConsumoSeduta&idPartita=<%=Partita.getId()%>';settaSoloCD('false');document.main.submit();};" />

	<%-- <%	if (update) { %> --%>
		<script type="text/javascript">nascondi_liberoConsumoButton(false)</script>
	<%-- <% } else { %>
		<script type="text/javascript">nascondi_liberoConsumoButton(false)</script>
	<% } %> --%>
	
	<%if(!update){ %>
<!--	<div style="text-align: center; margin-top: 20px;">-->
	<input type="button" value="Altre operazioni" onclick="checkControlloDocumentale();" />
<!--	</div>-->
	<%} %>


</div>
	
<div id="tabs-2">
<table width="100%" border="0" cellpadding="2" cellspacing="2">
    <tbody><tr>
        <td valign="top" width="55%">



				<table width="100%" border="0" cellpadding="2" cellspacing="2">
    <tbody><tr>
        <td valign="top" width="100%"><table class="details" width="100%" border="0" cellpadding="4" cellspacing="0">
          <tbody>
          
           <tr>
              <th colspan="2"><strong>Animale</strong></th>
            </tr>
            

            <tr>
                <td style="background-color:yellow;text-align: right" nowrap="nowrap">Partita</td>
                <td style="background-color:yellow;">
                	<%=toHtmlValue( Partita.getCd_partita() ) %>
                </td>
            </tr>
            
           
            <tr class="containerBody" >
                <td class="formLabel" nowrap="nowrap">Specie<br></td>
                <td>
<%
                	if(Partita.getCd_num_capi_ovini()>0)
                		out.println(" <label class=\"specie1\">Ovini</label>");	
					if(Partita.getCd_num_capi_caprini()>0)
					{
						if(Partita.getCd_num_capi_ovini()>0)
							out.println(", ");
						out.println(" <label class=\"specie2\">Caprini</label>");
					}
%>
				</td>
            </tr>
            
            <tr class="containerBody">
                <td class="formLabel" >Numero Capi  <label class="specie1">Ovini</label><br/>Controllo documentale</td>
                <td>
                	<%=Partita.getCd_num_capi_ovini()%>
                </td>
            </tr>
            <tr class="containerBody">
                <td class="formLabel" >Numero Capi  <label class="specie2">Caprini</label><br/>Controllo documentale</td>
                <td>
                	<%=Partita.getCd_num_capi_caprini()%>
                </td>
            </tr>
            <tr class="containerBody">
                <td class="formLabel" >Numero Capi  <label class="specie1">Ovini</label><br/>Morte Ant.Macellazione</td>
                <td>
                	<%=Partita.getMavam_num_capi_ovini()%>
                </td>
            </tr>
            <tr class="containerBody">
                <td class="formLabel" >Numero Capi  <label class="specie2">Caprini</label><br/>Morte Ant.Macellazione</td>
                <td>
                	<%=Partita.getMavam_num_capi_caprini()%>
                </td>
            </tr>
            
            <tr>
              <th colspan="2"><strong>Visita Ante Mortem </strong></th>
            </tr>

            <tr class="containerBody">
              <td class="formLabel" >Data</td>
              <td>
<%--               	<zeroio:dateSelect field="vam_data" form="main" showTimeZone="false" timestamp="<%=Partita.getVam_data() %>" /> --%>
					<input readonly type="text" id="vam_data" name="vam_data" onfocus="riportaDataArrivoMacello(this);gestisciObbligatorietaVisitaAnteMortem();" size="10" value="" />&nbsp;  
			        <font color="red" id="dataVisitaAnteMortem" style="display: none;">*</font>
			        <a href="#" onClick="cal19.select(document.forms[0].vam_data,'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19">
			 		<img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
			 		<a href="#" style="cursor: pointer;" onclick="svuotaData(document.forms[0].vam_data);"><img src="images/delete.gif" align="absmiddle"/></a>
              </td>
            </tr>
           
            <tr class="containerBody">
                <td class="formLabel">Esito</td>
                <td>
						<input 
							type=radio 
							onclick="if(this.checked==true) document.getElementById('vam_tabella_non_conformita').style.display='none';gestisciObbligatorietaVisitaAnteMortem();" 
							id= "vam_esito" 
							name="vam_esito" 
							value="Favorevole" 
							 >Favorevole<br/>
						<input 
							type=radio 
							onclick="if(this.checked==true) document.getElementById('vam_tabella_non_conformita').style.display='none';gestisciObbligatorietaVisitaAnteMortem();"
							id= "vam_esito" 
							name="vam_esito" 
							value="Favorevole con riserva"
							>Favorevole con riserva<br/>
						<input 
							type=radio 
							onclick="if(this.checked==true) document.getElementById('vam_tabella_non_conformita').style.display='';document.getElementById('nc_tipo_1').value = -1;document.getElementById('nc_tipo_2').value = -1;document.getElementById('nc_tipo_3').value = -1;gestisciObbligatorietaVisitaAnteMortem();" 
							id= "vam_esito" 
							name="vam_esito" 
							value="Non Favorevole"
							>Non favorevole 
						
							
							<p>
							</p>
				</td>               
            </tr>
			<tr class="containerBody">
            	<td class="formLabel">Numero Capi <label class="specie1">Ovini</label></td>
                <td>
<%
				num_capi_ovini = "";
// 				if(Partita.getVam_num_capi_ovini()>0)
// 					num_capi_ovini = Partita.getVam_num_capi_ovini()+"";
%>
                	<input type="text" <% if(Partita.getCd_num_capi_ovini()<=0){out.println("disabled=\"disabled\"");} %> id="vam_num_capi_ovini" name="vam_num_capi_ovini" onblur="gestisciObbligatorietaVisitaAnteMortem()" onchange="isIntPositivo(this.value,'Numero Capi Ovini',this);" value="<%=toHtmlValue(num_capi_ovini) %>" />
                	<font id="vam_num_capi_ovini_asterisco" align="center" style="display:none;" color="red" >*</font>
                </td>
            </tr>
            
            <tr class="containerBody">
            	<td class="formLabel">Numero Capi <label class="specie2">Caprini</label></td>
                <td>
<%
				num_capi_caprini = "";
// 				if(Partita.getVam_num_capi_caprini()>0)
// 					num_capi_caprini = Partita.getVam_num_capi_caprini()+"";
%>
                	<input type="text" <% if(Partita.getCd_num_capi_caprini()<=0){out.println("disabled=\"disabled\"");} %> id="vam_num_capi_caprini" name="vam_num_capi_caprini" onblur="gestisciObbligatorietaVisitaAnteMortem()" onchange="isIntPositivo(this.value,'Numero Capi Caprini',this);" value="<%=toHtmlValue(num_capi_caprini) %>" />
                	<font style="display:none;" id="vam_num_capi_caprini_asterisco" align="center"  color="red" >*</font>
                </td>
            </tr>
            
            <tr class="containerBody">
                <td class="formLabel">Provvedimento adottato</td>
                <td>
					<%
						ProvvedimentiVAM.setJsEvent("onChange=\"javascript:displayAbbattimento();gestisciObbligatorietaVisitaAnteMortem();\"");
					%>                               
                	
	               	<%=ProvvedimentiVAM.getHtmlSelect( "vam_provvedimenti", "" ) %>
	               	<font color="red" id="provvedimentoVisitaAnteMortem" style="display: none;">*</font>
                </td>
            </tr>
            
            
            <tr class="containerBody">
            	<td class="formLabel">Comunicazione a</td>
            	<td>
            		<input 
            			type="checkbox" 
            			id="vam_to_asl_origine"
            			name="vam_to_asl_origine" 
            			/> ASL origine <br/>
            		<input 
            			type="checkbox" 
            			id="vam_to_proprietario_animale"
            			name="vam_to_proprietario_animale" 
            			/> Proprietario animale <br/>
            		<input 
            			type="checkbox" 
            			id="vam_to_azienda_origine"
            			name="vam_to_azienda_origine" 
            			/> Azienda di origine <br/>
            		<input 
            			type="checkbox" 
            			id="vam_to_proprietario_macello"
            			name="vam_to_proprietario_macello" 
            			/> Proprietario macello <br/>
            		<input 
            			type="checkbox" 
            			id="vam_to_pif"
            			name="vam_to_pif" 
            			/> P.I.F. <br/>	
            		<input 
            			type="checkbox" 
            			id="vam_to_uvac"
            			name="vam_to_uvac" 
            			/> U.V.A.C. <br/>	
            		<input 
            			type="checkbox" 
            			id="vam_to_regione"
            			name="vam_to_regione" 
            			/> Regione <br/>
            		<input 
            			type="checkbox"
            			id="vam_to_altro" 
            			name="vam_to_altro" 
            			onclick="visualizzaTextareaVamToAltro();"
            			/> Altro <br/>
            		<textarea id="vam_to_altro_testo" name="vam_to_altro_testo" rows="2" cols="40" style="display: <%=(Partita.isVam_to_altro()) ? "''" : "none" %>;" ><%=toHtmlValue( Partita.getVam_to_altro_testo() ) %></textarea>
            			
            	</td>
            </tr>
            
              <tr class="containerBody">
		 		<td class="formLabel">Note</td>
		 		<td><textarea rows="2" cols="40" name="vam_provvedimenti_note"></textarea></td>
			  </tr>
            
                 </table>
                </td>

    </tr>
     
    <tr id="vam_tabella_non_conformita" <%=(update && !Partita.getVam_esito().equalsIgnoreCase("Favorevole")) ? ("") : ("style=\"display: none;\"") %> >
    	<td>
    		<table  class="details" width="100%" border="0" cellpadding="4" cellspacing="0">
    			<tr>
    				<th colspan="2">Non Conformit�</th>
    			</tr>
    			<tr>
    				<th>Tipo</th> <th>Note</th>
    			</tr>
    			<tr class="containerBody">
    				<td>
    					<%
    						int non_conformita_index	= -1;
							int non_conformita_id		= -1;
    						String non_conformita_note	= "";
    						
    						if( NCVAM.size() > 0 )
    						{
    							non_conformita_index	= ( (NonConformita)NCVAM.get( 0 ) ).getId_tipo();
    							non_conformita_note		= ( (NonConformita)NCVAM.get( 0 ) ).getNote();
    							non_conformita_id		= ( (NonConformita)NCVAM.get( 0 ) ).getId();
    						}
    						else
    						{
    							non_conformita_index	= -1;
    							non_conformita_id		= -1;
    							non_conformita_note		= "";
    						}
    					%>
    					<%=TipiNonConformita_Gruppo.getHtmlSelect( "nc_tipo_1", non_conformita_index )%>
    					<input type="hidden" name="nc_id_1" value="<%=non_conformita_id %>" />
    				</td>

    				<td><textarea name="nc_note_1" rows="2" cols="25" ></textarea> </td>
    				
    			</tr>
    			<tr class="containerBody">
    				<td>
    					<%
	    					if( NCVAM.size() > 1 )
							{
								non_conformita_index	= ( (NonConformita)NCVAM.get( 1 ) ).getId_tipo();
								non_conformita_note		= ( (NonConformita)NCVAM.get( 1 ) ).getNote();
    							non_conformita_id		= ( (NonConformita)NCVAM.get( 1 ) ).getId();
    						}
    						else
    						{
    							non_conformita_index	= -1;
    							non_conformita_id		= -1;
    							non_conformita_note		= "";
    						}
						%>
    					<%=TipiNonConformita_Gruppo.getHtmlSelect( "nc_tipo_2",non_conformita_index )%>
    					<input type="hidden" name="nc_id_2" value="<%=non_conformita_id %>" />
    				</td>

    				<td><textarea name="nc_note_2" rows="2" cols="25" ></textarea> </td>
    				
    			</tr>
    			<tr class="containerBody">
    				<td>
    					<%
	    					if( NCVAM.size() > 2 )
							{
								non_conformita_index	= ( (NonConformita)NCVAM.get( 2 ) ).getId_tipo();
								non_conformita_note		= ( (NonConformita)NCVAM.get( 2 ) ).getNote();
    							non_conformita_id		= ( (NonConformita)NCVAM.get( 2 ) ).getId();
    						}
    						else
    						{
    							non_conformita_index	= -1;
    							non_conformita_id		= -1;
    							non_conformita_note		= "";
    						}
						%>
    					<%=TipiNonConformita_Gruppo.getHtmlSelect( "nc_tipo_3", non_conformita_index )%>
    					<input type="hidden" name="nc_id_3" value="<%=non_conformita_id %>" />
    				</td>

    				<td><textarea name="nc_note_3" rows="2" cols="25" ></textarea> </td>
    				
    			</tr>
    		</table>
    	</td>
    </tr>
    
     
    
    </tbody>

</table>
    
      </td>
         
	</tr>

	

</tbody>

	

</table>
	
	
	
	
	
	
	
	
<table id="table_abbattimento" width="100%" border="0" cellpadding="2" cellspacing="2" style="display:none;">
    <tbody><tr>
        <td valign="top" width="55%">
		<table width="100%" border="0" cellpadding="2" cellspacing="2">
    <tbody><tr>

        <td valign="top" width="100%"><table class="details" width="100%" border="0" cellpadding="4" cellspacing="0">
          <tbody>
            <tr>
              <th colspan="2"><strong>Abbattimento</strong></th>
            </tr>
            <tr class="containerBody">
              <td class="formLabel" >Data</td>
              <td>
<%--			<zeroio:dateSelect field="abb_data" form="main" showTimeZone="false" timestamp="<%=Partita.getAbb_data() %>"/>  --%>              
              	<input readonly type="text" id="abb_data" name="abb_data" size="10" value="<%=DateUtils.timestamp2string(Partita.getAbb_data())%>" />&nbsp;  
			    <a href="#" onClick="cal19.select(document.forms[0].abb_data,'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19">
			 	<img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
			 	<a href="#" style="cursor: pointer;" onclick="svuotaData(document.forms[0].abb_data);"><img src="images/delete.gif" align="absmiddle"/></a>
             </td>

            </tr>
     
                <tr class="containerBody">
                <td class="formLabel">Motivo</td>
                <td>
                	<textarea rows="2" cols="40" name="abb_motivo"></textarea>
                </td>
                </tr>
                
             <tr>
                <th colspan="2"><strong>Veterinari addetti al controllo</strong></th>
            </tr>
            
            <tr class="containerBody">
            	<td colspan="2">
		            <table>
		            	<tr class="containerBody">
		                	<td>1. <input 
		                			value=""
		                			onchange="javascript:toggleVetDiv('abb_veterinario')" 
		                			size="25" id="abb_veterinario" 
		                			name="abb_veterinario" 
		                			type="text" />
		                	<% Veterinari.setJsEvent( "onchange=\"set_vet( this, 'abb_veterinario')\"" ); %>
		                	<%=Veterinari.getHtmlSelect( "veterinari_abb", "-1" )%></td>
		                </tr>
			            <tr 
			            	class="containerBody" 
			            	id="abb_veterinario_toggle" 
			            	>
			                <td>2. <input 
		                			value=""
			                		onchange="javascript:toggleVetDiv('abb_veterinario_2')" 
			                		size="25" id="abb_veterinario_2" 
			                		name="abb_veterinario_2" 
			                		type="text" />
			                <%Veterinari.setJsEvent("onchange=\"set_vet( this, 'abb_veterinario_2')\"");%>
			                <%=Veterinari.getHtmlSelect("veterinari_abb2", "-1")%></td>
			            </tr>
			            <tr 
			            	class="containerBody" 
			            	id="abb_veterinario_2_toggle"
			            	>
			                <td>3. <input 
		                			value=""
			                		size="25" 
			                		id="abb_veterinario_3"  
			                		name="abb_veterinario_3" 
			                		type="text" />
			                <%Veterinari.setJsEvent("onchange=\"set_vet( this, 'abb_veterinario_3')\"");%>
							<%=Veterinari.getHtmlSelect("veterinari_abb3", "-1")%></td>
			            </tr>
		            </table>
	            </td>
            </tr>

          </tbody>
        </table>

	</td>
    
        <td valign="top" width="50%"><!-- FILTRI DI RICERCA --></td>
    </tr></tbody></table>
		
</td>

</tr></tbody></table>
	
	
	
	
</div>
	
	
		
<div id="tabs-3">
	<table width="100%" border="0" cellpadding="2" cellspacing="2">
    <tbody><tr>
        <td valign="top" width="55%">
		<table width="100%" border="0" cellpadding="2" cellspacing="2">
    <tbody><tr>
        <td valign="top" width="100%"><table class="details" width="100%" border="0" cellpadding="4" cellspacing="0">
          <tbody>
           <tr>
              <th colspan="2"><strong>Animale</strong></th>
            </tr>
            

            <tr>
                <td style="background-color:yellow;text-align: right" nowrap="nowrap">Partita</td>
                <td style="background-color:yellow;">
                	<%=toHtmlValue( Partita.getCd_partita() ) %>
                </td>
            </tr>
            
           
            <tr class="containerBody" >
                <td class="formLabel" nowrap="nowrap">Specie<br></td>
                <td>
<%
                	if(Partita.getCd_num_capi_ovini()>0)
                		out.println("<label class=\"specie1\">Ovini</label>");	
					if(Partita.getCd_num_capi_caprini()>0)
					{
						if(Partita.getCd_num_capi_ovini()>0)
							out.println(", ");
						out.println("<label class=\"specie2\">Caprini</label>");
					}
%>
				</td>
            </tr>
            
            <tr class="containerBody">
                <td class="formLabel" >Numero Capi <label class="specie1">Ovini</label><br/>Controllo documentale</td>
                <td>
                	<%=Partita.getCd_num_capi_ovini()%>
                </td>
            </tr>
            <tr class="containerBody">
                <td class="formLabel" >Numero Capi <label class="specie2">Caprini</label><br/>Controllo documentale</td>
                <td>
                	<%=Partita.getCd_num_capi_caprini()%>
                </td>
            </tr>
            <tr class="containerBody">
                <td class="formLabel" >Numero Capi <label class="specie1">Ovini</label><br/>Morte Ant.Macellazione</td>
                <td>
                	<%=Partita.getMavam_num_capi_ovini()%>
                </td>
            </tr>
            <tr class="containerBody">
                <td class="formLabel" >Numero Capi <label class="specie2">Caprini</label><br/>Morte Ant.Macellazione</td>
                <td>
                	<%=Partita.getMavam_num_capi_caprini()%>
                </td>
            </tr>
            
            <tr>
              <th colspan="2"><strong>Macellazione</strong></th>
            </tr>
<!--            <tr class="containerBody">-->
<!--              <td class="formLabel" >Progressivo</td>-->
<!--              <td >-->
	              	<input type="hidden" name="mac_progressivo" value="<%=Partita.getMac_progressivo() %>" />
<!--              </td>-->
<!--            </tr>-->
 
            <tr class="containerBody">
              <td class="formLabel" >Tipo</td>
              <td>
              <%
              //TipiMacellazione.setJsEvent("onchange=\"setCategoriaRischio()\"");
              %>
              <%=TipiMacellazione.getHtmlSelect( "mac_tipo", "" ) %></td>
            </tr>
          </tbody>
        </table>
         </td>
        <%-- %>td valign="top" width="50%"><!-- FILTRI DI RICERCA --></td--%>
    </tr></tbody></table>
	</td>
</tr></tbody></table>
	
	<table width="100%" border="0" cellpadding="2" cellspacing="2" id="tab">
    <tbody>
    <tr>
        <td valign="top" width="55%">
        <table width="100%" border="0" cellpadding="2" cellspacing="2">
    <tbody>
    <tr>
        <td valign="top" width="100%"><table class="details" width="100%" border="0" cellpadding="4" cellspacing="0">
          <tbody>
            <tr>
              <th colspan="2"><strong>Visita Post Mortem</strong></th>

            </tr>
            
            <tr class="containerBody">
              <td class="formLabel" >Data Macellazione</td>
              <td>
<%--              	<zeroio:dateSelect field="vpm_data" form="main" showTimeZone="false" timestamp="<%=Partita.getVpm_data() %>" />  --%>
					<input readonly type="text" id="vpm_data" name="vpm_data"  onfocus="riportaDataArrivoMacello(this);gestisciObbligatorietaVisitaPostMortem();" size="10" value="" />&nbsp;  
			        <font color="red" id="dataVisitaPostMortem" style="display: none;">*</font>
			        <a href="#" onClick="cal19.select(document.forms[0].vpm_data,'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19">
			 		<img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
			 		<a href="#" style="cursor: pointer;" onclick="svuotaData(document.forms[0].vpm_data);"><img src="images/delete.gif" align="absmiddle"/></a>
              </td>
            </tr>
            
            <tr class="containerBody">
                <td class="formLabel">Esito</td>
                <td>
                <%
                	EsitiVpm.setSelectSize(5);
                	EsitiVpm.setJsEvent( "onChange=\"javascript:displayVPMpatologie(),displayLCSO(),resetSelect();displayNumCapiEsito();\"" );
                	EsitiVpm.setMultiple(true);
                %>                               
                <%=EsitiVpm.getHtmlSelect( "vpm_esito", new LookupList() ) %>
                </td>
            </tr>
            
           <%
			Iterator iter = EsitiVpm.iterator();
			int k=0;
			while (iter.hasNext()) 
			{
				LookupElement thisElement = (LookupElement) iter.next();
				if(k>=2)
				{
					String num_capi_ovini_esito = "";
					String num_capi_caprini_esito = "";
					for( Esito e: (ArrayList<Esito>)Esiti )
					{
						if(e.getId_esito()==thisElement.getId())
							num_capi_ovini_esito = e.getNum_capi_ovini()+"";
						num_capi_caprini_esito = e.getNum_capi_caprini()+"";
					}
  					
%>
            <tr class="containerBody" style="display:none;" id="trNumCapiOviniEsito<%=thisElement.getId()%>">
                <td class="formLabel">Numero Capi <label class="specie1">Ovini</label><br/><%=thisElement.getDescription()%></td>
                <td>
               		 <input <% if(Partita.getCd_num_capi_ovini()<=0){out.println("disabled=\"disabled\"");} %>  type="text" id="num_capi_ovini_esito_<%=thisElement.getId()%>" name="num_capi_ovini_esito_<%=thisElement.getId()%>" onchange="isIntPositivo(this.value,'Numero Capi Ovini',this);" value="" />
                	 <font <% if(Partita.getCd_num_capi_ovini()<=0){out.println("style=\"display:none;\"");} %>  id="num_capi_ovini_esito_asterisco_<%=thisElement.getId()%>" color="red" >*</font>
                </td>
            </tr>
            
             <tr class="containerBody" style="display:none;" id="trNumCapiCapriniEsito<%=thisElement.getId()%>">
                <td class="formLabel">Numero Capi <label class="specie2">Caprini</label><br/><%=thisElement.getDescription()%></td>
                <td>
               		 <input <% if(Partita.getCd_num_capi_caprini()<=0){out.println("disabled=\"disabled\"");} %>  type="text" id="num_capi_caprini_esito_<%=thisElement.getId()%>" name="num_capi_caprini_esito_<%=thisElement.getId()%>" onchange="isIntPositivo(this.value,'Numero Capi Caprini',this);" value="" />
                	 <font  <% if(Partita.getCd_num_capi_caprini()<=0){out.println("style=\"display:none;\"");} %> id="num_capi_caprini_esito_asterisco_<%=thisElement.getId()%>" color="red" >*</font>
                </td>
            </tr>
<%
				}
				k++;
			}
%>

<!--            <tr class="containerBody" id="tr_vpm_abb_dist_carcassa" style="display: none;">-->
<!--               <td class="formLabel">Distruzione Carcassa</td>-->
<!--               <td>-->
<!--               		<input type="checkbox" name="abb_dist_carcassa" id="vpm_abb_dist_carcassa"/>-->
<!--               </td>-->
<!--            </tr>              -->

			<% if (false) { %>
			<tr class="containerBody">
              <td class="formLabel" >Data Ricezione Esito</td>
              <td>
              	<zeroio:dateSelect field="vpm_data_esito" form="main" showTimeZone="false" timestamp="" />
              </td>
            </tr>
            <% } %>
            
            

            <tr class="containerBody" 
            	id="vpm_riga_patologie" 
            	<%=(update) ? ("") : ("style=\"display: none\"") %> >
                <td class="formLabel">Patologie Rilevate</td>
                <%
                	Patologie.setMultiple(true);
                	Patologie.setSelectSize(5);
                %>
                <td><%=Patologie.getHtmlSelect( "vpm_patologie_rilevate", new LookupList() ) %></td>
            </tr> 
                
             <tr class="containerBody">
                <td class="formLabel">Causa Presunta o Accertata<br/>(per eventuali patologie)</td>
                <td><input type="text" name="vpm_causa_patologia" value="" /></td>
             </tr>

             <tr class="containerBody">
                <td class="formLabel">Note</td>
                <td><textarea name="vpm_note" rows="2" cols="25"></textarea></td>

            </tr>
            
             <tr>
                <th colspan="2"><strong>Veterinari addetti al controllo</strong></th>
            </tr>
            
            <tr class="containerBody">
            	<td colspan="2">
		            <table>
		            	<tr class="containerBody" style="display: block;">
		                	<td>1. <input 
		                			value=""
		                			onchange="javascript:toggleVetDiv('vpm_veterinario')" 
		                			size="35" id="vpm_veterinario" 
		                			name="vpm_veterinario" 
		                			type="text" />
		                	 		
		                	<%--  		
		                	<% Veterinari.setJsEvent( "onchange=\"set_vet( this, 'vpm_veterinario')\"" ); %>
							<%=Veterinari.getHtmlSelect( "veterinari_vpm", "-1" )%>
							--%>
							<select id="veterinari_vpm" name="veterinari_vpm" onchange="set_vet( this, 'vpm_veterinario')">
									<option value="-1">Seleziona</option>
									<%for (String gruppo : listaVeterinari.keySet()){ %>
										<optgroup label="<%=gruppo %>"></optgroup>
										<%for(Contact vet : listaVeterinari.get(gruppo)){ %>
											<option value = "<%=vet.getUserId()%>" ><%=vet.getNameLast() %></option>
										<%} %>
									<%} %>
							</select>
							
							</td>
		                </tr>
			            <tr 
			            	class="containerBody" 
			            	id="vpm_veterinario_toggle" 
			            	<%=( toHtmlValue( Partita.getVpm_veterinario_2() ).length() == 0 ) ? ("style=\"display: none\"") : ("") %>
			            	>
			                <td>2. <input 
		                			value=""
			                		onchange="javascript:toggleVetDiv('vpm_veterinario_2')" 
			                		size="35" 
			                		id="vpm_veterinario_2" 
			                		name="vpm_veterinario_2" 
			                		type="text" />
			                <%-- 
			                <% Veterinari.setJsEvent( "onchange=\"set_vet( this, 'vpm_veterinario_2')\"" ); %>
			                <%=Veterinari.getHtmlSelect( "veterinari_vpm2", "-1" ) %>
			                --%>
			                <select id="veterinari_vpm2" name="veterinari_vpm2" onchange="set_vet( this, 'vpm_veterinario_2')">
									<option value="-1">Seleziona</option>
									<%for (String gruppo : listaVeterinari.keySet()){ %>
										<optgroup label="<%=gruppo %>"></optgroup>
										<%for(Contact vet : listaVeterinari.get(gruppo)){ %>
											<option value = "<%=vet.getUserId()%>" ><%=vet.getNameLast() %></option>
										<%} %>
									<%} %>
							</select>
			                </td>
			            </tr>
			            
			            
			            <tr 
			            	class="containerBody" 
			            	id="vpm_veterinario_2_toggle" 
			            	<%=( toHtmlValue( Partita.getVpm_veterinario_3() ).length() == 0 ) ? ("style=\"display: none\"") : ("") %> >
			                <td>3. <input 
		                			value=""
			                		size="35" 
			                		id="vpm_veterinario_3"  
			                		name="vpm_veterinario_3" 
			                		type="text" />
			                <%-- 		
			                <% Veterinari.setJsEvent( "onchange=\"set_vet( this, 'vpm_veterinario_3')\"" ); %>
			                <%=Veterinari.getHtmlSelect( "veterinari_vpm3", "-1" ) %>
			                --%>
			                <select id="veterinari_vpm3" name="veterinari_vpm3" onchange="set_vet( this, 'vpm_veterinario_3')">
									<option value="-1">Seleziona</option>
									<%for (String gruppo : listaVeterinari.keySet()){ %>
										<optgroup label="<%=gruppo %>"></optgroup>
										<%for(Contact vet : listaVeterinari.get(gruppo)){ %>
											<option value = "<%=vet.getUserId()%>" ><%=vet.getNameLast() %></option>
										<%} %>
									<%} %>
							</select>
			                
			                </td>
			            </tr>
		            </table>
	            </td>
            </tr>
            
              <tr>
              
        <% if (false) { %>
        <td valign="top" width="100%">
        
        <table class="details" width="100%" border="0" cellpadding="4" cellspacing="0">
          <tbody>
            <tr>

              <th colspan="2"><strong>Test TSE</strong></th>
            </tr>

             <tr class="containerBody">
                <td class="formLabel">Data Prelievo</td>
                <td>
                	<zeroio:dateSelect 
                		field="bse_data_prelievo" 
                		form="main" 
                		showTimeZone="false" 
                		timestamp="<%=Partita.getBse_data_prelievo() %>" />
                </td>
            </tr>
                
             <tr class="containerBody">
                <td class="formLabel">Data Ricezione Esito</td>
                <td>
                	<zeroio:dateSelect 
                		field="bse_data_ricezione_esito" 
                		form="main" 
                		showTimeZone="false" 
                		timestamp="<%=Partita.getBse_data_ricezione_esito() %>" />
                </td>
            </tr>
            
            <tr class="containerBody">
                <td class="formLabel">Esito</td>
                <td>
                	<select name="bse_esito" id="bse_esito" >
                		<option 
                			value="-1" 
                			<%=( toHtmlValue( Partita.getBse_esito() ).length() > 0 ) ? ("") : ("selected=\"selected\"") %> 
                			>-- Seleziona --</option>
                		<option 
                			value="POSITIVO" 
                			<%=( "POSITIVO".equals( toHtmlValue( Partita.getBse_esito() ) ) ) ? ("selected=\"selected\"") : ("") %> 
                			>POSITIVO</option>
                		<option 
                			value="NEGATIVO" 
                			<%=( "NEGATIVO".equals( toHtmlValue( Partita.getBse_esito() ) ) ) ? ("selected=\"selected\"") : ("") %> 
                			 >NEGATIVO</option>
                	</select>
                </td>
             </tr>
            
			<tr class="containerBody">
                <td class="formLabel">Note</td>
                <td><textarea rows="2" cols="40" name="bse_note"><%=toHtmlValue( Partita.getBse_note() ) %></textarea></td>
            </tr>

          </tbody>
        </table>
         
	</td>
	<% } %>
        
        

    </tr>
            
            <tr>
                <th colspan="2"><strong>Destinatari/Esercenti</strong> <input onclick="javascript:gestioneAddDest();" type="button" name="addDest" id="addDest" value="Aggiungi" /> 
                </th>
            </tr>
            <tr>
            	<td colspan="2">
            		<i>Il numero capi non &egrave; selezionabile se tutte le carni e visceri degli animali macellati vanno al libero consumo, senza distruzione di organi</i>
            	</td>
            </tr>
            <tr>
            	<td colspan="2">
		            <table width="100%" border="0" cellpadding="2" cellspacing="0" align="left">
			            <tr class="containerBody">
			            	<td  class="formLabel">In Regione </td>
					        <td colspan="2"> 
						        Si <input 
							        	type="radio" 
							        	name="destinatario_1_in_regione" 
							        	value="si" 
							        	onclick="selectDestinazione(1)" 
							        	id="inRegione_1" 
							        	<%=(update && !Partita.isDestinatario_1_in_regione()) ? ("") : ("checked=\"checked\"") %> /> 
							        	
						        No <input 
						        		type="radio" 
						        		name="destinatario_1_in_regione" 
						        		value="no" 
						        		onclick="selectDestinazione(1)" 
						        		id="outRegione_1"
						        		<%=(update && !Partita.isDestinatario_1_in_regione()) ? ("checked=\"checked\"") : ("") %> />
					        </td>
					        <td> 
						        Si <input 
						        		type="radio" 
						        		name="destinatario_2_in_regione" 
						        		value="si" 
						        		onclick="selectDestinazione(2)" 
						        		id="inRegione_2" 
						        		<%=(update && !Partita.isDestinatario_2_in_regione()) ? ("") : ("checked=\"checked\"") %> /> 
						        		
						        No <input 
						        		type="radio" 
						        		name="destinatario_2_in_regione" 
						        		value="no" 
						        		onclick="selectDestinazione(2)" 
						        		id="outRegione_2"
						        		<%=(update && !Partita.isDestinatario_2_in_regione()) ? ("checked=\"checked\"") : ("") %> />
					        </td >
					    </tr>
					    <tr class="containerBody">
			            	<td  class="formLabel">Destinatari/Esercenti</td>
					        <td colspan="2">
						        <div 
						        	id="imprese_1">
						        	<a href = "javascript:popLookupSelectorDestinazioneCarni( 'si', 1, 'impresa' );" onclick="selectDestinazione(1);gestisciObbligatorietaVisitaPostMortem();gestioneObbligNumCapiDestCarni(1,1);" >[Seleziona Impresa] </a><br/>
						        	<a href = "javascript:popLookupSelectorDestinazioneCarni( 'si', 3, 'stab');" onclick="selectDestinazione(1);gestisciObbligatorietaVisitaPostMortem();gestioneObbligNumCapiDestCarni(1,2);" >[Seleziona Stabilimento]  </a><br/>
						        	<a href="javascript:mostraTextareaEsercente('esercenteNoGisa1');" onclick="selectDestinazioneFromLinkTextarea(1);gestisciObbligatorietaVisitaPostMortem();gestioneObbligNumCapiDestCarni(1,3);" >[Inserisci Esercente non in G.I.S.A.]</a><br/>
						        	<a href="javascript:impostaDestinatarioMacelloCorrente(1);" onclick="gestisciObbligatorietaVisitaPostMortem();gestioneObbligNumCapiDestCarni(1,4);" >[Macello corrente]</a>
						        	<textarea style="display: none;" rows="3" cols="36" id="esercenteNoGisa1" name="esercenteNoGisa1" onchange="valorizzaDestinatario(this,'destinatario_1');" ></textarea>
						        </div>
						        <div  style="<%=(update && !Partita.isDestinatario_1_in_regione()) ? ("") : ("display:none") %>" 
						        	id="esercenti_1">
						       		<!--  <a href = "javascript:popLookupSelectorDestinazioneCarni( 'no', 1 );" >[Seleziona Destinatario/Esercente]</a> -->
						       		<a href="javascript:mostraTextareaEsercente('esercenteFuoriRegione1');" onclick="selectDestinazioneFromLinkTextarea(1);gestisciObbligatorietaVisitaPostMortem();gestioneObbligNumCapiDestCarni(1,0);" >[Inserisci Esercente fuori Regione]</a>
						       		<textarea style="display: none;" rows="3" cols="36" id="esercenteFuoriRegione1" name="esercenteFuoriRegione1" onchange="valorizzaDestinatario(this,'destinatario_1');" ></textarea>
						        </div>
						        <br/>
						        <div id ="destinatario_label_1" align="center">
						        	-- Seleziona Destinatario/Esercente --
						        </div>
					        	<input 
					        		type="hidden" 
					        		name="destinatario_1_id" 
					        		id="destinatario_1_id" 
					        		value="" />
					        	<input 
					        		type="hidden" 
					        		name="destinatario_1_nome" 
					        		id="destinatario_1_nome" 
					        		onchange="gestisciObbligatorietaVisitaPostMortem();"
					        		value="" />
					        		<p id="destinatarioCarni1" align="center" style="display: none;"><font color="red" >*</font></p>
							</td>
						    <td>
						    	<div style="" id="imprese_2">
						        	<a href = "javascript:popLookupSelectorDestinazioneCarni( 'si', 2, 'impresa' );" onclick="selectDestinazione(2);gestioneObbligNumCapiDestCarni(2,1);" >[Seleziona Impresa]</a><br/>
						      		<a href = "javascript:popLookupSelectorDestinazioneCarni( 'si', 4, 'stab');" onclick="selectDestinazione(2);gestioneObbligNumCapiDestCarni(2,2);" >[Seleziona Stabilimento]</a><br/>
						      		<a href="javascript:mostraTextareaEsercente('esercenteNoGisa2');" onclick="selectDestinazioneFromLinkTextarea(2);gestioneObbligNumCapiDestCarni(2,3);" >[Inserisci Esercente non in G.I.S.A.]</a><br/>
						      		<a href="javascript:impostaDestinatarioMacelloCorrente(2);" onclick="gestisciObbligatorietaVisitaPostMortem();gestioneObbligNumCapiDestCarni(2,4);" >[Macello corrente]</a>
						      		<textarea style="display: none;" rows="3" cols="36" id="esercenteNoGisa2" name="esercenteNoGisa2" onchange="valorizzaDestinatario(this,'destinatario_2');" ></textarea>

						        </div>
						        <div  style="<%=(update && !Partita.isDestinatario_2_in_regione()) ? ("") : ("display:none") %>"  id="esercenti_2">
						       		<a href="javascript:mostraTextareaEsercente('esercenteFuoriRegione2');" onclick="selectDestinazioneFromLinkTextarea(2);gestisciObbligatorietaVisitaPostMortem();gestioneObbligNumCapiDestCarni(2,0);" >[Inserisci Esercente fuori Regione]</a>
						       		<textarea style="display: none;" rows="3" cols="36" id="esercenteFuoriRegione2" name="esercenteFuoriRegione2" onchange="valorizzaDestinatario(this,'destinatario_2');" ></textarea>
						        </div>
						        <br/>
					        	<div id ="destinatario_label_2" align="center">
					        		-- Seleziona Destinatario/Esercente --
						        </div>
					        	<input 
					        		type="hidden" 
					        		name="destinatario_2_id" 
					        		id="destinatario_2_id" 
					        		value="" />
					        	<input 
					        		type="hidden" 
					        		name="destinatario_2_nome" 
					        		id="destinatario_2_nome" 
					        		onchange="gestisciObbligatorietaVisitaPostMortem();"
					        		value="" />
					        		<p id="destinatarioCarni2" align="center" style="display: none;"><font color="red" >*</font></p>
						    </td >
						</tr>
						<tr class="containerBody">
			            	<td  class="formLabel">Numero Capi <label class="specie1">Ovini</label></td>
					        <td colspan="2"> 
						        <input disabled="disabled" onchange="isIntPositivo(this.value,'Numero Capi',this);" type="text" name="destinatario_1_num_capi_ovini" value="" id="num_capi_ovini_1" /> 
					        	<font style="display:none;" id="num_capi_ovini_asterisco_1" color="red" >*</font>
					        </td>
					        <td> 
						        <input disabled="disabled" onchange="isIntPositivo(this.value,'Numero Capi',this);" type="text" name="destinatario_2_num_capi_ovini" value="" id="num_capi_ovini_2" /> 
						    	<font style="display:none;" id="num_capi_ovini_asterisco_2" color="red" >*</font>
						    </td >
					    </tr>
					    <tr class="containerBody">
			            	<td  class="formLabel">Numero Capi <label class="specie2">Caprini</label></td>
					        <td colspan="2"> 
						        <input disabled="disabled" onchange="isIntPositivo(this.value,'Numero Capi',this);" type="text" name="destinatario_1_num_capi_caprini" value="" id="num_capi_caprini_1" /> 
					        	<font style="display:none;" id="num_capi_caprini_asterisco_1" color="red" >*</font>
					        </td>
					        <td> 
						        <input disabled="disabled" onchange="isIntPositivo(this.value,'Numero Capi',this);" type="text" name="destinatario_2_num_capi_caprini" value="" id="num_capi_caprini_2" /> 
						    	<font style="display:none;" id="num_capi_caprini_asterisco_2" color="red" >*</font>
						    </td>
					    </tr>
					</table>
		  		</td>
			 </tr>
			 
			 
			 
			 
			 <!-- AGGIUNA DI ALTRI 2 -->
			 
			 
			 <tr>
            	<td colspan="2">
		            <table width="100%" border="0" cellpadding="2" cellspacing="0" align="left">
			            <tr class="containerBody">
			            	<td  class="formLabel">In Regione </td>
					        <td> 
						        Si <input 
							        	type="radio" 
							        	name="destinatario_3_in_regione" 
							        	value="si" 
							        	onclick="selectDestinazione(3)" 
							        	id="inRegione_3"/> 
							        	
						        No <input 
						        		type="radio" 
						        		name="destinatario_3_in_regione" 
						        		value="no" 
						        		onclick="selectDestinazione(3)" 
						        		id="outRegione_3"/>
					        </td>
					        <td> 
						        Si <input 
						        		type="radio" 
						        		name="destinatario_4_in_regione" 
						        		value="si" 
						        		onclick="selectDestinazione(4)" 
						        		id="inRegione_4" /> 
						        		
						        No <input 
						        		type="radio" 
						        		name="destinatario_4_in_regione" 
						        		value="no" 
						        		onclick="selectDestinazione(4)" 
						        		id="outRegione_4"/>
					        </td>
					    </tr>
					    <tr class="containerBody">
			            	<td  class="formLabel">Destinatario delle Carni </td>
					        <td>
						        <div 
						        	id="imprese_3">
						        	<a href = "javascript:popLookupSelectorDestinazioneCarni( 'si', 5, 'impresa' );" onclick="selectDestinazione(3);gestisciObbligatorietaVisitaPostMortem();gestioneObbligNumCapiDestCarni(3,1);" >[Seleziona Impresa] </a><br/>
						        	<a href = "javascript:popLookupSelectorDestinazioneCarni( 'si', 5, 'stab');" onclick="selectDestinazione(3);gestisciObbligatorietaVisitaPostMortem();gestioneObbligNumCapiDestCarni(3,2);" >[Seleziona Stabilimento]  </a><br/>
						        	<a href="javascript:mostraTextareaEsercente('esercenteNoGisa3');" onclick="selectDestinazioneFromLinkTextarea(3);gestisciObbligatorietaVisitaPostMortem();gestioneObbligNumCapiDestCarni(3,3);" >[Inserisci Esercente non in G.I.S.A.]</a><br/>
						        	<a href="javascript:impostaDestinatarioMacelloCorrente(3);" onclick="gestisciObbligatorietaVisitaPostMortem();gestioneObbligNumCapiDestCarni(3,4);" >[Macello corrente]</a>
						        	<textarea style="display: none;" rows="3" cols="36" id="esercenteNoGisa3" name="esercenteNoGisa3" onchange="valorizzaDestinatario(this,'destinatario_3');" ></textarea>
						        </div>
						        <div  style="<%=(update && !Partita.isDestinatario_3_in_regione()) ? ("") : ("display:none") %>" 
						        	id="esercenti_3">
						       		<a href="javascript:mostraTextareaEsercente('esercenteFuoriRegione3');" onclick="selectDestinazioneFromLinkTextarea(3);gestisciObbligatorietaVisitaPostMortem();gestioneObbligNumCapiDestCarni(3,0);" >[Inserisci Esercente fuori Regione]</a>
						       		<textarea style="display: none;" rows="3" cols="36" id="esercenteFuoriRegione3" name="esercenteFuoriRegione3" onchange="valorizzaDestinatario(this,'destinatario_3');" ></textarea>
						        </div>
						        <br/>
						        <div id ="destinatario_label_3" align="center">
						        	-- Seleziona Destinatario/Esercente --
						        </div>
					        	<input 
					        		type="hidden" 
					        		name="destinatario_3_id" 
					        		id="destinatario_3_id" 
					        		value="" />
					        	<input 
					        		type="hidden" 
					        		name="destinatario_3_nome" 
					        		id="destinatario_3_nome" 
					        		onchange="gestisciObbligatorietaVisitaPostMortem();"
					        		value="" />
					        		<p id="destinatarioCarni3" align="center" style="display: none;"><font color="red" >*</font></p>
							</td>
							
							
						    <td>
						    	<div style="" id="imprese_4">
						        	<a href = "javascript:popLookupSelectorDestinazioneCarni( 'si', 6, 'impresa' );" onclick="selectDestinazione(4);gestioneObbligNumCapiDestCarni(4,1);" >[Seleziona Impresa]</a><br/>
						      		<a href = "javascript:popLookupSelectorDestinazioneCarni( 'si', 6, 'stab');" onclick="selectDestinazione(4);gestioneObbligNumCapiDestCarni(4,2);" >[Seleziona Stabilimento]</a><br/>
						      		<a href="javascript:mostraTextareaEsercente('esercenteNoGisa4');" onclick="selectDestinazioneFromLinkTextarea(4);gestioneObbligNumCapiDestCarni(4,3);" >[Inserisci Esercente non in G.I.S.A.]</a><br/>
						      		<a href="javascript:impostaDestinatarioMacelloCorrente(4);" onclick="gestisciObbligatorietaVisitaPostMortem();gestioneObbligNumCapiDestCarni(4,4);" >[Macello corrente]</a>
						      		<textarea style="display: none;" rows="3" cols="36" id="esercenteNoGisa4" name="esercenteNoGisa4" onchange="valorizzaDestinatario(this,'destinatario_4');" ></textarea>

						        </div>
						        <div  style="<%=(update && !Partita.isDestinatario_4_in_regione()) ? ("") : ("display:none") %>"  id="esercenti_4">
						       		<a href="javascript:mostraTextareaEsercente('esercenteFuoriRegione4');" onclick="selectDestinazioneFromLinkTextarea(4);gestisciObbligatorietaVisitaPostMortem();gestioneObbligNumCapiDestCarni(4,0);" >[Inserisci Esercente fuori Regione]</a>
						       		<textarea style="display: none;" rows="3" cols="36" id="esercenteFuoriRegione4" name="esercenteFuoriRegione4" onchange="valorizzaDestinatario(this,'destinatario_4');" ></textarea>
						        </div>
						        <br/>
					        	<div id ="destinatario_label_4" align="center">
					        		-- Seleziona Destinatario/Esercente --
						        </div>
					        	<input 
					        		type="hidden" 
					        		name="destinatario_4_id" 
					        		id="destinatario_4_id" 
					        		value="" />
					        	<input 
					        		type="hidden" 
					        		name="destinatario_4_nome" 
					        		id="destinatario_4_nome" 
					        		onchange="gestisciObbligatorietaVisitaPostMortem();"
					        		value="" />
					        		<p id="destinatarioCarni4" align="center" style="display: none;"><font color="red" >*</font></p>
						    </td>
						</tr>
						<tr class="containerBody">
			            	<td  class="formLabel">Numero Capi <label class="specie1">Ovini</label></td>
					        <td> 
						        <input disabled="disabled" onchange="isIntPositivo(this.value,'Numero Capi',this);" type="text" name="destinatario_3_num_capi_ovini" value="" id="num_capi_ovini_3" /> 
					        	<font style="display:none;" id="num_capi_ovini_asterisco_3" color="red" >*</font>
					        </td>
					        <td> 
						        <input disabled="disabled" onchange="isIntPositivo(this.value,'Numero Capi',this);" type="text" name="destinatario_4_num_capi_ovini" value="" id="num_capi_ovini_4" /> 
						    	<font style="display:none;" id="num_capi_ovini_asterisco_4" color="red" >*</font>
						    </td>
					    </tr>
					    <tr class="containerBody">
			            	<td  class="formLabel">Numero Capi <label class="specie2">Caprini</label></td>
					        <td> 
						        <input disabled="disabled" onchange="isIntPositivo(this.value,'Numero Capi',this);" type="text" name="destinatario_3_num_capi_caprini" value="" id="num_capi_caprini_3" /> 
					        	<font style="display:none;" id="num_capi_caprini_asterisco_3" color="red" >*</font>
					        </td>
					        <td> 
						        <input disabled="disabled" onchange="isIntPositivo(this.value,'Numero Capi',this);" type="text" name="destinatario_4_num_capi_caprini" value="" id="num_capi_caprini_4" /> 
						    	<font style="display:none;" id="num_capi_caprini_asterisco_4" color="red" >*</font>
						    </td>
					    </tr>
					</table>
		  		</td>
			 </tr>
			 
			 
			 <%
						//Disabilitata l'aggiunta di altri destinatari
						for(int i=5;i<=20;i+=2)
						{
							int j=i+1;
				        	Boolean isDestinatarioInRegione = true;//(Boolean)ReflectionUtil.invocaMetodo(Partita, "isDestinatario_"+i+"_in_regione", null, null);
				        	Boolean isDestinatarioInRegione2 = true;//(Boolean)ReflectionUtil.invocaMetodo(Partita, "isDestinatario_"+j+"_in_regione", null, null);
				        	String destinatarioNome  = "";//(String)ReflectionUtil.invocaMetodo(Partita, "getDestinatario_"+i+"_nome", null, null);
				        	String destinatarioNome2 = "";//(String)ReflectionUtil.invocaMetodo(Partita, "getDestinatario_"+j+"_nome", null, null);
				        	Integer destinatarioId  = -1;//(Integer)ReflectionUtil.invocaMetodo(Partita, "getDestinatario_"+i+"_id", null, null);
				        	Integer destinatarioId2 = -1;//(Integer)ReflectionUtil.invocaMetodo(Partita, "getDestinatario_"+j+"_id", null, null);
				        	String destinatarioNumCapiOvini  = ((Integer)ReflectionUtil.invocaMetodo(Partita, "getDestinatario_"+i+"_num_capi_ovini", null, null))+"";
				        	String destinatarioNumCapiOvini2  = ((Integer)ReflectionUtil.invocaMetodo(Partita, "getDestinatario_"+j+"_num_capi_ovini", null, null))+"";
				        	String destinatarioNumCapiCaprini  = ((Integer)ReflectionUtil.invocaMetodo(Partita, "getDestinatario_"+i+"_num_capi_caprini", null, null))+"";
				        	String destinatarioNumCapiCaprini2  = ((Integer)ReflectionUtil.invocaMetodo(Partita, "getDestinatario_"+j+"_num_capi_caprini", null, null))+"";
				        	
				        	//if(destinatarioNumCapiOvini2.equals("0") || destinatarioNumCapiOvini2.equals("-1"))
				        		destinatarioNumCapiOvini2="";
				        	//if(destinatarioNumCapiOvini.equals("0") || destinatarioNumCapiOvini.equals("-1"))
				        		destinatarioNumCapiOvini="";
				        	//if(destinatarioNumCapiCaprini2.equals("0") || destinatarioNumCapiCaprini2.equals("-1"))
				        		destinatarioNumCapiCaprini2="";
				        	//if(destinatarioNumCapiCaprini.equals("0") || destinatarioNumCapiCaprini.equals("-1"))
				        		destinatarioNumCapiCaprini="";
%>						
		 <tr style="display:none;" id="rigaDestTr<%=(i+1)/2 %>">
            	<td colspan="2">
		            <table width="100%" border="0" cellpadding="2" cellspacing="0" align="left">
			            <tr class="containerBody">
			            	<td  style="display:none;" id="rigaDestTd1<%=(i+1)/2 %>"  class="formLabel">In Regione </td>
					        <td  style="display:none;" id="rigaDestTd2<%=(i+1)/2 %>" > 
						        Si <input 
							        	type="radio" 
							        	name="destinatario_<%=i%>_in_regione" 
							        	value="si" 
							        	onclick="selectDestinazione(<%=i%>)" 
							        	id="inRegione_<%=i%>" 
							        	<%=(update &&  !isDestinatarioInRegione) ? ("") : ("checked=\"checked\"") %> /> 
							        	
						        No <input 
						        		type="radio" 
						        		name="destinatario_<%=i%>_in_regione" 
						        		value="no" 
						        		onclick="selectDestinazione(<%=i%>)" 
						        		id="outRegione_<%=i%>"
						        		<%=(update && !isDestinatarioInRegione) ? ("checked=\"checked\"") : ("") %> />
					        </td>
					        <td style="display:none;" id="rigaDestTd3<%=(i+1)/2 %>" > 
						        Si <input 
						        		type="radio" 
						        		name="destinatario_<%=j%>_in_regione" 
						        		value="si"
						        		onclick="selectDestinazione(<%=j%>)" 
						        		id="inRegione_<%=j%>" 
						        		<%=(update && !isDestinatarioInRegione2) ? ("") : ("checked=\"checked\"") %> /> 
						        		
						        No <input 
						        		type="radio" 
						        		name="destinatario_<%=j%>_in_regione" 
						        		value="no" 
						        		onclick="selectDestinazione(<%=j%>)" 
						        		id="outRegione_<%=j%>"
						        		<%=(update && !isDestinatarioInRegione2) ? ("checked=\"checked\"") : ("") %> />
					        </td>
					    </tr>
					    <tr class="containerBody">
			            	<td  style="display:none;" id="rigaDestTd4<%=(i+1)/2 %>" class="formLabel">Esercenti</td>
					        <td style="display:none;" id="rigaDestTd5<%=(i+1)/2 %>" >
						        <div 
						        	style="<%=(update && !isDestinatarioInRegione) ? ("display:none") : ("") %>" 
						        	id="imprese_<%=i%>">
						        	<a href = "javascript:popLookupSelectorDestinazioneCarni( 'si', <%=i+2%>, 'impresa' );" onclick="selectDestinazione(<%=i%>);gestisciObbligatorietaVisitaPostMortem();gestioneObbligNumCapiDestCarni(<%=i%>,1);gestioneObbligNumCapiDestCarni(<%=i%>,1);" >[Seleziona Impresa] </a><br/>
						        	<a href = "javascript:popLookupSelectorDestinazioneCarni( 'si', <%=i+2%>, 'stab');" onclick="selectDestinazione(<%=i%>);gestisciObbligatorietaVisitaPostMortem();gestioneObbligNumCapiDestCarni(<%=i%>,2);gestioneObbligNumCapiDestCarni(<%=i%>,2);" >[Seleziona Stabilimento]  </a><br/>
						        	<a href="javascript:mostraTextareaEsercente('esercenteNoGisa<%=i%>');" onclick="selectDestinazioneFromLinkTextarea(<%=i%>);gestisciObbligatorietaVisitaPostMortem();gestioneObbligNumCapiDestCarni(<%=i%>,3);" >[Inserisci Esercente non in G.I.S.A.]</a><br/>
						        	<a href="javascript:impostaDestinatarioMacelloCorrente(<%=i%>);" onclick="gestisciObbligatorietaVisitaPostMortem();gestioneObbligNumCapiDestCarni(<%=i%>,4);" >[Macello corrente]</a>
						        	<textarea style="display: none;" rows="3" cols="36" id="esercenteNoGisa<%=i%>" name="esercenteNoGisa<%=i%>" onchange="valorizzaDestinatario(this,'destinatario_<%=i%>');" ><%=toHtmlValue( destinatarioNome ) %></textarea>
						        </div>
						        <div  
						        	style="<%=(update && !isDestinatarioInRegione) ? ("") : ("display:none") %>" 
						        	id="esercenti_<%=i%>">
						       		<a href="javascript:mostraTextareaEsercente('esercenteFuoriRegione<%=i%>');" onclick="selectDestinazioneFromLinkTextarea(<%=i%>);gestisciObbligatorietaVisitaPostMortem();gestioneObbligNumCapiDestCarni(<%=i%>,0);" >[Inserisci Esercente fuori Regione]</a>
						       		<textarea style="display: none;" rows="3" cols="36" id="esercenteFuoriRegione<%=i%>" name="esercenteFuoriRegione<%=i%>" onchange="valorizzaDestinatario(this,'destinatario_<%=i%>');" ><%=toHtmlValue( destinatarioNome ) %></textarea>
						        </div>
						        <br/>
						        <div id ="destinatario_label_<%=i%>" align="center">
						        	<%=( destinatarioId != -1) ? (toHtmlValue( destinatarioNome )) : ("-- Seleziona Destinatario/Esercente --") %>
						        </div>
					        	<input 
					        		type="hidden" 
					        		name="destinatario_<%=i%>_id" 
					        		id="destinatario_<%=i%>_id" 
					        		value="" />
					        	<input 
					        		type="hidden" 
					        		name="destinatario_<%=i%>_nome" 
					        		id="destinatario_<%=i%>_nome" 
					        		onchange="gestisciObbligatorietaVisitaPostMortem();"
					        		value="<%=toHtmlValue( destinatarioNome ) %>" />
					        		<p id="destinatarioCarni3" align="center" style="display: none;"><font color="red" >*</font></p>
							</td>
							
							
						    <td style="display:none;" id="rigaDestTd6<%=(i+1)/2 %>" >
						    	<div style="" id="imprese_<%=j%>">
						        	<a href = "javascript:popLookupSelectorDestinazioneCarni( 'si', <%=j+2%>, 'impresa' );" onclick="selectDestinazione(<%=j%>);gestioneObbligNumCapiDestCarni(<%=j%>,1);gestioneObbligNumCapiDestCarni(<%=j%>,1);" >[Seleziona Impresa]</a><br/>
						      		<a href = "javascript:popLookupSelectorDestinazioneCarni( 'si', <%=j+2%>, 'stab');" onclick="selectDestinazione(<%=j%>);gestioneObbligNumCapiDestCarni(<%=j%>,2);gestioneObbligNumCapiDestCarni(<%=j%>,2);" >[Seleziona Stabilimento]</a><br/>
						      		<a href="javascript:mostraTextareaEsercente('esercenteNoGisa<%=j%>');" onclick="selectDestinazioneFromLinkTextarea(<%=j%>);gestioneObbligNumCapiDestCarni(<%=j%>,3);" >[Inserisci Esercente non in G.I.S.A.]</a><br/>
						      		<a href="javascript:impostaDestinatarioMacelloCorrente(<%=j%>);" onclick="gestisciObbligatorietaVisitaPostMortem();gestioneObbligNumCapiDestCarni(<%=j%>,4);" >[Macello corrente]</a>
						      		<textarea style="display: none;" rows="3" cols="36" id="esercenteNoGisa<%=j%>" name="esercenteNoGisa<%=j%>" onchange="valorizzaDestinatario(this,'destinatario_<%=j%>');" ><%=toHtmlValue( destinatarioNome2 ) %></textarea>

						        </div>
						        <div  style="<%=(update && !isDestinatarioInRegione2) ? ("") : ("display:none") %>"  id="esercenti_<%=j%>">
						       		<a href="javascript:mostraTextareaEsercente('esercenteFuoriRegione<%=j%>');" onclick="selectDestinazioneFromLinkTextarea(<%=j%>);gestisciObbligatorietaVisitaPostMortem();gestioneObbligNumCapiDestCarni(<%=j%>,0);" >[Inserisci Esercente fuori Regione]</a>
						       		<textarea style="display: none;" rows="3" cols="36" id="esercenteFuoriRegione<%=j%>" name="esercenteFuoriRegione<%=j%>" onchange="valorizzaDestinatario(this,'destinatario_<%=j%>');" ><%=toHtmlValue( destinatarioNome2 ) %></textarea>
						        </div>
						        <br/>
					        	<div id ="destinatario_label_<%=j%>" align="center">
						        	<%=(destinatarioId2 != -1) ? (toHtmlValue( destinatarioNome2 )) : ("-- Seleziona Destinatario/Esercente --") %>	
						        </div>
					        	<input 
					        		type="hidden" 
					        		name="destinatario_<%=j%>_id" 
					        		id="destinatario_<%=j%>_id" 
					        		value="" />
					        	<input 
					        		type="hidden" 
					        		name="destinatario_<%=j%>_nome" 
					        		id="destinatario_<%=j%>_nome" 
					        		onchange="gestisciObbligatorietaVisitaPostMortem();"
					        		value="<%=toHtmlValue( destinatarioNome2 ) %>" />
					        		<p id="destinatarioCarni<%=j%>" align="center" style="display: none;"><font color="red" >*</font></p>
						    </td>
						</tr>
						<tr class="containerBody">
			            	<td class="formLabel" style="display:none;" id="rigaDestTd7<%=(i+1)/2 %>" >Numero Capi <label class="specie1">Ovini</label></td>
					        <td style="display:none;" id="rigaDestTd8<%=(i+1)/2 %>"> 
						        <input disabled="disabled" onchange="isIntPositivo(this.value,'Numero Capi',this);" type="text" name="destinatario_<%=i%>_num_capi_ovini" value="<%=destinatarioNumCapiOvini%>" id="num_capi_ovini_<%=i%>" /> 
					        	<font style="display:none;" id="num_capi_ovini_asterisco_<%=i%>" color="red" >*</font>
					        </td>
					        <td style="display:none;" id="rigaDestTd9<%=(i+1)/2 %>" > 
						        <input disabled="disabled" onchange="isIntPositivo(this.value,'Numero Capi',this);" type="text" name="destinatario_<%=j%>_num_capi_ovini" value="<%=destinatarioNumCapiOvini2%>" id="num_capi_ovini_<%=j%>" /> 
						    	<font style="display:none;" id="num_capi_ovini_asterisco_<%=j%>" color="red" >*</font>
						    </td>
					    </tr>
					    
					    <tr class="containerBody">
			            	<td class="formLabel" style="display:none;" id="rigaDestTd10<%=(i+1)/2 %>" >Numero Capi <label class="specie1">Ovini</label></td>
					        <td style="display:none;" id="rigaDestTd11<%=(i+1)/2 %>"> 
						        <input disabled="disabled" onchange="isIntPositivo(this.value,'Numero Capi',this);" type="text" name="destinatario_<%=i%>_num_capi_caprini" value="<%=destinatarioNumCapiCaprini%>" id="num_capi_caprini_<%=i%>" /> 
					        	<font style="display:none;" id="num_capi_caprini_asterisco_<%=i%>" color="red" >*</font>
					        </td>
					        <td style="display:none;" id="rigaDestTd12<%=(i+1)/2 %>" > 
						        <input disabled="disabled" onchange="isIntPositivo(this.value,'Numero Capi',this);" type="text" name="destinatario_<%=j%>_num_capi_caprini" value="<%=destinatarioNumCapiCaprini2%>" id="num_capi_caprini_<%=j%>" /> 
						    	<font style="display:none;" id="num_capi_caprini_asterisco_<%=j%>" color="red" >*</font>
						    </td>
					    </tr>
					    </table>
		  		</td>
			 </tr>
						
<%
						}
%>
            
                </tbody>
               </table>
         
			  </td>
          
    </tr>
    
    <tr 
    	id="lcso" 
    	style="display:none" >
    	<td>
    		<table class="details" width="100%" border="0" cellpadding="4" cellspacing="0">
    		<tr>
              <th colspan="2"><strong>Organi</strong></th>
            </tr>
<!--            <tr class="containerBody">-->
<!--              <td class="formLabel" >Data</td>-->
<!---->
<!--              <td><zeroio:dateSelect field="lcso_data" form="main" showTimeZone="false" /> </td>-->
<!--            </tr>-->
     
     <%
     	int numero_organi = 0;
     	int indice_globale= 0;
     	ArrayList<Integer> listaIdOrgani = new ArrayList<Integer>();
     	ArrayList<Organi> listaOrgani = null;
     	for(int key : (Set<Integer>)OrganiListNew.keySet()){
     		listaIdOrgani.add(key);
     	}
     	for( int index = 1; index == 1 || index <= listaIdOrgani.size(); index++ )
     	{
     		//out.println("Indice di Organi = "+ index);
     		//out.println("Numero di Organi = "+ OrganiList.size());
     		indice_globale=index;
     		if(listaIdOrgani.size() > 0){
     			listaOrgani = (ArrayList<Organi>)OrganiListNew.get( listaIdOrgani.get(index-1) );
     		}
     		Organi organo = (index <= listaIdOrgani.size()) ? (Organi)listaOrgani.get(0) : (new Organi());
     		PatologieOrgani.setJsEvent("onChange=\"javascript:displayStadio2(" + index + ");\"");
     %>
     
    
		    <tr style="background-color: #EDEDED" class="containerBody">
               <td colspan="2">&nbsp;<input type="hidden" name="lcso_id_<%=index %>" value="<%=organo.getId() %>" /> </td>
            </tr>
            
     		<tr id="organo" class="containerBody">
              <td class="formLabel" >Organo</td>
              <td>
              		<%	String id_organo = "document.getElementById('lcso_organo_"+index+"').value" ; 
              		
              			Organi.setJsEvent("onChange=\"javascript:vpm_resetta_lookup_patologia_organo("+ index +"," + id_organo +", -1);\"");
              			Organi.setIdName("lcso_organo_" + index);
              			
              		%>
              		<%=	Organi.getHtmlSelect("lcso_organo_" + index, organo.getLcso_organo())%>
              </td>
            </tr>

            <tr id="patologie" class="containerBody">
              <td class="formLabel" >Lesione Anatomopatologica</td>
              <td>
              <%
	      			lookup_lesione_milza.setSelectStyle("display:none");
              		lookup_lesione_milza.setMultiple(true);
              		lookup_lesione_milza.setSelectSize(5);
              		lookup_lesione_milza.setJsEvent("onChange=\"javascript:mostraLcsoPatologiaAltro(this," + index + ");\"");
              		
	       			lookup_lesione_cuore.setSelectStyle("display:none");
	       			lookup_lesione_cuore.setMultiple(true);
	       			lookup_lesione_cuore.setSelectSize(5);
	       			lookup_lesione_cuore.setJsEvent("onChange=\"javascript:mostraLcsoPatologiaAltro(this," + index + ");\"");
	       			
	        		lookup_lesione_polmoni.setSelectStyle("display:none");
	        		lookup_lesione_polmoni.setMultiple(true);
	        		lookup_lesione_polmoni.setSelectSize(5);
	        		lookup_lesione_polmoni.setJsEvent("onChange=\"javascript:mostraLcsoPatologiaAltro(this," + index + ");\"");
	        		
	        		lookup_lesione_visceri.setSelectStyle("display:none");
	        		lookup_lesione_visceri.setMultiple(true);
	        		lookup_lesione_visceri.setSelectSize(5);
	        		lookup_lesione_visceri.setJsEvent("onChange=\"javascript:mostraLcsoPatologiaAltro(this," + index + ");\"");
	        		
	        		lookup_lesione_fegato.setSelectStyle("display:none");
	        		lookup_lesione_fegato.setMultiple(true);
	        		lookup_lesione_fegato.setSelectSize(5);
	        		lookup_lesione_fegato.setJsEvent("onChange=\"javascript:mostraLcsoPatologiaAltro(this," + index + ");\"");
	        		
	        		lookup_lesione_rene.setSelectStyle("display:none");
	        		lookup_lesione_rene.setMultiple(true);
	        		lookup_lesione_rene.setSelectSize(5);
	        		lookup_lesione_rene.setJsEvent("onChange=\"javascript:mostraLcsoPatologiaAltro(this," + index + ");\"");
	        		
	        		lookup_lesione_mammella.setSelectStyle("display:none");
	        		lookup_lesione_mammella.setMultiple(true);
	        		lookup_lesione_mammella.setSelectSize(5);
	        		lookup_lesione_mammella.setJsEvent("onChange=\"javascript:mostraLcsoPatologiaAltro(this," + index + ");\"");
	        		
	        		lookup_lesione_apparato_genitale.setSelectStyle("display:none");
	        		lookup_lesione_apparato_genitale.setMultiple(true);
	        		lookup_lesione_apparato_genitale.setSelectSize(5);
	        		lookup_lesione_apparato_genitale.setJsEvent("onChange=\"javascript:mostraLcsoPatologiaAltro(this," + index + ");\"");
	        		
	        		lookup_lesione_stomaco.setSelectStyle("display:none");
	        		lookup_lesione_stomaco.setMultiple(true);
	        		lookup_lesione_stomaco.setSelectSize(5);
	        		lookup_lesione_stomaco.setJsEvent("onChange=\"javascript:mostraLcsoPatologiaAltro(this," + index + ");\"");
	        		
	        		lookup_lesione_intestino.setSelectStyle("display:none");
	        		lookup_lesione_intestino.setMultiple(true);
	        		lookup_lesione_intestino.setSelectSize(5);
	        		lookup_lesione_intestino.setJsEvent("onChange=\"javascript:mostraLcsoPatologiaAltro(this," + index + ");\"");
	        		
	        		lookup_lesione_osteomuscolari.setSelectStyle("display:none");
	        		lookup_lesione_osteomuscolari.setMultiple(true);
	        		lookup_lesione_osteomuscolari.setSelectSize(5);
	        		lookup_lesione_osteomuscolari.setJsEvent("onChange=\"javascript:mostraLcsoPatologiaAltro(this," + index + ");\"");
	        		
	        		lookup_lesione_generici.setSelectStyle("display:none");
	        		lookup_lesione_generici.setMultiple(true);
	        		lookup_lesione_generici.setSelectSize(5);
	        		lookup_lesione_generici.setJsEvent("onChange=\"javascript:mostraLcsoPatologiaAltro(this," + index + ");\"");
	        		
	        		lookup_lesione_altro.setSelectStyle("display:none");
	        		lookup_lesione_altro.setMultiple(true);
	        		lookup_lesione_altro.setSelectSize(5);
	        		lookup_lesione_altro.setJsEvent("onChange=\"javascript:mostraLcsoPatologiaAltro(this," + index + ");\"");
	        		
	        		
	        		//lookup_lesione_milza.setJsEvent("onChange=\"javascript:displayStadio2(" + index + ");\"");
	        		//lookup_lesione_cuore.setJsEvent("onChange=\"javascript:displayStadio2(" + index + ");\"");
	        		//lookup_lesione_polmoni.setJsEvent("onChange=\"javascript:displayStadio2(" + index + ");\"");
	        		//lookup_lesione_fegato.setJsEvent("onChange=\"javascript:displayStadio2(" + index + ");\"");
	        		//lookup_lesione_rene.setJsEvent("onChange=\"javascript:displayStadio2(" + index + ");\"");
	        		//lookup_lesione_mammella.setJsEvent("onChange=\"javascript:displayStadio2(" + index + ");\"");
	        		//lookup_lesione_apparato_genitale.setJsEvent("onChange=\"javascript:displayStadio2(" + index + ");\"");
	        		//lookup_lesione_stomaco.setJsEvent("onChange=\"javascript:displayStadio2(" + index + ");\"");
	        		//lookup_lesione_intestino.setJsEvent("onChange=\"javascript:displayStadio2(" + index + ");\"");
	        		//lookup_lesione_osteomuscolari.setJsEvent("onChange=\"javascript:displayStadio2(" + index + ");\"");
	        		
	        		
	        		//out.println("Valore ID lesione : "  + organo.getLcso_patologia() ) ;
	        		LookupList multipleSelect = new LookupList();
	        		if(listaIdOrgani.size() > 0){
		        		for ( Organi o : listaOrgani ){
		        			multipleSelect.addItem(o.getLcso_patologia(), "" );
		        		}
	        		}
	        		LookupList multipleSelectDefault = new LookupList();
	        		multipleSelectDefault.addItem(-1,"");
				               
              %>
                  <%=lookup_lesione_milza.getHtmlSelect("lesione_milza_" + index, organo.getLcso_organo() == 1 ? multipleSelect : multipleSelectDefault )%>
                  <%=lookup_lesione_cuore.getHtmlSelect("lesione_cuore_" + index, organo.getLcso_organo() == 2 ? multipleSelect : multipleSelectDefault)%>
	              <%=lookup_lesione_polmoni.getHtmlSelect("lesione_polmoni_" + index, organo.getLcso_organo() == 3 ? multipleSelect : multipleSelectDefault)%>
	               <%=lookup_lesione_visceri.getHtmlSelect("lesione_visceri_" + index, organo.getLcso_organo() == 26 ? multipleSelect : multipleSelectDefault)%>
	              <%=lookup_lesione_fegato.getHtmlSelect("lesione_fegato_" + index, organo.getLcso_organo() == 4 ? multipleSelect : multipleSelectDefault)%>
	              <%=lookup_lesione_rene.getHtmlSelect("lesione_rene_" + index, organo.getLcso_organo() == 5 ? multipleSelect : multipleSelectDefault)%>
	              <%=lookup_lesione_mammella.getHtmlSelect("lesione_mammella_" + index, organo.getLcso_organo() == 6 ? multipleSelect : multipleSelectDefault)%>
	              <%=lookup_lesione_apparato_genitale.getHtmlSelect("lesione_apparato_genitale_" + index, organo.getLcso_organo() == 7 ? multipleSelect : multipleSelectDefault)%>
	              <%=lookup_lesione_stomaco.getHtmlSelect("lesione_stomaco_" + index, organo.getLcso_organo() == 8 ? multipleSelect : multipleSelectDefault)%>
	              <%=lookup_lesione_intestino.getHtmlSelect("lesione_intestino_" + index, organo.getLcso_organo() == 9 ? multipleSelect : multipleSelectDefault)%>
	              <%=lookup_lesione_osteomuscolari.getHtmlSelect("lesione_osteomuscolari_" + index, organo.getLcso_organo() == 10 ? multipleSelect : multipleSelectDefault)%>
	              
	              <%=lookup_lesione_generici.getHtmlSelect("lesione_generici_" + index, organo.getLcso_organo() >= 13 ? multipleSelect : multipleSelectDefault)%>
	              <%=lookup_lesione_altro.getHtmlSelect("lesione_altro_" + index, organo.getLcso_organo() == 11 || organo.getLcso_organo() == 12 ? multipleSelect : multipleSelectDefault)%>
	              <input style="display: <%= organo.getLcso_patologia() == 5 ? "" : "none" %>;" type="text" id="lcso_patologiaaltro_<%=index %>" name="lcso_patologiaaltro_<%=index %>" 
	              value="<%= organo.getLcso_patologia_altro() != null ? organo.getLcso_patologia_altro() : "" %>" />
	              
              </td>
            </tr>
           
           <script>
	    		vpm_seleziona_lookup_patologia_organo(<%=index%>,<%=organo.getLcso_organo()%>,<%=organo.getLcso_patologia()%>);
	   	   </script> 	
<!-- **************************************************** INSERIMENTO DI ALBERTO ***********************************************     -->
<%-- 	
	
            <tr id="patologie" class="containerBody">
              <td class="formLabel" >Lesione Anatomopatologica</td>
              <td>
	              <%=PatologieOrgani.getHtmlSelect("lcso_patologia_" + index, organo.getLcso_patologia())%>
	          </td>
            </tr>	

			<tr id="lesione_milza" class="containerBody">
              <td class="formLabel" >Lesione Anatomopatologica (milza)</td>
              <td>
	              <%=lookup_lesione_milza.getHtmlSelect("lesione_milza_" + index, organo.getLcso_patologia())%>
	          </td>
            </tr>


          
			<tr id="lesione_cuore" class="containerBody">
              <td class="formLabel" >Lesione Anatomopatologica (cuore)</td>
              <td>
	              <%=lookup_lesione_cuore.getHtmlSelect("lesione_cuore_" + index, organo.getLcso_patologia())%>
	          </td>
            </tr>
            			
            <tr id="lesione_polmoni" class="containerBody">
              <td class="formLabel" >Lesione Anatomopatologica (polmoni)</td>
              <td>
	              <%=lookup_lesione_polmoni.getHtmlSelect("lesione_polmoni_" + index, organo.getLcso_patologia())%>
	          </td>
            </tr>
            
			<tr id="lesione_fegato" class="containerBody">
              <td class="formLabel" >Lesione Anatomopatologica (fegato)</td>
              <td>
	              <%=lookup_lesione_fegato.getHtmlSelect("lesione_fegato_" + index, organo.getLcso_patologia())%>
	          </td>
            </tr>

            <tr id="lesione_rene" class="containerBody">
              <td class="formLabel" >Lesione Anatomopatologica (rene)</td>
              <td>
	              <%=lookup_lesione_rene.getHtmlSelect("lesione_rene_" + index, organo.getLcso_patologia())%>
	          </td>
            </tr>
            
			<tr id="lesione_mammella" class="containerBody">
              <td class="formLabel" >Lesione Anatomopatologica (mammella)</td>
              <td>
	              <%=lookup_lesione_mammella.getHtmlSelect("lesione_mammella_" + index, organo.getLcso_patologia())%>
	          </td>
            </tr>
            
            <tr id="lesione_apparato_genitale" class="containerBody">
              <td class="formLabel" >Lesione Anatomopatologica (genitale)</td>
              <td>
	              <%=lookup_lesione_apparato_genitale.getHtmlSelect("lesione_apparato_genitale_" + index, organo.getLcso_patologia())%>
	          </td>
            </tr>
            
			<tr id="lesione_stomaco" class="containerBody">
              <td class="formLabel" >Lesione Anatomopatologica (stomaco)</td>
              <td>
	              <%=lookup_lesione_stomaco.getHtmlSelect("lesione_stomaco_" + index, organo.getLcso_patologia())%>
	          </td>
            </tr>
            
            <tr id="lesione_intestino" class="containerBody">
              <td class="formLabel" >Lesione Anatomopatologica (intestino)</td>
              <td>
	              <%=lookup_lesione_intestino.getHtmlSelect("lesione_intestino_" + index, organo.getLcso_patologia())%>
	          </td>
            </tr>
            
			<tr id="lesione_osteomuscolari" class="containerBody">
              <td class="formLabel" >Lesione Anatomopatologica (osteomuscolari)</td>
              <td>
	              <%=lookup_lesione_osteomuscolari.getHtmlSelect("lesione_osteomuscolari_" + index, organo.getLcso_patologia())%>
	          </td>
            </tr>        
--%>
<!-- *********************************************** FINE INSERIMENTO DI ALBERTO ***********************************************     -->	


 <%-- ELIMINA stadio 	
        <tr 
            	id="stadio_<%=index %>" 
            	class="containerBody" 
            	style="<%=(organo.getLcso_patologia() == 6) ? ("") : ("display:none") %>" >
	          <td class="formLabel" >Stadio</td>
    	      <td>
    	      	<%=Stadi.getHtmlSelect("lcso_stadio_" + index, organo.getLcso_stadio())%>
    	      </td>
            </tr>
            --%>   
         
       <%
       		numero_organi++;
     	}
     	PatologieOrgani.setJsEvent("onChange=\"javascript:displayStadio(--placeholder--);\"");
       %>
            
     	   
            
     			<input type="hidden" id="elementi" name="elementi" value="<%=numero_organi %>">
   				<input type="hidden" id="size" name="size" value="<%=numero_organi %>">
   				
   			<tr id="nbsp" style = "visibility: collapse; background-color: #EDEDED" class="containerBody">
               <td  name="nbsptr1_" colspan="2">&nbsp;<input type="hidden" name="lcso_id_" value="-1" /></td>
            </tr>
   			<tr id="ww" style = "visibility: collapse" class="containerBody">
              <td class="formLabel" colspan="1">Organo</td>
              <td>
               <%--Organi.setJsEvent("onChange=alert(this.value"+ out.print(indice_globale)  + ")");--%>
              <%=Organi.getHtmlSelect( "lcso_organo_", "-1" )%>
              
              </td>
            </tr>    
   			
   			<tr id="row" style = "visibility: collapse" class="containerBody">
              <td class="formLabel" >Lesione Anatomopatologica</td>
              <td>
              <%
					lookup_lesione_milza.setSelectStyle("display:none");
              		lookup_lesione_milza.setMultiple(true);
        			lookup_lesione_milza.setSelectSize(5);
        			
             		lookup_lesione_cuore.setSelectStyle("display:none");
             		lookup_lesione_cuore.setMultiple(true);
             		lookup_lesione_cuore.setSelectSize(5);
        			
              		lookup_lesione_polmoni.setSelectStyle("display:none");
              		lookup_lesione_polmoni.setMultiple(true);
              		lookup_lesione_polmoni.setSelectSize(5);
              		

              		lookup_lesione_visceri.setSelectStyle("display:none");
              		lookup_lesione_visceri.setMultiple(true);
              		lookup_lesione_visceri.setSelectSize(5);
        			
              		lookup_lesione_fegato.setSelectStyle("display:none");
              		lookup_lesione_fegato.setMultiple(true);
              		lookup_lesione_fegato.setSelectSize(5);
        			
              		lookup_lesione_rene.setSelectStyle("display:none");
              		lookup_lesione_rene.setMultiple(true);
              		lookup_lesione_rene.setSelectSize(5);
        			
              		lookup_lesione_mammella.setSelectStyle("display:none");
              		lookup_lesione_mammella.setMultiple(true);
              		lookup_lesione_mammella.setSelectSize(5);
        			
              		lookup_lesione_apparato_genitale.setSelectStyle("display:none");
              		lookup_lesione_apparato_genitale.setMultiple(true);
              		lookup_lesione_apparato_genitale.setSelectSize(5);
        			
              		lookup_lesione_stomaco.setSelectStyle("display:none");
              		lookup_lesione_stomaco.setMultiple(true);
              		lookup_lesione_stomaco.setSelectSize(5);
        			
              		lookup_lesione_intestino.setSelectStyle("display:none");
              		lookup_lesione_intestino.setMultiple(true);
              		lookup_lesione_intestino.setSelectSize(5);
        			
              		lookup_lesione_osteomuscolari.setSelectStyle("display:none");
              		lookup_lesione_osteomuscolari.setMultiple(true);
              		lookup_lesione_osteomuscolari.setSelectSize(5);

              		lookup_lesione_generici.setSelectStyle("display:none");
              		lookup_lesione_generici.setMultiple(true);
              		lookup_lesione_generici.setSelectSize(5);
        			
              		lookup_lesione_altro.setSelectStyle("display:none");
              		lookup_lesione_altro.setMultiple(true);
              		lookup_lesione_altro.setSelectSize(5);
              		//lookup_lesione_altro.setJsEvent("onchange=\"javascript:mostraLcsoPatologiaAltro();\"");
              		
              %>
                  <%=lookup_lesione_milza.getHtmlSelect("lesione_milza_","-1")%>
	              <%=lookup_lesione_cuore.getHtmlSelect("lesione_cuore_" ,"-1")%>
	              <%=lookup_lesione_polmoni.getHtmlSelect("lesione_polmoni_" ,"-1")%>
	              <%=lookup_lesione_visceri.getHtmlSelect("lesione_visceri_" ,"-1")%>
	              <%=lookup_lesione_fegato.getHtmlSelect("lesione_fegato_","-1")%>
	              <%=lookup_lesione_rene.getHtmlSelect("lesione_rene_","-1")%>
	              <%=lookup_lesione_mammella.getHtmlSelect("lesione_mammella_","-1")%>
	              <%=lookup_lesione_apparato_genitale.getHtmlSelect("lesione_apparato_genitale_","-1")%>
	              <%=lookup_lesione_stomaco.getHtmlSelect("lesione_stomaco_","-1")%>
	              <%=lookup_lesione_intestino.getHtmlSelect("lesione_intestino_","-1")%>
	              <%=lookup_lesione_osteomuscolari.getHtmlSelect("lesione_osteomuscolari_","-1")%>
	              
	              <%=lookup_lesione_generici.getHtmlSelect("lesione_generici_","-1")%>
	              <%=lookup_lesione_altro.getHtmlSelect("lesione_altro_","-1")%>
	              <input style="display: none;" type="text" id="lcso_patologiaaltro_" name="lcso_patologiaaltro_" class="lcso_patologia_altro_class" value="" />
	             
	              
	              
              </td>
            </tr>

		<%-- 
			<tr id="tr" style = "visibility: collapse" class="containerBody" >
	          <td class="formLabel" colspan="1">Stadio</td>
    	      <td><%=Stadi.getHtmlSelect( "lcso_stadio_", "-1" )%></td>
            </tr>
        --%>         
                 
       
          	<tr style="display: none;" id="lcsobutton">
	    	  <input type="button" onClick="javascript:provaOrgani();" id="aggiungialtrobutton" value="Aggiungi Altro Organo" >
	      	</tr>
</table>
</td>
</tr>


<tr id="lcpr" style="display: none">
    	<td>
    		<table class="details" width="100%" border="0" cellpadding="4" cellspacing="0">
    		
            <tr>
              <th colspan="2"><strong>Libero Consumo Previo Risanamento</strong></th>
            </tr>
            
            <tr class="containerBody">
              <td class="formLabel" >Data prevista di liberalizzazione</td>
              <td>
              		<input readonly type="text" id="lcpr_data_prevista_liber" name="lcpr_data_prevista_liber" size="10" value="" />&nbsp;  
			        <a href="#" onClick="cal19.select(document.forms[0].lcpr_data_prevista_liber,'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19">
			 		<img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
			 		<a href="#" style="cursor: pointer;" onclick="svuotaData(document.forms[0].lcpr_data_prevista_liber);"><img src="images/delete.gif" align="absmiddle"/></a>
              </td>
            </tr>     
             
            <tr class="containerBody">
              <td class="formLabel" >Data effettiva di liberalizzazione</td>
              <td>
              	    <input readonly type="text" id="lcpr_data_effettiva_liber" name="lcpr_data_effettiva_liber" size="10" value="" />&nbsp;  
			        <a href="#" onClick="cal19.select(document.forms[0].lcpr_data_effettiva_liber,'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19">
			 		<img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
			 		<a href="#" style="cursor: pointer;" onclick="svuotaData(document.forms[0].lcpr_data_effettiva_liber);"><img src="images/delete.gif" align="absmiddle"/></a>
              		
              </td>
            </tr>
   </table>
   </td>
</tr>
</tbody>
</table>
</td>
</tr>
	
</tbody></table>	
</div>


<div id="tableID1_Div"></div>
<table id="tableID1" style="display:none;clear:left;">
<tr><td> <%@include file="include_campioni_add_seduta.jsp" %> </td></tr>
<tr><td> <jsp:include page="include_tamponi_add_seduta.jsp"/> </td></tr>
</table>

    		



	
<div id="tabs-4">	
<table width="100%" border="0" cellpadding="2" cellspacing="2">
    <tbody><tr>
        <td valign="top" width="55%"><table width="100%" border="0" cellpadding="2" cellspacing="2">
    <tbody><tr>

        <td valign="top" width="100%"><table class="details" width="100%" border="0" cellpadding="4" cellspacing="0">
          <tbody>
          
           <tr>
              <th colspan="2"><strong>Animale</strong></th>
            </tr>
            

            <tr>
                <td style="background-color:yellow;text-align: right" nowrap="nowrap">Partita</td>
                <td style="background-color:yellow;">
                	<%=toHtmlValue( Partita.getCd_partita() ) %>
                </td>
            </tr>
            
           
            <tr class="containerBody" >
                <td class="formLabel" nowrap="nowrap">Specie<br></td>
                <td>
<%
                	if(Partita.getCd_num_capi_ovini()>0)
                		out.println("<label class=\"specie1\">Ovini</label>");	
					if(Partita.getCd_num_capi_caprini()>0)
					{
						if(Partita.getCd_num_capi_ovini()>0)
							out.println(", ");
						out.println("<label class=\"specie2\">Caprini</label>");
					}
%>
				</td>
            </tr>
            
            <tr class="containerBody">
                <td class="formLabel" >Numero Capi <label class="specie1">Ovini</label><br/>Controllo documentale</td>
                <td>
                	<%=Partita.getCd_num_capi_ovini()%>
                </td>
            </tr>
            <tr class="containerBody">
                <td class="formLabel" >Numero Capi <label class="specie2">Caprini</label><br/>Controllo documentale</td>
                <td>
                	<%=Partita.getCd_num_capi_caprini()%>
                </td>
            </tr>
            
            <tr>
              <th colspan="2"><strong>Morte antecedente macellazione</strong></th>
            </tr>
            <tr class="containerBody">
              <td class="formLabel" >Data</td>
              <td>
<%--              	<zeroio:dateSelect field="mavam_data" showTimeZone="false" form="main" timestamp="<%=Partita.getMavam_data() %>" />   --%>
              		<input readonly type="text" id="mavam_data" name="mavam_data" onfocus="riportaDataArrivoMacello(this);gestisciObbligatorietaMorteAnteMacellazione();" size="10" value="" />&nbsp;  
			        <font color="red" id="dataMorteAnteMacellazione" style="display: none;">*</font>
			        <a href="#" onClick="cal19.select(document.forms[0].mavam_data,'anchor19','dd/MM/yyyy'); return false;" NAME="anchor19" ID="anchor19">
			 		<img src="images/icons/stock_form-date-field-16.gif" border="0" align="absmiddle"></a>
			 		<a href="#" style="cursor: pointer;" onclick="svuotaData(document.forms[0].mavam_data);"><img src="images/delete.gif" align="absmiddle"/></a>
              </td>
            	
            </tr>
            
             <tr class="containerBody">
                <td class="formLabel">Luogo di verifica</td>
                
                <td>
                	<%
                		LuoghiVerifica.setJsEvent("onChange=\"javascript:displayLuogoVerifica();gestisciObbligatorietaMorteAnteMacellazione();\"");
                	%>                               
                	<%=LuoghiVerifica.getHtmlSelect( "mavam_luogo", "" ) %>
                	
                	<input 
                		type="text" 
                		size="30" 
                		id="luogo" 
                	
                		name="mavam_descrizione_luogo_verifica" value=""/>
                	<font color="red" id="luogoMorteAnteMacellazione" style="display: none;">*</font>
                </td>
                                
            </tr>
            
            <tr class="containerBody">
            	<td class="formLabel">Numero Capi <label class="specie1">Ovini</label></td>
                <td>
<%
				num_capi_ovini = "";
// 				if(((Partita)Partita).getMavam_num_capi_ovini()>0)
// 					num_capi_ovini = ((Partita)Partita).getMavam_num_capi_ovini()+"";
%>
                	<input <% if(Partita.getCd_num_capi_ovini()<=0){out.println("disabled=\"disabled\"");} %> type="text" id="mavam_num_capi_ovini" name="mavam_num_capi_ovini" onchange="isIntPositivo(this.value,'Numero Capi Ovini',this);" value="<%=toHtmlValue(num_capi_ovini) %>" />
                	<font <% if(Partita.getCd_num_capi_ovini()<=0){out.println("display=\"style:none;\"");} %> id="mavam_num_capi_ovini_asterisco" align="center" style="display: none;" color="red" >*</font>
                </td>
            </tr>
            
            <tr class="containerBody">
            	<td class="formLabel">Numero Capi <label class="specie2">Caprini</label></td>
                <td>
<%
// 				if(((Partita)Partita).getMavam_num_capi_caprini()>0)
// 					num_capi_caprini = ((Partita)Partita).getMavam_num_capi_caprini()+"";
%>
                	<input <% if(Partita.getCd_num_capi_caprini()<=0){out.println("disabled=\"disabled\"");} %>  type="text" id="mavam_num_capi_caprini" name="mavam_num_capi_caprini" onchange="isIntPositivo(this.value,'Numero Capi Caprini',this);" value="<%=toHtmlValue(num_capi_caprini) %>" />
                	<font <% if(Partita.getCd_num_capi_caprini()<=0){out.println("display=\"style:none;\"");} %>  id="mavam_num_capi_caprini_asterisco" align="center" style="display: none;" color="red" >*</font>
                </td>
            </tr>
                 
            <tr class="containerBody">
                <td class="formLabel">Causa</td>
                <td>
                	<textarea rows="2" cols="40" id="mavam_motivo" name="mavam_motivo" onchange="gestisciObbligatorietaMorteAnteMacellazione();"></textarea>
                	<font color="red" id="causaMorteAnteMacellazione" style="display: none;">*</font>
                </td>
				
           </tr>
           
           <tr class="containerBody">
                <td class="formLabel">Impianto di termodistruzione</td>
                <td>
                	<textarea 
                		rows="2" 
                		cols="40" 
                		name="mavam_impianto_termodistruzione"
                		></textarea>
                </td>
           </tr>
           
             <tr class="containerBody">
                <td class="formLabel">Destinazione della carcassa</td>
                <td>
                	<textarea 
                		rows="2" 
                		cols="40" 
                		name="mvam_destinazione_carcassa"
                		></textarea>
                </td>
           </tr>
           
           
           <tr class="containerBody">
            	<td class="formLabel">Comunicazione a</td>
            	<td>
            		<input 
            			type="checkbox" 
            			id="mavam_to_asl_origine"
            			name="mavam_to_asl_origine" 
            			/> ASL origine <br/>
            		<input 
            			type="checkbox" 
            			id="mavam_to_proprietario_animale"
            			name="mavam_to_proprietario_animale" 
            			/> Proprietario animale <br/>
            		<input 
            			type="checkbox" 
            			id="mavam_to_azienda_origine"
            			name="mavam_to_azienda_origine" 
            			/> Azienda di origine <br/>
            		<input 
            			type="checkbox" 
            			id="mavam_to_proprietario_macello"
            			name="mavam_to_proprietario_macello" 
            			/> Proprietario macello <br/>
            		<input 
            			type="checkbox" 
            			id="mavam_to_pif"
            			name="mavam_to_pif" 
            			/> P.I.F. <br/>	
            		<input 
            			type="checkbox" 
            			id="mavam_to_uvac"
            			name="mavam_to_uvac" 
            			/> U.V.A.C. <br/>	
            		<input 
            			type="checkbox" 
            			id="mavam_to_regione"
            			name="mavam_to_regione" 
            			/> Regione <br/>
            		<input 
            			type="checkbox"
            			id="mavam_to_altro" 
            			name="mavam_to_altro" 
            			onclick="visualizzaTextareaMavamToAltro();"
            			/> Altro <br/>
            		<textarea id="mavam_to_altro_testo" name="mavam_to_altro_testo" rows="2" cols="40"></textarea>
            			
            	</td>
            </tr>
           
           <tr class="containerBody">
                <td class="formLabel">Note</td>
                <td>
                	<textarea rows="2" cols="40" id="mavam_note" name="mavam_note"></textarea>
                </td>
				
           </tr>
           
        </tbody>
     </table>
          
			  
			  </td>
        
        
    </tr></tbody></table>&nbsp;</td>


</tr></tbody></table>
	</div>
     
<div id="tabs-7">
		<!-- Commento update  -->
		
		
<table width="100%" border="0" cellpadding="2" cellspacing="2">
    <tbody>
    <tr>
        <td valign="top" width="100%">
        <table class="details" width="100%" border="0" cellpadding="4" cellspacing="0">
          <tbody>
            <tr>
              <th colspan="2"><strong>Animale</strong></th>
            </tr>
            

            <tr>
                <td style="background-color:yellow;text-align: right" nowrap="nowrap">Partita</td>
                <td style="background-color:yellow;">
                	<%=toHtmlValue( Partita.getCd_partita() ) %>
                </td>
            </tr>
            
           
            <tr class="containerBody" >
                <td class="formLabel" nowrap="nowrap">Specie<br></td>
                <td>
<%
                	if(Partita.getCd_num_capi_ovini()>0)
                		out.println("<label class=\"specie1\">Ovini</label>");	
					if(Partita.getCd_num_capi_caprini()>0)
					{
						if(Partita.getCd_num_capi_ovini()>0)
							out.println(", ");
						out.println("<label class=\"specie2\">Caprini</label>");
					}
%>
				</td>
            </tr>
            
            <tr class="containerBody">
                <td class="formLabel" >Numero Capi <label class="specie1">Ovini</label><br/>Controllo documentale</td>
                <td>
                	<%=Partita.getCd_num_capi_ovini()%>
                </td>
            </tr>
            <tr class="containerBody">
                <td class="formLabel" >Numero Capi <label class="specie2">Caprini</label><br/>Controllo documentale</td>
                <td>
                	<%=Partita.getCd_num_capi_caprini()%>
                </td>
            </tr>
            <tr class="containerBody">
                <td class="formLabel" >Numero Capi <label class="specie1">Ovini</label><br/>Morte Ant.Macellazione</td>
                <td>
                	<%=Partita.getMavam_num_capi_ovini()%>
                </td>
            </tr>
            <tr class="containerBody">
                <td class="formLabel" >Numero Capi <label class="specie2">Caprini</label><br/>Morte Ant.Macellazione</td>
                <td>
                	<%=Partita.getMavam_num_capi_caprini()%>
                </td>
            </tr>
            
             <tr>

              <th colspan="2">
              	<strong>Comunicazioni Esterne</strong>
              </th>
            </tr>
            
			<tr class="containerBody">
            	<td class="formLabel">Comunicazione a</td>
            	<td>
            		<% if (Partita.isCasl_to_asl_origine()) { %>
            			ASL origine <br/>
            		<% } %>
            		
            		<% if (Partita.isCasl_to_proprietario_animale()) { %>
            			Proprietario animale <br/>
            		<% } %>
            		
            		<% if (Partita.isCasl_to_azienda_origine()) { %>
	            		Azienda di origine <br/>
            		<% } %>
            			
            		<% if (Partita.isCasl_to_proprietario_macello()) { %>
            			Proprietario macello <br/>
            		<% } %>
            		
            		<% if (Partita.isCasl_to_pif()) { %>
            			P.I.F. <br/>
            		<% } %>
            		
            		<% if (Partita.isCasl_to_uvac()) { %>
            			U.V.A.C. <br/>
            		<% } %>
            		
            		<% if (Partita.isCasl_to_regione()) { %>
            			Regione <br/>
            		<% } %>
            		
            		<% if (Partita.isCasl_to_altro()) { %>
            			Altro <%= Partita.getCasl_to_altro_testo() != null && !Partita.getCasl_to_altro_testo().equals("")? ": " + Partita.getCasl_to_altro_testo() : "" %><br/>
            		<% } %>
            		&nbsp;
            	</td>
            </tr>
            
            <tr class="containerBody">
              <td class="formLabel" >Data</td>
              <td><zeroio:tz timestamp="<%=Partita.getCasl_data()%>" showTimeZone="false" dateOnly="true" />&nbsp; </td>
            </tr>
            
<%--        <tr class="containerBody">
                <td class="formLabel">Tipo di non conformit�</td>
                <td><%=MotiviASL.getSelectedValue( Partita.getCasl_motivo() ) %>&nbsp;</td>
    			
            </tr>
--%>
            
			<tr class="containerBody">
                <td class="formLabel">Tipo di non conformit�</td>
                <td>
                	<%for( Casl_Non_Conformita_Rilevata nc: (ArrayList<Casl_Non_Conformita_Rilevata>)casl_NCRilevate ){ %>
                		<%=MotiviASL.getSelectedValue( nc.getId_casl_non_conformita() ) %><br/>
                	<%} %>
                	<%=(casl_NCRilevate.size() > 0) ? ("") : ("&nbsp;") %>
                </td>
            </tr> 
            
            <tr class="containerBody">
            	<td class="formLabel">Numero Capi <label class="specie1">Ovini</label></td>
                <td>
<%
				num_capi_ovini = "";
				if(((Partita)Partita).getCasl_num_capi_ovini()>0)
					num_capi_ovini = ((Partita)Partita).getCasl_num_capi_ovini()+"";
				out.println(num_capi_ovini);
%>
                </td>
            </tr>
            
            <tr class="containerBody">
            	<td class="formLabel">Numero Capi <label class="specie2">Caprini</label></td>
                <td>
<%
				num_capi_caprini = "";
				if(((Partita)Partita).getCasl_num_capi_caprini()>0)
					num_capi_caprini = ((Partita)Partita).getCasl_num_capi_caprini()+"";
				out.println(num_capi_caprini);
%>
                </td>
            </tr>
            
                
            <tr class="containerBody">
                <td class="formLabel">Descrizione non Conformit�</td>
                <td><%=Partita.getCasl_info_richiesta() %>&nbsp;</td>
            </tr>
            
            <tr class="containerBody">
                <td class="formLabel">Provvedimenti Adottati</td>
                <td>
                	<%for( ProvvedimentiCASL pr: (ArrayList<ProvvedimentiCASL>)casl_Provvedimenti_effettuati ){ %>
                		<%=look_ProvvedimentiCASL.getSelectedValue( pr.getId_provvedimento()) %><br/>
                	<%} %>
                	<%=(casl_Provvedimenti_effettuati.size() > 0) ? ("") : ("&nbsp;") %>
                </td>
            </tr> 
            
			<tr class="containerBody">
                <td class="formLabel">Note</td>
                <td><%=Partita.getCasl_note_prevvedimento() %>&nbsp;</td>
            </tr>
            
          </tbody>
        </table>

			  </td>
        
        

        <td valign="top" width="50%"><!-- FILTRI DI RICERCA --></td>
    </tr></tbody></table>


		<table width="100%" border="0" cellpadding="2" cellspacing="2">
    <tbody><tr>
        <td valign="top" width="100%"><table class="details" width="100%" border="0" cellpadding="4" cellspacing="0">
          <tbody>
            <tr>
              <th colspan="2"><strong>Ricezione Comunicazioni Esterne</strong></th>
            </tr>

             <tr class="containerBody">
                <td class="formLabel">Data</td>
                <td><zeroio:tz timestamp="<%=Partita.getRca_data()%>" showTimeZone="false" dateOnly="true" />&nbsp; </td>
             </tr>
             
             <tr class="containerBody">
                <td class="formLabel">Note</td>
                <td><%=Partita.getRca_note() %>&nbsp; </td>
             </tr>
                 
          </tbody>
        </table>
        
        <table class="details" width="100%" border="0" cellpadding="4" cellspacing="0">
          <tbody>
            <tr>
              <th colspan="2">
              	<strong>Blocco Animale</strong>
              </th>
            </tr>
            
            <tr class="containerBody">
              <td class="formLabel" >Data</td>
              <td><dhv:tz dateOnly="true" timestamp="<%=Partita.getSeqa_data() %>"/>&nbsp; </td>
            </tr>
            
            <tr class="containerBody">
              <td class="formLabel" >Sbloccato il</td>
              <td><dhv:tz dateOnly="true" timestamp="<%=Partita.getSeqa_data_sblocco() %>"/>&nbsp; </td>
            </tr>
            
             <tr class="containerBody">
                <td class="formLabel">Destinazione allo sblocco</td>
                                
                <td><%=ProvvedimentiVAM.getSelectedValue( Partita.getSeqa_destinazione_allo_sblocco() ) %> &nbsp;</td>
    			
            </tr>
          </tbody>
        </table>
        
         </td>
        
        

        <td valign="top" width="50%"><!-- FILTRI DI RICERCA --></td>
    </tr></tbody></table>
	        </div>


<%--
<div id="tabs-9">

<table width="100%" border="0" cellpadding="2" cellspacing="2">
    <tbody><tr>
        <td valign="top" width="55%">
		<table width="100%" border="0" cellpadding="2" cellspacing="2">
    <tbody><tr>

        <td valign="top" width="100%"><table class="details" width="100%" border="0" cellpadding="4" cellspacing="0">
          <tbody>
            <tr>
              <th colspan="2"><strong>Abbattimento</strong></th>
            </tr>
            <tr class="containerBody">
              <td class="formLabel" >Data</td>
              <td>
              	<zeroio:dateSelect field="abb_data" form="main" showTimeZone="false"/>
              	<%--zeroio:timeSelect baseName="abb_data" value="<%= new Timestamp(Calendar.getInstance().getTimeInMillis()) %>" />
             </td>

            </tr>
     
                <tr class="containerBody">
                <td class="formLabel">Motivo</td>
                <td>
                	<textarea rows="2" cols="40" name="abb_motivo"></textarea>
                </td>
                </tr>
                
<!--               <tr class="containerBody">-->
<!--               <td class="formLabel">Distruzione Carcassa</td>-->
<!--               <td>-->
<!--               		<input type="checkbox" name="abb_dist_carcassa" />-->
<!--               </td>-->
<!--            </tr>-->

             <tr>
                <th colspan="2"><strong>Veterinari addetti al controllo</strong></th>
            </tr>
            
            <tr class="containerBody">
            	<td colspan="2">
		            <table>
		            	<tr class="containerBody">
		                	<td>1. <input onchange="javascript:toggleVetDiv('abb_veterinario')" size="25" id="abb_veterinario" name="abb_veterinario" type="text" /><%Veterinari.setJsEvent( "onchange=\"set_vet( this, 'abb_veterinario')\"" ); %> <%=Veterinari.getHtmlSelect("veterinari_abb", "-1") %></td>
		                </tr>
			            <tr class="containerBody" id="abb_veterinario_toggle" style="display: none" >
			                <td>2. <input onchange="javascript:toggleVetDiv('abb_veterinario_2')" size="25" id="abb_veterinario_2" name="abb_veterinario_2" type="text" /><%Veterinari.setJsEvent( "onchange=\"set_vet( this, 'abb_veterinario_2')\"" ); %> <%=Veterinari.getHtmlSelect("veterinari_abb2", "-1") %></td>
			            </tr>
			            <tr class="containerBody" id="abb_veterinario_2_toggle" style="display: none" >
			                <td>3. <input size="25" id="abb_veterinario_3"  name="abb_veterinario_3" type="text" /><%Veterinari.setJsEvent( "onchange=\"set_vet( this, 'abb_veterinario_3')\"" ); %> <%=Veterinari.getHtmlSelect("veterinari_abb3", "-1") %></td>
			            </tr>
		            </table>
	            </td>
            </tr>

          </tbody>
        </table>

			  </td>

        
        

        <td valign="top" width="50%"><!-- FILTRI DI RICERCA --></td>
    </tr></tbody></table>
		
</td>

</tr></tbody></table>
	</div --%>

<% if (false) { %>
<div id="tabs-14">

<table width="100%" border="0" cellpadding="2" cellspacing="2">
    <tbody><tr>
        <td valign="top" width="55%">
	<table width="100%" border="0" cellpadding="2" cellspacing="2">
    <tbody>
    <tr>
        <td valign="top" width="100%">
        
        <table class="details" width="100%" border="0" cellpadding="4" cellspacing="0">
          <tbody>
            <tr>

              <th colspan="2"><strong>Test TSE</strong></th>
            </tr>

             <tr class="containerBody">
                <td class="formLabel">Data Prelievo</td>
                <td>
                	<zeroio:dateSelect 
                		field="bse_data_prelievo" 
                		form="main" 
                		showTimeZone="false" 
                		timestamp="<%=Partita.getBse_data_prelievo() %>" />
                </td>
            </tr>
                
             <tr class="containerBody">
                <td class="formLabel">Data Ricezione Esito</td>
                <td>
                	<zeroio:dateSelect 
                		field="bse_data_ricezione_esito" 
                		form="main" 
                		showTimeZone="false" 
                		timestamp="<%=Partita.getBse_data_ricezione_esito() %>" />
                </td>
            </tr>
            
            <tr class="containerBody">
                <td class="formLabel">Esito</td>
                <td>
                	<select name="bse_esito" id="bse_esito" >
                		<option 
                			value="" 
                			<%=( toHtmlValue( Partita.getBse_esito() ).length() > 0 ) ? ("") : ("selected=\"selected\"") %> 
                			>-- Seleziona --</option>
                		<option 
                			value="POSITIVO" 
                			<%=( "POSITIVO".equals( toHtmlValue( Partita.getBse_esito() ) ) ) ? ("selected=\"selected\"") : ("") %> 
                			>POSITIVO</option>
                		<option 
                			value="NEGATIVO" 
                			<%=( "NEGATIVO".equals( toHtmlValue( Partita.getBse_esito() ) ) ) ? ("selected=\"selected\"") : ("") %> 
                			 >NEGATIVO</option>
                	</select>
                </td>
             </tr>
             
			<tr class="containerBody">
                <td class="formLabel">Note</td>
                <td><textarea rows="2" cols="40" name="bse_note"><%=toHtmlValue( Partita.getBse_note() ) %></textarea></td>
            </tr>

          </tbody>
        </table>
         
	</td>

	<td valign="top" width="50%"><!-- FILTRI DI RICERCA --></td>

</tr></tbody></table>
	</div>
<% } %>

	

</div>
<input type="submit" value="Completa Macellazione">
</div>



<!-- End demo -->
</form>

</dhv:container>

<% 
	if (db != null) 
	  sqlDriver.free(db);
	db = null;
%>  

</body>


<script type="text/javascript">
function gestioneObbligNumCapiDestCarni(indice,tipoSelezione)
{
	if(tipoSelezione>2 || tipoSelezione==0)
	{
		if(document.getElementById( 'cd_num_capi_ovini').value!="" && document.getElementById( 'cd_num_capi_ovini').value!="0")
		{
			document.getElementById( 'num_capi_ovini_' + indice ).disabled="";
			if(document.getElementById( 'num_capi_ovini_asterisco_' + indice )!=null)
				document.getElementById( 'num_capi_ovini_asterisco_' + indice ).style.display = "block";
		}
		if(document.getElementById( 'cd_num_capi_caprini').value!="" && document.getElementById( 'cd_num_capi_caprini').value!="0")
		{
			document.getElementById( 'num_capi_caprini_' + indice ).disabled="";
			if(document.getElementById( 'num_capi_caprini_asterisco_' + indice )!=null)
				document.getElementById( 'num_capi_caprini_asterisco_' + indice ).style.display = "block";
		}
		if(destinatariSelezionati.indexOf(indice)==-1)
			destinatariSelezionati[destinatariSelezionati.length]=indice;
	}
	else
	{
		var displayOvini = null;
		var displayCaprini = null;
		if(document.getElementById( 'num_capi_ovini_asterisco_' + indice )!=null)
			displayOvini = document.getElementById( 'num_capi_ovini_asterisco_' + indice ).style.display;
		if(document.getElementById( 'num_capi_caprini_asterisco_' + indice )!=null)
			displayCaprini = document.getElementById( 'num_capi_caprini_asterisco_' + indice ).style.display;
		
		if(document.getElementById( 'num_capi_ovini_asterisco_' + indice )!=null)
		{
			if(displayOvini=="block" || displayOvini=="")
		    {
		    	document.getElementById( 'num_capi_ovini_asterisco_' + indice ).style.display = "none";
		    	document.getElementById( 'num_capi_ovini_' + indice ).disabled="disabled";
		    	document.getElementById( 'num_capi_ovini_' + indice ).value="";
		    	var index = destinatariSelezionati.indexOf(indice);
		    	if (index > -1) 
		    	{
		    		destinatariSelezionati.splice(index, 1);
		    	}
		    }
		}
		if(document.getElementById( 'num_capi_caprini_asterisco_' + indice )!=null)
		{
			if(displayCaprini=="block" || displayCaprini=="")
		    {
		    	document.getElementById( 'num_capi_caprini_asterisco_' + indice ).style.display = "none";
		    	document.getElementById( 'num_capi_caprini_' + indice ).disabled="disabled";
		    	document.getElementById( 'num_capi_caprini_' + indice ).value="";
		    	var index = destinatariSelezionati.indexOf(indice);
		    	if (index > -1) 
		    	{
		    		destinatariSelezionati.splice(index, 1);
		    	}
		    }
		}
	}
}

function gestioneObbligNumCapiDestCarniPostSelezione( indiceDestinatario, altId, ragioneSociale, tipo, hasNumCapi)
{
	var destinatariSelezionatiIncrementato=false;
	if(hasNumCapi)
	{
		var displayOvini = null;
		var displayCaprini = null;
		if(document.getElementById( 'num_capi_ovini_asterisco_' + indiceDestinatario )!=null)
		{
			displayOvini = document.getElementById( 'num_capi_ovini_asterisco_' + indiceDestinatario ).style.display;
			if(displayOvini=="block" || displayOvini=="")
		    {
		    	document.getElementById( 'num_capi_ovini_asterisco_' + indiceDestinatario ).style.display = "disabled";
		    	var index = destinatariSelezionati.indexOf(indiceDestinatario);
		    	if (index > -1) 
		    	{
		    		destinatariSelezionati.splice(index, 1);
		    	}
		    }
		    else
		    {
		    	if(document.getElementById('cd_num_capi_ovini').value!="" && document.getElementById('cd_num_capi_ovini').value!="0")
		    	{
		    		document.getElementById( 'num_capi_ovini_asterisco_' + indiceDestinatario ).style.display = "";
		    	}
		    	if(destinatariSelezionati.indexOf(indiceDestinatario)==-1)
					destinatariSelezionati[destinatariSelezionati.length]=indiceDestinatario;
	    		destinatariSelezionatiIncrementato=true;
		    		
		    }
		}
		if(document.getElementById( 'num_capi_caprini_asterisco_' + indiceDestinatario )!=null)
		{
			displayCaprini = document.getElementById( 'num_capi_caprini_asterisco_' + indiceDestinatario ).style.display;
			if(displayCaprini=="block" || displayCaprini=="")
		    {
		    	document.getElementById( 'num_capi_caprini_asterisco_' + indiceDestinatario ).style.display = "disabled";
		    	var index = destinatariSelezionati.indexOf(indiceDestinatario);
		    	if (index > -1) 
		    	{
		    		destinatariSelezionati.splice(index, 1);
		    	}
		    }
		    else
		    {
		    	if(document.getElementById('cd_num_capi_caprini').value!="" && document.getElementById('cd_num_capi_caprini').value!="0")
		    		document.getElementById( 'num_capi_caprini_asterisco_' + indiceDestinatario ).style.display = "";
		    	if(!destinatariSelezionatiIncrementato && destinatariSelezionati.indexOf(indiceDestinatario)==-1)
		    		destinatariSelezionati[destinatariSelezionati.length]=indiceDestinatario;
		    }
		}
    
    
	}
	if(ragioneSociale!="")
	{
  		if(document.getElementById('cd_num_capi_ovini').value!="" && document.getElementById('cd_num_capi_ovini').value!="0")
  			document.getElementById( 'num_capi_ovini_' + indiceDestinatario ).disabled = "";
  		if(document.getElementById('cd_num_capi_caprini').value!="" && document.getElementById('cd_num_capi_caprini').value!="0")
  			document.getElementById( 'num_capi_caprini_' + indiceDestinatario  ).disabled = "";
	}
	else
	{
		if(document.getElementById('cd_num_capi_ovini').value!="" && document.getElementById('cd_num_capi_ovini').value!="0")
		{
  			document.getElementById( 'num_capi_ovini_' + indiceDestinatario ).disabled = "none";
  			document.getElementById( 'num_capi_ovini_' + indiceDestinatario  ).value = "";
		}
  			if(document.getElementById('cd_num_capi_caprini').value!="" && document.getElementById('cd_num_capi_caprini').value!="0")
  		{
  			document.getElementById( 'num_capi_caprini_' + indiceDestinatario  ).disabled = "none";
  			document.getElementById( 'num_capi_caprini_' + indiceDestinatario  ).value = "";
  		}
	}
}

function gestioneAddDest()
{
	if(righeDest==10)
	{
		alert("Hai raggiunto il limite di destinatari selezionabili.");
		return false;
	}
	else
	{
		righeDest++;
		var i=1;
		while(i<=12)
		{
			document.getElementById('rigaDestTd'+i+righeDest).style.display="";
			i++;
		}
		document.getElementById('rigaDestTr'+righeDest).style.display="";
		
	}
}

for(var i=3;i<=righeMax;i++)
{
	gestioneAddDest();
}

</script>

<% if (Partita.isSpecie_suina()) { %>
<script>gestisciLabelPartite('2')</script>
<%}%>
