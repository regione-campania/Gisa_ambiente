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
		
		<p id="p3_my"> <%= "CF :"+ toHtml(User.getUserRecord().getSuap().getCodiceFiscaleRichiedente().toUpperCase()) %> 
			<br><br>							
			
			
			<br>						
				<br>
			<br>			
		</p>


	<ul id="qm0" class="qmmc">

	
   </ul>
   
   <p id="p3_my"> <br/>Help Desk:<br/>0817865132 / 0817865279<br/> <br/> 
   </p>
   
</div>
<img id="finemenu" src="css/suap/images/finemenu.jpg"/>	

</div>
	
				
			
			
			
			
	
			