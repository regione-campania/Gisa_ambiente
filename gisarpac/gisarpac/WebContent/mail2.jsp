<script>
function check()
{
	alert('wewe');
	return false;
	}
</script>

 <form action="demo_form.asp" onsubmit="return check()">
Username: <input type="text" name="usrname" required>
<input type="submit">
</form> 