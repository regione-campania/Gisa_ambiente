<style>

body {
 color: #000; font-family: 'Helvetica', serif; font-size: 45px; font-weight: bold; line-height: 48px; margin: 0; }
input{
  font-size: 20px; font-weight: bold; letter-spacing: -1px; line-height: 1; text-align: center; } 

</style> 

<br/><br/><br/>

<center>
<form name="addAccount"	action="Login.do?command=LoginDistributori&auto-populate=true" method="post" onSubmit="	if (this.cf.value.trim().length!=16) { alert('Inserire un codice fiscale di 16 cifre!'); return false;}">
<table style="border: 1px solid black">
<tr><td rowspan="3"><img src="images/concourseSuiteCommunitySplashOLD.png"/></td> <td><b>Accesso semplificato per utenti Distributori</b></td></tr>
<tr><td><center><input type="text" id="cf" name="cf" size="30" maxlength="16" placeholder="Codice fiscale"/></center></td></tr>
<tr><td><center><input type="submit" value="LOGIN"/></center></td></tr> 
</table>
</form>
</center>   