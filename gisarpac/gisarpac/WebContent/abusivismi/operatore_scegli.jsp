<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv" %>
<%@ page import="java.util.*,org.aspcfs.modules.accounts.base.*" %>
<%@ include file="../initPage.jsp" %>
<form name="addticket" action="Abusivismi.do?command=Insert&auto-populate=true" method="post">
<%-- Trails --%>
<table class="trails" cellspacing="0">
<tr>
<td>
<dhv:label name="">Seleziona Operatore</dhv:label>
</td>
</tr>
</table>
<%-- End Trails --%>

<style type="text/css">
#dhtmltooltip{
position: absolute;
left: -300px;
width: 150px;
border: 1px solid black;
padding: 2px;
background-color: lightyellow;
visibility: hidden;
z-index: 100;
/*Remove below line to remove shadow. Below line should always appear last within this CSS*/
filter: progid:DXImageTransform.Microsoft.Shadow(color=gray,direction=135);
}
#dhtmlpointer{
position:absolute;
left: -300px;
z-index: 101;
visibility: hidden;
}
</style>

<script type="text/javascript">
var offsetfromcursorX=12 
var offsetfromcursorY=10 
var offsetdivfrompointerX=10 
var offsetdivfrompointerY=14 
document.write('<div id="dhtmltooltip"></div>') //write out tooltip DIV
document.write('<img id="dhtmlpointer" src="images/arrow2.gif">') //write out pointer image
var ie=document.all
var ns6=document.getElementById && !document.all
var enabletip=false
if (ie||ns6)
var tipobj=document.all? document.all["dhtmltooltip"] : document.getElementById? document.getElementById("dhtmltooltip") : ""
var pointerobj=document.all? document.all["dhtmlpointer"] : document.getElementById? document.getElementById("dhtmlpointer") : ""
function ietruebody(){
return (document.compatMode && document.compatMode!="BackCompat")? document.documentElement : document.body
}
function ddrivetip(thetext, thewidth, thecolor){
if (ns6||ie){
if (typeof thewidth!="undefined") tipobj.style.width=thewidth+"px"
if (typeof thecolor!="undefined" && thecolor!="") tipobj.style.backgroundColor=thecolor
tipobj.innerHTML=thetext
enabletip=true
return false
}
}
function positiontip(e){
if (enabletip){
var nondefaultpos=false
var curX=(ns6)?e.pageX : event.clientX+ietruebody().scrollLeft;
var curY=(ns6)?e.pageY : event.clientY+ietruebody().scrollTop;

var winwidth=ie&&!window.opera? ietruebody().clientWidth : window.innerWidth-20
var winheight=ie&&!window.opera? ietruebody().clientHeight : window.innerHeight-20
var rightedge=ie&&!window.opera? winwidth-event.clientX-offsetfromcursorX : winwidth-e.clientX-offsetfromcursorX
var bottomedge=ie&&!window.opera? winheight-event.clientY-offsetfromcursorY : winheight-e.clientY-offsetfromcursorY
var leftedge=(offsetfromcursorX<0)? offsetfromcursorX*(-1) : -1000

if (rightedge<tipobj.offsetWidth){

tipobj.style.left=curX-tipobj.offsetWidth+"px"
nondefaultpos=true
}
else if (curX<leftedge)
tipobj.style.left="5px"
else{

tipobj.style.left=curX+offsetfromcursorX-offsetdivfrompointerX+"px"
pointerobj.style.left=curX+offsetfromcursorX+"px"
}

if (bottomedge<tipobj.offsetHeight){
tipobj.style.top=curY-tipobj.offsetHeight-offsetfromcursorY+"px"
nondefaultpos=true
}
else{
tipobj.style.top=curY+offsetfromcursorY+offsetdivfrompointerY+"px"
pointerobj.style.top=curY+offsetfromcursorY+"px"
}
tipobj.style.visibility="visible"
if (!nondefaultpos)
pointerobj.style.visibility="visible"
else
pointerobj.style.visibility="hidden"
}
}
function hideddrivetip(){
if (ns6||ie){
enabletip=false
tipobj.style.visibility="hidden"
pointerobj.style.visibility="hidden"
tipobj.style.left="-1000px"
tipobj.style.backgroundColor=''
tipobj.style.width=''
}
}
function inCostruzione(){
	alert('In Costruzione!');
	return false;
}
document.onmousemove=positiontip
</script>


<table cellpadding="4" cellspacing="0" width="100%" class="empty">
	
	<tr> 
   		 <td>
      	<!-- 	<input
      			type="submit"
      			onmouseover="ddrivetip('<dhv:label name="">Distributori Automatici in Campania</dhv:label>')"
      			onmouseout="hideddrivetip()"
      			name="<dhv:label name="distrib">Distributori Automatici</dhv:label>"
      			value="<dhv:label name="distrib">Distributori Automatici</dhv:label>"
      			onclick="javascript:this.form.action='Distributori.do?command=ScegliD'"
      		/>
      		-->
      		<input
      			type="submit"
      			onmouseover="ddrivetip('<dhv:label name="abusivi">Operatori Abusivi</dhv:label>')"
      			onmouseout="hideddrivetip()"
      			name="<dhv:label name="abusivi">Operatori Abusivi</dhv:label>"
      			value="<dhv:label name="abusivi">Operatori Abusivi</dhv:label>"
      			onclick="javascript:this.form.action='Abusivismi.do?command=Dashboard'"
      		/>
      		
      		<input
      			type="submit"
      			onmouseover="ddrivetip('<dhv:label name="">Privati</dhv:label>')"
      			onmouseout="hideddrivetip()"
      			name="<dhv:label name="">Privati</dhv:label>"
      			value="<dhv:label name="">Privati</dhv:label>"
      			onclick="javascript:this.form.action='Operatoriprivati.do?command=Add'"
      		/>
      		
      		<input
      			type="submit"
      			onmouseover="ddrivetip('<dhv:label name="">Attivit� Mobili Fuori Ambito ASL</dhv:label>')"
      			onmouseout="hideddrivetip()"
      			name="Operatori Fuori Regione"
      			value="Att. Fuori Ambito ASL"
      			onclick="javascript:this.form.action='OperatoriFuoriRegione.do?command=SearchForm'"
      		/>
      		
      		<%--<input
      			type="submit"
      			onmouseover="ddrivetip('<dhv:label name="">Esercenti fuori regione (destinatari delle carni macellate)</dhv:label>')"
      			onmouseout="hideddrivetip()"
      			name="Esercenti fuori regione "
      			value="Esercenti fuori regione "
      			onclick="javascript:this.form.action='EsercentiFuoriRegione.do?command=Dashboard'"
      		/>--%>
      		
      		
      			<input
      			type="submit"
      			onmouseover="ddrivetip('Altri Operatori Non Presenti altrove')"
      			onmouseout="hideddrivetip()"
      			name="Altri Operatori Non Presenti altrove"
      			value="Altri Operatori Non Presenti altrove"
      			onclick="javascript:this.form.action='OpnonAltrove.do?command=Dashboard'" />
      		
      		<!-- Aggiunta di Imbarcazioni -->
<!--       		<input -->
<!--       			type="submit" -->
<!--       			onmouseover="ddrivetip('Imbarcazioni')" -->
<!--       			onmouseout="hideddrivetip()" -->
<!--       			name="Imbarcazioni" -->
<!--       			value="Imbarcazioni" -->
<!--       			onclick="javascript:this.form.action='Imbarcazioni.do?command=Dashboard'" /> -->
      		
    	</td>
	</tr>
	
</table>

<br>
<dhv:formMessage />
</form>
