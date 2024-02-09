<style>
.selected{
background-color: #4e5873;
}
</style>
<jsp:useBean id="User" class="org.aspcfs.modules.login.beans.UserBean" scope="session"/>
<%@ include file="../initPage.jsp" %>
<%

%>

<div id="sidebar-left">

	<div class="mymoduletable">		
		
		<p id="p3_my"> <%= "STABILIMENTO NUM. "+ toHtml(User.getContact().getNumRegistrazioneStabilimentoAssociato().toUpperCase()) %> 
			<br><br>							
			
			
			<br>						
				<br>
			<br>			
		</p>


	<ul id="qm0" class="qmmc">
	<li>
		<a onclick="loadModalWindow();" href="OpuStab.do?command=MyHomePage" accesskey="2"><span>Home</span></a>
	</li>
	
<li>
		<a onclick="loadModalWindow()" href="Login.do?command=Logout" accesskey="2"><span>Logout</span></a>
	</li>
	
	<li>
		<a href="guida2016/guidaTrasportatore.jsp" style="color:black">Manuale utente</a>
	</li>
	
   </ul>
   
   <p id="p3_my"> <br/>Help Desk:<br/>0817865132 / 0817865279<br/> <br/> 
   </p>
   
</div>
<img id="finemenu" src="css/suap/images/finemenu.jpg"/>	

</div>
	
				
			
			
			
			
	
			