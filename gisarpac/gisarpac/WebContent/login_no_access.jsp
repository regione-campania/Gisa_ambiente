<%@page import="java.util.*" %>
<%

String[] arrImg = {"https://media.giphy.com/media/3oKIPznTgmcQGOlqyA/giphy.gif", 
		"https://media.giphy.com/media/PkMD5TyDdhCcjh6aO0/giphy.gif", 
		"https://media.giphy.com/media/ftqLysT45BJMagKFuk/giphy.gif", 
		"https://media.giphy.com/media/15aGGXfSlat2dP6ohs/giphy.gif",  
		"https://media.giphy.com/media/3bzQblfghToKsI2JLn/giphy.gif",
		"https://media.giphy.com/media/1woSyfTIPuLBdOXTCy/giphy.gif",
		"https://media.giphy.com/media/2ZWuCpxNtdd2BAfiLo/giphy.gif",
		"https://media.giphy.com/media/PZuPesDHiNBuM/giphy.gif",
		"https://media.giphy.com/media/r0g5Yfk3eRgqs/giphy.gif"};
Random rand = new Random();
int n = (int)(java.lang.Math.random() * (arrImg.length));	
%>

<center>

<% if (1==2){ %>

<font size="20px">
NUN S TRAS
</font>

<br/><br/>

<img src="<%=arrImg[n]%>"/>

<br/><br/>

<font size="20px" color="red">
THOU SHALT NOT ENTER
</font>

<% } else { %>
<font size="20px" color="red">
ACCESSO NON CONSENTITO.
</font>

<br/><br/>

<img src="images/alert.gif" width="50px"/>

<br/><br/>

<% } %>

<br/>

<a href="Login.do?command=Logout">RIPROVA</a>

</center>

